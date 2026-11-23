"""Harbor verifier: grades a ContextBench trial on the host.

ContextBench tasks are graded only by this verifier. Pass it to every run::

    harbor trials start -p <task> -a <agent> ... \\
        --verifier contextbench.harbor.verifiers:ContextBenchVerifier

It never enters the container. It reads the gold from the task directory on the
host and grades the snapshots the harness wrote into the trial's host-only snapshot
root, ``<trial_dir>/contextbench_harness/`` (Harbor mounts only ``agent/``,
``verifier/`` and ``artifacts/logs/artifacts`` of the trial dir into the container),
against the budget in the task's ``task.toml`` metadata. Without this flag Harbor
runs the task's ``tests/test.sh`` instead, which refuses to produce a reward.

Two modes, chosen with ``--verifier-kwarg mode=...``:

* ``scored`` (default) -- harness snapshots only; no fallback to a trajectory or a
  report. A missing, unreadable or unrecorded snapshot, an unclosed manifest, a
  budget mismatch or an over-budget frame makes the trial invalid: no reward is
  written and :meth:`verify` raises :class:`~contextbench.harbor.reward.InvalidGrade`.
* ``oracle`` -- grades the ``final_report.txt`` written by ``solution/solve.sh``, to
  check that a task, its gold and its grader agree. It refuses unless the trial's own
  ``config.json`` (written by Harbor on the host) names Harbor's built-in ``oracle``
  agent, so an agent cannot get its report graded this way.

The per-family names are aliases, for configs that prefer to name the family.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from harbor.models.verifier.result import VerifierResult
from harbor.verifier.base import BaseVerifier

from ..tokens import HARNESS_DIRNAME
from .reward import GRADED_FROM_CODES, InvalidGrade, write_rewards

__all__ = [
    "ContextBenchVerifier",
    "KVStoreVerifier",
    "LogTriageVerifier",
    "NeedleRetentionVerifier",
    "SudokuSketchpadVerifier",
    "GRADED_FROM_CODES",
    "InvalidGrade",
    "resolve_agent_dir",
    "trial_agent_is_oracle",
]

MODES = ("scored", "oracle")


def resolve_agent_dir(trial_paths: Any, step_name: str | None = None) -> Path:
    """The agent directory of a trial: the step's, else the trial's."""
    if step_name:
        try:
            return Path(trial_paths.step_agent_dir(step_name))
        except Exception:
            pass
    return Path(trial_paths.agent_dir)


def trial_agent_is_oracle(trial_dir: Path | str) -> bool:
    """True when the trial's ``config.json`` names Harbor's built-in oracle agent."""
    try:
        cfg = json.loads((Path(trial_dir) / "config.json").read_text(encoding="utf-8"))
    except Exception:
        return False
    agent = cfg.get("agent") or {}
    return agent.get("name") == "oracle" and not agent.get("import_path")


class ContextBenchVerifier(BaseVerifier):
    """Grades any ContextBench family from the host."""

    def __init__(self, *args: Any, gold_filename: str = "gold.json",
                 mode: str = "scored", **kwargs: Any):
        super().__init__(*args, **kwargs)
        mode = str(mode).strip().lower()
        if mode not in MODES:
            raise ValueError(f"ContextBenchVerifier mode must be one of {MODES}, "
                             f"got {mode!r}")
        self._gold_filename = gold_filename
        self._mode = mode

    def _task_budget(self) -> tuple[int | None, int | None]:
        meta = dict(getattr(self.task.config, "metadata", None) or {})
        budget = meta.get("contextbench_budget_tokens")
        reserve = meta.get("contextbench_reserve_tokens")
        return (int(budget) if budget is not None else None,
                int(reserve) if reserve is not None else None)

    async def verify(self) -> VerifierResult:
        gold_path = Path(self.task.paths.tests_dir) / self._gold_filename
        trial_dir = Path(self.trial_paths.trial_dir)
        out_dir = self.trial_paths.verifier_dir
        budget, reserve = self._task_budget()
        # /logs/verifier is mounted into the agent's container during its run: drop
        # anything it may have left there before deciding anything.
        for name in ("reward.json", "reward.txt", "contextbench_result.json"):
            (Path(out_dir) / name).unlink(missing_ok=True)
        if self._mode == "oracle":
            if not trial_agent_is_oracle(trial_dir):
                raise InvalidGrade("ContextBenchVerifier mode=oracle grades only trials "
                                   "run with Harbor's built-in oracle agent (-a oracle)")
            numeric = write_rewards(resolve_agent_dir(self.trial_paths, self.step_name),
                                    gold_path, out_dir, mode="oracle")
        else:
            numeric = write_rewards(trial_dir / HARNESS_DIRNAME, gold_path, out_dir,
                                    mode="harness", budget=budget, reserve=reserve)
        return VerifierResult(rewards=numeric)


class KVStoreVerifier(ContextBenchVerifier):
    pass


class LogTriageVerifier(ContextBenchVerifier):
    pass


class NeedleRetentionVerifier(ContextBenchVerifier):
    pass


class SudokuSketchpadVerifier(ContextBenchVerifier):
    pass
