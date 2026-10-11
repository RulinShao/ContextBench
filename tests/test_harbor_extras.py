"""The one-liners: package --all, the in-task grader, the mixin, and cb_stream."""

from __future__ import annotations

import asyncio
import json
import os
import subprocess
import sys
import tomllib
from pathlib import Path

import pytest

from conftest import make_instance
from contextbench import ADVANCE_MARKER, SUBMIT_MARKER
from contextbench.harbor import CBStreamMixin
from contextbench.harbor.package import build_all, build_task
from contextbench.stream import REFUSE_SUBMIT_TEXT

from test_harbor_turn_source import _container

TINY_CONFIG = {
    "context": {"budget_tokens": 8192, "reserve_tokens": 1024},
    "seeds": [42, 43],
    "families": {
        "kv_store": {"fixed": {"records_per_chunk": 100, "value_words": 8, "queries": 4},
                     "levels": [{"name": "R300", "records": 300}]},
        "sudoku_sketchpad": {"fixed": {}, "levels": [{"name": "b3", "box": 3,
                                                       "givens": 30, "turns": 12}]},
    },
}


def test_build_all_is_a_flat_dataset(tmp_path: Path) -> None:
    tasks = build_all(TINY_CONFIG, tmp_path / "cb_tasks", image="python:3.12-slim",
                      require_feasible=False)
    names = sorted(t.name for t in tasks)
    assert names == ["kv-store-R300-seed42", "kv-store-R300-seed43",
                     "sudoku-sketchpad-b3-seed42", "sudoku-sketchpad-b3-seed43"]
    assert sorted(p.name for p in (tmp_path / "cb_tasks").iterdir()) == names
    assert (tmp_path / "cb_tasks_instances" / names[0] / "gold.json").is_file()


@pytest.mark.needs_o200k
def test_build_all_keeps_descriptive_keys_out_of_the_generator(tmp_path: Path) -> None:
    """figure_x / main_figure / regime describe a level; regime gates it; the filter works."""
    config = {
        "context": {"budget_tokens": 32768, "reserve_tokens": 2048},
        "seeds": [42],
        "families": {"kv_store": {
            "fixed": {"records_per_chunk": 100, "value_words": 24, "queries": 24},
            "levels": [
                {"name": "R130", "records": 130, "figure_x": 0.197,
                 "appendix_pressure": 0.27, "main_figure": True, "regime": "sub-budget"},
                {"name": "R140", "records": 140, "figure_x": 0.21, "regime": "sub-budget"},
            ]}},
    }
    tasks = build_all(config, tmp_path / "all", image="python:3.12-slim")
    assert sorted(t.name for t in tasks) == ["kv-store-R130-seed42", "kv-store-R140-seed42"]
    cfg = tomllib.loads((tasks[0] / "task.toml").read_text())
    assert cfg["metadata"]["contextbench_regime"] == "sub-budget"
    assert cfg["metadata"]["contextbench_feasible"] is True
    receipt = json.loads((tasks[0] / "tests" / "feasibility_receipt.json").read_text())
    assert receipt["regime"] == "sub-budget"
    main_only = build_all(config, tmp_path / "main", image="python:3.12-slim",
                          main_figure_only=True)
    assert [t.name for t in main_only] == ["kv-store-R130-seed42"]


def _run_task_grader(task: Path, agent_dir: Path, out: Path) -> dict:
    """Run tests/test.sh's grader exactly as the container would: vendored copy only."""
    env = {k: v for k, v in os.environ.items() if k not in ("PYTHONPATH",)}
    env["PYTHONPATH"] = str(task / "tests" / "_cb")
    subprocess.run(
        [sys.executable, "-m", "contextbench.harbor.reward", "--agent-dir", str(agent_dir),
         "--gold", str(task / "tests" / "gold.json"), "--out-dir", str(out)],
        check=True, env=env, cwd=str(out.parent), capture_output=True, text=True)
    return json.loads((out / "reward.json").read_text())


