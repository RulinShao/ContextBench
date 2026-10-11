#!/usr/bin/env python3
"""Deterministic generator for the *Key-Value Store* family.

This family isolates **storage offloading**. A stream of operations is delivered
one at a time:

    SET <key> = <value>     # remember <value> for <key>; values are random,
                            # incompressible tokens
    GET <key>               # report the value stored for <key>

Most ``SET`` keys are never queried, and which keys will be queried is not
revealed up front. That is what makes offloading necessary: values cannot be
deleted (a deleted value cannot answer a later GET), cannot be summarized (they
are random tokens, so lossy compression fails), cannot be folded selectively (the
queried keys are unknown), and keeping all of them in context overflows the window
once the volume is large.

All ``SET`` ops stream first, batched ``records_per_chunk`` per op to keep the turn
count feasible; all ``GET`` ops arrive at the end. End-loading is what makes the
overflow decisive: an agent that keeps everything blows its budget during ingestion
and never reaches a GET, while an agent that parks each batch outside its context
stays flat and answers every GET afterwards.

Each batch is wrapped in unique, unguessable BEGIN/END sentinel lines so a whole
batch can be moved out of context with one anchored edit regardless of batch size.

Outputs into ``out_dir``: ``chunks.jsonl``, ``gold.json``, ``meta.json``.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import random
from pathlib import Path

__all__ = ["generate", "write_outputs", "instruction", "FAMILY"]

FAMILY = "kv_store"

# Random words tokenize poorly, so values are genuinely incompressible and defeat
# any summarizer.
WORDS = [
    "lantern", "crimson", "zebra", "orbit", "meadow", "cobalt", "thistle",
    "ember", "quartz", "willow", "harbor", "nimbus", "cedar", "pewter",
    "marble", "falcon", "indigo", "saffron", "boulder", "trellis", "glacier",
    "verdant", "copper", "lattice", "auburn", "spruce", "onyx", "cinder",
    "vellum", "garnet", "russet", "cobble", "fathom", "kindle", "mistral",
]


def _hash(*parts: object) -> str:
    return hashlib.sha1(":".join(str(p) for p in parts).encode()).hexdigest()[:8]


def _value(rng: random.Random, key: str, n_words: int) -> str:
    """An incompressible value: random words plus a key-derived hash tag, so it is
    globally unique and cannot be guessed or paraphrased."""
    words = " ".join(rng.choice(WORDS) for _ in range(max(1, n_words)))
    return f"{words} #{_hash(key, n_words, words)}"


def _approx_tokens(strings: list[str]) -> int:
    """Roughly four characters per token; used only for the meta estimates."""
    return sum(len(s) + 1 for s in strings) // 4


def generate(
    *,
    seed: int = 42,
    records: int = 120,
    value_words: int = 24,
    queries: int = 24,
    records_per_chunk: int = 20,
) -> dict:
    """Build the SET/GET stream for one instance."""
    rng = random.Random(seed)

    keys = [f"K{i:05d}" for i in range(records)]
    values = {k: _value(rng, k, value_words) for k in keys}

    # GET keys spread across the whole keyspace, old and new alike.
    q_keys = (
        rng.sample(keys, queries)
        if queries <= records
        else [rng.choice(keys) for _ in range(queries)]
    )
    gold_queries = [
        {"qid": i, "key": k, "value": values[k]} for i, k in enumerate(q_keys)
    ]

    chunk_objs: list[dict] = []
    idx = 0
    for start in range(0, records, records_per_chunk):
        batch = keys[start : start + records_per_chunk]
        sb_id = f"{idx:04d}#{_hash(seed, 'sb', idx)}"
        begin = (
            f"<<<SET-BATCH {sb_id} BEGIN -- offload this whole block this turn>>>"
        )
        end = f"<<<SET-BATCH {sb_id} END>>>"
        body = (
            begin
            + "\n"
            + "\n".join(f"SET {k} = {values[k]}" for k in batch)
            + "\n"
            + end
        )
        chunk_objs.append(
            {
                "index": idx,
                "header": f"set batch (keys {start}-{start + len(batch) - 1})",
                "body": body,
            }
        )
        idx += 1
    n_batches = idx

    for q in gold_queries:
        body = (
            f"GET {q['key']}\n"
            f"(Report the value you stored for {q['key']} as an ANSWER block "
            f"for that key.)"
        )
        chunk_objs.append({"index": idx, "header": f"get {q['qid']}", "body": body})
        idx += 1

    set_lines = [f"SET {k} = {values[k]}" for k in keys]
    value_tokens = _approx_tokens(set_lines)
    meta = {
        "task_family": FAMILY,
        "seed": seed,
        "records": records,
        "value_words": value_words,
        "records_per_chunk": records_per_chunk,
        "queries": len(gold_queries),
        "n_set": records,
        "n_get": len(gold_queries),
        "n_batches": n_batches,
        "n_actions": len(chunk_objs),
        # Total value volume the agent must be able to recall, sized to exceed the
        # budget so an agent that keeps everything overflows during ingestion.
        "approx_value_tokens": value_tokens,
        "approx_per_value_tokens": (value_tokens // records) if records else 0,
    }
    return {
        "chunks": chunk_objs,
        "queries": gold_queries,
        "values": values,
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
            {"queries": result["queries"], "meta": result["meta"]},
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )
    (out_dir / "meta.json").write_text(
        json.dumps(result["meta"], ensure_ascii=False, indent=2), encoding="utf-8"
    )


def instruction(gold: dict | None = None, *, delivery: str = "reply") -> str:
    """The instruction text for a kv_store instance."""
    from ..scaffold import instruction as _instruction

    return _instruction(FAMILY, delivery=delivery)


def main(argv: list[str] | None = None) -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument(
        "--records", "-R", type=int, default=120,
        help="number of SET ops (most are never queried)",
    )
    ap.add_argument(
        "--value-words", type=int, default=24,
        help="random words per value (incompressibility and volume knob)",
    )
    ap.add_argument(
        "--queries", "-Q", type=int, default=24,
        help="number of GET ops, delivered at the end of the stream",
    )
    ap.add_argument(
        "--records-per-chunk", type=int, default=20,
        help="SET ops batched per stream op (keeps the turn count feasible)",
    )
    ap.add_argument("--out-dir", type=Path, required=True)
    args = ap.parse_args(argv)
    result = generate(
        seed=args.seed,
        records=args.records,
        value_words=args.value_words,
        queries=args.queries,
        records_per_chunk=args.records_per_chunk,
    )
    write_outputs(args.out_dir, result)
    print(json.dumps(result["meta"], indent=2))


if __name__ == "__main__":
    main()
