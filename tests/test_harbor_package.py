"""`contextbench package`: the Harbor task layout, identity, gold isolation, oracle."""

from __future__ import annotations

import json
import re
import shutil
import tomllib
from pathlib import Path

import pytest

from conftest import TEST_BUDGET, TEST_RESERVE, make_instance
from contextbench import load_instance
from contextbench.cli import main as cli_main
from contextbench.graders import grade_run
from contextbench.graders.base import atif_messages, read_trajectory
from contextbench.harbor import (
    ENV_STREAM_COUNT,
    ENV_STREAM_PATH,
    ENV_STREAM_SHA256,
    canonical_sha256,
)
from contextbench.harbor.package import build_task

IMAGE = "python:3.12-slim"


def _build(instance: Path, out: Path, **kw) -> Path:
    kw.setdefault("budget", TEST_BUDGET)
    kw.setdefault("reserve", TEST_RESERVE)
    # The suite's small levels are sized for runner tests, not for the gate.
    kw.setdefault("require_feasible", False)
    return build_task(instance, out, image=IMAGE, **kw)


def test_layout_and_task_toml(tmp_path: Path, instance: Path, family: str) -> None:
    task = _build(instance, tmp_path / "tasks")
    for rel in ("instruction.md", "task.toml", "environment/stream/chunks.jsonl",
                "tests/gold.json", "tests/meta.json", "tests/feasibility_receipt.json",
                "tests/test.sh", "solution/solve.sh"):
        assert (task / rel).is_file(), rel

    cfg = tomllib.loads((task / "task.toml").read_text())
    inst = load_instance(instance)
    records = [json.loads(ln) for ln in (instance / "chunks.jsonl").read_text().splitlines()
               if ln.strip()]
    env = cfg["environment"]
    assert env["docker_image"] == IMAGE
    assert env["workdir"] == "/app"
    assert env["env"][ENV_STREAM_COUNT] == str(inst.n_ops)
    assert env["env"][ENV_STREAM_SHA256] == canonical_sha256(records)
    assert env["env"][ENV_STREAM_PATH] == "/app/stream/chunks.jsonl"
    assert cfg["metadata"]["contextbench_family"] == family
    assert cfg["metadata"]["contextbench_stream_count"] == inst.n_ops
    # The stream is the instance's, byte for byte.
    assert (task / "environment/stream/chunks.jsonl").read_bytes() == \
        (instance / "chunks.jsonl").read_bytes()


def test_gold_never_in_the_container_tree(tmp_path: Path, instance: Path) -> None:
    """Only environment/ is uploaded for the agent; it must hold nothing but ops."""
    task = _build(instance, tmp_path / "tasks")
    files = sorted(p.relative_to(task / "environment").as_posix()
                   for p in (task / "environment").rglob("*") if p.is_file())
    assert files == ["stream/chunks.jsonl"]
    gold = json.loads((instance / "gold.json").read_text())
    stream_text = (task / "environment/stream/chunks.jsonl").read_text()
    for q in gold.get("queries") or []:
        # A GET key appears in the stream; its value must not be next to "GET".
        if "value" in q:
            assert f"GET {q['key']} = " not in stream_text


def test_instruction_is_bash_scaffold(tmp_path: Path, instance: Path) -> None:
    task = _build(instance, tmp_path / "tasks")
    text = (task / "instruction.md").read_text()
    assert "echo READY_FOR_NEXT_OP" in text
    assert "{initial_block}" not in text


def test_method_section_appended_verbatim(tmp_path: Path, kv_instance: Path) -> None:
    skill = "## My method\n\nKeep a notes file.\n"
    task = _build(kv_instance, tmp_path / "tasks", method_section=skill,
                  method_name="demo")
    text = (task / "instruction.md").read_text()
    assert text.endswith("\n" + skill)
    assert tomllib.loads((task / "task.toml").read_text())["metadata"][
        "contextbench_method_section"] == "demo"


