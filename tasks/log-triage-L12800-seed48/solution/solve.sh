#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
downstream pool expired backlog downstream quota upstream spike deadlock #ab2edc47
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
heartbeat shard throttled refused lag pool lag cache pool #81be90ce
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
upstream replica connection spike miss #3bc1f4a6
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
deadlock handshake backlog cache #794e89b6
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
downstream queue downstream handshake #3fdccb47
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
queue pool spike throttled #22e57b97
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
timeout shard evicted exhausted #ef66ce3e
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
latency refused miss rollback lag connection reset pool #1fd7db75
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
connection refused latency miss backlog rollback evicted pool #a0b5f860
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
pool latency rollback queue handshake #a6a59a5a
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
replica replica spike deadlock #60c14ebb
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
spike queue queue connection rollback downstream backlog latency #8aca7cd3
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
305
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
566
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
1263
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
326
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
518
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
326
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
546
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
513
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
305
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
298
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
309
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
326
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
