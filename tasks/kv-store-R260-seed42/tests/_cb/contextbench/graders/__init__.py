"""ContextBench graders: one per task family, plus the shared context readers.

Every grader takes a run directory, the parsed ``gold.json``, a grade ``mode``
(``harness``: scored runs; ``legacy``: offline re-grade of old trials; ``oracle``)
and the task's ``budget``/``reserve``, and returns a reward dict carrying
``graded_from`` -- the context source it actually read -- and ``grader_valid``.
"""

from __future__ import annotations

import json
from pathlib import Path

from .base import (
    GRADE_MODES,
    ContextSource,
    Grader,
    InvalidRun,
    read_context,
    read_final_report,
    read_snapshots,
    read_trajectory,
)
from .kv import KVStoreGrader
from .log import LogTriageGrader
from .needle import NeedleRetentionGrader
from .sudoku import SudokuSketchpadGrader

__all__ = [
    "GRADE_MODES",
    "ContextSource",
    "Grader",
    "InvalidRun",
    "GRADERS",
    "KVStoreGrader",
    "LogTriageGrader",
    "NeedleRetentionGrader",
    "SudokuSketchpadGrader",
    "grade_run",
    "grader_for",
    "read_context",
    "read_final_report",
    "read_snapshots",
    "read_trajectory",
]

GRADERS: dict[str, type[Grader]] = {
    "kv_store": KVStoreGrader,
    "log_triage": LogTriageGrader,
    "needle_retention": NeedleRetentionGrader,
    "sudoku_sketchpad": SudokuSketchpadGrader,
}


def grader_for(family: str) -> Grader:
    """The grader instance for one family."""
    try:
        return GRADERS[family]()
    except KeyError:
        raise KeyError(
            f"no grader for family {family!r}; known: {', '.join(sorted(GRADERS))}"
        ) from None


def grade_run(run_dir: Path | str, gold: dict | Path | str, *, mode: str = "harness",
              budget: int | None = None, reserve: int | None = None) -> dict:
    """Grade a run against a gold object or a ``gold.json`` path.

    The family comes from ``gold["meta"]["task_family"]``, so a grader can never be
    pointed at the wrong family's instance by accident. ``mode`` picks the one source
    read (see :mod:`contextbench.graders.base`); ``budget`` (and ``reserve``) are the
    task's, which harness and legacy grades are checked against -- a missing budget
    makes the grade invalid.
    """
    if not isinstance(gold, dict):
        gold = json.loads(Path(gold).read_text(encoding="utf-8"))
    family = (gold.get("meta") or {}).get("task_family")
    if not family:
        raise ValueError("gold.meta['task_family'] is missing: cannot pick a grader")
    return grader_for(family).grade(run_dir, gold, mode=mode, budget=budget,
                                    reserve=reserve)
