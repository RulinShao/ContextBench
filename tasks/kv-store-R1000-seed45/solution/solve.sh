#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00485>>>
lattice cinder willow trellis garnet glacier marble trellis trellis lantern lantern pewter willow falcon vellum cedar cinder saffron willow thistle orbit thistle orbit cobble #f7c0e0bc
<<<ANSWER END>>>
<<<ANSWER key=K00728>>>
pewter saffron lantern cinder saffron cobalt harbor lantern orbit onyx fathom crimson ember saffron vellum russet willow trellis indigo auburn kindle cobalt orbit thistle #68f50ff8
<<<ANSWER END>>>
<<<ANSWER key=K00808>>>
marble glacier willow garnet lattice zebra garnet boulder cobble auburn zebra saffron ember cinder crimson harbor russet boulder orbit quartz pewter zebra trellis vellum #c18c6257
<<<ANSWER END>>>
<<<ANSWER key=K00877>>>
orbit glacier verdant copper boulder russet pewter onyx russet cobble auburn nimbus nimbus fathom quartz meadow harbor fathom russet pewter crimson trellis mistral saffron #fb30a3b2
<<<ANSWER END>>>
<<<ANSWER key=K00053>>>
garnet boulder fathom willow lattice cedar vellum russet lattice saffron falcon indigo fathom cobble meadow onyx verdant willow garnet meadow falcon verdant copper cedar #8eaf3715
<<<ANSWER END>>>
<<<ANSWER key=K00219>>>
spruce verdant quartz glacier zebra lattice boulder ember zebra lattice boulder vellum auburn willow saffron orbit spruce russet crimson russet cinder saffron russet trellis #c0bffd2e
<<<ANSWER END>>>
<<<ANSWER key=K00287>>>
willow harbor spruce marble onyx glacier cobble kindle copper saffron lattice fathom cobalt willow auburn mistral kindle pewter russet pewter trellis mistral falcon willow #38239238
<<<ANSWER END>>>
<<<ANSWER key=K00920>>>
vellum russet marble vellum fathom indigo boulder saffron cobble verdant verdant orbit orbit auburn kindle lattice auburn mistral zebra cobble spruce zebra quartz crimson #84d722b6
<<<ANSWER END>>>
<<<ANSWER key=K00529>>>
meadow orbit copper trellis fathom pewter pewter lantern mistral garnet spruce quartz mistral crimson ember nimbus cedar cobalt marble lantern vellum copper cinder meadow #3449084c
<<<ANSWER END>>>
<<<ANSWER key=K00202>>>
zebra orbit cedar lattice crimson pewter cedar pewter falcon quartz trellis verdant indigo spruce meadow auburn copper crimson crimson zebra ember zebra trellis cobalt #99e5c2b0
<<<ANSWER END>>>
<<<ANSWER key=K00395>>>
mistral falcon saffron meadow cobalt cedar marble indigo indigo verdant copper crimson glacier trellis cobble kindle cedar vellum fathom willow fathom cinder indigo boulder #5e3d59c4
<<<ANSWER END>>>
<<<ANSWER key=K00340>>>
fathom auburn boulder spruce fathom cobble orbit orbit crimson verdant willow crimson boulder garnet glacier cedar cedar lattice zebra spruce nimbus harbor willow copper #7fc160d8
<<<ANSWER END>>>
<<<ANSWER key=K00917>>>
crimson crimson mistral indigo willow falcon kindle cinder indigo harbor zebra spruce trellis russet thistle trellis garnet vellum auburn cobble zebra ember onyx cinder #16962241
<<<ANSWER END>>>
<<<ANSWER key=K00776>>>
zebra meadow boulder garnet verdant onyx spruce orbit ember cinder verdant willow zebra nimbus cobble orbit crimson boulder auburn glacier nimbus lantern thistle falcon #6161fb62
<<<ANSWER END>>>
<<<ANSWER key=K00207>>>
mistral quartz russet auburn lattice verdant onyx ember glacier russet cobble spruce cobble trellis quartz quartz verdant kindle marble spruce mistral lantern falcon vellum #02147e3e
<<<ANSWER END>>>
<<<ANSWER key=K00967>>>
harbor willow glacier vellum crimson copper garnet ember willow kindle cobalt ember pewter lattice marble cinder cinder zebra thistle russet thistle indigo boulder spruce #847a2783
<<<ANSWER END>>>
<<<ANSWER key=K00638>>>
fathom orbit indigo pewter zebra fathom russet zebra fathom onyx kindle trellis orbit crimson thistle vellum willow russet pewter boulder glacier mistral copper indigo #1b2bc4a1
<<<ANSWER END>>>
<<<ANSWER key=K00310>>>
mistral ember lattice saffron orbit willow falcon fathom thistle pewter pewter marble pewter cedar cinder pewter crimson thistle garnet boulder thistle cedar onyx zebra #66825556
<<<ANSWER END>>>
<<<ANSWER key=K00121>>>
ember indigo saffron cinder zebra boulder lantern vellum cobble verdant lantern lantern zebra fathom mistral cedar cobble verdant copper spruce russet lattice cobble falcon #4b39ff1a
<<<ANSWER END>>>
<<<ANSWER key=K00794>>>
harbor lantern russet cobalt trellis quartz meadow pewter indigo falcon cobble orbit indigo boulder meadow cobalt thistle orbit fathom boulder garnet marble vellum lantern #595c5de9
<<<ANSWER END>>>
<<<ANSWER key=K00183>>>
mistral spruce cinder verdant russet spruce cobalt orbit lantern falcon garnet spruce ember zebra glacier auburn mistral verdant boulder copper lantern verdant glacier nimbus #d1f64a17
<<<ANSWER END>>>
<<<ANSWER key=K00036>>>
willow nimbus willow lantern harbor cedar boulder meadow russet thistle marble nimbus nimbus marble onyx fathom auburn verdant copper harbor harbor russet saffron onyx #6e50c7f4
<<<ANSWER END>>>
<<<ANSWER key=K00825>>>
lattice spruce verdant cedar cobble lantern garnet marble lattice spruce verdant auburn kindle kindle harbor copper zebra trellis lantern cobble copper indigo thistle saffron #26c0bfbb
<<<ANSWER END>>>
<<<ANSWER key=K00626>>>
spruce kindle verdant zebra copper marble boulder verdant kindle lantern verdant glacier harbor russet lattice falcon lantern ember onyx auburn lantern harbor harbor pewter #1cfa7a29
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
