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
[n00000i00#73d03c85] pewter indigo saffron copper cinder orbit cobalt cedar ember willow.
[n00000i01#e8dad4c0] lantern ember orbit boulder lantern orbit cobalt auburn indigo copper.
[n00000i02#74da5e4a] willow copper glacier cedar boulder cedar auburn copper verdant harbor.
[n00000i03#1be7f770] nimbus zebra harbor onyx willow trellis cobalt orbit indigo zebra.
[n00001i00#d6cc1015] glacier thistle boulder verdant marble spruce zebra cinder willow saffron.
[n00001i01#b28e6e7b] harbor trellis crimson auburn lantern quartz lattice harbor boulder copper.
[n00001i02#10dd7453] cinder indigo thistle crimson lantern glacier falcon falcon willow lattice.
[n00001i03#4891021a] nimbus pewter auburn ember auburn willow cobalt trellis cedar trellis.
[n00002i00#b3384568] ember meadow trellis meadow marble verdant thistle onyx spruce quartz.
[n00002i01#2466dae3] onyx marble lattice falcon boulder crimson lantern quartz falcon pewter.
[n00002i02#1f2ad6c9] verdant pewter lantern harbor orbit pewter nimbus marble trellis cedar.
[n00002i03#ea43be29] falcon marble glacier ember auburn pewter onyx onyx falcon lattice.
[n00003i00#acc00ab8] orbit verdant quartz saffron boulder crimson meadow trellis saffron cobalt.
[n00003i01#93649057] verdant glacier falcon indigo orbit lantern verdant glacier onyx crimson.
[n00003i02#82fb8820] willow spruce glacier thistle boulder meadow orbit glacier boulder crimson.
[n00003i03#8ae5e919] thistle cedar lantern marble lantern marble spruce copper falcon verdant.
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
