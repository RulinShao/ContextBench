"""Graders: the reward definitions, the three readers, and reference parity."""

from __future__ import annotations

import asyncio
import importlib.util
import json
import logging
import re
import sys
from pathlib import Path

import pytest

from conftest import (
    TEST_BUDGET,
    TEST_RESERVE,
    make_instance,
    read_gold,
    requires_reference_tree,
)
from contextbench import grade_run, load_instance, run
from contextbench.oracle import OracleAgent
from contextbench.graders import grader_for
from contextbench.graders.base import read_context, read_final_report
from contextbench.graders.needle import NeedleRetentionGrader


class HalfOracle(OracleAgent):
    """An oracle that handles only every other operation.

    A run that scores exactly 1.0 cannot tell two graders apart, so the parity
    checks need a run whose rewards land strictly inside (0, 1).
    """

    def __init__(self, instance_dir: Path):
        super().__init__(instance_dir)
        self._turn = 0

    def _handle(self, text: str, *, last: bool) -> tuple[str, str]:
        self._turn += 1
        if self._turn % 2 == 0:
            return "", ""
        return super()._handle(text, last=last)


def _run(instance: Path, out_dir: Path, agent) -> dict:
    return run(
        agent,
        instance,
        budget=TEST_BUDGET,
        reserve=TEST_RESERVE,
        out_dir=out_dir,
    )


# ----------------------------------------------------------------- reward definitions
def test_every_result_records_its_source(tmp_path: Path, instance: Path) -> None:
    out = tmp_path / "run"
    _run(instance, out, OracleAgent(instance))
    rewards = grade_run(out, read_gold(instance))
    assert rewards["graded_from"] == "snapshots"
    assert rewards["grader_valid"] == 1.0
    assert 0.0 <= rewards["reward"] <= 1.0


def test_a_run_with_nothing_to_grade_is_invalid_not_zero(
    tmp_path: Path, instance: Path
) -> None:
    """No terminal state and no context is not the same as a score of zero."""
    rewards = grade_run(tmp_path / "empty", read_gold(instance))
    assert rewards["grader_valid"] == 0.0
    assert rewards["graded_from"] == "none"
    assert "grader_note" in rewards


def test_partial_credit_is_partial(tmp_path: Path, instance: Path) -> None:
    out = tmp_path / "run"
    _run(instance, out, HalfOracle(instance))
    rewards = grade_run(out, read_gold(instance))
    assert 0.0 < rewards["reward"] < 1.0


def test_kv_extra_fields(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "kv_store")
    out = tmp_path / "run"
    _run(instance, out, HalfOracle(instance))
    r = grade_run(out, read_gold(instance))
    assert r["n_answered"] < r["total"]
    # Of the GETs it answered at all, the oracle was always right.
    assert r["reward_attempted"] == pytest.approx(1.0)
    assert r["reward"] == pytest.approx(r["matched"] / r["total"])
    assert r["agent_peak_tokens"] >= r["agent_mean_tokens"] > 0


def test_log_per_type_rewards(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "log_triage")
    out = tmp_path / "run"
    _run(instance, out, OracleAgent(instance))
    r = grade_run(out, read_gold(instance))
    assert r["reward_lookup"] == pytest.approx(1.0)
    assert r["reward_count"] == pytest.approx(1.0)


def test_log_lookup_ignores_the_uniqueness_tag(tmp_path: Path) -> None:
    """Lookup grading measures retrieval, not whether the model parrots the tag."""
    instance = make_instance(tmp_path / "instance", "log_triage")
    gold = read_gold(instance)
    lookup = next(q for q in gold["queries"] if q["type"] == "lookup")
    stripped = re.sub(r"\s*#[0-9a-f]+\s*$", "", lookup["answer"])
    assert stripped != lookup["answer"]

    out = tmp_path / "run"
    out.mkdir()
    (out / "trajectory.json").write_text(
        json.dumps(
            [
                {
                    "role": "assistant",
                    "content": f"<<<ANSWER qid={lookup['qid']}>>>\n{stripped}\n"
                    f"<<<ANSWER END>>>",
                }
            ]
        ),
        encoding="utf-8",
    )
    r = grade_run(out, gold)
    assert r["graded_from"] == "trajectory"
    assert r["matched"] == 1.0


