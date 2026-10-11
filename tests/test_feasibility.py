"""The feasibility gate, on the paper levels and on instances built to fail it."""

from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pytest

from conftest import generator, make_instance, requires_reference_tree
from contextbench import feasibility
from contextbench.cli import DEFAULT_CONFIG, level_entry, load_config, resolve_level
from contextbench.levels import level_regime

PAPER_BUDGET = 32768
PAPER_RESERVE = 2048

CONFIG = load_config(DEFAULT_CONFIG)
LEVELS = [
    (family, level["name"])
    for family, spec in CONFIG["families"].items()
    for level in spec["levels"]
]

#: The rungs the main-text figure leaves out (its generator's DROP list).
NOT_IN_MAIN_FIGURE = {
    ("needle_retention", "K4-C6"),
    ("needle_retention", "K8-C62"),
    ("log_triage", "L6400"),
}


def _generate_level(out_dir: Path, family: str, level: str, seed: int = 42) -> Path:
    knobs = resolve_level(CONFIG, family, level)
    knobs["seed"] = seed
    module = generator(family)
    module.write_outputs(out_dir, module.generate(**knobs))
    return out_dir


def test_config_constants_match_the_validator() -> None:
    """The levels file and the validator can never quote different ceilings."""
    cfg = CONFIG["feasibility"]
    usable = CONFIG["context"]["budget_tokens"] - CONFIG["context"]["reserve_tokens"]
    assert cfg["usable_tokens"] == usable
    assert cfg["safety"] == feasibility.SAFETY
    assert cfg["small_op_fraction"] == pytest.approx(feasibility.SMALL_OP_FRACTION)
    assert cfg["retained_fraction"] == pytest.approx(feasibility.RETAINED_FRACTION)
    assert cfg["horizon_min_ops"] == feasibility.MIN_OPS
    assert cfg["prompt_tokens"] == feasibility.PROMPT_TOKENS_DEFAULT
    assert cfg["cap_op_tokens"] == int(
        usable * feasibility.SMALL_OP_FRACTION * feasibility.SAFETY
    )
    assert cfg["cap_retained_tokens"] == int(
        usable * feasibility.RETAINED_FRACTION * feasibility.SAFETY
    )


@pytest.mark.parametrize("family,level", LEVELS, ids=[f"{f}-{l}" for f, l in LEVELS])
@pytest.mark.needs_o200k
def test_paper_levels_are_feasible(tmp_path: Path, family: str, level: str) -> None:
    """Every level passes the gate under its own regime and lands on the figure's x."""
    entry = level_entry(CONFIG, family, level)
    regime = level_regime(entry)
    inst = _generate_level(tmp_path / f"{family}-{level}", family, level)
    verdict = feasibility.evaluate(inst, PAPER_BUDGET, PAPER_RESERVE, regime=regime)
    failed = {k: c["detail"] for k, c in verdict["checks"].items() if not c["pass"]}
    assert verdict["feasible"], failed
    assert verdict["n_ops"] >= feasibility.MIN_OPS
    # A level is sub-budget exactly when its gate pressure is below one budget.
    assert (verdict["P"] > 1.0) == (regime == "pressure")
    if family == "sudoku_sketchpad":
        # The figure's sudoku x is the number of moves, one op per move.
        assert verdict["n_ops"] == entry["figure_x"] == entry["turns"]
    elif regime == "pressure":
        # The figure's x is the gate's P (streamed op tokens / budget).
        assert verdict["P"] == pytest.approx(entry["figure_x"], rel=5e-3)


def test_main_figure_flags_match_the_figure() -> None:
    unflagged = {
        (family, level["name"])
        for family, spec in CONFIG["families"].items()
        for level in spec["levels"]
        if not level.get("main_figure")
    }
    assert unflagged == NOT_IN_MAIN_FIGURE
    # The appendix pressure table lists exactly the main-figure rungs.
    for family, spec in CONFIG["families"].items():
        for level in spec["levels"]:
            assert ("appendix_pressure" in level) == bool(level.get("main_figure"))


