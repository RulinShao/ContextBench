#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
upstream reset retry replica expired throttled latency #345c243b
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
lag spike timeout spike token handshake #bc6d0a72
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
shard quota expired timeout retry exhausted cache refused cache #a11425c1
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
expired refused cache downstream connection evicted exhausted quota connection #d8258b8d
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
rollback shard downstream rollback #b2fcf1a0
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
reset refused deadlock deadlock handshake latency #560d7d26
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
cache lag refused refused timeout rollback handshake #db824f90
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
pool downstream deadlock queue deadlock #cbd8bc97
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
quota quota pool refused rollback throttled latency #078b4b6c
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
miss downstream spike rollback downstream evicted throttled spike handshake #6fa6bca9
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
reset rollback pool lag exhausted #199a6cb1
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
upstream miss connection connection pool #4f5dd497
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
38
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
27
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
29
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
9
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
9
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
