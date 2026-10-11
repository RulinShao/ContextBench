#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
quota miss heartbeat reset reset #5712820c
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
cache lag expired shard pool cache heartbeat #dc443b78
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
connection token connection cache pool connection #9dc0b3e9
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
upstream spike spike exhausted downstream reset replica #2174e8e5
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
timeout retry expired timeout downstream miss quota #5562f663
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
deadlock spike backlog downstream cache #3dcfc802
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
latency pool quota heartbeat quota throttled connection expired #38882d84
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
backlog reset heartbeat reset deadlock #3aff5fe7
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
queue deadlock latency handshake miss deadlock heartbeat #1c9e3780
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
lag reset backlog rollback token refused upstream #9ad31c86
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
exhausted timeout queue connection handshake replica connection #f6f453a5
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
refused replica heartbeat upstream pool #68d7ef48
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
319
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
376
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
328
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
309
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
302
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
532
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
1246
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
523
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
534
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
316
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
316
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
551
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
