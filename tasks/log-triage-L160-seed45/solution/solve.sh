#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
downstream heartbeat cache evicted pool refused quota #6dce890c
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
retry throttled quota quota shard retry heartbeat #c1ab1cc3
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
lag handshake token cache latency evicted lag rollback #e93c460d
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
refused expired cache deadlock #1871f0f3
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
quota throttled refused token refused #05304a29
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
throttled lag evicted throttled pool downstream token retry #a1074a63
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
spike quota exhausted spike miss #fca6ba1b
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
spike cache exhausted reset backlog #0f94b328
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
miss evicted timeout queue miss throttled #03bcd6c0
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
reset cache latency evicted exhausted expired token #de04d47f
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
reset connection rollback cache miss #ddc44eb5
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
upstream rollback reset timeout queue downstream rollback #45e8b7cc
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
11
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
15
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
8
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
8
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
4
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
