#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
replica upstream spike exhausted replica backlog #09266502
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
downstream deadlock refused exhausted lag throttled miss downstream #9c1956ef
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
deadlock pool rollback reset evicted timeout #d3ffc7ec
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
queue replica timeout shard rollback #b5d720fd
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
downstream exhausted refused quota lag #8506bcfd
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
exhausted spike rollback shard queue #ac0b5253
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
handshake refused backlog queue refused #0b7d535c
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
handshake handshake lag shard throttled #6b5a75e4
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
upstream cache shard spike miss replica upstream exhausted lag #196261a2
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
throttled pool pool upstream timeout retry latency #2dabd694
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
backlog deadlock rollback heartbeat cache expired upstream #19ecba52
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
lag exhausted replica upstream cache throttled refused quota #282dd614
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
79
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
50
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
156
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
168
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
50
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
168
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
62
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
156
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
156
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
48
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
29
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
168
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
