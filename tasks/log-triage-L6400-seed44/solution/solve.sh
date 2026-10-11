#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
reset pool backlog replica evicted quota reset #febfda84
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
downstream shard rollback throttled replica reset handshake heartbeat throttled #1a9d532a
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
lag throttled timeout timeout #727abd0f
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
downstream handshake connection expired #8819bf49
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
deadlock throttled refused downstream deadlock token quota #4951def5
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
miss replica exhausted spike token latency throttled #2ac24c20
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
refused upstream deadlock backlog miss heartbeat upstream #ebf47ed4
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
upstream retry spike lag shard expired rollback heartbeat connection #023f39f8
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
downstream lag retry backlog refused evicted replica upstream pool #dba16bce
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
evicted backlog shard timeout reset upstream handshake #ccc41684
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
exhausted upstream latency deadlock retry lag rollback #11798209
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
cache connection deadlock connection #9ab98253
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
654
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
666
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
263
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
266
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
598
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
180
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
251
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
581
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
170
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
263
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
263
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
251
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