def test_oracle_solution_scores_one(tmp_path: Path, instance: Path, family: str) -> None:
    """solve.sh's report, graded as Harbor would find it, is a perfect score."""
    task = _build(instance, tmp_path / "tasks")
    solve = (task / "solution/solve.sh").read_text()
    m = re.search(r"<<'(\w+)'\n(.*)\n\1\n", solve, re.DOTALL)
    assert m, "solve.sh has no heredoc"
    agent_dir = tmp_path / "trial" / "agent"
    agent_dir.mkdir(parents=True)
    (agent_dir / "final_report.txt").write_text(m.group(2) + "\n")
    rewards = grade_run(tmp_path / "trial", task / "tests" / "gold.json")
    assert rewards["graded_from"] == "final_report"
    assert rewards["reward"] == pytest.approx(1.0)


def test_infeasible_instance_refused(tmp_path: Path) -> None:
    inst = make_instance(tmp_path / "tiny", "kv_store", records=100, queries=2)
    with pytest.raises(ValueError, match="feasibility"):
        _build(inst, tmp_path / "tasks", require_feasible=True)


def test_existing_task_needs_overwrite(tmp_path: Path, kv_instance: Path) -> None:
    _build(kv_instance, tmp_path / "tasks", name="t")
    with pytest.raises(FileExistsError):
        _build(kv_instance, tmp_path / "tasks", name="t")
    _build(kv_instance, tmp_path / "tasks", name="t", overwrite=True)


def test_cli_package(tmp_path: Path, kv_instance: Path, capsys) -> None:
    rc = cli_main(["package", "--instance-dir", str(kv_instance), "--out-dir",
                   str(tmp_path / "tasks"), "--image", IMAGE, "--name", "cli-task",
                   "--budget", str(TEST_BUDGET), "--reserve", str(TEST_RESERVE),
                   "--allow-infeasible"])
    assert rc == 0
    out = json.loads(capsys.readouterr().out)
    assert Path(out["task_dir"]).name == "cli-task"
    assert (tmp_path / "tasks" / "cli-task" / "task.toml").is_file()


def test_atif_trajectory_is_readable(tmp_path: Path) -> None:
    """An ATIF trajectory flattens to messages with ops as user turns."""
    steps = [
        {"step_id": 1, "source": "user", "message": "instruction"},
        {"step_id": 2, "source": "user", "message": "=== op 1 ===\nGET K1"},
        {"step_id": 3, "source": "agent", "message": "Analysis: answer",
         "observation": {"results": [{"content": "<<<ANSWER key=K1>>>\nv\n<<<ANSWER END>>>"}]}},
    ]
    msgs = atif_messages(steps)
    assert [m["role"] for m in msgs] == ["user", "user", "assistant", "tool"]
    (tmp_path / "agent").mkdir()
    (tmp_path / "agent" / "trajectory.json").write_text(json.dumps({"steps": steps}))
    src = read_trajectory(tmp_path)
    assert src is not None and src.graded_from == "trajectory"
    assert "<<<ANSWER key=K1>>>" in src.all_text()


@pytest.fixture
def kv_instance(tmp_path: Path) -> Path:
    return make_instance(tmp_path / "kv", "kv_store")


def test_json_tool_output_is_decoded_for_grading(tmp_path: Path) -> None:
    """A harness that renders tool output as JSON (escaped < >) is still graded."""
    gold = {"meta": {"task_family": "kv_store"},
            "queries": [{"key": "K1", "value": "alpha beta #1"}]}
    obs = json.dumps({"returncode": 0,
                      "output": "<<<ANSWER key=K1>>>\nalpha beta #1\n<<<ANSWER END>>>\n"})
    snap = tmp_path / "agent" / "context_snapshots"
    snap.mkdir(parents=True)
    (snap / "turn-0000.json").write_text(json.dumps(
        {"step": 0, "tokens": 10, "messages": [
            {"role": "tool", "content": obs.replace("<", "\\u003c").replace(">", "\\u003e")}]}))
    rewards = grade_run(tmp_path, gold)
    assert rewards["reward"] == 1.0
