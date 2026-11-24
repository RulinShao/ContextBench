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
| needle_retention | document chunks, each with a few needle lines and a large filler block | none; the agent keeps needle lines | fraction of needle lines present verbatim in the final context |
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
- kv: an ANSWER block, each marker on its own line:
  ```
  <<<ANSWER key=K>>>
  value
  <<<ANSWER END>>>
  ```
  The one-line form `<<<ANSWER key=K>>> value <<<ANSWER END>>>` is not an answer (scores 0).
- log: the same block with `qid=N` and the answer between the two marker lines.
- For both: only assistant messages and tool output count (terminus-2's terminal turns are
  tool output; a JSON reply is read decoded). One answer per key or qid: the last block, in
  snapshot order and then message order, so a later answer replaces an earlier one, across
  snapshots too. Keys and qids are matched exactly (case-sensitive).
- needle: keep `[n…#…]` lines verbatim; they are graded in the final context snapshot. The
  `<<<NEEDLES BEGIN>>>` / `<<<NEEDLES END>>>` report is read only for the oracle solution
  (`mode=oracle`, graded as `final_report`), never for an agent.
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

Grading is host-side only: every run passes
`--verifier contextbench.harbor.verifiers:ContextBenchVerifier`, and a run without it is not a
valid scored run. Harbor records the host verifier's return value as the reward (the score of
record is the trial's `result.json`), never a file the agent could write. The tasks set
`[verifier] environment_mode = "separate"`: Harbor stops the agent's container before
verification and empties the verifier directory in a fresh container (where the host verifier
needs nothing). On Singularity a process started by the agent can survive that stop
(Harbor 0.16.1) and can still write into `verifier/`, which is why a run without the flag is
never a scored run. Only single-step tasks are supported. The harness writes the
per-turn snapshots through `contextbench.tokens.SnapshotLog` into
`<trial_dir>/contextbench_harness/`, a sibling of `agent/` that Harbor does not mount into
the container, together with `snapshot_manifest.jsonl` (each file's sha256, then a closing
line with the terminal reason) and a copy of `interactive_stream.json`. The verifier reads
the gold from the task's `tests/` and the budget from its `task.toml` metadata on the host,
and grades only manifest-listed, unmodified snapshots (see `contextbench/graders/base.py`
for the checks). Without the flag Harbor's default verifier finds no `tests/test.sh` in the
fresh container and the trial has no reward; the script itself grades nothing either (it
removes reward files from `/logs/verifier` and exits non-zero). The snapshot root passed to
an offline grade must not be an agent logs dir (a directory named `agent`, or one holding
agent log files): harness mode refuses it. Host-side writes into the directories the
container can reach never follow a symlink. An invalid run gets
`contextbench_result.json` with the reason and no `reward.json`, and the verifier raises.
Offline, `--mode legacy` re-grades run folders written before v0.1 (snapshots in the agent
dir, no manifest); its budget check is advisory (`budget_checked="advisory"`, `budget_ok`),
because those folders do not record which context was sent to the model.
`--verifier-kwarg mode=oracle` grades the oracle solution's `final_report.txt`, only in a
trial whose `config.json` names Harbor's `oracle` agent. Harbor's reward dict must be
numeric, so the source is recorded as `graded_from_code` (3 snapshots, 4 legacy snapshots,
1 final report), the mode as `grade_mode_code`, the task budget as `budget_tokens` /
`reserve_tokens`, and the full result, with `graded_from` and `terminated_by` as strings,
goes to `verifier/contextbench_result.json`. `tests/_cb/` keeps a standard-library copy of
the graders for grading a trial offline without installing the package.

## Package layout

```
contextbench/
  __init__.py            run(), ContextAgent, load_instance
  tasks/<family>/        generate.py (CLI + generate()), scaffold.md, levels in clm_exp/configs/paper.yaml
  stream.py              Op, render_op, is_ready_marker, refusal texts, terminated_by
  feasibility.py         evaluate(), receipt
  tokens.py              count_tokens (tiktoken o200k, fallback), SnapshotLog (snapshots + manifest)
  graders/               kv.py log.py needle.py sudoku.py  (+ base.py: sources, budget checks)
  runner.py              Python runner
  oracle.py              gold-answer agent: self-check for instances, protocol and graders
  harbor/                package.py (task builder, --all), turn_source.py, mixin.py (CBStreamMixin),
                         agents/ (ContextBenchAgent, Terminus2Stream), wrap.py (cb_stream,
                         CodexStream, MiniSweAgentStream), reward.py (reward files, offline
                         grading), verifiers.py (the host-side verifier: scored and oracle modes)
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
