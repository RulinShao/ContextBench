#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00068>>>
zebra mistral saffron spruce zebra vellum crimson quartz russet willow falcon mistral harbor garnet quartz garnet glacier russet cinder mistral russet cedar verdant auburn #1b879017
<<<ANSWER END>>>
<<<ANSWER key=K00129>>>
copper lattice cobble nimbus mistral marble lantern zebra orbit garnet lattice meadow indigo verdant ember thistle verdant falcon verdant nimbus crimson harbor nimbus orbit #ef2a8227
<<<ANSWER END>>>
<<<ANSWER key=K00112>>>
mistral orbit meadow harbor zebra ember kindle marble cobble quartz saffron cedar falcon vellum pewter marble glacier quartz mistral nimbus pewter willow mistral zebra #b835d926
<<<ANSWER END>>>
<<<ANSWER key=K00113>>>
verdant quartz pewter fathom verdant willow marble russet auburn copper auburn glacier lantern lantern falcon pewter cobalt cinder auburn spruce ember russet willow verdant #2382c861
<<<ANSWER END>>>
<<<ANSWER key=K00090>>>
onyx mistral trellis russet boulder trellis indigo meadow mistral russet willow willow saffron trellis boulder indigo meadow lattice mistral nimbus copper quartz cobalt verdant #2fd5908c
<<<ANSWER END>>>
<<<ANSWER key=K00128>>>
verdant boulder harbor harbor indigo indigo crimson ember cinder vellum meadow auburn garnet trellis willow meadow saffron zebra cobalt garnet verdant orbit pewter meadow #04fb99c6
<<<ANSWER END>>>
<<<ANSWER key=K00030>>>
fathom spruce onyx cinder garnet trellis indigo verdant spruce orbit cobalt verdant garnet russet marble cinder quartz thistle thistle spruce marble cedar willow auburn #85085e79
<<<ANSWER END>>>
<<<ANSWER key=K00056>>>
vellum onyx kindle fathom spruce falcon pewter marble quartz willow falcon boulder ember quartz orbit marble meadow thistle verdant spruce orbit glacier russet willow #7393104c
<<<ANSWER END>>>
<<<ANSWER key=K00096>>>
ember spruce trellis marble marble lantern boulder cobalt cobalt auburn harbor falcon crimson saffron lattice indigo verdant lantern lantern cedar ember saffron indigo trellis #d015540c
<<<ANSWER END>>>
<<<ANSWER key=K00101>>>
russet onyx falcon mistral harbor garnet auburn cobalt cinder glacier ember falcon fathom fathom indigo indigo vellum nimbus vellum onyx fathom lantern lattice crimson #2b03354d
<<<ANSWER END>>>
<<<ANSWER key=K00086>>>
orbit crimson indigo onyx fathom marble quartz crimson pewter pewter marble orbit fathom orbit lattice indigo boulder cinder trellis meadow crimson auburn orbit zebra #0e1d84ee
<<<ANSWER END>>>
<<<ANSWER key=K00123>>>
harbor cobble mistral marble copper fathom lantern orbit cinder ember fathom spruce willow onyx cobble russet russet zebra cinder onyx ember russet boulder boulder #25696812
<<<ANSWER END>>>
<<<ANSWER key=K00089>>>
cedar kindle trellis indigo fathom lattice boulder pewter fathom cobalt copper meadow cobalt marble cedar spruce zebra orbit lantern garnet boulder indigo pewter kindle #950a2621
<<<ANSWER END>>>
<<<ANSWER key=K00074>>>
garnet verdant pewter zebra nimbus meadow glacier boulder harbor fathom harbor pewter willow trellis falcon glacier copper thistle russet glacier trellis russet glacier thistle #558d588a
<<<ANSWER END>>>
<<<ANSWER key=K00038>>>
cobble russet spruce ember cobble lantern boulder glacier trellis boulder saffron harbor willow garnet cobble verdant lantern fathom marble harbor marble quartz auburn orbit #86756726
<<<ANSWER END>>>
<<<ANSWER key=K00088>>>
cinder cedar orbit thistle verdant marble kindle garnet verdant cinder falcon onyx thistle vellum verdant auburn spruce lattice kindle cinder thistle onyx spruce kindle #aadd2ca3
<<<ANSWER END>>>
<<<ANSWER key=K00015>>>
cedar boulder harbor vellum ember fathom cobble verdant spruce nimbus cinder saffron cedar verdant glacier thistle marble boulder fathom falcon quartz willow cobble cobble #a258ad53
<<<ANSWER END>>>
<<<ANSWER key=K00103>>>
vellum pewter lattice glacier lattice auburn mistral pewter fathom trellis thistle zebra thistle harbor mistral cedar meadow orbit harbor indigo quartz indigo thistle boulder #13b8cb94
<<<ANSWER END>>>
<<<ANSWER key=K00091>>>
fathom boulder cobalt lantern boulder harbor meadow pewter zebra spruce crimson cinder nimbus trellis garnet verdant ember falcon verdant willow indigo indigo meadow onyx #b4f64d25
<<<ANSWER END>>>
<<<ANSWER key=K00040>>>
boulder copper garnet willow cedar vellum quartz verdant zebra pewter nimbus harbor pewter kindle vellum auburn onyx harbor pewter falcon verdant zebra spruce trellis #c5261450
<<<ANSWER END>>>
<<<ANSWER key=K00053>>>
russet auburn copper orbit kindle russet pewter lantern marble lantern glacier onyx cobble quartz marble copper lantern quartz thistle orbit orbit auburn harbor auburn #ebd8d94e
<<<ANSWER END>>>
<<<ANSWER key=K00110>>>
willow falcon falcon lantern thistle willow cobble boulder nimbus ember vellum spruce meadow boulder meadow thistle nimbus crimson glacier russet trellis meadow auburn russet #4e6b06a5
<<<ANSWER END>>>
<<<ANSWER key=K00085>>>
glacier cobble falcon auburn crimson glacier cobble falcon meadow willow quartz quartz willow cobble russet onyx verdant nimbus auburn russet zebra meadow cinder pewter #aa0d9de5
<<<ANSWER END>>>
<<<ANSWER key=K00024>>>
cobalt quartz cedar fathom indigo auburn copper quartz kindle lattice marble indigo willow copper saffron harbor boulder auburn falcon glacier nimbus nimbus boulder zebra #2a64a89f
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
