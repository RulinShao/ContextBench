#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
heartbeat rollback handshake pool connection queue heartbeat #cf9c20c4
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
shard backlog heartbeat queue token miss #bbc9d371
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
retry queue exhausted refused #e11d5762
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
connection timeout evicted shard connection quota latency #b61c7802
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
latency handshake shard expired replica deadlock timeout evicted shard #9309bca3
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
retry reset quota timeout timeout heartbeat rollback downstream #c8966ff5
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
queue timeout throttled retry throttled quota reset token shard #5b4c41fc
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
evicted queue refused cache handshake connection #99a9f9e1
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
lag backlog upstream latency retry quota replica shard latency #36761e40
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
reset retry cache miss miss spike evicted downstream throttled #3c5fcecc
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
queue heartbeat heartbeat shard token heartbeat cache pool #191bf390
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
throttled evicted handshake replica #9366937b
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
233
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
168
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
169
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
168
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
169
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
634
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
168
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
233
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
181
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
181
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
691
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
168
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
