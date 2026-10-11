"""Export a levels config as a Hugging Face dataset repository.

Layout written into ``out_dir``::

    README.md                      dataset card (YAML ``configs:``: one per family + ``all``)
                                   (``harbor_subdir`` renames ``harbor/``; the
                                   ContextBench repository keeps its copy in ``tasks/``)
    data/<family>.parquet          one row per instance
    harbor/<task>/                 the packaged Harbor tasks (``contextbench package``)
    registry.json                  Harbor registry: datasets ``contextbench`` (every
                                   task) and ``contextbench-<family>``

Each parquet row holds one instance: ``task_id``, ``family``, ``level``, ``seed``,
``budget``, ``reserve``, ``n_ops``, ``streamed_tokens``, ``pressure``, ``chunks`` (a
list of ``{index, header, body}``), ``gold`` and ``meta`` (both JSON strings).

The same directory serves ``datasets.load_dataset("<org>/<name>", "<family>")`` and,
once downloaded, ``harbor jobs start --registry-path registry.json -d contextbench``
(or ``-p harbor/``). The card also points to a GitHub copy of ``harbor/`` and
``registry.json`` (``harbor_repo``) for ``harbor jobs start --repo``. Registry task
paths are repository-relative and carry no git URL or commit, so they resolve against
the checkout they are read from.

Needs ``pyarrow`` (the ``hf`` extra).
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from .harbor.package import build_all
from .levels import iter_levels

__all__ = ["REGISTRY_FILENAME", "export_hf", "registry_entries", "write_card"]

REGISTRY_FILENAME = "registry.json"
HARBOR_SUBDIR = "harbor"
DATA_SUBDIR = "data"
SPLIT = "test"


def _family_slug(family: str) -> str:
    return family.replace("_", "-")


def _instance_row(task_id: str, family: str, level: str, seed: int, inst: Path) -> dict:
    receipt = json.loads((inst / "feasibility_receipt.json").read_text(encoding="utf-8"))
    measured = receipt.get("measured") or {}
    chunks = [json.loads(ln) for ln in
              (inst / "chunks.jsonl").read_text(encoding="utf-8").splitlines() if ln.strip()]
    return {
        "task_id": task_id,
        "family": family,
        "level": level,
        "seed": int(seed),
        "budget": int(receipt["budget"]),
        "reserve": int(receipt["reserve"]),
        "n_ops": len(chunks),
        "streamed_tokens": int(measured["streamed_tokens"]),
        "pressure": float(measured["P"]),
        "chunks": [{"index": int(c["index"]), "header": str(c["header"]),
                    "body": str(c["body"])} for c in chunks],
        "gold": (inst / "gold.json").read_text(encoding="utf-8"),
        "meta": (inst / "meta.json").read_text(encoding="utf-8"),
    }


def _write_parquet(rows: list[dict], path: Path) -> None:
    import pyarrow as pa
    import pyarrow.parquet as pq

    schema = pa.schema([
        ("task_id", pa.string()),
        ("family", pa.string()),
        ("level", pa.string()),
        ("seed", pa.int32()),
        ("budget", pa.int32()),
        ("reserve", pa.int32()),
        ("n_ops", pa.int32()),
        ("streamed_tokens", pa.int64()),
        ("pressure", pa.float64()),
        ("chunks", pa.list_(pa.struct([("index", pa.int32()), ("header", pa.string()),
                                       ("body", pa.string())]))),
        ("gold", pa.string()),
        ("meta", pa.string()),
    ])
    table = pa.Table.from_pylist(rows, schema=schema)
    path.parent.mkdir(parents=True, exist_ok=True)
    # Small row groups keep the dataset viewer's page reads light: rows can be MBs.
    pq.write_table(table, path, row_group_size=8, compression="zstd")


def registry_entries(task_names: dict[str, list[str]], version: str,
                     description: str, subdir: str = HARBOR_SUBDIR) -> list[dict]:
    """Harbor ``registry.json`` rows: one dataset over every task, one per family."""
    def spec(name: str, desc: str, names: list[str]) -> dict:
        return {
            "name": name,
            "version": version,
            "description": desc,
            "tasks": [{"name": t, "path": f"{subdir}/{t}"} for t in sorted(names)],
        }

    every = sorted(t for names in task_names.values() for t in names)
    rows = [spec("contextbench", description, every)]
    for family, names in task_names.items():
        rows.append(spec(f"contextbench-{_family_slug(family)}",
                         f"{description} Family: {family}.", names))
    return rows


_CARD = """---
license: apache-2.0
pretty_name: ContextBench
language:
- en
tags:
- agents
- long-context
- context-management
- benchmark
size_categories:
- n<1K
configs:
{configs}
---

