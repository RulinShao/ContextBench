#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
cache heartbeat quota shard connection shard downstream deadlock deadlock #d1244d09
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
quota latency heartbeat miss #3a211fcd
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
throttled lag evicted throttled pool downstream token retry #a1074a63
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
queue miss cache queue #3d354d62
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
heartbeat lag throttled queue retry connection reset #dca7d3b0
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
upstream token quota shard throttled cache retry quota #2ea55f38
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
downstream connection heartbeat token evicted heartbeat connection timeout #3d8f4ca1
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
upstream lag replica reset pool expired deadlock expired #ec958722
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
evicted rollback exhausted retry shard token downstream throttled #f2946359
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
latency throttled connection reset retry upstream deadlock token refused #a55e2a78
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
handshake timeout latency timeout shard #c75bd151
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
backlog queue queue shard token cache connection retry #d0812ba5
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
28
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
20
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
11
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
24
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
