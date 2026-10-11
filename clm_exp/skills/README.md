# Method skills used in the paper

A method skill is the per-method section of the task instruction that tells the agent how to
manage its context with the tools its harness provides. ContextBench's scaffolds
(`contextbench/tasks/<family>/scaffold.md`) carry no skill; this directory holds the skills the
arms of the paper's ContextBench figure (GPT-5.4, 32K context limit) actually received, byte for
byte. Nothing here was edited: no skill contained internal paths, service names or identifiers,
so no scrubbing was needed (paths such as `/tmp/.live_ctx/...` or `/tmp/store` are container
paths that belong to the method).

Layout: `clm_exp/skills/<arm>/<family>.md`. `base` and `summary` ran two skills in the figure (see
below), so they also have `<family>.short.md`.

## Where the skill goes

The paper's package builder placed the skill where the scaffold's `{memory_section}` used to be:
for kv_store, log_triage and needle_retention before the closing line "The run ends
automatically ...", as `"\n" + skill + "\n"`; for sudoku_sketchpad before
`## Turn protocol (IMPORTANT)`, followed by two blank lines. `contextbench package
--method-file clm_exp/skills/<arm>/<family>.md` appends the skill at the end of the instruction instead;
an adapter that wants the byte-exact paper instruction inserts it at the position above (see
`docs/DEVIATIONS.md`, "Instruction scaffolds" and "Method skills under clm_exp/skills/").

## Arm names

| directory | figure legend | internal arm name |
|---|---|---|
| `clm` | CLM (Ours) | livectx (method text v2, "trace-cut") |
| `acm` | ACM | acmfd (ACM with the detailed skill) |
| `rlm` | RLM | rlm_hh (faithful RLM harness) |
| `context_folding` | Context folding | fold |
| `self_compact` | Self-Compact | selfcompact |
| `summary` | Summary | summary |
| `base` | Base | base |

Sculptor and "RLM + state reset" were removed from the figure and have no skills here.

## Skills

