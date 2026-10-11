#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
exhausted quota spike pool handshake #88607b8a
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
spike throttled lag token replica cache exhausted refused shard #063d7343
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
pool quota token evicted lag handshake throttled heartbeat #820df22b
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
handshake evicted expired retry shard lag throttled pool #10d71247
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
backlog deadlock timeout lag queue rollback timeout deadlock #26bc3513
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
exhausted handshake queue expired connection #a83ef4d1
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
evicted replica heartbeat throttled connection shard miss pool #2aaf69aa
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
backlog deadlock refused downstream miss expired token replica #ecf6c49b
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
expired downstream pool shard #2dd61224
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
queue rollback reset timeout lag quota evicted refused #7b131ba0
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
evicted replica timeout queue replica latency #a3809bcd
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
evicted handshake cache evicted evicted #bd10e0a3
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
19
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
10
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
10
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
17
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
