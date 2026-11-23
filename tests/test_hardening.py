"""Grader/runner hardening: every bypass found by the audit of fb533c1 is closed.

Each test builds the attack out of plain files, the way an agent with a shell in the
container could (``<trial>/agent`` is the container's ``/logs/agent``), and grades the
trial the way the host verifier does. The ``_grade`` shim falls back to the pre-fix
``grade_run(run_dir, gold)`` signature, so this file can also be pointed at an older
checkout to show that the attacks succeeded there.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
from pathlib import Path

import pytest

from conftest import TEST_BUDGET, TEST_RESERVE, make_instance, read_gold
from contextbench.graders import grade_run

HARNESS = "contextbench_harness"


# ------------------------------------------------------------------------ helpers
def _grade(run_dir: Path, gold: dict, **kwargs) -> dict:
    try:
        return grade_run(run_dir, gold, budget=kwargs.pop("budget", TEST_BUDGET),
                         reserve=kwargs.pop("reserve", TEST_RESERVE), **kwargs)
    except TypeError:  # pre-fix signature: grade_run(run_dir, gold)
        return grade_run(run_dir, gold)


def _harness(root: Path, frames: list[list[dict]], *, budget: int = TEST_BUDGET,
             reserve: int = TEST_RESERVE, terminated_by: str = "stream_exhausted",
             extra: dict | None = None) -> Path:
    """An honest snapshot root, as the harness writes it (no-op on pre-fix code)."""
    try:
        from contextbench.tokens import SnapshotLog
    except ImportError:  # pre-fix code: the same frames, in its own format
        from contextbench.tokens import record_snapshot

        for step, frame in enumerate(frames):
            record_snapshot(root, step, frame, {"kind": "sent", "budget": budget,
                                                "reserve": reserve, **(extra or {})})
        return root
    log = SnapshotLog(root)
    for step, frame in enumerate(frames):
        log.record(step, frame, {"kind": "sent", "budget": budget, "reserve": reserve,
                                 **(extra or {})})
    log.close(terminated_by=terminated_by)
    return root


def _agent_snapshot(agent_dir: Path, name: str, messages: list[dict],
                    tokens: int = 1) -> None:
    """A snapshot file planted by the agent in its own logs dir."""
    d = agent_dir / "context_snapshots"
    d.mkdir(parents=True, exist_ok=True)
    (d / name).write_text(json.dumps({"step": 0, "tokens": tokens, "messages": messages}))


def _kv_blocks(gold: dict) -> str:
    return "\n".join(f"<<<ANSWER key={q['key']}>>>\n{q['value']}\n<<<ANSWER END>>>"
                     for q in gold["queries"])


def _op(text: str = "=== op 0 ===\nSET K1 = v") -> list[dict]:
    return [{"role": "system", "content": "sys"}, {"role": "user", "content": text}]


@pytest.fixture
def kv(tmp_path: Path) -> dict:
    return read_gold(make_instance(tmp_path / "kv", "kv_store"))


@pytest.fixture
def log_gold(tmp_path: Path) -> dict:
    return read_gold(make_instance(tmp_path / "log", "log_triage"))


@pytest.fixture
def needle(tmp_path: Path) -> dict:
    return read_gold(make_instance(tmp_path / "needle", "needle_retention"))


def _valid(r: dict) -> bool:
    return r.get("grader_valid") == 1.0


# ------------------------------------------- C1/O1/O2: snapshots out of the agent's reach
def test_turn_file_planted_in_the_agent_dir_is_never_read(tmp_path: Path, kv: dict) -> None:
    """[C1] turn-99999.json in /logs/agent/context_snapshots with every answer."""
    trial = tmp_path / "trial"
    _harness(trial / HARNESS, [_op()])
    _agent_snapshot(trial / "agent", "turn-0000.json", _op())
    _agent_snapshot(trial / "agent", "turn-99999.json",
                    [{"role": "assistant", "content": _kv_blocks(kv)}])
    r = _grade(trial, kv)
    assert _valid(r) and r["reward"] == 0.0


def test_turn_file_not_written_by_the_harness_invalidates(tmp_path: Path, kv: dict) -> None:
    """Even where the snapshot folder itself is reachable, an unlisted file is refused."""
    root = _harness(tmp_path / "root", [_op()])
    _agent_snapshot(root, "turn-99999.json",
                    [{"role": "assistant", "content": _kv_blocks(kv)}])
    r = _grade(root, kv)
    assert r["grader_valid"] == 0.0 and r["reward"] is None
    assert "did not write" in r["grader_note"]


def test_modified_snapshot_invalidates(tmp_path: Path, kv: dict) -> None:
    root = _harness(tmp_path / "root", [_op(), _op()])
    f = root / "context_snapshots" / "turn-0001.json"
    obj = json.loads(f.read_text())
    obj["messages"].append({"role": "assistant", "content": _kv_blocks(kv)})
    f.write_text(json.dumps(obj))
    r = _grade(root, kv)
    assert r["grader_valid"] == 0.0 and "modified" in r["grader_note"]


def test_corrupt_snapshot_fails_loudly(tmp_path: Path, kv: dict) -> None:
    """[L1] an unreadable snapshot is not skipped."""
    root = _harness(tmp_path / "root", [_op(), _op()])
    (root / "context_snapshots" / "turn-0001.json").write_text("{not json")
    r = _grade(root, kv)
    assert r["grader_valid"] == 0.0
    # The legacy (offline) reader is just as strict.
    agent = tmp_path / "old" / "agent"
    _agent_snapshot(agent, "turn-0000.json", _op())
    (agent / "context_snapshots" / "turn-0001.json").write_text("{not json")
    legacy = grade_run(agent, kv, mode="legacy", budget=TEST_BUDGET)
    assert legacy["grader_valid"] == 0.0 and "not readable" in legacy["grader_note"]


def test_snapshot_folder_replaced_by_a_file(tmp_path: Path, kv: dict) -> None:
    """[OWN] the agent occupies /logs/agent/context_snapshots with a file and leaves a
    report: the harness root is unaffected and the report is never graded."""
    trial = tmp_path / "trial"
    _harness(trial / HARNESS, [_op()])
    (trial / "agent").mkdir(parents=True)
    (trial / "agent" / "context_snapshots").write_text("x")
    (trial / "agent" / "final_report.txt").write_text(_kv_blocks(kv))
    r = _grade(trial, kv)
    assert _valid(r) and r["reward"] == 0.0 and r["graded_from"] == "snapshots"


def test_failed_snapshot_write_invalidates_the_run(tmp_path: Path, kv: dict) -> None:
    from contextbench.tokens import SnapshotLog, SnapshotWriteError

    root = tmp_path / "root"
    log = SnapshotLog(root)
    log.record(0, _op(), {"budget": TEST_BUDGET})
    import shutil

    shutil.rmtree(root / "context_snapshots")
    (root / "context_snapshots").write_text("x")
    with pytest.raises(SnapshotWriteError):
        log.record(1, _op(), {"budget": TEST_BUDGET})
    log.close(terminated_by="stream_exhausted")
    r = _grade(root, kv)
    assert r["grader_valid"] == 0.0 and "failed to write" in r["grader_note"]


def test_unclosed_manifest_invalidates(tmp_path: Path, kv: dict) -> None:
    from contextbench.tokens import SnapshotLog

    log = SnapshotLog(tmp_path / "root")
    log.record(0, _op(), {"budget": TEST_BUDGET})
    r = _grade(tmp_path / "root", kv)
    assert r["grader_valid"] == 0.0 and "never closed" in r["grader_note"]


def test_report_only_run_is_invalid(tmp_path: Path, kv: dict) -> None:
    """[C1b] no snapshots, only final_report.txt: no fallback for a scored run."""
    trial = tmp_path / "trial"
    (trial / "agent").mkdir(parents=True)
    (trial / "agent" / "final_report.txt").write_text(_kv_blocks(kv))
    r = _grade(trial, kv)
    assert r["grader_valid"] == 0.0 and r["reward"] is None


def test_trajectory_is_never_a_fallback(tmp_path: Path, needle: dict) -> None:
    """[OWN] snapshots blocked, full ATIF history of a compacting run left behind."""
    trial = tmp_path / "trial"
    (trial / "agent").mkdir(parents=True)
    steps = [{"source": "user", "message": f"piece {i}\n{line}"}
             for i, line in enumerate(needle["answer_lines"])]
    steps.append({"source": "system", "message": "[summarized: earlier pieces dropped]"})
    (trial / "agent" / "trajectory.json").write_text(json.dumps({"steps": steps}))
    r = _grade(trial, needle)
    assert r["grader_valid"] == 0.0 and r["reward"] is None


def test_needle_tool_output_in_the_final_frame_still_counts(tmp_path: Path,
                                                            needle: dict) -> None:
    """[C3] needle retention keeps its definition (whole final context); the defence
    against lines parked on disk is the audit tool's needle-write check."""
    root = _harness(tmp_path / "root", [_op(), [
        {"role": "assistant", "content": "cat /tmp/n.txt"},
        {"role": "tool", "content": "\n".join(needle["answer_lines"])}]])
    r = _grade(root, needle)
    assert _valid(r) and r["reward"] == 1.0


