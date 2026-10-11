"""TurnSource: loading, identity checks, readiness, refusals, bookkeeping.

No Harbor and no model: the container is a fake whose ``exec`` understands the
three commands TurnSource issues (``pwd``, ``cat``, ``rm -rf`` / ``test -e``).
"""

from __future__ import annotations

import asyncio
import json
import shlex
import shutil
from dataclasses import dataclass, field
from pathlib import Path

import pytest

from conftest import make_instance
from contextbench import ADVANCE_MARKER, SUBMIT_MARKER, load_instance
from contextbench.harbor import turn_source as turn_source_mod
from contextbench.harbor import (
    ENV_STREAM_COUNT,
    ENV_STREAM_PATH,
    ENV_STREAM_SHA256,
    STREAM_RECORD_NAME,
    StreamIdentityError,
    TurnSource,
    canonical_sha256,
)
from contextbench.stream import (
    EXPLAIN_NON_STANDALONE_TEXT,
    REFUSE_SUBMIT_TEXT,
    render_op,
)


@dataclass
class _Res:
    stdout: str = ""
    stderr: str = ""
    return_code: int = 0


@dataclass
class _EnvCfg:
    env: dict = field(default_factory=dict)
    workdir: str | None = None


class FakeEnvironment:
    """Maps container paths under ``root``; records every command."""

    def __init__(self, root: Path, env: dict | None = None, workdir: str | None = None):
        self.root = root
        self.task_env_config = _EnvCfg(env or {}, workdir)
        self.commands: list[str] = []

    def _host(self, path: str) -> Path:
        return self.root / path.lstrip("/")

    async def exec(self, command: str, timeout_sec: int | None = None, **_) -> _Res:
        self.commands.append(command)
        argv = shlex.split(command)
        if argv == ["pwd"]:
            return _Res("/app\n")
        if argv[0] == "cat":
            p = self._host(argv[1])
            return _Res(p.read_text()) if p.exists() else _Res("", "no such file", 1)
        if argv[:2] == ["rm", "-rf"]:
            shutil.rmtree(self._host(argv[2]), ignore_errors=True)
            return _Res()
        if argv[:2] == ["test", "-e"]:
            return _Res(return_code=0 if self._host(argv[2]).exists() else 1)
        raise AssertionError(f"unexpected command {command!r}")


def _container(tmp_path: Path, instance: Path, **env_overrides) -> FakeEnvironment:
    root = tmp_path / "container"
    stream_dir = root / "app" / "stream"
    stream_dir.mkdir(parents=True)
    shutil.copyfile(instance / "chunks.jsonl", stream_dir / "chunks.jsonl")
    records = [json.loads(ln) for ln in (instance / "chunks.jsonl").read_text().splitlines()
               if ln.strip()]
    env = {ENV_STREAM_COUNT: str(len(records)),
           ENV_STREAM_SHA256: canonical_sha256(records)}
    env.update(env_overrides)
    return FakeEnvironment(root, env={k: v for k, v in env.items() if v is not None})


@pytest.fixture
def kv(tmp_path: Path) -> Path:
    return make_instance(tmp_path / "kv", "kv_store")


def _load(env: FakeEnvironment, logs: Path | None = None, **kw) -> TurnSource:
    return asyncio.run(TurnSource.load(env, logs_dir=logs, **kw))


