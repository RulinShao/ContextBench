#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
quota handshake cache exhausted pool exhausted handshake reset #316caabd
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
pool quota pool heartbeat lag token reset #712fd29d
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
timeout token upstream quota timeout #eca9c7be
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
evicted connection upstream throttled timeout #4beb421e
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
lag expired queue refused queue quota queue rollback #94ec9b20
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
expired exhausted expired throttled quota quota throttled retry #e4766267
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
timeout upstream backlog upstream handshake quota downstream spike #4b977f71
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
quota expired retry lag #d8fe3038
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
cache upstream rollback handshake cache deadlock throttled retry #acf5322f
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
reset refused pool miss rollback exhausted deadlock #5134b8df
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
exhausted replica upstream cache exhausted replica miss retry rollback #c3f405e8
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
handshake token connection spike #6f5b7127
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
2
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
2
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
3
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
21
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
21
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
3
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
