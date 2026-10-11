# Harbor smoke trials and trace audit

End-to-end Harbor trials of every shipped streaming path with a real model, and an
audit of what actually reached the model. The goal is correctness of the delivery
path, not scores: one seed, one model.

## Setup

- Harbor 0.16.1, Singularity backend, one trial per job (2 CPUs).
- Model: Qwen3.6-27B served by vLLM 0.19.1 (OpenAI-compatible chat and Responses APIs,
  64K window, native tool calling; thinking on, reasoning appears inline in the text).
  Up to 8 trials shared the one server, so wall times are load-dependent.
- Budget of record: 32768 tokens, reserve 2048 (usable 30720), o200k token counts.
- Instances: `kv_store` R1000 seed 42 (34 ops, P = 1.52) and `sudoku_sketchpad` box3
  seed 42 (150 ops, P = 2.22; box3 is a level of the earlier configuration, not a paper
  level, see "Paper levels" below), built with
  `contextbench package --all --config clm_exp/configs/paper.yaml`. codex and mini-swe-agent
  were also run on "sudoku box3 T80": the same instance cut to its first 80 moves
  (`--knob turns=80`, P = 1.18, identical op bodies), because codex needed about
  35 s per move under load.
- Images: `environment/contextbench.def` for ContextBenchAgent, Terminus2Stream and
  ClmStream; `environment/contextbench-cli-agents.def` (codex 0.157.1,
  mini-swe-agent 2.4.6, Node 22) for the two CLI agents.
- Grading: the task's own `tests/test.sh` (vendored graders, no verifier flag), except
  the two "pre-fix" terminus rows, which were graded with the host-side
  `ContextBenchVerifier` (same code path, `contextbench.harbor.reward`).
- Rows marked "pre-fix" ran an earlier `Terminus2Stream`; they are kept because they
  show the two defects the audit found (below). Earlier runs of every other agent,
  made before the code was consolidated onto `CBStreamMixin` and `cb_stream`, were
  superseded and are not reported.
- ClmStream kv and the CodexStream rows were started with plain
  `harbor trials start -p <task> -e singularity -a <import path> -m openai/qwen36-27b
  --agent-kwarg api_base=...`; the others with a job config carrying the same kwargs.
- Audits are produced by `tools/audit_trial.py <trial dir>`.

## What the audit checks

For each trial, from the trial's own files: the reward dict and `graded_from`;
`terminated_by` and ops delivered/total from `interactive_stream.json`; for every op, the
role of the message where its header line (`=== ... (N op(s) remaining after this) ===`)
**first** appears in the per-turn context snapshots (must be `user`, and the count must
equal the ops delivered), plus the ATIF `source=user` steps for terminus; the delivery log
(every op after the first released by a standalone readiness command); in the snapshot
where op k first appears, whether the last command the agent ran before it was the
readiness command and whether the echo's own output line `READY_FOR_NEXT_OP` precedes
it (an op placed right after a harness summary or compaction has no such line, because
the harness replaced that output; those are counted separately); refusals; peak context
against the budget; and the harness's own context management (CLM edits, terminus
summarizations, codex compactions).

Two trace-fidelity checks follow. **Snapshot fidelity**: consecutive snapshots of what
was sent must either extend each other (append-only) or differ by a recorded event (a
terminus summarization counted in the snapshot, a CLM edit note in the new turn whose
editing command is visible in that turn, a codex compaction summary); for terminus the
post-reply snapshot must equal the sent snapshot plus exactly one assistant message.
codex is snapshotted once per resumed turn, which may hold several model calls, so its
check is at turn granularity. **Answer provenance** (kv): for every GET, the gold value
must be in the context the model was sent for the answering call or earlier in the same
step (for example a `grep` result), or be produced by the environment in the answering
command itself (in its output but not typed in the command). Counts are reported as
correct/wrong x present/absent. For sudoku, every missed version among the delivered
moves is listed with its cell differences.

Peak context: the table gives the maximum over all snapshots, and in parentheses the
maximum over the snapshots of what was about to be **sent** where the two differ.
terminus snapshots also record the context with the reply (`kind=turn`, so an answer
survives a later summarization); the wall is enforced on the sent context, after
terminus's own summarization had its chance. For ContextBenchAgent and mini-swe-agent
the peak is the sent context that tripped the wall.

## Results

| agent | instance | reward | terminated_by | ops | peak ctx tokens | agent wall | trial dir |
|---|---|---|---|---|---|---|---|
| ContextBenchAgent | kv_store R1000 | 0.000 | budget_wall | 4/34 | 35299 | 7.9 min | `cbagent-kv-store-R1000-seed42/kv-store-R1000-seed42__LX6u2o3` |
| Terminus2Stream (pane 160, pre-fix) | kv_store R1000 | 0.125 | stream_exhausted | 34/34 | 34147 (29062 sent) | 31.6 min | `terminus-kv-R1000-seed42/kv-R1000-seed42__8uZf99k` |
| Terminus2Stream | kv_store R1000 | 0.917 | stream_exhausted | 34/34 | 34676 (29594 sent) | 32.6 min | `terminus-kv-store-R1000-seed42/kv-store-R1000-seed42__2bS7peb` |
| ClmStream (v1 skill) | kv_store R1000 | 1.000 | stream_exhausted | 34/34 | 12849 | 2.8 min | `clm-kv-store-R1000-seed42/clm-kv-store-R1000-seed42` |
| MiniSweAgentStream | kv_store R1000 | 0.000 | budget_wall | 3/34 | 33246 | 8.6 min | `mini-kv-store-R1000-seed42/kv-store-R1000-seed42__pehX3jz` |
| CodexStream (cancelled) | kv_store R1000 | - | None | 4/34 | 24469 | cancelled | `codex-kv-store-R1000-seed42/codex-kv-store-R1000-seed42` |
| CodexStream (cancelled) | kv_store R700 C50 | - | None | 8/38 | 24473 | cancelled | `codex-kv-store-R700-C50-seed42/codex-kv-store-R700-C50-seed42` |
| ContextBenchAgent | sudoku box3 | 0.160 | budget_wall | 25/150 | 31733 | 6.8 min | `cbagent-sudoku-sketchpad-box3-seed42/sudoku-sketchpad-box3-seed42__LgFWbVP` |
| Terminus2Stream (pre-fix) | sudoku box3 | 0.993 | stream_exhausted | 150/150 | 27407 (26689 sent) | 84.0 min | `terminus-sudoku-box3-seed42/sudoku-box3-seed42__D6Nvzux` |
| Terminus2Stream | sudoku box3 | 1.000 | stream_exhausted | 150/150 | 26354 (25607 sent) | 61.4 min | `terminus-sudoku-sketchpad-box3-seed42/sudoku-sketchpad-box3-seed42__ocHwKVs` |
| ClmStream (v1 skill) | sudoku box3 | 0.347 | budget_wall | 53/150 | 30074 | 6.9 min | `clm-sudoku-sketchpad-box3-seed42/sudoku-sketchpad-box3-seed42__3zmatrq` |
| MiniSweAgentStream | sudoku box3 | 0.147 | budget_wall | 23/150 | 31644 | 6.5 min | `mini-sudoku-sketchpad-box3-seed42/sudoku-sketchpad-box3-seed42__XfhepuX` |
| MiniSweAgentStream | sudoku box3 T80 | 0.275 | budget_wall | 23/80 | 31617 | 7.4 min | `mini-sudoku-sketchpad-box3-T80-seed42/sudoku-sketchpad-box3-T80-seed42__e8ce2mz` |
| CodexStream | sudoku box3 T80 | 1.000 | stream_exhausted | 80/80 | 27662 | 45.7 min | `codex-sudoku-sketchpad-box3-T80-seed42/codex-sudoku-sketchpad-box3-T80-seed42` |


