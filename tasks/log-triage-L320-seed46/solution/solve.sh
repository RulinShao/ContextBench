#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
reset replica expired throttled downstream rollback deadlock #2d1b40a9
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
throttled miss exhausted spike throttled #ca517d99
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
cache throttled rollback timeout throttled rollback queue cache #43edef6c
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
latency quota connection timeout expired heartbeat retry #2105915e
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
throttled heartbeat retry retry #73c2f1db
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
evicted replica miss pool #ecc36815
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
queue deadlock connection heartbeat queue token reset #a6b42b94
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
expired downstream pool shard #2dd61224
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
throttled refused handshake timeout expired deadlock heartbeat #8c5167e5
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
replica rollback connection miss queue spike #1408efa4
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
connection quota refused retry quota lag #e7fb3e8a
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
downstream throttled queue retry refused spike heartbeat evicted #98813647
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
27
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
31
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
10
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
14
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
18
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
34
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
9
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
34
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
35
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
18
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
7
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