# --------------------------------------------------------- C2/O5/O6: one answer per query
def test_count_spray_across_turns_is_one_answer(tmp_path: Path, log_gold: dict) -> None:
    """[C2] one block per candidate count, spread over many turns: the last one counts."""
    counts = [q for q in log_gold["queries"] if q["type"] == "count"]
    frames = []
    for n in range(0, 401):
        frames.append([{"role": "assistant", "content": "\n".join(
            f"<<<ANSWER qid={q['qid']}>>>\n{n}\n<<<ANSWER END>>>" for q in counts)}])
    root = _harness(tmp_path / "root", frames)
    r = _grade(root, log_gold)
    want = sum(1 for q in counts if int(q["answer"]) == 400) / len(counts)
    assert _valid(r) and r["reward_count"] == pytest.approx(want)


def test_lookup_candidate_list_is_wrong(tmp_path: Path, log_gold: dict) -> None:
    """[OWN] every lookup answered with all candidate messages in one block."""
    lookups = [q for q in log_gold["queries"] if q["type"] == "lookup"]
    msgs = "\n".join(q["answer"] for q in lookups)
    root = _harness(tmp_path / "root", [[{"role": "assistant", "content": "\n".join(
        f"<<<ANSWER qid={q['qid']}>>>\n{msgs}\n<<<ANSWER END>>>" for q in lookups)}]])
    r = _grade(root, log_gold)
    assert _valid(r) and r["reward_lookup"] == 0.0