## Findings and flags

Defects found by the audit and fixed (fixed code is what the unmarked rows ran):

1. **terminus lost the last command's output.** When the stream ended, the final terminal
   output (the last GET's ANSWER, or the last board) was never appended to terminus's chat,
   so it was in no snapshot: the pre-fix sudoku row misses exactly v150 and an intermediate
   kv run left its last GET "unanswered" in the provenance check. `Terminus2Stream` now
   records the pending observation as part of the final context (as harnesses that append
   tool results do) and no longer stops inside `_check_proactive_summarization`. After the
   fix: sudoku 150/150, kv provenance "unanswered 0".
2. **tmux line wrapping split answers.** terminus's 160-column pane hard-wraps long lines,
   so a kv value came back as `... will` / `ow russet ...`: the pre-fix kv row answered 24/24
   GETs with the right values but only 3 are string-equal (provenance: 19 "wrong & absent",
   all wrapped). `Terminus2Stream` now defaults `tmux_pane_width=400`.
3. **A readiness command typed into a waiting program advanced the stream** (tiny smoke:
   `sed` with no input file was reading stdin, and `echo READY_FOR_NEXT_OP` became its
   input). tmux has no exit code, so terminus readiness now also requires the echo's own
   output line. Side effect seen once in a later kv run: a large heredoc paste was still
   being echoed when terminus captured the screen, so a real readiness was not counted and
   the agent was told why; it re-ran the echo (costs one turn, never an op).
4. **mini-swe-agent answers were invisible to the graders.** Its observation template
   renders output as JSON (`<` escaped as `<`), so a correct ANSWER block did not match.
   The graders now read the string fields of a tool message that is a single JSON object
   (parity tests still pass). No mini kv answer is affected in the table because mini hits
   the wall before any GET.

Other flags (not fixed, reported as observed):

5. **codex did not finish kv.** On R1000 it compacted 11 times within the first 4 ops and
   then spent its turns re-discovering where it had stored values; on a smaller feasible
   instance (R700, 50 records per batch, P = 1.08) it reached 8/38 ops in 90 min. Both were
   cancelled; their partial traces pass every delivery check. codex on sudoku T80: 80/80,
   reward 1.0, 7 compactions. Running codex against vLLM needed three adapter settings,
   all in `CodexStream`: codex's developer-role instruction blocks switched off (vLLM's
   Responses API rejects that role), `model_context_window` set to the budget, and a 30-min
   stream idle timeout (the default dropped and re-sent turns under load).
6. **CLM on sudoku hit the budget wall at move 53** (an earlier, superseded run reached 104).
   These CLM rows ran the printed (v1) method skill, which edits the board in place, but each
   move's command and tool output (about 450 tokens) stay in context; the harness reports
   every edit as "applied but it GREW" and `n_ctx_syncs_real` stays 0. On kv the skill
   offloads each batch (10 edits, peak 12.8K tokens, reward 1.0). The paper's CLM rows ran
   the v2 ("trace-cut") skill, which exists for all four families and is now the adapter's
   default; see "Paper levels" below.
7. **terminus summarization shapes delivery.** terminus keeps its first user message
   through every summary, so op 0 (a 4.9K-token kv batch, appended to the initial prompt)
   stays pinned for the whole run. 5-8 ops per kv run are delivered on a summarization
   handoff prompt, which replaces the terminal output; the audit counts these separately.
   One kv episode made two model calls (output-length error, retry): the intermediate
   request is inside the post-reply snapshot, not a separate sent snapshot.
8. **Budget-wall runs end with one delivered but never-seen op.** The op that pushes the
   sent context over the wall is appended and then the run stops before the call, so the
   last version of each wall-terminated sudoku run is "never displayed". Peak tokens in
   those rows are the over-budget sent context that tripped the wall.
9. **No early submit was attempted** in any real trial, so the refusal path is covered only
   by the unit tests (`test_early_submit_refused_then_submit_after_drain`, the mixin test).
10. **Harbor environment notes.** Harbor 0.16.1's Singularity backend runs containers with
    `--no-mount bind-paths`, so there is no `/etc/hosts` or resolver config inside: in-container
    clients (codex, mini-swe-agent) need the endpoint as an IP address. Trials run on a login
    node left orphaned container processes after they finished ("Event loop is closed").
11. **Explanation wording.** A readiness command with a non-zero exit is answered with the
    non-standalone explanation (parity with the source), which blames the command's form.

## Comparison with the Python runner (same instances, reply delivery, no shell)

| runner agent | instance | reward | terminated_by | ops |
|---|---|---|---|---|
| api (append-only) | kv_store R1000 | 0.000 | budget_wall | 6/34 |
| summary (compaction at 75%) | kv_store R1000 | 0.167 | stream_exhausted | 34/34 |
| api (append-only) | sudoku box3 | 0.293 | budget_wall | 44/150 |
| summary (compaction at 75%) | sudoku box3 | 0.993 | stream_exhausted | 150/150 |

The append-only paths agree across runners: both hit the wall early on kv with no GET
answered. Harbor's bash agents reach the wall sooner on sudoku (23-25 moves vs 44) because
each move also keeps a command and its output in context.


## Why each imperfect row scores what it does

Read from the traces (per-snapshot o200k counts; "per op" is the growth of the sent
context from one op to the next).

- **Append-only agents at the wall (expected by design).** None of these manages its
  context, so the run ends when the retained stream passes 30720 tokens.
  ContextBenchAgent kv: 5.7K start, about 9.8K per batch (the 4.9K batch plus the same
  batch retyped into a heredoc to store it), sent context 35299 with batch 4.
  mini-swe-agent kv: 6.3K start, about 10.4K per batch (batch, heredoc, 0.5K of output),
  33246 with batch 3. Python `api` kv: 5.9K start, 5.0K per batch, 30940 after batch 6.
  ContextBenchAgent 16x16 sudoku: 2.7K start, 3.4K per move (board in the command and in
  its output), 33128 with move 10. ContextBenchAgent 9x9: 1.6K + 1.25K per move, 31733
  with move 25; mini-swe-agent 9x9: 2.2K + 1.34K per move, 31644 with move 23; Python
  `api` 9x9: 2.2K + about 0.64K per move (the reply reprints the board), wall after move 44.
  Even the ideal append-only policy cannot finish kv R1000: its 1000 values are about
  48K tokens.
- **CLM, v1 skill, 9x9 (expected for that skill).** The v1 skill edits the board in place but
  keeps every move's message, command and output: about 440 tokens per move (context
  5.7K at move 1, 29150 at move 51). The instance's second board arrives at op 52 and takes
  the harness's calibrated count over the budget. The v2 skill cuts those messages after
  each edit: on the same instance it grows about 1 token per move (6419 at move 15, 6453
  at move 51), peaks at 8885 and scores 1.000 (148 edits, 150/150 versions).
- **Python `summary` kv, 0.167 (expected upper bound plus model error).** The four correct
  answers are the four GETs whose batch (900-999) was still verbatim in the context; the
  other 20 values were in neither the context nor the note and were made up. The first
  note kept 200 values in full; every later note stopped mid-value (after 110, 25 and 5
  keys): replaying the recorded compaction request gives the same early end
  (`finish_reason` stop, `<|im_end|>` at logprob -1.4 in the middle of a value), at the
  server default sampling and at 0.7 / 0.95. Without a disk, even perfect notes could not
  hold 48K tokens of values in a 32K budget.
- **Terminus kv, 0.917 (model error).** Both misses (K00798, K00723) are in batch 7, whose
  store command dropped the `SET Kxxxxx = ` prefix from every heredoc line, so `grep '^SET K'`
  stored nothing. The summarization that followed replaced the output that showed it; the
  continuing agent printed an empty answer for both keys.
