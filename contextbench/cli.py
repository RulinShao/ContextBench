"""``contextbench generate | check | run | grade | package | export-hf``.

``generate`` writes an instance from ``clm_exp/configs/paper.yaml`` (or from explicit
knobs), ``check`` runs the feasibility gate, ``run`` drives the gold oracle through
the Python runner as a self-check, ``grade`` scores a finished run directory, and ``package`` builds
a Harbor task directory from an instance, and ``export-hf`` writes the Hugging Face
dataset layout (parquet, Harbor tasks, ``registry.json``, dataset card).
"""

from __future__ import annotations

import argparse
import importlib
import json
import sys
from pathlib import Path
from typing import Any

from . import feasibility
from .graders import grade_run
from .levels import level_knobs, level_regime
from .tasks.scaffold import FAMILIES

__all__ = ["main"]

#: The paper's levels file, shipped inside the package so a wheel install can read it.
#: ``clm_exp/configs/paper.yaml`` in the source tree is a byte-identical copy (tested).
DEFAULT_CONFIG = Path(__file__).resolve().parent / "configs" / "paper.yaml"


# ------------------------------------------------------------------------- config
def load_config(path: Path | str | None = None) -> dict:
    """Read a levels file. Requires ``pyyaml``."""
    try:
        import yaml
    except ImportError:
        raise SystemExit(
            "reading a levels file needs pyyaml: install it, or pass explicit knobs"
        ) from None
    p = Path(path or DEFAULT_CONFIG)
    return yaml.safe_load(p.read_text(encoding="utf-8"))


def resolve_level(config: dict, family: str, level: str) -> dict:
    """The knobs for one named level: the family's fixed knobs plus the level's."""
    fam = (config.get("families") or {}).get(family)
    if fam is None:
        raise SystemExit(f"config has no family {family!r}")
    return level_knobs(fam, level_entry(config, family, level))


def level_entry(config: dict, family: str, level: str) -> dict:
    """The config entry of one named level (knobs plus descriptive keys)."""
    fam = (config.get("families") or {}).get(family)
    if fam is None:
        raise SystemExit(f"config has no family {family!r}")
    for entry in fam.get("levels") or []:
        if entry.get("name") == level:
            return entry
    names = ", ".join(e.get("name", "?") for e in fam.get("levels") or [])
    raise SystemExit(f"family {family!r} has no level {level!r}; known: {names}")


def _parse_knobs(pairs: list[str]) -> dict[str, Any]:
    """``--knob records=1000`` pairs into typed values."""
    out: dict[str, Any] = {}
    for pair in pairs or []:
        if "=" not in pair:
            raise SystemExit(f"--knob expects key=value, got {pair!r}")
        key, _, raw = pair.partition("=")
        try:
            out[key.strip()] = int(raw)
        except ValueError:
            out[key.strip()] = raw
    return out


def _generator(family: str):
    if family not in FAMILIES:
        raise SystemExit(f"unknown family {family!r}; known: {', '.join(FAMILIES)}")
    return importlib.import_module(f"contextbench.tasks.{family}.generate")


# ----------------------------------------------------------------------- commands
def cmd_generate(args: argparse.Namespace) -> int:
    module = _generator(args.family)
    knobs: dict[str, Any] = {}
    regime = args.regime
    if args.level:
        config = load_config(args.config)
        knobs.update(resolve_level(config, args.family, args.level))
        regime = regime or level_regime(level_entry(config, args.family, args.level))
    knobs.update(_parse_knobs(args.knob))
    knobs["seed"] = args.seed

    result = module.generate(**knobs)
    module.write_outputs(args.out_dir, result)

    verdict = feasibility.evaluate(
        args.out_dir, args.budget, args.reserve, args.prompt_tokens, regime or "pressure"
    )
    if args.receipt:
        feasibility.write_receipt(args.out_dir, verdict)
    print(json.dumps({"meta": result["meta"], "feasible": verdict["feasible"]}, indent=2))
    if not verdict["feasible"]:
        print(feasibility.format_verdict(verdict), file=sys.stderr)
        return 1
    return 0


def cmd_check(args: argparse.Namespace) -> int:
    argv = ["--budget", str(args.budget), "--reserve", str(args.reserve),
            "--prompt-tokens", str(args.prompt_tokens), "--regime", args.regime]
    if args.scan:
        argv += ["--scan", str(args.scan)]
    else:
        argv += ["--instance-dir", str(args.instance_dir)]
    if args.json:
        argv.append("--json")
    if args.receipt:
        argv.append("--write-receipt")
    return feasibility.main(argv)


