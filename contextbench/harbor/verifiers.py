"""Harbor verifiers: thin host-side wrappers around the ContextBench graders.

A packaged task already grades itself (its ``tests/test.sh`` runs the vendored
graders in the container, Harbor's default verifier). This host-side verifier is
for images without ``python3``: set ``verifier.import_path`` in a trial or job
config to ``contextbench.harbor.verifiers:ContextBenchVerifier`` (the family is read
from the gold). The per-family names are aliases, for configs that prefer to name
the family.

It never enters the container: it reads ``tests/gold.json`` from the task directory
on the host and grades the trial's agent directory with the same
:func:`contextbench.harbor.reward.write_rewards` the in-container script uses.
"""

from __future__ import annotations

from pathlib import Path
from typing import Any

from harbor.models.verifier.result import VerifierResult
from harbor.verifier.base import BaseVerifier

from .reward import GRADED_FROM_CODES, write_rewards

__all__ = [
    "ContextBenchVerifier",
    "KVStoreVerifier",
    "LogTriageVerifier",
    "NeedleRetentionVerifier",
    "SudokuSketchpadVerifier",
    "GRADED_FROM_CODES",
    "resolve_agent_dir",
]

def resolve_agent_dir(trial_paths: Any, step_name: str | None = None) -> Path:
    """The agent directory of a trial: the step's, the trial's, or a search."""
    candidates: list[Path] = []
    if step_name:
        try:
            candidates.append(Path(trial_paths.step_agent_dir(step_name)))
        except Exception:
            pass
    candidates.append(Path(trial_paths.agent_dir))
    for cand in candidates:
        if cand.is_dir() and any(cand.iterdir()):
            return cand
    trial_dir = Path(trial_paths.trial_dir)
    for pattern in ("**/agent/context_snapshots", "**/agent/trajectory.json"):
        hits = sorted(trial_dir.glob(pattern))
        if hits:
            return hits[0].parent
    return candidates[-1]


class ContextBenchVerifier(BaseVerifier):
    """Grades any ContextBench family from the host."""

    def __init__(self, *args: Any, gold_filename: str = "gold.json", **kwargs: Any):
        super().__init__(*args, **kwargs)
        self._gold_filename = gold_filename

    async def verify(self) -> VerifierResult:
        gold_path = Path(self.task.paths.tests_dir) / self._gold_filename
        agent_dir = resolve_agent_dir(self.trial_paths, self.step_name)
        numeric = write_rewards(agent_dir, gold_path, self.trial_paths.verifier_dir)
        return VerifierResult(rewards=numeric)


class KVStoreVerifier(ContextBenchVerifier):
    pass


class LogTriageVerifier(ContextBenchVerifier):
    pass


class NeedleRetentionVerifier(ContextBenchVerifier):
    pass


class SudokuSketchpadVerifier(ContextBenchVerifier):
    pass
