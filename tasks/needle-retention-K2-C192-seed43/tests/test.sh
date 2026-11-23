#!/usr/bin/env bash
# ContextBench tasks are graded on the host, never in the agent's container. Run
#   harbor ... --verifier contextbench.harbor.verifiers:ContextBenchVerifier
# The harness writes the context snapshots to <trial_dir>/contextbench_harness/, which
# is not mounted here, so nothing in this container can produce a valid score. This
# script runs no interpreter from the container: it removes any reward file the agent
# may have left in /logs/verifier and exits non-zero, so the trial has no reward.
cd /tests || exit 3
/bin/rm -f /logs/verifier/reward.json /logs/verifier/reward.txt
echo "ContextBench: tests/test.sh does not grade. Grade on the host with" >&2
echo "  --verifier contextbench.harbor.verifiers:ContextBenchVerifier" >&2
exit 3
