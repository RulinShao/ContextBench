#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
handshake latency quota upstream shard miss spike cache #7b3e68da
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
token cache downstream downstream token backlog timeout evicted deadlock #2853d03b
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
handshake handshake backlog heartbeat deadlock connection refused shard throttled #d748eb76
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
miss handshake reset throttled downstream replica connection #674d7a16
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
throttled handshake connection retry cache refused #0193a22d
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
retry miss quota handshake #1f8febca
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
heartbeat quota handshake pool downstream handshake replica throttled #d3b10d29
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
handshake token backlog throttled queue heartbeat connection #c111e5fe
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
token replica throttled retry #738c5534
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
lag downstream handshake rollback timeout upstream timeout downstream spike #6cc72caf
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
timeout latency latency exhausted #1a0dbc0d
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
quota deadlock connection quota connection connection #26c424de
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
1316
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
290
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
541
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
1221
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
1316
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
1316
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
1297
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
508
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
320
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
1316
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
541
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
541
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
