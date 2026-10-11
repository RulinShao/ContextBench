#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00130>>>
russet orbit cobalt saffron auburn quartz onyx cedar kindle falcon mistral crimson auburn copper russet mistral cobble copper fathom glacier auburn saffron nimbus crimson #1ea1ca12
<<<ANSWER END>>>
<<<ANSWER key=K10480>>>
fathom falcon pewter quartz vellum saffron glacier lantern thistle orbit marble saffron auburn mistral pewter thistle verdant indigo verdant copper ember vellum thistle quartz #80ee35ea
<<<ANSWER END>>>
<<<ANSWER key=K11370>>>
verdant lattice glacier nimbus meadow boulder mistral mistral cinder mistral pewter meadow onyx fathom falcon verdant garnet garnet pewter ember trellis marble cobalt kindle #9b507f16
<<<ANSWER END>>>
<<<ANSWER key=K07197>>>
fathom cobalt nimbus thistle pewter russet marble saffron copper saffron kindle quartz glacier thistle ember pewter indigo saffron cobalt orbit russet auburn mistral willow #d637776f
<<<ANSWER END>>>
<<<ANSWER key=K03006>>>
quartz kindle quartz fathom lantern kindle harbor pewter thistle trellis cedar zebra willow copper willow zebra lantern quartz kindle crimson boulder harbor onyx zebra #8032c224
<<<ANSWER END>>>
<<<ANSWER key=K07231>>>
auburn russet quartz vellum glacier kindle crimson pewter willow orbit marble onyx zebra lattice cobalt ember cinder zebra willow glacier orbit zebra orbit zebra #17b12e7b
<<<ANSWER END>>>
<<<ANSWER key=K10500>>>
orbit meadow ember lattice quartz nimbus boulder marble verdant lantern orbit russet verdant nimbus trellis orbit orbit zebra cinder kindle crimson ember cobalt garnet #d7e865f4
<<<ANSWER END>>>
<<<ANSWER key=K00994>>>
glacier kindle spruce fathom saffron thistle onyx harbor falcon marble harbor cinder crimson lattice auburn saffron harbor garnet onyx russet boulder kindle pewter thistle #b6f7bc4f
<<<ANSWER END>>>
<<<ANSWER key=K07144>>>
ember spruce indigo cedar indigo zebra lattice vellum trellis pewter harbor mistral glacier auburn cobalt trellis harbor thistle mistral cobble kindle cobble boulder boulder #a1e38d21
<<<ANSWER END>>>
<<<ANSWER key=K03563>>>
cedar cinder indigo copper trellis mistral willow vellum falcon lattice indigo thistle onyx spruce thistle saffron kindle russet thistle crimson fathom harbor cinder fathom #466c8c1b
<<<ANSWER END>>>
<<<ANSWER key=K11391>>>
falcon cedar lattice zebra russet zebra russet orbit quartz nimbus orbit lattice saffron ember harbor cinder onyx boulder cobble onyx vellum orbit garnet nimbus #a6ed2436
<<<ANSWER END>>>
<<<ANSWER key=K05275>>>
spruce quartz cobalt falcon cedar kindle pewter willow auburn cedar thistle onyx verdant cobble pewter cedar willow cedar lattice meadow ember copper onyx cedar #a9188b3f
<<<ANSWER END>>>
<<<ANSWER key=K03886>>>
fathom vellum auburn russet verdant auburn cinder russet pewter thistle lattice mistral saffron ember garnet thistle saffron garnet auburn glacier cobalt lantern garnet spruce #93f43aa3
<<<ANSWER END>>>
<<<ANSWER key=K12530>>>
indigo cobble garnet trellis mistral cedar crimson spruce boulder spruce orbit copper meadow mistral marble nimbus quartz meadow boulder mistral harbor cobalt ember willow #0cde08fb
<<<ANSWER END>>>
<<<ANSWER key=K04547>>>
harbor crimson onyx trellis harbor cedar harbor ember orbit ember ember spruce cinder mistral crimson cinder trellis kindle spruce lantern falcon pewter willow willow #bccd447c
<<<ANSWER END>>>
<<<ANSWER key=K09604>>>
onyx vellum harbor harbor fathom auburn nimbus willow cobble trellis russet lantern ember cinder saffron lantern indigo vellum vellum copper spruce spruce lattice lattice #5f8bcfb0
<<<ANSWER END>>>
<<<ANSWER key=K13025>>>
verdant onyx zebra saffron willow kindle willow lattice boulder ember cobalt verdant cobble thistle crimson trellis pewter ember falcon glacier mistral spruce vellum saffron #de4259f1
<<<ANSWER END>>>
<<<ANSWER key=K00733>>>
cobalt harbor fathom cobble saffron harbor cinder fathom willow garnet spruce russet orbit saffron zebra copper marble ember indigo cobalt cinder ember copper cinder #803b3a71
<<<ANSWER END>>>
<<<ANSWER key=K10919>>>
lantern falcon onyx kindle trellis marble copper ember verdant cobble russet indigo ember auburn ember ember marble boulder verdant marble harbor pewter thistle kindle #4e3fffb4
<<<ANSWER END>>>
<<<ANSWER key=K11988>>>
russet pewter quartz indigo quartz saffron lattice orbit onyx garnet copper glacier ember ember meadow garnet thistle meadow indigo cobalt falcon copper indigo orbit #ffbcd27d
<<<ANSWER END>>>
<<<ANSWER key=K06998>>>
garnet cobalt vellum boulder indigo meadow harbor cobble trellis cedar cedar nimbus marble saffron mistral fathom auburn thistle cobble boulder willow quartz cinder kindle #25ff22da
<<<ANSWER END>>>
<<<ANSWER key=K01918>>>
garnet boulder nimbus verdant nimbus glacier garnet vellum auburn mistral cobble russet marble lattice cobalt auburn auburn zebra marble harbor falcon russet crimson thistle #390b4812
<<<ANSWER END>>>
<<<ANSWER key=K08903>>>
crimson crimson ember cobalt vellum willow cobble pewter indigo cinder lattice cinder falcon falcon quartz marble cinder indigo harbor thistle vellum cobalt ember garnet #8eb3e7a7
<<<ANSWER END>>>
<<<ANSWER key=K01202>>>
copper harbor spruce vellum indigo saffron harbor orbit marble spruce orbit russet mistral verdant boulder mistral cedar cedar lantern lattice fathom cobble willow falcon #be348696
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
