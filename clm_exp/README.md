# clm_exp: the paper's experiment settings

Everything here is specific to reproducing the paper's ContextBench results. The benchmark
itself (`contextbench/`) does not depend on it. `configs/paper.yaml` is a byte-identical copy
of `contextbench/configs/paper.yaml`, the levels file the CLI uses by default and ships in the
installed package.

| Path | What it holds |
|---|---|
| `configs/paper.yaml` | The 32 levels the paper's figure plots, seeds 42-49, budget 32768, reserve 2048, main-figure flags |
| `skills/<method>/<family>.md` | The method skills each method of the paper's GPT-5.4 figure ran with, sha-matched to the runs of record (see `skills/README.md`) |

To evaluate your own agent on your own levels, write a levels file in the same format and pass it
with `--config`.
