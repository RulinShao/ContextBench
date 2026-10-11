#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
handshake lag connection exhausted token evicted reset #939a7710
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
heartbeat replica heartbeat rollback #b59416c0
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
queue heartbeat spike replica #f90cb6ab
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
backlog upstream handshake rollback latency replica spike #49bc53ba
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
deadlock spike token timeout timeout #5d86781d
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
evicted token retry quota retry retry retry #bd7af683
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
reset pool miss lag shard latency miss token #c7f016f6
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
queue upstream heartbeat retry throttled handshake quota downstream #c552759c
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
upstream miss connection connection pool #4f5dd497
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
quota rollback timeout refused shard token backlog deadlock upstream #ed6f3689
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
refused replica retry downstream timeout reset quota upstream queue #75bf0100
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
token spike expired connection connection #ef62235f
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
68
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
39
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
28
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
19
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
28
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
39
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
27
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
21
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
20
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
14
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
