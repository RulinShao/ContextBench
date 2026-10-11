#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
connection reset queue quota cache rollback connection pool #01f2d7b2
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
timeout queue lag latency lag latency backlog miss exhausted #7b014bc1
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
backlog refused expired lag downstream lag token #ab7ee48a
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
evicted exhausted token cache lag #88b4e90b
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
spike queue throttled timeout timeout queue throttled connection #69dde670
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
rollback upstream handshake expired lag rollback connection replica downstream #42f64e20
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
miss pool handshake rollback connection expired shard #a8e6d666
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
heartbeat retry token quota spike queue reset #19a38cb7
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
heartbeat expired exhausted token retry heartbeat #9446cfd7
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
throttled connection refused deadlock timeout latency timeout heartbeat expired #4cd458fb
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
shard evicted exhausted cache refused timeout #81a5f8bc
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
timeout evicted upstream lag connection expired timeout token upstream #3a49eb1f
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
523
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
1280
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
345
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
326
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
311
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
311
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
323
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
332
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
326
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
1193
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
332
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
533
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
