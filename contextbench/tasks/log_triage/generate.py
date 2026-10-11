#!/usr/bin/env python3
"""Deterministic generator for the *Incident Log Triage* family.

A practical companion to ``kv_store``: an on-call engineer is streamed a long
service log in batches, then must answer incident questions about it. The natural
winning move is to park each batch outside the context and search the saved copies
when a question arrives, which is how real log triage works.

Stream layout::

    # batches of log lines, one batch per op:
    2026-06-20T14:32:07Z [ERROR] auth-svc req=ab12cd34 message words ... #h
    2026-06-20T14:32:08Z [INFO] cache-svc req=... message words ... #h
    ...
    # then QUERY ops, one per op:
    QUERY 0: How many [ERROR] lines are from service "auth-svc"?
    QUERY 1: What is the message of the line with req=ab12cd34?

Two query types: ``count`` (count the lines matching a level and service, answered
with an integer) and ``lookup`` (the message text of a unique ``req=<id>`` line,
answered verbatim). Both are answerable by searching the saved log; neither is
answerable from a lossy summary (exact messages, exact counts), nor after deletion
(the data is gone), nor by pre-surfacing answers to questions not yet asked -- and
an agent that keeps the whole log in context overflows once it is large enough.

Each batch is wrapped in unique BEGIN/END sentinel lines so the whole batch can be
moved out of context with one anchored edit regardless of batch size.

Outputs into ``out_dir``: ``chunks.jsonl``, ``gold.json``, ``meta.json``.
"""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import random
from pathlib import Path

__all__ = ["generate", "write_outputs", "instruction", "FAMILY"]

FAMILY = "log_triage"

SERVICES = ["auth-svc", "cache-svc", "api-gw", "db-proxy", "worker", "billing"]
LEVELS = ["INFO", "WARN", "ERROR"]
#: Skewed so ERROR is rarer, which is realistic and makes the counts non-trivial.
LEVEL_WEIGHTS = [0.6, 0.25, 0.15]
MSG_WORDS = [
    "timeout", "retry", "connection", "refused", "latency", "spike", "cache",
    "miss", "token", "expired", "deadlock", "rollback", "throttled", "queue",
    "backlog", "handshake", "reset", "upstream", "downstream", "shard",
    "replica", "lag", "heartbeat", "evicted", "pool", "exhausted", "quota",
]

#: Log timestamps start here and advance one second per line.
EPOCH = dt.datetime(2026, 6, 20, 14, 0, 0)


def _hash(*parts: object) -> str:
    return hashlib.sha1(":".join(str(p) for p in parts).encode()).hexdigest()[:8]


def _ts(base_epoch: int, i: int) -> str:
    return (EPOCH + dt.timedelta(seconds=base_epoch + i)).strftime(
        "%Y-%m-%dT%H:%M:%SZ"
    )


def _approx_tokens(strings: list[str]) -> int:
    return sum(len(s) + 1 for s in strings) // 4


def generate(
    *,
    seed: int = 42,
    lines: int = 400,
    lines_per_batch: int = 20,
    queries: int = 20,
) -> dict:
    """Build the log stream and the questions for one instance."""
    rng = random.Random(seed)

    log: list[dict] = []
    for i in range(lines):
        level = rng.choices(LEVELS, weights=LEVEL_WEIGHTS, k=1)[0]
        svc = rng.choice(SERVICES)
        req = _hash(seed, "req", i)
        n_words = rng.randint(4, 9)
        msg = " ".join(rng.choice(MSG_WORDS) for _ in range(n_words))
        tag = _hash(seed, "msg", i)
        text = f"{_ts(0, i)} [{level}] {svc} req={req} {msg} #{tag}"
        log.append(
            {
                "i": i,
                "level": level,
                "svc": svc,
                "req": req,
                "msg": f"{msg} #{tag}",
                "text": text,
            }
        )

    # Gold answers are computed exactly from the log. Half lookups, half counts,
    # with at least one of each whenever possible.
    gold_queries: list[dict] = []
    qid = 0
    n_lookup = max(1, queries // 2)
    n_count = max(1, queries - n_lookup)

    for ln in rng.sample(log, min(n_lookup, len(log))):
        prompt = f'What is the message of the log line with req={ln["req"]}?'
        gold_queries.append(
            {"qid": qid, "type": "lookup", "prompt": prompt, "answer": ln["msg"]}
        )
        qid += 1

    for _ in range(n_count):
        level = rng.choice(LEVELS)
        svc = rng.choice(SERVICES)
        count = sum(1 for ln in log if ln["level"] == level and ln["svc"] == svc)
        prompt = f'How many [{level}] log lines are from service "{svc}"?'
        gold_queries.append(
            {"qid": qid, "type": "count", "prompt": prompt, "answer": str(count)}
        )
        qid += 1

    chunk_objs: list[dict] = []
    idx = 0
    for start in range(0, len(log), lines_per_batch):
        batch = log[start : start + lines_per_batch]
        lb_id = f"{idx:04d}#{_hash(seed, 'lb', idx)}"
        begin = (
            f"<<<LOG-BATCH {lb_id} BEGIN -- offload this whole block this turn>>>"
        )
        end = f"<<<LOG-BATCH {lb_id} END>>>"
        body = begin + "\n" + "\n".join(ln["text"] for ln in batch) + "\n" + end
        chunk_objs.append(
            {
                "index": idx,
                "header": f"log batch (lines {start}-{start + len(batch) - 1})",
                "body": body,
            }
        )
        idx += 1

    for q in gold_queries:
        body = (
            f"QUERY {q['qid']}: {q['prompt']}\n"
            f"(Answer with an ANSWER block for qid={q['qid']}.)"
        )
        chunk_objs.append({"index": idx, "header": f"query {q['qid']}", "body": body})
        idx += 1

    meta = {
        "task_family": FAMILY,
        "seed": seed,
        "lines": lines,
        "lines_per_batch": lines_per_batch,
        "queries": len(gold_queries),
        "n_lookup": n_lookup,
        "n_count": n_count,
        "n_batches": (len(log) + lines_per_batch - 1) // lines_per_batch,
        "n_actions": len(chunk_objs),
        "approx_log_tokens": _approx_tokens([ln["text"] for ln in log]),
    }
    return {"chunks": chunk_objs, "queries": gold_queries, "meta": meta}


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
    """The instruction text for a log_triage instance."""
    from ..scaffold import instruction as _instruction

    return _instruction(FAMILY, delivery=delivery)


def main(argv: list[str] | None = None) -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument(
        "--lines", "-L", type=int, default=400, help="total log lines (volume knob)"
    )
    ap.add_argument(
        "--lines-per-batch", type=int, default=20,
        help="log lines delivered per stream op",
    )
    ap.add_argument("--queries", "-Q", type=int, default=20)
    ap.add_argument("--out-dir", type=Path, required=True)
    args = ap.parse_args(argv)
    result = generate(
        seed=args.seed,
        lines=args.lines,
        lines_per_batch=args.lines_per_batch,
        queries=args.queries,
    )
    write_outputs(args.out_dir, result)
    print(json.dumps(result["meta"], indent=2))


if __name__ == "__main__":
    main()
