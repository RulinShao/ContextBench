# ContextBench

ContextBench measures what an agent **keeps, updates, and offloads** when the input
does not fit. Four task families stream more content than the context window holds,
and the reward is read out of the agent's own messages: what survived in context, not
what ended up on disk. Everything the agent has to do is expressed as ordinary user
turns, so any chat agent can be evaluated, with or without tools.

- Paper: [Context Language Models](https://arxiv.org/abs/2609.37725) (arXiv:2609.37725)
- Dataset: [context-language-model/ContextBench](https://huggingface.co/datasets/context-language-model/ContextBench) on Hugging Face
- Context Language Models, which introduced the benchmark: [facebookresearch/context-language-models](https://github.com/facebookresearch/context-language-models)
- Run every task with Harbor in one line: `harbor jobs start --repo RulinShao/ContextBench@v0.1 -d contextbench -a <agent> -m <model> --verifier contextbench.harbor.verifiers:ContextBenchVerifier`

## Versions

**v0.1** hardens the graders and the runner against reward hacking (see
[`docs/DESIGN.md`](docs/DESIGN.md), threat model). It differs from the original release
used in the paper in how runs are recorded and graded (host-side verifier, new run
command) and in stricter answer extraction (see [`CHANGELOG.md`](CHANGELOG.md)); the
task streams and gold answers are unchanged. The original release remains available at
tag `v0.0-paper`.

v0.1 lives on the `v0.1` branch of this repository and the `v0.1` revision of the
Hugging Face dataset; the commands below pin it (`--repo RulinShao/ContextBench@v0.1`,
`revision="v0.1"`), and `git clone -b v0.1` gets this code. Every grade records
`benchmark_version` (`contextbench --version` shows it). Under v0.1 a run is gradable
only when it is verified with `--verifier contextbench.harbor.verifiers:ContextBenchVerifier` and its harness records the context it sends
through the snapshot recorder on the host (`CBStreamMixin`, or
`contextbench.tokens.SnapshotLog(harness_dir_for(logs_dir))`). Integrations written for
the original release need the host verifier flag and the snapshot recorder. Changes are
listed in [`CHANGELOG.md`](CHANGELOG.md).

## Install

```bash
pip install -e .                    # core: pyyaml, numpy
pip install -e '.[tokenizer]'       # exact o200k token counts
```

`tiktoken` is optional: without it token counts fall back to a character estimate,
and every reward and gate reports which method it used. The core never imports the
container runtime.

## Quickstart

```python
from contextbench import run
from contextbench.oracle import OracleAgent
from contextbench.tasks.kv_store import generate, write_outputs

write_outputs("instances/kv-R1000-seed42",
              generate(seed=42, records=1000, records_per_chunk=100,
                       value_words=24, queries=24))

# Check the generated task first: the gold oracle must score 1.0. The oracle reads
# the answers from gold.json, so it is a task self-check only, never a baseline.
result = run(OracleAgent("instances/kv-R1000-seed42"),
             "instances/kv-R1000-seed42",
             budget=32768, reserve=2048, out_dir="runs/kv-R1000-seed42")
print(result["reward"], result["terminated_by"], result["peak_tokens"])
```

Your own agent needs three methods -- `reset(system, instruction)`,
`on_user_turn(text) -> str`, and `context() -> list[dict]`, the message list the
runner snapshots and measures against the budget. The same four steps run from the
command line:

```bash
contextbench generate --family kv_store --level R1000 --seed 42 --out-dir instances/kv
contextbench check    --instance-dir instances/kv
contextbench run      --instance-dir instances/kv --out-dir runs/kv   # gold-oracle self-check
contextbench grade    --run-dir runs/kv --instance-dir instances/kv
```

## Families

| family | stream | query | reward |
|---|---|---|---|
| `kv_store` | batches of `SET key = value`, values are random tokens | `GET key` after every batch | fraction of GETs answered with the right value |
| `log_triage` | batches of service log lines | count and lookup questions | fraction of questions answered correctly |
| `needle_retention` | chunks of a few needle lines and a large filler block | none: the agent keeps the needles | fraction of needle lines still present verbatim |
| `sudoku_sketchpad` | one fully specified move per turn | none: the agent reprints the board | fraction of gold board versions the agent displayed |

An instance is three files: `chunks.jsonl` (one operation per line, as
`{"index", "header", "body"}`), `gold.json`, and `meta.json`. Pressure is
`P = streamed tokens / budget`, and generation refuses an instance an ideal policy
could not pass: `P > 1`, every operation at most `0.9 * usable/5`, retained mass at
most `0.9 * usable/2`, and at least four operations, where
`usable = budget - reserve`. The levels and seeds of record live in
[`clm_exp/configs/paper.yaml`](clm_exp/configs/paper.yaml).

## The turn protocol

One operation per user turn, rendered as
`=== {header} ({remaining} op(s) remaining after this) ===` and the body. The agent
works, then signals readiness: `READY_FOR_NEXT_OP` on a line of its own for a chat
agent, or `echo READY_FOR_NEXT_OP` as a standalone shell statement for an agent with
a shell. Neither counts when the marker appears as an argument or inside answer
data, because a spurious advance would consume an operation that is then lost.
Submitting before the stream is drained is refused and explained. A run ends as
`submit`, `stream_exhausted`, `budget_wall`, `timeout`, or `max_steps`.

**The budget.** The benchmark counts every context in `o200k_base` tokens, for every
agent: a run hits the wall (`budget_wall`) when the context it is about to send exceeds
`budget - reserve` o200k tokens. An agent may enforce a stricter budget of its own, for
example one calibrated to its served model's tokenizer; that is part of the agent's
behaviour, not of the benchmark. The wall applies to the turns of the main conversation:
a side call an agent makes to compact its own context (a summarization request) is
recorded but does not end the run, even when it exceeds the budget.

Graders read the per-turn context snapshots the harness wrote (`context_snapshots/turn-*.json`)
and nothing else: there is no fallback to a trajectory or a report for a scored run.
A snapshot is checked against the task's budget (`contextbench_budget_tokens` in
`task.toml`): it must record that budget, and no context sent to the model (the
`kind="sent"` snapshots, or every snapshot for a harness that records no such kind) may
hold more tokens than the budget, except the context that hit the wall at the very end
of a `budget_wall` run.
The grader recounts every snapshot with `o200k_base` and records the budget in
`reward.json` (`budget_tokens`, `reserve_tokens`, `tokens_verified=1`). Where it cannot
count with `o200k_base` (no `tiktoken` or no vocabulary, as with the standard-library
copy in `tests/_cb`), it never judges a run on its character estimate: it checks the
token counts the harness recorded (sha256-protected by the manifest) and reports
`tokens_verified=0` with a `token_note`.

ANSWER blocks (kv store, log triage) are read only from what the agent produced:
assistant messages and tool output, never the instruction or the ops. Each question has
one answer, the **last** block for it (latest snapshot first, then the later message in
that snapshot), so an agent may correct an answer and a later wrong answer replaces a
right one; this holds across snapshots too, so the answer of record is the last one the
run produced. A block counts only with each marker at the start of its own line, as the
instruction shows it; a mention of the format inside other text, or a one-line
`<<<ANSWER key=K>>> value <<<ANSWER END>>>`, is not an answer. A reply that is a JSON
object (terminus-2's command format) is read decoded, from its top-level text fields.
Keys and qids are matched exactly (`K00007` is not `k00007`). A kv value and a log lookup
must equal the gold after whitespace normalization (a log message's trailing `#hex` tag is optional); a count must state
exactly one number. Needle retention reads the whole final snapshot and the sudoku
grader every message of every snapshot, as before.

An answer is credited once it appears in any snapshot. A Harbor agent snapshots the
context it is about to send to the model, and it also snapshots each turn's context, tool
output included, before its own compaction runs (`manage_context` in `ContextBenchAgent`,
terminus-2's summarization). An answer that the harness compacts away right after it
arrives therefore still counts. The Python runner snapshots `context()` after each turn,
so an agent driven through it should compact at the start of its next turn rather than
right after producing an answer.

## Harbor

ContextBench tasks also run as ordinary single-step [Harbor](https://github.com/laude-institute/harbor)
tasks (Harbor >= 0.16, `pip install -e '.[harbor]'`), with the ops still arriving as
user messages in one conversation. The 256 paper tasks live in this repository under
[`tasks/`](tasks/), with [`registry.json`](registry.json) at the root, so Harbor runs
them straight from GitHub with no local build:

```bash
harbor jobs start --repo RulinShao/ContextBench@v0.1 -d contextbench \
    -a contextbench.harbor.agents:Terminus2Stream -m openai/MODEL \
    --agent-kwarg api_base=http://HOST:PORT/v1 \
    --verifier contextbench.harbor.verifiers:ContextBenchVerifier
```

`-d contextbench-<family>` (for example `contextbench-kv-store`) selects one family and
`-i <task>` one task (`-i` takes a glob). `tasks/` and `registry.json` are the output of
`contextbench export-hf --harbor-subdir tasks` (below). To build the tasks yourself instead:

```bash
contextbench package --all --config clm_exp/configs/paper.yaml --out-dir cb_tasks/   # 256 tasks

harbor trials start -p cb_tasks/kv-store-R1000-seed42 \
    -a contextbench.harbor.agents:Terminus2Stream -m openai/MODEL \
    --agent-kwarg api_base=http://HOST:PORT/v1 \
    --verifier contextbench.harbor.verifiers:ContextBenchVerifier
harbor jobs start -p cb_tasks/ -a contextbench.harbor.wrap:CodexStream -m openai/MODEL \
    --agent-kwarg api_base=http://HOST:PORT/v1 -n 8 \
    --verifier contextbench.harbor.verifiers:ContextBenchVerifier
```

The same tasks are published as the Hugging Face dataset
[context-language-model/ContextBench](https://huggingface.co/datasets/context-language-model/ContextBench),
readable with `datasets.load_dataset` (one config per family plus `all`; pass
`revision="v0.1"` for this version) and, once downloaded
(`hf download ... --repo-type dataset --revision v0.1`), runnable with `harbor jobs start --registry-path registry.json -d contextbench -a <agent> -m <model> --verifier contextbench.harbor.verifiers:ContextBenchVerifier`.
`contextbench export-hf` writes that layout (`data/*.parquet`, `harbor/`, `registry.json`, `README.md`) for any
levels file (`pip install -e '.[hf]'`):

```bash
contextbench export-hf --config clm_exp/configs/paper.yaml --repo-id context-language-model/ContextBench --out-dir hf/
contextbench export-hf ... --revision v0.1   # the card for the v0.1 revision
```

**Grading is host-side only.** Every run needs
`--verifier contextbench.harbor.verifiers:ContextBenchVerifier`; a run without it is not
a valid scored run, whatever reward file it may show. The harness writes the
context snapshots to `<trial_dir>/contextbench_harness/`, a sibling of the `agent/`
directory that Harbor does not mount into the container, and the verifier grades them on
the host. Harbor takes the reward from the verifier's return value, never from a file
the agent could have written; read it from the trial's `result.json`, not from
`verifier/reward.json`. The tasks set `[verifier] environment_mode = "separate"`, so
Harbor stops the agent's container before verification and empties the verifier
directory in a fresh container. That does not make a run without the flag safe: on
Singularity, a process the agent detaches from its session (`setsid`) survives Harbor's
container stop and can keep writing into the trial's `verifier/` directory (observed with
Harbor 0.16.1). Without the flag Harbor's default verifier finds no `tests/test.sh` in
the fresh container and the trial normally ends with no reward (the script itself only
deletes reward files and exits non-zero). A run that cannot be graded (no snapshots, a snapshot file the harness did not
write, a changed or unreadable one, a manifest that was never closed, a budget mismatch)
is **invalid**: the verifier writes `contextbench_result.json` with the reason, no
`reward.json`, and fails, instead of reporting a zero.

To check a task, its gold and its grader with the oracle solution, run Harbor's oracle
agent with the verifier's oracle mode, which refuses any trial whose `config.json` does
not name that agent:

```bash
harbor trials start -p cb_tasks/kv-store-R1000-seed42 -a oracle \
    --verifier contextbench.harbor.verifiers:ContextBenchVerifier --verifier-kwarg mode=oracle
```

`contextbench grade --task-dir <task> --run-dir <trial_dir>` grades a finished trial
offline (pass the trial dir; an agent logs dir is refused), and so does the
copy of the graders in each task's `tests/_cb/`, standard library only:
`python3 -I -c 'import sys; sys.path.insert(0, sys.argv.pop(1)); from contextbench.harbor.reward import main; sys.exit(main())' <task>/tests/_cb --run-dir <trial_dir> --task-dir <task> --out-dir <dir>`.

`--mode legacy --run-dir <trial_dir>/agent` re-grades a run folder written before
v0.1, offline. Such folders cannot meet v0.1's recording rules, so the grade is weaker
than a scored one and meant only for runs whose provenance was checked by other means
(`tools/audit_trial.py`): it reads snapshots from the agent-writable logs dir with no
manifest, and takes `terminated_by` from the agent-writable `interactive_stream.json`
(or `usage.json` when that file does not record it; `terminated_by_from` says which).
Its budget check is **advisory**: old snapshots do not say which context was sent to the
model, so the run is scored and the outcome is reported (`budget_checked="advisory"`,
`budget_ok`, `budget_note`, `budget_max_tokens`, `n_snapshots_over_budget`) instead of
making it invalid. Scored runs (harness mode) enforce the budget
(`budget_checked="enforced"`).

**What the grader assumes.** The agent controls its container, including `/logs/agent`
and `/logs/verifier`; it does not control the host. The snapshots are written by the
harness process on the host, outside the container, and the grader accepts only files
listed with their sha256 in the harness's closed `snapshot_manifest.jsonl`. Host-side
writes into the directories the container can reach never follow a symlink. Budget,
reserve and gold come from the task directory on the host. A scored run is one graded by
`--verifier contextbench.harbor.verifiers:ContextBenchVerifier`; a run without that flag
is not a valid scored run.

`CodexStream` and `MiniSweAgentStream` are not tamper-proof against an adversarial
agent. Their CLI runs inside the container and keeps its session in `/logs/agent`, and
the harness builds the snapshots from those session files. The files are the context the
CLI resumes from, but a process in the container can rewrite them between turns, so what
the snapshots record is only as trustworthy as the agent. The harnesses that run on the
host (`ContextBenchAgent`, `Terminus2Stream`, and any harness built on `CBStreamMixin`)
snapshot the messages they send themselves.

Only single-step Harbor tasks are supported: the tasks have no `[[steps]]`, and the
verifier is not designed for multi-step trials.

On Singularity, Harbor 0.16.1 does not kill a process the agent detached with `setsid`
when it stops the container; such a process can keep writing files into the trial's
`verifier/` directory (including `reward.json` and `contextbench_result.json`) after the
trial. The score of record is the one in the trial's `result.json`, which Harbor writes
on the host from the verifier's return value.
The tasks set `network_mode = "public"` (Harbor's default) explicitly: agents that run in
the container reach their model endpoint from it, and Singularity/Apptainer cannot
enforce anything stricter. The gold and the oracle solution are public in this
repository; where the provider can enforce it, run host-side harnesses with
`network_mode = "no-network"`.

**Container image.** Tasks use `python:3.12-slim`, which works as is on Docker
(`-e docker`). For Singularity/Apptainer (`-e singularity`), build the image from
[`environment/contextbench.def`](environment/contextbench.def) under the name Harbor
looks up for `python:3.12-slim`, and point Harbor at that directory:

```bash
apptainer build sif_cache/python_3.12-slim.sif environment/contextbench.def
harbor jobs start --repo RulinShao/ContextBench@v0.1 -d contextbench -e singularity \
    --ek singularity_image_cache_dir=$PWD/sif_cache -a <agent> -m <model> \
    --verifier contextbench.harbor.verifiers:ContextBenchVerifier
```

`environment/contextbench-cli-agents.def` adds codex and mini-swe-agent. `contextbench
package --image` also accepts a `.sif` path for tasks you build yourself.

The task ships its ops in `environment/stream/chunks.jsonl`. Every agent below reads
them once through `contextbench.harbor.TurnSource`, which checks them against
`task.toml`, deletes them from the container, and releases the next one only after a
standalone `echo READY_FOR_NEXT_OP`.

| `-a` | harness | how an op arrives |
|---|---|---|
| `contextbench.harbor.agents:ContextBenchAgent` | minimal bash-tool loop, append-only | user message after the tool result |
| `contextbench.harbor.agents:Terminus2Stream` | Harbor's terminus-2, with its own summarization | appended to terminus's next user turn |
| `contextbench.harbor.wrap:CodexStream` | codex, with its own compaction | the next `codex exec resume` prompt |
| `contextbench.harbor.wrap:MiniSweAgentStream` | mini-swe-agent's `DefaultAgent`, resumed step by step | user message in the saved session |

**Your own installed agent.** `contextbench.harbor.wrap.cb_stream(AgentCls)` wraps a
Harbor installed agent whose CLI can resume a session (codex, mini-swe-agent and their
subclasses); it raises for any other, rather than fall back to a fresh conversation per
op. `patches/harbor-0.16-terminus2-turn-source.patch` is the in-place equivalent of
`Terminus2Stream`.

**Your own Python agent.** Add `CBStreamMixin` and three calls to your loop:

```python
from contextbench.harbor import CBStreamMixin

class MyAgent(CBStreamMixin, BaseAgent):
    async def run(self, instruction, environment, context):
        await self.cb_setup(environment)                                       # 1
        messages = [{"role": "user", "content": instruction}]
        messages += self.cb_user_turns(self.cb_initial_turns())
        while not self.cb_done:
            if self.cb_over_budget(messages):                                  # 2
                break
            command, result = ...          # your model call and tool execution
            messages += [assistant_msg, tool_msg]
            messages += self.cb_user_turns(self.cb_pending(command, result.code))  # 3
        self.cb_finish(None, messages)
```

`cb_over_budget` also writes the per-turn context snapshot the graders read, into the
host-only snapshot root; `cb_finish` closes its manifest (a run whose manifest is never
closed is invalid). `ContextBenchAgent` is built exactly this way. A harness that keeps
its own message list but not this mixin's loop must still write its snapshots through
`contextbench.tokens.SnapshotLog(harness_dir_for(self.logs_dir))`; snapshots written
anywhere else are not graded.

## Documentation

- [`docs/DESIGN.md`](docs/DESIGN.md) -- the full design, including the container path.
- [`docs/DEVIATIONS.md`](docs/DEVIATIONS.md) -- every place this release differs from
  the original benchmark code, and the rulings behind those differences.
- [`docs/HARBOR_SMOKE.md`](docs/HARBOR_SMOKE.md) -- end-to-end Harbor trials with a real
  model, and an audit of their traces.
- [`docs/MULTIFRAME_GRADING.md`](docs/MULTIFRAME_GRADING.md) -- a proposal (not
  implemented) for timing-aware needle and sudoku rewards.

## Development

```bash
pip install -e '.[dev]'
pytest                       # oracle-driven, no network, no model calls
```

The test suite runs the oracle agent through every family and requires reward 1.0: an
oracle that scores less means the instance, the protocol, or a grader is broken.

## Citation

ContextBench was introduced in the Context Language Models paper. If you use it, please cite:

```bibtex
@article{shao2026context,
  title   = {Context Language Models},
  author  = {Shao, Rulin and Shen, Shannon Zejiang and Yin, Junjie Oscar and Li, Yuetai and
             Wang, Minheng and Ivison, Hamish and Poovendran, Radha and Lambert, Nathan and
             Xiao, Teng and Lewis, Mike and Yih, Wen-tau and Zettlemoyer, Luke and Koh, Pang Wei},
  journal = {arXiv preprint arXiv:2609.37725},
  year    = {2026}
}
```

## License

Licensed under Apache-2.0.
