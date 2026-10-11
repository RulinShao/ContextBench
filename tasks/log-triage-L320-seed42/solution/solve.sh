#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
rollback replica reset throttled lag quota #01190d1d
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
throttled throttled shard backlog #f2844e8b
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
reset connection replica lag queue reset rollback timeout rollback #a35a2799
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
cache downstream connection retry queue rollback heartbeat connection upstream #b0a1b6ee
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
throttled token backlog replica #74e969aa
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
queue deadlock deadlock lag refused spike #972e9a8d
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
expired refused quota cache expired miss rollback spike #beb0d887
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
spike queue handshake handshake cache #3051d034
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
queue latency retry expired rollback #1c53415e
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
downstream evicted downstream timeout token replica #258f4f49
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
lag evicted refused lag #41273996
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
shard reset queue refused pool expired miss expired refused #db958e1f
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
8
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
33
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
31
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
14
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
27
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
33
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
9
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
4
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
