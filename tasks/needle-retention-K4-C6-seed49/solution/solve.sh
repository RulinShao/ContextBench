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
[n00000i00#e5c01652] zebra nimbus pewter orbit harbor auburn saffron indigo spruce crimson.
[n00000i01#2c806057] verdant crimson auburn lattice quartz meadow marble lattice crimson glacier.
[n00000i02#1b8cf869] saffron indigo ember cinder trellis willow boulder nimbus cedar lantern.
[n00000i03#5f0403ae] ember lattice meadow orbit pewter lattice cedar harbor auburn nimbus.
[n00001i00#a2d27b13] quartz thistle thistle meadow harbor orbit orbit spruce thistle harbor.
[n00001i01#77f2a08a] auburn orbit saffron cinder crimson meadow verdant crimson onyx lattice.
[n00001i02#8d6bb85a] crimson onyx saffron auburn ember cobalt saffron cinder cinder willow.
[n00001i03#fa665c45] copper orbit cinder boulder cinder pewter willow trellis thistle cinder.
[n00002i00#d0c07c77] saffron falcon falcon copper boulder copper glacier thistle thistle quartz.
[n00002i01#ab917005] nimbus verdant meadow glacier auburn pewter crimson ember auburn verdant.
[n00002i02#d0561cf6] falcon boulder marble quartz onyx nimbus boulder cedar orbit saffron.
[n00002i03#d82c19dc] auburn saffron meadow willow orbit cobalt crimson cedar zebra glacier.
[n00003i00#220e8e71] boulder spruce spruce onyx lattice marble cobalt cobalt lantern ember.
[n00003i01#f52de371] cedar pewter quartz boulder willow falcon zebra verdant ember glacier.
[n00003i02#8a04fdbe] glacier boulder zebra marble indigo saffron indigo lattice indigo cedar.
[n00003i03#4323fea4] glacier spruce nimbus lantern harbor zebra lattice cedar cedar auburn.
[n00004i00#c86b4ffe] trellis cobalt boulder cedar onyx lantern glacier cedar orbit saffron.
[n00004i01#22d90bac] cinder ember willow orbit crimson pewter thistle lantern lattice ember.
[n00004i02#831bebeb] pewter pewter marble falcon willow auburn glacier lantern ember onyx.
[n00004i03#553d0df9] nimbus saffron onyx crimson meadow meadow indigo zebra zebra indigo.
[n00005i00#1bd78e7b] onyx crimson onyx falcon boulder quartz onyx falcon lattice lattice.
[n00005i01#baebf92b] falcon lattice marble lantern crimson lattice auburn trellis pewter falcon.
[n00005i02#26c95993] nimbus zebra verdant cobalt crimson falcon crimson spruce saffron ember.
[n00005i03#2fc37a37] lantern crimson crimson thistle quartz pewter marble willow nimbus cobalt.
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
