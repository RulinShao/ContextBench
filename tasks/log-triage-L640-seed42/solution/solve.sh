#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
retry deadlock expired reset throttled #fd606537
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
spike shard downstream expired throttled upstream quota timeout expired #eb8b7e90
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
miss cache downstream rollback retry retry expired #a80dabf2
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
retry downstream replica lag replica throttled pool deadlock #4685d9c1
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
deadlock token refused exhausted rollback queue throttled evicted backlog #839515f8
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
backlog shard downstream refused #d64f74f0
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
token evicted lag shard latency deadlock #c156beb0
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
shard shard expired expired lag refused handshake connection deadlock #796b5a62
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
expired deadlock shard heartbeat cache #a14b3398
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
connection downstream timeout exhausted pool #aac093a7
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
exhausted deadlock retry timeout latency #3b7f7523
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
retry backlog retry spike #4414d3e7
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
52
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
14
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
68
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
28
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
28
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
71
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
22
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
28
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
10
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
14
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
