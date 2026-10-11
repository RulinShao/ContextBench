#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
timeout shard connection cache handshake expired miss #6342dee8
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
lag shard heartbeat connection deadlock #b5f368ac
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
connection expired handshake expired throttled throttled expired #0163a385
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
handshake reset backlog heartbeat queue expired refused token #78e1a1f2
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
refused quota cache exhausted latency spike latency #0992291a
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
throttled retry expired token spike queue pool #af49bb07
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
heartbeat connection expired throttled #8f391dfa
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
heartbeat token timeout spike refused replica evicted backlog replica #6488e0a3
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
quota handshake replica backlog downstream exhausted #ce547288
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
rollback queue rollback lag pool backlog evicted quota upstream #6c10385e
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
expired refused cache downstream connection evicted exhausted quota connection #d8258b8d
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
queue queue downstream queue queue upstream shard shard throttled #81f85b60
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
19
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
8
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
15
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
3
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
11
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
