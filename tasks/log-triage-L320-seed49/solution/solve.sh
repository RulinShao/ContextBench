#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
miss timeout token handshake token timeout throttled latency #2f378769
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
timeout lag upstream token token exhausted refused pool #2db2599b
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
timeout downstream downstream miss #1ef1cdcf
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
pool rollback cache refused spike latency cache #20086897
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
timeout replica connection downstream timeout throttled quota replica connection #7129b0f3
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
pool backlog rollback shard latency expired cache expired #b660c891
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
pool downstream refused expired lag #723b2cbd
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
latency rollback timeout pool miss #966cfcf6
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
spike shard handshake expired expired #8b933074
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
throttled pool backlog evicted upstream cache connection #240d8974
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
reset shard downstream deadlock latency exhausted #54e9fb6e
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
handshake spike quota miss rollback heartbeat spike #d3ce42a9
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
8
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
34
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
9
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
32
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
34
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
27
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
12
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
