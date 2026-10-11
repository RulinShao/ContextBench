#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
kept 4 needle line(s).
kept 8 needle line(s).
kept 12 needle line(s).
kept 16 needle line(s).
kept 20 needle line(s).
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
[n00004i00#d3347cfa] orbit spruce marble willow quartz spruce auburn harbor spruce cobalt.
[n00004i01#c2729c27] verdant orbit indigo pewter orbit boulder lattice crimson lantern quartz.
[n00004i02#341c777d] auburn marble trellis orbit boulder lattice crimson onyx verdant verdant.
[n00004i03#9219a621] indigo pewter thistle harbor copper spruce cobalt spruce auburn falcon.
[n00005i00#cc8a7939] spruce thistle cobalt quartz saffron lattice indigo harbor cedar lattice.
[n00005i01#4d6e09fe] quartz crimson lattice marble cedar saffron willow zebra orbit zebra.
[n00005i02#2d2f152b] glacier willow lantern cobalt zebra crimson cedar saffron nimbus saffron.
[n00005i03#04dcd6c2] marble cobalt spruce ember crimson marble quartz falcon quartz nimbus.
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
