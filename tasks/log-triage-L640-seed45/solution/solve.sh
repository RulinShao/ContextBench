#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
downstream cache spike reset #5aa2e892
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
throttled heartbeat cache expired quota miss #228f0d87
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
queue cache timeout spike queue #a9afba4f
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
rollback expired quota latency spike shard #c3a95f7f
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
timeout latency backlog pool lag #049d4f04
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
pool connection token throttled lag quota cache expired #19a72a40
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
cache miss token heartbeat quota rollback deadlock downstream expired #6e1ff08d
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
timeout deadlock token token spike expired backlog quota #aef96171
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
expired evicted replica retry #3b732451
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
queue connection connection rollback shard #57cf6d3d
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
retry upstream shard exhausted shard #80777ab5
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
replica latency miss pool expired shard handshake #4b833bb2
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
62
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
74
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
55
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
19
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
50
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
25
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
12
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
74
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
12
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
15
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
12
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
27
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
