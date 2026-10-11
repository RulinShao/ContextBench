#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
exhausted queue miss evicted heartbeat pool latency #e9cd3a4e
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
backlog token retry upstream throttled queue exhausted pool quota #24da8865
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
pool heartbeat retry rollback #7cbbf294
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
refused miss handshake evicted refused connection miss downstream #53ed5ded
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
reset shard latency latency expired reset #d4ebcd8c
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
deadlock lag replica latency quota lag throttled pool #75bc6ba5
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
shard replica spike pool expired #8a277887
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
replica miss token miss expired pool #264586f0
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
token retry connection queue replica retry backlog #f0c13e07
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
token downstream connection replica refused #5e2d9f89
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
connection upstream throttled miss #c0dcd7c3
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
refused rollback upstream miss token rollback #1a0f4fef
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
95
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
136
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
355
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
279
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
79
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
327
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
319
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
87
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
279
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
327
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
151
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
99
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
