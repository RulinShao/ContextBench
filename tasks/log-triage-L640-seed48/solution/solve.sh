#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
shard handshake handshake replica pool handshake queue #a1cae610
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
lag quota downstream token miss upstream handshake connection #c118ec0d
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
connection refused quota upstream #88becba0
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
reset handshake miss backlog #fcf25ba0
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
miss handshake replica quota retry #63de1356
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
cache token throttled downstream #c1a77b97
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
exhausted shard reset backlog downstream rollback replica connection quota #c1d7cb46
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
timeout heartbeat downstream evicted replica reset cache reset #2118c75e
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
lag connection heartbeat throttled upstream spike replica rollback throttled #8e703608
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
replica token replica upstream #1390d945
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
pool token throttled replica lag rollback exhausted quota lag #464099a8
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
deadlock rollback connection replica exhausted shard backlog reset quota #b7f0e697
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
18
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
15
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
67
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
11
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
67
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
21
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
67
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
11
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
21
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
71
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
19
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
