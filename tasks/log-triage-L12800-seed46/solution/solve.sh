#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
handshake timeout pool miss lag connection connection #9510d026
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
retry latency token replica heartbeat pool #85e2b34b
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
deadlock upstream exhausted expired deadlock downstream retry spike #0205aaa6
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
lag spike handshake heartbeat quota #0c5b1436
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
deadlock queue pool cache replica #d9fcb49a
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
retry pool evicted spike #675668f7
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
token retry expired expired expired lag handshake token upstream #ac13ab13
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
replica timeout cache queue spike cache pool connection #f6a1bdb9
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
exhausted expired cache retry downstream reset #bddfbdf0
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
expired exhausted backlog rollback expired deadlock connection #07751885
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
throttled deadlock reset expired #f74b6cb2
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
timeout spike reset connection downstream #135acdc6
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
1280
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
1197
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
1269
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
1315
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
337
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
311
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
1269
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
1217
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
548
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
1302
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
534
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
527
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
