#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
reset shard throttled exhausted queue evicted queue #ae828ffc
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
deadlock expired refused retry backlog cache downstream heartbeat #52b8c1d2
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
connection quota refused retry quota lag #e7fb3e8a
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
backlog rollback deadlock exhausted shard upstream #c9687b55
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
queue rollback cache retry #19e134db
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
pool quota throttled latency replica queue quota handshake handshake #f12dc28e
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
downstream exhausted handshake heartbeat rollback lag downstream #7ee3497b
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
downstream evicted upstream timeout retry upstream reset quota upstream #9130f2f8
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
handshake heartbeat evicted cache pool deadlock throttled connection upstream #23a60c48
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
evicted downstream rollback shard pool #e26e7db0
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
shard token miss connection #c665c823
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
handshake replica lag latency quota shard rollback throttled #8bd49649
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
56
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
56
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
69
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
34
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
74
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
156
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
156
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
34
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
189
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
61
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
36
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
71
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
