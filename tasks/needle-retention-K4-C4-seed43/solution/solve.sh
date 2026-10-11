#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
kept 4 needle line(s).
kept 8 needle line(s).
kept 12 needle line(s).
<<<NEEDLES BEGIN>>>
[n00000i00#8c7601ed] crimson willow copper auburn meadow marble nimbus verdant copper spruce.
[n00000i01#2f72e3f9] orbit marble trellis falcon trellis lantern indigo pewter boulder nimbus.
[n00000i02#b13cbdab] trellis cinder saffron auburn pewter cedar cobalt crimson cinder orbit.
[n00000i03#5c63c5b6] onyx orbit cedar meadow orbit cobalt indigo onyx falcon meadow.
[n00001i00#ab458110] crimson harbor nimbus verdant willow boulder lantern thistle boulder meadow.
[n00001i01#3abfeabc] lantern boulder onyx pewter harbor falcon onyx verdant lantern cedar.
[n00001i02#460c9fec] zebra thistle lantern onyx orbit trellis lantern crimson auburn copper.
[n00001i03#bcd066e8] saffron cobalt marble lantern falcon pewter thistle lantern quartz boulder.
[n00002i00#e7863f2f] falcon saffron crimson nimbus spruce quartz copper boulder trellis willow.
[n00002i01#f95d8610] crimson harbor marble trellis nimbus nimbus zebra harbor copper meadow.
[n00002i02#f8ec443c] cinder cobalt cobalt nimbus indigo crimson quartz falcon auburn thistle.
[n00002i03#975ce71d] falcon saffron glacier thistle saffron cinder copper thistle zebra crimson.
[n00003i00#451cf54f] lantern marble indigo trellis boulder marble meadow harbor falcon cedar.
[n00003i01#528025e3] cobalt quartz cobalt trellis crimson cedar onyx marble boulder trellis.
[n00003i02#8ae2e3d9] lantern marble ember cedar indigo harbor copper pewter verdant glacier.
[n00003i03#28666c2d] auburn crimson indigo crimson ember quartz saffron meadow orbit meadow.
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
