"""Grader for *Needle Retention*: what is still in the context at the end.

The reward is the fraction of gold needle lines present verbatim in the agent's
final retained context. Two modes, and which one ran is recorded as ``mode`` and
``graded_from``:

* ``final_context`` (scored runs) -- the last per-turn snapshot is the retained
  context. Every message of it counts, user turns included: keeping the delivered
  lines in context is what this family measures.
* ``final_report`` (oracle mode only) -- the lines between ``<<<NEEDLES BEGIN>>>``
  and ``<<<NEEDLES END>>>`` in the oracle's ``final_report.txt``. It checks that the
  task, its gold and this grader agree; it is never a score for an agent.

Rewards: ``reward``, ``matched``, ``total``, ``mode``, ``graded_from``.
"""

from __future__ import annotations

import re

from .base import ContextSource, Grader, InvalidRun, messages_text, normalize

__all__ = ["NeedleRetentionGrader", "NEEDLES_BLOCK_RE", "extract_reported_needles"]

#: The block the oracle's report carries the kept lines in.
NEEDLES_BLOCK_RE = re.compile(
    r"<<<\s*NEEDLES\s+BEGIN\s*>>>(.*?)<<<\s*NEEDLES\s+END\s*>>>",
    re.DOTALL | re.IGNORECASE,
)


def extract_reported_needles(text: str) -> set[str]:
    """The normalized lines inside every ``NEEDLES`` block of ``text``."""
    lines: set[str] = set()
    for block in NEEDLES_BLOCK_RE.findall(text or ""):
        for line in block.splitlines():
            if line.strip():
                lines.add(normalize(line))
    return lines


class NeedleRetentionGrader(Grader):
    family = "needle_retention"

    def score(self, source: ContextSource, gold: dict) -> dict:
        gold_lines = {normalize(s) for s in gold.get("answer_lines") or []}
        total = len(gold_lines)
        if total == 0:
            raise InvalidRun("gold has no answer_lines")
        if source.graded_from == "final_report":
            present = extract_reported_needles(messages_text(source.final_frame))
            mode = "final_report"
        else:
            present = self._context_lines(messages_text(source.final_frame))
            mode = "final_context"
        matched = gold_lines & present
        return {
            "reward": len(matched) / total,
            "matched": float(len(matched)),
            "total": float(total),
            "mode": mode,
        }

    @staticmethod
    def _context_lines(text: str) -> set[str]:
        return {normalize(line) for line in text.splitlines() if line.strip()}
