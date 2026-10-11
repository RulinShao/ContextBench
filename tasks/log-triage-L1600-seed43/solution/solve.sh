#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
exhausted shard backlog quota rollback refused lag #cc5fc81e
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
downstream miss throttled miss #f2641e5a
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
lag retry backlog rollback retry connection reset shard #0cadeb9f
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
queue heartbeat heartbeat shard token heartbeat cache pool #191bf390
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
latency reset quota backlog downstream miss backlog #b0276155
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
lag exhausted reset handshake exhausted heartbeat retry evicted heartbeat #e802d411
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
cache heartbeat downstream connection deadlock heartbeat #06c33576
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
reset token heartbeat cache reset throttled #78f09371
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
evicted latency pool downstream handshake quota reset #972e105a
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
miss quota reset retry deadlock miss cache #ba68eb3d
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
shard rollback retry retry #f527a572
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
reset rollback evicted latency exhausted backlog #8eb5b345
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
63
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
184
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
62
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
184
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
41
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
38
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
45
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
35
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
40
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
55
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
61
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
35
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
