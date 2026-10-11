#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K01527>>>
cobalt crimson falcon boulder spruce crimson cinder glacier lantern orbit vellum cedar russet trellis zebra ember harbor orbit lantern thistle quartz meadow vellum nimbus #73b5b68c
<<<ANSWER END>>>
<<<ANSWER key=K00722>>>
cobble lattice cobble cobalt ember kindle garnet verdant harbor copper glacier onyx quartz lantern quartz nimbus glacier garnet orbit cinder nimbus ember mistral nimbus #71482332
<<<ANSWER END>>>
<<<ANSWER key=K01169>>>
mistral auburn lantern cobalt crimson ember vellum auburn verdant cedar zebra kindle spruce indigo marble willow auburn verdant zebra nimbus ember lattice willow indigo #8d62ec8c
<<<ANSWER END>>>
<<<ANSWER key=K01423>>>
crimson kindle vellum onyx zebra kindle ember willow meadow saffron ember ember russet mistral lattice harbor lattice trellis kindle cobble thistle kindle vellum glacier #4a59f9e8
<<<ANSWER END>>>
<<<ANSWER key=K00203>>>
cinder cobble lattice pewter cedar nimbus saffron marble meadow mistral cobalt harbor falcon lattice lattice ember russet harbor thistle cinder zebra pewter zebra falcon #5b885cbf
<<<ANSWER END>>>
<<<ANSWER key=K01698>>>
fathom willow falcon garnet russet cinder quartz thistle marble crimson quartz marble mistral indigo cobalt saffron cedar indigo indigo thistle garnet nimbus cobble kindle #63632fed
<<<ANSWER END>>>
<<<ANSWER key=K00689>>>
saffron willow auburn glacier marble zebra indigo cobble cobalt zebra quartz lantern pewter orbit willow ember auburn copper meadow meadow onyx indigo ember russet #3a74911f
<<<ANSWER END>>>
<<<ANSWER key=K01723>>>
copper russet thistle marble copper crimson falcon kindle boulder crimson copper vellum quartz copper saffron nimbus saffron russet cinder auburn falcon lantern glacier saffron #393c1ef5
<<<ANSWER END>>>
<<<ANSWER key=K01870>>>
marble spruce lantern pewter ember trellis nimbus mistral garnet lattice zebra spruce orbit falcon mistral marble russet spruce mistral copper harbor thistle quartz trellis #c54f45b9
<<<ANSWER END>>>
<<<ANSWER key=K01720>>>
harbor fathom glacier zebra fathom willow cedar cobalt cedar vellum lattice saffron auburn harbor cobalt thistle lantern vellum cinder kindle garnet garnet thistle crimson #8f0bcdd6
<<<ANSWER END>>>
<<<ANSWER key=K00913>>>
thistle garnet zebra spruce meadow saffron cedar cedar auburn crimson thistle verdant lattice saffron indigo verdant auburn kindle glacier fathom cobble lattice glacier lattice #68bc8b76
<<<ANSWER END>>>
<<<ANSWER key=K01483>>>
cobble crimson auburn boulder fathom nimbus trellis thistle meadow nimbus cinder meadow pewter orbit kindle ember fathom cinder nimbus garnet vellum marble indigo lattice #aec6f92f
<<<ANSWER END>>>
<<<ANSWER key=K00231>>>
falcon willow glacier nimbus glacier quartz auburn kindle saffron spruce crimson ember zebra indigo crimson copper spruce marble mistral trellis zebra cobalt mistral verdant #9ee3fe04
<<<ANSWER END>>>
<<<ANSWER key=K00925>>>
willow vellum cobalt cobble verdant garnet lantern cedar trellis cobalt orbit mistral kindle thistle lantern ember cobble falcon trellis lantern orbit vellum falcon glacier #867c722d
<<<ANSWER END>>>
<<<ANSWER key=K00056>>>
saffron lantern fathom mistral saffron nimbus fathom lantern fathom trellis trellis onyx lattice verdant falcon boulder pewter verdant spruce lattice pewter quartz copper fathom #30c15196
<<<ANSWER END>>>
<<<ANSWER key=K00641>>>
glacier fathom nimbus russet indigo willow garnet thistle harbor nimbus thistle orbit garnet saffron garnet falcon willow lantern indigo russet mistral zebra lantern cinder #d07cadb2
<<<ANSWER END>>>
<<<ANSWER key=K00808>>>
marble trellis meadow garnet auburn garnet fathom auburn boulder trellis orbit willow verdant copper fathom copper fathom thistle orbit nimbus lattice nimbus onyx meadow #c3173922
<<<ANSWER END>>>
<<<ANSWER key=K00393>>>
meadow zebra garnet crimson cinder pewter kindle harbor glacier boulder marble cobble meadow cedar garnet fathom glacier cinder thistle meadow quartz cinder spruce saffron #ed00c940
<<<ANSWER END>>>
<<<ANSWER key=K00400>>>
indigo verdant kindle lattice indigo nimbus cobalt trellis pewter lattice pewter kindle cobalt verdant orbit mistral trellis saffron harbor saffron trellis crimson fathom pewter #b9f476bf
<<<ANSWER END>>>
<<<ANSWER key=K00690>>>
saffron zebra cinder trellis vellum spruce fathom lantern fathom ember indigo ember nimbus meadow crimson orbit indigo indigo quartz mistral auburn verdant auburn copper #5d8c5ce3
<<<ANSWER END>>>
<<<ANSWER key=K01049>>>
kindle lattice lattice meadow copper kindle marble falcon marble ember quartz falcon mistral copper verdant harbor cinder spruce lantern zebra ember crimson saffron lantern #eb5b3101
<<<ANSWER END>>>
<<<ANSWER key=K01144>>>
saffron russet auburn ember lattice trellis mistral nimbus cobble trellis falcon crimson kindle thistle mistral falcon kindle auburn willow ember lattice orbit spruce cobalt #619205b6
<<<ANSWER END>>>
<<<ANSWER key=K01233>>>
cedar quartz fathom cedar boulder orbit willow boulder lattice trellis willow nimbus harbor glacier meadow pewter ember pewter thistle marble trellis willow zebra orbit #813a264b
<<<ANSWER END>>>
<<<ANSWER key=K00879>>>
auburn boulder auburn nimbus russet kindle lattice glacier thistle kindle indigo nimbus spruce pewter trellis meadow vellum pewter meadow marble cobble vellum cobble auburn #676a6441
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
