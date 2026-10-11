"""The runner: the oracle upper bound, and every way the protocol says no."""

from __future__ import annotations

import json
from pathlib import Path

import pytest

from conftest import (
    PROTOCOL_LEVEL,
    TEST_BUDGET,
    TEST_RESERVE,
    make_instance,
    read_gold,
)
from contextbench import ADVANCE_MARKER, SUBMIT_MARKER, load_instance, run
from contextbench.oracle import OracleAgent


def _run(instance: Path, out_dir: Path, agent=None, **kwargs) -> dict:
    return run(
        agent if agent is not None else OracleAgent(instance),
        instance,
        budget=kwargs.pop("budget", TEST_BUDGET),
        reserve=kwargs.pop("reserve", TEST_RESERVE),
        out_dir=out_dir,
        **kwargs,
    )


def _snapshot_count(out_dir: Path) -> int:
    return len(list((out_dir / "context_snapshots").glob("turn-*.json")))


# ------------------------------------------------------------------- the upper bound
def test_oracle_scores_one(tmp_path: Path, instance: Path, family: str) -> None:
    """An oracle that does not score 1.0 means the task or the grader is broken."""
    out = tmp_path / "run"
    result = _run(instance, out)
    n_ops = len(load_instance(instance).ops)

    assert result["reward"] == pytest.approx(1.0)
    assert result["terminated_by"] == "submit"
    assert result["n_turns"] == n_ops
    assert result["n_ops_delivered"] == n_ops == result["n_ops_total"]
    assert _snapshot_count(out) == n_ops
    assert result["rewards"]["graded_from"] == "snapshots"
    assert result["rewards"]["grader_valid"] == 1.0
    assert result["task_family"] == family


def test_oracle_holds_the_context_flat(tmp_path: Path, instance: Path) -> None:
    result = _run(instance, tmp_path / "run")
    assert result["peak_tokens"] <= TEST_BUDGET - TEST_RESERVE


def test_run_writes_its_artifacts(tmp_path: Path, instance: Path) -> None:
    out = tmp_path / "run"
    result = _run(instance, out)

    stream = json.loads((out / "interactive_stream.json").read_text(encoding="utf-8"))
    assert stream == {
        "n_ops_delivered": result["n_ops_delivered"],
        "n_ops_total": result["n_ops_total"],
        "terminated_by": "submit",
    }
    assert json.loads((out / "result.json").read_text(encoding="utf-8")) == result


def test_first_op_reaches_the_agent_as_a_user_turn(
    tmp_path: Path, instance: Path
) -> None:
    ops = load_instance(instance).ops
    out = tmp_path / "run"
    # An append-only agent keeps the delivered turn, so the snapshot shows it
    # verbatim; the oracle drops it again as part of its policy.
    _run(instance, out, agent=ScriptedAgent([]), max_turns=1)
    first = json.loads(
        (out / "context_snapshots" / "turn-0001.json").read_text(encoding="utf-8")
    )
    header = f"=== {ops[0].header} ({len(ops) - 1} op(s) remaining after this) ==="
    assert any(header in str(m.get("content", "")) for m in first["messages"])


# ------------------------------------------------------------------- scripted agents
class ScriptedAgent:
    """An agent that replies from a fixed script, then always asks for the next op."""

    def __init__(self, script: list[str]):
        self.script = list(script)
        self.received: list[str] = []
        self.messages: list[dict] = []

    def reset(self, system: str, instruction: str) -> None:
        self.messages = [
            {"role": "system", "content": system},
            {"role": "user", "content": instruction},
        ]

    def context(self) -> list[dict]:
        return self.messages

    def on_user_turn(self, text: str) -> str:
        self.received.append(text)
        self.messages.append({"role": "user", "content": text})
        reply = self.script.pop(0) if self.script else ADVANCE_MARKER
        self.messages.append({"role": "assistant", "content": reply})
        return reply