def test_lookup_exact_answer_is_right_with_or_without_the_tag(tmp_path: Path,
                                                              log_gold: dict) -> None:
    import re

    q = next(q for q in log_gold["queries"] if q["type"] == "lookup")
    for answer in (q["answer"], re.sub(r"\s*#[0-9a-f]+\s*$", "", q["answer"])):
        root = _harness(tmp_path / f"root{len(answer)}", [[{"role": "tool", "content":
            f"<<<ANSWER qid={q['qid']}>>>\n  {answer} \n<<<ANSWER END>>>"}]])
        assert _grade(root, log_gold)["matched"] == 1.0


def test_kv_value_inside_a_longer_answer_is_wrong(tmp_path: Path, kv: dict) -> None:
    """[OWN] substring credit: every value buried in one long answer per key."""
    allv = " ".join(q["value"] for q in kv["queries"])
    root = _harness(tmp_path / "root", [[{"role": "assistant", "content": "\n".join(
        f"<<<ANSWER key={q['key']}>>>\n{allv}\n<<<ANSWER END>>>" for q in kv["queries"])}]])
    r = _grade(root, kv)
    assert _valid(r) and r["reward"] == 0.0


def test_last_answer_wins(tmp_path: Path, kv: dict) -> None:
    q = kv["queries"][0]
    right = f"<<<ANSWER key={q['key']}>>>\n{q['value']}\n<<<ANSWER END>>>"
    wrong = f"<<<ANSWER key={q['key']}>>>\nnot it\n<<<ANSWER END>>>"
    fixed = _harness(tmp_path / "a", [[{"role": "assistant", "content": wrong}],
                                      [{"role": "assistant", "content": right}]])
    assert _grade(fixed, kv)["matched"] == 1.0
    regressed = _harness(tmp_path / "b", [[{"role": "assistant", "content": right}],
                                          [{"role": "assistant", "content": wrong}]])
    assert _grade(regressed, kv)["matched"] == 0.0
    # Within one frame, the later message wins too.
    one = _harness(tmp_path / "c", [[{"role": "assistant", "content": right},
                                     {"role": "tool", "content": wrong}]])
    assert _grade(one, kv)["matched"] == 0.0


