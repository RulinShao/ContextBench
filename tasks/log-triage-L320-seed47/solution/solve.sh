#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
handshake shard quota downstream refused quota #d4e7601d
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
cache expired cache backlog lag quota #5ee7b84c
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
reset throttled refused token backlog timeout #a161f495
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
connection token backlog reset #1739286b
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
queue miss miss reset reset rollback backlog miss #54c8f9cb
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
miss cache cache spike deadlock miss #b87a291b
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
latency backlog timeout spike upstream replica exhausted pool #e71865d7
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
upstream downstream pool pool lag rollback exhausted reset #8d2514a8
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
heartbeat evicted pool upstream #a3698aba
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
timeout heartbeat rollback cache #0582f8f7
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
spike shard miss expired lag miss backlog heartbeat pool #24df3879
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
rollback queue spike reset replica upstream #193ec5a4
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
8
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
14
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
11
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
14
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
34
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
14
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
8
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
