#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
latency shard latency downstream expired downstream throttled #b548581b
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
miss replica refused token throttled exhausted deadlock upstream reset #7f41f21b
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
pool lag deadlock rollback heartbeat #03307afa
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
replica replica cache lag throttled token upstream evicted #4b5cf610
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
quota latency downstream expired #49420108
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
downstream pool deadlock evicted #a18c7f27
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
exhausted reset retry latency cache refused latency downstream reset #d350c366
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
reset shard refused spike lag exhausted miss spike #6b9d6eac
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
evicted reset evicted rollback token evicted backlog latency token #0b886b81
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
exhausted reset upstream downstream reset deadlock shard #28047a30
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
throttled retry cache lag backlog reset handshake #e5f8ce21
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
pool replica deadlock expired retry connection exhausted expired #48d34ea4
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
687
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
162
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
282
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
647
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
604
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
262
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
158
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
158
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
180
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
180
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
158
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
660
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
