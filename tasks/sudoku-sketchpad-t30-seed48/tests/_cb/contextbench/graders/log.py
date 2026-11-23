"""Grader for *Incident Log Triage*: process-graded, ANSWER-block based.

The agent answers each ``QUERY <n>`` by emitting an ANSWER block::

    <<<ANSWER qid=0>>>
    timeout retry connection refused #ab12cd34      (lookup)
    <<<ANSWER END>>>

Every per-turn context frame is scanned for ANSWER blocks in what the agent produced
(assistant messages and tool output; never the instruction or the ops). Each query
has **one** answer: the last block for its qid, in turn order and then in message
order within the turn, so a later answer replaces an earlier one. The score is the
fraction of gold queries answered correctly. Matching is per type:

* ``lookup`` -- the answer must equal the gold message after whitespace
  normalization (a list of candidates, or extra text around the message, is wrong);
* ``count`` -- the answer must state exactly one number, equal to the gold integer.

A gold message ends in a random ``#<hex>`` uniqueness tag that a model treats as a
noise id and usually drops. Lookup grading measures retrieval -- did the agent
surface the right log line's message -- not whether it parrots that tag, so a
trailing tag is stripped from both the gold and the answer before matching.

Rewards: ``reward``, ``reward_lookup`` / ``reward_count`` per type,
``reward_attempted`` over the queries answered at all, and the per-turn context size.
"""

from __future__ import annotations

import re

from .base import ContextSource, Grader, InvalidRun, normalize

__all__ = ["LogTriageGrader", "ANSWER_RE"]

ANSWER_RE = re.compile(
    r"<<<\s*ANSWER\s+qid\s*=\s*([0-9]+)\s*>>>(.*?)<<<\s*ANSWER\s+END\s*>>>",
    re.DOTALL | re.IGNORECASE,
)

#: The trailing uniqueness tag of a gold message.
_TAG_RE = re.compile(r"\s*#[0-9a-f]+\s*$")


#: A complete number: optional sign, digits, optional decimal part.
_NUMBER_RE = re.compile(r"[-+]?\d+(?:\.\d+)?")


def _count_correct(want: str, answer: str) -> bool:
    """A count is correct when the answer states exactly one number and it equals the
    gold integer. ``-5``, ``5.9`` or a hedge such as ``5 or 6`` is not ``5``."""
    return _NUMBER_RE.findall(answer) == [want]


def _lookup_correct(want: str, answer: str) -> bool:
    """The answer is the gold message (normalized, trailing ``#hex`` tag optional)."""
    core = _TAG_RE.sub("", normalize(want)).strip()
    if not core:
        return False
    return _TAG_RE.sub("", normalize(answer)).strip() == core


class LogTriageGrader(Grader):
    family = "log_triage"

    def score(self, source: ContextSource, gold: dict) -> dict:
        queries = gold.get("queries") or []
        total = len(queries)
        if total == 0:
            raise InvalidRun("gold has no queries")

        answers = self._collect(source)
        correct = answered = 0
        by_type_total: dict[str, int] = {"lookup": 0, "count": 0}
        by_type_correct: dict[str, int] = {"lookup": 0, "count": 0}
        for q in queries:
            qid = str(q["qid"])
            qtype = q.get("type", "lookup")
            want = normalize(str(q["answer"]))
            by_type_total[qtype] = by_type_total.get(qtype, 0) + 1
            got = answers.get(qid)
            if got is None:
                continue
            answered += 1
            ok = (
                _count_correct(want, got)
                if qtype == "count"
                else _lookup_correct(want, got)
            )
            if ok:
                correct += 1
                by_type_correct[qtype] = by_type_correct.get(qtype, 0) + 1

        def _rate(t: str) -> float:
            n = by_type_total.get(t, 0)
            return (by_type_correct.get(t, 0) / n) if n else 0.0

        return {
            "reward": correct / total,
            "reward_lookup": _rate("lookup"),
            "reward_count": _rate("count"),
            "reward_attempted": (correct / answered) if answered else 0.0,
            "n_answered": float(answered),
            "matched": float(correct),
            "total": float(total),
        }

    @staticmethod
    def _collect(source: ContextSource) -> dict[str, str]:
        """``qid -> normalized answer``: the last ANSWER block for each qid."""
        answers: dict[str, str] = {}
        for text in source.answer_texts():
            for qid, val in ANSWER_RE.findall(text):
                answers[qid.strip()] = normalize(val)
        return answers
