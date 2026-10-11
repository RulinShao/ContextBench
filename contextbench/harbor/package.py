"""Build a Harbor task directory from a generated ContextBench instance.

Layout written into ``<out_dir>/<name>/``::

    instruction.md                 family scaffold (bash delivery) [+ method section]
    task.toml                      docker_image, workdir, stream identity, timeouts
    environment/stream/chunks.jsonl  the ops; uploaded into the container work dir
    tests/gold.json                never in the agent's container (see below)
    tests/meta.json
    tests/feasibility_receipt.json
    tests/test.sh                  grades /logs/agent with the vendored graders
    tests/_cb/contextbench/        the graders, standard library only
    solution/solve.sh              oracle: writes the gold answers as a final report

What the agent can see inside the container: the work directory (with the stream
until :class:`~contextbench.harbor.turn_source.TurnSource` loads and removes it at
the start of ``run()``) and ``/logs``. Harbor copies ``tests/`` into the container
only after the agent has finished, to run ``tests/test.sh`` (its default verifier,
so a trial needs no verifier flag), and ``solution/`` only for its oracle agent. The
gold therefore never reaches the agent. ``test.sh`` needs ``python3`` in the image;
for an image without it, grade on the host with
``contextbench.harbor.verifiers:ContextBenchVerifier``.

This module imports nothing from Harbor; the task is plain files.
"""

from __future__ import annotations

import json
import re
import shutil
from pathlib import Path
from typing import Any

from .. import feasibility
from ..levels import iter_levels, level_knobs, level_regime
from ..runner import Instance, instruction_for, load_instance
from ..stream import ADVANCE_MARKER, SUBMIT_MARKER, render_op
from .turn_source import (
    ENV_STREAM_COUNT,
    ENV_STREAM_PATH,
    ENV_STREAM_SHA256,
    STREAM_RELPATH,
    canonical_sha256,
)

__all__ = ["DEFAULT_WORKDIR", "VERIFIER_IMPORT_PATH", "build_all", "build_task",
           "oracle_report", "task_name"]

#: The container work directory; the stream lands at ``<workdir>/stream/``.
DEFAULT_WORKDIR = "/app"

#: What a trial or job config sets as ``verifier.import_path`` for these tasks.
VERIFIER_IMPORT_PATH = "contextbench.harbor.verifiers:ContextBenchVerifier"

_FAMILY_TAGS = {
    "kv_store": ["kv-store", "storage-offloading"],
    "log_triage": ["log-triage", "aggregation"],
    "needle_retention": ["needle-retention", "selective-retention"],
    "sudoku_sketchpad": ["sudoku", "state-update"],
}

_TEST_SH = """#!/usr/bin/env bash
# Grades the agent's own messages (context snapshots, else trajectory, else final
# report) with the ContextBench graders vendored next to this script. Runs after the
# agent has finished; writes /logs/verifier/reward.json.
set -u
PY=$(command -v python3 || command -v python) || {
  echo "ContextBench grading needs python3 in the image; or verify on the host with" \
       "contextbench.harbor.verifiers:ContextBenchVerifier" >&2
  exit 2
}
PYTHONPATH=/tests/_cb "$PY" -m contextbench.harbor.reward \
  --agent-dir /logs/agent --gold /tests/gold.json --out-dir /logs/verifier
"""

#: The package files ``tests/_cb`` needs to grade: standard library only.
_VENDORED = (
    "__init__.py", "runner.py", "stream.py", "tokens.py",
    "graders/__init__.py", "graders/base.py", "graders/kv.py", "graders/log.py",
    "graders/needle.py", "graders/sudoku.py",
    "harbor/__init__.py", "harbor/mixin.py", "harbor/turn_source.py",
    "harbor/reward.py",
)


def _vendor_graders(tests_dir: Path) -> None:
    root = Path(__file__).resolve().parent.parent
    for rel in _VENDORED:
        dst = tests_dir / "_cb" / "contextbench" / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(root / rel, dst)


def task_name(instance: Instance) -> str:
    """``<family>-<knob values>-seed<seed>``, stable for one instance."""
    meta = instance.meta
    fam = instance.family
    knobs = {
        "kv_store": ("records",),
        "log_triage": ("lines",),
        "needle_retention": ("needles_per_chunk", "chunks"),
        "sudoku_sketchpad": ("box",),
    }.get(fam, ())
    parts = [fam]
    for k in knobs:
        if k in meta:
            parts.append(f"{k[0].upper()}{meta[k]}")
    parts.append(f"seed{meta.get('seed', 0)}")
    return "-".join(parts).replace("_", "-")


