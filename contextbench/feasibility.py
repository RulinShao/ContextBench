"""Generation-time feasibility check for ContextBench instances.

An instance is only a valid pressure point if an ideal context-management policy
*can* pass it. Four checks, all measured on the generated instance itself:

1. **pressure** -- streamed tokens / budget > 1: keeping everything must overflow.
2. **small ops** -- the largest single operation <= usable / 5 (with a safety
   factor): one user turn must never fill the window on its own. A batch that
   alone overflows is a configuration bug, not a task.
3. **retained** -- the task-specific mass the ideal policy has to hold in context
   <= usable / 2 (with the same safety factor):

   * needle: every needle line, verbatim;
   * kv: the in-context index over the offloaded batches plus the emitted answers;
   * log: the emitted answers (the batches live on disk);
   * sudoku: instance prompt + one full panel + one move.

4. **horizon** -- at least four operations, and for sudoku the append-only mass
   (panel x moves) must itself exceed the budget.

``usable = budget - reserve``. Token counts come from
:func:`contextbench.tokens.count_text` (exact ``o200k_base`` with tiktoken, else a
character estimate), so the ceilings carry a 0.9 safety factor.

The ``sub-budget`` regime keeps the other three checks but stops failing on
``P <= 1``: a deliberately under-pressure instance is expected curve-shape data,
not a broken configuration.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path
from typing import Literal

from .tokens import count_text as ntok
from .tokens import encoder_name

__all__ = [
    "PROMPT_TOKENS_DEFAULT",
    "SAFETY",
    "SMALL_OP_FRACTION",
    "RETAINED_FRACTION",
    "MIN_OPS",
    "BUDGET_DEFAULT",
    "RESERVE_DEFAULT",
    "evaluate",
    "check",
    "receipt",
    "write_receipt",
    "validator_sha16",
]

#: System prompt + instruction + instance prompt, as measured on the paper runs.
PROMPT_TOKENS_DEFAULT = 3000
SAFETY = 0.9
SMALL_OP_FRACTION = 1 / 5
RETAINED_FRACTION = 1 / 2
MIN_OPS = 4

BUDGET_DEFAULT = 32768
RESERVE_DEFAULT = 2048

Regime = Literal["pressure", "sub-budget"]


def validator_sha16() -> str:
    """``sha256[:16]`` of this validator's own bytes, for the receipt."""
    return hashlib.sha256(Path(__file__).read_bytes()).hexdigest()[:16]