def cmd_run(args: argparse.Namespace) -> int:
    from .runner import run

    from .oracle import OracleAgent

    # The CLI runs the gold oracle only: a self-check that an instance, the protocol
    # and the graders agree. Evaluate a real agent from Python or through Harbor.
    agent: Any = OracleAgent(args.instance_dir)

    result = run(
        agent,
        args.instance_dir,
        budget=args.budget,
        reserve=args.reserve,
        out_dir=args.out_dir,
        max_turns=args.max_turns,
        overwrite=args.overwrite,
    )
    print(json.dumps(result, indent=2, default=str))
    return 0


def cmd_grade(args: argparse.Namespace) -> int:
    gold_path = args.gold or Path(args.instance_dir or args.run_dir) / "gold.json"
    rewards = grade_run(args.run_dir, gold_path)
    print(json.dumps(rewards, indent=2, default=str))
    return 0 if rewards.get("grader_valid") else 2


def cmd_package(args: argparse.Namespace) -> int:
    from .harbor.package import build_all, build_task

    method = Path(args.method_file).read_text(encoding="utf-8") if args.method_file else None
    method_name = args.method_name or (Path(args.method_file).stem if method else None)
    if args.all:
        if method and len(args.family or []) != 1:
            raise SystemExit("--method-file with --all needs exactly one --family "
                             "(a method file is written for one family)")
        tasks = build_all(
            load_config(args.config), args.out_dir, image=args.image,
            families=args.family or None,
            seeds=[int(x) for x in args.seeds.split(",")] if args.seeds else None,
            overwrite=args.overwrite, agent_timeout_sec=args.agent_timeout_sec,
            workdir=args.workdir, main_figure_only=args.main_figure,
            method_section=method, method_name=method_name,
        )
        print(json.dumps({"out_dir": str(args.out_dir), "n_tasks": len(tasks),
                          "tasks": [t.name for t in tasks]}, indent=2))
        return 0
    if not args.instance_dir:
        raise SystemExit("package needs --instance-dir, or --all with --config")
    task_dir = build_task(
        args.instance_dir,
        args.out_dir,
        image=args.image,
        name=args.name,
        workdir=args.workdir,
        budget=args.budget,
        reserve=args.reserve,
        method_section=method,
        method_name=method_name,
        agent_timeout_sec=args.agent_timeout_sec,
        require_feasible=not args.allow_infeasible,
        overwrite=args.overwrite,
    )
    print(json.dumps({"task_dir": str(task_dir)}, indent=2))
    return 0


def cmd_export_hf(args: argparse.Namespace) -> int:
    from .hf_export import export_hf

    summary = export_hf(
        load_config(args.config), args.out_dir, repo_id=args.repo_id,
        paper_url=args.paper_url, image=args.image, version=args.version,
        instances_dir=args.instances_dir,
        seeds=[int(x) for x in args.seeds.split(",")] if args.seeds else None,
        families=args.family or None, overwrite=args.overwrite,
        harbor_repo=args.harbor_repo, harbor_subdir=args.harbor_subdir,
    )
    print(json.dumps(summary, indent=2))
    return 0


# -------------------------------------------------------------------------- parser
def _add_budget_args(ap: argparse.ArgumentParser) -> None:
    ap.add_argument("--budget", type=int, default=feasibility.BUDGET_DEFAULT)
    ap.add_argument("--reserve", type=int, default=feasibility.RESERVE_DEFAULT)


