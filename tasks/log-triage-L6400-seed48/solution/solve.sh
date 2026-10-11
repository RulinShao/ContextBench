#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
refused miss quota timeout pool miss connection expired #25131dd5
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
exhausted refused rollback shard retry #b205b018
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
downstream throttled deadlock cache heartbeat deadlock heartbeat #cde84956
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
handshake miss handshake queue miss pool expired backlog handshake #126e6061
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
queue expired spike rollback #09af1f53
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
shard replica retry upstream connection miss retry exhausted #eeaf406c
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
handshake backlog exhausted quota evicted expired exhausted handshake #40aa52f2
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
backlog throttled lag queue rollback #07aee5c6
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
throttled latency token cache deadlock retry upstream #b09007b7
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
upstream timeout evicted retry expired #3a37b4bb
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
upstream pool latency handshake #601b77a4
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
deadlock queue quota rollback miss heartbeat #ddbb1012
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
265
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
150
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
147
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
635
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
633
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
155
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
674
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
648
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
295
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
626
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
265
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
239
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
