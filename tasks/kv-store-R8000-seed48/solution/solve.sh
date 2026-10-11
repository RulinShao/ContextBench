#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K02062>>>
glacier lattice vellum meadow russet ember glacier meadow onyx ember willow vellum vellum cedar kindle cinder saffron cedar lattice cobble indigo thistle lantern nimbus #e69054ea
<<<ANSWER END>>>
<<<ANSWER key=K03744>>>
thistle pewter marble zebra cobalt cobble quartz mistral copper saffron nimbus crimson verdant cobble mistral cobble mistral pewter harbor cobalt cedar auburn crimson vellum #bcf4fd15
<<<ANSWER END>>>
<<<ANSWER key=K06605>>>
lantern spruce marble kindle boulder orbit thistle lattice orbit spruce orbit cobble onyx marble glacier nimbus meadow garnet onyx marble quartz orbit spruce nimbus #2af7cf9a
<<<ANSWER END>>>
<<<ANSWER key=K07294>>>
meadow glacier trellis crimson boulder onyx quartz mistral auburn zebra vellum indigo trellis thistle fathom russet harbor nimbus lattice cedar indigo quartz verdant willow #2ee9983e
<<<ANSWER END>>>
<<<ANSWER key=K00070>>>
boulder crimson willow thistle mistral lattice thistle willow cobble spruce crimson fathom vellum copper thistle willow harbor garnet indigo kindle kindle auburn copper copper #6ca033ad
<<<ANSWER END>>>
<<<ANSWER key=K01358>>>
vellum glacier willow lattice spruce cinder lantern cobalt crimson kindle trellis willow saffron verdant boulder vellum indigo spruce auburn trellis cobalt willow cedar cinder #22d7a7fb
<<<ANSWER END>>>
<<<ANSWER key=K06402>>>
pewter thistle cobalt willow pewter mistral crimson orbit mistral vellum cedar trellis cinder pewter saffron auburn trellis spruce zebra harbor ember meadow glacier lattice #4b55b642
<<<ANSWER END>>>
<<<ANSWER key=K05255>>>
quartz copper lantern cobalt lattice saffron cobalt cobalt verdant zebra zebra cinder falcon kindle saffron saffron nimbus zebra copper saffron fathom thistle indigo meadow #763ec5fc
<<<ANSWER END>>>
<<<ANSWER key=K01608>>>
copper marble indigo lattice thistle willow garnet verdant glacier glacier indigo kindle crimson fathom copper vellum saffron saffron cinder crimson lantern mistral willow onyx #b4d6ec65
<<<ANSWER END>>>
<<<ANSWER key=K04748>>>
lattice lattice spruce falcon willow glacier nimbus quartz cedar zebra harbor harbor meadow vellum cobalt copper mistral cobble glacier lattice lantern saffron cobalt spruce #abe4fe0e
<<<ANSWER END>>>
<<<ANSWER key=K07474>>>
onyx willow zebra zebra nimbus lattice cobalt garnet willow orbit orbit auburn meadow marble boulder crimson vellum onyx mistral saffron indigo mistral mistral orbit #1f93bde6
<<<ANSWER END>>>
<<<ANSWER key=K04160>>>
russet lantern nimbus harbor spruce spruce kindle meadow ember willow trellis cobalt falcon meadow spruce garnet cobalt orbit meadow boulder garnet nimbus harbor ember #24c4e80a
<<<ANSWER END>>>
<<<ANSWER key=K04255>>>
cobalt cobble ember zebra fathom falcon russet russet russet willow lantern vellum harbor lattice boulder mistral copper cedar glacier glacier verdant mistral nimbus cobble #b62853e8
<<<ANSWER END>>>
<<<ANSWER key=K04727>>>
falcon falcon copper glacier saffron marble pewter copper glacier fathom harbor ember lantern glacier marble orbit zebra harbor nimbus russet cobble garnet cobble orbit #57e88ff9
<<<ANSWER END>>>
<<<ANSWER key=K02624>>>
nimbus onyx cinder nimbus willow orbit falcon garnet indigo zebra nimbus thistle meadow lattice lattice auburn kindle kindle copper kindle vellum onyx zebra meadow #20251cb2
<<<ANSWER END>>>
<<<ANSWER key=K05873>>>
cinder orbit willow trellis russet thistle harbor orbit quartz meadow vellum spruce boulder pewter pewter nimbus saffron cobble harbor crimson zebra garnet willow willow #ec18721b
<<<ANSWER END>>>
<<<ANSWER key=K01525>>>
cobalt marble meadow cinder harbor russet nimbus vellum nimbus glacier lantern crimson onyx copper russet pewter copper cedar trellis spruce cedar crimson harbor cinder #276e2a54
<<<ANSWER END>>>
<<<ANSWER key=K01854>>>
harbor pewter marble fathom ember copper vellum trellis verdant onyx mistral zebra cobble auburn onyx thistle kindle cinder willow spruce lattice orbit fathom cedar #bee9ee99
<<<ANSWER END>>>
<<<ANSWER key=K06885>>>
pewter copper onyx onyx nimbus glacier lattice quartz verdant mistral cinder willow zebra falcon pewter meadow auburn pewter crimson cinder fathom trellis harbor zebra #af5f3bdc
<<<ANSWER END>>>
<<<ANSWER key=K00504>>>
meadow vellum zebra willow copper russet quartz cobble falcon falcon mistral glacier glacier orbit kindle lantern ember nimbus marble cedar onyx garnet lattice quartz #c3671df7
<<<ANSWER END>>>
<<<ANSWER key=K07959>>>
zebra cinder cobalt willow auburn crimson marble onyx cinder quartz ember lantern glacier vellum cobalt crimson saffron verdant fathom glacier fathom trellis auburn copper #b188f957
<<<ANSWER END>>>
<<<ANSWER key=K05293>>>
vellum cobble saffron marble boulder kindle vellum mistral glacier harbor nimbus copper orbit boulder mistral fathom cobalt spruce cobble marble auburn cobble russet lattice #b04f0275
<<<ANSWER END>>>
<<<ANSWER key=K06215>>>
trellis garnet orbit harbor cinder vellum indigo mistral cinder crimson orbit cobble crimson fathom orbit cobalt marble zebra lattice cobalt lantern cedar nimbus mistral #95b5a42d
<<<ANSWER END>>>
<<<ANSWER key=K00005>>>
garnet glacier ember orbit meadow cedar quartz pewter thistle quartz falcon indigo glacier cedar quartz cinder zebra meadow cobalt auburn fathom lantern saffron willow #773e8f1b
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
