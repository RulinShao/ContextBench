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
[n00000i00#83089bbe] quartz pewter falcon quartz zebra willow harbor lantern zebra falcon.
[n00000i01#d7908831] lantern orbit willow spruce orbit willow cinder lattice glacier crimson.
[n00000i02#d0268580] trellis zebra meadow quartz spruce lattice meadow thistle cinder auburn.
[n00000i03#ba429df1] copper pewter zebra trellis pewter meadow copper crimson crimson cobalt.
[n00001i00#11894327] falcon trellis crimson harbor thistle indigo zebra nimbus thistle ember.
[n00001i01#e79aae2b] nimbus indigo trellis glacier lantern boulder onyx spruce zebra willow.
[n00001i02#ca9f5664] indigo trellis orbit falcon marble ember saffron cedar verdant lattice.
[n00001i03#ff842349] cedar auburn boulder quartz crimson zebra saffron quartz meadow orbit.
[n00002i00#497fdf66] ember pewter zebra boulder glacier zebra auburn falcon onyx indigo.
[n00002i01#270dc520] lantern lantern lantern cedar onyx falcon falcon trellis glacier verdant.
[n00002i02#d309a403] onyx meadow harbor falcon ember saffron falcon harbor falcon ember.
[n00002i03#5dd170b4] quartz lantern verdant spruce cinder harbor indigo cobalt boulder thistle.
[n00003i00#23b4a047] onyx auburn ember spruce lattice copper thistle harbor indigo onyx.
[n00003i01#6839d755] nimbus saffron spruce marble orbit orbit zebra cedar marble onyx.
[n00003i02#0c9c4dd8] cedar onyx willow spruce quartz nimbus cobalt lantern boulder boulder.
[n00003i03#57dd19b0] meadow harbor quartz glacier ember meadow orbit zebra pewter harbor.
[n00004i00#18dcb5a1] zebra glacier onyx willow marble spruce saffron harbor auburn verdant.
[n00004i01#4e4d5d6d] lantern lattice pewter willow glacier verdant cedar spruce harbor cobalt.
[n00004i02#c265eba0] lattice crimson saffron auburn auburn auburn crimson cedar meadow quartz.
[n00004i03#e1dd3329] meadow cedar marble copper verdant verdant glacier cinder meadow boulder.
[n00005i00#36a237ec] glacier orbit verdant verdant boulder trellis crimson lattice spruce boulder.
[n00005i01#98d645e4] lantern nimbus cedar indigo lantern ember trellis zebra lantern ember.
[n00005i02#5e7a7b0f] lattice lantern verdant spruce onyx cinder cinder saffron auburn falcon.
[n00005i03#afe32758] nimbus copper onyx falcon boulder trellis saffron verdant marble auburn.
[n00006i00#b777b848] boulder harbor pewter thistle cinder thistle pewter marble saffron orbit.
[n00006i01#3c2bdb69] auburn boulder orbit spruce orbit trellis nimbus orbit nimbus copper.
[n00006i02#9a53cc40] cinder copper ember falcon spruce auburn lantern orbit quartz orbit.
[n00006i03#234d01c5] trellis marble lattice falcon harbor glacier glacier nimbus verdant boulder.
[n00007i00#2733170a] spruce willow cobalt orbit ember lantern lantern falcon verdant falcon.
[n00007i01#04827921] lantern saffron boulder boulder cedar trellis glacier cobalt boulder zebra.
[n00007i02#40f2904b] saffron spruce saffron ember willow lantern lantern willow orbit harbor.
[n00007i03#d966114c] cedar pewter lantern auburn lattice trellis marble willow crimson onyx.
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
