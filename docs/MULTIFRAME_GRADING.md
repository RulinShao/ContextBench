# Proposal: multi-frame grading for needle retention and sudoku (optional follow-up)

Status: proposal only. Nothing here is implemented, and the rewards of record are
unchanged.

## What the current definitions allow

Both families are graded from the harness's per-turn snapshots, which the agent can no
longer forge. What a snapshot contains is still up to the agent, and two shortcuts stay
open:

- **Needle retention** scores the final snapshot only. An agent can write each needle
  line to disk when it arrives, drop it from its context, and `cat` the file in its last
  turn. The lines are then "present in the final context" as tool output, although the
  agent never kept them in context while the stream ran. `tools/audit_trial.py` flags
  commands that write needle tags to disk, but the reward does not change.
- **Sudoku** credits a version if its exact grid appears in any snapshot, at any time.
  An agent can keep the moves on disk, compute the boards offline, and print many
  versions late in the run (all of them, if one tool output fits the budget). The
  version is credited although it was never on the sketchpad when its move arrived.

## Proposal

Add timing-aware rewards next to the current ones, as extra keys, without changing
`reward`:

- **`reward_retained` (needle).** A gold line counts if it is present in every snapshot
  from the first one after its delivery to the last one. A line that disappears and
  reappears (for example, re-read from disk) does not count. A weaker variant counts a
  line present in at least a fraction `q` of those snapshots (with `q` fixed in advance,
  for example 0.9).
- **`reward_timely` (sudoku).** Version `v` counts if its exact grid is displayed in a
  snapshot recorded after move `v` was delivered and before move `v + 1` was delivered.
  The snapshots carry `n_ops_delivered`, so the window of each version can be read from
  them without new harness fields.

Both rules need the delivery index of each snapshot, which `SnapshotLog` already
records (`n_ops_delivered` in every snapshot written through `CBStreamMixin` and
Terminus2Stream; the Python runner records it too).

## What would need checking first

- **Harnesses that compact or summarize.** A summarizing harness (terminus-2, codex) can
  legitimately drop a needle and restore it from its summary. `reward_retained` would
  score that run lower, which is a different claim about the method, not a grader fix.
  Report both numbers, and keep the current `reward` as the number of record.
- **Snapshot granularity.** Harnesses snapshot at different points (sent, post-reply,
  pre-compaction). The windows above use delivery counts, not snapshot counts, so they
  do not depend on how often a harness snapshots, but they should be checked on one
  trial per harness before use.
- **Validation.** Re-grade existing trials with both keys and list every trial where the
  new key differs from `reward`, with the reason read from the trace. Then run one small
  new experiment with a scripted agent whose disk-parking behaviour is switched on or off
  by a single flag, so the new keys are shown to separate the two behaviours. Comparing
  existing trials by how much they used the disk would not show that, because the disk
  use comes from the runs themselves.