def test_inline_mentions_of_the_format_are_not_answers(tmp_path: Path, kv: dict) -> None:
    """A summary quoting the format, a printf literal or a shell echo of the command
    must not replace the real answer under last-answer-wins."""
    q = kv["queries"][0]
    real = f"<<<ANSWER key={q['key']}>>>\n{q['value']}\n<<<ANSWER END>>>"
    later = (f"Notes: use `<<<ANSWER key={q['key']}>>>` then the value.\n"
             f"$ printf '<<<ANSWER key={q['key']}>>>\\n%s\\n<<<ANSWER END>>>\\n' \"$v\"\n"
             f"Apptainer> printf '<<<ANSWER key={q['key']}>>>\n> %s\n> <<<ANSWER END>>>'")
    root = _harness(tmp_path / "root", [[{"role": "tool", "content": real}],
                                        [{"role": "assistant", "content": later}]])
    assert _grade(root, kv)["matched"] == 1.0


def test_user_text_is_never_an_answer(tmp_path: Path, kv: dict) -> None:
    """[O6] the instruction's example block (and any user/system text) is not parsed."""
    q = kv["queries"][0]
    instruction = ("# Key-Value Store\nexample:\nprintf '<<<ANSWER key=%s>>>\\n%%s\\n"
                   "<<<ANSWER END>>>\\n' \"$val\"\n<<<ANSWER key=%s>>>\n%s\n<<<ANSWER END>>>"
                   % (q["key"], q["key"], q["value"]))
    root = _harness(tmp_path / "root", [[{"role": "system", "content": _kv_blocks(kv)},
                                         {"role": "user", "content": instruction}]])
    r = _grade(root, kv)
    assert _valid(r) and r["reward"] == 0.0 and r["n_answered"] == 0.0


def test_tool_output_counts_as_an_answer(tmp_path: Path, kv: dict) -> None:
    root = _harness(tmp_path / "root", [[{"role": "tool", "content": _kv_blocks(kv)}]])
    assert _grade(root, kv)["reward"] == 1.0


def test_terminus_user_turns_after_the_first_are_tool_output(tmp_path: Path,
                                                            kv: dict) -> None:
    """terminus-2 shows the terminal as user turns; its snapshots say so."""
    frame = [{"role": "user", "content": "instruction"},
             {"role": "assistant", "content": '{"keystrokes": "printf ..."}'},
             {"role": "user", "content": "New Terminal Output:\n" + _kv_blocks(kv)}]
    flagged = _harness(tmp_path / "a", [frame],
                       extra={"tool_output_in_user_turns": True})
    assert _grade(flagged, kv)["reward"] == 1.0
    plain = _harness(tmp_path / "b", [frame])
    assert _grade(plain, kv)["reward"] == 0.0
    first_only = _harness(tmp_path / "c", [[frame[2]]],
                          extra={"tool_output_in_user_turns": True})
    assert _grade(first_only, kv)["reward"] == 0.0


# ------------------------------------------------------------------- O3: the budget
def test_snapshot_budget_must_be_the_tasks(tmp_path: Path, kv: dict) -> None:
    """[O3] an agent kwarg cannot raise the budget the run is graded under."""
    root = _harness(tmp_path / "root", [[{"role": "tool", "content": _kv_blocks(kv)}]],
                    budget=10**6)
    r = _grade(root, kv)
    assert r["grader_valid"] == 0.0 and "budget" in r["grader_note"]
    assert r["budget_tokens"] == float(TEST_BUDGET)


def test_smaller_reserve_than_the_tasks_is_refused(tmp_path: Path, kv: dict) -> None:
    root = _harness(tmp_path / "root", [_op()], reserve=0)
    assert _grade(root, kv)["grader_valid"] == 0.0
    stricter = _harness(tmp_path / "s", [_op()], reserve=TEST_RESERVE * 2)
    assert _grade(stricter, kv)["grader_valid"] == 1.0


