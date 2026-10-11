"""Instruction scaffolds: the family contract text handed to the agent.

Each family ships its scaffold as ``<family>/scaffold.md``, copied from the
benchmark of record with the method-specific skill removed -- phase 1 evaluates
agents on the task contract alone, so no scaffold carries advice about how to
manage context.

The scaffolds of record describe readiness as a shell command
(``echo READY_FOR_NEXT_OP``), because the paper ran agents that had a bash tool.
The pure-Python runner drives chat agents with no shell, so two sections are
rewritten for ``delivery="reply"``: the turn protocol, and (sudoku only) the
paragraph that requires a tool call to surface the board. Everything else is the
text of record, byte for byte.
"""

from __future__ import annotations

import re
from pathlib import Path

from ..stream import ADVANCE_MARKER, SUBMIT_MARKER

__all__ = ["FAMILIES", "Delivery", "load_scaffold", "instruction"]

FAMILIES = ("kv_store", "log_triage", "needle_retention", "sudoku_sketchpad")

Delivery = str  # "bash" (scaffold of record) or "reply" (no shell)

_HERE = Path(__file__).resolve().parent

_TURN_PROTOCOL_HEADING = "## Turn protocol (IMPORTANT)"
_SUDOKU_SURFACE_HEADING = "## Keeping your board in your context"

_REPLY_TURN_PROTOCOL = f"""{_TURN_PROTOCOL_HEADING}

Each incoming message is ONE operation. Do everything it needs FIRST. When you are
done with the current operation, **end your turn** by putting this marker on a
line of its own, as the last line of your reply:

```
{ADVANCE_MARKER}
```

The harness then delivers the next operation as the next user message. ONLY the
standalone marker line advances the stream: the marker does not count when it
appears inside a sentence or inside answer data, and a reply without it does not
advance (you are simply prompted to keep going). Do NOT emit the marker until you
have fully handled the current operation.

The run ends after the final operation: emit the marker once more, or the
standalone line `{SUBMIT_MARKER}` to finish. Submitting
before the stream is drained is refused and wastes a turn.
"""

_REPLY_SUDOKU_SURFACE = """## Keeping your board in your context (required)

Grading reads ONLY your context, so after each move the current board must be
present in it. Write the whole panel out in your reply, between the
`<<<SKETCHPAD BEGIN>>>` and `<<<SKETCHPAD END>>>` sentinels, every turn. Nothing
you put on disk is read.
"""


def _sections(text: str) -> list[str]:
    """Split a scaffold on its level-2 headings, keeping each heading with its body."""
    parts = re.split(r"(?m)^(?=## )", text)
    return [p for p in parts if p]


def _replace_section(text: str, heading_prefix: str, replacement: str) -> str:
    out: list[str] = []
    hit = False
    for part in _sections(text):
        if part.startswith(heading_prefix):
            hit = True
            tail = "\n" if part.endswith("\n\n") else ""
            out.append(replacement.rstrip("\n") + "\n" + tail)
        else:
            out.append(part)
    if not hit:
        raise KeyError(f"scaffold has no section starting {heading_prefix!r}")
    return "".join(out)


_DISK_SCRATCH_RE = re.compile(
    r"You MAY use\s+the disk as scratch/storage, but FINDING a value \(e\.g\. with\s+"
    r"`grep`\) is NOT\s+answering\s+—\s+only an ANSWER block that actually appears in your\s+"
    r"context is scored,\s+so you must",
)
_REPLY_NO_DISK = (
    "You have no shell, no files and no tools in this setting: anything you want to\n"
    "recall later must still be in this conversation when you need it. Only an\n"
    "ANSWER block that appears in your context is scored, so you must"
)


def _drop_disk_scratch(text: str) -> str:
    """Replace the bash scaffold's disk-as-scratch sentence (kv_store, log_triage)."""
    return _DISK_SCRATCH_RE.sub(_REPLY_NO_DISK, text)


def load_scaffold(family: str) -> str:
    """The scaffold of record for ``family`` (method skill already removed)."""
    if family not in FAMILIES:
        raise KeyError(f"unknown family {family!r}; known: {', '.join(FAMILIES)}")
    return (_HERE / family / "scaffold.md").read_text(encoding="utf-8")


def instruction(
    family: str,
    *,
    delivery: Delivery = "reply",
    initial_block: str = "",
) -> str:
    """The instruction text for one instance.

    ``delivery="bash"`` returns the scaffold of record unchanged. ``"reply"``
    rewrites the readiness sections for an agent with no shell. ``initial_block``
    fills the sudoku starting-panel placeholder and is ignored by the other
    families.
    """
    if delivery not in ("bash", "reply"):
        raise ValueError(f"delivery must be 'bash' or 'reply', got {delivery!r}")
    text = load_scaffold(family)
    if delivery == "reply":
        text = _replace_section(text, _TURN_PROTOCOL_HEADING, _REPLY_TURN_PROTOCOL)
        # The bash scaffold offers the disk as scratch space. A reply-mode agent has
        # no shell and no disk, so that sentence would invite writes that go nowhere.
        text = _drop_disk_scratch(text)
        if family == "sudoku_sketchpad":
            text = _replace_section(
                text, _SUDOKU_SURFACE_HEADING, _REPLY_SUDOKU_SURFACE
            )
    return text.replace("{initial_block}", initial_block)