def test_task_grades_itself_from_the_vendored_copy(tmp_path: Path, instance: Path,
                                                   family: str) -> None:
    task = build_task(instance, tmp_path / "tasks", image="python:3.12-slim",
                      require_feasible=False)
    test_sh = (task / "tests" / "test.sh").read_text()
    assert "contextbench.harbor.reward" in test_sh and "/tests/gold.json" in test_sh
    # The oracle's report, graded by the copy shipped inside the task.
    import re

    solve = (task / "solution" / "solve.sh").read_text()
    report = re.search(r"<<'(\w+)'\n(.*)\n\1\n", solve, re.DOTALL).group(2)
    agent = tmp_path / "logs" / "agent"
    agent.mkdir(parents=True)
    (agent / "final_report.txt").write_text(report + "\n")
    rewards = _run_task_grader(task, agent, tmp_path / "logs" / "verifier")
    assert rewards["reward"] == pytest.approx(1.0)
    assert rewards["graded_from_code"] == 1
    assert all(isinstance(v, (int, float)) for v in rewards.values())
    full = json.loads((tmp_path / "logs" / "verifier" / "contextbench_result.json").read_text())
    assert full["graded_from"] == "final_report"


# ------------------------------------------------------------------------- mixin
class _Loop(CBStreamMixin):
    """A user's own loop: the documented three calls, nothing else."""

    def __init__(self, logs_dir: Path):
        self.logs_dir = logs_dir

    async def run(self, environment, script: list[tuple[str, int]]) -> list[dict]:
        await self.cb_setup(environment, budget=8192, reserve=1024)
        messages = [{"role": "user", "content": "instruction"}]
        messages += self.cb_user_turns(self.cb_initial_turns())
        for command, code in script:
            if self.cb_done or self.cb_over_budget(messages):
                break
            messages.append({"role": "assistant", "content": command})
            messages.append({"role": "tool", "content": f"exit {code}"})
            messages += self.cb_user_turns(self.cb_pending(command, code))
        self.cb_finish(None, messages)
        return messages


def test_mixin_drives_a_plain_loop(tmp_path: Path) -> None:
    inst = make_instance(tmp_path / "kv", "kv_store", records=300, value_words=4,
                         queries=2)
    env = _container(tmp_path, inst)
    loop = _Loop(tmp_path / "logs")
    n = len((inst / "chunks.jsonl").read_text().splitlines())
    script = [(f"echo {SUBMIT_MARKER}", 0)] + [("ls", 0), (f"echo {ADVANCE_MARKER}", 0)] * n
    messages = asyncio.run(loop.run(env, script))
    src = loop.cb_turn_source
    assert src.terminated_by == "stream_exhausted"
    assert src.n_delivered == src.n_total == n
    assert src.n_refusals == 1
    assert messages[4]["content"] == REFUSE_SUBMIT_TEXT  # right after the tool result
    ops = [m for m in messages if m["role"] == "user" and m["content"].startswith("=== ")]
    assert len(ops) == n
    snaps = sorted((tmp_path / "logs" / "context_snapshots").glob("turn-*.json"))
    assert snaps and json.loads(snaps[-1].read_text())["kind"] == "final"
    rec = json.loads((tmp_path / "logs" / "interactive_stream.json").read_text())
    assert rec["terminated_by"] == "stream_exhausted"


def test_mixin_budget_wall(tmp_path: Path) -> None:
    inst = make_instance(tmp_path / "kv", "kv_store")
    env = _container(tmp_path, inst)
    loop = _Loop(tmp_path / "logs")

    async def go():
        await loop.cb_setup(env, budget=300, reserve=100)
        msgs = loop.cb_user_turns(loop.cb_initial_turns())
        return loop.cb_over_budget(msgs)

    assert asyncio.run(go()) is True
    assert loop.cb_turn_source.terminated_by == "budget_wall"


