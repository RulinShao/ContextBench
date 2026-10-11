#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
evicted token miss timeout upstream latency latency expired #f36118b0
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
exhausted cache quota replica #e0024a53
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
refused queue queue connection retry refused expired #db3b5257
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
downstream heartbeat evicted handshake refused token lag upstream reset #c631c2b2
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
deadlock backlog downstream exhausted rollback retry throttled #66dfd3b7
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
heartbeat connection queue timeout #fc22db93
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
pool shard latency handshake #932dc271
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
expired deadlock refused latency connection #0e91b4ca
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
exhausted quota lag exhausted #eb50c508
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
quota latency heartbeat spike #3b3a564d
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
spike downstream pool exhausted quota spike #eae3d493
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
upstream handshake retry downstream reset evicted backlog deadlock #6395f461
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
319
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
85
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
316
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
140
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
92
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
100
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
306
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
85
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
319
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
306
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
319
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
319
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
