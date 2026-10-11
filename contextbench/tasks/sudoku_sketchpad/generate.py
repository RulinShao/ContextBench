#!/usr/bin/env python3
"""Deterministic generator for the *Sudoku Sketchpad* family.

The agent maintains a **sketchpad** -- the whole Sudoku board, one
``(row,col,value)`` tuple per cell -- inside its context window, and updates it in
place as moves stream in one at a time. Every move is fully specified, so no
solving or search is required: the family isolates context maintenance (apply a
well-defined mechanical edit to a large in-context structure and keep it consistent
across many turns) from reasoning. Where needle_retention asks the agent to retain,
this asks it to mutate.

Sketchpad format (canonical; the agent reproduces the whole board between the
sentinels), one tuple per cell, row-major, ``value`` a digit if placed or ``.`` if
empty, with a ``VERSION: <n>`` line below BEGIN counting the moves applied so far::

    <<<SKETCHPAD BEGIN>>>
    VERSION: <n>
    (1,1,.) (1,2,3) (1,3,4) (1,4,.)
    (2,1,2) (2,2,1) (2,3,3) (2,4,4)
    ...
    <<<SKETCHPAD END>>>

Every cell self-locates through its unique ``(r,c,`` prefix, so an in-place edit
anchors reliably and the grader is position-independent. Values 1..N use
single-character symbols (1-9, then A..Z), supporting boards up to box=5 (25x25):
``box`` 3 gives 9x9, 4 gives 16x16, 5 gives 25x25.

Process and gold: each board starts from a solved grid with ``givens`` cells
revealed and the rest blanked, and one Place move per turn sets a cell to its
placed digit in a seeded fill order. Many puzzles chain into one stream
(``boards`` / ``turns``): when a board is finished a NEW-BOARD reset action arrives
carrying the fresh starting panel, and the panel's version id increments on every
action. Gold is stored as compact per-version deltas (changed cells, with a reset
storing the full board), so thousands of turns stay small on disk; the grader folds
the deltas back into full per-version states and scores the versioned exact match
across the whole process.

Outputs into ``out_dir``: ``chunks.jsonl`` (one action per op), ``gold.json``
(initial panel plus per-version deltas), and ``meta.json``.
"""

from __future__ import annotations

import argparse
import json
import random
from pathlib import Path

__all__ = ["generate", "write_outputs", "instruction", "initial_block", "FAMILY",
           "SYMBOLS"]

FAMILY = "sudoku_sketchpad"

#: Cell values 1..N are drawn as single characters (digits 1-9, then A..Z for
#: 10..35), so boards up to box=6 (36x36) render one character per value slot.
SYMBOLS = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"


def _sym(v: int) -> str:
    return SYMBOLS[v - 1]