def _load(d: Path) -> tuple[dict, list[dict]]:
    meta = json.loads((d / "meta.json").read_text(encoding="utf-8"))
    chunks = [
        json.loads(line)
        for line in (d / "chunks.jsonl").read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    return meta, chunks


def _op_tokens(chunk: dict) -> int:
    """Tokens of one op as the agent receives it (header line + body)."""
    header = chunk.get("header", "")
    body = chunk.get("body", "")
    return ntok(f"=== {header} (000 op(s) remaining after this) ===\n{body}")


def _retained(
    meta: dict, chunks: list[dict], usable: int, prompt_tokens: int
) -> tuple[int, str]:
    """The mass the ideal policy must keep in context, per family."""
    fam = meta.get("task_family")

    if fam == "needle_retention":
        kept = 0
        for c in chunks:
            for line in c.get("body", "").splitlines():
                if line.startswith("[n") and "#" in line:
                    kept += ntok(line + "\n")
        return kept, "all needle lines verbatim"

    if fam == "kv_store":
        # Ideal policy: offload every SET batch to disk and keep a SMALL in-context
        # index. Keys are dense and batches are contiguous key ranges, so the index
        # is one pointer line per batch (a grep does the lookup), not one line per
        # key. Retained = per-batch index + the emitted GET answers.
        n_batches = int(meta.get("n_batches", 0)) or max(
            1, int(meta.get("n_set", meta.get("records", 0))) // 20
        )
        n_get = int(meta.get("n_get", meta.get("queries", 0)))
        per_value = int(meta.get("approx_per_value_tokens", 48))
        index = n_batches * ntok("K00000-K00019 -> /tmp/ctx_offload/batch_0000.txt\n")
        answers = n_get * (
            per_value + ntok("<<<ANSWER key=K00000>>>\n\n<<<ANSWER END>>>\n")
        )
        return index + answers, f"per-batch index {index} + answers {answers}"

    if fam == "log_triage":
        n_q = int(meta.get("queries", 0))
        answers = n_q * ntok(
            "<<<ANSWER q=00>>>\n2026-06-20T14:00:00Z [ERROR] cache-svc req=e093bb5c "
            "replica retry connection quota upstream refused rollback #12d82fbe\n"
            "<<<ANSWER END>>>\n"
        )
        return answers, "emitted answers (batches live on disk)"

    if fam == "sudoku_sketchpad":
        box = int(meta["box"])
        side = int(meta["side"])
        # Pencil-mark panel: each cell is a box x box block, one panel line is
        # side*box symbols plus separators, box rows of lines per cell row; symbol
        # runs tokenize at roughly 2.2 characters per token.
        panel_chars = side * box * (side * box + side + 2) + 40
        panel = int(panel_chars / 2.2)
        move = max(_op_tokens(c) for c in chunks[:5])
        return (
            prompt_tokens + panel + move,
            f"prompt {prompt_tokens} + panel {panel} + move {move}",
        )

    return 0, "unknown family (no task-specific check)"


def evaluate(
    d: Path | str,
    budget: int = BUDGET_DEFAULT,
    reserve: int = RESERVE_DEFAULT,
    prompt_tokens: int = PROMPT_TOKENS_DEFAULT,
    regime: Regime = "pressure",
) -> dict:
    """Run the four checks on one generated instance directory."""
    d = Path(d)
    meta, chunks = _load(d)
    usable = budget - reserve
    ops = [_op_tokens(c) for c in chunks]
    streamed = sum(ops)
    max_op = max(ops) if ops else 0
    fam = meta.get("task_family")
    checks: dict[str, tuple[bool, str]] = {}
    sub = regime == "sub-budget"
    note = " (sub-budget (expected))" if sub else " (need > 1)"

    if fam == "sudoku_sketchpad":
        retained, why = _retained(meta, chunks, usable, prompt_tokens)
        panel = retained - prompt_tokens - max(ops[:5])
        append_mass = panel * len(chunks)
        pressure = append_mass / budget
        checks["pressure"] = (
            True if sub else pressure > 1.0,
            f"append-only mass {append_mass} / budget {budget} = "
            f"P {pressure:.2f}" + note,
        )
    else:
        pressure = streamed / budget
        checks["pressure"] = (
            True if sub else pressure > 1.0,
            f"streamed {streamed} / budget {budget} = P {pressure:.2f}" + note,
        )
        retained, why = _retained(meta, chunks, usable, prompt_tokens)

    cap_op = int(usable * SMALL_OP_FRACTION * SAFETY)
    checks["small_ops"] = (
        max_op <= cap_op,
        f"max op {max_op} tok (cap {cap_op} = usable {usable} / 5 x {SAFETY})",
    )
    cap_ret = int(usable * RETAINED_FRACTION * SAFETY)
    checks["retained"] = (
        retained <= cap_ret,
        f"retained {retained} tok [{why}] (cap {cap_ret} = usable / 2 x {SAFETY})",
    )
    checks["horizon"] = (
        len(chunks) >= MIN_OPS,
        f"{len(chunks)} ops (need >= {MIN_OPS})",
    )

    return {
        "dir": str(d),
        "task_family": fam,
        "budget": budget,
        "reserve": reserve,
        "P": round(pressure, 3),
        "streamed_tokens": streamed,
        "max_op_tokens": max_op,
        "retained_tokens": retained,
        "n_ops": len(chunks),
        "checks": {k: {"pass": v[0], "detail": v[1]} for k, v in checks.items()},
        "regime": regime,
        "feasible": all(v[0] for v in checks.values()),
    }


def check(
    instance_dir: Path | str,
    *,
    budget: int = BUDGET_DEFAULT,
    reserve: int = RESERVE_DEFAULT,
    prompt_tokens: int | None = None,
    regime: Regime = "pressure",
) -> dict:
    """Evaluate and raise on an infeasible instance, so a generator can refuse it."""
    pt = PROMPT_TOKENS_DEFAULT if prompt_tokens is None else prompt_tokens
    verdict = evaluate(instance_dir, budget, reserve, pt, regime)
    if not verdict["feasible"]:
        failed = {
            k: c["detail"] for k, c in verdict["checks"].items() if not c["pass"]
        }
        raise RuntimeError(
            f"feasibility FAIL ({verdict.get('task_family')}, {instance_dir}): "
            f"refusing to emit. failed={failed}; measured P={verdict.get('P')} "
            f"max_op={verdict.get('max_op_tokens')} "
            f"retained={verdict.get('retained_tokens')} "
            f"n_ops={verdict.get('n_ops')} (budget={budget} reserve={reserve})"
        )
    return verdict


def receipt(verdict: dict) -> dict:
    """The auditable record of a passing verdict.

    The ceilings are recomputed from the verdict's own budget and reserve through
    this module's constants, so a receipt can never quote a bar the validator does
    not apply. ``validator_sha16`` pins the bytes that produced it.
    """
    budget = int(verdict["budget"])
    reserve = int(verdict["reserve"])
    usable = budget - reserve
    return {
        "verdict": "PASS" if verdict.get("feasible") else "FAIL",
        "feasible": bool(verdict.get("feasible")),
        "task_family": verdict.get("task_family"),
        "checks": verdict["checks"],
        "measured": {
            "P": verdict.get("P"),
            "streamed_tokens": verdict.get("streamed_tokens"),
            "max_op_tokens": verdict.get("max_op_tokens"),
            "retained_tokens": verdict.get("retained_tokens"),
            "n_ops": verdict.get("n_ops"),
        },
        "budget": budget,
        "reserve": reserve,
        "usable_tokens": usable,
        "cap_op_tokens": int(usable * SMALL_OP_FRACTION * SAFETY),
        "cap_retained_tokens": int(usable * RETAINED_FRACTION * SAFETY),
        "regime": verdict.get("regime", "pressure"),
        "token_method": encoder_name(),
        "validator_sha16": validator_sha16(),
    }


def write_receipt(out_dir: Path | str, verdict: dict) -> Path:
    """Write ``feasibility_receipt.json`` into ``out_dir``."""
    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)
    path = out / "feasibility_receipt.json"
    path.write_text(json.dumps(receipt(verdict), indent=2) + "\n", encoding="utf-8")
    return path


