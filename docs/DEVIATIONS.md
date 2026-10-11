# Deviations from the benchmark of record

ContextBench is a port. This file lists every place the released package differs
from the internal benchmark it was ported from, and the questions the source left
open. Anything not listed here was ported as is.

Parity is machine-checked where it can be. With the reference tree available,
`pytest` compares the ported generators (byte-identical instance files), the
feasibility gate (every measured number and every check detail string), and the four
graders (every shared reward key, on a full run and on a half-correct run). Those
tests skip when the reference tree is absent, so the public repository carries no
path to it.

## Token counting

**The fallback divisor is `len // 3`, not `len // 4`.** The source used two different
estimates: the feasibility gate divided by 3, the harness's own context accounting
divided by 4. The design document settles on `len // 3` for the whole package, so
that is what `contextbench.tokens.count_text` does and what the gate inherits.

With `tiktoken` installed -- the normal case, and the case every paper number was
produced under -- counts are exact `o200k_base` and identical either way. Without it,
the package estimates roughly a third more tokens than the harness of record did, so
the budget wall fires slightly earlier. Every reward dict and every receipt records
the method (`tiktoken:o200k_base` or `approx_chars3`), so the two are never mixed
silently.

*Open question:* which divisor was intended as the package-wide fallback. The two
source values were never reconciled.

## Instruction scaffolds

**Ported from the interactive scaffold, with the method skill removed.** Each family's
build script carried two scaffolds: one where the agent pulls operations with a shell
command, and one where the harness pushes each operation as a user message. Only the
second matches this package's turn protocol, so that is the one in
`contextbench/tasks/<family>/scaffold.md`. The trailing `{memory_section}` -- the
per-method skill telling the agent how to manage its context -- is removed: phase 1
evaluates agents on the task contract alone.

**Two sections are rewritten for shell-less agents.** The scaffolds of record describe
readiness as `echo READY_FOR_NEXT_OP`, because the paper ran agents with a bash tool.
`instruction(family, delivery="bash")` returns that text unchanged.
`delivery="reply"`, the Python runner's default, replaces the
`## Turn protocol (IMPORTANT)` section with a marker-line equivalent, and for
`sudoku_sketchpad` also replaces `## Keeping your board in your context`, whose text
of record requires a tool call and rejects a plain reply. Both replacements are single
named sections in `contextbench/tasks/scaffold.py`; everything outside them is the
text of record, byte for byte.