def _solve_full(side: int, box: int, rng: random.Random) -> list[list[int]]:
    """A random fully solved board (``side = box * box``).

    Built by the standard pattern-shuffle construction, with no search: a base
    valid pattern is permuted by shuffling row bands, rows within bands, the column
    equivalents, and the digit labels. This is always valid and is instant at any
    board size.
    """

    def pattern(r: int, c: int) -> int:
        return (box * (r % box) + r // box + c) % side

    def shuffled(seq):
        s = list(seq)
        rng.shuffle(s)
        return s

    bands = shuffled(range(box))
    rows = [g * box + r for g in bands for r in shuffled(range(box))]
    stacks = shuffled(range(box))
    cols = [g * box + c for g in stacks for c in shuffled(range(box))]
    nums = shuffled(range(1, side + 1))

    return [[nums[pattern(r, c)] for c in cols] for r in rows]


class _State:
    """A mutable board. ``solved[r][c]`` is the placed digit, or 0 when empty."""

    def __init__(self, side: int, box: int):
        self.side = side
        self.box = box
        self.solved = [[0] * side for _ in range(side)]

    def place(self, r: int, c: int, d: int) -> None:
        self.solved[r][c] = d

    def cell_value(self, r: int, c: int) -> str:
        """The integer-canonical value for gold and grading: ``=d`` or ``.``."""
        return f"={self.solved[r][c]}" if self.solved[r][c] else "."

    def render(self, *, turn: int) -> str:
        """The board as one ``(row,col,value)`` tuple per cell, row-major, labelled
        with the version id (the number of moves applied)."""
        n = self.side
        lines = ["<<<SKETCHPAD BEGIN>>>", f"VERSION: {turn}"]
        for br in range(n):
            segs = []
            for c in range(n):
                v = _sym(self.solved[br][c]) if self.solved[br][c] else "."
                segs.append(f"({br + 1},{c + 1},{v})")
            lines.append(" ".join(segs))
        lines.append("<<<SKETCHPAD END>>>")
        return "\n".join(lines)

    def cells_dict(self) -> dict[str, str]:
        """The canonical ``{"rXcY": value}`` mapping used for grading."""
        return {
            f"r{r + 1}c{c + 1}": self.cell_value(r, c)
            for r in range(self.side)
            for c in range(self.side)
        }


def _build_board(rng: random.Random, side: int, box: int, givens: int):
    """A fresh puzzle: the full solution, the starting state, and the move order."""
    full = _solve_full(side, box, rng)
    all_cells = [(r, c) for r in range(side) for c in range(side)]
    rng.shuffle(all_cells)
    given = set(all_cells[:givens])
    empties = sorted(c for c in all_cells if c not in given)  # row-major move order
    state = _State(side, box)
    for (r, c) in sorted(given):
        state.solved[r][c] = full[r][c]
    return full, state, empties


def _diff(before: dict[str, str], after: dict[str, str]) -> dict[str, str]:
    return {k: v for k, v in after.items() if before.get(k) != v}


def generate(
    *,
    seed: int = 42,
    box: int = 3,
    givens: int = 30,
    boards: int = 1,
    turns: int | None = None,
    moves_per_board: int | None = None,
) -> dict:
    """Chain one or more puzzles into a single long-horizon stream.

    The sketchpad has a global version id that increments on every action. Each
    board contributes its place moves; when a board is finished the next arrives as
    a NEW-BOARD reset action carrying the fresh starting panel. Generate ``boards``
    puzzles, or keep generating until ``turns`` stream actions exist (``turns``
    overrides ``boards``).
    """
    rng = random.Random(seed)
    side = box * box

    chunk_objs: list[dict] = []
    deltas: list[dict] = []  # {"v": int, "reset"?: True, "cells": {...}}
    initial_text: str | None = None
    version = 0
    boards_used = 0

    def _done() -> bool:
        if turns is not None:
            return len(chunk_objs) >= turns
        return boards_used >= boards

    b = 0
    while not _done():
        full, state, empties = _build_board(rng, side, box, givens)
        if moves_per_board is not None:
            empties = empties[:moves_per_board]
        boards_used += 1
        cells = state.cells_dict()

        if b == 0:
            # Version 0 is the first board's starting panel, shown in the instruction.
            initial_text = state.render(turn=0)
            deltas.append({"v": 0, "reset": True, "cells": cells})
        else:
            version += 1
            deltas.append({"v": version, "reset": True, "cells": cells})
            body = (
                f"NEW BOARD #{b + 1} (your sketchpad becomes version {version}): the "
                f"previous puzzle is complete. Discard it and reset your sketchpad to "
                f"this fresh puzzle — set the version id to {version} and load this "
                f"panel exactly:\n" + state.render(turn=version)
            )
            chunk_objs.append(
                {
                    "index": len(chunk_objs),
                    "header": f"new board #{b + 1}",
                    "body": body,
                }
            )
            if turns is not None and len(chunk_objs) >= turns:
                break

        prev = cells
        for (r, c) in empties:
            d = full[r][c]
            rr, cc, sym = r + 1, c + 1, _sym(full[r][c])
            version += 1
            state.place(r, c, d)
            after = state.cells_dict()
            deltas.append({"v": version, "cells": _diff(prev, after)})
            prev = after
            # The move message deliberately does NOT print the literal anchor
            # strings (the empty tuple, or the `VERSION: <k>` token). The action
            # arrives after the board, so any literal anchor it carried would be an
            # extra match for an in-place edit; the move is described instead and
            # the agent forms its anchors from the board itself.
            body = (
                f"Move (board #{b + 1}): Place {sym} in cell r{rr}c{cc} "
                f"(row {rr} from the top, column {cc} from the left).\n"
                f"In your sketchpad, set that cell's tuple value to {sym} and "
                f"increment the VERSION line to {version}. Leave every other cell "
                f"unchanged."
            )
            chunk_objs.append(
                {
                    "index": len(chunk_objs),
                    "header": f"board {b + 1} move v{version}",
                    "body": body,
                }
            )
            if turns is not None and len(chunk_objs) >= turns:
                break
        b += 1

    def _toks(s: str) -> int:
        return (len(s) + 1) // 4

    n_turns = len(chunk_objs)
    grid_tok = _toks(initial_text or "")
    actions_tok = sum(_toks(c["body"]) for c in chunk_objs)
    meta = {
        "task_family": FAMILY,
        "seed": seed,
        "box": box,
        "side": side,
        "n_cells": side * side,
        "givens": givens,
        "boards": boards_used,
        "n_turns": n_turns,
        "approx_grid_tokens": grid_tok,
        "approx_actions_tokens": actions_tok,
        "approx_per_action_tokens": (actions_tok // n_turns) if n_turns else 0,
    }
    return {
        "initial_grid_text": initial_text,
        "deltas": deltas,
        "chunks": chunk_objs,
        "meta": meta,
    }


def write_outputs(out_dir: Path | str, result: dict) -> None:
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    with (out_dir / "chunks.jsonl").open("w", encoding="utf-8") as f:
        for chunk in result["chunks"]:
            f.write(json.dumps(chunk, ensure_ascii=False) + "\n")
    # gold.json holds one delta per version and is written compactly: a long
    # horizon otherwise inflates the file by an order of magnitude.
    (out_dir / "gold.json").write_text(
        json.dumps(
            {
                "initial_grid_text": result["initial_grid_text"],
                "deltas": result["deltas"],
                "meta": result["meta"],
            },
            ensure_ascii=False,
        ),
        encoding="utf-8",
    )
    (out_dir / "meta.json").write_text(
        json.dumps(result["meta"], ensure_ascii=False, indent=2), encoding="utf-8"
    )


def initial_block(gold: dict) -> str:
    """The starting-panel block the instruction embeds."""
    return (
        "Your STARTING sketchpad (version 0):\n\n```\n"
        + (gold.get("initial_grid_text") or "")
        + "\n```"
    )


def instruction(gold: dict | None = None, *, delivery: str = "reply") -> str:
    """The instruction text for a sudoku_sketchpad instance.

    ``gold`` supplies the starting panel, which the scaffold embeds.
    """
    from ..scaffold import instruction as _instruction

    return _instruction(
        FAMILY,
        delivery=delivery,
        initial_block=initial_block(gold or {}),
    )


def main(argv: list[str] | None = None) -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument(
        "--box", type=int, default=3,
        help="sub-box size n; the board is (n*n)x(n*n). 3->9x9, 4->16x16, 5->25x25",
    )
    ap.add_argument(
        "--givens", type=int, default=30,
        help="pre-filled cells per board (the rest become Place moves)",
    )
    ap.add_argument(
        "--boards", type=int, default=1,
        help="number of chained puzzles (horizon = boards x moves per board)",
    )
    ap.add_argument(
        "--turns", type=int, default=None,
        help="total streamed actions; keeps adding boards until reached "
             "(overrides --boards)",
    )
    ap.add_argument(
        "--moves-per-board", type=int, default=None,
        help="cap moves per board (default: solve the whole board)",
    )
    ap.add_argument("--out-dir", type=Path, required=True)
    args = ap.parse_args(argv)
    result = generate(
        seed=args.seed,
        box=args.box,
        givens=args.givens,
        boards=args.boards,
        turns=args.turns,
        moves_per_board=args.moves_per_board,
    )
    write_outputs(args.out_dir, result)
    print(json.dumps(result["meta"], indent=2))


if __name__ == "__main__":
    main()
