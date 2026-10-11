#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
reset pool queue connection downstream expired #f2820b3f
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
throttled pool latency latency #4ea111f7
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
spike evicted miss replica replica #e0885714
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
evicted retry connection reset quota exhausted expired downstream handshake #cde27c72
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
evicted pool throttled evicted #ca8e381b
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
lag shard evicted evicted downstream #5ec67e56
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
lag upstream cache timeout connection pool evicted #bd154731
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
shard downstream quota shard #1f77030e
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
connection retry throttled shard latency rollback #9819863b
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
expired quota rollback quota #f7b23bc4
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
cache timeout miss exhausted queue #c94f9e77
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
downstream upstream spike timeout exhausted spike spike timeout expired #53ae8793
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
143
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
76
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
325
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
130
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
130
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
130
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
312
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
146
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
136
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
120
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
146
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
148
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