def test_a_tiny_instance_fails_pressure_and_horizon(tmp_path: Path) -> None:
    inst = make_instance(
        tmp_path / "tiny", "needle_retention", chunks=2, filler_lines_per_chunk=2
    )
    verdict = feasibility.evaluate(inst, PAPER_BUDGET, PAPER_RESERVE)
    assert not verdict["feasible"]
    assert not verdict["checks"]["pressure"]["pass"]
    assert not verdict["checks"]["horizon"]["pass"]


def test_sub_budget_regime_keeps_the_other_checks(tmp_path: Path) -> None:
    inst = make_instance(
        tmp_path / "tiny", "needle_retention", chunks=8, filler_lines_per_chunk=2
    )
    strict = feasibility.evaluate(inst, PAPER_BUDGET, PAPER_RESERVE)
    relaxed = feasibility.evaluate(
        inst, PAPER_BUDGET, PAPER_RESERVE, regime="sub-budget"
    )
    assert not strict["checks"]["pressure"]["pass"]
    assert relaxed["checks"]["pressure"]["pass"]
    assert relaxed["feasible"]
    assert relaxed["regime"] == "sub-budget"


def test_an_oversized_op_fails_small_ops(tmp_path: Path) -> None:
    """One batch that alone fills the window is a configuration bug, not a task."""
    inst = make_instance(
        tmp_path / "huge", "log_triage", lines=4000, lines_per_batch=4000
    )
    verdict = feasibility.evaluate(inst, PAPER_BUDGET, PAPER_RESERVE)
    assert not verdict["checks"]["small_ops"]["pass"]
    assert not verdict["feasible"]


def test_check_raises_on_an_infeasible_instance(tmp_path: Path) -> None:
    inst = make_instance(
        tmp_path / "tiny", "needle_retention", chunks=2, filler_lines_per_chunk=2
    )
    with pytest.raises(RuntimeError, match="feasibility FAIL"):
        feasibility.check(inst, budget=PAPER_BUDGET, reserve=PAPER_RESERVE)


@pytest.mark.needs_o200k
def test_receipt_pins_the_validator(tmp_path: Path) -> None:
    inst = _generate_level(tmp_path / "kv", "kv_store", "R1000")
    verdict = feasibility.evaluate(inst, PAPER_BUDGET, PAPER_RESERVE)
    path = feasibility.write_receipt(inst, verdict)
    receipt = json.loads(path.read_text(encoding="utf-8"))

    assert receipt["verdict"] == "PASS"
    assert receipt["task_family"] == "kv_store"
    assert receipt["usable_tokens"] == PAPER_BUDGET - PAPER_RESERVE
    assert receipt["cap_op_tokens"] == CONFIG["feasibility"]["cap_op_tokens"]
    assert receipt["cap_retained_tokens"] == CONFIG["feasibility"]["cap_retained_tokens"]
    assert receipt["validator_sha16"] == feasibility.validator_sha16()
    assert len(receipt["validator_sha16"]) == 16
    assert set(receipt["checks"]) == {
        "pressure",
        "small_ops",
        "retained",
        "horizon",
    }


@pytest.mark.parametrize("family,level", LEVELS, ids=[f"{f}-{l}" for f, l in LEVELS])
def test_matches_the_reference_validator(
    tmp_path: Path, family: str, level: str
) -> None:
    """Every measured number and every check detail must match the gate of record."""
    root = requires_reference_tree()
    path = root / "feasibility.py"
    if not path.is_file():
        pytest.skip("reference tree has no feasibility.py")
    spec = importlib.util.spec_from_file_location("_ref_feasibility", path)
    assert spec and spec.loader
    ref = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = ref
    spec.loader.exec_module(ref)

    inst = _generate_level(tmp_path / f"{family}-{level}", family, level)
    theirs = ref.evaluate(
        Path(inst), PAPER_BUDGET, PAPER_RESERVE, ref.PROMPT_TOKENS_DEFAULT
    )
    ours = feasibility.evaluate(
        inst, PAPER_BUDGET, PAPER_RESERVE, feasibility.PROMPT_TOKENS_DEFAULT
    )
    for key in (
        "task_family",
        "P",
        "streamed_tokens",
        "max_op_tokens",
        "retained_tokens",
        "n_ops",
        "feasible",
    ):
        assert ours[key] == theirs[key], key
    assert ours["checks"] == theirs["checks"]
