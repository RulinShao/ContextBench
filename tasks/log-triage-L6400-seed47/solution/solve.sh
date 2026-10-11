#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
rollback heartbeat handshake spike expired refused #c170042b
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
cache upstream evicted pool #a2a8e963
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
cache spike spike shard #d6dba948
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
quota connection expired evicted queue expired #a82cd006
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
connection retry lag shard token heartbeat quota #877177f3
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
queue spike expired rollback refused expired rollback reset expired #219c164d
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
shard retry miss expired upstream quota #947bbf06
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
spike throttled reset evicted expired reset reset #02eb0560
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
retry latency heartbeat shard expired downstream #20ebdd76
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
rollback connection pool refused pool #44b07c5e
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
lag pool reset quota backlog quota latency #e06fb891
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
spike latency throttled token throttled heartbeat replica pool #984244c9
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
274
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
139
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
169
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
262
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
167
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
651
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
259
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
159
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
262
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
635
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
635
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
259
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
