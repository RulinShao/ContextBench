#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
lag connection connection spike expired pool connection spike latency #63f96b14
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
downstream queue replica upstream reset deadlock upstream #fccf8dd5
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
token rollback latency latency deadlock expired shard rollback backlog #2fe92ede
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
latency refused quota reset #4bd8d560
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
quota replica connection deadlock lag exhausted #ad5420cf
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
rollback token backlog downstream replica #35ebe81a
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
spike reset timeout rollback token deadlock #29b6370d
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
spike pool reset reset #d1c21343
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
lag timeout replica cache expired quota exhausted connection #2871b129
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
upstream pool shard latency connection token reset downstream latency #47554e97
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
heartbeat lag handshake expired #b0d37b60
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
deadlock token expired downstream expired replica reset #98055cde
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
158
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
37
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
65
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
49
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
67
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
80
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
37
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
158
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
80
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
63
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
46
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
37
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
