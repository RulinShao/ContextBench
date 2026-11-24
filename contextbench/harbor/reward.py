"""Grade a ContextBench run and write Harbor's reward files.

Used by the host-side verifier (``contextbench.harbor.verifiers:ContextBenchVerifier``)
and, as ``python -m contextbench.harbor.reward``, for grading or re-grading a trial
offline. Nothing here runs inside the agent's container: the snapshots a scored run
is graded from live in the trial's host-only snapshot root
(``<trial_dir>/contextbench_harness``), and the task's ``tests/test.sh`` refuses to
produce a reward.

Harbor's reward dict must be numeric (its job-level mean sums every key), so the
string fields are encoded: ``graded_from_code`` (3 snapshots, 4 legacy_snapshots,
1 final_report, 0 none), ``grade_mode_code`` (0 harness, 1 legacy, 2 oracle) and
``terminated_by_code`` (index into ``contextbench.stream.TERMINATED_BY``, -1
unknown). ``budget_tokens``/``reserve_tokens`` are the task's budget the run was
checked against. The unencoded result goes to ``contextbench_result.json`` next to
``reward.json``.

A run that cannot be graded is **invalid**, not zero: :func:`write_rewards` removes
any ``reward.json``/``reward.txt`` already in the output directory, writes only
``contextbench_result.json`` (with the reason), and raises :class:`InvalidGrade`; the
command line exits with status 2.

Pure standard library.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

from ..graders import grade_run
from ..graders.base import GRADE_MODES, InvalidRun, resolve_snapshot_root
from ..stream import TERMINATED_BY
from .turn_source import write_text_nofollow

__all__ = ["GRADED_FROM_CODES", "GRADE_MODE_CODES", "InvalidGrade", "harbor_rewards",
           "task_budget", "write_rewards", "main"]

GRADED_FROM_CODES = {"snapshots": 3, "legacy_snapshots": 4, "trajectory": 2,
                     "final_report": 1, "none": 0}
GRADE_MODE_CODES = {"harness": 0, "legacy": 1, "oracle": 2}

STREAM_RECORD_NAME = "interactive_stream.json"

#: Files a grade writes; all are removed before grading, so none can be stale.
_OUTPUTS = ("reward.json", "reward.txt", "contextbench_result.json")


class InvalidGrade(RuntimeError):
    """The run could not be graded; no reward was written. ``result`` has the detail."""

    def __init__(self, message: str, result: dict | None = None):
        super().__init__(message)
        self.result = result or {}


def _stream_record(run_dir: Path, mode: str) -> dict[str, Any]:
    if mode == "harness":
        try:
            path = resolve_snapshot_root(run_dir) / STREAM_RECORD_NAME
        except InvalidRun:
            return {}
    elif mode == "legacy":
        path = run_dir / STREAM_RECORD_NAME
    else:
        return {}
    if not path.is_file():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return {}


def harbor_rewards(run_dir: Path | str, gold: dict, *, mode: str = "harness",
                   budget: int | None = None,
                   reserve: int | None = None) -> tuple[dict, dict]:
    """``(numeric reward dict, full result dict)`` for one run.

    ``run_dir``: the snapshot root (or the trial dir holding it) for ``harness``; the
    old-layout agent dir for ``legacy``; the oracle's agent dir for ``oracle``.
    """
    run_dir = Path(run_dir)
    rewards = grade_run(run_dir, gold, mode=mode, budget=budget, reserve=reserve)
    stream = _stream_record(run_dir, mode)
    numeric: dict[str, float | int] = {
        k: v for k, v in rewards.items()
        if isinstance(v, (int, float)) and not isinstance(v, bool)
    }
    numeric["graded_from_code"] = GRADED_FROM_CODES.get(str(rewards.get("graded_from")), 0)
    numeric["grade_mode_code"] = GRADE_MODE_CODES[mode]
    # The harness's closing manifest line is the record of the terminal reason.
    terminated_by = rewards.get("terminated_by") or stream.get("terminated_by")
    numeric["terminated_by_code"] = (
        TERMINATED_BY.index(terminated_by) if terminated_by in TERMINATED_BY else -1
    )
    for key in ("n_ops_delivered", "n_ops_total", "n_refusals"):
        if isinstance(stream.get(key), int):
            numeric[key] = stream[key]
    full = {
        "rewards": rewards,
        "valid": bool(rewards.get("grader_valid")),
        "grade_mode": mode,
        "graded_from": rewards.get("graded_from"),
        "terminated_by": terminated_by,
        "run_dir": str(run_dir),
        "stream": {k: v for k, v in stream.items() if k != "log"},
    }
    return numeric, full


def write_rewards(run_dir: Path | str, gold: dict | Path | str, out_dir: Path | str, *,
                  mode: str = "harness", budget: int | None = None,
                  reserve: int | None = None) -> dict:
    """Grade, write ``reward.json`` + ``contextbench_result.json``, return numeric.

    An invalid grade writes only ``contextbench_result.json`` and raises
    :class:`InvalidGrade`.
    """
    if not isinstance(gold, dict):
        gold = json.loads(Path(gold).read_text(encoding="utf-8"))
    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)
    for name in _OUTPUTS:
        (out / name).unlink(missing_ok=True)
    numeric, full = harbor_rewards(run_dir, gold, mode=mode, budget=budget,
                                   reserve=reserve)
    # The verifier dir is mounted into the agent's container during its run: never
    # write through a link left there.
    write_text_nofollow(out / "contextbench_result.json",
                        json.dumps(full, indent=2, default=str) + "\n", root=out)
    if not full["valid"]:
        note = full["rewards"].get("grader_note") or "invalid grade"
        raise InvalidGrade(f"ContextBench run is invalid, no reward written: {note}",
                           full)
    write_text_nofollow(out / "reward.json", json.dumps(numeric, indent=2) + "\n",
                        root=out)
    return numeric


def task_budget(task_dir: Path | str) -> tuple[int | None, int | None]:
    """``(budget, reserve)`` from a task's ``task.toml`` ``[metadata]``.

    Falls back to ``tests/feasibility_receipt.json``; ``(None, None)`` if neither
    names a budget.
    """
    task_dir = Path(task_dir)
    toml_path = task_dir / "task.toml"
    if toml_path.is_file():
        text = toml_path.read_text(encoding="utf-8")
        try:
            import tomllib

            meta = tomllib.loads(text).get("metadata") or {}
        except ModuleNotFoundError:  # Python 3.10
            meta = {m.group(1): int(m.group(2)) for m in re.finditer(
                r"^(contextbench_(?:budget|reserve)_tokens)\s*=\s*(\d+)\s*$", text, re.M)}
        if "contextbench_budget_tokens" in meta:
            reserve = meta.get("contextbench_reserve_tokens")
            return int(meta["contextbench_budget_tokens"]), \
                (int(reserve) if reserve is not None else None)
    receipt = task_dir / "tests" / "feasibility_receipt.json"
    if receipt.is_file():
        obj = json.loads(receipt.read_text(encoding="utf-8"))
        if obj.get("budget") is not None:
            return int(obj["budget"]), (int(obj["reserve"])
                                        if obj.get("reserve") is not None else None)
    return None, None


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--run-dir", type=Path, required=True,
                    help="harness: the trial dir (or its contextbench_harness/); an "
                         "agent logs dir is refused. legacy: the old trial's agent/ "
                         "dir. oracle: the oracle trial's agent/ dir")
    ap.add_argument("--mode", choices=GRADE_MODES, default="harness")
    ap.add_argument("--task-dir", type=Path, default=None,
                    help="the task directory: gold and budget are read from it")
    ap.add_argument("--gold", type=Path, default=None)
    ap.add_argument("--budget", type=int, default=None)
    ap.add_argument("--reserve", type=int, default=None)
    ap.add_argument("--out-dir", type=Path, required=True)
    a = ap.parse_args(argv)
    budget, reserve = a.budget, a.reserve
    if a.task_dir is not None:
        tb, tr = task_budget(a.task_dir)
        budget = budget if budget is not None else tb
        reserve = reserve if reserve is not None else tr
    gold = a.gold or (a.task_dir / "tests" / "gold.json" if a.task_dir else None)
    if gold is None:
        ap.error("--gold or --task-dir is required")
    try:
        numeric = write_rewards(a.run_dir, gold, a.out_dir, mode=a.mode, budget=budget,
                                reserve=reserve)
    except InvalidGrade as exc:
        print(str(exc), file=sys.stderr)
        return 2
    print(json.dumps(numeric))
    return 0


if __name__ == "__main__":
    sys.exit(main())
