#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00438>>>
cedar boulder spruce kindle verdant copper onyx meadow falcon copper trellis trellis cobalt quartz willow falcon verdant saffron cobble kindle thistle lantern trellis boulder #118dc7ec
<<<ANSWER END>>>
<<<ANSWER key=K00326>>>
vellum glacier harbor onyx lantern pewter copper orbit meadow saffron mistral harbor zebra cinder russet glacier garnet falcon pewter verdant cobalt auburn auburn onyx #345a4052
<<<ANSWER END>>>
<<<ANSWER key=K00104>>>
saffron cobalt thistle auburn russet russet fathom mistral indigo auburn vellum copper meadow lattice spruce saffron thistle mistral vellum quartz russet willow copper orbit #3fc14bee
<<<ANSWER END>>>
<<<ANSWER key=K00306>>>
crimson boulder auburn onyx nimbus nimbus saffron thistle orbit vellum zebra lattice cinder lattice quartz cobble garnet pewter indigo cinder onyx garnet copper copper #594cece6
<<<ANSWER END>>>
<<<ANSWER key=K00229>>>
meadow quartz saffron orbit fathom vellum mistral ember vellum cobalt orbit meadow spruce cobalt trellis vellum lantern marble cobalt copper onyx zebra trellis thistle #3956b5c6
<<<ANSWER END>>>
<<<ANSWER key=K00424>>>
russet mistral onyx onyx crimson marble nimbus thistle meadow spruce ember zebra garnet saffron meadow vellum nimbus marble trellis willow nimbus orbit orbit pewter #ede1530b
<<<ANSWER END>>>
<<<ANSWER key=K00076>>>
mistral ember mistral falcon lantern mistral willow trellis fathom russet lantern cobalt fathom mistral indigo russet nimbus pewter pewter verdant cobalt cobble ember crimson #84d4c2d9
<<<ANSWER END>>>
<<<ANSWER key=K00159>>>
cobble nimbus lantern russet auburn indigo lantern boulder auburn cinder glacier ember thistle mistral verdant cobble cobalt pewter nimbus cobalt cedar meadow auburn harbor #a48007b3
<<<ANSWER END>>>
<<<ANSWER key=K00175>>>
meadow garnet auburn onyx falcon harbor mistral crimson quartz auburn lattice spruce auburn boulder quartz garnet fathom willow glacier verdant lantern spruce trellis nimbus #6f96a8a9
<<<ANSWER END>>>
<<<ANSWER key=K00464>>>
quartz thistle boulder verdant ember nimbus cinder cedar kindle boulder saffron cinder garnet onyx meadow willow mistral kindle nimbus kindle cobalt spruce nimbus falcon #f4bb1653
<<<ANSWER END>>>
<<<ANSWER key=K00291>>>
vellum zebra cedar russet ember indigo cinder copper cedar pewter willow mistral quartz boulder crimson spruce cobalt willow cinder meadow boulder spruce nimbus garnet #bf6f87e5
<<<ANSWER END>>>
<<<ANSWER key=K00336>>>
ember indigo marble quartz garnet ember marble spruce boulder ember spruce marble indigo pewter russet verdant lattice saffron cinder nimbus onyx copper copper trellis #06ef4f8f
<<<ANSWER END>>>
<<<ANSWER key=K00512>>>
willow saffron verdant garnet auburn kindle russet mistral meadow vellum vellum auburn glacier quartz marble ember trellis crimson fathom cedar thistle vellum pewter saffron #46960f86
<<<ANSWER END>>>
<<<ANSWER key=K00235>>>
crimson indigo meadow pewter quartz spruce copper meadow cedar zebra cobalt garnet fathom thistle fathom onyx kindle boulder pewter saffron fathom lattice russet pewter #ebd68224
<<<ANSWER END>>>
<<<ANSWER key=K00365>>>
verdant thistle verdant nimbus boulder harbor crimson cobalt vellum marble boulder pewter onyx willow trellis onyx glacier copper auburn lantern marble meadow lattice ember #f94c12ce
<<<ANSWER END>>>
<<<ANSWER key=K00455>>>
auburn verdant copper ember cinder kindle pewter auburn garnet glacier trellis cobalt onyx harbor cinder cedar vellum cinder harbor crimson fathom spruce verdant willow #7a722146
<<<ANSWER END>>>
<<<ANSWER key=K00123>>>
crimson russet cinder nimbus cedar onyx lattice marble orbit zebra meadow onyx cedar indigo auburn lattice glacier saffron indigo mistral indigo auburn thistle cobble #92dfb910
<<<ANSWER END>>>
<<<ANSWER key=K00268>>>
lantern ember harbor mistral crimson cedar thistle vellum vellum saffron ember zebra falcon onyx quartz kindle cobalt marble fathom cinder pewter mistral garnet falcon #6f73f965
<<<ANSWER END>>>
<<<ANSWER key=K00277>>>
trellis falcon harbor zebra cedar thistle indigo thistle vellum glacier cobalt harbor onyx meadow cinder mistral verdant spruce fathom russet lantern cinder auburn willow #4a23a3ee
<<<ANSWER END>>>
<<<ANSWER key=K00003>>>
meadow saffron fathom mistral russet cinder lattice zebra indigo kindle russet glacier crimson falcon pewter copper cinder nimbus nimbus russet cedar quartz thistle quartz #3d790c98
<<<ANSWER END>>>
<<<ANSWER key=K00240>>>
cinder cobalt lantern lantern falcon verdant willow cobble cedar cinder lattice garnet cinder copper saffron willow crimson marble mistral lattice garnet onyx russet lantern #cb047f7a
<<<ANSWER END>>>
<<<ANSWER key=K00249>>>
saffron verdant falcon auburn copper cedar quartz glacier pewter ember mistral cedar willow pewter cinder indigo spruce willow auburn glacier auburn russet nimbus fathom #8b065c74
<<<ANSWER END>>>
<<<ANSWER key=K00121>>>
fathom pewter willow indigo boulder marble crimson verdant russet indigo lantern lattice cobble mistral mistral falcon saffron ember russet fathom harbor ember garnet orbit #5f307f97
<<<ANSWER END>>>
<<<ANSWER key=K00452>>>
mistral zebra marble auburn boulder onyx garnet cedar indigo boulder cobalt nimbus garnet thistle thistle fathom willow ember thistle lantern fathom cinder thistle copper #0116314c
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