def test_over_budget_frame_mid_run_is_invalid(tmp_path: Path, kv: dict) -> None:
    big = [{"role": "tool", "content": "word " * (TEST_BUDGET * 2)}]
    root = _harness(tmp_path / "a", [_op(), big, _op()], terminated_by="budget_wall")
    r = _grade(root, kv)
    assert r["grader_valid"] == 0.0 and "over the task budget" in r["grader_note"]
    # The frame that hit the wall, recorded last before the run stopped there: valid.
    tail = _harness(tmp_path / "b", [_op(), big], terminated_by="budget_wall")
    r = _grade(tail, kv)
    assert r["grader_valid"] == 1.0 and r["n_snapshots_over_budget"] == 1.0
    # The same tail in a run that did not end at the wall: invalid.
    other = _harness(tmp_path / "c", [_op(), big], terminated_by="stream_exhausted")
    assert _grade(other, kv)["grader_valid"] == 0.0


def test_budget_applies_to_sent_frames(tmp_path: Path, kv: dict) -> None:
    """A post-reply snapshot (sent context + reply) may exceed the budget; a sent one
    may not, unless it is the one that hit the wall at the end of the run."""
    from contextbench.tokens import SnapshotLog

    big = [{"role": "tool", "content": "word " * (TEST_BUDGET * 2)}]

    def run(name: str, kinds: list[str], terminated_by: str) -> dict:
        log = SnapshotLog(tmp_path / name)
        for step, kind in enumerate(kinds):
            frame = big if kind.endswith("!") else _op()
            log.record(step, frame, {"kind": kind.rstrip("!"), "budget": TEST_BUDGET,
                                     "reserve": TEST_RESERVE})
        log.close(terminated_by=terminated_by)
        return _grade(tmp_path / name, kv)

    assert run("a", ["sent", "turn!", "sent", "turn"], "stream_exhausted")["grader_valid"] == 1.0
    assert run("b", ["sent", "sent!", "sent"], "stream_exhausted")["grader_valid"] == 0.0
    assert run("c", ["sent", "turn", "sent!", "final!"], "budget_wall")["grader_valid"] == 1.0


def test_resolve_snapshot_root_never_doubles_the_dir(tmp_path: Path) -> None:
    from contextbench.graders.base import resolve_snapshot_root

    root = tmp_path / HARNESS
    assert resolve_snapshot_root(root) == root
    assert resolve_snapshot_root(tmp_path) == root


def test_self_reported_token_count_is_checked(tmp_path: Path, kv: dict) -> None:
    root = _harness(tmp_path / "root", [_op()])
    f = root / "context_snapshots" / "turn-0000.json"
    obj = json.loads(f.read_text())
    obj["tokens"] = 1
    data = (json.dumps(obj, indent=2) + "\n").encode()
    f.write_bytes(data)
    # Re-sign the manifest too, as an attacker with write access to the root would:
    import hashlib

    lines = [json.loads(x) for x in (root / "snapshot_manifest.jsonl").read_text().splitlines()]
    for ln in lines:
        if ln.get("file") == "turn-0000.json":
            ln["sha256"], ln["tokens"] = hashlib.sha256(data).hexdigest(), 1
    (root / "snapshot_manifest.jsonl").write_text(
        "".join(json.dumps(ln) + "\n" for ln in lines))
    from contextbench.tokens import encoder_name

    r = _grade(root, kv)
    if obj["token_method"] == encoder_name():
        assert r["grader_valid"] == 0.0 and "count" in r["grader_note"]


def test_missing_budget_is_invalid(tmp_path: Path, kv: dict) -> None:
    root = _harness(tmp_path / "root", [_op()])
    r = grade_run(root, kv)  # no task budget given
    assert r["grader_valid"] == 0.0


def test_reward_records_the_budget(tmp_path: Path, kv: dict) -> None:
    from contextbench.harbor.reward import write_rewards

    root = _harness(tmp_path / "root", [[{"role": "tool", "content": _kv_blocks(kv)}]])
    numeric = write_rewards(root, kv, tmp_path / "out", budget=TEST_BUDGET,
                            reserve=TEST_RESERVE)
    assert numeric["budget_tokens"] == TEST_BUDGET
    assert numeric["reserve_tokens"] == TEST_RESERVE
    assert json.loads((tmp_path / "out" / "reward.json").read_text())["reward"] == 1.0


