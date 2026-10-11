#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
connection token handshake heartbeat #f6e32c2c
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
miss timeout refused heartbeat miss #df2a976e
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
backlog queue queue handshake #1903ee23
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
latency evicted heartbeat miss expired refused throttled retry retry #20f99424
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
timeout replica quota token #a002e8e0
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
downstream cache quota expired retry deadlock lag #be9bc02c
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
backlog deadlock exhausted cache #8efb5db3
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
retry handshake throttled quota #7831bdf8
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
token deadlock lag throttled replica #afa8b012
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
timeout heartbeat lag expired upstream pool replica #f5c7a754
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
replica refused timeout lag heartbeat handshake handshake quota #6b09c620
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
quota deadlock quota timeout retry timeout refused latency heartbeat #d998ca8c
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
3
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
3
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
8
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
3
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
16
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
8
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
5
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
3
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
6
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
