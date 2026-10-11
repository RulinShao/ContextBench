#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
reset refused replica downstream exhausted #28391441
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
pool expired throttled reset cache deadlock #622b2d9f
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
retry token handshake refused quota #fb1c9bd6
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
reset quota queue latency #9b6a5dbb
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
reset lag backlog timeout timeout #069373cf
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
backlog heartbeat timeout pool retry replica #732aac49
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
replica cache pool expired deadlock expired replica #33fb0283
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
refused shard queue refused refused rollback #7e3f76e2
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
replica pool downstream latency #09d15b8d
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
spike throttled shard lag #00586d23
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
queue downstream expired exhausted #7e0a54f6
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
upstream rollback pool cache #2566b56e
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
46
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
174
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
33
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
32
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
66
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
40
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
148
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
145
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
32
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
32
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
145
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
182
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
