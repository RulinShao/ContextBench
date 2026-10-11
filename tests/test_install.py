"""A non-editable wheel install carries everything the CLI needs (no source tree)."""

from __future__ import annotations

import os
import subprocess
import sys
import zipfile
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parent.parent


def test_packaged_config_matches_the_clm_exp_copy() -> None:
    packaged = ROOT / "contextbench" / "configs" / "paper.yaml"
    assert packaged.read_bytes() == (ROOT / "clm_exp" / "configs" / "paper.yaml").read_bytes()


def test_default_config_is_inside_the_package() -> None:
    from contextbench.cli import DEFAULT_CONFIG, load_config

    import contextbench

    assert Path(contextbench.__file__).resolve().parent in DEFAULT_CONFIG.resolve().parents
    assert len(load_config()["families"]) == 4


@pytest.mark.slow
@pytest.mark.needs_o200k
def test_wheel_install_runs_the_cli(tmp_path: Path) -> None:
    pytest.importorskip("setuptools")
    wheels = tmp_path / "wheels"
    build = subprocess.run(
        [sys.executable, "-m", "pip", "wheel", "--no-deps", "--no-build-isolation",
         "-q", "-w", str(wheels), str(ROOT)],
        capture_output=True, text=True)
    if build.returncode != 0:
        pytest.skip(f"cannot build a wheel here: {build.stderr[-300:]}")
    (wheel,) = wheels.glob("contextbench-*.whl")
    names = zipfile.ZipFile(wheel).namelist()
    assert "contextbench/configs/paper.yaml" in names
    assert all(n.startswith(("contextbench/", "contextbench-")) for n in names)

    venv = tmp_path / "venv"
    # System site-packages provide pyyaml/numpy (and pyarrow, if present) offline;
    # contextbench itself must come from the wheel, never the source tree.
    subprocess.run([sys.executable, "-m", "venv", "--system-site-packages", str(venv)],
                   check=True)
    py = venv / "bin" / "python"
    subprocess.run([str(py), "-m", "pip", "install", "-q", "--no-deps", "--force-reinstall",
                    str(wheel)], check=True)
    env = {k: v for k, v in os.environ.items() if k != "PYTHONPATH"}
    work = tmp_path / "work"
    work.mkdir()

    def cli(*args: str) -> subprocess.CompletedProcess:
        return subprocess.run([str(py), "-m", "contextbench.cli", *args], cwd=work,
                              env=env, capture_output=True, text=True)

    where = subprocess.run([str(py), "-c", "import contextbench; print(contextbench.__file__)"],
                           cwd=work, env=env, capture_output=True, text=True, check=True)
    assert str(venv) in where.stdout

    r = cli("generate", "--family", "kv_store", "--level", "R1000", "--seed", "42",
            "--out-dir", "inst")
    assert r.returncode == 0, r.stderr
    r = cli("package", "--all", "--family", "sudoku_sketchpad", "--seeds", "42",
            "--out-dir", "tasks")
    assert r.returncode == 0, r.stderr
    assert (work / "tasks" / "sudoku-sketchpad-t4-seed42" / "task.toml").is_file()
    probe = subprocess.run([str(py), "-c", "import pyarrow"], env=env, capture_output=True)
    if probe.returncode == 0:
        r = cli("export-hf", "--family", "kv_store", "--seeds", "42",
                "--repo-id", "org/ContextBench", "--out-dir", "hf")
        assert r.returncode == 0, r.stderr
        assert (work / "hf" / "data" / "kv_store.parquet").is_file()