# ---------------------------------------------------------- L1: invalid grade handling
def test_invalid_grade_writes_no_reward_and_exits_nonzero(tmp_path: Path, kv: dict) -> None:
    from contextbench.harbor.reward import InvalidGrade, main, write_rewards

    trial = tmp_path / "trial"
    (trial / "agent").mkdir(parents=True)
    out = tmp_path / "verifier"
    out.mkdir()
    (out / "reward.json").write_text('{"reward": 1.0}')  # left behind by the agent
    gold = tmp_path / "gold.json"
    gold.write_text(json.dumps(kv))
    with pytest.raises(InvalidGrade):
        write_rewards(trial, kv, out, budget=TEST_BUDGET)
    assert not (out / "reward.json").exists()
    assert json.loads((out / "contextbench_result.json").read_text())["valid"] is False
    rc = main(["--run-dir", str(trial), "--gold", str(gold), "--out-dir", str(out),
               "--budget", str(TEST_BUDGET)])
    assert rc == 2 and not (out / "reward.json").exists()


# ------------------------------------------------------------------ H: tests/test.sh
def _task(tmp_path: Path, family: str = "kv_store") -> Path:
    from contextbench.harbor.package import build_task

    inst = make_instance(tmp_path / f"inst-{family}", family)
    return build_task(inst, tmp_path / "tasks", image="python:3.12-slim",
                      budget=TEST_BUDGET, reserve=TEST_RESERVE, require_feasible=False)


def test_test_sh_cannot_be_shadowed_and_writes_no_reward(tmp_path: Path) -> None:
    """[H] a `contextbench` package (and a `python3`) planted by the agent in the work
    dir and on PATH: tests/test.sh still writes no reward and exits non-zero."""
    task = _task(tmp_path)
    box = tmp_path / "box"
    for d in ("tests", "logs/verifier", "logs/agent", "app/contextbench/harbor", "bin"):
        (box / d).mkdir(parents=True)
    import shutil

    shutil.copytree(task / "tests", box / "tests", dirs_exist_ok=True)
    fake = ("import json, pathlib\n"
            "pathlib.Path('%s/logs/verifier/reward.json').write_text("
            "json.dumps({'reward': 1.0}))\n" % box)
    (box / "app" / "contextbench" / "__init__.py").write_text("")
    (box / "app" / "contextbench" / "harbor" / "__init__.py").write_text("")
    (box / "app" / "contextbench" / "harbor" / "reward.py").write_text(fake)
    py = box / "bin" / "python3"
    py.write_text(f"#!/bin/sh\n{sys.executable} -c \"{fake.replace(chr(10), ';')}\"\n")
    py.chmod(0o755)
    (box / "logs" / "verifier" / "reward.json").write_text('{"reward": 1.0}')
    script = (box / "tests" / "test.sh").read_text()
    script = script.replace("/tests", f"{box}/tests").replace("/logs/", f"{box}/logs/")
    env = dict(os.environ, PATH=f"{box / 'bin'}:{os.environ.get('PATH', '')}",
               PYTHONPATH=f"{box / 'app'}")
    res = subprocess.run(["bash", "-c", script], cwd=box / "app", env=env,
                         capture_output=True, text=True)
    assert res.returncode != 0
    assert not (box / "logs" / "verifier" / "reward.json").exists()
    assert "ContextBenchVerifier" in res.stderr


def test_task_toml_settings_parse_under_harbor(tmp_path: Path) -> None:
    import tomllib

    task = _task(tmp_path)
    raw = tomllib.loads((task / "task.toml").read_text())
    assert raw["verifier"]["environment_mode"] == "shared"
    assert raw["environment"]["network_mode"] == "public"
    assert raw["metadata"]["contextbench_budget_tokens"] == TEST_BUDGET
    config = pytest.importorskip("harbor.models.task.config")
    cfg = config.TaskConfig.model_validate(raw)
    assert cfg.verifier.environment_mode.value == "shared"
    assert cfg.environment.network_mode.value == "public"


# ----------------------------------------------- the host verifier and its oracle mode
class _Obj:
    def __init__(self, **kw):
        self.__dict__.update(kw)


