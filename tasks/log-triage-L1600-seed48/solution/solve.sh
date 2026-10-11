#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
exhausted miss throttled replica queue connection deadlock rollback #3f3f9936
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
shard spike timeout timeout backlog replica #092073ce
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
timeout handshake evicted token reset spike #b4d5f3d1
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
refused evicted quota deadlock #6e7045cb
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
expired exhausted expired reset timeout backlog #b6e52d58
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
upstream latency token spike expired backlog #73ff8dc0
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
pool replica retry latency queue evicted timeout #fee0bf58
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
retry token spike expired connection miss #ec453c39
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
shard downstream quota shard #1f77030e
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
backlog retry reset lag #4ed828fa
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
exhausted spike miss token exhausted downstream #57a34c61
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
heartbeat expired cache queue timeout #271731be
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
42
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
37
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
42
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
172
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
65
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
174
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
154
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
37
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
168
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
172
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
71
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
42
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
