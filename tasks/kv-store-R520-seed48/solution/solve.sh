#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00131>>>
copper mistral orbit cobble spruce kindle cinder quartz marble cedar auburn willow quartz vellum copper auburn cobble auburn fathom indigo auburn lantern cedar mistral #a294b912
<<<ANSWER END>>>
<<<ANSWER key=K00211>>>
auburn garnet boulder onyx zebra mistral lantern harbor thistle mistral glacier meadow verdant auburn cinder pewter thistle cobble boulder cedar lattice onyx auburn mistral #28ef1cc1
<<<ANSWER END>>>
<<<ANSWER key=K00288>>>
saffron russet indigo pewter kindle auburn onyx pewter harbor orbit fathom willow thistle lattice zebra garnet onyx boulder meadow lantern falcon harbor marble indigo #720269cb
<<<ANSWER END>>>
<<<ANSWER key=K00485>>>
spruce cobble mistral vellum willow cobble nimbus quartz saffron cobalt pewter harbor lattice zebra lattice cinder auburn willow falcon indigo verdant zebra cobalt cobalt #72a502ee
<<<ANSWER END>>>
<<<ANSWER key=K00503>>>
cobble fathom ember russet quartz cobalt verdant kindle willow mistral trellis meadow crimson glacier russet auburn harbor marble glacier cedar nimbus verdant indigo garnet #647e4da1
<<<ANSWER END>>>
<<<ANSWER key=K00002>>>
cobble ember ember marble willow verdant russet mistral glacier cinder ember lantern lattice cinder onyx glacier lantern spruce russet cinder indigo willow lattice cedar #0526c5c3
<<<ANSWER END>>>
<<<ANSWER key=K00190>>>
copper mistral cinder harbor cobalt willow saffron garnet lattice lattice cobble cobalt zebra garnet garnet orbit mistral onyx saffron copper cinder copper pewter pewter #bf528ae3
<<<ANSWER END>>>
<<<ANSWER key=K00254>>>
saffron quartz ember russet kindle glacier crimson verdant indigo quartz thistle spruce kindle willow mistral marble lantern quartz kindle glacier onyx harbor russet onyx #9a47340d
<<<ANSWER END>>>
<<<ANSWER key=K00021>>>
marble cinder meadow cobalt trellis zebra nimbus marble mistral pewter falcon quartz lantern onyx mistral trellis fathom russet kindle boulder russet harbor falcon nimbus #76d2d234
<<<ANSWER END>>>
<<<ANSWER key=K00053>>>
cobble cobble orbit pewter mistral pewter verdant falcon ember zebra verdant falcon spruce marble vellum lantern cinder crimson pewter trellis cedar cinder lantern auburn #5693bb1f
<<<ANSWER END>>>
<<<ANSWER key=K00093>>>
boulder crimson auburn cinder cobble garnet glacier pewter cedar cedar zebra russet quartz cobalt quartz auburn lantern vellum indigo lattice cobalt cobalt russet lattice #06682bb6
<<<ANSWER END>>>
<<<ANSWER key=K00474>>>
onyx russet lantern meadow lantern trellis kindle falcon quartz vellum copper lantern cedar falcon cinder zebra cobble quartz willow boulder cobalt willow cinder mistral #1e260138
<<<ANSWER END>>>
<<<ANSWER key=K00056>>>
trellis verdant vellum harbor ember kindle quartz orbit verdant garnet garnet quartz glacier zebra verdant kindle zebra nimbus glacier cobalt thistle pewter indigo indigo #4de9f12a
<<<ANSWER END>>>
<<<ANSWER key=K00073>>>
lattice cobble saffron cedar falcon crimson nimbus boulder mistral willow crimson marble nimbus garnet fathom boulder boulder nimbus quartz vellum lantern crimson willow cedar #f290f0c3
<<<ANSWER END>>>
<<<ANSWER key=K00456>>>
ember glacier cinder garnet onyx lattice glacier quartz falcon falcon zebra harbor willow crimson cinder saffron auburn orbit quartz copper meadow mistral spruce indigo #8e3df47d
<<<ANSWER END>>>
<<<ANSWER key=K00295>>>
auburn verdant russet mistral meadow onyx harbor cobalt indigo lattice boulder garnet nimbus indigo zebra copper thistle mistral cedar crimson pewter lantern garnet kindle #75b88c5a
<<<ANSWER END>>>
<<<ANSWER key=K00350>>>
harbor pewter cobalt spruce falcon mistral boulder verdant nimbus kindle auburn spruce copper quartz lantern trellis lattice pewter glacier auburn nimbus verdant onyx lantern #5bbed123
<<<ANSWER END>>>
<<<ANSWER key=K00233>>>
indigo fathom willow quartz lantern cobble russet mistral glacier kindle auburn willow russet russet trellis fathom indigo lantern boulder harbor cinder pewter fathom marble #b584ff95
<<<ANSWER END>>>
<<<ANSWER key=K00421>>>
cobble onyx crimson lattice copper russet falcon cinder indigo meadow zebra indigo mistral orbit fathom marble saffron orbit orbit indigo falcon cobalt pewter vellum #30a1d65b
<<<ANSWER END>>>
<<<ANSWER key=K00087>>>
russet garnet cinder lantern cobalt cobalt indigo auburn vellum harbor falcon meadow trellis boulder zebra mistral trellis lattice garnet saffron spruce vellum glacier thistle #e1d24af0
<<<ANSWER END>>>
<<<ANSWER key=K00493>>>
falcon lantern marble spruce boulder lattice meadow lantern harbor mistral saffron quartz glacier cobalt pewter mistral falcon saffron lattice marble nimbus lantern garnet saffron #1373fe72
<<<ANSWER END>>>
<<<ANSWER key=K00416>>>
marble lattice russet cedar boulder indigo garnet cobalt cobalt pewter lattice crimson fathom cedar lattice orbit fathom boulder falcon boulder glacier cedar auburn zebra #da5a17d6
<<<ANSWER END>>>
<<<ANSWER key=K00392>>>
boulder kindle auburn spruce quartz harbor russet quartz nimbus cinder garnet marble orbit vellum zebra lattice verdant willow quartz boulder spruce lantern cinder willow #c47cf62a
<<<ANSWER END>>>
<<<ANSWER key=K00418>>>
falcon saffron meadow vellum cobble garnet fathom cobble quartz auburn fathom falcon cobble thistle fathom auburn harbor russet kindle harbor mistral vellum ember cinder #541e570d
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
