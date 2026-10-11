"""Levels of a levels file (``clm_exp/configs/paper.yaml``): generator knobs vs descriptive keys.

A level entry carries its generator knobs plus keys that describe it and never reach
the generator: ``name``, ``figure_x`` (its x value in the paper figure's rows),
``appendix_pressure`` (the appendix pressure table), ``main_figure`` (drawn in the
main-text figure) and ``regime`` (the feasibility regime it is gated under).
"""

from __future__ import annotations

from typing import Any

__all__ = ["LEVEL_META_KEYS", "level_knobs", "level_regime", "iter_levels"]

LEVEL_META_KEYS = frozenset(
    {"name", "figure_x", "appendix_pressure", "main_figure", "regime"}
)


def level_knobs(family_spec: dict, entry: dict) -> dict[str, Any]:
    """The generator knobs of one level: the family's fixed knobs plus the level's."""
    knobs = dict(family_spec.get("fixed") or {})
    knobs.update({k: v for k, v in entry.items() if k not in LEVEL_META_KEYS})
    return knobs


def level_regime(entry: dict) -> str:
    """The feasibility regime a level is gated under (default ``pressure``)."""
    return str(entry.get("regime") or "pressure")


def iter_levels(config: dict, *, main_figure_only: bool = False):
    """Yield ``(family, family_spec, level_entry)`` over a levels config."""
    for family, spec in (config.get("families") or {}).items():
        for entry in spec.get("levels") or []:
            if main_figure_only and not entry.get("main_figure"):
                continue
            yield family, spec, entry