# ------------------------------------------------------------------------ wrapper
def test_cb_stream_refuses_a_cli_without_resume() -> None:
    pytest.importorskip("harbor")
    from harbor.agents.installed.claude_code import ClaudeCode
    from harbor.agents.installed.codex import Codex
    from harbor.agents.installed.mini_swe_agent import MiniSweAgent

    from contextbench.harbor.wrap import CodexStream, MiniSweAgentStream, cb_stream

    with pytest.raises(TypeError, match="fresh conversation per op"):
        cb_stream(ClaudeCode)
    with pytest.raises(TypeError):
        cb_stream(object)
    assert issubclass(CodexStream, Codex) and issubclass(CodexStream, CBStreamMixin)
    assert issubclass(MiniSweAgentStream, MiniSweAgent)
    assert CodexStream.name() == "codex-contextbench"

    class MyCodex(Codex):
        pass

    wrapped = cb_stream(MyCodex)
    assert issubclass(wrapped, MyCodex) and wrapped.__name__ == "MyCodexStream"


def test_unwrap_shell() -> None:
    pytest.importorskip("harbor")
    from contextbench.harbor.wrap import unwrap_shell

    assert unwrap_shell("/bin/bash -lc 'echo READY_FOR_NEXT_OP'") == "echo READY_FOR_NEXT_OP"
    assert unwrap_shell("bash -lc \"printf x; echo READY_FOR_NEXT_OP\"") == \
        "printf x; echo READY_FOR_NEXT_OP"
    assert unwrap_shell("ls -la") == "ls -la"


def test_terminus_limit_defaults_to_the_budget(tmp_path: Path, monkeypatch) -> None:
    pytest.importorskip("harbor")
    from harbor.agents.terminus_2.terminus_2 import Terminus2
    from contextbench.harbor.agents import Terminus2Stream

    seen: dict = {}

    def fake_init(self, logs_dir, model_name=None, *args, **kwargs):
        seen.update(kwargs)
        self.logs_dir = logs_dir

    monkeypatch.setattr(Terminus2, "__init__", fake_init)
    Terminus2Stream(tmp_path, "openai/x", context_budget_tokens=20000)
    assert seen["model_info"]["max_input_tokens"] == 20000
    assert seen["tmux_pane_width"] == 400
    seen.clear()
    given = {"max_input_tokens": 32768, "max_output_tokens": 8192}
    Terminus2Stream(tmp_path, "openai/x", model_info=given)
    assert seen["model_info"] is given


def test_terminus_records_summarizer_calls(tmp_path: Path, monkeypatch) -> None:
    pytest.importorskip("harbor")
    from harbor.agents.terminus_2.terminus_2 import Terminus2
    from contextbench.harbor.agents import Terminus2Stream

    async def fake_subagent(self, prompt, message_history, **kwargs):
        if kwargs.get("filename_suffix") == "questions":
            raise RuntimeError("hit max_tokens")
        return "resp", "ref"

    monkeypatch.setattr(Terminus2, "_run_subagent", fake_subagent)
    agent = Terminus2Stream.__new__(Terminus2Stream)
    agent._cb_subagent_calls = []
    agent._summarization_count = 3
    history = [{"role": "user", "content": "word " * 500}]
    out = asyncio.run(agent._run_subagent(prompt="summarize", message_history=history,
                                          filename_suffix="summary"))
    assert out == ("resp", "ref")
    with pytest.raises(RuntimeError):
        asyncio.run(agent._run_subagent(prompt="ask", message_history=[],
                                        filename_suffix="questions"))
    calls = agent._cb_subagent_calls
    assert [(c["summarization"], c["step"], c["ok"]) for c in calls] == [
        (3, "summary", True), (3, "questions", False)]
    assert calls[0]["tokens"] > 400 > calls[1]["tokens"]