- **Terminus 16x16 sudoku, 0.153.** See above: the seventh summarization failed on the
  output cap and the next move crossed the wall.
- **CodexStream kv (did not finish).** codex keeps recent user messages verbatim through its
  compaction; in the post-compaction context of turn 4, 20.1K of 24.5K tokens were earlier 5K SET
  batches, so the context stayed near codex's limit and it compacted again at once.

## Paper levels, CLM method v2 (rerun)

`clm_exp/configs/paper.yaml` now carries the levels the paper's figure plots (see
`docs/DEVIATIONS.md`, "Levels and seeds"); sudoku is one 16x16 board (box 4, 90 givens)
played for up to 150 moves, not the box3 instance above. The CLM adapter now defaults to
the method text of the paper's CLM rows (v2, "trace-cut"), placed where the paper's
package builder put it. Its kv instruction hashes to the paper's: `clm_stream.json`
records `instruction_sha16` beff2f70192abfa5, the value in the paper's v2 run table.
Same setup as above (Qwen3.6-27B on the shared vLLM server, Singularity, one trial per
job, task-side grading), seed 42, agent timeout 2 h (not reached).

| agent | instance | reward | terminated_by | ops | peak ctx tokens | agent wall | trial dir |
|---|---|---|---|---|---|---|---|
| ClmStream (v2 skill) | kv_store R1000 | 1.000 | stream_exhausted | 34/34 | 8188 | 1.8 min | `clm-v2-kv-store-R1000-seed42/kv-store-R1000-seed42__6sXezbA` |
| ClmStream (v2 skill) | sudoku t150 | 1.000 | stream_exhausted | 150/150 | 9719 | 16.2 min | `clm-paper-sudoku-t150-seed42/sudoku-sketchpad-t150-seed42__tLYLMeo` |
| ClmStream (v2 skill, `clm_exp/skills/clm`) | sudoku box3 (old level) | 1.000 | stream_exhausted | 150/150 | 8885 | - | `clm-v2-sudoku-sketchpad-box3-seed42/sudoku-sketchpad-box3-seed42__eRgxZkJ` |
| Terminus2Stream | sudoku t150 | 0.153 | budget_wall | 24/150 | 31925 | 27.7 min | `terminus-paper-sudoku-t150-seed42/sudoku-sketchpad-t150-seed42__FJ3e5aX` |
| ContextBenchAgent | sudoku t150 | 0.060 | budget_wall | 10/150 | 33128 | 5.4 min | `cbagent-paper-sudoku-t150-seed42/sudoku-sketchpad-t150-seed42__qZ983db` |

Audit flags: none. Every trial passes the delivery checks (each op header first appears
as a user turn, and every op after the first is released by a standalone readiness
command) and snapshot fidelity (no unexplained transition: CLM kv 10 edits, CLM sudoku
148 edits, terminus 6 summarizations, each visible in the new snapshot). kv answer
provenance: 24/24 correct and present (23 produced by the answering command's own
`grep`). Sudoku missed versions: CLM none (150/150 displayed). ContextBenchAgent and
Terminus2Stream each miss exactly one version, the one delivered by the op that pushed
the sent context over the wall (v10 and v24; finding 8 above). No cell differences can
be listed for these, because those versions were never displayed at all. Terminus
summarized successfully 6 times, every three moves (a 16x16 move adds about 5.1K tokens:
the board typed in the command, echoed by the terminal, and the move). The seventh
attempt failed: its questions step ran into the 8192-token output cap
("Error in proactively summarizing: Model openai/qwen36-27b hit max_tokens limit"), terminus
logs such errors and carries on unsummarized, and the next move took the sent context
from 26786 to 31925 tokens. With a successful seventh summary the cycle would have
stayed under the wall (worst case about 28.1K); on 9x9 a failed summary leaves room
for another move, on 16x16 it does not.

### Comparison with the paper's Qwen3.6 rows

Paper values are the per-seed rows of the paper figure (`rows_q36.csv`) at the same
family and level, mean over all rows (seeds 42-45; n = rows). CB values are one trial,
seed 42. The paper's sudoku rewards here are version fractions (base 0.047 = 7/150).

