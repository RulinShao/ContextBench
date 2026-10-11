#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
miss queue timeout miss upstream deadlock #ed1224d5
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
miss exhausted lag queue expired upstream pool #8d390b4a
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
lag backlog handshake reset backlog token replica #01941a3e
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
spike timeout exhausted lag rollback refused refused #2430f073
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
upstream downstream rollback exhausted latency timeout pool #f3708501
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
latency pool handshake connection downstream token #d54c8191
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
latency heartbeat queue retry heartbeat exhausted #33ea055b
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
evicted latency reset backlog throttled #d7958f8d
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
pool quota lag throttled cache deadlock token token #a038c0bb
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
timeout quota latency cache handshake backlog #c7c2cec6
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
evicted throttled connection connection evicted deadlock miss #ff5d889e
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
exhausted pool connection connection pool replica quota #e80f8d1e
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
581
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
1342
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
1301
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
261
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
581
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
337
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
329
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
530
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
1342
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
261
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
339
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
324
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