def build_parser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser(prog="contextbench", description=__doc__.splitlines()[0])
    sub = ap.add_subparsers(dest="command", required=True)

    gen = sub.add_parser("generate", help="write one instance to a directory")
    gen.add_argument("--family", required=True, choices=list(FAMILIES))
    gen.add_argument("--out-dir", type=Path, required=True)
    gen.add_argument("--seed", type=int, default=42)
    gen.add_argument("--level", help="a level name from the config, e.g. R1000")
    gen.add_argument("--config", type=Path, default=None)
    gen.add_argument("--knob", action="append", default=[],
                     help="key=value knob override; repeatable")
    gen.add_argument("--prompt-tokens", type=int,
                     default=feasibility.PROMPT_TOKENS_DEFAULT)
    gen.add_argument("--regime", choices=["pressure", "sub-budget"], default=None,
                     help="feasibility regime (default: the level's, else pressure)")
    gen.add_argument("--receipt", action="store_true",
                     help="also write feasibility_receipt.json")
    _add_budget_args(gen)
    gen.set_defaults(func=cmd_generate)

    chk = sub.add_parser("check", help="run the feasibility gate")
    group = chk.add_mutually_exclusive_group(required=True)
    group.add_argument("--instance-dir", type=Path)
    group.add_argument("--scan", type=Path)
    chk.add_argument("--prompt-tokens", type=int,
                     default=feasibility.PROMPT_TOKENS_DEFAULT)
    chk.add_argument("--regime", choices=["pressure", "sub-budget"], default="pressure")
    chk.add_argument("--json", action="store_true")
    chk.add_argument("--receipt", action="store_true")
    _add_budget_args(chk)
    chk.set_defaults(func=cmd_check)

    rn = sub.add_parser("run", help="run the gold oracle through one instance (self-check)")
    rn.add_argument("--instance-dir", type=Path, required=True)
    rn.add_argument("--out-dir", type=Path, required=True)
    rn.add_argument("--max-turns", type=int, default=None,
                    help="safety stop; unset runs the full horizon")
    rn.add_argument("--overwrite", action="store_true",
                    help="delete a non-empty --out-dir first (otherwise refused)")
    _add_budget_args(rn)
    rn.set_defaults(func=cmd_run)

    gr = sub.add_parser("grade", help="score a finished run directory")
    gr.add_argument("--run-dir", type=Path, required=True)
    gr.add_argument("--instance-dir", type=Path, default=None,
                    help="where gold.json lives, if not in the run directory")
    gr.add_argument("--gold", type=Path, default=None)
    gr.set_defaults(func=cmd_grade)

    pk = sub.add_parser("package", help="build Harbor task directories")
    pk.add_argument("--instance-dir", type=Path, default=None,
                    help="one generated instance to package")
    pk.add_argument("--all", action="store_true",
                    help="generate and package every level x seed of --config")
    pk.add_argument("--config", type=Path, default=None,
                    help="levels file for --all (default: the packaged paper.yaml)")
    pk.add_argument("--family", action="append", default=[],
                    help="with --all: only these families (repeatable)")
    pk.add_argument("--seeds", default=None, help="with --all: comma list of seeds")
    pk.add_argument("--main-figure", action="store_true",
                    help="with --all: only the levels marked main_figure")
    pk.add_argument("--out-dir", type=Path, required=True,
                    help="parent directory; the task lands in <out-dir>/<name>")
    pk.add_argument("--image", default="python:3.12-slim",
                    help="task docker_image: a Docker reference or a prebuilt .sif path "
                         "(default: python:3.12-slim)")
    pk.add_argument("--name", default=None, help="task directory name")
    pk.add_argument("--workdir", default="/app", help="container work directory")
    pk.add_argument("--method-file", default=None,
                    help="markdown appended verbatim to the instruction (a method skill)")
    pk.add_argument("--method-name", default=None)
    pk.add_argument("--agent-timeout-sec", type=float, default=14400.0)
    pk.add_argument("--allow-infeasible", action="store_true")
    pk.add_argument("--overwrite", action="store_true")
    _add_budget_args(pk)
    pk.set_defaults(func=cmd_package)

    hf = sub.add_parser("export-hf",
                        help="write the Hugging Face dataset layout for a levels config")
    hf.add_argument("--out-dir", type=Path, required=True)
    hf.add_argument("--config", type=Path, default=None,
                    help="levels file (default: the packaged paper.yaml)")
    hf.add_argument("--repo-id", required=True,
                    help="<org>/<name> the dataset is published as; used in the card")
    hf.add_argument("--paper-url", default="https://huggingface.co/papers/2609.37725")
    hf.add_argument("--image", default="python:3.12-slim")
    hf.add_argument("--version", default="1.0", help="registry dataset version")
    hf.add_argument("--harbor-repo", default="RulinShao/ContextBench",
                    help="GitHub repo holding the tasks + registry.json, for the card's --repo line")
    hf.add_argument("--harbor-subdir", default="harbor",
                    help="directory the Harbor tasks are written to (the repository uses tasks)")
    hf.add_argument("--instances-dir", type=Path, default=None)
    hf.add_argument("--family", action="append", default=[])
    hf.add_argument("--seeds", default=None)
    hf.add_argument("--overwrite", action="store_true")
    hf.set_defaults(func=cmd_export_hf)

    return ap


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
