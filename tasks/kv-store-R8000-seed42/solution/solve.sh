#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K07408>>>
indigo boulder lattice cobalt mistral cedar russet indigo indigo lantern harbor cinder cedar trellis indigo vellum zebra cedar auburn cinder onyx boulder trellis vellum #28be80fa
<<<ANSWER END>>>
<<<ANSWER key=K07413>>>
willow cobalt crimson orbit verdant willow pewter lattice kindle cobble boulder indigo glacier willow fathom fathom cobble pewter ember quartz auburn copper saffron cobble #05357095
<<<ANSWER END>>>
<<<ANSWER key=K05616>>>
garnet trellis indigo onyx mistral willow zebra glacier orbit cobble pewter nimbus boulder marble saffron cinder verdant meadow verdant kindle nimbus pewter vellum quartz #056ca3b5
<<<ANSWER END>>>
<<<ANSWER key=K03714>>>
mistral kindle saffron garnet copper vellum spruce harbor meadow fathom crimson kindle thistle onyx falcon spruce zebra harbor lantern onyx quartz cinder cinder orbit #4d99acbe
<<<ANSWER END>>>
<<<ANSWER key=K00512>>>
marble quartz fathom cobalt onyx crimson glacier falcon harbor russet cobalt lattice crimson auburn fathom cedar harbor garnet lattice falcon nimbus russet cedar glacier #69a39ba6
<<<ANSWER END>>>
<<<ANSWER key=K01756>>>
auburn copper ember ember nimbus trellis onyx indigo zebra falcon meadow thistle mistral willow garnet thistle indigo cinder copper copper thistle cobalt willow crimson #29b6eaae
<<<ANSWER END>>>
<<<ANSWER key=K03408>>>
ember auburn cobble crimson harbor cobalt trellis nimbus orbit garnet fathom cedar saffron lantern thistle crimson garnet garnet quartz copper lantern quartz ember zebra #27f44df0
<<<ANSWER END>>>
<<<ANSWER key=K00841>>>
trellis ember onyx garnet falcon boulder garnet kindle verdant pewter spruce mistral mistral thistle auburn boulder mistral crimson indigo boulder glacier lantern harbor fathom #6a135150
<<<ANSWER END>>>
<<<ANSWER key=K03700>>>
indigo pewter indigo russet spruce willow cinder thistle meadow vellum ember falcon spruce zebra cedar kindle quartz meadow cinder cinder willow quartz saffron meadow #5cddfd5e
<<<ANSWER END>>>
<<<ANSWER key=K00613>>>
falcon pewter verdant nimbus cobble lattice falcon spruce russet saffron garnet mistral verdant willow indigo meadow indigo ember auburn spruce lantern meadow cedar indigo #74629434
<<<ANSWER END>>>
<<<ANSWER key=K01677>>>
boulder onyx quartz russet thistle quartz cedar marble falcon orbit onyx verdant falcon cedar lattice cedar lattice russet glacier mistral crimson spruce harbor fathom #de90de87
<<<ANSWER END>>>
<<<ANSWER key=K05041>>>
lantern lantern spruce zebra lantern verdant zebra orbit nimbus cinder indigo pewter falcon cobalt cedar nimbus nimbus verdant verdant garnet crimson auburn copper zebra #d97f0ab6
<<<ANSWER END>>>
<<<ANSWER key=K07384>>>
verdant cobble lattice zebra trellis spruce lantern thistle vellum trellis lantern zebra pewter zebra nimbus ember copper thistle copper cinder verdant cedar lattice marble #87050870
<<<ANSWER END>>>
<<<ANSWER key=K01457>>>
orbit copper lantern russet lantern cobble russet lattice lantern trellis boulder spruce cedar copper garnet auburn fathom onyx onyx quartz meadow falcon mistral lantern #a05f2689
<<<ANSWER END>>>
<<<ANSWER key=K04469>>>
crimson spruce cobble meadow indigo copper quartz vellum marble quartz onyx thistle saffron cobalt cobalt willow falcon cinder cedar indigo fathom pewter boulder glacier #1b80efd1
<<<ANSWER END>>>
<<<ANSWER key=K01158>>>
copper cobalt onyx russet pewter orbit verdant marble quartz spruce cobble lantern indigo fathom kindle spruce kindle onyx verdant auburn willow harbor lattice mistral #3efa3974
<<<ANSWER END>>>
<<<ANSWER key=K05278>>>
quartz trellis mistral cedar saffron boulder copper harbor cobalt cobalt copper pewter glacier russet fathom lantern falcon meadow zebra onyx kindle willow harbor lantern #c1dd393d
<<<ANSWER END>>>
<<<ANSWER key=K03759>>>
quartz thistle auburn nimbus meadow garnet russet auburn vellum vellum cobble cobalt russet verdant falcon zebra crimson auburn ember garnet cobble mistral saffron trellis #b40c63a2
<<<ANSWER END>>>
<<<ANSWER key=K02499>>>
boulder ember indigo ember copper garnet garnet ember orbit vellum indigo quartz willow cedar cinder onyx lattice quartz mistral lattice thistle indigo thistle lantern #03027a5e
<<<ANSWER END>>>
<<<ANSWER key=K06039>>>
willow fathom crimson russet quartz pewter indigo verdant cobble cedar auburn mistral cedar pewter lantern vellum thistle trellis boulder copper orbit willow garnet crimson #0a2ade63
<<<ANSWER END>>>
<<<ANSWER key=K07485>>>
auburn cedar ember lantern falcon cobble kindle spruce kindle indigo ember falcon garnet zebra saffron pewter pewter crimson glacier nimbus copper ember verdant spruce #074ef1fc
<<<ANSWER END>>>
<<<ANSWER key=K05010>>>
ember harbor fathom lattice copper boulder verdant marble indigo vellum nimbus quartz russet vellum lattice boulder quartz zebra willow lattice indigo copper copper garnet #4d8cee0a
<<<ANSWER END>>>
<<<ANSWER key=K04916>>>
orbit crimson garnet thistle auburn ember cobalt crimson trellis pewter russet lantern willow glacier harbor ember quartz nimbus thistle copper nimbus cobalt saffron auburn #56c5d8b6
<<<ANSWER END>>>
<<<ANSWER key=K06489>>>
meadow spruce mistral auburn garnet russet willow nimbus cobble onyx glacier mistral glacier nimbus meadow zebra kindle marble harbor saffron mistral cinder quartz spruce #bdb66895
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
