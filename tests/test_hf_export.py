"""The Hugging Face layout: parquet rows, Harbor registry, dataset card."""

from __future__ import annotations

import json
from pathlib import Path

import pytest

pq = pytest.importorskip("pyarrow.parquet")

from contextbench.hf_export import export_hf  # noqa: E402

CONFIG = {
    "context": {"budget_tokens": 32768, "reserve_tokens": 2048},
    "seeds": [42, 43],
    "families": {
        "kv_store": {
            "fixed": {"records_per_chunk": 100, "value_words": 24, "queries": 24},
            "levels": [{"name": "R1000", "records": 1000}],
        },
        "sudoku_sketchpad": {
            "fixed": {"box": 4, "givens": 90, "boards": 1},
            "levels": [{"name": "t15", "turns": 15}],
        },
    },
}


@pytest.mark.needs_o200k
def test_export_hf_layout(tmp_path: Path) -> None:
    out = tmp_path / "hf"
    summary = export_hf(CONFIG, out, repo_id="org/ContextBench",
                        paper_url="https://example.org/paper")
    assert summary["n_rows"] == 4 and summary["n_tasks"] == 4

    table = pq.read_table(out / "data" / "kv_store.parquet").to_pylist()
    assert [r["seed"] for r in table] == [42, 43]
    row = table[0]
    assert row["task_id"] == "kv-store-R1000-seed42"
    assert row["family"] == "kv_store" and row["level"] == "R1000"
    assert row["budget"] == 32768 and row["reserve"] == 2048
    assert row["n_ops"] == len(row["chunks"]) == 34
    assert set(row["chunks"][0]) == {"index", "header", "body"}
    assert row["pressure"] == pytest.approx(row["streamed_tokens"] / 32768, abs=1e-3)
    inst = tmp_path / "hf_instances" / row["task_id"]
    assert json.loads(row["gold"]) == json.loads((inst / "gold.json").read_text())
    assert json.loads(row["meta"]) == json.loads((inst / "meta.json").read_text())
    chunks = [json.loads(ln) for ln in (inst / "chunks.jsonl").read_text().splitlines()]
    assert row["chunks"] == chunks

    registry = json.loads((out / "registry.json").read_text())
    names = {d["name"]: d for d in registry}
    assert set(names) == {"contextbench", "contextbench-kv-store",
                          "contextbench-sudoku-sketchpad"}
    every = names["contextbench"]["tasks"]
    assert len(every) == 4
    for task in every:
        assert task["path"] == f"harbor/{task['name']}"
        assert (out / task["path"] / "task.toml").is_file()
        assert "git_url" not in task

    card = (out / "README.md").read_text()
    assert card.startswith("---\nlicense: apache-2.0\n")
    for cfg in ("all", "kv_store", "sudoku_sketchpad"):
        assert f"- config_name: {cfg}\n" in card
    assert "path: data/kv_store.parquet" in card and "path: data/*.parquet" in card
    assert "org/ContextBench" in card and "https://example.org/paper" in card
    assert "harbor jobs start --repo RulinShao/ContextBench -d contextbench" in card


@pytest.mark.needs_o200k
def test_registry_validates_against_harbor(tmp_path: Path) -> None:
    registry_models = pytest.importorskip("harbor.models.registry")
    out = tmp_path / "hf"
    export_hf(CONFIG, out, repo_id="org/ContextBench", paper_url="https://example.org/p",
              families=["kv_store"], seeds=[42])
    rows = json.loads((out / "registry.json").read_text())
    specs = [registry_models.DatasetSpec.model_validate(r) for r in rows]
    assert [s.name for s in specs] == ["contextbench", "contextbench-kv-store"]
    assert specs[0].tasks[0].to_source_task_id().path == Path("harbor/kv-store-R1000-seed42")


@pytest.mark.needs_o200k
def test_export_hf_harbor_subdir(tmp_path: Path) -> None:
    out = tmp_path / "hf"
    export_hf(CONFIG, out, repo_id="org/ContextBench", paper_url="https://example.org/p",
              families=["sudoku_sketchpad"], seeds=[42], harbor_subdir="tasks")
    rows = json.loads((out / "registry.json").read_text())
    assert rows[0]["tasks"] == [{"name": "sudoku-sketchpad-t15-seed42",
                                 "path": "tasks/sudoku-sketchpad-t15-seed42"}]
    assert (out / "tasks" / "sudoku-sketchpad-t15-seed42" / "task.toml").is_file()
    assert not (out / "harbor").exists()


def test_repository_registry_matches_tasks_dir() -> None:
    """The shipped registry.json lists exactly the task directories under tasks/."""
    root = Path(__file__).resolve().parent.parent
    if not (root / "registry.json").is_file():
        pytest.skip("no registry.json in this checkout")
    rows = {d["name"]: d for d in json.loads((root / "registry.json").read_text())}
    every = {t["name"]: t["path"] for t in rows["contextbench"]["tasks"]}
    on_disk = {p.name for p in (root / "tasks").iterdir() if (p / "task.toml").is_file()}
    assert set(every) == on_disk and len(on_disk) == 256
    assert all(path == f"tasks/{name}" for name, path in every.items())
    fam = [d for n, d in rows.items() if n != "contextbench"]
    assert sum(len(d["tasks"]) for d in fam) == 256
