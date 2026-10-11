#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00122>>>
fathom lattice orbit cobble harbor lattice harbor indigo thistle ember marble fathom lantern zebra lantern falcon zebra russet lattice auburn willow nimbus zebra onyx #8104400c
<<<ANSWER END>>>
<<<ANSWER key=K00015>>>
saffron harbor thistle auburn zebra russet marble cedar garnet copper trellis marble marble crimson cedar spruce verdant saffron meadow saffron copper fathom spruce mistral #15e1b19b
<<<ANSWER END>>>
<<<ANSWER key=K00022>>>
marble cobble marble saffron cinder cobble crimson auburn verdant spruce harbor garnet quartz mistral crimson spruce crimson cobalt cinder quartz garnet nimbus orbit indigo #98ad4c42
<<<ANSWER END>>>
<<<ANSWER key=K00035>>>
crimson falcon harbor trellis lantern onyx cobalt marble ember garnet ember willow cobble boulder fathom saffron onyx russet russet falcon garnet willow auburn cedar #8947acc9
<<<ANSWER END>>>
<<<ANSWER key=K00049>>>
meadow cobalt cobalt cobalt cinder thistle lattice quartz orbit verdant ember onyx copper cinder orbit boulder trellis copper thistle fathom pewter willow russet marble #a212d3cf
<<<ANSWER END>>>
<<<ANSWER key=K00017>>>
cinder meadow verdant glacier ember trellis fathom trellis onyx glacier spruce boulder quartz cedar onyx auburn nimbus trellis spruce lantern trellis boulder pewter cinder #5182aaa6
<<<ANSWER END>>>
<<<ANSWER key=K00053>>>
nimbus quartz auburn mistral marble fathom copper meadow spruce zebra cinder crimson garnet meadow glacier cinder spruce onyx boulder ember spruce crimson glacier harbor #456bd068
<<<ANSWER END>>>
<<<ANSWER key=K00025>>>
copper mistral cinder lattice meadow fathom verdant lantern onyx cobble thistle cinder lattice garnet willow cinder nimbus kindle saffron mistral russet garnet cinder saffron #4ea7eb17
<<<ANSWER END>>>
<<<ANSWER key=K00082>>>
harbor onyx russet russet cedar boulder glacier boulder orbit cobalt marble mistral zebra nimbus onyx nimbus zebra spruce cobble nimbus boulder zebra lantern trellis #0c25673d
<<<ANSWER END>>>
<<<ANSWER key=K00113>>>
quartz quartz falcon willow glacier falcon spruce cobble willow saffron onyx auburn vellum meadow cobalt spruce fathom saffron lattice garnet cobble glacier lantern cobalt #c3721678
<<<ANSWER END>>>
<<<ANSWER key=K00102>>>
onyx trellis russet meadow lattice indigo falcon cobble cedar garnet thistle quartz trellis lantern spruce verdant auburn verdant vellum verdant cinder quartz trellis glacier #6e298ba4
<<<ANSWER END>>>
<<<ANSWER key=K00067>>>
boulder glacier thistle cobalt glacier boulder trellis vellum cinder harbor vellum copper vellum zebra copper cinder saffron orbit meadow spruce lattice fathom harbor crimson #8d554562
<<<ANSWER END>>>
<<<ANSWER key=K00031>>>
harbor lantern onyx vellum russet boulder zebra marble boulder boulder garnet meadow marble indigo cedar cinder ember mistral marble willow saffron willow meadow orbit #06ea803c
<<<ANSWER END>>>
<<<ANSWER key=K00080>>>
falcon saffron trellis marble trellis boulder pewter cobble glacier russet copper saffron boulder ember mistral auburn spruce copper willow boulder zebra boulder cobalt copper #4bd0e54e
<<<ANSWER END>>>
<<<ANSWER key=K00119>>>
onyx lattice mistral nimbus russet meadow crimson meadow lantern indigo pewter zebra orbit spruce fathom boulder fathom onyx cinder spruce cobalt mistral mistral willow #b5fb9443
<<<ANSWER END>>>
<<<ANSWER key=K00069>>>
crimson nimbus cobble kindle auburn ember indigo indigo vellum pewter boulder cobble cedar ember quartz meadow vellum nimbus vellum cobalt glacier copper meadow mistral #93e36f55
<<<ANSWER END>>>
<<<ANSWER key=K00101>>>
copper cobalt glacier auburn lantern boulder onyx auburn cobalt falcon kindle harbor auburn harbor quartz saffron trellis saffron cobble willow meadow harbor cinder saffron #833babba
<<<ANSWER END>>>
<<<ANSWER key=K00002>>>
zebra marble boulder cobalt marble thistle auburn saffron garnet lattice harbor lattice copper pewter saffron meadow harbor mistral falcon harbor garnet auburn saffron marble #d3982bcf
<<<ANSWER END>>>
<<<ANSWER key=K00048>>>
kindle boulder garnet fathom cinder thistle ember pewter cinder vellum marble onyx verdant garnet spruce onyx thistle glacier cinder glacier indigo lattice willow russet #948823b5
<<<ANSWER END>>>
<<<ANSWER key=K00100>>>
willow auburn willow auburn glacier lattice thistle cobalt lantern trellis vellum lattice saffron thistle quartz cobalt nimbus cinder vellum fathom onyx thistle crimson cobalt #9194fe26
<<<ANSWER END>>>
<<<ANSWER key=K00091>>>
kindle glacier onyx onyx willow trellis auburn nimbus mistral russet falcon marble trellis willow garnet orbit onyx onyx kindle quartz auburn falcon indigo pewter #8715ec4e
<<<ANSWER END>>>
<<<ANSWER key=K00045>>>
orbit spruce saffron cedar ember garnet cobalt pewter crimson orbit verdant falcon quartz pewter meadow pewter pewter marble verdant willow lantern saffron willow quartz #e3625ecb
<<<ANSWER END>>>
<<<ANSWER key=K00061>>>
lattice thistle kindle ember boulder cobalt harbor saffron vellum fathom willow cinder cobalt marble vellum copper crimson onyx orbit spruce fathom lattice falcon auburn #a7b05fe8
<<<ANSWER END>>>
<<<ANSWER key=K00114>>>
garnet copper meadow mistral spruce pewter cinder pewter cobble saffron glacier boulder verdant quartz cobble verdant orbit zebra thistle garnet crimson ember harbor vellum #d17464a7
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