def format_verdict(r: dict) -> str:
    lines = [
        f"[{'PASS' if r['feasible'] else 'FAIL'}] {r['task_family']}  "
        f"P={r['P']}  ops={r['n_ops']}  max_op={r['max_op_tokens']}  "
        f"retained={r['retained_tokens']}  ({r['dir']})"
    ]
    for name, c in r["checks"].items():
        lines.append(f"    {'ok ' if c['pass'] else 'BAD'} {name:9s} {c['detail']}")
    return "\n".join(lines)


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(
        description="Feasibility gate for ContextBench instances.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    group = ap.add_mutually_exclusive_group(required=True)
    group.add_argument("--instance-dir", type=Path)
    group.add_argument(
        "--scan",
        type=Path,
        help="root; every subdirectory with meta.json + chunks.jsonl is checked",
    )
    ap.add_argument("--budget", type=int, default=BUDGET_DEFAULT)
    ap.add_argument("--reserve", type=int, default=RESERVE_DEFAULT)
    ap.add_argument("--prompt-tokens", type=int, default=PROMPT_TOKENS_DEFAULT)
    ap.add_argument("--regime", choices=["pressure", "sub-budget"], default="pressure")
    ap.add_argument("--json", action="store_true")
    ap.add_argument(
        "--write-receipt",
        action="store_true",
        help="drop feasibility_receipt.json beside each checked instance",
    )
    args = ap.parse_args(argv)

    if args.instance_dir:
        dirs = [args.instance_dir]
    else:
        dirs = sorted(
            p.parent
            for p in args.scan.rglob("meta.json")
            if (p.parent / "chunks.jsonl").exists()
        )
    if not dirs:
        print("no instances found", file=sys.stderr)
        return 2

    results = [
        evaluate(d, args.budget, args.reserve, args.prompt_tokens, args.regime)
        for d in dirs
    ]
    if args.write_receipt:
        for d, r in zip(dirs, results):
            write_receipt(d, r)
    if args.json:
        print(json.dumps(results, indent=1))
    else:
        for r in results:
            print(format_verdict(r))
    return 0 if all(r["feasible"] for r in results) else 1


if __name__ == "__main__":
    sys.exit(main())