def _verifier(task: Path, trial: Path, mode: str):
    verifiers = pytest.importorskip("contextbench.harbor.verifiers")
    import tomllib

    meta = tomllib.loads((task / "task.toml").read_text())["metadata"]
    v = object.__new__(verifiers.ContextBenchVerifier)
    v.task = _Obj(paths=_Obj(tests_dir=task / "tests"), config=_Obj(metadata=meta))
    v.trial_paths = _Obj(trial_dir=trial, agent_dir=trial / "agent",
                         verifier_dir=trial / "verifier")
    v.step_name = None
    v._gold_filename = "gold.json"
    v._mode = mode
    return v, verifiers


def _oracle_trial(task: Path, trial: Path, agent_name: str) -> None:
    import re

    solve = (task / "solution" / "solve.sh").read_text()
    report = re.search(r"<<'(\w+)'\n(.*)\n\1\n", solve, re.DOTALL).group(2)
    (trial / "agent").mkdir(parents=True)
    (trial / "verifier").mkdir()
    (trial / "agent" / "final_report.txt").write_text(report + "\n")
    (trial / "config.json").write_text(json.dumps(
        {"agent": {"name": agent_name, "import_path": None}}))


def test_oracle_mode_only_for_the_oracle_agent(tmp_path: Path) -> None:
    import asyncio

    task = _task(tmp_path)
    ok = tmp_path / "oracle-trial"
    _oracle_trial(task, ok, "oracle")
    v, verifiers = _verifier(task, ok, "oracle")
    assert asyncio.run(v.verify()).rewards["reward"] == pytest.approx(1.0)

    agent = tmp_path / "agent-trial"
    _oracle_trial(task, agent, "terminus-2")
    (agent / "verifier" / "reward.json").write_text('{"reward": 1.0}')
    v, verifiers = _verifier(task, agent, "oracle")
    with pytest.raises(verifiers.InvalidGrade):
        asyncio.run(v.verify())
    assert not (agent / "verifier" / "reward.json").exists()
    # The same report in a scored run: invalid, no reward.
    v, verifiers = _verifier(task, agent, "scored")
    with pytest.raises(verifiers.InvalidGrade):
        asyncio.run(v.verify())
    assert not (agent / "verifier" / "reward.json").exists()


def test_scored_verifier_grades_the_harness_root(tmp_path: Path) -> None:
    import asyncio

    task = _task(tmp_path)
    gold = json.loads((task / "tests" / "gold.json").read_text())
    trial = tmp_path / "trial"
    (trial / "verifier").mkdir(parents=True)
    _harness(trial / HARNESS, [[{"role": "tool", "content": _kv_blocks(gold)}]])
    _agent_snapshot(trial / "agent", "turn-0000.json", _op())
    v, _ = _verifier(task, trial, "scored")
    rewards = asyncio.run(v.verify()).rewards
    assert rewards["reward"] == 1.0 and rewards["budget_tokens"] == TEST_BUDGET
    assert rewards["graded_from_code"] == 3


# -------------------------------------------------------------- mixin write failures
def test_mixin_snapshot_failure_makes_the_run_invalid(tmp_path: Path, kv: dict) -> None:
    import asyncio

    from contextbench.harbor import CBStreamMixin
    from contextbench.tokens import SnapshotWriteError
    from test_harbor_turn_source import _container

    inst = make_instance(tmp_path / "kvi", "kv_store", records=300, value_words=4,
                         queries=2)
    env = _container(tmp_path, inst)

    class Loop(CBStreamMixin):
        def __init__(self, logs_dir: Path):
            self.logs_dir = logs_dir

    loop = Loop(tmp_path / "trial" / "agent")

    async def go():
        await loop.cb_setup(env, budget=TEST_BUDGET, reserve=TEST_RESERVE)
        msgs = loop.cb_user_turns(loop.cb_initial_turns())
        loop.cb_over_budget(msgs)
        import shutil

        snap_dir = loop.cb_snapshots.snapshot_dir
        shutil.rmtree(snap_dir)
        snap_dir.write_text("x")
        try:
            loop.cb_over_budget(msgs)
        finally:
            loop.cb_finish(None)

    with pytest.raises(SnapshotWriteError):
        asyncio.run(go())
    r = _grade(tmp_path / "trial", read_gold(inst))
    assert r["grader_valid"] == 0.0 and "failed to write" in r["grader_note"]
