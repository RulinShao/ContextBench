#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
downstream replica deadlock downstream queue latency spike #de51ec4d
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
pool exhausted miss reset pool exhausted rollback #e56f9569
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
pool pool timeout exhausted throttled reset replica #c2c70e37
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
upstream replica refused rollback #b9de8093
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
evicted rollback evicted queue shard retry #1eefb03d
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
handshake downstream refused queue upstream exhausted heartbeat latency shard #35743f4e
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
shard exhausted timeout timeout backlog rollback #672b679d
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
throttled connection spike retry quota retry queue upstream upstream #113a81e8
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
miss rollback token lag latency #5ee30d07
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
cache refused pool queue throttled #6b078aea
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
exhausted throttled throttled timeout rollback #f58082e7
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
exhausted spike downstream miss retry pool timeout throttled throttled #1faafd69
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
287
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
1291
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
1327
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
568
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
1291
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
1286
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
1234
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
1286
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
511
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
1291
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
476
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
1286
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
