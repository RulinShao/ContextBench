#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
queue refused evicted rollback #5ab7417c
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
token upstream shard upstream deadlock latency handshake miss #1735c155
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
spike latency reset upstream evicted #eb609d72
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
deadlock deadlock cache rollback pool #36b7f602
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
exhausted heartbeat backlog miss shard rollback replica miss expired #1b36bfed
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
replica connection reset exhausted cache backlog rollback connection #f2ef403e
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
upstream latency cache miss queue handshake handshake #50a15aeb
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
quota retry expired latency throttled cache reset heartbeat #4440ef17
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
queue connection cache expired evicted #fa68331d
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
evicted refused spike downstream token pool shard queue #fb658989
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
retry expired backlog rollback handshake miss exhausted #90ff1759
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
latency quota shard cache rollback cache exhausted #ed4d072f
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
9
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
3
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
21
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
6
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
