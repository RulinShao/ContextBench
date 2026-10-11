#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00435>>>
trellis cobble meadow copper auburn marble saffron kindle copper cobalt quartz falcon auburn harbor zebra quartz zebra cobalt fathom cedar lantern willow lantern vellum #c77d7a6d
<<<ANSWER END>>>
<<<ANSWER key=K00446>>>
cinder russet boulder cobalt indigo trellis vellum russet meadow mistral cinder saffron pewter copper zebra lattice cinder cinder glacier thistle cobble meadow kindle indigo #bda5f395
<<<ANSWER END>>>
<<<ANSWER key=K00320>>>
cinder harbor orbit lantern glacier garnet lattice spruce mistral onyx copper pewter saffron meadow spruce quartz auburn fathom thistle zebra lantern willow nimbus falcon #d09b194c
<<<ANSWER END>>>
<<<ANSWER key=K00485>>>
kindle pewter cedar lantern kindle falcon trellis lattice garnet pewter zebra verdant boulder fathom kindle quartz saffron indigo ember onyx copper fathom copper thistle #b2624d46
<<<ANSWER END>>>
<<<ANSWER key=K00038>>>
cinder harbor kindle boulder mistral zebra glacier copper boulder crimson cedar quartz crimson cinder verdant cobble lantern auburn cobalt pewter lantern ember crimson orbit #f232ef00
<<<ANSWER END>>>
<<<ANSWER key=K00224>>>
boulder onyx cobalt boulder mistral marble pewter cedar nimbus cinder russet lattice cobble verdant lantern falcon cobble glacier orbit glacier onyx orbit glacier nimbus #d00e7dcd
<<<ANSWER END>>>
<<<ANSWER key=K00215>>>
nimbus copper vellum russet spruce cinder saffron orbit meadow trellis mistral crimson kindle orbit zebra meadow fathom thistle russet zebra saffron crimson trellis trellis #a4514e40
<<<ANSWER END>>>
<<<ANSWER key=K00007>>>
willow glacier marble lantern pewter russet willow boulder vellum trellis russet vellum trellis cobble cinder cinder kindle meadow pewter willow crimson thistle cobalt marble #8c152e06
<<<ANSWER END>>>
<<<ANSWER key=K00184>>>
harbor ember marble lantern orbit saffron nimbus lattice mistral kindle fathom spruce kindle mistral cedar quartz garnet lattice indigo spruce meadow zebra nimbus nimbus #ceb1cf6c
<<<ANSWER END>>>
<<<ANSWER key=K00130>>>
cobalt trellis zebra lattice kindle ember kindle lattice nimbus ember glacier lantern cobalt harbor meadow glacier verdant nimbus willow cobble cinder thistle cedar fathom #2c728023
<<<ANSWER END>>>
<<<ANSWER key=K00502>>>
cobalt thistle zebra cinder fathom russet cedar lattice russet cedar saffron nimbus willow cobalt russet harbor quartz saffron nimbus orbit mistral quartz quartz indigo #2a69c269
<<<ANSWER END>>>
<<<ANSWER key=K00361>>>
saffron auburn lantern cedar saffron verdant mistral kindle willow glacier glacier mistral saffron glacier spruce zebra nimbus nimbus fathom kindle marble lattice cedar quartz #74f6f300
<<<ANSWER END>>>
<<<ANSWER key=K00239>>>
russet auburn cobble cobalt quartz orbit russet cobalt vellum garnet glacier marble garnet lattice falcon marble onyx onyx kindle mistral fathom glacier russet russet #ba585224
<<<ANSWER END>>>
<<<ANSWER key=K00070>>>
willow spruce glacier cedar fathom indigo mistral meadow cobble falcon cobalt saffron thistle harbor russet fathom garnet cobalt verdant saffron glacier orbit fathom lantern #445d6fa6
<<<ANSWER END>>>
<<<ANSWER key=K00149>>>
auburn spruce copper garnet copper harbor verdant mistral willow orbit spruce orbit trellis meadow spruce copper copper cobble mistral lattice spruce marble trellis nimbus #f8f23da3
<<<ANSWER END>>>
<<<ANSWER key=K00012>>>
crimson copper pewter glacier ember onyx garnet orbit lantern cobalt marble thistle cedar pewter falcon zebra spruce zebra ember thistle trellis crimson meadow fathom #161ac7e1
<<<ANSWER END>>>
<<<ANSWER key=K00498>>>
nimbus kindle orbit spruce cobble thistle quartz ember ember vellum zebra vellum russet russet indigo indigo harbor lattice willow zebra pewter boulder crimson garnet #f93f24bb
<<<ANSWER END>>>
<<<ANSWER key=K00090>>>
harbor cinder glacier boulder onyx boulder auburn trellis fathom pewter kindle willow nimbus vellum verdant lattice orbit marble zebra russet willow quartz lantern cobalt #33ae25b4
<<<ANSWER END>>>
<<<ANSWER key=K00086>>>
zebra russet cedar cinder vellum vellum orbit garnet willow fathom nimbus lantern cinder thistle auburn orbit falcon fathom copper harbor cobble nimbus vellum meadow #ce25ed72
<<<ANSWER END>>>
<<<ANSWER key=K00176>>>
indigo willow cobalt nimbus saffron willow cobalt orbit thistle copper quartz crimson quartz kindle lantern mistral lattice indigo trellis boulder pewter boulder trellis quartz #391277b3
<<<ANSWER END>>>
<<<ANSWER key=K00111>>>
cedar spruce lantern quartz kindle thistle vellum fathom garnet falcon meadow harbor kindle kindle trellis zebra nimbus russet copper orbit nimbus saffron ember mistral #e24ee699
<<<ANSWER END>>>
<<<ANSWER key=K00147>>>
ember quartz vellum indigo thistle trellis harbor indigo harbor verdant mistral orbit quartz saffron lantern cobalt mistral orbit indigo vellum spruce lattice saffron spruce #7b4174a4
<<<ANSWER END>>>
<<<ANSWER key=K00427>>>
quartz cedar mistral onyx quartz ember zebra auburn trellis garnet pewter pewter cobalt ember crimson cobble cobalt crimson vellum pewter garnet thistle russet russet #c9d5eddf
<<<ANSWER END>>>
<<<ANSWER key=K00031>>>
falcon garnet zebra lantern saffron russet ember lantern verdant cedar pewter vellum glacier harbor fathom crimson fathom boulder fathom thistle fathom auburn russet trellis #5283b3f0
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