def _strip_markers(reply: str) -> str:
    lines = [
        ln for ln in reply.splitlines()
        if ln.strip() not in (ADVANCE_MARKER, SUBMIT_MARKER)
    ]
    return "\n".join(lines).strip()


def oracle_report(instance: Instance) -> str:
    """Every gold answer an ideal agent would have printed, as one report.

    Produced by running the phase-1 oracle over the rendered ops, so the Harbor
    oracle and the Python-runner oracle cannot disagree.
    """
    from ..oracle import OracleAgent

    agent = OracleAgent(instance.path)
    agent.reset("", "")
    bodies: list[str] = []
    for i, op in enumerate(instance.ops):
        reply = agent.on_user_turn(render_op(op, remaining=instance.n_ops - (i + 1)))
        body = _strip_markers(reply)
        if body:
            bodies.append(body)
    return "\n".join(bodies) + "\n"


def _toml_str(value: Any) -> str:
    return json.dumps(str(value))


def _toml_value(value: Any) -> str | None:
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return repr(value)
    if isinstance(value, str):
        return _toml_str(value)
    return None


def _task_toml(
    instance: Instance,
    *,
    image: str,
    workdir: str,
    stream_count: int,
    stream_sha: str,
    verdict: dict,
    agent_timeout_sec: float,
    verifier_timeout_sec: float,
    method_name: str | None,
) -> str:
    fam = instance.family
    tags = ["context-management", "contextbench", *(_FAMILY_TAGS.get(fam) or [])]
    lines = [
        "[metadata]",
        'author_name = "contextbench"',
        'difficulty = "medium"',
        'category = "context-management"',
        "tags = [" + ", ".join(_toml_str(t) for t in tags) + "]",
        f"contextbench_family = {_toml_str(fam)}",
        f"contextbench_budget_tokens = {int(verdict['budget'])}",
        f"contextbench_reserve_tokens = {int(verdict['reserve'])}",
        f"contextbench_pressure = {float(verdict['P'])}",
        f"contextbench_feasible = {'true' if verdict['feasible'] else 'false'}",
        f"contextbench_regime = {_toml_str(str(verdict.get('regime', 'pressure')))}",
        f"contextbench_stream_count = {stream_count}",
        f"contextbench_stream_sha256 = {_toml_str(stream_sha)}",
    ]
    if method_name:
        lines.append(f"contextbench_method_section = {_toml_str(method_name)}")
    for key, value in sorted(instance.meta.items()):
        rendered = _toml_value(value)
        if rendered is not None and re.fullmatch(r"[A-Za-z0-9_]+", key):
            lines.append(f"instance_{key} = {rendered}")
    lines += [
        "",
        "[verifier]",
        f"timeout_sec = {float(verifier_timeout_sec)}",
        "",
        "[agent]",
        f"timeout_sec = {float(agent_timeout_sec)}",
        "",
        "[environment]",
        f"docker_image = {_toml_str(image)}",
        f"workdir = {_toml_str(workdir)}",
        "build_timeout_sec = 600.0",
        "cpus = 1",
        "memory_mb = 2048",
        "storage_mb = 4096",
        "",
        "[environment.env]",
        f"{ENV_STREAM_COUNT} = {_toml_str(stream_count)}",
        f"{ENV_STREAM_SHA256} = {_toml_str(stream_sha)}",
        f"{ENV_STREAM_PATH} = {_toml_str(workdir.rstrip('/') + '/' + STREAM_RELPATH)}",
        "",
    ]
    return "\n".join(lines)


