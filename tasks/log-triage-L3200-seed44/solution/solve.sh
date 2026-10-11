#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
spike timeout shard cache pool exhausted queue handshake throttled #5387ea99
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
token expired backlog latency upstream shard #5500ebb4
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
exhausted pool expired handshake deadlock downstream spike #feb98599
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
reset timeout exhausted timeout quota miss upstream token shard #736d2b1c
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
cache pool upstream shard refused lag exhausted #cfb332be
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
reset replica pool retry lag lag downstream spike miss #59ddb3e4
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
handshake expired replica connection connection exhausted spike shard #4acafbdc
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
expired handshake expired quota quota throttled latency #ef163ffe
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
connection downstream handshake replica backlog expired reset throttled connection #99bbeee6
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
cache handshake pool backlog downstream deadlock token latency #9b153663
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
latency evicted refused connection expired #7b1bdd30
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
replica retry exhausted downstream #805c9eee
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
85
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
333
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
82
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
82
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
117
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
344
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
63
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
117
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
63
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
333
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
344
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
142
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
