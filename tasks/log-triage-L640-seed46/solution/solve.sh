#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
throttled handshake lag spike #173645ef
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
latency retry shard timeout #60819ce7
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
miss handshake retry timeout latency miss heartbeat reset timeout #5839acac
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
latency latency lag connection heartbeat replica handshake retry #cd80229a
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
cache rollback backlog upstream latency lag #67bd6a3a
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
expired expired latency lag quota #13617e62
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
connection handshake upstream evicted pool downstream deadlock #5b487312
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
pool quota token evicted lag handshake throttled heartbeat #820df22b
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
cache heartbeat throttled retry queue exhausted #0617e286
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
reset queue quota retry miss replica reset handshake #65e67825
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
handshake evicted refused latency shard deadlock evicted #add80952
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
heartbeat handshake handshake cache pool #934c945c
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
21
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
28
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
58
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
29
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
57
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
15
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
26
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
67
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
26
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