| instance | CB agent | CB reward (seed 42) | paper arm | paper mean (n) | paper seed 42 | mapping |
|---|---|---|---|---|---|---|
| kv_store R1000 | ClmStream (v2 skill) | 1.000 | livectx (CLM) | 1.000 (4) | 1.000 | same harness and method text |
| kv_store R1000 | ClmStream (v1 skill) | 1.000 | livectx (CLM) | 1.000 (4) | 1.000 | same harness, printed (v1) text; the paper ran v2 |
| kv_store R1000 | ContextBenchAgent | 0.000 | base | 0.000 (4) | 0.000 | nearest: both append-only bash loops; different harness code and prompts |
| kv_store R1000 | Python runner `api` (append-only, no shell) | 0.000 | base | 0.000 (4) | 0.000 | nearest; no bash, reply-mode instruction |
| kv_store R1000 | Python runner `summary` (compaction at 75 %, no shell) | 0.167 | summary | 0.990 (4) | 1.000 | nearest; the paper's summary harness has bash and can offload to disk |
| kv_store R1000 | Terminus2Stream | 0.917 | - | - | - | no paper counterpart |
| kv_store R1000 | MiniSweAgentStream | 0.000 | - | - | - | no paper counterpart (stock mini-swe-agent 2.4.6 prompts, not the paper's base harness) |
| kv_store R1000 | CodexStream | cancelled (4/34 ops) | - | - | - | no paper counterpart |
| sudoku t150 | ClmStream (v2 skill) | 1.000 | livectx (CLM) | 1.000 (4) | 1.000 | same harness and method text (the scaffold differs by one sentence) |
| sudoku t150 | ContextBenchAgent | 0.060 | base | 0.047 (4) | 0.047 | nearest, as above |
| sudoku t150 | Terminus2Stream | 0.153 | - | - | - | no paper counterpart |
| sudoku t150 | (not run) | - | summary | 0.990 (8) | 0.960 | the paper's rows list seeds 42-45 twice (two sources) |

In the paper, `base` is a mini-swe-agent-style append-only agent with bash, `summary` is
a Codex-style summarizing harness with bash, and `livectx` is the CLM harness. Only the
CLM rows use the same harness with the same method text. The ContextBenchAgent and
Python runner rows are the nearest ContextBench equivalents, not the same systems. The
earlier sudoku rows (box3, above) have no paper level to compare with.

## Per-trial audits

### ContextBenchAgent x kv_store R1000 seed 42

- trial dir: `cbagent-kv-store-R1000-seed42/kv-store-R1000-seed42__LX6u2o3`
- agent wall: 2026-09-26T22:00:54.918463Z -> 2026-09-26T22:08:50.051857Z
- reward: reward=0, matched=0, total=24, n_answered=0, grader_valid=1, agent_peak_tokens=3.53e+04, graded_from=snapshots
- terminated_by: **budget_wall**; ops delivered 4/34; refusals 0; explanations 0
- stream identity: count 34, sha256 5f0799fab3470cf4..., removed from container: True
- op headers in snapshots (8 frames): first appearance by role {'user': 4} -> 4 op user turns vs 4 delivered
- delivery log: 4 ops; op 0 at start; 3 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 3/3
- peak context: 35299 tokens (budget 32768, usable 30720)
- snapshot fidelity: 7 sent snapshots; transitions append-only 6, changed by a recorded event none, unexplained 0
- answer provenance (kv): correct & present 0 (in context 0, from a tool this call 0), correct & absent 0, wrong & present 0, wrong & absent 0, unanswered 24

Excerpts:

- op header:

  ```
  === set batch (keys 0-99) (33 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  echo READY_FOR_NEXT_OP
  ```

Flags: none from the checks above.


### Terminus2Stream (pane 160, pre-fix) x kv_store R1000 seed 42

- trial dir: `terminus-kv-R1000-seed42/kv-R1000-seed42__8uZf99k`
- agent wall: 2026-09-26T21:53:48.298395Z -> 2026-09-26T22:25:27.295640Z
- reward: reward=0.125, matched=3, total=24, n_answered=24, grader_valid=1, agent_peak_tokens=3.415e+04, graded_from=snapshots
- terminated_by: **stream_exhausted**; ops delivered 34/34; refusals 0; explanations 0
- stream identity: count 34, sha256 5f0799fab3470cf4..., removed from container: True
- op headers in snapshots (69 frames): first appearance by role {'user': 34} -> 34 op user turns vs 34 delivered
- ATIF trajectory: 34 `source=user` op steps
- delivery log: 34 ops; op 0 at start; 33 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 28/33 (+5 delivered right after a harness summary/compaction, which replaces the prior output)
- peak context: 34147 tokens (budget 32768, usable 30720)
- terminus summarizations: 5
- snapshot fidelity: 34 sent snapshots; transitions append-only 28, changed by a recorded event 5 terminus summarization, unexplained 0
  - post-reply snapshot == sent snapshot + one assistant message: 34/34
- answer provenance (kv): correct & present 3 (in context 1, from a tool this call 3), correct & absent 0, wrong & present 1, wrong & absent 19, unanswered 1

Excerpts:

- op header:

  ```
  === set batch (keys 0-99) (33 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [user] <<<ANSWER key=K00048>>>
  kindle boulder garnet fathom cinder thistle ember pewter cinder vellum marble onyx verdant garnet spruce onyx thistle glacier cinder glacier indigo lattice will
  ow russet #948823b5
  <<<ANSWER END>>>
  ```

Flags: none from the checks above.


### Terminus2Stream x kv_store R1000 seed 42

- trial dir: `terminus-kv-store-R1000-seed42/kv-store-R1000-seed42__2bS7peb`
- agent wall: 2026-09-27T01:04:11.030355Z -> 2026-09-27T01:36:48.056923Z
- reward: reward=0.9167, matched=22, total=24, n_answered=24, grader_valid=1, agent_peak_tokens=3.468e+04, graded_from=snapshots
- terminated_by: **stream_exhausted**; ops delivered 34/34; refusals 0; explanations 0
- stream identity: count 34, sha256 5f0799fab3470cf4..., removed from container: True
- op headers in snapshots (83 frames): first appearance by role {'user': 34} -> 34 op user turns vs 34 delivered
- ATIF trajectory: 34 `source=user` op steps
- delivery log: 34 ops; op 0 at start; 33 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 25/33 (+8 delivered right after a harness summary/compaction, which replaces the prior output)
- peak context: 34676 tokens (budget 32768, usable 30720)
- terminus summarizations: 8
- snapshot fidelity: 41 sent snapshots; transitions append-only 32, changed by a recorded event 8 terminus summarization, unexplained 0
  - post-reply snapshot == sent snapshot + one assistant message: 41/41
- answer provenance (kv): correct & present 22 (in context 1, from a tool this call 21), correct & absent 0, wrong & present 0, wrong & absent 2, unanswered 0

Excerpts:

- op header:

  ```
  === set batch (keys 0-99) (33 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [user] <<<ANSWER key=K00048>>>
  kindle boulder garnet fathom cinder thistle ember pewter cinder vellum marble onyx verdant garnet spruce onyx thistle glacier cinder glacier indigo lattice willow russet #948823b5
  <<<ANSWER END>>>
  ```

Flags: none from the checks above.


### ClmStream (v1 skill) x kv_store R1000 seed 42

- trial dir: `clm-kv-store-R1000-seed42/clm-kv-store-R1000-seed42`
- agent wall: 2026-09-26T22:00:56.736893Z -> 2026-09-26T22:03:44.397530Z
- reward: reward=1, matched=24, total=24, n_answered=24, grader_valid=1, agent_peak_tokens=1.285e+04, graded_from=snapshots
- terminated_by: **stream_exhausted**; ops delivered 34/34; refusals 0; explanations 0
- stream identity: count 34, sha256 5f0799fab3470cf4..., removed from container: True
- op headers in snapshots (60 frames): first appearance by role {'user': 34} -> 34 op user turns vs 34 delivered
- delivery log: 34 ops; op 0 at start; 33 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 33/33
- peak context: 12849 tokens (budget 32768, usable 30720)
- CLM context edits (n_ctx_syncs_real): 10

  one edit (command head, harness note):

  ```
  python3 - <<'PY' && echo READY_FOR_NEXT_OP
  import pathlib
  p = pathlib.Path('/tmp/.live_ctx/LIVE_CTX_MAIN.txt'); t = p.read_text()
  ...
  [LIVE_CTX_MAIN.txt: edit applied — context ~7789->2894 tokens, 3 turns]
  ```
- snapshot fidelity: 58 sent snapshots; transitions append-only 47, changed by a recorded event 10 CLM context edit, unexplained 0
  - CLM edits whose editing command is visible in the new turn: 10/10
- answer provenance (kv): correct & present 24 (in context 24, from a tool this call 0), correct & absent 0, wrong & present 0, wrong & absent 0, unanswered 0

Excerpts:

- op header:

  ```
  === set batch (keys 0-99) (33 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  python3 - <<'PY' && echo READY_FOR_NEXT_OP
  import pathlib
  p = pathlib.Path('/tmp/.live_ctx/LIVE_CTX_MAIN.txt'); t = p.re [...]  d.mkdir(exist_ok=True)
  (d / 'kv-0000.txt').write_text(t[i:j])
  p.write_text(t[:i] + '[batch 0000 offloaded]' + t[j:])
  PY
  ```
- answer block:

  ```
  [tool] <<<ANSWER key=K00048>>>
  kindle boulder garnet fathom cinder thistle ember pewter cinder vellum marble onyx verdant garnet spruce onyx thistle glacier cinder glacier indigo lattice willow russet #948823b5
  <<<ANSWER END>>>
  ```

Flags: none from the checks above.


### MiniSweAgentStream x kv_store R1000 seed 42

- trial dir: `mini-kv-store-R1000-seed42/kv-store-R1000-seed42__pehX3jz`
- agent wall: 2026-09-26T22:00:57.187665Z -> 2026-09-26T22:09:31.324119Z
- reward: reward=0, matched=0, total=24, n_answered=0, grader_valid=1, agent_peak_tokens=3.325e+04, graded_from=snapshots
- terminated_by: **budget_wall**; ops delivered 3/34; refusals 0; explanations 0
- stream identity: count 34, sha256 5f0799fab3470cf4..., removed from container: True
- op headers in snapshots (9 frames): first appearance by role {'user': 3} -> 3 op user turns vs 3 delivered
- delivery log: 3 ops; op 0 at start; 2 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 2/2
- peak context: 33246 tokens (budget 32768, usable 30720)
- snapshot fidelity: 8 sent snapshots; transitions append-only 7, changed by a recorded event none, unexplained 0
- answer provenance (kv): correct & present 0 (in context 0, from a tool this call 0), correct & absent 0, wrong & present 0, wrong & absent 0, unanswered 24

Excerpts:

- op header:

  ```
  === set batch (keys 0-99) (33 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  echo READY_FOR_NEXT_OP
  ```

Flags: none from the checks above.


### CodexStream (cancelled) x kv_store R1000 seed 42

- trial dir: `codex-kv-store-R1000-seed42/codex-kv-store-R1000-seed42`
- reward: , graded_from=None
- terminated_by: **None**; ops delivered 4/34; refusals 0; explanations 0
- stream identity: count 34, sha256 5f0799fab3470cf4..., removed from container: True
- op headers in snapshots (6 frames): first appearance by role {'user': 4} -> 4 op user turns vs 4 delivered
- delivery log: 4 ops; op 0 at start; 3 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 0/3 (+3 delivered right after a harness summary/compaction, which replaces the prior output)
- peak context: 24469 tokens (budget 32768, usable 30720)
- codex compactions (rollout `compacted` records): 11
- snapshot fidelity: 6 sent snapshots; transitions append-only 0, changed by a recorded event 5 compaction summary, unexplained 0
- answer provenance (kv): correct & present 0 (in context 0, from a tool this call 0), correct & absent 0, wrong & present 0, wrong & absent 0, unanswered 24

Excerpts:

- op header:

  ```
  === set batch (keys 0-99) (33 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  echo READY_FOR_NEXT_OP
  ```

Flags: none from the checks above.


### CodexStream (cancelled) x kv_store R700 C50 seed 42

- trial dir: `codex-kv-store-R700-C50-seed42/codex-kv-store-R700-C50-seed42`
- reward: , graded_from=None
- terminated_by: **None**; ops delivered 8/38; refusals 0; explanations 0
- stream identity: count 38, sha256 97cb4e5dc4005d3f..., removed from container: True
- op headers in snapshots (15 frames): first appearance by role {'user': 8} -> 8 op user turns vs 8 delivered
- delivery log: 8 ops; op 0 at start; 7 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 2/7 (+5 delivered right after a harness summary/compaction, which replaces the prior output)
- peak context: 24473 tokens (budget 32768, usable 30720)
- codex compactions (rollout `compacted` records): 52
- snapshot fidelity: 15 sent snapshots; transitions append-only 4, changed by a recorded event 10 compaction summary, unexplained 0
- answer provenance (kv): correct & present 0 (in context 0, from a tool this call 0), correct & absent 0, wrong & present 0, wrong & absent 0, unanswered 24

Excerpts:

- op header:

  ```
  === set batch (keys 0-49) (37 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  echo READY_FOR_NEXT_OP
  ```

Flags: none from the checks above.


### ContextBenchAgent x sudoku box3 seed 42

- trial dir: `cbagent-sudoku-sketchpad-box3-seed42/sudoku-sketchpad-box3-seed42__LgFWbVP`
- agent wall: 2026-09-26T22:00:54.918862Z -> 2026-09-26T22:07:43.956792Z
- reward: reward=0.16, matched=24, total=150, reward_versioned=0.16, reward_content=0.16, grader_valid=1, agent_peak_tokens=3.173e+04, graded_from=snapshots
- terminated_by: **budget_wall**; ops delivered 25/150; refusals 0; explanations 0
- stream identity: count 150, sha256 64401ad221366397..., removed from container: True
- op headers in snapshots (26 frames): first appearance by role {'user': 25} -> 25 op user turns vs 25 delivered
- delivery log: 25 ops; op 0 at start; 24 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 24/24
- peak context: 31733 tokens (budget 32768, usable 30720)
- snapshot fidelity: 25 sent snapshots; transitions append-only 24, changed by a recorded event none, unexplained 0
- sudoku versions missed among delivered moves: 1; not delivered (run ended): 125
  - v25 (op 24, move v25): never displayed with this VERSION

Excerpts:

- op header:

  ```
  === board 1 move v1 (149 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  printf '<<<SKETCHPAD BEGIN>>>
  VERSION: 1
  (1,1,6) (1,2,8) (1,3,.) (1,4,4) (1,5,.) (1,6,.) (1,7,.) (1,8,.) (1,9,7)
  (2,1,1) [...] 2)
  (9,1,2) (9,2,5) (9,3,.) (9,4,.) (9,5,7) (9,6,8) (9,7,3) (9,8,.) (9,9,.)
  <<<SKETCHPAD END>>>
  '; echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [tool] <<<SKETCHPAD BEGIN>>>
  VERSION: 1
  (1,1,6) (1,2,8) (1,3,.) (1,4,4) (1,5,.) (1,6,.) (1,7,.) (1,8,.) (1,9,7)
  (2,1,1) (2,2,.) (2,3,.) (2,4,.) (2,5,.) (2,6,.) (2,7,8) (2,8,9) (2,9,.)
  (3,1,.) (3,2,.) (3,3,.) (3,4,8) (3,5,.) (3,6,.) (3,7,.) (3,8,3) (3,9,1)
  (4,1,.) (4,2,1) (4,3,.) (4,4,7) (4,5,2) (4,6,9) (4,7,.) (4,8,.) (4,9,.)
  (5,1,.) (5,2,6) (5,3,.) (5,4,.) (5,5,.) (5,6,5) (5,7,.) (5,8,.) (5,9,.)
  (6,1,.) (6,2,.) (6,3,2) (6,4,.) (6,5,8) (6,6,.) (6,7,.) (6,8,4) (6,9,.)
  (7,1,.) (7,2,.) (7,3,6) (7,4,.) (7,5,.) (7,6,2) (7,7,9) (7,8,.) (7,9,8)
  (8,1,.) (8,2,.) (8,3,.) (8,4,.) (8,5,.) (8,6,4) (8,7,5) (8,8,.) (8,9,2)
  (9,1,2) (9,2,5) (9,3,.) (9,4,.) (9,5,7) (9,6,8) (9,7,3) (9,8,.) (9,9,.)
  <<<SKETCHPAD
  [...]
  ```

Flags: none from the checks above.


### Terminus2Stream (pre-fix) x sudoku box3 seed 42

- trial dir: `terminus-sudoku-box3-seed42/sudoku-box3-seed42__D6Nvzux`
- agent wall: 2026-09-26T21:53:51.501578Z -> 2026-09-26T23:17:52.916937Z
- reward: reward=0.9933, matched=149, total=150, reward_versioned=0.9933, reward_content=0.9933, grader_valid=1, agent_peak_tokens=2.741e+04, graded_from=snapshots
- terminated_by: **stream_exhausted**; ops delivered 150/150; refusals 0; explanations 0
- stream identity: count 150, sha256 64401ad221366397..., removed from container: True
- op headers in snapshots (301 frames): first appearance by role {'user': 150} -> 150 op user turns vs 150 delivered
- ATIF trajectory: 150 `source=user` op steps
- delivery log: 150 ops; op 0 at start; 149 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 131/149 (+18 delivered right after a harness summary/compaction, which replaces the prior output)
- peak context: 27407 tokens (budget 32768, usable 30720)
- terminus summarizations: 20
- snapshot fidelity: 150 sent snapshots; transitions append-only 130, changed by a recorded event 19 terminus summarization, unexplained 0
  - post-reply snapshot == sent snapshot + one assistant message: 150/150
- sudoku versions missed among delivered moves: 1; not delivered (run ended): 0
  - v150 (op 149, move v150): never displayed with this VERSION

Excerpts:

- op header:

  ```
  === board 1 move v1 (149 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  printf '%s\n' '<<<SKETCHPAD BEGIN>>>' 'VERSION: 1' '(1,1,6) (1,2,8) (1,3,.) (1,4,4) (1,5,.) (1,6,.) (1,7,.) (1,8,.) (1,9 [...] (9,1,2) (9,2,5) (9,3,.) (9,4,.) (9,5,7) (9,6,8) (9,7,3) (9,8,.) (9,9,.)' '<<<SKETCHPAD END>>>' && echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [user] <<<SKETCHPAD BEGIN>>>` /
  `<<<SKETCHPAD END>>>
  ```

Flags: none from the checks above.


### Terminus2Stream x sudoku box3 seed 42

- trial dir: `terminus-sudoku-sketchpad-box3-seed42/sudoku-sketchpad-box3-seed42__ocHwKVs`
- agent wall: 2026-09-27T01:04:11.262205Z -> 2026-09-27T02:05:32.287182Z
- reward: reward=1, matched=150, total=150, reward_versioned=1, reward_content=1, grader_valid=1, agent_peak_tokens=2.635e+04, graded_from=snapshots
- terminated_by: **stream_exhausted**; ops delivered 150/150; refusals 0; explanations 0
- stream identity: count 150, sha256 64401ad221366397..., removed from container: True
- op headers in snapshots (301 frames): first appearance by role {'user': 150} -> 150 op user turns vs 150 delivered
- ATIF trajectory: 150 `source=user` op steps
- delivery log: 150 ops; op 0 at start; 149 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 131/149 (+18 delivered right after a harness summary/compaction, which replaces the prior output)
- peak context: 26354 tokens (budget 32768, usable 30720)
- terminus summarizations: 18
- snapshot fidelity: 150 sent snapshots; transitions append-only 131, changed by a recorded event 18 terminus summarization, unexplained 0
  - post-reply snapshot == sent snapshot + one assistant message: 150/150
- sudoku versions missed among delivered moves: 0; not delivered (run ended): 0

Excerpts:

- op header:

  ```
  === board 1 move v1 (149 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  printf '<<<SKETCHPAD BEGIN>>>
  VERSION: 1
  (1,1,6) (1,2,8) (1,3,.) (1,4,4) (1,5,.) (1,6,.) (1,7,.) (1,8,.) (1,9,7)
  (2,1,1) [...] 2)
  (9,1,2) (9,2,5) (9,3,.) (9,4,.) (9,5,7) (9,6,8) (9,7,3) (9,8,.) (9,9,.)
  <<<SKETCHPAD END>>>
  '; echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [user] <<<SKETCHPAD BEGIN>>>` /
  `<<<SKETCHPAD END>>>
  ```

Flags: none from the checks above.


### ClmStream (v1 skill) x sudoku box3 seed 42

- trial dir: `clm-sudoku-sketchpad-box3-seed42/sudoku-sketchpad-box3-seed42__3zmatrq`
- agent wall: 2026-09-26T22:00:57.017952Z -> 2026-09-26T22:07:53.745346Z
- reward: reward=0.3467, matched=52, total=150, reward_versioned=0.3467, reward_content=0.3467, grader_valid=1, agent_peak_tokens=3.007e+04, graded_from=snapshots
- terminated_by: **budget_wall**; ops delivered 53/150; refusals 0; explanations 0
- stream identity: count 150, sha256 64401ad221366397..., removed from container: True
- op headers in snapshots (58 frames): first appearance by role {'user': 53} -> 53 op user turns vs 53 delivered
- delivery log: 53 ops; op 0 at start; 52 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 52/52
- peak context: 30074 tokens (budget 32768, usable 30720)
- CLM context edits (n_ctx_syncs_real): 0

  one edit (command head, harness note):

  ```
  python3 - <<'PY' && echo READY_FOR_NEXT_OP
  import pathlib, re
  f = '/tmp/.live_ctx/LIVE_CTX_MAIN.txt'; t = open(f).read()
  ...
  [LIVE_CTX_MAIN.txt: edit applied but it GREW context ~5868->5869 tokens (it fits, so it was kept). If you meant to condense, you likely duplicated content instead of replacing it.]
  ```
- snapshot fidelity: 55 sent snapshots; transitions append-only 4, changed by a recorded event 50 CLM context edit, unexplained 0
  - CLM edits whose editing command is visible in the new turn: 50/50
- sudoku versions missed among delivered moves: 1; not delivered (run ended): 97
  - v53 (op 52, move v53): never displayed with this VERSION

Excerpts:

- op header:

  ```
  === board 1 move v1 (149 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [tool] <<<SKETCHPAD BEGIN>>>
  VERSION: 1
  (1,1,6) (1,2,8) (1,3,.) (1,4,4) (1,5,.) (1,6,.) (1,7,.) (1,8,.) (1,9,7)
  (2,1,1) (2,2,.) (2,3,.) (2,4,.) (2,5,.) (2,6,.) (2,7,8) (2,8,9) (2,9,.)
  (3,1,.) (3,2,.) (3,3,.) (3,4,8) (3,5,.) (3,6,.) (3,7,.) (3,8,3) (3,9,1)
  (4,1,.) (4,2,1) (4,3,.) (4,4,7) (4,5,2) (4,6,9) (4,7,.) (4,8,.) (4,9,.)
  (5,1,.) (5,2,6) (5,3,.) (5,4,.) (5,5,.) (5,6,5) (5,7,.) (5,8,.) (5,9,.)
  (6,1,.) (6,2,.) (6,3,2) (6,4,.) (6,5,8) (6,6,.) (6,7,.) (6,8,4) (6,9,.)
  (7,1,.) (7,2,.) (7,3,6) (7,4,.) (7,5,.) (7,6,2) (7,7,9) (7,8,.) (7,9,8)
  (8,1,.) (8,2,.) (8,3,.) (8,4,.) (8,5,.) (8,6,4) (8,7,5) (8,8,.) (8,9,2)
  (9,1,2) (9,2,5) (9,3,.) (9,4,.) (9,5,7) (9,6,8) (9,7,3) (9,8,.) (9,9,.)
  <<<SKETCHPAD
  [...]
  ```

Flags: none from the checks above.


### MiniSweAgentStream x sudoku box3 seed 42

- trial dir: `mini-sudoku-sketchpad-box3-seed42/sudoku-sketchpad-box3-seed42__XfhepuX`
- agent wall: 2026-09-26T23:18:51.109762Z -> 2026-09-26T23:25:18.360576Z
- reward: reward=0.1467, matched=22, total=150, reward_versioned=0.1467, reward_content=0.1467, grader_valid=1, agent_peak_tokens=3.164e+04, graded_from=snapshots
- terminated_by: **budget_wall**; ops delivered 23/150; refusals 0; explanations 0
- stream identity: count 150, sha256 64401ad221366397..., removed from container: True
- op headers in snapshots (24 frames): first appearance by role {'user': 23} -> 23 op user turns vs 23 delivered
- delivery log: 23 ops; op 0 at start; 22 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 22/22
- peak context: 31644 tokens (budget 32768, usable 30720)
- snapshot fidelity: 23 sent snapshots; transitions append-only 22, changed by a recorded event none, unexplained 0
- sudoku versions missed among delivered moves: 1; not delivered (run ended): 127
  - v23 (op 22, move v23): never displayed with this VERSION

Excerpts:

- op header:

  ```
  === board 1 move v1 (149 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  printf '<<<SKETCHPAD BEGIN>>>
  VERSION: 1
  (1,1,6) (1,2,8) (1,3,.) (1,4,4) (1,5,.) (1,6,.) (1,7,.) (1,8,.) (1,9,7)
  (2,1,1) [...] 2)
  (9,1,2) (9,2,5) (9,3,.) (9,4,.) (9,5,7) (9,6,8) (9,7,3) (9,8,.) (9,9,.)
  <<<SKETCHPAD END>>>
  '; echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [user] <<<SKETCHPAD BEGIN>>>` /
  `<<<SKETCHPAD END>>>
  ```

Flags: none from the checks above.


### MiniSweAgentStream x sudoku box3 T80 seed 42

- trial dir: `mini-sudoku-sketchpad-box3-T80-seed42/sudoku-sketchpad-box3-T80-seed42__e8ce2mz`
- agent wall: 2026-09-26T22:09:36.003167Z -> 2026-09-26T22:16:57.026047Z
- reward: reward=0.275, matched=22, total=80, reward_versioned=0.275, reward_content=0.275, grader_valid=1, agent_peak_tokens=3.162e+04, graded_from=snapshots
- terminated_by: **budget_wall**; ops delivered 23/80; refusals 0; explanations 0
- stream identity: count 80, sha256 c448e956f6cf8464..., removed from container: True
- op headers in snapshots (24 frames): first appearance by role {'user': 23} -> 23 op user turns vs 23 delivered
- delivery log: 23 ops; op 0 at start; 22 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 22/22
- peak context: 31617 tokens (budget 32768, usable 30720)
- snapshot fidelity: 23 sent snapshots; transitions append-only 22, changed by a recorded event none, unexplained 0
- sudoku versions missed among delivered moves: 1; not delivered (run ended): 57
  - v23 (op 22, move v23): never displayed with this VERSION

Excerpts:

- op header:

  ```
  === board 1 move v1 (79 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  printf '<<<SKETCHPAD BEGIN>>>
  VERSION: 1
  (1,1,6) (1,2,8) (1,3,.) (1,4,4) (1,5,.) (1,6,.) (1,7,.) (1,8,.) (1,9,7)
  (2,1,1) [...] 2)
  (9,1,2) (9,2,5) (9,3,.) (9,4,.) (9,5,7) (9,6,8) (9,7,3) (9,8,.) (9,9,.)
  <<<SKETCHPAD END>>>
  '; echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [user] <<<SKETCHPAD BEGIN>>>` /
  `<<<SKETCHPAD END>>>
  ```

Flags: none from the checks above.


### CodexStream x sudoku box3 T80 seed 42

- trial dir: `codex-sudoku-sketchpad-box3-T80-seed42/codex-sudoku-sketchpad-box3-T80-seed42`
- agent wall: 2026-09-26T22:08:36.216163Z -> 2026-09-26T22:54:19.316295Z
- reward: reward=1, matched=80, total=80, reward_versioned=1, reward_content=1, grader_valid=1, agent_peak_tokens=2.766e+04, graded_from=snapshots
- terminated_by: **stream_exhausted**; ops delivered 80/80; refusals 0; explanations 0
- stream identity: count 80, sha256 c448e956f6cf8464..., removed from container: True
- op headers in snapshots (80 frames): first appearance by role {'user': 80} -> 80 op user turns vs 80 delivered
- delivery log: 80 ops; op 0 at start; 79 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 72/79 (+7 delivered right after a harness summary/compaction, which replaces the prior output)
- peak context: 27662 tokens (budget 32768, usable 30720)
- codex compactions (rollout `compacted` records): 7
- snapshot fidelity: 80 sent snapshots; transitions append-only 72, changed by a recorded event 7 compaction summary, unexplained 0
- sudoku versions missed among delivered moves: 0; not delivered (run ended): 0

Excerpts:

- op header:

  ```
  === board 1 move v1 (79 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [tool] <<<SKETCHPAD BEGIN>>>
  VERSION: 1
  (1,1,6) (1,2,8) (1,3,.) (1,4,4) (1,5,.) (1,6,.) (1,7,.) (1,8,.) (1,9,7)
  (2,1,1) (2,2,.) (2,3,.) (2,4,.) (2,5,.) (2,6,.) (2,7,8) (2,8,9) (2,9,.)
  (3,1,.) (3,2,.) (3,3,.) (3,4,8) (3,5,.) (3,6,.) (3,7,.) (3,8,3) (3,9,1)
  (4,1,.) (4,2,1) (4,3,.) (4,4,7) (4,5,2) (4,6,9) (4,7,.) (4,8,.) (4,9,.)
  (5,1,.) (5,2,6) (5,3,.) (5,4,.) (5,5,.) (5,6,5) (5,7,.) (5,8,.) (5,9,.)
  (6,1,.) (6,2,.) (6,3,2) (6,4,.) (6,5,8) (6,6,.) (6,7,.) (6,8,4) (6,9,.)
  (7,1,.) (7,2,.) (7,3,6) (7,4,.) (7,5,.) (7,6,2) (7,7,9) (7,8,.) (7,9,8)
  (8,1,.) (8,2,.) (8,3,.) (8,4,.) (8,5,.) (8,6,4) (8,7,5) (8,8,.) (8,9,2)
  (9,1,2) (9,2,5) (9,3,.) (9,4,.) (9,5,7) (9,6,8) (9,7,3) (9,8,.) (9,9,.)
  <<<SKETCHPAD
  [...]
  ```

Flags: none from the checks above.

## Per-trial audits, paper levels

### ClmStream (v2 skill) x kv_store R1000 seed 42

- trial dir: `clm-v2-kv-store-R1000-seed42/kv-store-R1000-seed42__6sXezbA`
- agent wall: 2026-09-27T02:26:12.519625Z -> 2026-09-27T02:28:01.691112Z
- reward: reward=1, matched=24, total=24, n_answered=24, grader_valid=1, agent_peak_tokens=8188, graded_from=snapshots
- terminated_by: **stream_exhausted**; ops delivered 34/34; refusals 0; explanations 0
- stream identity: count 34, sha256 5f0799fab3470cf4..., removed from container: True
- op headers in snapshots (37 frames): first appearance by role {'user': 34} -> 34 op user turns vs 34 delivered
- delivery log: 34 ops; op 0 at start; 33 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 33/33
- peak context: 8188 tokens (budget 32768, usable 30720)
- CLM context edits (n_ctx_syncs_real): 10

  one edit (command head, harness note):

  ```
  python3 - <<'PY' && echo READY_FOR_NEXT_OP
  import pathlib
  p = pathlib.Path('/tmp/.live_ctx/LIVE_CTX_MAIN.txt'); t = p.read_text()
  ...
  [LIVE_CTX_MAIN.txt: edit applied — context ~7853->2958 tokens, 3 turns]
  ```
- snapshot fidelity: 35 sent snapshots; transitions append-only 24, changed by a recorded event 10 CLM context edit, unexplained 0
  - CLM edits whose editing command is visible in the new turn: 10/10
- answer provenance (kv): correct & present 24 (in context 1, from a tool this call 23), correct & absent 0, wrong & present 0, wrong & absent 0, unanswered 0

Excerpts:

- op header:

  ```
  === set batch (keys 0-99) (33 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  val=$(grep -h 'SET K00465 =' /tmp/ctx_offload/* | sed 's/SET K00465 = //'); printf '<<<ANSWER key=K00465>>>\n%s\n<<<ANSWER END>>>\n' "$val"; echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [tool] <<<ANSWER key=K00048>>>
  kindle boulder garnet fathom cinder thistle ember pewter cinder vellum marble onyx verdant garnet spruce onyx thistle glacier cinder glacier indigo lattice willow russet #948823b5
  <<<ANSWER END>>>
  ```

Flags: none from the checks above.


### ClmStream (v2 skill) x sudoku t150 seed 42

- trial dir: `clm-paper-sudoku-t150-seed42/sudoku-sketchpad-t150-seed42__tLYLMeo`
- agent wall: 2026-09-27T02:26:13.756360Z -> 2026-09-27T02:42:24.532173Z
- reward: reward=1, matched=150, total=150, reward_versioned=1, reward_content=1, grader_valid=1, agent_peak_tokens=9719, graded_from=snapshots
- terminated_by: **stream_exhausted**; ops delivered 150/150; refusals 0; explanations 0
- stream identity: count 150, sha256 66e1fc7e2a30328d..., removed from container: True
- op headers in snapshots (153 frames): first appearance by role {'user': 150} -> 150 op user turns vs 150 delivered
- delivery log: 150 ops; op 0 at start; 149 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 149/149
- peak context: 9719 tokens (budget 32768, usable 30720)
- CLM context edits (n_ctx_syncs_real): 149

  one edit (command head, harness note):

  ```
  python3 - <<'PY' && echo READY_FOR_NEXT_OP
  import pathlib, re
  f = '/tmp/.live_ctx/LIVE_CTX_MAIN.txt'; t = open(f).read()
  ...
  [LIVE_CTX_MAIN.txt: edit applied — context ~9243->9160 tokens, 5 turns]
  ```
- snapshot fidelity: 151 sent snapshots; transitions append-only 2, changed by a recorded event 148 CLM context edit, unexplained 0
  - CLM edits whose editing command is visible in the new turn: 148/148
- sudoku versions missed among delivered moves: 0; not delivered (run ended): 0

Excerpts:

- op header:

  ```
  === board 1 move v1 (149 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [tool] <<<SKETCHPAD BEGIN>>>
  VERSION: 1
  (1,1,9) (1,2,8) (1,3,.) (1,4,G) (1,5,6) (1,6,7) (1,7,C) (1,8,.) (1,9,.) (1,10,5) (1,11,.) (1,12,.) (1,13,.) (1,14,E) (1,15,.) (1,16,4)
  (2,1,.) (2,2,.) (2,3,.) (2,4,E) (2,5,.) (2,6,.) (2,7,B) (2,8,.) (2,9,D) (2,10,.) (2,11,8) (2,12,.) (2,13,.) (2,14,.) (2,15,.) (2,16,6)
  (3,1,5) (3,2,.) (3,3,B) (3,4,.) (3,5,.) (3,6,E) (3,7,2) (3,8,.) (3,9,.) (3,10,.) (3,11,6) (3,12,.) (3,13,9) (3,14,.) (3,15,.) (3,16,8)
  (4,1,F) (4,2,.) (4,3,.) (4,4,7) (4,5,8) (4,6,.) (4,7,.) (4,8,9) (4,9,.) (4,10,3) (4,11,.) (4,12,.) (4,13,.) (4,14,A) (4,15,.) (4,16,.)
  (5,1,.) (5,2,C) (5,3,A) (5,4,.) (5,5,.) (5,6,.) (5,7,.) (5,8,.) (5,9,.) (5,10,4) (5,11,.) (5,12,.) (5,13,.) (5,14,.) (5,
  [...]
  ```

Flags: none from the checks above.


### Terminus2Stream x sudoku t150 seed 42

- trial dir: `terminus-paper-sudoku-t150-seed42/sudoku-sketchpad-t150-seed42__FJ3e5aX`
- agent wall: 2026-09-27T02:26:13.761063Z -> 2026-09-27T02:53:57.704768Z
- reward: reward=0.1533, matched=23, total=150, reward_versioned=0.1533, reward_content=0.1533, grader_valid=1, agent_peak_tokens=3.192e+04, graded_from=snapshots
- terminated_by: **budget_wall**; ops delivered 24/150; refusals 0; explanations 0
- stream identity: count 150, sha256 66e1fc7e2a30328d..., removed from container: True
- op headers in snapshots (48 frames): first appearance by role {'user': 24} -> 24 op user turns vs 24 delivered
- ATIF trajectory: 24 `source=user` op steps
- delivery log: 24 ops; op 0 at start; 23 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 17/23 (+6 delivered right after a harness summary/compaction, which replaces the prior output)
- peak context: 31925 tokens (budget 32768, usable 30720)
- terminus summarizations: 7
- snapshot fidelity: 24 sent snapshots; transitions append-only 17, changed by a recorded event 6 terminus summarization, unexplained 0
  - post-reply snapshot == sent snapshot + one assistant message: 23/23
- sudoku versions missed among delivered moves: 1; not delivered (run ended): 126
  - v24 (op 23, move v24): never displayed with this VERSION

Excerpts:

- op header:

  ```
  === board 1 move v1 (149 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  printf '%s\n' '<<<SKETCHPAD BEGIN>>>' 'VERSION: 1' '(1,1,9) (1,2,8) (1,3,.) (1,4,G) (1,5,6) (1,6,7) (1,7,C) (1,8,.) (1,9 [...] ) (16,10,.) (16,11,.) (16,12,6) (16,13,.) (16,14,.) (16,15,.) (16,16,E)' '<<<SKETCHPAD END>>>' && echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [user] <<<SKETCHPAD BEGIN>>>` /
  `<<<SKETCHPAD END>>>
  ```

Flags: none from the checks above.


### ContextBenchAgent x sudoku t150 seed 42

- trial dir: `cbagent-paper-sudoku-t150-seed42/sudoku-sketchpad-t150-seed42__qZ983db`
- agent wall: 2026-09-27T02:26:10.095883Z -> 2026-09-27T02:31:36.907014Z
- reward: reward=0.06, matched=9, total=150, reward_versioned=0.06, reward_content=0.06, grader_valid=1, agent_peak_tokens=3.313e+04, graded_from=snapshots
- terminated_by: **budget_wall**; ops delivered 10/150; refusals 0; explanations 0
- stream identity: count 150, sha256 66e1fc7e2a30328d..., removed from container: True
- op headers in snapshots (11 frames): first appearance by role {'user': 10} -> 10 op user turns vs 10 delivered
- delivery log: 10 ops; op 0 at start; 9 released by a standalone readiness command, 0 otherwise; snapshot order check (last command before each op k>=1 is the readiness command): 0 violation(s); echo output line present before each op k>=1: 9/9
- peak context: 33128 tokens (budget 32768, usable 30720)
- snapshot fidelity: 10 sent snapshots; transitions append-only 9, changed by a recorded event none, unexplained 0
- sudoku versions missed among delivered moves: 1; not delivered (run ended): 140
  - v10 (op 9, move v10): never displayed with this VERSION

Excerpts:

- op header:

  ```
  === board 1 move v1 (149 op(s) remaining after this) ===
  ```
- readiness command:

  ```
  printf '<<<SKETCHPAD BEGIN>>>
  VERSION: 1
  (1,1,9) (1,2,8) (1,3,.) (1,4,G) (1,5,6) (1,6,7) (1,7,C) (1,8,.) (1,9,.) (1,10,5 [...] 9,5) (16,10,.) (16,11,.) (16,12,6) (16,13,.) (16,14,.) (16,15,.) (16,16,E)
  <<<SKETCHPAD END>>>
  '; echo READY_FOR_NEXT_OP
  ```
- answer block:

  ```
  [tool] <<<SKETCHPAD BEGIN>>>
  VERSION: 1
  (1,1,9) (1,2,8) (1,3,.) (1,4,G) (1,5,6) (1,6,7) (1,7,C) (1,8,.) (1,9,.) (1,10,5) (1,11,.) (1,12,.) (1,13,.) (1,14,E) (1,15,.) (1,16,4)
  (2,1,.) (2,2,.) (2,3,.) (2,4,E) (2,5,.) (2,6,.) (2,7,B) (2,8,.) (2,9,D) (2,10,.) (2,11,8) (2,12,.) (2,13,.) (2,14,.) (2,15,.) (2,16,6)
  (3,1,5) (3,2,.) (3,3,B) (3,4,.) (3,5,.) (3,6,E) (3,7,2) (3,8,.) (3,9,.) (3,10,.) (3,11,6) (3,12,.) (3,13,9) (3,14,.) (3,15,.) (3,16,8)
  (4,1,F) (4,2,.) (4,3,.) (4,4,7) (4,5,8) (4,6,.) (4,7,.) (4,8,9) (4,9,.) (4,10,3) (4,11,.) (4,12,.) (4,13,.) (4,14,A) (4,15,.) (4,16,.)
  (5,1,.) (5,2,C) (5,3,A) (5,4,.) (5,5,.) (5,6,.) (5,7,.) (5,8,.) (5,9,.) (5,10,4) (5,11,.) (5,12,.) (5,13,.) (5,14,.) (5,
  [...]
  ```

Flags: none from the checks above.
