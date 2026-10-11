#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
queue replica handshake replica quota upstream shard connection #b671e810
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
downstream shard upstream cache throttled reset expired latency #ea67ac1b
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
miss lag spike quota replica miss deadlock #11c4f7f9
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
shard retry latency replica pool token #da6e9dcb
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
latency lag queue pool #bffe46ba
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
shard downstream deadlock spike #ac4e1e44
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
deadlock quota replica upstream #b035d145
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
exhausted evicted expired evicted throttled retry #0ae664f7
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
miss rollback lag expired #4068385b
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
token handshake refused refused #5142eb29
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
lag backlog retry timeout queue #860ed63f
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
cache refused token downstream quota #eb7fe24b
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
121
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
338
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
300
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
300
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
327
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
327
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
122
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
327
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
127
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
121
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
300
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
300
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
