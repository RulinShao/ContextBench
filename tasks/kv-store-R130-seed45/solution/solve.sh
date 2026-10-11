#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00073>>>
mistral mistral vellum quartz zebra crimson cobble harbor fathom ember verdant harbor garnet cobble quartz verdant saffron nimbus glacier copper trellis auburn indigo ember #9aa8a2f9
<<<ANSWER END>>>
<<<ANSWER key=K00086>>>
cinder crimson willow vellum glacier trellis auburn boulder thistle cobalt boulder garnet indigo boulder onyx crimson garnet spruce copper kindle mistral cedar meadow harbor #8e738344
<<<ANSWER END>>>
<<<ANSWER key=K00013>>>
lattice cedar verdant spruce cedar boulder marble quartz quartz lantern quartz vellum saffron russet mistral copper saffron thistle cobalt pewter lattice verdant vellum indigo #e075ae3c
<<<ANSWER END>>>
<<<ANSWER key=K00121>>>
ember indigo saffron cinder zebra boulder lantern vellum cobble verdant lantern lantern zebra fathom mistral cedar cobble verdant copper spruce russet lattice cobble falcon #4b39ff1a
<<<ANSWER END>>>
<<<ANSWER key=K00089>>>
zebra ember crimson meadow thistle verdant mistral lattice saffron marble meadow marble zebra indigo ember mistral harbor zebra nimbus orbit cobble kindle onyx falcon #c9aaa4d5
<<<ANSWER END>>>
<<<ANSWER key=K00120>>>
copper willow cedar pewter indigo auburn nimbus falcon meadow cobble russet cinder spruce vellum vellum garnet glacier cinder willow zebra orbit spruce mistral copper #01bab71d
<<<ANSWER END>>>
<<<ANSWER key=K00092>>>
thistle cinder onyx ember zebra meadow boulder nimbus indigo zebra garnet marble thistle boulder trellis quartz falcon mistral pewter copper ember onyx orbit pewter #f5e15ebd
<<<ANSWER END>>>
<<<ANSWER key=K00005>>>
spruce kindle mistral lantern onyx zebra garnet orbit marble marble marble orbit orbit cobalt lattice boulder glacier vellum kindle auburn orbit spruce garnet auburn #cb0df809
<<<ANSWER END>>>
<<<ANSWER key=K00031>>>
pewter spruce cobalt lattice orbit pewter nimbus kindle trellis indigo meadow quartz vellum marble glacier nimbus lattice spruce mistral nimbus cobble glacier saffron pewter #33ae62f2
<<<ANSWER END>>>
<<<ANSWER key=K00006>>>
zebra auburn falcon auburn orbit cobalt lattice saffron cobalt willow auburn glacier marble lantern onyx glacier quartz meadow onyx thistle mistral quartz falcon cobalt #6c8d52e4
<<<ANSWER END>>>
<<<ANSWER key=K00077>>>
falcon indigo mistral verdant ember harbor orbit cobalt garnet cedar nimbus cedar spruce spruce trellis zebra russet quartz cedar indigo spruce willow auburn harbor #fc56ebf8
<<<ANSWER END>>>
<<<ANSWER key=K00124>>>
verdant mistral mistral nimbus saffron harbor vellum zebra copper cobalt auburn cedar kindle meadow quartz quartz meadow quartz marble quartz nimbus fathom cedar harbor #7cda733a
<<<ANSWER END>>>
<<<ANSWER key=K00012>>>
cobalt lantern cinder falcon vellum onyx nimbus fathom fathom saffron copper cobble orbit trellis cedar onyx garnet cobble mistral ember harbor garnet verdant copper #c258a878
<<<ANSWER END>>>
<<<ANSWER key=K00087>>>
russet falcon willow lantern willow harbor nimbus lattice crimson mistral onyx meadow cinder boulder verdant pewter zebra harbor nimbus kindle lantern verdant indigo indigo #1c77a5d7
<<<ANSWER END>>>
<<<ANSWER key=K00014>>>
falcon nimbus cinder marble cinder fathom cedar quartz trellis indigo trellis lattice lantern cobble kindle crimson nimbus garnet fathom crimson verdant pewter verdant fathom #f3a923ea
<<<ANSWER END>>>
<<<ANSWER key=K00126>>>
meadow auburn cedar cobalt trellis auburn cedar auburn quartz nimbus trellis kindle nimbus cinder verdant ember onyx quartz auburn fathom zebra falcon lattice cedar #17d221c3
<<<ANSWER END>>>
<<<ANSWER key=K00001>>>
willow orbit zebra nimbus glacier indigo copper glacier thistle onyx cobalt crimson verdant glacier auburn kindle mistral indigo orbit cobble lattice pewter copper willow #5db709e2
<<<ANSWER END>>>
<<<ANSWER key=K00053>>>
garnet boulder fathom willow lattice cedar vellum russet lattice saffron falcon indigo fathom cobble meadow onyx verdant willow garnet meadow falcon verdant copper cedar #8eaf3715
<<<ANSWER END>>>
<<<ANSWER key=K00036>>>
willow nimbus willow lantern harbor cedar boulder meadow russet thistle marble nimbus nimbus marble onyx fathom auburn verdant copper harbor harbor russet saffron onyx #6e50c7f4
<<<ANSWER END>>>
<<<ANSWER key=K00043>>>
willow marble falcon cedar willow spruce quartz pewter copper glacier boulder glacier marble mistral falcon verdant russet boulder cobalt ember fathom onyx lantern willow #8db28150
<<<ANSWER END>>>
<<<ANSWER key=K00051>>>
garnet cobalt willow harbor willow lattice boulder cinder spruce russet thistle fathom trellis spruce nimbus cobble boulder cedar cinder lattice cobble trellis falcon cinder #6b47072c
<<<ANSWER END>>>
<<<ANSWER key=K00093>>>
cobble harbor garnet russet harbor ember russet lattice verdant trellis lattice garnet copper glacier thistle garnet verdant garnet trellis spruce glacier fathom falcon pewter #c6b4e689
<<<ANSWER END>>>
<<<ANSWER key=K00057>>>
vellum marble glacier falcon pewter ember fathom harbor meadow trellis willow onyx meadow meadow quartz harbor trellis willow cobble pewter glacier glacier saffron indigo #ae052647
<<<ANSWER END>>>
<<<ANSWER key=K00072>>>
verdant harbor quartz onyx pewter crimson nimbus onyx cedar meadow willow cobble lantern garnet meadow boulder trellis thistle lantern willow garnet cobble cinder nimbus #ff26de12
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
