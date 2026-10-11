#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
timeout rollback throttled connection heartbeat backlog #3123820e
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
miss queue queue token #de4a765f
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
miss evicted spike timeout deadlock latency #08f1845b
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
refused evicted spike quota evicted #3f5891a0
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
reset downstream downstream exhausted #48b333ea
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
timeout spike heartbeat downstream shard upstream #5e29d5e8
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
miss rollback rollback retry connection #57522e2d
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
heartbeat heartbeat upstream expired spike retry refused spike quota #3f4a6ea9
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
refused evicted throttled reset evicted #0e254cf0
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
reset cache miss retry evicted shard spike spike #d4e6c57d
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
timeout heartbeat queue connection retry heartbeat lag #395f6937
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
connection latency downstream deadlock handshake replica #8ef246c0
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
675
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
250
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
160
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
250
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
250
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
675
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
160
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
160
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
309
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
164
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
627
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
675
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
