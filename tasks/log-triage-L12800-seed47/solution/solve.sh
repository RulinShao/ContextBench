#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
queue exhausted handshake heartbeat heartbeat #0633e2df
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
miss throttled rollback downstream pool connection heartbeat shard #058c961c
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
shard connection latency refused miss #f4b3ef3e
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
heartbeat upstream queue token lag token #ba1dfe03
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
latency shard cache deadlock deadlock timeout heartbeat cache #a23dad67
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
expired latency quota lag retry downstream rollback retry #c1cbc1ab
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
cache spike spike timeout quota evicted retry #98f91195
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
retry backlog timeout upstream miss quota exhausted throttled #26fcfb6d
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
rollback expired latency cache queue #ca70d62e
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
miss backlog throttled queue #230dbede
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
throttled downstream shard expired #aa34a21b
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
retry retry connection handshake cache refused #a3af4f7a
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
1230
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
511
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
511
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
540
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
317
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
556
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
1323
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
540
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
511
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
540
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
1320
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
1259
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
