#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K01722>>>
thistle lantern saffron fathom garnet spruce kindle trellis lattice trellis kindle thistle mistral russet harbor cobalt cobalt saffron boulder glacier glacier zebra zebra spruce #61dd8844
<<<ANSWER END>>>
<<<ANSWER key=K01255>>>
onyx vellum pewter orbit auburn fathom quartz lattice ember harbor cedar trellis cedar auburn kindle ember orbit cobble copper quartz trellis marble lattice saffron #e61d1b7a
<<<ANSWER END>>>
<<<ANSWER key=K01933>>>
crimson kindle copper verdant cinder zebra thistle willow nimbus willow nimbus onyx trellis quartz copper auburn copper cobble cinder cinder ember cobble meadow boulder #a6c3acbb
<<<ANSWER END>>>
<<<ANSWER key=K01396>>>
zebra orbit crimson quartz verdant auburn trellis spruce quartz garnet falcon willow ember quartz cedar trellis russet crimson cinder cedar zebra fathom cinder garnet #07d5991d
<<<ANSWER END>>>
<<<ANSWER key=K01174>>>
crimson spruce vellum orbit onyx vellum thistle willow falcon cobble boulder meadow boulder russet falcon falcon trellis cobalt cinder lattice meadow lattice nimbus cobble #d6693f5a
<<<ANSWER END>>>
<<<ANSWER key=K01493>>>
vellum cinder saffron onyx nimbus zebra orbit harbor cinder copper pewter willow mistral saffron willow harbor spruce thistle garnet copper ember falcon cedar thistle #025d8fdb
<<<ANSWER END>>>
<<<ANSWER key=K01719>>>
zebra onyx nimbus kindle ember meadow ember orbit onyx quartz lattice harbor cobalt lattice lattice cobble indigo auburn onyx onyx trellis quartz lattice nimbus #f6500abf
<<<ANSWER END>>>
<<<ANSWER key=K01355>>>
vellum nimbus glacier indigo boulder zebra kindle copper fathom crimson quartz kindle thistle meadow spruce saffron meadow cinder russet trellis indigo russet onyx kindle #4984afdf
<<<ANSWER END>>>
<<<ANSWER key=K00377>>>
glacier cobble kindle pewter boulder nimbus trellis orbit zebra cobalt cinder pewter cinder copper glacier ember copper marble garnet fathom auburn lantern quartz crimson #2dcfda55
<<<ANSWER END>>>
<<<ANSWER key=K01175>>>
crimson zebra cobble verdant orbit ember lattice pewter cobalt cobble boulder nimbus kindle willow cedar saffron cobble quartz cobble falcon russet crimson thistle russet #0407c81a
<<<ANSWER END>>>
<<<ANSWER key=K01583>>>
fathom zebra auburn spruce cobble nimbus copper quartz mistral auburn cinder crimson saffron orbit nimbus falcon cedar glacier trellis marble auburn cedar harbor meadow #b37ebc12
<<<ANSWER END>>>
<<<ANSWER key=K00913>>>
willow harbor saffron cobalt boulder lantern boulder indigo harbor thistle fathom lantern crimson quartz indigo spruce thistle cedar thistle nimbus lantern copper verdant fathom #c2b2799d
<<<ANSWER END>>>
<<<ANSWER key=K00861>>>
cobalt boulder marble russet vellum onyx trellis meadow orbit cedar cedar trellis garnet cedar zebra garnet copper glacier cobble fathom cobble quartz meadow trellis #04121ae2
<<<ANSWER END>>>
<<<ANSWER key=K00679>>>
ember garnet meadow thistle indigo russet ember meadow mistral glacier zebra crimson meadow mistral willow saffron onyx indigo verdant fathom boulder willow falcon cedar #f5bb5618
<<<ANSWER END>>>
<<<ANSWER key=K00712>>>
orbit onyx spruce saffron verdant auburn cobble ember willow nimbus russet mistral cinder harbor mistral vellum harbor ember indigo pewter lattice trellis fathom kindle #85898d52
<<<ANSWER END>>>
<<<ANSWER key=K00349>>>
cobble kindle trellis quartz boulder saffron falcon fathom garnet trellis onyx cobalt trellis lattice trellis marble thistle auburn cedar willow cobble lantern saffron verdant #afec6131
<<<ANSWER END>>>
<<<ANSWER key=K00475>>>
nimbus copper onyx crimson cinder cedar harbor quartz mistral trellis russet ember fathom garnet ember russet zebra kindle boulder falcon saffron lattice falcon meadow #baf60dfa
<<<ANSWER END>>>
<<<ANSWER key=K01783>>>
ember harbor onyx onyx lantern lantern onyx cobble cobalt auburn garnet lattice boulder russet auburn harbor cedar auburn falcon willow copper meadow cobble quartz #1bafcb9d
<<<ANSWER END>>>
<<<ANSWER key=K00060>>>
lattice cedar onyx lantern copper vellum zebra mistral glacier cobalt pewter orbit auburn garnet quartz falcon garnet lattice lattice cinder mistral ember crimson harbor #67062a10
<<<ANSWER END>>>
<<<ANSWER key=K00368>>>
copper onyx falcon kindle vellum pewter glacier lattice boulder pewter copper cobalt garnet cobble marble verdant harbor orbit ember harbor saffron lattice meadow fathom #b62308a4
<<<ANSWER END>>>
<<<ANSWER key=K00376>>>
lattice lattice meadow trellis garnet lantern spruce fathom trellis cobalt garnet cinder cobble garnet indigo onyx pewter mistral cinder onyx copper trellis cobble spruce #ce17ad78
<<<ANSWER END>>>
<<<ANSWER key=K00186>>>
kindle marble saffron cedar garnet meadow onyx cobble harbor mistral vellum nimbus spruce crimson cobble nimbus copper onyx kindle nimbus indigo auburn boulder glacier #72f754ad
<<<ANSWER END>>>
<<<ANSWER key=K01358>>>
vellum glacier willow lattice spruce cinder lantern cobalt crimson kindle trellis willow saffron verdant boulder vellum indigo spruce auburn trellis cobalt willow cedar cinder #22d7a7fb
<<<ANSWER END>>>
<<<ANSWER key=K00316>>>
thistle copper falcon orbit cobalt trellis orbit harbor ember saffron spruce pewter cedar pewter willow kindle garnet cobble thistle falcon cobble willow cobble spruce #2d446d41
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
