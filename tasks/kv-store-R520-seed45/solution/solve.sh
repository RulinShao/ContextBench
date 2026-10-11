#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00041>>>
cedar trellis orbit zebra cobble crimson crimson mistral falcon marble copper cobble willow nimbus saffron saffron fathom copper trellis kindle nimbus cobalt russet russet #3d0cea29
<<<ANSWER END>>>
<<<ANSWER key=K00321>>>
ember willow copper quartz harbor willow boulder spruce mistral pewter auburn falcon copper nimbus ember spruce nimbus onyx saffron boulder harbor saffron marble verdant #02909777
<<<ANSWER END>>>
<<<ANSWER key=K00494>>>
vellum onyx marble cobble indigo cinder onyx indigo mistral zebra pewter pewter cedar nimbus vellum pewter ember orbit mistral lattice harbor ember saffron russet #010a80ae
<<<ANSWER END>>>
<<<ANSWER key=K00249>>>
harbor auburn mistral vellum cedar auburn quartz pewter quartz trellis zebra orbit glacier vellum nimbus lantern quartz glacier cinder marble lantern pewter falcon vellum #40c237c3
<<<ANSWER END>>>
<<<ANSWER key=K00270>>>
orbit boulder cinder onyx thistle spruce spruce mistral zebra zebra boulder vellum mistral fathom lantern ember orbit indigo fathom copper auburn lattice quartz kindle #de8eb47f
<<<ANSWER END>>>
<<<ANSWER key=K00309>>>
glacier copper onyx indigo nimbus marble kindle vellum spruce nimbus russet orbit cobalt vellum harbor marble copper crimson indigo verdant lattice marble nimbus spruce #61fcffab
<<<ANSWER END>>>
<<<ANSWER key=K00479>>>
pewter saffron mistral onyx copper verdant saffron verdant cobalt onyx thistle copper thistle zebra spruce russet thistle harbor meadow meadow harbor crimson meadow lantern #ee3735b4
<<<ANSWER END>>>
<<<ANSWER key=K00096>>>
zebra boulder lantern nimbus cobalt crimson boulder trellis copper harbor glacier russet thistle nimbus russet garnet falcon saffron fathom cedar onyx quartz falcon quartz #6e46d93b
<<<ANSWER END>>>
<<<ANSWER key=K00455>>>
boulder spruce mistral zebra zebra thistle thistle zebra zebra spruce garnet mistral glacier russet vellum meadow willow copper boulder spruce copper auburn pewter copper #50dd6c78
<<<ANSWER END>>>
<<<ANSWER key=K00454>>>
onyx thistle kindle thistle pewter boulder zebra copper kindle pewter russet cobalt onyx kindle spruce trellis willow falcon crimson meadow crimson auburn willow quartz #e5344dad
<<<ANSWER END>>>
<<<ANSWER key=K00294>>>
onyx trellis cinder marble garnet verdant cinder spruce onyx harbor crimson falcon kindle lattice onyx orbit verdant kindle marble nimbus meadow thistle meadow kindle #85092d7e
<<<ANSWER END>>>
<<<ANSWER key=K00504>>>
boulder auburn cedar ember pewter cinder trellis marble quartz marble verdant glacier crimson spruce cedar cobble nimbus meadow kindle nimbus saffron meadow harbor lattice #54a1289e
<<<ANSWER END>>>
<<<ANSWER key=K00002>>>
crimson falcon cobble cinder boulder pewter onyx auburn auburn willow garnet cobalt auburn orbit fathom crimson mistral kindle boulder glacier trellis harbor nimbus lantern #bb4fed33
<<<ANSWER END>>>
<<<ANSWER key=K00105>>>
vellum fathom cedar falcon onyx meadow spruce thistle cinder auburn ember harbor willow cinder garnet cedar boulder ember meadow cinder verdant glacier marble garnet #d0024eb7
<<<ANSWER END>>>
<<<ANSWER key=K00278>>>
lattice fathom lantern quartz saffron onyx glacier crimson saffron mistral mistral onyx auburn saffron crimson lattice thistle verdant cobble harbor verdant nimbus meadow trellis #383e796c
<<<ANSWER END>>>
<<<ANSWER key=K00175>>>
onyx copper kindle quartz kindle crimson fathom boulder quartz cobalt meadow pewter glacier russet copper pewter cobble marble onyx mistral verdant lattice harbor onyx #919b7db6
<<<ANSWER END>>>
<<<ANSWER key=K00343>>>
ember lantern copper cedar falcon falcon indigo boulder ember nimbus willow zebra ember lantern mistral mistral nimbus meadow mistral crimson mistral onyx copper onyx #5ab78401
<<<ANSWER END>>>
<<<ANSWER key=K00124>>>
verdant mistral mistral nimbus saffron harbor vellum zebra copper cobalt auburn cedar kindle meadow quartz quartz meadow quartz marble quartz nimbus fathom cedar harbor #7cda733a
<<<ANSWER END>>>
<<<ANSWER key=K00012>>>
cobalt lantern cinder falcon vellum onyx nimbus fathom fathom saffron copper cobble orbit trellis cedar onyx garnet cobble mistral ember harbor garnet verdant copper #c258a878
<<<ANSWER END>>>
<<<ANSWER key=K00072>>>
verdant harbor quartz onyx pewter crimson nimbus onyx cedar meadow willow cobble lantern garnet meadow boulder trellis thistle lantern willow garnet cobble cinder nimbus #ff26de12
<<<ANSWER END>>>
<<<ANSWER key=K00304>>>
verdant auburn quartz vellum verdant pewter orbit zebra lantern meadow cobble lantern auburn willow lantern cinder cobble russet quartz kindle garnet onyx copper cobalt #bd0736be
<<<ANSWER END>>>
<<<ANSWER key=K00157>>>
willow cedar kindle spruce onyx crimson garnet falcon cobalt verdant lattice vellum boulder cobble pewter mistral thistle kindle willow meadow lattice spruce crimson willow #e18889f8
<<<ANSWER END>>>
<<<ANSWER key=K00430>>>
ember crimson marble nimbus thistle vellum russet marble spruce cobalt lantern cobble orbit ember falcon cobble saffron vellum thistle cobble spruce falcon verdant zebra #42076c3e
<<<ANSWER END>>>
<<<ANSWER key=K00130>>>
boulder verdant orbit zebra falcon orbit orbit thistle ember falcon lantern onyx boulder verdant spruce vellum cobble auburn verdant boulder willow russet cedar kindle #38cf7f8c
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