def test_early_submit_is_refused_then_the_run_succeeds(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention", **PROTOCOL_LEVEL)
    n_ops = len(load_instance(instance).ops)
    # Submit on the very first turn, then follow the protocol for the rest.
    agent = ScriptedAgent([SUBMIT_MARKER])
    result = _run(instance, tmp_path / "run", agent=agent)

    refusals = [t for t in agent.received if "nothing to submit" in t]
    assert len(refusals) == 1
    # The refusal costs a turn but never an operation.
    assert result["n_ops_delivered"] == n_ops
    assert result["n_turns"] == n_ops + 1
    assert result["terminated_by"] == "stream_exhausted"


def test_submit_after_the_last_op_ends_the_run(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention", **PROTOCOL_LEVEL)
    n_ops = len(load_instance(instance).ops)
    agent = ScriptedAgent([ADVANCE_MARKER] * (n_ops - 1) + [SUBMIT_MARKER])
    result = _run(instance, tmp_path / "run", agent=agent)
    assert result["terminated_by"] == "submit"
    assert result["n_turns"] == n_ops


def test_a_non_standalone_marker_is_explained_and_does_not_advance(
    tmp_path: Path,
) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention", **PROTOCOL_LEVEL)
    agent = ScriptedAgent(["I will send READY_FOR_NEXT_OP once I am done."])
    result = _run(instance, tmp_path / "run", agent=agent)

    explained = [t for t in agent.received if "did NOT advance" in t]
    assert len(explained) == 1
    assert result["n_ops_delivered"] == len(load_instance(instance).ops)


def test_a_reply_without_the_marker_is_nudged(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention", **PROTOCOL_LEVEL)
    agent = ScriptedAgent(["thinking about it."])
    _run(instance, tmp_path / "run", agent=agent)
    assert any("did not advance" in t for t in agent.received)


def test_running_out_of_ops_ends_as_stream_exhausted(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention", **PROTOCOL_LEVEL)
    agent = ScriptedAgent([])  # always asks for the next op, never submits
    result = _run(instance, tmp_path / "run", agent=agent)
    assert result["terminated_by"] == "stream_exhausted"


def test_max_turns_stops_the_run(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention", **PROTOCOL_LEVEL)
    result = _run(instance, tmp_path / "run", max_turns=3)
    assert result["terminated_by"] == "max_steps"
    assert result["n_turns"] == 3


class HoardingAgent(ScriptedAgent):
    """Appends every turn and never removes anything: the overflow baseline."""

    def __init__(self) -> None:
        super().__init__([])


def test_an_append_only_agent_hits_the_budget_wall(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention")
    result = _run(instance, tmp_path / "run", agent=HoardingAgent(), budget=4096,
                  reserve=512)
    assert result["terminated_by"] == "budget_wall"
    assert result["n_ops_delivered"] < result["n_ops_total"]
    assert result["peak_tokens"] > 4096 - 512


def test_grading_uses_the_family_from_gold(tmp_path: Path, instance: Path) -> None:
    from contextbench import grade_run

    out = tmp_path / "run"
    _run(instance, out)
    rewards = grade_run(out, read_gold(instance))
    assert rewards["reward"] == pytest.approx(1.0)


class _SilentAgent:
    """Advances through every op without ever answering."""

    def reset(self, system: str, instruction: str) -> None:
        self._messages = [{"role": "system", "content": system},
                          {"role": "user", "content": instruction}]

    def on_user_turn(self, text: str) -> str:
        reply = ADVANCE_MARKER
        self._messages = self._messages[:2] + [{"role": "user", "content": text},
                                               {"role": "assistant", "content": reply}]
        return reply

    def context(self) -> list[dict]:
        return list(self._messages)


def test_a_used_run_dir_is_refused(tmp_path: Path) -> None:
    """Old snapshots in out_dir would be graded as this run's: refuse, never mix."""
    inst = make_instance(tmp_path / "kv", "kv_store")
    out = tmp_path / "run"
    assert _run(inst, out)["reward"] == pytest.approx(1.0)
    with pytest.raises(FileExistsError):
        _run(inst, out, agent=_SilentAgent())
    # overwrite clears the old run, so the silent agent is graded on its own snapshots
    silent = _run(inst, out, agent=_SilentAgent(), overwrite=True)
    assert silent["reward"] == pytest.approx(0.0)
    assert _snapshot_count(out) == silent["n_turns"]


def test_an_empty_existing_run_dir_is_accepted(tmp_path: Path) -> None:
    inst = make_instance(tmp_path / "kv", "kv_store")
    out = tmp_path / "run"
    out.mkdir()
    assert _run(inst, out)["reward"] == pytest.approx(1.0)


class _ForgetfulOracle(OracleAgent):
    """The oracle's replies, but its context never keeps its own assistant turns."""

    def context(self) -> list[dict]:
        return [m for m in super().context() if m.get("role") != "assistant"]


def test_only_answers_kept_in_context_are_credited(tmp_path: Path) -> None:
    """A snapshot is the agent's context after the turn. An answer the agent drops
    from its context before the snapshot is not credited: the reward measures what
    the agent keeps, not what it said once."""
    inst = make_instance(tmp_path / "kv", "kv_store")
    assert _run(inst, tmp_path / "kept")["reward"] == pytest.approx(1.0)
    assert _run(inst, tmp_path / "dropped",
                agent=_ForgetfulOracle(inst))["reward"] == pytest.approx(0.0)
