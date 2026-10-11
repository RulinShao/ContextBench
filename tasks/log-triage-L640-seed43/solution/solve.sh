#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
expired latency timeout reset cache evicted backlog #9f82f97c
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
timeout lag connection lag shard upstream throttled #32fb939d
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
handshake queue cache timeout #8ce07a64
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
expired exhausted pool deadlock queue retry evicted backlog #060a0dc1
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
reset rollback upstream expired refused #d2fef065
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
spike lag downstream token deadlock refused #3435ef45
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
pool backlog spike downstream latency latency quota heartbeat #69247224
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
quota deadlock quota timeout retry timeout refused latency heartbeat #d998ca8c
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
handshake exhausted retry shard connection upstream evicted exhausted #dd0ee142
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
reset cache lag expired quota timeout timeout timeout connection #76402e4b
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
downstream evicted throttled handshake lag #7dbeb23c
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
replica throttled downstream reset spike #7d504750
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
24
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
34
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
61
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
15
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
21
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
13
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
24
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
67
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
12
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
21
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
34
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
