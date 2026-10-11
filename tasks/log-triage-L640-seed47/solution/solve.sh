#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
lag rollback refused refused spike #f4b381d2
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
refused retry spike expired deadlock #58afd38f
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
miss backlog exhausted upstream #ab9b859f
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
heartbeat miss throttled refused downstream timeout #95ee8b35
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
pool refused downstream throttled deadlock queue rollback exhausted evicted #a0db4431
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
replica quota miss exhausted replica expired evicted pool #9c82252d
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
expired exhausted expired throttled quota quota throttled retry #e4766267
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
connection exhausted upstream deadlock connection downstream quota timeout #8136a753
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
queue timeout latency spike handshake exhausted latency queue #6500af01
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
lag evicted pool refused lag quota #751f541b
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
upstream downstream retry handshake expired downstream #5afe8886
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
shard queue upstream evicted handshake shard downstream timeout #263eb733
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
56
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
21
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
62
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
59
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
29
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
29
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
33
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
29
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
56
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
20
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
62
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
20
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
