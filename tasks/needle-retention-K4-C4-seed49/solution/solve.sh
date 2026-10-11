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
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
