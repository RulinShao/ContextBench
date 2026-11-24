"""The benchmark version: one definition, recorded by every grade and shown by the CLI."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

import contextbench
from contextbench.version import BENCHMARK_VERSION, PACKAGE_VERSION

REPO = Path(__file__).resolve().parent.parent


def test_one_definition() -> None:
    assert contextbench.__benchmark_version__ == BENCHMARK_VERSION == "0.1"
    assert contextbench.__version__ == PACKAGE_VERSION
    m = re.search(r'^version = "([^"]+)"$', (REPO / "pyproject.toml").read_text(), re.M)
    assert m and m.group(1) == PACKAGE_VERSION
    assert PACKAGE_VERSION.startswith(BENCHMARK_VERSION + ".")


def test_cli_shows_it() -> None:
    res = subprocess.run([sys.executable, "-m", "contextbench.cli", "--version"],
                         capture_output=True, text=True, cwd=REPO)
    assert res.returncode == 0
    assert f"benchmark v{BENCHMARK_VERSION}" in res.stdout


def test_every_grade_records_it(tmp_path: Path) -> None:
    from contextbench.graders import grade_run
    from contextbench.harbor.reward import InvalidGrade, write_rewards
    from contextbench.tokens import SnapshotLog

    gold = {"meta": {"task_family": "kv_store"},
            "queries": [{"key": "K1", "value": "v"}]}
    root = tmp_path / "trial" / "contextbench_harness"
    log = SnapshotLog(root)
    log.record(0, [{"role": "tool", "content": "<<<ANSWER key=K1>>>\nv\n<<<ANSWER END>>>"}],
               {"kind": "sent", "budget": 1000, "reserve": 100})
    log.close(terminated_by="submit")
    r = grade_run(root, gold, budget=1000, reserve=100)
    assert r["benchmark_version"] == BENCHMARK_VERSION and r["reward"] == 1.0
    out = tmp_path / "v"
    numeric = write_rewards(tmp_path / "trial", gold, out, budget=1000, reserve=100)
    assert numeric["benchmark_version"] == float(BENCHMARK_VERSION)
    assert json.loads((out / "reward.json").read_text())["benchmark_version"] == 0.1
    full = json.loads((out / "contextbench_result.json").read_text())
    assert full["benchmark_version"] == BENCHMARK_VERSION
    bad = grade_run(tmp_path / "nothing", gold, budget=1000, reserve=100)
    assert bad["grader_valid"] == 0.0 and bad["benchmark_version"] == BENCHMARK_VERSION
    try:
        write_rewards(tmp_path / "nothing", gold, out, budget=1000)
    except InvalidGrade:
        pass
    assert json.loads((out / "contextbench_result.json").read_text())[
        "benchmark_version"] == BENCHMARK_VERSION


def test_vendored_graders_carry_it() -> None:
    from contextbench.harbor.package import _VENDORED

    assert "version.py" in _VENDORED
