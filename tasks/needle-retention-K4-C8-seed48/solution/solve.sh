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
[n00000i00#79182776] saffron harbor meadow saffron copper saffron willow spruce indigo thistle.
[n00000i01#72422325] copper auburn pewter cobalt meadow spruce cinder verdant orbit falcon.
[n00000i02#6a005a63] glacier ember thistle auburn indigo saffron cinder indigo meadow falcon.
[n00000i03#5f7162ec] thistle lantern zebra pewter zebra meadow falcon verdant cobalt meadow.
[n00001i00#76da7ca6] spruce falcon nimbus copper marble verdant thistle nimbus ember harbor.
[n00001i01#c335f37e] lantern ember copper cedar trellis cobalt marble copper marble cinder.
[n00001i02#965912dc] cinder thistle orbit lantern willow cinder pewter falcon verdant orbit.
[n00001i03#d2c15eb8] nimbus pewter onyx trellis indigo willow thistle spruce falcon quartz.
[n00002i00#549d72ec] marble cinder cedar lattice cobalt nimbus falcon quartz copper thistle.
[n00002i01#11e36a7b] spruce ember onyx lantern cobalt auburn spruce willow saffron meadow.
[n00002i02#17829887] lantern ember cobalt spruce marble indigo willow cinder willow cobalt.
[n00002i03#cf516b29] verdant meadow marble lantern lantern meadow spruce thistle lattice auburn.
[n00003i00#2af54b64] trellis trellis auburn cinder indigo cobalt crimson harbor nimbus saffron.
[n00003i01#d4002475] auburn saffron crimson indigo marble willow trellis crimson zebra cinder.
[n00003i02#36c344df] thistle pewter pewter glacier glacier cedar copper marble cobalt meadow.
[n00003i03#53683ebd] pewter willow cedar marble saffron willow nimbus marble auburn orbit.
[n00004i00#ffffae6e] willow meadow willow auburn harbor ember meadow glacier nimbus falcon.
[n00004i01#97c03c20] pewter thistle marble cedar orbit copper harbor thistle meadow boulder.
[n00004i02#ccbb7ee3] lantern quartz trellis lantern saffron copper onyx zebra verdant meadow.
[n00004i03#c377880f] harbor trellis zebra crimson pewter spruce willow cedar cinder indigo.
[n00005i00#1abecb43] cobalt nimbus copper auburn thistle falcon trellis lattice verdant trellis.
[n00005i01#f90d4ac5] boulder pewter zebra verdant cobalt onyx cedar orbit indigo auburn.
[n00005i02#abd61805] willow spruce lantern cinder zebra saffron spruce meadow harbor zebra.
[n00005i03#45f27f73] cobalt pewter copper meadow trellis harbor willow auburn pewter willow.
[n00006i00#2ebb8e1b] onyx glacier cobalt ember ember spruce thistle cedar zebra onyx.
[n00006i01#c3683619] meadow trellis crimson ember boulder indigo cedar marble pewter pewter.
[n00006i02#74fe9578] orbit cinder spruce glacier lantern trellis auburn harbor trellis crimson.
[n00006i03#339189f7] cedar pewter auburn meadow crimson orbit indigo cedar marble cobalt.
[n00007i00#9d71c995] thistle pewter pewter orbit orbit crimson glacier lattice crimson lattice.
[n00007i01#ee0b20af] lantern spruce saffron copper crimson cedar harbor onyx glacier copper.
[n00007i02#48911ad4] spruce lattice harbor falcon nimbus verdant crimson onyx ember ember.
[n00007i03#7c2f8a77] crimson cinder meadow crimson pewter harbor quartz glacier willow thistle.
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
