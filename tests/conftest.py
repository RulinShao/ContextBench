"""Shared fixtures. No network and no model calls anywhere in the suite."""

from __future__ import annotations

import importlib
import json
import os
from pathlib import Path

import pytest

#: Small, feasible levels: enough pressure and turns to exercise the protocol,
#: small enough for a test run at budget 8192.
SMALL_LEVELS: dict[str, dict] = {
    "kv_store": dict(
        seed=42, records=300, value_words=24, queries=8, records_per_chunk=100
    ),
    "log_triage": dict(seed=42, lines=400, lines_per_batch=14, queries=8),
    "needle_retention": dict(
        seed=42,
        chunks=8,
        needles_per_chunk=4,
        filler_lines_per_chunk=140,
        words_per_line=10,
    ),
    "sudoku_sketchpad": dict(seed=42, box=3, givens=20, turns=20),
}

TEST_BUDGET = 8192
TEST_RESERVE = 1024

#: A needle instance small enough that an append-only agent fits inside TEST_BUDGET,
#: so the protocol tests exercise refusals rather than the budget wall.
PROTOCOL_LEVEL = dict(
    seed=42,
    chunks=8,
    needles_per_chunk=4,
    filler_lines_per_chunk=6,
    words_per_line=10,
)

#: The internal benchmark tree the package was ported from. Parity tests read it
#: when this environment variable points at it and skip otherwise, so the public
#: repository carries no path to it.
REFERENCE_TREE_ENV = "CONTEXTBENCH_REFERENCE_TREE"


def reference_tree() -> Path | None:
    raw = os.environ.get(REFERENCE_TREE_ENV)
    if not raw:
        return None
    path = Path(raw)
    return path if path.is_dir() else None


def requires_reference_tree() -> Path:
    path = reference_tree()
    if path is None:
        pytest.skip(
            f"set {REFERENCE_TREE_ENV} to the reference benchmark tree to run "
            f"parity tests"
        )
    return path


def generator(family: str):
    return importlib.import_module(f"contextbench.tasks.{family}.generate")


def make_instance(out_dir: Path, family: str, **overrides) -> Path:
    """Write one small instance of ``family`` into ``out_dir``."""
    knobs = dict(SMALL_LEVELS[family])
    knobs.update(overrides)
    module = generator(family)
    module.write_outputs(out_dir, module.generate(**knobs))
    return out_dir


def read_gold(instance_dir: Path) -> dict:
    return json.loads((instance_dir / "gold.json").read_text(encoding="utf-8"))


@pytest.fixture(params=sorted(SMALL_LEVELS))
def family(request) -> str:
    return request.param


@pytest.fixture
def instance(tmp_path: Path, family: str) -> Path:
    return make_instance(tmp_path / "instance", family)


def o200k_available() -> bool:
    from contextbench.tokens import encoder_name

    return encoder_name() == "tiktoken:o200k_base"


def pytest_collection_modifyitems(config, items) -> None:
    """``needs_o200k`` tests check the paper levels against the feasibility gate with
    exact o200k_base counts; the character-estimate fallback gives different counts,
    so they are skipped (not loosened) when o200k_base cannot be loaded."""
    if o200k_available():
        return
    skip = pytest.mark.skip(reason="needs exact o200k_base counts (tiktoken + o200k vocabulary)")
    for item in items:
        if "needs_o200k" in item.keywords:
            item.add_marker(skip)
