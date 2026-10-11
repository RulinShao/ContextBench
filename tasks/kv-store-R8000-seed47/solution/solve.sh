#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K03633>>>
verdant mistral kindle cedar glacier spruce indigo crimson pewter cobble pewter auburn quartz lantern zebra cobble quartz fathom garnet cedar vellum trellis trellis harbor #bc6480db
<<<ANSWER END>>>
<<<ANSWER key=K05321>>>
russet boulder kindle glacier kindle mistral crimson mistral indigo auburn harbor willow spruce cobalt crimson harbor zebra marble verdant falcon crimson verdant saffron nimbus #f1d32ab7
<<<ANSWER END>>>
<<<ANSWER key=K07354>>>
indigo orbit spruce cobble thistle cobble glacier onyx verdant cinder cobble cedar russet meadow boulder quartz harbor harbor orbit indigo cedar trellis cedar onyx #777190d0
<<<ANSWER END>>>
<<<ANSWER key=K03680>>>
auburn marble mistral cobalt lantern russet verdant crimson orbit copper onyx marble auburn russet willow fathom pewter harbor boulder onyx cedar garnet trellis spruce #9057f0b0
<<<ANSWER END>>>
<<<ANSWER key=K04958>>>
mistral nimbus cedar crimson glacier cobble zebra meadow trellis glacier russet cobalt copper glacier boulder orbit cobble crimson mistral spruce ember vellum vellum auburn #42759196
<<<ANSWER END>>>
<<<ANSWER key=K02012>>>
falcon cedar nimbus zebra pewter willow russet mistral orbit cobalt onyx quartz zebra saffron trellis zebra mistral boulder thistle spruce glacier verdant harbor harbor #31c5bb03
<<<ANSWER END>>>
<<<ANSWER key=K07672>>>
ember nimbus thistle saffron thistle falcon cedar harbor falcon meadow nimbus trellis cedar harbor willow russet meadow lantern zebra glacier falcon onyx meadow crimson #c65b5199
<<<ANSWER END>>>
<<<ANSWER key=K05886>>>
indigo cobble nimbus willow lattice quartz cobalt quartz russet saffron trellis meadow nimbus cinder cobble copper verdant falcon mistral trellis harbor cobble willow meadow #fc02f574
<<<ANSWER END>>>
<<<ANSWER key=K00849>>>
cobalt saffron lattice indigo auburn fathom boulder cinder indigo thistle fathom pewter mistral cinder willow verdant cobalt meadow nimbus nimbus verdant garnet russet boulder #f86ec2d5
<<<ANSWER END>>>
<<<ANSWER key=K06516>>>
kindle marble nimbus verdant glacier russet garnet glacier vellum thistle garnet kindle marble ember willow vellum falcon crimson cinder willow verdant zebra russet trellis #42328206
<<<ANSWER END>>>
<<<ANSWER key=K02034>>>
saffron falcon thistle zebra zebra fathom auburn kindle glacier lattice harbor meadow falcon boulder spruce glacier ember zebra mistral auburn cedar glacier nimbus russet #70c6a6e0
<<<ANSWER END>>>
<<<ANSWER key=K03597>>>
falcon pewter nimbus trellis orbit quartz copper cinder trellis pewter indigo zebra pewter trellis saffron garnet onyx kindle lantern zebra auburn vellum russet boulder #0f75ae92
<<<ANSWER END>>>
<<<ANSWER key=K05563>>>
verdant indigo boulder cinder willow cobble garnet fathom fathom boulder thistle fathom copper nimbus orbit willow willow cobble fathom zebra zebra garnet verdant garnet #be88a610
<<<ANSWER END>>>
<<<ANSWER key=K01075>>>
cedar nimbus mistral onyx onyx cobble indigo lantern willow onyx crimson indigo thistle orbit saffron russet russet orbit crimson fathom crimson cobble zebra mistral #4f9fcc41
<<<ANSWER END>>>
<<<ANSWER key=K07460>>>
trellis fathom lantern saffron auburn lattice auburn meadow cedar thistle willow fathom spruce spruce marble copper kindle fathom mistral mistral falcon garnet harbor mistral #896c6ff0
<<<ANSWER END>>>
<<<ANSWER key=K04851>>>
crimson mistral mistral thistle cobble saffron glacier crimson marble meadow ember spruce spruce verdant garnet cobble onyx copper nimbus lantern garnet marble indigo thistle #1ee235cd
<<<ANSWER END>>>
<<<ANSWER key=K00490>>>
fathom cobble zebra thistle russet falcon zebra zebra fathom onyx cinder lantern copper cobalt orbit lantern cobalt fathom lantern cobble orbit cobble indigo quartz #242c309f
<<<ANSWER END>>>
<<<ANSWER key=K02943>>>
glacier willow meadow vellum crimson copper saffron lantern glacier mistral pewter mistral orbit thistle thistle kindle cedar zebra trellis boulder onyx pewter vellum verdant #41f90a93
<<<ANSWER END>>>
<<<ANSWER key=K03271>>>
cobalt vellum auburn cinder nimbus lattice garnet thistle indigo garnet russet ember lattice falcon boulder kindle spruce fathom vellum garnet vellum saffron marble cinder #3362ba6d
<<<ANSWER END>>>
<<<ANSWER key=K07260>>>
lantern spruce pewter lattice glacier auburn glacier mistral lantern harbor quartz pewter zebra falcon falcon harbor quartz indigo auburn boulder cobble indigo lantern cedar #e942b6e0
<<<ANSWER END>>>
<<<ANSWER key=K00870>>>
lattice cobalt saffron falcon meadow lattice zebra cinder kindle trellis glacier cinder spruce harbor falcon saffron mistral willow boulder cedar spruce cedar lattice russet #67e22ccd
<<<ANSWER END>>>
<<<ANSWER key=K05618>>>
fathom cobble onyx cedar kindle trellis cedar auburn verdant cobalt saffron quartz meadow indigo kindle cinder saffron meadow garnet cinder garnet ember lantern falcon #ac9d882c
<<<ANSWER END>>>
<<<ANSWER key=K03174>>>
ember crimson garnet pewter lantern boulder quartz cobble copper ember pewter lantern pewter copper fathom vellum vellum quartz vellum trellis lattice russet ember vellum #d6be3803
<<<ANSWER END>>>
<<<ANSWER key=K02763>>>
glacier mistral boulder willow falcon auburn harbor fathom fathom glacier verdant garnet orbit willow quartz willow nimbus nimbus copper quartz ember verdant mistral zebra #6b82f0f2
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
