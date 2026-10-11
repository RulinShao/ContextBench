#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K04172>>>
cobalt ember mistral onyx cedar cinder lattice saffron mistral kindle willow willow cobble copper harbor spruce saffron cobble lattice willow cobble copper glacier cinder #294faaed
<<<ANSWER END>>>
<<<ANSWER key=K07643>>>
harbor indigo trellis mistral cinder fathom cobalt verdant cobble cobble harbor marble fathom kindle garnet ember boulder indigo onyx copper cobble auburn lattice indigo #8760d30f
<<<ANSWER END>>>
<<<ANSWER key=K02986>>>
cinder garnet vellum nimbus verdant indigo onyx lantern harbor lattice quartz auburn fathom auburn russet crimson verdant garnet zebra cedar thistle copper indigo lattice #ffb82f73
<<<ANSWER END>>>
<<<ANSWER key=K01688>>>
kindle vellum cedar spruce glacier thistle garnet falcon mistral trellis vellum glacier ember verdant mistral vellum saffron lattice garnet thistle cedar cobalt verdant vellum #40db995f
<<<ANSWER END>>>
<<<ANSWER key=K03933>>>
marble vellum cobalt cinder cobalt crimson zebra boulder zebra orbit kindle spruce nimbus nimbus glacier cinder garnet boulder quartz cinder onyx meadow spruce ember #5c6ae513
<<<ANSWER END>>>
<<<ANSWER key=K05021>>>
crimson cobalt spruce glacier pewter indigo meadow crimson cobble quartz onyx verdant willow orbit quartz cobble cobalt saffron ember pewter copper trellis mistral pewter #50eca55f
<<<ANSWER END>>>
<<<ANSWER key=K01250>>>
orbit cinder harbor nimbus quartz copper auburn cedar zebra crimson russet boulder onyx falcon cobble boulder crimson garnet harbor zebra saffron fathom fathom saffron #ba9ec8dc
<<<ANSWER END>>>
<<<ANSWER key=K05821>>>
cedar cobalt kindle thistle falcon mistral cedar vellum spruce verdant thistle indigo pewter lattice spruce falcon russet orbit orbit marble vellum quartz onyx willow #36291487
<<<ANSWER END>>>
<<<ANSWER key=K01173>>>
mistral harbor cedar indigo vellum nimbus quartz cinder willow quartz zebra mistral nimbus verdant ember verdant thistle quartz meadow lantern lattice thistle cobalt indigo #ae7cc13f
<<<ANSWER END>>>
<<<ANSWER key=K07279>>>
trellis marble orbit copper vellum indigo pewter garnet cobble fathom russet ember kindle zebra thistle meadow harbor willow crimson garnet cinder falcon kindle trellis #89f4df44
<<<ANSWER END>>>
<<<ANSWER key=K01253>>>
harbor meadow cobble harbor garnet copper saffron onyx spruce pewter saffron meadow kindle russet saffron ember lattice garnet zebra meadow kindle ember garnet trellis #f8ff81c5
<<<ANSWER END>>>
<<<ANSWER key=K01736>>>
zebra cedar willow quartz harbor vellum nimbus cobble glacier pewter garnet vellum indigo cedar harbor spruce kindle garnet falcon willow harbor cobble zebra pewter #8e2d3a22
<<<ANSWER END>>>
<<<ANSWER key=K00165>>>
orbit zebra orbit cobble glacier ember falcon harbor crimson garnet nimbus ember pewter crimson onyx copper boulder copper cedar boulder saffron marble kindle fathom #c913cf96
<<<ANSWER END>>>
<<<ANSWER key=K02101>>>
glacier lantern pewter harbor kindle willow russet ember cinder quartz falcon saffron cobble pewter meadow marble ember vellum willow boulder fathom spruce garnet zebra #7332ce29
<<<ANSWER END>>>
<<<ANSWER key=K06282>>>
pewter onyx falcon auburn thistle orbit pewter spruce vellum saffron boulder lattice verdant indigo glacier meadow glacier saffron cobalt pewter willow cobble orbit willow #440ed30b
<<<ANSWER END>>>
<<<ANSWER key=K04867>>>
verdant lantern quartz cobble willow cedar ember crimson cedar cobalt falcon lattice trellis marble lantern orbit auburn marble ember fathom cinder harbor garnet russet #2d29a831
<<<ANSWER END>>>
<<<ANSWER key=K04643>>>
ember pewter spruce verdant fathom trellis indigo indigo saffron boulder crimson verdant verdant zebra crimson boulder garnet boulder falcon indigo quartz vellum cobalt falcon #e9f6409a
<<<ANSWER END>>>
<<<ANSWER key=K00624>>>
thistle meadow ember cobalt crimson vellum thistle copper glacier garnet indigo zebra cedar harbor quartz marble willow copper auburn russet lantern auburn auburn marble #2db5fb02
<<<ANSWER END>>>
<<<ANSWER key=K01401>>>
ember harbor mistral lantern ember cedar cinder marble meadow garnet pewter mistral meadow auburn russet indigo lattice saffron indigo lantern verdant thistle kindle verdant #8a63828c
<<<ANSWER END>>>
<<<ANSWER key=K03572>>>
thistle willow russet meadow quartz pewter boulder nimbus pewter thistle zebra cedar cedar ember glacier harbor onyx cobalt boulder kindle willow cobalt cobble lattice #5d71a444
<<<ANSWER END>>>
<<<ANSWER key=K01888>>>
cobalt onyx kindle spruce vellum ember crimson mistral orbit trellis onyx nimbus glacier meadow auburn mistral lattice lantern cobalt vellum vellum thistle willow copper #ab8d4161
<<<ANSWER END>>>
<<<ANSWER key=K04069>>>
copper lantern nimbus cinder meadow pewter quartz nimbus thistle saffron willow nimbus glacier meadow boulder glacier cinder kindle nimbus cinder cedar saffron nimbus marble #af341d52
<<<ANSWER END>>>
<<<ANSWER key=K07289>>>
marble harbor lantern garnet cobble fathom pewter mistral falcon quartz spruce indigo marble onyx cobalt lantern glacier boulder cedar kindle zebra spruce lantern indigo #2f01d12a
<<<ANSWER END>>>
<<<ANSWER key=K07711>>>
cobalt nimbus verdant cedar trellis marble marble lattice harbor lattice lantern spruce pewter thistle boulder mistral garnet spruce meadow lantern russet cinder falcon boulder #ef55a634
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
