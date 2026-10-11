#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
retry upstream upstream reset upstream timeout reset #c75aad42
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
reset cache handshake refused #c8010387
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
expired exhausted evicted refused reset connection reset latency #8f22532b
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
latency spike heartbeat token rollback throttled throttled throttled handshake #b8317c0d
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
downstream timeout reset evicted downstream replica handshake handshake queue #647410b6
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
evicted evicted replica pool pool pool retry spike #a8fe25f7
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
spike miss miss exhausted latency #dc8585d5
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
pool timeout expired timeout shard handshake #178b0603
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
rollback rollback reset backlog retry handshake token expired latency #bda71cee
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
replica throttled retry backlog replica shard miss #6835c872
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
token lag rollback refused lag expired #00d54614
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
reset reset expired queue queue heartbeat retry deadlock queue #cfb94011
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
142
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
92
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
344
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
344
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
344
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
83
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
83
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
323
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
78
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
75
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
130
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
92
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
