# Changelog

## v0.1

Benchmark version `0.1` (package `0.1.0`). Hardens the graders and the runner against
reward hacking; the threat model is in [`docs/DESIGN.md`](docs/DESIGN.md) and the README
("What the grader assumes"). Task streams, gold answers and the scoring of honest runs
are unchanged. The original release remains available at tag `v0.0-paper`.

### What changes for users

- **New run command.** Every Harbor run passes
  `--verifier contextbench.harbor.verifiers:ContextBenchVerifier`; a run without it is not
  a valid scored run. From GitHub, pin this version with
  `--repo RulinShao/ContextBench@v0.1`; from Hugging Face, use `revision="v0.1"`.
- **Snapshots on the host.** Harnesses write the per-turn context snapshots through
  `contextbench.tokens.SnapshotLog` (or `CBStreamMixin`) into
  `<trial_dir>/contextbench_harness/`, which is not mounted into the container, with a
  `snapshot_manifest.jsonl` of sha256 hashes that the harness closes at the end of the
  run. Snapshots in the agent's logs dir are not graded. Integrations written for the
  original release need the host verifier flag and this snapshot recorder.
- **Separate verifier environment.** Tasks set `[verifier] environment_mode =
  "separate"`: Harbor stops the agent's container before verification. `tests/test.sh`
  grades nothing.
- **Invalid instead of zero.** A run that cannot be graded (missing, unlisted, changed
  or unreadable snapshots, an unclosed manifest, a budget mismatch, a context over the
  budget other than the wall-hitting end of a `budget_wall` run) gets no `reward.json`;
  `contextbench_result.json` holds the reason, and the verifier fails.
- **One source per grade, no fallback.** `harness` (scored runs), `legacy` (offline
  re-grading of older run folders) and `oracle` (the reference solution, only for trials
  of Harbor's `oracle` agent). The trajectory and report fallbacks are gone.
- **Answer rules (kv store, log triage).** Answers count only from assistant messages
  and tool output (terminus-2's terminal turns are tool output; JSON replies are read
  decoded); each marker of an ANSWER block must start a line; one answer per question,
  the last one in the run; kv values and log lookups must equal the gold after
  whitespace normalization; a count must state exactly one number; keys are
  case-sensitive.
- **Budget checked by the grader.** Every snapshot must record the task's budget, and
  the grader recounts each with `o200k_base`. Without `tiktoken` it checks the
  harness's recorded counts instead and reports `tokens_verified=0`.
- **Host-side writes** into the directories the container can reach never follow a
  symlink.
- **`CodexStream`** ends a run as `budget_wall` whenever the context after a turn is over
  the wall, whatever the turn's last command was.
- **Version recorded.** `benchmark_version` is in every grade, in
  `contextbench_result.json` and (as `0.1`) in `reward.json`; `contextbench --version`
  shows it.
- **Hugging Face export.** `contextbench export-hf --revision v0.1` writes the card for
  a separate dataset revision; data, tasks and registry are the same as without it.

### Re-grading older run folders

A run folder recorded before v0.1 has its snapshots in the agent's logs dir
(`<trial_dir>/agent/context_snapshots/`) and no manifest. Re-grade it offline with
`--mode legacy`, pointing at that agent dir and the task:

```bash
contextbench grade --mode legacy --run-dir <trial_dir>/agent --task-dir <task>
```

or, with the standard-library copy of the graders in a task:

```bash
python3 -I -c 'import sys; sys.path.insert(0, sys.argv.pop(1)); from contextbench.harbor.reward import main; sys.exit(main())' \
    <task>/tests/_cb --mode legacy --run-dir <trial_dir>/agent --task-dir <task> --out-dir <dir>
```

Legacy mode applies the v0.1 answer rules and budget checks but reads files the agent
could write: there is no manifest, a snapshot need not record the budget, a recorded
token count need not equal the recount (the larger is kept), and `terminated_by` comes
from `interactive_stream.json` in the agent dir. Use it only for runs whose provenance
was checked by other means (`tools/audit_trial.py`), never as a scored grade.

### Known limitations

- `CodexStream` and `MiniSweAgentStream` build snapshots from session files the CLI
  keeps in the agent-visible logs dir; they are not tamper-proof against an
  adversarial agent.
- Only single-step Harbor tasks are supported.
- Tasks use `network_mode = "public"`; the gold and the reference solution are public,
  so an agent with network access could look them up.
- Without `tiktoken` and the `o200k_base` vocabulary, token counts are the harness's
  recorded ones (`tokens_verified=0`), not recounted.
- Harbor's own host-side writes into the agent dir (for example terminus-2's
  `trajectory.json`) are Harbor's and are not covered by the symlink guard.
