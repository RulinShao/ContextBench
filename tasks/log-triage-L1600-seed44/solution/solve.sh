#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
evicted miss cache latency replica deadlock expired exhausted #91b5777b
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
reset timeout pool throttled upstream replica #7ce0c1cb
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
reset refused spike exhausted retry refused reset #e5625e12
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
refused downstream evicted retry timeout token pool #865c6d47
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
lag upstream heartbeat rollback evicted latency timeout shard backlog #5fa8b4bf
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
rollback latency retry retry #dc8f8f3c
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
throttled throttled backlog backlog queue upstream evicted exhausted token #8bc21ebf
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
backlog cache timeout lag retry upstream shard quota backlog #47c47bc0
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
handshake lag shard quota latency spike shard #f72b25a3
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
upstream deadlock handshake expired #75de3a27
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
evicted upstream rollback throttled shard upstream spike throttled upstream #9a5a43fa
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
expired downstream handshake latency replica throttled connection rollback throttled #4ba65f22
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
49
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
41
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
42
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
150
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
168
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
67
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
192
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
51
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
30
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
67
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
150
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
168
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
