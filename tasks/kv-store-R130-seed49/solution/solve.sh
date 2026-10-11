#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00114>>>
nimbus lantern marble spruce cinder saffron trellis cobble meadow marble cobalt garnet fathom mistral kindle kindle auburn copper crimson verdant meadow auburn spruce marble #e4f328eb
<<<ANSWER END>>>
<<<ANSWER key=K00128>>>
auburn onyx copper quartz vellum cedar lattice copper auburn marble onyx russet garnet trellis indigo marble kindle cedar cobble onyx pewter orbit copper verdant #6b09845c
<<<ANSWER END>>>
<<<ANSWER key=K00060>>>
boulder trellis vellum nimbus cobalt falcon ember cobalt auburn trellis ember ember pewter zebra pewter cedar orbit spruce orbit spruce garnet cobalt pewter mistral #643fc0c8
<<<ANSWER END>>>
<<<ANSWER key=K00126>>>
falcon indigo glacier trellis onyx orbit mistral meadow spruce verdant lattice glacier lattice meadow orbit cedar ember crimson quartz crimson auburn auburn zebra crimson #c9db4218
<<<ANSWER END>>>
<<<ANSWER key=K00045>>>
russet auburn thistle lattice pewter kindle quartz ember crimson thistle harbor glacier crimson mistral quartz glacier nimbus russet cobble onyx willow meadow boulder vellum #6e87becc
<<<ANSWER END>>>
<<<ANSWER key=K00096>>>
harbor lattice russet lantern cobalt spruce ember quartz verdant marble boulder cobble onyx zebra lattice thistle copper nimbus zebra copper kindle kindle pewter lantern #4c16d288
<<<ANSWER END>>>
<<<ANSWER key=K00098>>>
harbor kindle fathom lantern spruce fathom copper indigo copper verdant lattice indigo quartz orbit cedar mistral mistral meadow trellis lattice cobalt quartz spruce pewter #8232a7d3
<<<ANSWER END>>>
<<<ANSWER key=K00005>>>
crimson onyx kindle indigo ember vellum marble crimson russet willow indigo spruce harbor saffron marble harbor marble trellis copper pewter zebra ember cinder zebra #1dfc519d
<<<ANSWER END>>>
<<<ANSWER key=K00055>>>
willow falcon indigo lantern copper harbor crimson thistle spruce copper garnet meadow fathom pewter meadow cinder fathom garnet indigo garnet fathom indigo trellis verdant #d36ef8ea
<<<ANSWER END>>>
<<<ANSWER key=K00121>>>
kindle ember spruce vellum onyx spruce orbit kindle cedar thistle quartz zebra ember indigo saffron kindle indigo indigo indigo verdant boulder onyx auburn saffron #2273e016
<<<ANSWER END>>>
<<<ANSWER key=K00032>>>
onyx auburn nimbus garnet glacier cedar lantern quartz nimbus russet cobble garnet meadow quartz quartz cinder boulder falcon meadow spruce boulder saffron russet spruce #85f317be
<<<ANSWER END>>>
<<<ANSWER key=K00123>>>
mistral cobble vellum cobble indigo willow meadow auburn willow lantern marble onyx falcon onyx vellum verdant quartz cobalt kindle auburn lattice zebra thistle harbor #d4ef0b13
<<<ANSWER END>>>
<<<ANSWER key=K00056>>>
boulder glacier cinder cobalt mistral saffron copper glacier cobalt cobble russet orbit vellum marble spruce copper kindle cinder quartz nimbus marble copper cobalt thistle #3dda45fe
<<<ANSWER END>>>
<<<ANSWER key=K00016>>>
copper willow pewter trellis crimson thistle quartz willow trellis onyx spruce zebra ember zebra copper kindle nimbus verdant glacier vellum willow falcon lattice russet #36cfc56a
<<<ANSWER END>>>
<<<ANSWER key=K00084>>>
auburn boulder boulder cobble orbit meadow quartz cedar quartz onyx lantern crimson nimbus willow lattice lantern marble glacier lattice meadow marble copper ember cinder #9281844b
<<<ANSWER END>>>
<<<ANSWER key=K00020>>>
cobalt marble nimbus zebra meadow ember orbit lantern orbit russet lattice marble cinder cinder indigo quartz verdant indigo pewter nimbus verdant nimbus vellum cinder #710cb3fa
<<<ANSWER END>>>
<<<ANSWER key=K00107>>>
russet thistle trellis lantern trellis glacier saffron indigo trellis verdant lantern marble meadow harbor kindle lattice vellum cinder mistral pewter harbor falcon russet lattice #2c0dead9
<<<ANSWER END>>>
<<<ANSWER key=K00018>>>
cobalt orbit kindle vellum saffron quartz marble cedar russet crimson lantern marble pewter quartz meadow cinder verdant lattice boulder orbit quartz trellis spruce auburn #e5f8cd54
<<<ANSWER END>>>
<<<ANSWER key=K00001>>>
glacier copper saffron spruce orbit onyx mistral pewter meadow indigo mistral mistral glacier quartz cobble marble glacier indigo cinder cobble cobble auburn saffron crimson #f157cacc
<<<ANSWER END>>>
<<<ANSWER key=K00046>>>
crimson falcon garnet fathom verdant meadow trellis crimson trellis ember auburn meadow indigo glacier harbor pewter orbit harbor cinder cobble harbor glacier cinder mistral #88de6706
<<<ANSWER END>>>
<<<ANSWER key=K00014>>>
copper marble boulder glacier vellum crimson vellum trellis boulder pewter spruce verdant cobalt onyx meadow verdant glacier vellum thistle kindle willow onyx russet zebra #ba05529d
<<<ANSWER END>>>
<<<ANSWER key=K00047>>>
crimson onyx nimbus nimbus verdant spruce mistral onyx orbit cobble auburn lattice pewter thistle nimbus willow cedar indigo meadow vellum thistle thistle onyx nimbus #1ee9848a
<<<ANSWER END>>>
<<<ANSWER key=K00049>>>
cobalt boulder cobble harbor auburn saffron falcon cedar trellis garnet cobble garnet russet verdant quartz garnet ember trellis willow indigo meadow verdant saffron orbit #3a1b8195
<<<ANSWER END>>>
<<<ANSWER key=K00086>>>
verdant verdant indigo indigo kindle lantern pewter nimbus cobalt lattice harbor quartz thistle harbor cedar lattice cinder fathom quartz cobalt thistle meadow onyx vellum #93ce658e
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
