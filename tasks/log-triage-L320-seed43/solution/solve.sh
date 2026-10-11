#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
upstream latency heartbeat reset deadlock latency lag heartbeat deadlock #a4b0c801
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
pool evicted retry downstream timeout backlog evicted #11bf8c2e
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
handshake pool cache handshake upstream replica #f683cf4a
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
throttled latency replica backlog #326fe8fa
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
lag spike reset retry #184255ee
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
queue cache deadlock throttled replica #ff0b44a5
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
pool throttled retry miss refused spike evicted #96aa47c5
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
latency refused refused shard retry retry upstream throttled spike #dcf9700c
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
exhausted evicted exhausted reset retry token spike handshake #abb4e951
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
backlog timeout lag latency handshake backlog token reset evicted #52b969e3
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
retry backlog reset retry refused #db3a9121
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
evicted cache retry lag reset #9027ddb5
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
12
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
10
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
32
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
17
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
32
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
12
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
12
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
38
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
10
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
14
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
