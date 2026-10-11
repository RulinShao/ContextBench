"""An agent that answers from gold: a task self-check, NOT a method or a baseline.

    +------------------------------------------------------------------------+
    | USE THIS ONLY TO CHECK THAT GENERATED TASKS ARE CORRECT.               |
    |                                                                        |
    | The oracle reads gold.json, so it sees every answer in advance. Its    |
    | score says nothing about context management and must never be         |
    | reported as a result, compared against agents, or drawn as a ceiling   |
    | in a figure. It exists so that a task, the delivery protocol and the   |
    | graders can be checked without a model: the test suite, `contextbench  |
    | run`, and the Harbor packages' solution/solve.sh all use it for that.  |
    +------------------------------------------------------------------------+

The oracle plays the ideal context policy for each family: it answers every query
correctly, it keeps exactly what the reward needs and nothing else, and it holds its
context flat across any horizon. A run of the oracle that does not score 1.0 means
the instance, the protocol or a grader is broken, not the agent -- which is what
makes it the right fixture for the test suite. It makes no model calls.

Per family:

* **kv_store** -- answers each GET with the gold value in an ANSWER block;
* **log_triage** -- answers each QUERY with the gold answer in an ANSWER block;
* **needle_retention** -- replaces each delivered chunk with its needle lines, so
  the final context holds every needle and no filler, and prints the kept lines as
  a final report as well;
* **sudoku_sketchpad** -- reprints the correct panel for the new version after each
  move, keeping only the latest one.

It submits after the last operation rather than asking for another, which exercises
the submit path: the early-submit refusal is exercised by the test suite's own
scripted agent.
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any

from .stream import ADVANCE_MARKER, SUBMIT_MARKER
from .tasks.sudoku_sketchpad.generate import SYMBOLS

__all__ = ["OracleAgent"]

_REMAINING_RE = re.compile(r"\((\d+) op\(s\) remaining after this\)")
_GET_RE = re.compile(r"^GET\s+(\S+)", re.MULTILINE)
_QUERY_RE = re.compile(r"^QUERY\s+(\d+):", re.MULTILINE)
_NEEDLE_RE = re.compile(r"^\[n\d+i\d+#[0-9a-f]+\].*$", re.MULTILINE)
_MOVE_RE = re.compile(r"increment the VERSION line to (\d+)", re.IGNORECASE)
_NEW_BOARD_RE = re.compile(r"becomes version (\d+)", re.IGNORECASE)


class OracleAgent:
    """Reads the gold answers. For checking generated tasks only; never an evaluated agent.

    Any score below 1.0 means the instance, the protocol or a grader is broken.
    """

    def __init__(self, instance_dir: Path | str):
        d = Path(instance_dir)
        self.gold: dict = json.loads((d / "gold.json").read_text(encoding="utf-8"))
        meta = self.gold.get("meta") or json.loads(
            (d / "meta.json").read_text(encoding="utf-8")
        )
        self.family: str = meta["task_family"]
        self.side: int = int(meta.get("side", 0) or 0)

        queries = self.gold.get("queries") or []
        self._values: dict[str, str] = {
            str(q["key"]): str(q["value"]) for q in queries if "key" in q
        }
        self._answers: dict[str, str] = {
            str(q["qid"]): str(q["answer"]) for q in queries if "answer" in q
        }
        self._panels: dict[int, str] = {}
        if self.family == "sudoku_sketchpad":
            self._panels = _render_gold_panels(self.gold, self.side)

        self._messages: list[dict[str, Any]] = []
        self._kept_needles: list[str] = []

    # -------------------------------------------------------------- the protocol
    def reset(self, system: str, instruction: str) -> None:
        self._messages = [
            {"role": "system", "content": system},
            {"role": "user", "content": instruction},
        ]
        self._kept_needles = []

    def context(self) -> list[dict]:
        return self._messages

    def on_user_turn(self, text: str) -> str:
        last = _remaining(text) == 0
        body, keep_user = self._handle(text, last=last)
        marker = SUBMIT_MARKER if last else ADVANCE_MARKER
        reply = (body + "\n" if body else "") + marker

        # The oracle keeps a flat context: it drops the previous turn's traffic and
        # retains only what the reward reads back.
        self._messages = self._messages[:2]
        if self._kept_needles:
            self._messages.append(
                {"role": "assistant", "content": "\n".join(self._kept_needles)}
            )
        if keep_user:
            self._messages.append({"role": "user", "content": keep_user})
        self._messages.append({"role": "assistant", "content": reply})
        return reply

    # ------------------------------------------------------------- per family
    def _handle(self, text: str, *, last: bool) -> tuple[str, str]:
        """Return ``(reply body, user text to retain)`` for one delivered turn."""
        if self.family == "kv_store":
            return self._kv(text), ""
        if self.family == "log_triage":
            return self._log(text), ""
        if self.family == "needle_retention":
            return self._needle(text, last=last), ""
        if self.family == "sudoku_sketchpad":
            return self._sudoku(text), ""
        return "", ""

    def _kv(self, text: str) -> str:
        blocks = []
        for key in _GET_RE.findall(text):
            value = self._values.get(key)
            if value is not None:
                blocks.append(
                    f"<<<ANSWER key={key}>>>\n{value}\n<<<ANSWER END>>>"
                )
        return "\n".join(blocks)

    def _log(self, text: str) -> str:
        blocks = []
        for qid in _QUERY_RE.findall(text):
            answer = self._answers.get(qid)
            if answer is not None:
                blocks.append(
                    f"<<<ANSWER qid={qid}>>>\n{answer}\n<<<ANSWER END>>>"
                )
        return "\n".join(blocks)

    def _needle(self, text: str, *, last: bool) -> str:
        """Keep this chunk's needle lines; on the last chunk also report them."""
        for line in _NEEDLE_RE.findall(text):
            self._kept_needles.append(line)
        if last:
            kept = "\n".join(self._kept_needles)
            return f"<<<NEEDLES BEGIN>>>\n{kept}\n<<<NEEDLES END>>>"
        return f"kept {len(self._kept_needles)} needle line(s)."

    def _sudoku(self, text: str) -> str:
        m = _MOVE_RE.search(text) or _NEW_BOARD_RE.search(text)
        if not m:
            return ""
        return self._panels.get(int(m.group(1)), "")


# --------------------------------------------------------------------- gold panels
def _render_gold_panels(gold: dict, side: int) -> dict[int, str]:
    """Fold the gold deltas into one rendered panel per version."""
    from .graders.sudoku import gold_states

    panels: dict[int, str] = {}
    for version, cells in gold_states(gold):
        panels[version] = _render(cells, side, version)
    return panels


def _render(cells: dict[str, str], side: int, version: int) -> str:
    lines = ["<<<SKETCHPAD BEGIN>>>", f"VERSION: {version}"]
    for r in range(1, side + 1):
        segs = []
        for c in range(1, side + 1):
            raw = cells.get(f"r{r}c{c}", ".")
            if raw.startswith("="):
                segs.append(f"({r},{c},{SYMBOLS[int(raw[1:]) - 1]})")
            else:
                segs.append(f"({r},{c},.)")
        lines.append(" ".join(segs))
    lines.append("<<<SKETCHPAD END>>>")
    return "\n".join(lines)


def _remaining(text: str) -> int | None:
    """The op-count remaining that the delivery header announces."""
    m = _REMAINING_RE.search(text or "")
    return int(m.group(1)) if m else None
