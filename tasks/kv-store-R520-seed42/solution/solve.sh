#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00310>>>
marble ember marble cobble indigo verdant copper zebra saffron willow fathom thistle orbit vellum garnet ember thistle thistle zebra fathom thistle harbor ember pewter #cc4e4c7f
<<<ANSWER END>>>
<<<ANSWER key=K00062>>>
cobalt lattice marble crimson glacier thistle verdant willow quartz zebra boulder russet quartz russet vellum lantern cobalt crimson indigo pewter willow kindle cinder ember #a4d13bb3
<<<ANSWER END>>>
<<<ANSWER key=K00212>>>
vellum willow vellum zebra marble cedar lattice willow cobalt ember orbit falcon willow boulder lantern verdant ember trellis vellum russet crimson verdant pewter mistral #236bc280
<<<ANSWER END>>>
<<<ANSWER key=K00233>>>
cobalt garnet thistle garnet trellis garnet russet marble marble willow indigo lattice spruce nimbus verdant glacier garnet cobble crimson meadow russet ember copper russet #0bbdf940
<<<ANSWER END>>>
<<<ANSWER key=K00249>>>
auburn cedar trellis auburn thistle copper cobble cobalt vellum cedar quartz zebra cedar crimson falcon cobble auburn meadow mistral trellis cobble mistral vellum crimson #289e7907
<<<ANSWER END>>>
<<<ANSWER key=K00488>>>
russet lantern glacier meadow orbit quartz fathom vellum cinder russet glacier trellis fathom ember falcon spruce auburn auburn russet copper trellis kindle glacier kindle #d5f4528c
<<<ANSWER END>>>
<<<ANSWER key=K00475>>>
onyx indigo auburn falcon copper russet kindle nimbus trellis marble boulder cobble cobble spruce copper mistral russet boulder thistle marble ember boulder onyx vellum #d9bb38d1
<<<ANSWER END>>>
<<<ANSWER key=K00100>>>
willow auburn willow auburn glacier lattice thistle cobalt lantern trellis vellum lattice saffron thistle quartz cobalt nimbus cinder vellum fathom onyx thistle crimson cobalt #9194fe26
<<<ANSWER END>>>
<<<ANSWER key=K00052>>>
ember copper cinder ember boulder cobble kindle trellis zebra marble spruce orbit lantern pewter trellis pewter quartz indigo boulder glacier ember lantern cobble cinder #0d7897f0
<<<ANSWER END>>>
<<<ANSWER key=K00326>>>
verdant indigo vellum saffron falcon glacier verdant pewter garnet verdant crimson quartz lantern russet lantern lantern nimbus onyx cobble spruce mistral cobalt meadow mistral #a9a753a5
<<<ANSWER END>>>
<<<ANSWER key=K00074>>>
fathom thistle glacier falcon garnet ember saffron vellum falcon willow thistle orbit boulder auburn onyx falcon harbor glacier glacier cedar harbor cobble fathom garnet #be9e0a09
<<<ANSWER END>>>
<<<ANSWER key=K00201>>>
saffron ember spruce falcon lantern zebra russet willow lattice cobalt falcon harbor cobble cobalt verdant orbit orbit copper willow mistral thistle quartz cobble marble #3a5aba3c
<<<ANSWER END>>>
<<<ANSWER key=K00489>>>
cobalt pewter harbor saffron willow cinder vellum cobble indigo ember cinder copper nimbus crimson lattice garnet copper cinder pewter cedar auburn lattice nimbus lantern #f2334848
<<<ANSWER END>>>
<<<ANSWER key=K00119>>>
onyx lattice mistral nimbus russet meadow crimson meadow lantern indigo pewter zebra orbit spruce fathom boulder fathom onyx cinder spruce cobalt mistral mistral willow #b5fb9443
<<<ANSWER END>>>
<<<ANSWER key=K00452>>>
meadow verdant nimbus kindle cobble cedar pewter russet fathom copper copper quartz meadow vellum cinder auburn meadow cobalt quartz kindle trellis thistle ember cobble #7c370acb
<<<ANSWER END>>>
<<<ANSWER key=K00085>>>
ember garnet trellis harbor spruce fathom trellis ember boulder lattice marble marble quartz russet willow garnet lattice onyx russet mistral pewter falcon cobalt kindle #0f4bb774
<<<ANSWER END>>>
<<<ANSWER key=K00487>>>
cedar meadow willow thistle pewter saffron nimbus indigo thistle quartz kindle auburn verdant saffron russet pewter harbor lantern marble pewter cobalt willow willow harbor #edb2b426
<<<ANSWER END>>>
<<<ANSWER key=K00202>>>
glacier copper vellum cedar crimson auburn copper quartz indigo zebra cobble vellum boulder mistral cobble cedar nimbus mistral copper glacier garnet saffron harbor meadow #17b89c45
<<<ANSWER END>>>
<<<ANSWER key=K00102>>>
onyx trellis russet meadow lattice indigo falcon cobble cedar garnet thistle quartz trellis lantern spruce verdant auburn verdant vellum verdant cinder quartz trellis glacier #6e298ba4
<<<ANSWER END>>>
<<<ANSWER key=K00220>>>
cedar boulder vellum spruce trellis boulder garnet harbor cinder boulder orbit kindle willow garnet vellum cobalt fathom ember nimbus mistral quartz spruce onyx glacier #01de0fe1
<<<ANSWER END>>>
<<<ANSWER key=K00498>>>
crimson harbor fathom harbor trellis kindle cedar quartz quartz verdant orbit cobalt trellis willow copper garnet spruce harbor garnet lantern willow cedar nimbus trellis #2df113af
<<<ANSWER END>>>
<<<ANSWER key=K00307>>>
cinder onyx cobble boulder zebra cobble spruce cobble fathom cobble marble orbit kindle crimson cinder glacier meadow saffron onyx russet ember cobble copper vellum #5a0fb35f
<<<ANSWER END>>>
<<<ANSWER key=K00009>>>
garnet falcon meadow vellum thistle orbit mistral lantern cobalt falcon harbor onyx cobble russet pewter spruce orbit harbor auburn lantern auburn indigo garnet boulder #aa978ddb
<<<ANSWER END>>>
<<<ANSWER key=K00440>>>
verdant ember cinder garnet copper boulder ember lantern cobble willow garnet willow kindle boulder harbor trellis cobble boulder meadow boulder lantern garnet zebra pewter #d1e72fab
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
