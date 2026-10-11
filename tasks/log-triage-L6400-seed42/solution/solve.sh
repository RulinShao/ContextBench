#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
shard downstream shard miss shard miss #e9c7a6a7
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
timeout pool evicted exhausted expired deadlock #4f3235e5
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
throttled evicted downstream evicted shard spike replica #38da7074
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
token shard connection token refused #f7151c09
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
rollback downstream evicted evicted #c14428c5
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
expired evicted handshake throttled latency queue #8171350b
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
rollback quota handshake evicted queue throttled throttled #8067f3ff
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
refused latency backlog throttled downstream reset backlog #a5d5f156
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
downstream rollback spike pool #a417bfc0
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
backlog pool expired handshake #d5a8f8fa
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
queue lag refused latency heartbeat downstream #5bd3ee0d
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
cache rollback spike throttled quota token latency deadlock #a64bb8d2
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
171
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
594
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
160
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
615
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
653
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
171
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
159
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
164
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
162
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
701
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
641
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
701
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
