#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
deadlock queue miss latency quota heartbeat lag backlog cache #f78c1b55
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
handshake retry latency shard handshake replica queue upstream token #e512de64
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
timeout heartbeat miss token exhausted token timeout retry #03191365
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
expired queue quota connection miss exhausted token downstream handshake #13e90d70
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
refused pool latency retry evicted downstream heartbeat retry backlog #297fb7bb
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
miss handshake replica quota retry #63de1356
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
refused latency miss token deadlock cache quota latency #b11d72bb
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
upstream heartbeat spike exhausted cache #54f4f7b2
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
quota shard expired retry heartbeat rollback exhausted upstream #dcdf4850
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
queue expired heartbeat rollback connection queue retry heartbeat heartbeat #d7e8fafc
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
shard miss refused pool retry heartbeat #1bc99553
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
downstream latency upstream backlog replica connection downstream downstream quota #98ce05a8
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
9
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
12
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
27
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
9
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
24
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
12
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
9
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
12
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
41
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
41
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
9
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