def build_task(
    instance_dir: Path | str,
    out_dir: Path | str,
    *,
    image: str,
    name: str | None = None,
    workdir: str = DEFAULT_WORKDIR,
    budget: int = feasibility.BUDGET_DEFAULT,
    reserve: int = feasibility.RESERVE_DEFAULT,
    method_section: str | None = None,
    method_name: str | None = None,
    agent_timeout_sec: float = 14400.0,
    verifier_timeout_sec: float = 600.0,
    require_feasible: bool = True,
    overwrite: bool = False,
    regime: str = "pressure",
) -> Path:
    """Write one Harbor task directory and return its path.

    ``image`` is the task's ``docker_image``: a Docker reference, or a prebuilt
    ``.sif`` path for Singularity (see ``environment/contextbench.def``).
    ``method_section`` is appended to the instruction verbatim, for evaluating a
    method with its own method skill; the task contract itself is never
    changed. An infeasible instance is refused unless ``require_feasible`` is off;
    ``regime`` is the feasibility regime it is gated under (``sub-budget`` for the
    paper's rungs below one budget of input).
    """
    instance = load_instance(instance_dir)
    verdict = feasibility.evaluate(instance.path, budget, reserve, regime=regime)
    if require_feasible and not verdict["feasible"]:
        raise ValueError(
            "instance fails the feasibility gate:\n" + feasibility.format_verdict(verdict)
        )

    task_dir = Path(out_dir) / (name or task_name(instance))
    if task_dir.exists():
        if not overwrite:
            raise FileExistsError(f"{task_dir} exists (pass overwrite=True to replace it)")
        shutil.rmtree(task_dir)
    (task_dir / "environment" / "stream").mkdir(parents=True)
    (task_dir / "tests").mkdir()
    (task_dir / "solution").mkdir()

    # The stream: copied byte for byte; the identity is canonical, not byte-level.
    src_chunks = instance.path / "chunks.jsonl"
    records = [json.loads(ln) for ln in src_chunks.read_text(encoding="utf-8").splitlines()
               if ln.strip()]
    shutil.copyfile(src_chunks, task_dir / "environment" / STREAM_RELPATH)
    stream_sha = canonical_sha256(records)

    instruction = instruction_for(instance, delivery="bash").rstrip("\n") + "\n"
    if method_section:
        instruction += "\n" + method_section.strip("\n") + "\n"
    (task_dir / "instruction.md").write_text(instruction, encoding="utf-8")

    (task_dir / "task.toml").write_text(
        _task_toml(
            instance,
            image=image,
            workdir=workdir,
            stream_count=len(records),
            stream_sha=stream_sha,
            verdict=verdict,
            agent_timeout_sec=agent_timeout_sec,
            verifier_timeout_sec=verifier_timeout_sec,
            method_name=method_name,
        ),
        encoding="utf-8",
    )

    shutil.copyfile(instance.path / "gold.json", task_dir / "tests" / "gold.json")
    shutil.copyfile(instance.path / "meta.json", task_dir / "tests" / "meta.json")
    feasibility.write_receipt(task_dir / "tests", verdict)
    test_sh = task_dir / "tests" / "test.sh"
    test_sh.write_text(_TEST_SH, encoding="utf-8")
    test_sh.chmod(0o755)
    _vendor_graders(task_dir / "tests")

    report = oracle_report(instance)
    delim = "CONTEXTBENCH_ORACLE_EOF"
    if delim in report:
        raise ValueError("oracle report contains the heredoc delimiter")
    solve = task_dir / "solution" / "solve.sh"
    solve.write_text(
        "#!/usr/bin/env bash\n"
        "# Oracle: writes every gold answer into the agent log dir as a final report.\n"
        "# Graded as graded_from=final_report, never comparable to a context grade.\n"
        "set -euo pipefail\n"
        "mkdir -p /logs/agent\n"
        f"cat > /logs/agent/final_report.txt <<'{delim}'\n{report}{delim}\n",
        encoding="utf-8",
    )
    solve.chmod(0o755)
    return task_dir


def build_all(
    config: dict,
    out_dir: Path | str,
    *,
    image: str,
    instances_dir: Path | str | None = None,
    families: list[str] | None = None,
    seeds: list[int] | None = None,
    overwrite: bool = False,
    main_figure_only: bool = False,
    **task_kwargs: Any,
) -> list[Path]:
    """Every level x seed of a levels config (``clm_exp/configs/paper.yaml``) as Harbor tasks.

    Each level is gated under its own ``regime``; ``main_figure_only`` keeps the
    levels marked ``main_figure``.

    Tasks land flat in ``out_dir`` as ``<family>-<level>-seed<seed>`` so the directory
    is a Harbor dataset (``harbor jobs start -p out_dir``); the generated instances
    go to ``instances_dir`` (default ``<out_dir>/../<name>_instances``).
    """
    import importlib

    out = Path(out_dir)
    inst_root = Path(instances_dir) if instances_dir else \
        out.parent / f"{out.name}_instances"
    budget = int((config.get("context") or {}).get("budget_tokens", 32768))
    reserve = int((config.get("context") or {}).get("reserve_tokens", 2048))
    built: list[Path] = []
    for family, spec, level in iter_levels(config, main_figure_only=main_figure_only):
        if families and family not in families:
            continue
        module = importlib.import_module(f"contextbench.tasks.{family}.generate")
        knobs = level_knobs(spec, level)
        regime = level_regime(level)
        for seed in seeds or config.get("seeds") or [42]:
            name = f"{family.replace('_', '-')}-{level['name']}-seed{seed}"
            inst = inst_root / name
            module.write_outputs(inst, module.generate(seed=seed, **knobs))
            feasibility.write_receipt(
                inst, feasibility.evaluate(inst, budget, reserve, regime=regime))
            built.append(build_task(inst, out, image=image, name=name,
                                    budget=budget, reserve=reserve, regime=regime,
                                    overwrite=overwrite, **task_kwargs))
    return built
