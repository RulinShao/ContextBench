#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
miss deadlock reset spike queue shard deadlock downstream replica #70909554
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
shard lag cache connection token rollback reset heartbeat #f77e5aff
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
refused backlog exhausted handshake downstream replica #96da211c
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
connection timeout downstream backlog #ba05dc15
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
cache cache cache spike spike cache #6bf49ee5
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
exhausted backlog upstream quota downstream #59fe9b02
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
cache token queue latency exhausted quota #a8449c1e
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
refused throttled reset reset heartbeat #6289664a
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
heartbeat refused heartbeat backlog #73cdc49e
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
quota miss cache lag #52bf8fd9
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
lag latency miss shard rollback exhausted upstream handshake replica #9cf79aaf
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
pool replica connection backlog quota evicted pool latency throttled #2b98d89d
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
81
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
299
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
311
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
80
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
311
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
81
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
78
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
140
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
299
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
135
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
135
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
149
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