**Where a method skill goes, and one sudoku sentence.** The scaffolds of record held the
skill at `{memory_section}`, which for kv_store, log_triage and needle_retention sits
before the closing "The run ends automatically ..." line and for sudoku_sketchpad before
`## Turn protocol (IMPORTANT)`. `contextbench package --method-file` appends at the end;
an adapter that wants the byte-exact paper instruction inserts the skill at that point
instead (the CLM adapter outside this repository does, and its kv/log/needle
instructions then hash identically to the paper's CLM packages). The sudoku scaffold
here carries the sentence "Once a move is applied to your sketchpad, the move message
and your working turns for it are stale.", as did every baseline package of the paper;
the paper's CLM sudoku packages were built from a scaffold without it, so a CLM sudoku
instruction differs from the paper's by that sentence alone.

*Open question:* the paper only ever ran the shell wording. Reply-mode numbers are
produced under a different instruction and are not strictly comparable to it.

## Needle retention: the final-report mode

**`<<<NEEDLES BEGIN>>>` / `<<<NEEDLES END>>>` has no source.** The marker pair appears
only in the design document; nothing in the reference tree emits or parses it. The
reward definition here is therefore new: the normalized lines inside the block,
intersected with the gold needle lines, over the gold total.

It is kept strictly separate from the paper metric. A result records
`mode: "final_report"` next to `graded_from: "final_report"`, and the two modes are
never averaged: a line an agent *reports* is weaker evidence than a line still
*present* in its context, because a reporting agent could have read it back from
anywhere.

**Snapshots are preferred over the trajectory.** The source needle grader read only
`trajectory.json`. This package prefers the last per-turn snapshot when snapshots
exist, then the trajectory, then the report. The parity test confirms the two agree
on the same trajectory file.

## Graders

**Plain classes instead of container verifiers.** The source graders subclass the
container runtime's verifier base and expose an `async verify()` that reads gold and
the trajectory through runtime path helpers. Here each grader is a plain class with
`grade(run_dir, gold) -> dict`, and the three readers live in
`contextbench/graders/base.py`. The reward names, the reward values, and the matching
rules are unchanged, which the parity tests check key by key.

**`graded_from` is added to every result.** The source recorded no such field, because
each grader read exactly one source. With three readers, a number is only meaningful
next to the source it came from.

**The grader witness is not ported.** The source graders stamped their own class,
file, and file hash into the reward dict, to make a `PYTHONPATH` grader shadow visible
in the output -- one family's grader silently resolving for another's import path.
The public package selects a grader from `gold.meta.task_family` through a table in
`contextbench.graders`, with no import-path indirection to shadow, so the witness has
nothing to guard.

**An ungradeable run is invalid, not a zero.** A run that left no snapshots, no
trajectory and no report returns `grader_valid: 0.0`, `graded_from: "none"` and a
`grader_note` saying why. The source returned the same zero reward and
`grader_valid: 0.0`; the note is new.

## The feasibility gate

**The regime is an argument, not an environment variable.** The source read
`FEAS_REGIME` from the environment to switch between the `pressure` and `sub-budget`
regimes, which made the gate's verdict depend on ambient state. Here it is a
parameter of `evaluate()` and a `--regime` flag, defaulting to `pressure`. The verdict
and the receipt record which regime ran, as before.

**The receipt lands beside the instance.** The source wrote the receipt into a
container package's host-side `tests/` directory and named the validator hash
`feasibility_py_sha16`. Here `write_receipt` puts `feasibility_receipt.json` in the
instance directory and names the field `validator_sha16`, with `regime` and
`token_method` added. The hash value differs from the internal pin because it is the
hash of *this* validator's bytes, which is the whole point of recording it.

**The sudoku retained estimate is the source's, and it is conservative.** The gate
estimates the retained mass for `sudoku_sketchpad` as a pencil-mark panel, where each
cell occupies a `box` by `box` block. The generator renders one `(row,col,value)`
tuple per cell instead, which is smaller. Ported unchanged, so the recorded level
numbers reproduce exactly.

*Open question:* whether the pencil-mark estimate is intended as a deliberate safety
margin or is left over from an earlier panel format.

## Levels and seeds

**Seeds 42-49.** The internal configuration pinned seeds 42-45 for its 48-package
sweep. `clm_exp/configs/paper.yaml` carries 42-49 as specified for the release. The paper's
figure rows use seeds 42-45 for every arm and 46-49 in addition for some arms.

*Open question:* which seed set is the release's set of record.

**The levels are the paper figure's rungs, not the internal pinned ladder.** An earlier
`clm_exp/configs/paper.yaml` copied the internal configuration's pinned level tuples, a
12-level ladder whose sudoku axis was board size (box 3 / 4 / 5 with 150 / 100 / 60
moves). The figure the paper reports plots different levels, and nothing in the
release needs the old ladder, so it was removed. The file now carries every rung in
the figure's per-seed rows: kv_store R130-R16000 (8 rungs), log_triage L160-L12800 (7),
needle_retention K4-C4 to K2-C224 (10), and sudoku_sketchpad as one 16x16 board (box 4,
90 givens) played for 4 to 150 moves (7). The knobs were checked by generation: for
every rung and every seed the figure's rows contain (42-49, or 42-45 where only those
ran), the op stream is byte-identical to the stream the paper's run configurations
expect (canonical sha of the ops). Two knobs matter beyond the named axis:
log_triage's batch size is 14 lines up to L1600, 27 at L3200 and 54 from L6400 on, and
needle_retention uses 140 filler lines per chunk (the generator's default is 160).

**Descriptive keys per level.** Each level also carries `figure_x`, `main_figure`,
`regime` and, where the appendix lists it, `appendix_pressure`; `contextbench.levels`
keeps them out of the generator. `main_figure: true` marks the rungs drawn in the
main-text figure: every rung except needle K4-C6 and K8-C62 and log L6400, which the
figure generator drops. (The appendix text says three rungs per family are shown; the
figure and the appendix pressure table show more. The flag follows the figure.)

**Three pressure numbers, stated apart.** For kv_store, log_triage and
needle_retention the figure's x is the gate's `P` (streamed op tokens / budget); the
tests check the two agree within 0.5 % on every rung gated under the pressure regime.
On the rungs below one budget the figure's x was scaled linearly from a larger rung
(R130 = 0.13 x R1000's value, likewise L160-L640, K4-C4 to K4-C8, K8-C60/C62), so it
differs from the measured `P` by up to 0.03 there (R130: x 0.197, measured 0.225). The
appendix table's pressure also counts the task instruction, so it is slightly higher
than `P` (R1000: 1.57 vs 1.52). For sudoku the figure's x is the number of moves, and
the axis the appendix describes is total input over budget with the board counted once
per move (t150: 8.01); the gate's own `P` for sudoku is a third quantity, the
append-only panel mass estimate (t150: 11.0).

**Rungs below one budget are gated as `sub-budget`.** Eleven rungs have gate `P < 1`
(kv R130-R520, log L160-L640, needle K4-C4 to K4-C8, sudoku t4 and t8). The source
built these with its `sub-budget` regime; the levels say so with `regime`, and
`generate --level` and `package --all` use it, so the pressure check does not refuse
them. `task.toml` records `contextbench_regime`.

**Level names are new.** The source named packages, not levels. Levels are named after
the figure's rows (`R1000`, `L12800`, `K8-C60`, `t150`); the rows also call the sudoku
levels `box4-g90-t150` and the log levels `L12800-B54`.

**Only values, no commentary.** The source configuration file interleaved its numbers
with review history and internal references. `clm_exp/configs/paper.yaml` carries the
resolved values and the arithmetic that derives the ceilings, and nothing else.

## The runner

**`timeout` is declared but not produced.** `TERMINATED_BY` lists all five endings,
including `timeout`, which only a wall-clock-enforcing container runner can produce.
The Python runner produces `submit`, `stream_exhausted`, `budget_wall` and
`max_steps`.

**A reply with no marker at all is nudged.** The source explained a *non-standalone*
marker back to the agent but had no text for a reply that never mentions the marker:
the internal harness simply looped. `stream.NO_MARKER_TEXT` is new, so a shell-less
agent cannot stall the stream in silence.

**`strip_submit_hint` is not ported.** The source stripped a submit-syntax correction
that the container environment layer injected into tool output. The Python runner has
no such layer; the helper belongs with the container adapters in phase 2.

## Oracle

**`OracleAgent` submits after the last operation** rather than asking for another, so
the submit path is exercised by the normal test run. It also prunes its own context to
exactly what the reward reads back, which is the ideal policy rather than any
particular method.

## The container path (phase 2)

**The stream travels inside the task, not in a sidecar.** The source served the ops from a
compose sidecar or a bind-mounted `/opt/stream`, and one variant read them host-side. Harbor's
Singularity backend has no sidecars, so a task ships `environment/stream/chunks.jsonl`, which
Harbor uploads into the work directory. `TurnSource` reads it once, checks the op count and the
canonical sha (the source's canonical form: sorted-key JSON per op, newline-joined) against
`task.toml`, and then **deletes it** from the container. The source's host-read variant existed
for the same reason: a stream the agent can `cat` is a stream it can read ahead in.

**Readiness in a terminal multiplexer has no exit code.** terminus-2 types into tmux, so a
readiness command counts when its keystroke batch finished without timing out. Every other
path requires exit code 0, as in the source.

**terminus-2 carries op 0 in its first user message.** terminus builds one initial prompt
(instruction plus terminal state); op 0 is appended to it, and every later op is appended to
the user message that carries the previous terminal output. terminus keeps its first message
through its own summarization, so op 0 stays pinned in its context. codex likewise receives
the instruction and op 0 as one prompt.

**terminus-2 runs with a 400-column pane.** tmux hard-wraps output at the pane width, and a
wrapped answer line is a different string (`willow` becomes `will` + newline + `ow`), which the
graders rightly do not accept. At terminus's default of 160 columns most kv values wrap (observed:
24/24 answered, 3/24 graded correct). `Terminus2Stream` defaults `tmux_pane_width` to 400; the
patch leaves terminus's default alone, so pass `--agent-kwarg tmux_pane_width=400` with it.

**Explanation text.** `EXPLAIN_NON_STANDALONE_TEXT` uses `--` where the source used an em
dash (English-only, ASCII tree). The other protocol texts are byte-identical to the source's
(`MARKER_PARAGRAPH`, the early-submit refusal).

**Where the budget wall is measured.** The Harbor agents check the wall on the context about
to be sent to the model (after the harness's own compaction had its chance), as the CLM harness
of record does. The Python runner checks it on the context after the reply. A harness that
summarizes before sending (terminus-2) can therefore show a post-reply snapshot above the usable
budget without ending the run; snapshots carry `kind` (`sent`, `turn`, `final`) so the two can be
told apart.

**Graders decode JSON tool results.** mini-swe-agent renders every command's output as a JSON
object whose `<` and `>` are escaped (`\u003c`), so an ANSWER block the model printed is not
literally present in the tool message, although the model reads it decoded. The graders now read
the string fields of a tool message that is a single JSON object. Nothing else changes: the
parity tests against the source graders still pass.

**A failed readiness command is explained as non-standalone.** As in the source, a readiness
command with a non-zero exit (for example `python3 - <<'PY' && echo READY_FOR_NEXT_OP` whose
script failed) does not advance and is answered with `EXPLAIN_NON_STANDALONE_TEXT`, which blames
the command's form rather than its exit code. Kept for parity with the texts of record.

**`strip_submit_hint` is still not ported.** No shipped container adapter injects a submit
correction into tool output, so there is nothing to strip.

**Reward dict encoding.** Harbor's job-level mean sums every reward key, so string fields
crash it (the source witnessed this). The verifier therefore returns numeric keys only and
writes the strings to `verifier/contextbench_result.json`.

**codex needs three feature switches on an OpenAI-compatible server.** codex only speaks the
Responses API and injects `role="developer"` messages for its skills, plugins, apps,
multi-agent and goals features; vLLM 0.19's Responses endpoint rejects that role.
`CodexStream` switches those features off (`CodexStream.COMPAT_FLAGS`, on by default); codex's
own system instructions, tools and compaction are unchanged. `CodexStream` also raises codex's
stream idle timeout to 30 minutes (`stream_idle_timeout_ms`): a loaded local server can take
minutes to its first token, and codex otherwise drops and re-sends the whole turn.

*Open question:* whether the paper's method skills should be appended by the task
(`contextbench package --method-file`) or by the method's adapter. Both work and produce the
same instruction; the CLM adapter outside this repository does the latter.

## Reply-mode instruction drops the disk-as-scratch sentence

The bash scaffolds of kv_store and log_triage say the agent MAY use the disk as scratch
storage. In `delivery="reply"` (Python runner, no shell) that sentence is replaced by a
statement that the agent has no shell, files or tools. Found in a real-model smoke: with the
sentence kept, the model "wrote" records to files that did not exist and later "grepped" them,
scoring 0. `delivery="bash"` is unchanged.

## The budget wall counts o200k tokens, not the served model's tokens (resolved)

Every ContextBench wall (Python runner, `CBStreamMixin`, `Terminus2Stream`) compares an
`o200k_base` count of the messages against `budget - reserve`. The model does not see o200k
tokens. Measured on smoke contexts with the served Qwen3.6-27B tokenizer and chat template
(vLLM `/tokenize`, tool schemas not included): kv_store 1.24x the o200k count, 16x16 sudoku
1.14x, 9x9 sudoku 1.02-1.04x; terminus's own `prompt_tokens` agree (kv 1.17-1.22, 16x16
1.10-1.13, 9x9 1.03-1.05). So a 30720-token wall lets a kv agent send about 38K model tokens.

The harnesses of record did not do this: their shared budget controller multiplies the o200k
count by a ratio learned from the server's `prompt_tokens` and walls on the product. The CLM
harness keeps that controller under the CLM adapter, so inside ContextBench CLM's wall is the
stricter one (the v1-skill 9x9 run was given its final turn at a calibrated 31400 tokens, 29150
o200k, and stopped at 32444 calibrated, 30074 o200k), while ContextBenchAgent, Terminus2Stream, and mini-swe-agent
get the o200k wall. The difference is largest on kv_store and log_triage, whose random words and
hashes tokenize worst.

*Resolved:* the benchmark's wall is `o200k_base` tokens for every agent. An agent may enforce a
stricter budget of its own, as the CLM adapter does with its served-token calibration; that is
the agent's behaviour, not part of the benchmark, and no code changes.

## Terminus2Stream: context limit and summarizer calls

`Terminus2Stream` now sets terminus's `model_info.max_input_tokens` to the budget when the
launcher gives no `model_info` (the smoke launchers always passed 32768, so no smoke row
changes). Without it terminus asks LiteLLM for the model's limit, which for a local model is
unknown or the full window. terminus summarizes when `limit - history < 8000` tokens; it counts
the history only, not the terminal output about to be appended, and ignores the reserve. Both
are stock behaviour and kept.

terminus's summarization runs three subagent calls (summary, questions, answers) outside the
main chat. They are not walled and leave no snapshot; the summary call reads the whole history
plus its prompt, so it is larger than the context that triggered it (smoke: up to 40.5K served
tokens on kv). The harnesses of record capped the summary request at the budget by dropping the
oldest turns first. `Terminus2Stream` now records each call's o200k size and whether it
returned in `agent/contextbench_subagent_calls.json` (and the counts in the trial metadata);
`tools/audit_trial.py` reports them. A failed summarization (for example the questions step
running into the output cap) is logged by terminus and the loop continues unsummarized; terminus's
`summarization_count` includes it, so the audit now labels that count "attempts".

*Resolved:* a compaction call larger than the budget does not end the run. The wall applies to
the turns of the main conversation; summarization calls are recorded (size and outcome) but not
walled. This is the current behaviour and is the benchmark's rule.

## Method skills under clm_exp/skills/

**What was shipped.** `clm_exp/skills/<arm>/<family>.md` holds the method skills the arms of the paper's
ContextBench figure (GPT-5.4 row; Sculptor and "RLM + state reset" were dropped from it) received,
byte for byte; `clm_exp/skills/README.md` gives source commit, sha16 and the figure rungs per skill. No
skill needed scrubbing: none contains an internal path, service name, person or id, and the
absolute paths inside them (`/tmp/.live_ctx/...`, `/tmp/ctx_offload`, `/tmp/store`) are container
paths that belong to the method. Every file's bytes therefore equal the paper's skill text, and the
sha16 in the README is also the sha16 of the paper's skill. The skills keep the non-ASCII
punctuation of the text of record (dashes, arrows), as the scaffolds do.

**How each skill was tied to the figure.** Each figure row names the run that produced it. For
every run the task instruction the agent saw was recovered from the run's records and matched to
a candidate skill, by one of: (a) the full `instruction.md` sha16 recorded per cell at fire time,
reproduced exactly by inserting the candidate skill into the scaffold; (b) the per-cell arm-text
check of record, a hash of the method section that the launcher asserted before each cell ran,
reproduced exactly from the candidate skill; (c) for ACM, the per-cell method-section witness in
the run's own readout. All matches are exact; no skill was chosen by name alone.

**Two skills for base and summary.** The figure's base and summary points come from two skill
sets. The standard rungs (kv R130-R4000, log L160-L3200, needle K4-C4-K8-C48, sudoku t4-t150,
and needle K8-C60/C62) were re-run with packages built by an earlier builder that inlined a
short memory section (`<family>.short.md`); the harder rungs (kv R8000/R16000, log
L6400/L12800, needle K2-C192/C224) and the seed-46-49 summary sudoku points used the detailed skill
set that every other baseline used (`<family>.md`). For base x needle_retention the earlier
builder's section was empty, so those rows ran with no skill. The short skills were recovered by
running that builder and checked with method (b); they have no source file of their own.

*Open questions.* (1) Some printed baseline rows (context folding and self-compact at kv R520 and
log L1600/L3200) carry no instruction sha in the run table; they came
from the same detailed-skill wave, and the skill is attributed from the wave, not from a hash.
(2) The CLM K8-C60/C62 rows ran from a package directory whose surviving copy carries the
earlier CLM text; the launcher's per-cell arm-text check of record names the v2 skill, which is
what is attributed here. (3) The Qwen3.6-27B row of the same generator is not in the paper; its
ACM line used the earlier detailed ACM skill set, and its base and summary rows used the detailed
skills on the standard rungs (the short or empty skill only at needle K8-C60/C62); the earlier
ACM skills are not shipped.

## Readiness matcher ignores here-document bodies (differs from the paper's harness)

The paper's harness split a command on `;`, newlines, `&&` and `||` and advanced the stream if any
piece was `echo READY_FOR_NEXT_OP`. A here-document body line was therefore counted as a statement:
`cat <<'EOF'\n<board>\necho READY_FOR_NEXT_OP\nEOF` advanced the stream although the echo never runs,
contradicting the protocol text. CB strips here-document bodies and quoted strings that span lines
before splitting. A marker on the line that opens a here-document (`python3 - <<'PY' && echo
READY_FOR_NEXT_OP`, the CLM skill's form) or after its terminator still advances. Found in a gpt-5.4
reproduction run (the model prints boards with here-documents); Qwen3.6 used `printf` and never hit it.
Scores are unaffected (grading reads snapshots); delivery provenance is. Runs meant to reproduce the
paper exactly can expect this class of early advance, and the trial audit reports it.
