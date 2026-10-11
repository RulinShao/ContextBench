#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00062>>>
marble fathom fathom russet cedar cedar willow ember lantern kindle quartz lattice zebra ember lattice cobble cedar verdant kindle fathom cobble boulder harbor saffron #4fa29969
<<<ANSWER END>>>
<<<ANSWER key=K00257>>>
trellis cinder spruce vellum boulder copper quartz zebra pewter lattice saffron copper cedar zebra mistral lantern spruce cedar onyx meadow spruce kindle lantern falcon #47cb65d8
<<<ANSWER END>>>
<<<ANSWER key=K00092>>>
cedar ember indigo crimson harbor willow fathom spruce quartz glacier zebra auburn quartz russet nimbus pewter auburn onyx harbor willow spruce cinder trellis trellis #cb032f13
<<<ANSWER END>>>
<<<ANSWER key=K00512>>>
onyx cobble crimson mistral meadow willow cinder lantern zebra trellis verdant zebra auburn kindle auburn harbor zebra copper falcon orbit verdant kindle cobalt boulder #fb0e0979
<<<ANSWER END>>>
<<<ANSWER key=K00902>>>
verdant vellum harbor kindle lattice cobble vellum boulder meadow indigo willow cinder spruce harbor nimbus ember orbit quartz cobble russet cobble ember harbor boulder #81905f8d
<<<ANSWER END>>>
<<<ANSWER key=K00875>>>
fathom spruce cedar vellum orbit verdant indigo crimson cedar auburn mistral trellis kindle nimbus mistral glacier copper cedar harbor onyx garnet onyx glacier zebra #ccdbbb12
<<<ANSWER END>>>
<<<ANSWER key=K00661>>>
garnet quartz spruce crimson zebra pewter boulder cedar quartz willow onyx thistle indigo nimbus marble cedar orbit lattice indigo auburn kindle cinder mistral fathom #7085bf23
<<<ANSWER END>>>
<<<ANSWER key=K00808>>>
glacier willow cedar kindle indigo onyx fathom cobble ember saffron onyx zebra cedar trellis lantern orbit auburn harbor crimson cedar onyx russet spruce lattice #7713bb28
<<<ANSWER END>>>
<<<ANSWER key=K00889>>>
orbit meadow thistle copper cobalt cinder quartz vellum mistral thistle crimson trellis saffron orbit spruce spruce lattice willow onyx marble saffron copper falcon copper #f5d44cce
<<<ANSWER END>>>
<<<ANSWER key=K00536>>>
thistle orbit indigo lattice cobalt willow thistle lantern cedar ember auburn quartz boulder crimson cobalt thistle onyx kindle cinder marble copper trellis cobalt marble #e0b0231e
<<<ANSWER END>>>
<<<ANSWER key=K00142>>>
marble kindle indigo meadow cinder pewter pewter lattice kindle willow vellum verdant trellis copper saffron lattice zebra lattice lantern cobalt zebra crimson nimbus harbor #8141d296
<<<ANSWER END>>>
<<<ANSWER key=K00633>>>
auburn garnet verdant lattice spruce garnet harbor quartz trellis copper lattice falcon kindle zebra trellis auburn orbit harbor mistral marble cinder cinder meadow mistral #d9eb60c7
<<<ANSWER END>>>
<<<ANSWER key=K00874>>>
vellum quartz lattice zebra trellis lantern cedar cinder trellis marble garnet copper cinder thistle falcon orbit glacier harbor glacier kindle meadow vellum kindle thistle #c2bb12eb
<<<ANSWER END>>>
<<<ANSWER key=K00017>>>
lantern glacier auburn indigo lantern nimbus thistle garnet indigo cedar trellis crimson zebra nimbus copper cinder cinder boulder cinder kindle cobalt trellis lantern onyx #be44d348
<<<ANSWER END>>>
<<<ANSWER key=K00094>>>
thistle falcon nimbus kindle onyx nimbus willow cobble cobalt cedar cedar pewter harbor fathom marble verdant trellis marble glacier nimbus lantern thistle indigo vellum #3a46174c
<<<ANSWER END>>>
<<<ANSWER key=K00194>>>
pewter willow glacier lantern harbor orbit cobble nimbus russet garnet ember lattice ember falcon harbor trellis verdant marble kindle fathom willow copper auburn cobble #4d806a71
<<<ANSWER END>>>
<<<ANSWER key=K00984>>>
cinder fathom pewter verdant trellis copper zebra willow russet glacier cinder quartz pewter mistral orbit zebra verdant ember cobble nimbus willow copper meadow cedar #6dc2a282
<<<ANSWER END>>>
<<<ANSWER key=K00169>>>
marble russet trellis lantern cedar zebra vellum harbor quartz trellis cedar cobalt kindle mistral orbit willow marble verdant falcon spruce pewter saffron quartz thistle #9be2be29
<<<ANSWER END>>>
<<<ANSWER key=K00272>>>
zebra auburn marble onyx russet verdant marble willow thistle meadow glacier mistral lantern quartz boulder thistle auburn ember glacier verdant copper trellis indigo pewter #21dd2ff2
<<<ANSWER END>>>
<<<ANSWER key=K00747>>>
thistle russet saffron boulder cedar meadow falcon fathom nimbus fathom boulder verdant marble cinder onyx meadow cinder meadow harbor trellis kindle nimbus onyx vellum #15cf1605
<<<ANSWER END>>>
<<<ANSWER key=K00556>>>
willow saffron boulder cobble kindle trellis cobble glacier lattice harbor ember mistral boulder boulder cobalt saffron lattice copper crimson crimson fathom lantern copper indigo #e7e424f5
<<<ANSWER END>>>
<<<ANSWER key=K00163>>>
fathom harbor indigo marble zebra mistral saffron cobalt spruce cobble saffron trellis indigo vellum nimbus cinder garnet cobble auburn onyx thistle meadow thistle quartz #822453d9
<<<ANSWER END>>>
<<<ANSWER key=K00912>>>
auburn willow cedar cedar cobble marble orbit indigo kindle crimson willow lantern verdant crimson vellum mistral meadow nimbus ember vellum cobble russet pewter quartz #e59608b7
<<<ANSWER END>>>
<<<ANSWER key=K00540>>>
meadow trellis cinder garnet fathom falcon glacier kindle spruce saffron glacier copper garnet pewter ember nimbus mistral willow saffron willow boulder cobalt cobble quartz #e8f9824d
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