# ContextBench

ContextBench measures what an agent keeps, updates, and offloads when its input does
not fit in its context window. Each task streams a sequence of operations as ordinary
user turns, more than the context budget holds, and the reward is read from the
agent's own messages: what survived in its context, not what it wrote to disk.

Paper: [Context Language Models](https://arxiv.org/abs/2609.37725) ([paper page]({paper_url}))

## Families

| config | task | reward |
|---|---|---|
| `kv_store` | batches of `SET key = value`, then `GET key` queries | fraction of GETs answered with the right value |
| `log_triage` | batches of service log lines, then count and lookup questions | fraction of questions answered correctly |
| `needle_retention` | chunks with a few needle lines inside a large filler block | fraction of needle lines still present verbatim |
| `sudoku_sketchpad` | one fully specified move per turn on a 16x16 board | fraction of gold board versions the agent displayed |

The `all` config holds every instance. This release has {n_rows} instances:
{counts} ({n_levels} levels, seeds {seeds}), with a context budget of {budget} tokens
and a reserve of {reserve}.

## Columns

| column | type | meaning |
|---|---|---|
| `task_id` | string | `<family>-<level>-seed<seed>`, also the Harbor task directory name |
| `family` | string | task family |
| `level` | string | difficulty level |
| `seed` | int | generator seed |
| `budget` | int | context budget in tokens |
| `reserve` | int | tokens reserved for the reply; the agent may use `budget - reserve` |
| `n_ops` | int | number of streamed operations |
| `streamed_tokens` | int | tokens streamed over the episode (`o200k_base`) |
| `pressure` | float | `streamed_tokens / budget` |
| `chunks` | list of `{{index, header, body}}` | the operations, one user turn each |
| `gold` | string (JSON) | the answers the graders score against |
| `meta` | string (JSON) | generator settings and instance statistics |

The budget is counted in `o200k_base` tokens for every agent. An agent may enforce a
stricter budget of its own; that is part of the agent, not of the benchmark.

Each operation is shown to the agent as
`=== {{header}} ({{remaining}} op(s) remaining after this) ===` followed by its body.

## Usage

### With `datasets`

```python
import json
from datasets import load_dataset

ds = load_dataset("{repo_id}", "kv_store", split="{split}")   # or "all"
row = ds[0]
ops = row["chunks"]            # list of {{"index", "header", "body"}}
gold = json.loads(row["gold"])
```

To evaluate an agent from Python, install the `contextbench` package, write an
instance to disk, and pass your agent to `contextbench.run`:

```python
from pathlib import Path
from contextbench import run

inst = Path("instances") / row["task_id"]
inst.mkdir(parents=True, exist_ok=True)
(inst / "chunks.jsonl").write_text(
    "".join(json.dumps(c) + "\\n" for c in row["chunks"]))
(inst / "gold.json").write_text(row["gold"])
(inst / "meta.json").write_text(row["meta"])

result = run(my_agent, inst, budget=row["budget"], reserve=row["reserve"],
             out_dir=Path("runs") / row["task_id"])
```

### With Harbor

The `harbor/` directory holds one Harbor task per instance, and `registry.json`
lists the datasets `contextbench` (every task) and `contextbench-<family>`
(for example `contextbench-kv-store`). The same tasks are on GitHub, so Harbor runs
them in one line:

```bash
harbor jobs start --repo {harbor_repo} -d contextbench \\
    -a contextbench.harbor.agents:Terminus2Stream -m <model>
```

Or download this repository and run Harbor from inside it:

```bash
hf download {repo_id} --repo-type dataset --local-dir contextbench-hf
cd contextbench-hf
harbor jobs start --registry-path registry.json -d contextbench \\
    -a contextbench.harbor.agents:Terminus2Stream -m <model>
```

Use `-d contextbench-sudoku-sketchpad` for one family, `-i <task_id>` for one task,
`-p harbor/` to run the downloaded directory without the registry, or `-a oracle` to
check a task with its reference solution. Agents that deliver operations into a running
conversation ship with the `contextbench` package (`contextbench.harbor.agents`).

## Citation

ContextBench was introduced in the Context Language Models paper. If you use it, please cite:

```bibtex
@article{{shao2026context,
  title   = {{Context Language Models}},
  author  = {{Shao, Rulin and Shen, Shannon Zejiang and Yin, Junjie Oscar and Li, Yuetai and
             Wang, Minheng and Ivison, Hamish and Poovendran, Radha and Lambert, Nathan and
             Xiao, Teng and Lewis, Mike and Yih, Wen-tau and Zettlemoyer, Luke and Koh, Pang Wei}},
  journal = {{arXiv preprint arXiv:2609.37725}},
  year    = {{2026}}
}}
```

## License

Apache-2.0.
"""


DEFAULT_HARBOR_REPO = "RulinShao/ContextBench"


def write_card(out_dir: Path | str, *, repo_id: str, families: list[str],
               counts: dict[str, int], n_levels: int, seeds: list[int],
               budget: int, reserve: int, paper_url: str,
               harbor_repo: str = DEFAULT_HARBOR_REPO) -> Path:
    """Write ``README.md``: the dataset card with one config per family plus ``all``."""
    cfg = ['- config_name: all', '  default: true', '  data_files:',
           f'  - split: {SPLIT}', f'    path: {DATA_SUBDIR}/*.parquet']
    for family in families:
        cfg += [f'- config_name: {family}', '  data_files:',
                f'  - split: {SPLIT}', f'    path: {DATA_SUBDIR}/{family}.parquet']
    seed_text = (f"{min(seeds)}-{max(seeds)}" if seeds == list(range(min(seeds), max(seeds) + 1))
                 else ", ".join(str(s) for s in seeds))
    text = _CARD.format(
        configs="\n".join(cfg),
        paper_url=paper_url,
        n_rows=sum(counts.values()),
        counts=", ".join(f"{counts[f]} `{f}`" for f in families),
        n_levels=n_levels,
        seeds=seed_text,
        budget=budget,
        reserve=reserve,
        repo_id=repo_id,
        harbor_repo=harbor_repo,
        split=SPLIT,
    )
    path = Path(out_dir) / "README.md"
    path.write_text(text, encoding="utf-8")
    return path


def export_hf(
    config: dict,
    out_dir: Path | str,
    *,
    repo_id: str,
    paper_url: str,
    image: str = "python:3.12-slim",
    version: str = "1.0",
    instances_dir: Path | str | None = None,
    seeds: list[int] | None = None,
    families: list[str] | None = None,
    overwrite: bool = False,
    harbor_repo: str = DEFAULT_HARBOR_REPO,
    harbor_subdir: str = HARBOR_SUBDIR,
    **task_kwargs: Any,
) -> dict:
    """Build the whole repository layout under ``out_dir``; return a summary."""
    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)
    inst_root = Path(instances_dir) if instances_dir else out.parent / f"{out.name}_instances"
    seeds = list(seeds or config.get("seeds") or [42])

    tasks = build_all(config, out / harbor_subdir, image=image, instances_dir=inst_root,
                      families=families, seeds=seeds, overwrite=overwrite, **task_kwargs)
    built = {t.name for t in tasks}

    budget = int((config.get("context") or {}).get("budget_tokens", 32768))
    reserve = int((config.get("context") or {}).get("reserve_tokens", 2048))
    rows: dict[str, list[dict]] = {}
    n_levels = 0
    for family, _spec, level in iter_levels(config):
        if families and family not in families:
            continue
        n_levels += 1
        for seed in seeds:
            name = f"{_family_slug(family)}-{level['name']}-seed{seed}"
            if name not in built:
                raise RuntimeError(f"{name} was not packaged")
            rows.setdefault(family, []).append(
                _instance_row(name, family, str(level["name"]), seed, inst_root / name))

    for family, fam_rows in rows.items():
        _write_parquet(fam_rows, out / DATA_SUBDIR / f"{family}.parquet")

    task_names = {f: [r["task_id"] for r in fam_rows] for f, fam_rows in rows.items()}
    registry = registry_entries(
        task_names, version,
        "ContextBench: streamed tasks that exceed the context budget.", subdir=harbor_subdir)
    (out / REGISTRY_FILENAME).write_text(json.dumps(registry, indent=2) + "\n",
                                         encoding="utf-8")

    fams = list(rows)
    write_card(out, repo_id=repo_id, families=fams,
               counts={f: len(r) for f, r in rows.items()}, n_levels=n_levels,
               seeds=seeds, budget=budget, reserve=reserve, paper_url=paper_url,
               harbor_repo=harbor_repo)
    return {"out_dir": str(out), "n_rows": sum(len(r) for r in rows.values()),
            "rows_per_family": {f: len(r) for f, r in rows.items()},
            "n_tasks": len(tasks), "registry_datasets": [r["name"] for r in registry]}
