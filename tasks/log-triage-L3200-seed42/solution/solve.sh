#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
cache reset quota replica queue timeout #d41252f2
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
expired shard expired spike downstream queue #02e9bee7
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
connection throttled rollback reset timeout lag miss exhausted #20dee831
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
handshake timeout latency upstream #a80ec352
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
refused heartbeat heartbeat latency throttled #ddca7736
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
cache evicted latency evicted reset evicted refused connection queue #28280b23
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
connection evicted heartbeat refused lag queue exhausted #a76f8e9f
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
replica replica queue upstream evicted #117cb296
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
retry expired deadlock retry #059ff341
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
connection reset replica spike retry miss heartbeat backlog backlog #01395684
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
connection shard pool deadlock cache exhausted #083fa8cc
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
throttled replica quota downstream expired #1f212363
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
148
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
99
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
128
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
151
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
142
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
303
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
289
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
335
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
124
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
151
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
303
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
289
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
