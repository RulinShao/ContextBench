#!/usr/bin/env python3
"""Deterministic generator for the *Needle Retention* family.

The agent must maintain a dense, useful working context under a fixed budget. Each
streamed chunk is structured as::

    NEEDLES (keep these lines verbatim in your context):
    [n00007i03#a1b2c3d4] <verbatim needle line>
    ... K needles ...
    <<<FILLER-BLOCK 00007#hash START -- delete this entire block ...>>>
    <F lines of filler>
    <<<FILLER-BLOCK 00007#hash END>>>

The agent keeps the K ``[n...#...]`` needle lines and drops the contiguous filler
block, whose unique START and END sentinel lines are short, unique and printed
verbatim, so one anchored edit removes the whole block and can never overlap a
needle. A structural-editing agent therefore keeps context bounded and stays near
1.0 across the sweep, while a fixed-buffer summarizer fails once the retained
content exceeds its buffer.

The kept-ratio knob is ``alpha = kept_tokens / input_tokens``. Holding the chunk
count C and the per-chunk size roughly fixed and varying K (needles per chunk)
gives total kept = C * K * line_tokens, so alpha rises with K. The filler is sized
so each chunk stays comfortably under the budget.

Outputs into ``out_dir``: ``chunks.jsonl``, ``gold.json``, ``meta.json``, where
``gold["answer_lines"]`` is every needle line.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import random
from pathlib import Path

__all__ = ["generate", "write_outputs", "instruction", "FAMILY"]

FAMILY = "needle_retention"

WORDS = [
    "lantern", "crimson", "zebra", "orbit", "meadow", "cobalt", "thistle",
    "ember", "quartz", "willow", "harbor", "nimbus", "cedar", "pewter",
    "marble", "falcon", "indigo", "saffron", "boulder", "trellis", "glacier",
    "verdant", "copper", "lattice", "auburn", "spruce", "onyx", "cinder",
]


def _hash(*parts: object) -> str:
    return hashlib.sha1(":".join(str(p) for p in parts).encode()).hexdigest()[:8]


def _line(rng: random.Random, tag: str, n_words: int) -> str:
    words = [rng.choice(WORDS) for _ in range(max(1, n_words))]
    return f"[{tag}] " + " ".join(words) + "."


def _approx_tokens(lines: list[str]) -> int:
    """Roughly four characters per token; used only for the meta estimates.

    The random words and hash tags tokenize poorly, so a per-word estimate badly
    undercounts, while characters over four tracks a real tokenizer closely.
    """
    return sum(len(s) + 1 for s in lines) // 4


def generate(
    *,
    seed: int = 42,
    chunks: int = 8,
    needles_per_chunk: int = 4,
    filler_lines_per_chunk: int = 160,
    words_per_line: int = 10,
) -> dict:
    """Build the needle stream for one instance."""
    rng = random.Random(seed)
    chunk_objs: list[dict] = []
    answer_lines: list[str] = []
    source_lines: list[str] = []

    for c in range(chunks):
        needle_lines = []
        for n in range(needles_per_chunk):
            tag = f"n{c:05d}i{n:02d}#{_hash(seed, 'ndl', c, n)}"
            line = _line(rng, tag, words_per_line)
            needle_lines.append(line)
            answer_lines.append(line)
        filler = []
        for fidx in range(filler_lines_per_chunk):
            tag = f"f{c:05d}x{fidx:03d}#{_hash(seed, 'f', c, fidx)}"
            filler.append(_line(rng, tag, words_per_line))
        source_lines.extend(needle_lines)
        source_lines.extend(filler)

        # Unique, unguessable sentinels delimit the filler, so the whole block can
        # be removed with one edit anchored on two exact short lines: no multi-line
        # guessing and no needle overlap.
        fb_id = f"{c:05d}#{_hash(seed, 'fb', c)}"
        start_sent = (
            f"<<<FILLER-BLOCK {fb_id} START -- delete this entire block "
            f"(through its END line) from your context this turn>>>"
        )
        end_sent = f"<<<FILLER-BLOCK {fb_id} END>>>"
        body = (
            "NEEDLES (keep these lines verbatim in your context):\n"
            + "\n".join(needle_lines)
            + "\n"
            + start_sent
            + "\n"
            + "\n".join(filler)
            + "\n"
            + end_sent
        )
        chunk_objs.append(
            {"index": c, "header": f"chunk {c + 1}/{chunks}", "body": body}
        )

    kept_tok = _approx_tokens(answer_lines)
    input_tok = _approx_tokens(source_lines)
    meta = {
        "task_family": FAMILY,
        "seed": seed,
        "chunks": chunks,
        "needles_per_chunk": needles_per_chunk,
        "filler_lines_per_chunk": filler_lines_per_chunk,
        "words_per_line": words_per_line,
        "n_answer_lines": len(answer_lines),
        "n_source_lines": len(source_lines),
        "alpha_nominal": (kept_tok / input_tok) if input_tok else 0.0,
        "approx_input_tokens": input_tok,
        "approx_kept_tokens": kept_tok,
        "approx_chunk_tokens": (input_tok // chunks) if chunks else input_tok,
    }
    return {
        "chunks": chunk_objs,
        "answer_lines": answer_lines,
        "source_lines": source_lines,
        "meta": meta,
    }


def write_outputs(out_dir: Path | str, result: dict) -> None:
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    with (out_dir / "chunks.jsonl").open("w", encoding="utf-8") as f:
        for chunk in result["chunks"]:
            f.write(json.dumps(chunk, ensure_ascii=False) + "\n")
    (out_dir / "gold.json").write_text(
        json.dumps(
            {
                "answer_lines": result["answer_lines"],
                "source_lines": result["source_lines"],
                "meta": result["meta"],
            },
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )
    (out_dir / "meta.json").write_text(
        json.dumps(result["meta"], ensure_ascii=False, indent=2), encoding="utf-8"
    )


def instruction(gold: dict | None = None, *, delivery: str = "reply") -> str:
    """The instruction text for a needle_retention instance."""
    from ..scaffold import instruction as _instruction

    return _instruction(FAMILY, delivery=delivery)


def main(argv: list[str] | None = None) -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--chunks", "-C", type=int, default=8)
    ap.add_argument("--needles-per-chunk", "-K", type=int, required=True)
    ap.add_argument("--filler-lines-per-chunk", "-F", type=int, default=160)
    ap.add_argument("--words-per-line", type=int, default=10)
    ap.add_argument("--out-dir", type=Path, required=True)
    args = ap.parse_args(argv)
    result = generate(
        seed=args.seed,
        chunks=args.chunks,
        needles_per_chunk=args.needles_per_chunk,
        filler_lines_per_chunk=args.filler_lines_per_chunk,
        words_per_line=args.words_per_line,
    )
    write_outputs(args.out_dir, result)
    print(json.dumps(result["meta"], indent=2))


if __name__ == "__main__":
    main()