Source = file in the paper's code repository (`live_context_bench/<family>/...`) at the named
commit; sha16 = first 16 hex digits of the SHA-256 of the file bytes in this directory (equal to
the source file's bytes except where noted). Rungs are the figure's x positions; every row of
the figure at those rungs used the skill, seeds 42-45 unless noted.

| file | source | sha16 | figure rows (family: rungs) |
|---|---|---|---|
| `clm/kv_store.md` | `livectx_method.md` @ bf07ea2deb | `70695bdca1a7f39d` | kv: R130-R16000 |
| `clm/log_triage.md` | `livectx_method.md` @ bf07ea2deb | `1a071e820bcc9a93` | log: L160-L12800 |
| `clm/needle_retention.md` | `livectx_method.md` @ bf07ea2deb | `e834d24bf004c7ae` | needle: all rungs incl. K8-C60/C62, K2-C192/C224 |
| `clm/sudoku_sketchpad.md` | `livectx_method.md` @ bf07ea2deb | `378c4e5d928af06f` | sudoku: t4-t150 |
| `acm/kv_store.md` | `acmfd_method.md` @ 0a41469675 | `1a8315652e7606fa` | kv: R130-R16000 |
| `acm/log_triage.md` | `acmfd_method.md` @ 0a41469675 | `10d6548f14e99cbd` | log: L160-L3200, L12800 |
| `acm/needle_retention.md` | `acmfd_method.md` @ 0a41469675 | `d22af5b85ab15963` | needle: K4-C4, K4-C8, K4-C24, K4-C96, K8-C48, K8-C60, K2-C192, K2-C224 |
| `acm/sudoku_sketchpad.md` | `acmfd_method.md` @ 0a41469675 | `12749d3c2b9eb6fa` | sudoku: t4-t150 |
| `rlm/kv_store.md` | `rlm_method.md` @ 988668a980 | `d03eb3d39ab139e8` | kv: R130-R16000 |
| `rlm/log_triage.md` | `rlm_method.md` @ 988668a980 | `55a95152 76388a9a` (1) | log: L160-L12800 |
| `rlm/needle_retention.md` | `rlm_method.md` @ 988668a980 | `9a8f4a5dcbcaf879` | needle: all rungs incl. K8-C60/C62, K2-C192/C224 |
| `rlm/sudoku_sketchpad.md` | `rlm_method.md` @ 988668a980 | `822d560dafa6ad0f` | sudoku: t4-t150 |
| `context_folding/kv_store.md` | `fold_method.md` @ 93978b562f | `d338be8c722bbdd3` | kv: R130-R16000 |
| `context_folding/log_triage.md` | `fold_method.md` @ 93978b562f | `e4c50731a9aa634f` | log: L160-L12800 |
| `context_folding/needle_retention.md` | `fold_method.md` @ 93978b562f | `8bf38cdb2deb04d3` | needle: all rungs incl. K8-C60/C62 |
| `context_folding/sudoku_sketchpad.md` | `fold_method.md` @ 93978b562f | `cb73d638125e7b84` | sudoku: t4-t150 |
| `self_compact/kv_store.md` | `selfcompact_method.md` @ 93978b562f | `762b6c9abcb25c20` | kv: R130-R16000 (seeds 42-49 on some rungs) |
| `self_compact/log_triage.md` | `selfcompact_method.md` @ 93978b562f | `6b4b5c9e6d7e78c2` | log: L160-L12800 (seeds 42-49 on some rungs) |
| `self_compact/needle_retention.md` | `selfcompact_method.md` @ 93978b562f | `5bfcbda0891d2a74` | needle: all rungs incl. K8-C60/C62 |
| `self_compact/sudoku_sketchpad.md` | `selfcompact_method.md` @ 93978b562f | `cf821a1f2a977668` | sudoku: t4-t150 (seeds 42-49 on some rungs) |
| `summary/kv_store.md` | `summary_method.md` @ 93978b562f | `b071f2a8e12d64a5` | kv: R8000, R16000 |
| `summary/log_triage.md` | `summary_method.md` @ 93978b562f | `d239e42e4dafedd2` | log: L6400, L12800 |
| `summary/needle_retention.md` | `summary_method.md` @ 93978b562f | `79ff853b7c57280e` | needle: K2-C192, K2-C224 |
| `summary/sudoku_sketchpad.md` | `summary_method.md` @ 93978b562f | `6db882c3d3022973` | sudoku: t30, t60, t100, t150 (seeds 46-49) |
| `summary/kv_store.short.md` | inline section of `build.py` @ fd5ba98b | `4d74601b360847e1` | kv: R130-R4000 (seeds 42-49) |
| `summary/log_triage.short.md` | inline section of `build.py` @ fd5ba98b | `0ace0d75fb79ba73` | log: L160-L3200 (seeds 42-49) |
| `summary/needle_retention.short.md` | inline section of `build.py` @ fd5ba98b | `61395753201008cf` | needle: K4-C4-K8-C48 (seeds 42-49), K8-C60, K8-C62 |
| `summary/sudoku_sketchpad.short.md` | inline section of `build.py` @ fd5ba98b | `5c9205a9cb006553` | sudoku: t4-t150 (seeds 42-45) |
| `base/kv_store.md` | `base_method.md` @ 93978b562f | `a0b9d4b54b496426` | kv: R8000, R16000 |
| `base/log_triage.md` | `base_method.md` @ 93978b562f | `5c68cf8a937003b4` | log: L6400, L12800 |
| `base/needle_retention.md` | `base_method.md` @ 93978b562f | `f630bb9c68e77145` | needle: K2-C192, K2-C224 |
| `base/kv_store.short.md` | inline section of `build.py` @ fd5ba98b | `58ba7d944434646f` | kv: R130-R4000 |
| `base/log_triage.short.md` | inline section of `build.py` @ fd5ba98b | `52bead31380b399b` | log: L160-L3200 |
| `base/sudoku_sketchpad.short.md` | inline section of `build.py` @ fd5ba98b | `418fc80559b8f2c1` | sudoku: t4-t150 |

(1) Printed with a space after 8 digits: the value holds a run of ten decimal digits, which the
release scrub rejects as an id.

No skill: **base x needle_retention** at K4-C4 to K8-C48, K8-C60 and K8-C62. The builder that
made those packages gave the base arm an empty section, so the agent saw the scaffold alone.

Base sudoku ran only the short skill in the figure, so `base/` has no `sudoku_sketchpad.md`.

## Notes

- The `clm` skills equal `livectx_tracecut_method.md` of the same repository (kv, log @ 38f1f9f5ed;
  needle @ e2bcc95513; sudoku @ a82796e0eb); the CLM sudoku packages were built from a scaffold
  without the sentence "Once a move is applied to your sketchpad, ... are stale." that
  ContextBench's sudoku scaffold keeps.
- The `.short.md` skills have no source file of their own: they are the memory sections that
  `build.py` @ fd5ba98b inlined for the `base` and `summary` styles, with leading and trailing
  blank lines trimmed.
- How each skill was matched to the figure's rows is recorded in `docs/DEVIATIONS.md`,
  "Method skills under clm_exp/skills/".
