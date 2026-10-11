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
[n00000i00#d16d1c29] zebra cedar crimson boulder boulder cinder ember glacier indigo meadow.
[n00000i01#bf1c6f55] boulder saffron spruce crimson lantern zebra spruce harbor glacier onyx.
[n00000i02#5e20f0eb] crimson onyx lantern meadow saffron willow indigo harbor copper auburn.
[n00000i03#2e8a9dcb] zebra cedar copper falcon nimbus meadow falcon marble onyx zebra.
[n00001i00#8ccd998d] meadow onyx marble falcon copper harbor spruce lantern indigo ember.
[n00001i01#d63498a6] cobalt verdant ember meadow cinder saffron cedar crimson lantern spruce.
[n00001i02#83a99d9d] pewter auburn glacier cinder onyx thistle willow pewter harbor marble.
[n00001i03#a7e2370f] zebra meadow spruce cobalt boulder zebra lantern falcon harbor indigo.
[n00002i00#c9ea6cc2] crimson ember meadow lantern willow quartz trellis thistle cedar falcon.
[n00002i01#fae11d69] auburn copper trellis nimbus lantern orbit copper harbor falcon spruce.
[n00002i02#6b63e189] verdant boulder trellis lantern nimbus glacier trellis copper harbor crimson.
[n00002i03#f15391b5] cobalt cinder lattice verdant meadow meadow quartz cinder meadow auburn.
[n00003i00#a146a961] glacier auburn meadow thistle onyx copper indigo harbor meadow ember.
[n00003i01#90c9ece6] falcon cedar nimbus cedar harbor lantern lantern ember thistle copper.
[n00003i02#51975bcd] saffron onyx saffron glacier spruce zebra verdant pewter saffron auburn.
[n00003i03#02cbcdb9] cedar trellis auburn cedar verdant orbit copper falcon meadow auburn.
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
