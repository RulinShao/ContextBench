#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00511>>>
vellum pewter cobble kindle cedar cobble garnet cinder willow verdant willow cobble marble nimbus orbit cobble saffron verdant meadow spruce pewter nimbus thistle nimbus #d57f915a
<<<ANSWER END>>>
<<<ANSWER key=K00488>>>
vellum mistral russet crimson cobalt cinder meadow vellum zebra copper garnet thistle ember fathom falcon auburn thistle marble crimson kindle glacier thistle copper marble #e9846f90
<<<ANSWER END>>>
<<<ANSWER key=K00426>>>
nimbus meadow nimbus crimson cedar indigo trellis onyx onyx verdant marble fathom cinder falcon lattice kindle crimson auburn zebra russet trellis spruce lattice meadow #289047a4
<<<ANSWER END>>>
<<<ANSWER key=K00309>>>
mistral glacier cedar saffron zebra garnet mistral boulder onyx lantern vellum harbor boulder thistle falcon meadow falcon zebra lattice fathom orbit zebra garnet cinder #5d7cdac8
<<<ANSWER END>>>
<<<ANSWER key=K00052>>>
ember auburn lattice willow lantern cobble russet cobalt indigo kindle cedar ember crimson falcon cedar ember falcon fathom trellis onyx cobalt spruce onyx nimbus #fdedf14d
<<<ANSWER END>>>
<<<ANSWER key=K00073>>>
russet orbit cobalt harbor trellis crimson cedar crimson onyx garnet cinder onyx cinder crimson falcon indigo quartz ember lantern indigo ember willow kindle copper #0fd1bc0b
<<<ANSWER END>>>
<<<ANSWER key=K00047>>>
cinder harbor marble indigo falcon fathom cobble cinder glacier vellum marble orbit trellis glacier spruce falcon mistral glacier lantern glacier meadow nimbus ember glacier #9fb55db2
<<<ANSWER END>>>
<<<ANSWER key=K00245>>>
onyx cobble crimson copper thistle spruce trellis nimbus mistral saffron harbor harbor saffron lattice copper mistral nimbus glacier trellis fathom cinder meadow ember fathom #8bfef193
<<<ANSWER END>>>
<<<ANSWER key=K00453>>>
quartz marble copper falcon quartz boulder mistral crimson verdant thistle nimbus falcon fathom glacier cedar pewter falcon orbit willow crimson russet willow falcon mistral #88c6d4c6
<<<ANSWER END>>>
<<<ANSWER key=K00429>>>
marble cedar vellum cobalt orbit saffron marble saffron indigo lantern nimbus fathom marble onyx verdant willow vellum cobble trellis cobalt marble lantern nimbus marble #97469b94
<<<ANSWER END>>>
<<<ANSWER key=K00230>>>
mistral zebra lattice lantern quartz quartz cedar willow verdant willow cinder boulder cinder russet cobble onyx copper saffron meadow trellis falcon crimson russet meadow #d1d1aba8
<<<ANSWER END>>>
<<<ANSWER key=K00409>>>
kindle quartz auburn falcon glacier cedar cedar boulder marble auburn quartz cinder falcon cobalt cinder zebra glacier cinder boulder auburn vellum pewter quartz quartz #7b1eaa39
<<<ANSWER END>>>
<<<ANSWER key=K00178>>>
cobalt fathom fathom marble onyx pewter cinder copper saffron fathom verdant vellum orbit cinder nimbus thistle zebra thistle harbor cobble cedar cobble falcon quartz #a877945c
<<<ANSWER END>>>
<<<ANSWER key=K00120>>>
pewter ember verdant boulder cinder nimbus garnet orbit marble thistle boulder pewter crimson lattice lattice saffron lantern falcon trellis cobble marble verdant harbor pewter #3fe6bf08
<<<ANSWER END>>>
<<<ANSWER key=K00298>>>
lattice zebra thistle meadow fathom nimbus russet quartz saffron willow nimbus glacier quartz nimbus mistral orbit quartz auburn trellis onyx saffron quartz ember orbit #49594366
<<<ANSWER END>>>
<<<ANSWER key=K00246>>>
garnet lantern pewter saffron thistle trellis zebra spruce orbit auburn falcon glacier lantern cobalt trellis mistral orbit ember zebra auburn russet cobble ember fathom #997aa40f
<<<ANSWER END>>>
<<<ANSWER key=K00144>>>
indigo indigo onyx pewter mistral harbor zebra quartz auburn harbor onyx crimson marble spruce garnet trellis cedar cobalt boulder vellum cobble cedar cobble indigo #bdafbadb
<<<ANSWER END>>>
<<<ANSWER key=K00162>>>
ember willow cobalt cinder harbor garnet saffron meadow cedar cinder kindle auburn fathom russet ember trellis indigo onyx harbor verdant thistle thistle mistral lantern #21b23f63
<<<ANSWER END>>>
<<<ANSWER key=K00082>>>
thistle kindle willow nimbus kindle russet mistral glacier nimbus lantern willow fathom cobalt copper cinder copper russet saffron pewter quartz vellum falcon mistral cinder #25a167dd
<<<ANSWER END>>>
<<<ANSWER key=K00366>>>
russet marble orbit saffron cobalt saffron pewter ember falcon ember saffron lattice falcon copper harbor falcon orbit boulder meadow lantern harbor cinder lattice cobalt #9b81dd5d
<<<ANSWER END>>>
<<<ANSWER key=K00401>>>
kindle mistral ember vellum garnet marble cobble meadow boulder spruce saffron verdant meadow lantern crimson falcon verdant nimbus crimson russet lattice quartz saffron pewter #eca0a836
<<<ANSWER END>>>
<<<ANSWER key=K00331>>>
vellum vellum nimbus verdant cobalt crimson lattice willow harbor quartz lantern fathom trellis zebra meadow falcon harbor thistle harbor mistral falcon glacier orbit quartz #37977e29
<<<ANSWER END>>>
<<<ANSWER key=K00285>>>
cobalt cobalt russet boulder trellis cinder lantern crimson thistle ember zebra trellis cinder fathom kindle falcon copper onyx fathom verdant lattice thistle indigo glacier #237edddd
<<<ANSWER END>>>
<<<ANSWER key=K00213>>>
lantern cedar trellis cobble kindle mistral garnet falcon quartz orbit glacier indigo garnet thistle cedar spruce crimson crimson kindle onyx auburn cobble ember cobalt #b9f41add
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
