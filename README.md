# ContextBench

ContextBench measures what an agent **keeps, updates, and offloads** when the input
does not fit. Four task families stream more content than the context window holds,
and the reward is read out of the agent's own messages: what survived in context, not
what ended up on disk. Everything the agent has to do is expressed as ordinary user
turns, so any chat agent can be evaluated, with or without tools.

- Paper: [Context Language Models](https://arxiv.org/abs/2609.37725) (arXiv:2609.37725)
- Dataset: [context-language-model/ContextBench](https://huggingface.co/datasets/context-language-model/ContextBench) on Hugging Face
- Context Language Models, which introduced the benchmark: [facebookresearch/context-language-models](https://github.com/facebookresearch/context-language-models)
- Run every task with Harbor in one line: `harbor jobs start --repo RulinShao/ContextBench -d contextbench -a <agent> -m <model>`

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

Graders read, in order of preference, the per-turn `context_snapshots/turn-*.json`
(the paper metric), an ATIF `trajectory.json`, or the final report -- and record
which one they used as `graded_from`, so numbers from different sources are never
compared by accident.

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
harbor jobs start --repo RulinShao/ContextBench -d contextbench \
    -a contextbench.harbor.agents:Terminus2Stream -m openai/MODEL \
    --agent-kwarg api_base=http://HOST:PORT/v1
```

`-d contextbench-<family>` (for example `contextbench-kv-store`) selects one family and
`-i <task>` one task (`-i` takes a glob). `tasks/` and `registry.json` are the output of
`contextbench export-hf --harbor-subdir tasks` (below). To build the tasks yourself instead:

```bash
contextbench package --all --config clm_exp/configs/paper.yaml --out-dir cb_tasks/   # 256 tasks

harbor trials start -p cb_tasks/kv-store-R1000-seed42 \
    -a contextbench.harbor.agents:Terminus2Stream -m openai/MODEL \
    --agent-kwarg api_base=http://HOST:PORT/v1
harbor jobs start -p cb_tasks/ -a contextbench.harbor.wrap:CodexStream -m openai/MODEL \
    --agent-kwarg api_base=http://HOST:PORT/v1 -n 8
```

The same tasks are published as the Hugging Face dataset
[context-language-model/ContextBench](https://huggingface.co/datasets/context-language-model/ContextBench),
readable with `datasets.load_dataset` (one config per family plus `all`) and, once
downloaded, runnable with `harbor jobs start --registry-path registry.json -d contextbench`.
`contextbench export-hf` writes that layout (`data/*.parquet`, `harbor/`, `registry.json`, `README.md`) for any
levels file (`pip install -e '.[hf]'`):

```bash
contextbench export-hf --config clm_exp/configs/paper.yaml --repo-id context-language-model/ContextBench --out-dir hf/
```

No verifier flag is needed: each task grades itself after the agent has finished
(`tests/test.sh` runs a copy of the graders shipped in `tests/_cb/`, standard library
only). For an image without `python3`, grade on the host with
`--verifier-import-path contextbench.harbor.verifiers:ContextBenchVerifier`.

**Container image.** Tasks use `python:3.12-slim`, which works as is on Docker
(`-e docker`). For Singularity/Apptainer (`-e singularity`), build the image from
[`environment/contextbench.def`](environment/contextbench.def) under the name Harbor
looks up for `python:3.12-slim`, and point Harbor at that directory:

```bash
apptainer build sif_cache/python_3.12-slim.sif environment/contextbench.def
harbor jobs start --repo RulinShao/ContextBench -d contextbench -e singularity \
    --ek singularity_image_cache_dir=$PWD/sif_cache -a <agent> -m <model>
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

`cb_over_budget` also writes the per-turn context snapshot the graders read.
`ContextBenchAgent` is built exactly this way.

## Documentation

- [`docs/DESIGN.md`](docs/DESIGN.md) -- the full design, including the container path.
- [`docs/DEVIATIONS.md`](docs/DEVIATIONS.md) -- every place this release differs from
  the original benchmark code, and the rulings behind those differences.
- [`docs/HARBOR_SMOKE.md`](docs/HARBOR_SMOKE.md) -- end-to-end Harbor trials with a real
  model, and an audit of their traces.

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
