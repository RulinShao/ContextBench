#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
token reset heartbeat connection deadlock cache rollback #42325b3f
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
backlog retry retry handshake heartbeat replica heartbeat latency cache #854a3cfc
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
backlog connection lag handshake quota latency exhausted #6125503a
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
shard deadlock timeout reset upstream timeout retry shard #ae1fcb49
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
spike throttled exhausted queue upstream handshake miss #a7e3aaae
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
pool downstream upstream token expired throttled upstream connection #fb847017
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
shard retry cache deadlock shard #aa622ccf
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
miss quota cache timeout downstream #52a681cd
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
quota latency queue retry latency retry lag pool downstream #9023818e
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
heartbeat cache latency throttled upstream backlog connection #533cbb5f
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
heartbeat shard heartbeat shard backlog shard upstream spike #fb374c73
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
shard backlog spike refused pool #5a808da0
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
147
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
41
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
44
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
76
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
162
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
50
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
41
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
148
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
76
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
63
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
147
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
76
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
