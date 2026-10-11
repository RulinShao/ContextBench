#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
heartbeat heartbeat upstream heartbeat #65bb187d
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
reset retry cache connection reset downstream exhausted #8e0b9b03
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
reset throttled shard handshake deadlock #12a3775d
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
quota replica latency evicted backlog downstream quota #3c39a75d
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
retry backlog retry timeout #945835b1
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
expired deadlock heartbeat exhausted #566b7651
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
expired queue replica throttled retry #8f666835
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
heartbeat expired replica spike latency refused shard pool #a2ff2f77
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
lag refused lag replica upstream downstream #69f950aa
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
replica replica evicted shard latency downstream evicted upstream miss #1079ecf5
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
shard evicted shard cache cache backlog refused #8c5f4c3d
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
evicted retry deadlock deadlock retry #58445b22
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
18
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
27
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
24
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
18
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
18
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
64
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
59
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
64
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
14
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
20
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
64
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
59
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