@pytest.fixture(autouse=True)
def _no_backoff(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setattr(turn_source_mod, "READ_BACKOFF_SEC", 0.0)


class TruncatingEnvironment(FakeEnvironment):
    """The first ``n_bad`` reads of the stream return a truncated stdout."""

    def __init__(self, *a, n_bad: int = 1, **kw):
        super().__init__(*a, **kw)
        self.n_bad = n_bad

    async def exec(self, command: str, timeout_sec: int | None = None, **_) -> _Res:
        res = await super().exec(command, timeout_sec)
        if shlex.split(command)[0] == "cat" and self.n_bad > 0:
            self.n_bad -= 1
            return _Res(res.stdout[: len(res.stdout) // 2])
        return res


def _truncating(tmp_path: Path, kv: Path, n_bad: int) -> TruncatingEnvironment:
    env = _container(tmp_path, kv)
    bad = TruncatingEnvironment(env.root, n_bad=n_bad)
    bad.task_env_config = env.task_env_config
    return bad


# ------------------------------------------------------------------------ loading
def test_truncated_read_is_retried(tmp_path: Path, kv: Path) -> None:
    env = _truncating(tmp_path, kv, n_bad=2)
    src = _load(env)
    assert src.n_total == load_instance(kv).n_ops and src.identity["removed"]
    assert sum(c.startswith("cat ") for c in env.commands) == 3


def test_persistent_truncation_refused_and_stream_kept(tmp_path: Path, kv: Path) -> None:
    env = _truncating(tmp_path, kv, n_bad=99)
    with pytest.raises(StreamIdentityError, match="failed verification"):
        _load(env)
    # Nothing was deleted, so a rerun of the trial can still read the stream.
    assert (tmp_path / "container" / "app" / "stream" / "chunks.jsonl").exists()


def test_load_reads_verifies_and_removes(tmp_path: Path, kv: Path) -> None:
    env = _container(tmp_path, kv)
    src = _load(env, tmp_path / "logs")
    inst = load_instance(kv)
    assert src.n_total == inst.n_ops
    assert src.identity["verified"] and src.identity["removed"]
    assert src.identity["path"] == "/app/stream/chunks.jsonl"
    # The agent cannot read ahead: the stream is gone from the container.
    assert not (tmp_path / "container" / "app" / "stream").exists()
    # The record exists from the start, before any delivery.
    rec = json.loads((tmp_path / "logs" / STREAM_RECORD_NAME).read_text())
    assert rec["n_ops_delivered"] == 0 and rec["n_ops_total"] == inst.n_ops
    assert rec["terminated_by"] is None


def test_load_honours_explicit_path(tmp_path: Path, kv: Path) -> None:
    env = _container(tmp_path, kv, **{ENV_STREAM_PATH: "/app/stream/chunks.jsonl"})
    env.task_env_config.workdir = "/elsewhere"
    assert _load(env).n_total == load_instance(kv).n_ops
    assert not any(c == "pwd" for c in env.commands)


def test_count_mismatch_refused(tmp_path: Path, kv: Path) -> None:
    env = _container(tmp_path, kv, **{ENV_STREAM_COUNT: "3"})
    with pytest.raises(StreamIdentityError, match="count"):
        _load(env)


def test_sha_mismatch_refused(tmp_path: Path, kv: Path) -> None:
    env = _container(tmp_path, kv, **{ENV_STREAM_SHA256: "0" * 64})
    with pytest.raises(StreamIdentityError, match="sha256"):
        _load(env)


def test_unverifiable_stream_refused(tmp_path: Path, kv: Path) -> None:
    env = _container(tmp_path, kv, **{ENV_STREAM_COUNT: None, ENV_STREAM_SHA256: None})
    with pytest.raises(StreamIdentityError, match="unverifiable"):
        _load(env)


def test_canonical_sha_ignores_key_order() -> None:
    a = [{"index": 0, "header": "h", "body": "b"}]
    b = [{"body": "b", "header": "h", "index": 0}]
    assert canonical_sha256(a) == canonical_sha256(b)
    assert canonical_sha256(a) != canonical_sha256([{"index": 0, "header": "h", "body": "c"}])


# ----------------------------------------------------------------------- delivery
def _source(kv: Path, logs: Path | None = None) -> TurnSource:
    text = (kv / "chunks.jsonl").read_text()
    return TurnSource.from_jsonl(text, logs_dir=logs)


def test_first_turn_is_op_zero_rendered(kv: Path) -> None:
    src = _source(kv)
    inst = load_instance(kv)
    assert src.first_turn() == render_op(inst.ops[0], remaining=inst.n_ops - 1)
    assert src.n_delivered == 1
    assert src.log[0].trigger == "<start>"


@pytest.mark.parametrize("cmd", [
    f"echo {ADVANCE_MARKER}",
    f"  echo '{ADVANCE_MARKER}'  ",
    f"printf 'x'; echo {ADVANCE_MARKER}",
    f"python3 - <<'PY' && echo {ADVANCE_MARKER}\nprint(1)\nPY",
])
def test_standalone_ready_delivers_next(kv: Path, cmd: str) -> None:
    src = _source(kv)
    src.first_turn()
    out = src.pending(cmd, 0)
    inst = load_instance(kv)
    assert out == [render_op(inst.ops[1], remaining=inst.n_ops - 2)]
    assert src.n_delivered == 2


@pytest.mark.parametrize("cmd,code", [
    (f"grep {ADVANCE_MARKER} notes.txt", 0),
    (f"printf '{ADVANCE_MARKER}\\n'", 0),
])
def test_non_standalone_marker_explained(kv: Path, cmd: str, code: int) -> None:
    src = _source(kv)
    src.first_turn()
    assert src.pending(cmd, code) == [EXPLAIN_NON_STANDALONE_TEXT]
    assert src.n_delivered == 1 and src.n_explains == 1


def test_failed_ready_does_not_advance(kv: Path) -> None:
    src = _source(kv)
    src.first_turn()
    # exit 1: the step did not finish, so the op is not handed over. The marker is
    # mentioned, so the agent is told why.
    assert src.pending(f"false && echo {ADVANCE_MARKER}", 1) == [EXPLAIN_NON_STANDALONE_TEXT]
    assert src.n_delivered == 1


def test_unknown_exit_counts_as_success(kv: Path) -> None:
    src = _source(kv)
    src.first_turn()
    assert len(src.pending(f"echo {ADVANCE_MARKER}", None)) == 1


def test_ordinary_command_delivers_nothing(kv: Path) -> None:
    src = _source(kv)
    src.first_turn()
    assert src.pending("ls -la", 0) == []
    assert src.n_delivered == 1 and not src.log[1:]


def test_early_submit_refused_then_submit_after_drain(tmp_path: Path, kv: Path) -> None:
    src = _source(kv, tmp_path / "logs")
    src.first_turn()
    assert src.pending(f"echo {SUBMIT_MARKER}", 0) == [REFUSE_SUBMIT_TEXT]
    assert src.on_submit(trigger="task_complete") == [REFUSE_SUBMIT_TEXT]
    assert src.n_refusals == 2 and not src.done
    while not src.drained:
        assert len(src.pending(f"echo {ADVANCE_MARKER}", 0)) == 1
    assert src.pending(f"echo {SUBMIT_MARKER}", 0) == []
    assert src.terminated_by == "submit"
    rec = json.loads((tmp_path / "logs" / STREAM_RECORD_NAME).read_text())
    assert rec["terminated_by"] == "submit"
    assert rec["n_ops_delivered"] == rec["n_ops_total"] == src.n_total
    assert [e["kind"] for e in rec["log"]].count("refuse_submit") == 2


def test_ready_after_drain_is_stream_exhausted(kv: Path) -> None:
    src = _source(kv)
    src.first_turn()
    while not src.drained:
        src.pending(f"echo {ADVANCE_MARKER}", 0)
    assert src.pending(f"echo {ADVANCE_MARKER}", 0) == []
    assert src.terminated_by == "stream_exhausted"
    # After the end nothing more is delivered and the reason is not overwritten.
    assert src.pending(f"echo {ADVANCE_MARKER}", 0) == []
    src.terminate("timeout")
    assert src.terminated_by == "stream_exhausted"


def test_every_op_delivered_only_after_a_ready_command(kv: Path) -> None:
    src = _source(kv)
    src.first_turn()
    cmds = ["ls", f"echo {ADVANCE_MARKER}", "cat x", "cat y", f"echo {ADVANCE_MARKER}"]
    for c in cmds * src.n_total:
        src.pending(c, 0)
    ops = [d for d in src.log if d.kind == "op"]
    assert ops[0].trigger == "<start>"
    assert all(d.trigger == f"echo {ADVANCE_MARKER}" for d in ops[1:])
    assert [d.index for d in ops] == list(range(src.n_total))


def test_empty_stream_ends_immediately() -> None:
    src = TurnSource.from_records([])
    assert src.first_turn() is None
    assert src.terminated_by == "stream_exhausted"


def test_unknown_terminal_reason_rejected(kv: Path) -> None:
    with pytest.raises(ValueError):
        _source(kv).terminate("crashed")
