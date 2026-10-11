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
[n00000i00#5443e18f] nimbus zebra pewter saffron marble boulder harbor quartz indigo cedar.
[n00000i01#4f4dbad3] cedar trellis crimson spruce pewter verdant lantern orbit lantern quartz.
[n00000i02#622332f2] spruce falcon lattice saffron lantern onyx harbor boulder pewter ember.
[n00000i03#806c6105] ember indigo indigo nimbus marble ember crimson saffron nimbus copper.
[n00001i00#d2f8ce66] cobalt saffron willow spruce marble willow willow trellis lattice crimson.
[n00001i01#5322441c] onyx willow crimson verdant cinder zebra trellis trellis cedar boulder.
[n00001i02#a1adea05] indigo pewter meadow cedar cedar verdant saffron ember indigo saffron.
[n00001i03#3099fe04] pewter copper marble saffron onyx cobalt quartz cedar harbor harbor.
[n00002i00#0ae3df85] verdant cinder zebra ember trellis willow nimbus marble lattice cinder.
[n00002i01#5edf4097] glacier cobalt glacier indigo marble trellis pewter orbit cobalt copper.
[n00002i02#b90547fe] lattice saffron crimson meadow falcon spruce trellis willow spruce onyx.
[n00002i03#3524998e] trellis verdant pewter marble indigo pewter verdant indigo indigo pewter.
[n00003i00#49896fcf] glacier auburn quartz marble cobalt saffron cobalt cobalt marble zebra.
[n00003i01#5aad5535] auburn indigo crimson indigo nimbus cinder verdant cedar crimson orbit.
[n00003i02#3ffe4834] saffron cedar willow boulder onyx spruce falcon verdant harbor glacier.
[n00003i03#e009841c] onyx zebra quartz nimbus cobalt trellis zebra harbor quartz cobalt.
[n00004i00#503c0bd6] verdant meadow pewter verdant saffron auburn boulder saffron quartz willow.
[n00004i01#7a19e8ec] cedar saffron zebra quartz saffron lattice indigo willow nimbus orbit.
[n00004i02#58361100] meadow cedar cinder cinder indigo zebra onyx saffron verdant glacier.
[n00004i03#c21da15a] indigo cobalt cobalt spruce willow trellis willow thistle harbor saffron.
[n00005i00#cfe28464] orbit trellis falcon saffron boulder lantern willow verdant willow verdant.
[n00005i01#fe70eb03] onyx orbit zebra crimson zebra pewter saffron verdant indigo orbit.
[n00005i02#91e631b5] thistle indigo falcon spruce marble glacier auburn onyx orbit marble.
[n00005i03#96b68892] thistle copper onyx pewter lantern trellis crimson trellis copper boulder.
[n00006i00#0e02b7eb] lattice auburn thistle auburn saffron lantern cedar pewter boulder verdant.
[n00006i01#30a28bb0] thistle boulder cedar onyx crimson zebra thistle thistle marble boulder.
[n00006i02#825f091e] copper harbor boulder glacier glacier nimbus meadow trellis copper copper.
[n00006i03#3c61f04a] cedar cinder copper copper onyx onyx boulder nimbus cedar cobalt.
[n00007i00#f3243ceb] verdant quartz copper cinder lantern marble cedar falcon cinder glacier.
[n00007i01#adcf926b] crimson marble saffron lattice saffron cobalt crimson willow willow ember.
[n00007i02#252ded2e] thistle boulder lantern cobalt cedar zebra trellis pewter cedar boulder.
[n00007i03#f7541fda] orbit lattice orbit willow lantern willow zebra lattice harbor ember.
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
