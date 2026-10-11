#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K03389>>>
zebra copper vellum trellis garnet thistle cobalt cedar onyx willow auburn saffron cobble copper garnet trellis fathom lattice auburn thistle boulder glacier verdant orbit #f6602755
<<<ANSWER END>>>
<<<ANSWER key=K13328>>>
pewter fathom copper verdant quartz kindle auburn glacier kindle spruce indigo falcon garnet garnet meadow lattice harbor harbor fathom quartz auburn orbit cobble spruce #615a8602
<<<ANSWER END>>>
<<<ANSWER key=K00203>>>
mistral auburn saffron vellum mistral cobble auburn indigo lattice russet verdant auburn lattice onyx harbor boulder cobalt auburn pewter spruce cobble vellum crimson marble #33d49e31
<<<ANSWER END>>>
<<<ANSWER key=K14399>>>
thistle pewter willow nimbus kindle saffron pewter pewter garnet copper cobalt cinder garnet falcon glacier pewter cobble pewter meadow russet crimson mistral meadow russet #90352493
<<<ANSWER END>>>
<<<ANSWER key=K15709>>>
vellum meadow cinder onyx saffron mistral marble lattice spruce pewter mistral zebra russet cobble ember verdant mistral spruce spruce cobble vellum orbit vellum harbor #e7b0749f
<<<ANSWER END>>>
<<<ANSWER key=K01178>>>
garnet auburn indigo marble trellis fathom cobalt meadow marble pewter quartz spruce fathom trellis zebra russet harbor lantern quartz trellis cobble cinder vellum indigo #19907782
<<<ANSWER END>>>
<<<ANSWER key=K05497>>>
copper lantern lantern zebra auburn russet harbor pewter pewter ember boulder verdant russet lattice cobble onyx willow indigo marble spruce lattice orbit willow fathom #1074d6b9
<<<ANSWER END>>>
<<<ANSWER key=K03002>>>
copper cobalt quartz verdant saffron onyx trellis indigo copper falcon cobble thistle vellum falcon cedar lattice vellum saffron willow cobalt crimson marble onyx garnet #6033e5a9
<<<ANSWER END>>>
<<<ANSWER key=K07847>>>
harbor meadow zebra auburn lattice mistral lantern ember indigo auburn ember kindle lantern willow zebra quartz verdant meadow glacier cedar pewter ember lattice kindle #433b70ed
<<<ANSWER END>>>
<<<ANSWER key=K11282>>>
harbor marble harbor orbit verdant orbit spruce cobalt orbit cinder glacier saffron russet nimbus onyx meadow kindle willow cobalt verdant copper russet saffron cobble #660fb5c8
<<<ANSWER END>>>
<<<ANSWER key=K01031>>>
falcon crimson cobble marble quartz onyx spruce falcon fathom willow thistle cobalt cobble kindle quartz crimson willow trellis verdant cedar crimson kindle quartz crimson #05c2d2e0
<<<ANSWER END>>>
<<<ANSWER key=K05194>>>
nimbus onyx falcon harbor lantern quartz russet auburn harbor boulder lattice cobalt saffron boulder boulder saffron kindle ember falcon lattice cedar pewter lattice indigo #df1d00de
<<<ANSWER END>>>
<<<ANSWER key=K09065>>>
spruce kindle nimbus cobalt russet russet spruce cobble russet saffron crimson orbit russet kindle lattice meadow zebra russet auburn fathom saffron orbit meadow thistle #cad2843c
<<<ANSWER END>>>
<<<ANSWER key=K15715>>>
thistle lantern lantern kindle saffron ember harbor trellis saffron pewter trellis trellis auburn marble zebra indigo onyx pewter kindle thistle saffron indigo onyx copper #0124ec32
<<<ANSWER END>>>
<<<ANSWER key=K04023>>>
nimbus glacier cinder vellum vellum cobble spruce cobble cobalt thistle zebra thistle cobble falcon orbit cobalt pewter cinder quartz cedar cedar kindle spruce pewter #71af77cc
<<<ANSWER END>>>
<<<ANSWER key=K08186>>>
fathom marble cinder kindle lattice zebra marble meadow orbit lattice harbor nimbus crimson cobble lattice thistle marble spruce saffron crimson harbor onyx cobalt marble #92297a31
<<<ANSWER END>>>
<<<ANSWER key=K06911>>>
falcon cinder onyx cobble harbor russet harbor cobalt vellum spruce boulder mistral harbor lantern spruce spruce pewter lattice verdant crimson garnet lantern auburn russet #475b9434
<<<ANSWER END>>>
<<<ANSWER key=K06675>>>
nimbus falcon glacier indigo trellis onyx cobble verdant lattice harbor lantern lattice kindle trellis nimbus saffron ember cobble garnet russet lantern cobalt marble spruce #9d11f50b
<<<ANSWER END>>>
<<<ANSWER key=K15966>>>
cedar cedar copper thistle meadow cedar zebra marble spruce mistral garnet mistral marble boulder fathom spruce cedar cobble zebra meadow copper glacier copper trellis #cb548087
<<<ANSWER END>>>
<<<ANSWER key=K02901>>>
copper ember garnet trellis russet pewter glacier crimson kindle glacier glacier cinder copper meadow lattice thistle thistle garnet falcon garnet fathom indigo kindle glacier #3e26a08b
<<<ANSWER END>>>
<<<ANSWER key=K09140>>>
saffron indigo orbit thistle lattice indigo zebra verdant zebra crimson thistle quartz thistle cobalt vellum glacier harbor falcon cobble copper mistral verdant cedar pewter #c15af134
<<<ANSWER END>>>
<<<ANSWER key=K01794>>>
auburn garnet cobble harbor spruce falcon falcon marble lantern cobble kindle glacier russet zebra cinder lattice orbit saffron mistral pewter orbit ember lantern boulder #ab594f4b
<<<ANSWER END>>>
<<<ANSWER key=K09507>>>
indigo zebra pewter fathom thistle lantern fathom harbor nimbus verdant pewter indigo ember onyx meadow harbor boulder meadow cinder russet cinder lantern saffron zebra #791296e0
<<<ANSWER END>>>
<<<ANSWER key=K03572>>>
vellum indigo verdant pewter nimbus garnet cinder marble lantern cinder lattice falcon pewter willow falcon ember spruce trellis lattice kindle orbit pewter onyx willow #964cfc95
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
