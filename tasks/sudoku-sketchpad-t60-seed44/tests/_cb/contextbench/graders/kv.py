"""Grader for *Key-Value Store*: process-graded, ANSWER-block based.

The agent answers each ``GET <key>`` by emitting an ANSWER block::

    <<<ANSWER key=K00007>>>
    <the value it stored for K00007>
    <<<ANSWER END>>>

Every per-turn context frame is scanned for ANSWER blocks in what the agent produced
(assistant messages and tool output; never the instruction or the ops). Each key has
**one** answer: the last block for it, in turn order and then in message order
within the turn, so a later answer replaces an earlier one. The answer is correct
when it equals the gold value after whitespace normalization; the score is the
fraction of gold GET queries answered correctly.

Reading the whole per-turn series rather than the final context is what makes the
mechanisms comparable on one number: an agent that parks values outside its context
and surfaces the queried one only transiently has the value in the snapshot of the
GET turn, but not in its final context.

Rewards:

* ``reward`` -- fraction of GET queries whose (last) answer is the correct value;
* ``reward_attempted`` -- of the GETs answered at all, the fraction correct;
* ``n_answered`` -- how many distinct gold GETs got any ANSWER block;
* ``agent_peak_tokens`` / ``agent_mean_tokens`` -- per-turn context size.
"""

from __future__ import annotations

import re

from .base import ContextSource, Grader, InvalidRun, normalize

__all__ = ["KVStoreGrader", "ANSWER_RE"]

#: ``<<<ANSWER key=K00007>>> ... <<<ANSWER END>>>``; the key may carry spaces.
ANSWER_RE = re.compile(
    r"<<<\s*ANSWER\s+key\s*=\s*([^\s>]+)\s*>>>(.*?)<<<\s*ANSWER\s+END\s*>>>",
    re.DOTALL | re.IGNORECASE,
)


class KVStoreGrader(Grader):
    family = "kv_store"

    def score(self, source: ContextSource, gold: dict) -> dict:
        queries = gold.get("queries") or []
        total = len(queries)
        if total == 0:
            raise InvalidRun("gold has no queries")

        answers = self._collect(source)
        correct = 0
        answered = 0
        for q in queries:
            key = normalize(str(q["key"]))
            want = normalize(str(q["value"]))
            got = answers.get(key)
            if got is not None:
                answered += 1
                if got == want:
                    correct += 1

        return {
            "reward": correct / total,
            "reward_attempted": (correct / answered) if answered else 0.0,
            "n_answered": float(answered),
            "matched": float(correct),
            "total": float(total),
        }

    @staticmethod
    def _collect(source: ContextSource) -> dict[str, str]:
        """``key -> normalized answer``: the last ANSWER block for each key."""
        answers: dict[str, str] = {}
        for text in source.answer_texts():
            for key, val in ANSWER_RE.findall(text):
                answers[normalize(key)] = normalize(val)
        return answers
