"""The method skills under clm_exp/skills/ match the sha16 table in their README."""

from __future__ import annotations

import hashlib
import re
from pathlib import Path

SKILLS = Path(__file__).resolve().parents[1] / "clm_exp" / "skills"

#: A table row: | `<arm>/<file>.md` | source | `<sha16>` | rungs |. One sha16 is printed
#: with a space after 8 digits (see the README's note), so spaces are dropped.
_ROW = re.compile(r"^\| `([\w/.]+\.md)` \| [^|]+ \| `([0-9a-f ]{16,17})`", re.MULTILINE)


def _table() -> dict[str, str]:
    return {path: sha.replace(" ", "")
            for path, sha in _ROW.findall((SKILLS / "README.md").read_text(encoding="utf-8"))}


def test_every_skill_file_is_in_the_table_with_its_sha16() -> None:
    table = _table()
    files = {p.relative_to(SKILLS).as_posix() for p in SKILLS.glob("*/*.md")}
    assert files == set(table)
    for rel, sha16 in table.items():
        got = hashlib.sha256((SKILLS / rel).read_bytes()).hexdigest()[:16]
        assert got == sha16, rel


def test_clm_skills_are_the_paper_method_text() -> None:
    table = _table()
    assert {f: table[f"clm/{f}.md"] for f in
            ("kv_store", "log_triage", "needle_retention", "sudoku_sketchpad")} == {
        "kv_store": "70695bdca1a7f39d",
        "log_triage": "1a071e820bcc9a93",
        "needle_retention": "e834d24bf004c7ae",
        "sudoku_sketchpad": "378c4e5d928af06f",
    }
