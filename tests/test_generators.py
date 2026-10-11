"""Generators: on-disk shape, determinism, sentinels, and reference parity."""

from __future__ import annotations

import hashlib
import importlib.util
import json
import sys
from pathlib import Path

import pytest

from conftest import (
    SMALL_LEVELS,
    generator,
    make_instance,
    requires_reference_tree,
)


def _files(d: Path) -> dict[str, str]:
    return {
        p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(d.iterdir())
    }


def test_writes_the_three_files(instance: Path, family: str) -> None:
    assert sorted(p.name for p in instance.iterdir()) == [
        "chunks.jsonl",
        "gold.json",
        "meta.json",
    ]
    meta = json.loads((instance / "meta.json").read_text(encoding="utf-8"))
    assert meta["task_family"] == family
    gold = json.loads((instance / "gold.json").read_text(encoding="utf-8"))
    assert gold["meta"]["task_family"] == family


def test_chunks_are_one_op_per_line(instance: Path) -> None:
    lines = (instance / "chunks.jsonl").read_text(encoding="utf-8").splitlines()
    assert lines
    for i, line in enumerate(lines):
        op = json.loads(line)
        assert set(op) == {"index", "header", "body"}
        assert op["index"] == i
        assert op["body"]


def test_generation_is_deterministic(tmp_path: Path, family: str) -> None:
    a = make_instance(tmp_path / "a", family)
    b = make_instance(tmp_path / "b", family)
    assert _files(a) == _files(b)


def test_seed_changes_the_instance(tmp_path: Path, family: str) -> None:
    a = make_instance(tmp_path / "a", family, seed=42)
    b = make_instance(tmp_path / "b", family, seed=43)
    assert _files(a) != _files(b)


@pytest.mark.parametrize(
    "family,sentinel",
    [
        ("kv_store", "<<<SET-BATCH "),
        ("log_triage", "<<<LOG-BATCH "),
        ("needle_retention", "<<<FILLER-BLOCK "),
        ("sudoku_sketchpad", "<<<SKETCHPAD BEGIN>>>"),
    ],
)
def test_sentinel_markers_present(tmp_path: Path, family: str, sentinel: str) -> None:
    inst = make_instance(tmp_path / family, family)
    text = (inst / "chunks.jsonl").read_text(encoding="utf-8")
    if family == "sudoku_sketchpad":
        # The panel is carried by the gold and the instruction, not by a move op.
        text += (inst / "gold.json").read_text(encoding="utf-8")
    assert sentinel in text


def test_sentinels_are_unique_per_block(tmp_path: Path) -> None:
    inst = make_instance(tmp_path / "kv", "kv_store")
    ids = []
    for line in (inst / "chunks.jsonl").read_text(encoding="utf-8").splitlines():
        body = json.loads(line)["body"]
        if "<<<SET-BATCH " in body:
            ids.append(body.split("<<<SET-BATCH ", 1)[1].split(" ", 1)[0])
    assert ids and len(ids) == len(set(ids))


def test_needle_gold_lines_appear_in_the_stream(tmp_path: Path) -> None:
    inst = make_instance(tmp_path / "needle", "needle_retention")
    gold = json.loads((inst / "gold.json").read_text(encoding="utf-8"))
    stream = (inst / "chunks.jsonl").read_text(encoding="utf-8")
    for line in gold["answer_lines"]:
        assert json.dumps(line)[1:-1] in stream


def test_sudoku_gold_stamps_side(tmp_path: Path) -> None:
    inst = make_instance(tmp_path / "sudoku", "sudoku_sketchpad", box=3)
    gold = json.loads((inst / "gold.json").read_text(encoding="utf-8"))
    assert gold["meta"]["side"] == 9
    assert gold["deltas"][0]["v"] == 0 and gold["deltas"][0]["reset"] is True


def test_instruction_carries_the_family_contract(instance: Path, family: str) -> None:
    from contextbench import instruction_for, load_instance

    text = instruction_for(load_instance(instance))
    assert "READY_FOR_NEXT_OP" in text
    # Phase 1 ships no method skill: nothing tells the agent how to manage context.
    assert "edit_context" not in text
    assert "{memory_section}" not in text
    if family == "sudoku_sketchpad":
        assert "<<<SKETCHPAD BEGIN>>>" in text
        assert "{initial_block}" not in text


# ------------------------------------------------------------------- reference parity
@pytest.mark.parametrize("family", sorted(SMALL_LEVELS))
def test_matches_the_reference_generator(tmp_path: Path, family: str) -> None:
    """The ported generator must be byte-identical to the benchmark of record."""
    root = requires_reference_tree()
    path = root / family / "generate.py"
    if not path.is_file():
        pytest.skip(f"reference tree has no {family}/generate.py")

    spec = importlib.util.spec_from_file_location(f"_ref_{family}", path)
    assert spec and spec.loader
    ref = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = ref
    spec.loader.exec_module(ref)

    knobs = SMALL_LEVELS[family]
    ref_dir, our_dir = tmp_path / "ref", tmp_path / "our"
    ref.write_outputs(ref_dir, ref.generate(**knobs))
    module = generator(family)
    module.write_outputs(our_dir, module.generate(**knobs))
    assert _files(our_dir) == _files(ref_dir)


def test_reply_mode_never_offers_disk_or_tools():
    """A reply-mode agent has no shell; its instruction must not invite disk writes."""
    from contextbench.tasks.scaffold import instruction

    for family in ("kv_store", "log_triage", "needle_retention", "sudoku_sketchpad"):
        text = instruction(family, delivery="reply")
        assert "You MAY use" not in text, family
        assert "echo READY_FOR_NEXT_OP" not in text, family
    for family in ("kv_store", "log_triage"):
        assert "no shell, no files and no tools" in instruction(family, delivery="reply")
