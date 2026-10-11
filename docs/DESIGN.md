# ContextBench design

ContextBench is the public release of the benchmark called LiveCtxBench in the internal code
(paper name: ContextBench). Four task families stream more input than fits in the agent's
context window and grade what the agent kept, updated, or offloaded. Everything the agent
has to do is expressed as ordinary user turns, so any chat agent can be evaluated.

## Families (unchanged from the paper)

| family | stream | query | reward |
|---|---|---|---|
| kv_store | batches of `SET key = value` records | `GET key` after all batches | fraction of GETs answered with the right value |
| log_triage | batches of log lines | count / lookup questions | fraction of questions answered correctly |
| needle_retention | document chunks, each with a few needle lines and a large filler block | none; the agent keeps needle lines | fraction of needle lines present verbatim in the final context (or in the final report, see graders) |
| sudoku_sketchpad | one move per turn; the agent re-prints the board with a bumped version | none | fraction of gold board versions whose exact content the agent displayed |

Instance = `chunks.jsonl` (one op per line: `{"index", "header", "body"}`), `gold.json`, `meta.json`.
Pressure `P = streamed_body_tokens / context_budget` (o200k tokenizer, `len//3` fallback).
Feasibility gate at generation: `P > 1`, every op <= 0.9 * budget/5, retained mass <= 0.9 * budget/2, >= 4 ops.
Paper levels and seeds live in `clm_exp/configs/paper.yaml` (budget 32768, reserve 2048, seeds 42-49).

## Turn protocol

