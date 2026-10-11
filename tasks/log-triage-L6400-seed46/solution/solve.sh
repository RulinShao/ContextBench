#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER qid=0>>>
refused cache exhausted cache evicted #24d751af
<<<ANSWER END>>>
<<<ANSWER qid=1>>>
throttled backlog cache downstream backlog evicted quota cache #b54d4ec3
<<<ANSWER END>>>
<<<ANSWER qid=2>>>
lag upstream cache connection cache evicted #4411954e
<<<ANSWER END>>>
<<<ANSWER qid=3>>>
expired cache evicted handshake #f9ff16a8
<<<ANSWER END>>>
<<<ANSWER qid=4>>>
upstream retry upstream throttled refused #8e0c59dc
<<<ANSWER END>>>
<<<ANSWER qid=5>>>
handshake refused miss handshake deadlock queue #cda16184
<<<ANSWER END>>>
<<<ANSWER qid=6>>>
handshake token evicted backlog evicted handshake #4f64cbb3
<<<ANSWER END>>>
<<<ANSWER qid=7>>>
pool replica queue queue cache downstream #ab7d4173
<<<ANSWER END>>>
<<<ANSWER qid=8>>>
expired refused spike cache quota exhausted #190d7ef7
<<<ANSWER END>>>
<<<ANSWER qid=9>>>
shard timeout spike exhausted connection #cc8eb466
<<<ANSWER END>>>
<<<ANSWER qid=10>>>
expired shard backlog quota reset pool #48c5126a
<<<ANSWER END>>>
<<<ANSWER qid=11>>>
deadlock rollback timeout expired lag #d86cbbe2
<<<ANSWER END>>>
<<<ANSWER qid=12>>>
283
<<<ANSWER END>>>
<<<ANSWER qid=13>>>
662
<<<ANSWER END>>>
<<<ANSWER qid=14>>>
174
<<<ANSWER END>>>
<<<ANSWER qid=15>>>
570
<<<ANSWER END>>>
<<<ANSWER qid=16>>>
190
<<<ANSWER END>>>
<<<ANSWER qid=17>>>
258
<<<ANSWER END>>>
<<<ANSWER qid=18>>>
153
<<<ANSWER END>>>
<<<ANSWER qid=19>>>
190
<<<ANSWER END>>>
<<<ANSWER qid=20>>>
175
<<<ANSWER END>>>
<<<ANSWER qid=21>>>
275
<<<ANSWER END>>>
<<<ANSWER qid=22>>>
652
<<<ANSWER END>>>
<<<ANSWER qid=23>>>
649
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
