"""The command line: generate, check, run, grade."""

from __future__ import annotations

import json
from pathlib import Path

import pytest

from contextbench.cli import main, resolve_level
from contextbench.cli import load_config


@pytest.mark.needs_o200k
def test_generate_a_named_level(tmp_path: Path, capsys) -> None:
    out = tmp_path / "kv"
    rc = main(
        ["generate", "--family", "kv_store", "--level", "R1000", "--seed", "42",
         "--out-dir", str(out), "--receipt"]
    )
    assert rc == 0
    printed = json.loads(capsys.readouterr().out)
    assert printed["feasible"] is True
    assert printed["meta"]["records"] == 1000
    assert printed["meta"]["records_per_chunk"] == 100
    assert (out / "chunks.jsonl").is_file()
    assert (out / "feasibility_receipt.json").is_file()


def test_generate_with_knob_overrides(tmp_path: Path, capsys) -> None:
    out = tmp_path / "needle"
    rc = main(
        ["generate", "--family", "needle_retention", "--out-dir", str(out),
         "--knob", "chunks=24", "--knob", "needles_per_chunk=4",
         "--knob", "filler_lines_per_chunk=140", "--knob", "words_per_line=10"]
    )
    assert rc == 0
    assert json.loads(capsys.readouterr().out)["meta"]["chunks"] == 24


def test_generate_refuses_an_unknown_level(tmp_path: Path) -> None:
    with pytest.raises(SystemExit, match="no level"):
        main(["generate", "--family", "kv_store", "--level", "R999",
              "--out-dir", str(tmp_path / "x")])


@pytest.mark.needs_o200k
def test_check_reports_the_verdict(tmp_path: Path, capsys) -> None:
    out = tmp_path / "kv"
    main(["generate", "--family", "kv_store", "--level", "R1000",
          "--out-dir", str(out)])
    capsys.readouterr()
    assert main(["check", "--instance-dir", str(out), "--json"]) == 0
    verdicts = json.loads(capsys.readouterr().out)
    assert verdicts[0]["feasible"] is True


def test_run_then_grade(tmp_path: Path, capsys) -> None:
    instance = tmp_path / "instance"
    main(["generate", "--family", "log_triage", "--out-dir", str(instance),
          "--knob", "lines=400", "--knob", "lines_per_batch=14",
          "--knob", "queries=8"])
    capsys.readouterr()

    run_dir = tmp_path / "run"
    assert main(["run", "--instance-dir", str(instance), "--out-dir", str(run_dir),
                 "--budget", "8192", "--reserve", "1024"]) == 0
    result = json.loads(capsys.readouterr().out)
    assert result["reward"] == 1.0
    assert result["terminated_by"] == "submit"

    assert main(["grade", "--run-dir", str(run_dir),
                 "--instance-dir", str(instance)]) == 0
    rewards = json.loads(capsys.readouterr().out)
    assert rewards["reward"] == 1.0
    assert rewards["graded_from"] == "snapshots"


def test_every_family_and_level_resolves() -> None:
    config = load_config()
    for family, spec in config["families"].items():
        for level in spec["levels"]:
            knobs = resolve_level(config, family, level["name"])
            assert knobs
            assert "name" not in knobs


@pytest.mark.needs_o200k
def test_package_all_forwards_the_method_file(tmp_path: Path, capsys) -> None:
    method = tmp_path / "my_method.md"
    method.write_text("## Method\nKEEP-THIS-SENTENCE\n")
    out = tmp_path / "tasks"
    rc = main(["package", "--all", "--family", "kv_store", "--seeds", "42",
               "--method-file", str(method), "--out-dir", str(out)])
    assert rc == 0
    names = json.loads(capsys.readouterr().out)["tasks"]
    assert names
    for name in names:
        assert "KEEP-THIS-SENTENCE" in (out / name / "instruction.md").read_text()
        assert 'contextbench_method_section = "my_method"' in (out / name / "task.toml").read_text()


def test_package_all_method_file_needs_one_family(tmp_path: Path) -> None:
    method = tmp_path / "m.md"
    method.write_text("x\n")
    with pytest.raises(SystemExit):
        main(["package", "--all", "--seeds", "42", "--method-file", str(method),
              "--out-dir", str(tmp_path / "t")])