1. system prompt (agent's own) + instruction (family scaffold: contracts below, no method text).
2. op 0 delivered as a user turn: `=== {header} ({remaining} op(s) remaining after this) ===\n{body}`.
3. The agent works; when ready for the next op it signals readiness. Readiness is
   `READY_FOR_NEXT_OP` as a standalone line in the reply (Python runner) or as a standalone
   bash command `echo READY_FOR_NEXT_OP` (Harbor agents with a shell). Non-standalone use is
   explained back to the agent and does not advance.
4. Submitting before the stream is drained is refused with an explanation. After the last op,
   the run ends on submit (`terminated_by = submit`) or when the agent asks for another op
   (`stream_exhausted`). Other terminations: `budget_wall`, `timeout`, `max_steps`.

Answer contracts (graded out of the agent's messages, never from disk):
- kv: `<<<ANSWER key=K>>> value <<<ANSWER END>>>`
- log: `<<<ANSWER qid=N>>> answer <<<ANSWER END>>>`
- needle: keep `[n…#…]` lines verbatim; agents that cannot expose their context print the kept
  lines between `<<<NEEDLES BEGIN>>>` / `<<<NEEDLES END>>>` at the end (graded as `final_report`).
- sudoku: reprint the panel between `<<<SKETCHPAD BEGIN>>>` / `<<<SKETCHPAD END>>>` with the
  `VERSION: n` line bumped after each move.

## Two ways to run

### A. Python runner (no containers)

```python
from contextbench import run, ContextAgent

class MyAgent(ContextAgent):
    def reset(self, system: str, instruction: str) -> None: ...
    def on_user_turn(self, text: str) -> str: ...      # reply text
    def context(self) -> list[dict]: ...               # current messages for snapshots

result = run(MyAgent(), instance_dir, budget=32768, reserve=2048, out_dir="runs/x")
```
The runner delivers ops, records `context_snapshots/turn-NNNN.json` (`{"step", "tokens", "messages"}`)
after every turn, enforces the budget wall on `context()` tokens, and grades. The only agent
shipped for it is `oracle.py`, which answers from gold and must score 1.0; it is the self-check
for instances, protocol and graders, not a method.

### B. Harbor (containers, stock and custom agents)

Harbor >= 0.16 is the target. A ContextBench task package is a normal single-step Harbor task:
`instruction.md`, `task.toml`, `environment/` (Dockerfile or `docker_image`, plus `stream/chunks.jsonl`,
which Harbor uploads into the container work dir on every backend, including Singularity, which has
no compose sidecars), `tests/` (host-side gold + feasibility receipt), `solution/`.

Why not Harbor `[[steps]]`: Harbor 0.16 does re-invoke the same agent object per step in the same
container, but every stock agent starts a fresh LLM conversation on each `run()` (terminus_2 resets
its chat explicitly; the installed CLI agents run one-shot `claude --print` / `codex exec` with no
resume). A step per op would therefore wipe the context the benchmark is about. Ops must be
delivered inside one conversation.

Delivery = `contextbench.harbor.TurnSource`: it loads the ops once from the container
(`cat <workdir>/stream/chunks.jsonl`, count and body sha checked against `task.toml`), then
deletes the stream from the container so the agent cannot read ahead with its shell, renders them,
and answers `pending(last_command, last_exit) -> list[str]` with the next op when the agent's last
command was the standalone `echo READY_FOR_NEXT_OP`; it also owns refusal of early submit and the
`terminated_by` bookkeeping. Agents consume it in three ways, all shipped in `contextbench.harbor.agents`:

1. `CBStreamMixin` (`contextbench.harbor.mixin`): for any Python agent loop. `cb_setup(environment)`,
   `cb_initial_turns()`, `cb_pending(last_command, last_exit)` and `cb_over_budget(messages)` (which
   also writes `context_snapshots/turn-NNNN.json`) are the whole integration. `ContextBenchAgent`
   (minimal bash-tool loop, append-only) and the CLM adapter outside this repository are built on it.
2. `Terminus2Stream(Terminus2)`: subclass of Harbor's own terminus_2 with narrow overrides
   (`run`, a wrapper around `_run_agent_loop`, `_execute_commands`, `_handle_llm_interaction`): the
   next op is appended to the prompt variable that carries terminus's next user turn, after its own
   summarization had its chance, and recorded as an ATIF `user` step. tmux gives no exit code, so
   readiness also requires the echo's own output line in the terminal. No file in Harbor is patched;
   the same change is provided as `patches/harbor-0.16-terminus2-turn-source.patch`.
3. `contextbench.harbor.wrap.cb_stream(AgentCls)`: wraps a Harbor installed CLI agent whose session
   can be resumed and raises for any other (a fresh conversation per op would wipe the context under
   test). `wrap:CodexStream` and `wrap:MiniSweAgentStream` are the registered ones. They keep
   one session across many invocations. `codex exec` starts the session with the instruction
   and op 0; every later user turn is a `codex exec resume <thread>` whose prompt is the op
   (or a one-line reminder when a turn ended without the readiness command). mini-swe-agent's
   CLI cannot resume, so its library's own `DefaultAgent` is driven one step per call by a small
   in-container driver that reloads the saved messages each time. Whatever compaction the CLI
   performs on its own is the harness under test. (Claude Code is out of scope: it needs an
   Anthropic-compatible endpoint.)

Invariant for every path: an op enters the agent's context as a user message appended by the
harness, before the agent can act on it. The agent controls only *when* the next op arrives, never
its content or its route into the context. A pull design (the agent fetches the op as a tool
observation) breaks this, because observations pass through the harness's truncation and offload
paths before they reach the context; it is not offered.

Each task grades itself through Harbor's default verifier: after the agent has finished, Harbor
copies `tests/` into the container and runs `tests/test.sh`, which runs a copy of the graders
vendored into `tests/_cb/` (standard library only, so no verifier flag is needed). For images
without `python3` the same grading runs host-side as `contextbench.harbor.verifiers:ContextBenchVerifier`
(the family is read from the gold). Either way the graders read, in order of preference:
`agent/context_snapshots/turn-*.json` (context-exposing agents, paper metric), else the ATIF
`trajectory.json` (steps flattened to user / assistant / tool messages), else the final report.
Harbor's reward dict must be numeric, so the source is recorded as `graded_from_code`
(3 snapshots, 2 trajectory, 1 final report) and the full result, with `graded_from` and
`terminated_by` as strings, goes to `verifier/contextbench_result.json`.

## Package layout

```
contextbench/
  __init__.py            run(), ContextAgent, load_instance
  tasks/<family>/        generate.py (CLI + generate()), scaffold.md, levels in clm_exp/configs/paper.yaml
  stream.py              Op, render_op, is_ready_marker, refusal texts, terminated_by
  feasibility.py         evaluate(), receipt
  tokens.py              count_tokens (tiktoken o200k, fallback), snapshot writer
  graders/               kv.py log.py needle.py sudoku.py  (+ base.py with the three readers)
  runner.py              Python runner
  oracle.py              gold-answer agent: self-check for instances, protocol and graders
  harbor/                package.py (task builder, --all), turn_source.py, mixin.py (CBStreamMixin),
                         agents/ (ContextBenchAgent, Terminus2Stream), wrap.py (cb_stream,
                         CodexStream, MiniSweAgentStream), reward.py (grading for test.sh and
                         the host verifier), verifiers.py (host-side BaseVerifier)
  cli.py                 contextbench generate | check | run | grade | package
clm_exp/                 paper experiment: configs/paper.yaml (levels, seeds), skills/ (method skills)
environment/             contextbench.def, contextbench-cli-agents.def (Singularity image recipes)
patches/                 harbor-0.16-terminus2-turn-source.patch
tests/                   oracle-driven, no model needed
tools/audit_trial.py     trace audit of one Harbor trial (docs/HARBOR_SMOKE.md)
```

## Rules for this repository

- Apache-2.0; English only in code, comments and docs.
- No internal cluster paths, gateway or quota model ids, board or job ids, people or seat names.
- Reproduces the paper's levels and metrics; deviations are listed in `docs/DEVIATIONS.md`.
- Numbers in docs come from `clm_exp/configs/paper.yaml` or from a run, never typed in.
