#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
backlog evicted pool evicted downstream quota throttled expired evicted #ac7ff9b0
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
evicted refused deadlock handshake heartbeat queue shard backlog #c8d4843e
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
spike miss spike exhausted refused upstream quota upstream timeout #7191dd63
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
refused token miss latency queue downstream connection #3a20502a
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
refused retry backlog handshake heartbeat evicted spike #a8b63596
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
backlog latency pool retry token replica upstream exhausted pool #b1137651
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
expired miss throttled spike #149bd984
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
pool cache miss latency timeout queue lag upstream quota #3c53a631
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
evicted evicted connection token #da2954cf
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
spike pool handshake reset connection exhausted miss evicted #03120254
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
lag deadlock exhausted queue refused pool timeout exhausted #9c85a91e
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
reset backlog replica token downstream quota reset handshake #24d8ce06
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
2
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
7
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
4
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
6
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
11
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
2
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
14
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
8
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
3
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
6
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
