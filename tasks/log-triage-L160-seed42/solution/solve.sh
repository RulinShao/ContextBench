#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
connection queue queue deadlock upstream #2e76df6d
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
backlog queue retry cache reset rollback shard pool #59deb54a
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
cache refused refused lag queue rollback queue #9da892eb
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
cache upstream pool evicted heartbeat cache heartbeat #cd652779
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
token retry heartbeat queue timeout #32b35757
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
refused backlog refused reset backlog timeout #4f15d6f0
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
spike queue handshake handshake cache #3051d034
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
miss evicted queue handshake #c8215f4f
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
refused upstream miss replica latency token quota #50f2162d
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
spike evicted reset replica token shard exhausted #3160ff10
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
latency connection handshake exhausted token deadlock shard heartbeat throttled #15bebcc4
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
timeout downstream expired handshake #e8fcb278
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
2
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
3
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
2
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
9
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
2
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
4
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