def test_sudoku_versioned_and_content_rewards(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "sudoku_sketchpad")
    out = tmp_path / "run"
    _run(instance, out, OracleAgent(instance))
    r = grade_run(out, read_gold(instance))
    for key in (
        "reward_versioned",
        "reward_content",
        "reward_cell",
        "reward_final_em",
        "reward_final_cell",
    ):
        assert r[key] == pytest.approx(1.0), key
    assert r["reward"] == r["reward_content"]


def test_sudoku_refuses_a_gold_without_a_side(tmp_path: Path) -> None:
    """A larger board graded under a silent 9x9 default would look healthy."""
    instance = make_instance(tmp_path / "instance", "sudoku_sketchpad")
    out = tmp_path / "run"
    _run(instance, out, OracleAgent(instance))
    gold = read_gold(instance)
    del gold["meta"]["side"]
    with pytest.raises(ValueError, match="side"):
        grader_for("sudoku_sketchpad").grade(out, gold)


# ----------------------------------------------------------------------- needle modes
def test_needle_prefers_the_final_context(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention")
    out = tmp_path / "run"
    _run(instance, out, OracleAgent(instance))
    r = grade_run(out, read_gold(instance))
    assert r["mode"] == "final_context"
    assert r["graded_from"] == "snapshots"
    assert r["reward"] == pytest.approx(1.0)


def test_needle_falls_back_to_the_final_report(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention")
    gold = read_gold(instance)
    kept = gold["answer_lines"][: len(gold["answer_lines"]) // 2]

    out = tmp_path / "report-run"
    out.mkdir()
    (out / "final_report.txt").write_text(
        "<<<NEEDLES BEGIN>>>\n" + "\n".join(kept) + "\n<<<NEEDLES END>>>\n",
        encoding="utf-8",
    )
    r = grade_run(out, gold)
    assert r["mode"] == "final_report"
    assert r["graded_from"] == "final_report"
    assert r["matched"] == float(len(kept))
    assert r["reward"] == pytest.approx(len(kept) / len(gold["answer_lines"]))


def test_needle_report_ignores_lines_outside_the_block(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention")
    gold = read_gold(instance)
    inside, outside = gold["answer_lines"][0], gold["answer_lines"][1]

    out = tmp_path / "report-run"
    out.mkdir()
    (out / "final_report.txt").write_text(
        f"{outside}\n<<<NEEDLES BEGIN>>>\n{inside}\n<<<NEEDLES END>>>\n",
        encoding="utf-8",
    )
    r = grade_run(out, gold)
    assert r["matched"] == 1.0


def test_needle_reads_a_trajectory_as_the_final_context(tmp_path: Path) -> None:
    instance = make_instance(tmp_path / "instance", "needle_retention")
    gold = read_gold(instance)
    out = tmp_path / "traj-run"
    out.mkdir()
    (out / "trajectory.json").write_text(
        json.dumps(
            [{"role": "assistant", "content": "\n".join(gold["answer_lines"])}]
        ),
        encoding="utf-8",
    )
    r = NeedleRetentionGrader().grade(out, gold)
    assert r["graded_from"] == "trajectory"
    assert r["mode"] == "final_context"
    assert r["reward"] == pytest.approx(1.0)


# --------------------------------------------------------------------- source readers
def test_reader_preference_order(tmp_path: Path, instance: Path) -> None:
    out = tmp_path / "run"
    _run(instance, out, OracleAgent(instance))
    (out / "trajectory.json").write_text(json.dumps([]), encoding="utf-8")
    assert read_context(out).graded_from == "snapshots"


def test_final_report_falls_back_to_assistant_messages(tmp_path: Path) -> None:
    out = tmp_path / "run"
    out.mkdir()
    (out / "trajectory.json").write_text(
        json.dumps(
            [
                {"role": "user", "content": "an operation"},
                {"role": "assistant", "content": "the report"},
            ]
        ),
        encoding="utf-8",
    )
    assert read_final_report(out) == "the report"


# ------------------------------------------------------------------- reference parity
_REFERENCE_GRADERS = {
    "kv_store": ("kv_store/grader.py", "KVStoreTrajectoryGrader"),
    "log_triage": ("log_triage/grader.py", "LogTriageTrajectoryGrader"),
    "sudoku_sketchpad": ("sudoku_sketchpad/grader.py", "SudokuSketchpadGrader"),
    "needle_retention": ("grader_unified.py", "NeedleRetentionTrajectoryGrader"),
}


class _Paths:
    def __init__(self, tests_dir: Path):
        self.tests_dir = tests_dir


class _Task:
    def __init__(self, tests_dir: Path):
        self.paths = _Paths(tests_dir)


class _TrialPaths:
    def __init__(self, agent_dir: Path):
        self.agent_dir = agent_dir
        self.trial_dir = agent_dir


def _reference_rewards(root: Path, family: str, gold_dir: Path, run_dir: Path) -> dict:
    rel, clsname = _REFERENCE_GRADERS[family]
    path = root / rel
    if not path.is_file():
        pytest.skip(f"reference tree has no {rel}")
    # grader_witness is imported as a sibling module by every reference grader.
    if str(root) not in sys.path:
        sys.path.insert(0, str(root))
    spec = importlib.util.spec_from_file_location(f"_ref_grader_{family}", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)

    grader = object.__new__(getattr(module, clsname))
    grader._gold_filename = "gold.json"
    grader.task = _Task(gold_dir)
    grader.trial_paths = _TrialPaths(run_dir)
    grader.step_name = None
    grader.logger = logging.getLogger(f"reference.{family}")
    return asyncio.run(grader.verify()).rewards


@pytest.mark.parametrize("agent_cls", [OracleAgent, HalfOracle])
def test_matches_the_reference_grader(
    tmp_path: Path, family: str, agent_cls
) -> None:
    """The same snapshots must score the same under the grader of record."""
    root = requires_reference_tree()
    instance = make_instance(tmp_path / "instance", family)
    out = tmp_path / "run"
    _run(instance, out, agent_cls(instance))
    gold = read_gold(instance)

    if family == "needle_retention":
        # The reference needle grader reads an ATIF trajectory.json as the final
        # retained context; hand it the run's last snapshot in that form, and grade
        # the same file with ours.
        snapshots = sorted((out / "context_snapshots").glob("turn-*.json"))
        final = json.loads(snapshots[-1].read_text(encoding="utf-8"))["messages"]
        traj_dir = tmp_path / "traj"
        traj_dir.mkdir()
        (traj_dir / "trajectory.json").write_text(
            json.dumps(final), encoding="utf-8"
        )
        ours = NeedleRetentionGrader().grade(traj_dir, gold)
        theirs = _reference_rewards(root, family, instance, traj_dir)
    else:
        ours = grade_run(out, gold)
        theirs = _reference_rewards(root, family, instance, out)

    shared = sorted(set(ours) & set(theirs))
    assert "reward" in shared
    for key in shared:
        assert ours[key] == pytest.approx(theirs[key]), key


def test_reference_grader_agrees_on_a_partial_run(tmp_path: Path) -> None:
    """A sanity guard: the parity check above must be scoring a partial run."""
    instance = make_instance(tmp_path / "instance", "kv_store")
    out = tmp_path / "run"
    _run(instance, out, HalfOracle(instance))
    rewards = grade_run(out, read_gold(instance))
    assert 0.0 < rewards["reward"] < 1.0


@pytest.mark.parametrize("stated,ok", [
    ("5", True), ("count: 5", True), ("-5", False), ("5.9", False),
    ("5 or 6", False), ("15", False), ("50", False), ("none", False),
])
def test_log_count_needs_exactly_the_gold_number(tmp_path: Path, stated: str,
                                                  ok: bool) -> None:
    """A count answer must state one complete number equal to the gold."""
    from contextbench.graders.log import _count_correct

    assert _count_correct("5", {stated}) is ok
