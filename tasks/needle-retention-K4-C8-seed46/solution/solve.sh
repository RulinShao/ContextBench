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
kept 24 needle line(s).
kept 28 needle line(s).
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
[n00004i00#37cf1c2f] meadow auburn onyx onyx pewter verdant auburn falcon willow lattice.
[n00004i01#00ec3f5f] crimson marble indigo lantern ember boulder cobalt auburn quartz auburn.
[n00004i02#4f8ff3e4] lantern willow lantern trellis falcon spruce quartz boulder lantern quartz.
[n00004i03#cba84550] nimbus cinder copper thistle falcon glacier glacier copper saffron lattice.
[n00005i00#0e101838] boulder ember cobalt lattice ember nimbus cinder quartz orbit thistle.
[n00005i01#5df49d0f] thistle glacier lattice orbit trellis nimbus thistle zebra lantern trellis.
[n00005i02#ec8bc267] nimbus willow copper cedar cedar ember meadow saffron willow cobalt.
[n00005i03#d1b459ec] lantern harbor meadow willow thistle meadow pewter cedar thistle lantern.
[n00006i00#5b980c24] harbor nimbus ember onyx cinder saffron zebra willow cinder glacier.
[n00006i01#c3626164] lantern marble ember indigo trellis saffron auburn cedar verdant quartz.
[n00006i02#f43c0bd6] cinder trellis verdant copper glacier pewter falcon pewter saffron orbit.
[n00006i03#17abab84] nimbus crimson boulder falcon crimson zebra indigo nimbus trellis meadow.
[n00007i00#2af99263] verdant marble indigo quartz boulder glacier onyx crimson spruce falcon.
[n00007i01#9735e0cc] indigo quartz cobalt indigo boulder cinder onyx nimbus cobalt spruce.
[n00007i02#6193ad73] trellis nimbus quartz lattice boulder harbor boulder copper onyx pewter.
[n00007i03#713e0042] falcon marble glacier meadow quartz saffron quartz falcon verdant meadow.
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
