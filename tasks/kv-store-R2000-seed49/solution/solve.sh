#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K01050>>>
kindle zebra cobble cinder kindle quartz mistral boulder garnet copper garnet glacier vellum lantern zebra cedar quartz glacier vellum nimbus falcon zebra ember harbor #e7f299ec
<<<ANSWER END>>>
<<<ANSWER key=K01348>>>
cobble lattice spruce glacier onyx cedar trellis falcon mistral cobalt thistle copper boulder lantern fathom trellis russet willow saffron kindle cobble nimbus quartz cedar #897d51cb
<<<ANSWER END>>>
<<<ANSWER key=K01537>>>
cinder copper zebra ember copper boulder mistral lantern cinder indigo orbit boulder garnet kindle thistle copper meadow copper thistle orbit marble meadow saffron indigo #77294240
<<<ANSWER END>>>
<<<ANSWER key=K01307>>>
cobble saffron quartz cobalt harbor verdant ember harbor auburn nimbus cobalt lantern cinder harbor indigo lattice lattice trellis vellum trellis willow marble spruce cobalt #bbfdc1b8
<<<ANSWER END>>>
<<<ANSWER key=K00884>>>
cinder lattice boulder fathom copper russet boulder russet lantern mistral saffron nimbus spruce thistle lattice spruce verdant lattice mistral vellum fathom crimson verdant cedar #30015461
<<<ANSWER END>>>
<<<ANSWER key=K01325>>>
auburn harbor lattice cedar spruce thistle saffron quartz copper lantern trellis copper zebra crimson vellum pewter indigo meadow meadow auburn indigo russet crimson verdant #c677fb6c
<<<ANSWER END>>>
<<<ANSWER key=K00760>>>
garnet saffron marble auburn cobble fathom auburn crimson vellum kindle cedar fathom quartz nimbus spruce cobalt auburn meadow russet spruce willow cinder verdant kindle #c5162215
<<<ANSWER END>>>
<<<ANSWER key=K00952>>>
boulder auburn falcon mistral falcon auburn willow auburn zebra meadow onyx cobalt ember thistle ember fathom thistle zebra verdant pewter falcon nimbus cinder thistle #37a8da8b
<<<ANSWER END>>>
<<<ANSWER key=K01034>>>
cinder pewter crimson lantern marble saffron pewter marble crimson trellis auburn indigo copper willow mistral pewter crimson quartz marble onyx copper lantern meadow falcon #240506f8
<<<ANSWER END>>>
<<<ANSWER key=K01137>>>
glacier falcon zebra indigo falcon orbit copper copper harbor garnet spruce boulder trellis spruce orbit cedar russet harbor kindle copper thistle pewter pewter boulder #a1ef5ca8
<<<ANSWER END>>>
<<<ANSWER key=K01417>>>
marble auburn thistle copper kindle garnet willow nimbus willow kindle marble crimson copper mistral onyx vellum russet fathom indigo orbit vellum glacier indigo marble #a2877069
<<<ANSWER END>>>
<<<ANSWER key=K00391>>>
crimson onyx cobalt boulder trellis fathom trellis indigo harbor quartz quartz fathom trellis indigo cinder kindle cinder zebra trellis marble willow glacier kindle cobble #0bddc35a
<<<ANSWER END>>>
<<<ANSWER key=K00922>>>
crimson cobalt vellum fathom nimbus verdant cobalt quartz trellis nimbus saffron glacier spruce ember onyx orbit onyx fathom cedar glacier onyx falcon willow vellum #9a48d8e2
<<<ANSWER END>>>
<<<ANSWER key=K01451>>>
meadow glacier lattice cobalt willow spruce onyx lattice quartz auburn falcon cobble copper saffron orbit garnet cinder mistral thistle ember auburn spruce spruce lantern #6568e1af
<<<ANSWER END>>>
<<<ANSWER key=K00237>>>
orbit ember zebra quartz vellum copper cedar willow glacier glacier cinder marble saffron copper cinder russet glacier willow fathom vellum garnet nimbus willow vellum #8c03ef20
<<<ANSWER END>>>
<<<ANSWER key=K00891>>>
indigo glacier thistle ember garnet crimson auburn lattice boulder pewter glacier orbit verdant ember crimson nimbus auburn copper cobalt russet lattice meadow garnet saffron #e2948d32
<<<ANSWER END>>>
<<<ANSWER key=K01263>>>
lantern quartz verdant cedar saffron trellis kindle onyx nimbus spruce cedar lantern thistle spruce glacier trellis trellis nimbus ember auburn nimbus garnet thistle falcon #c3fb4f65
<<<ANSWER END>>>
<<<ANSWER key=K00828>>>
willow fathom indigo kindle crimson garnet falcon trellis cobalt onyx zebra quartz falcon spruce marble orbit ember willow cobble meadow crimson vellum spruce cedar #2b4fe5b7
<<<ANSWER END>>>
<<<ANSWER key=K00148>>>
spruce trellis trellis willow falcon auburn auburn meadow boulder verdant cobble mistral trellis harbor marble falcon trellis garnet falcon willow auburn zebra boulder fathom #d64d7307
<<<ANSWER END>>>
<<<ANSWER key=K00299>>>
spruce cobble thistle vellum verdant boulder onyx meadow cobalt zebra indigo pewter fathom russet harbor indigo cobble cobalt cedar auburn glacier fathom saffron meadow #dbfba9a9
<<<ANSWER END>>>
<<<ANSWER key=K00008>>>
copper cedar trellis orbit nimbus cobble boulder vellum cobalt meadow garnet falcon onyx quartz crimson zebra fathom lantern boulder harbor auburn ember nimbus nimbus #4511d545
<<<ANSWER END>>>
<<<ANSWER key=K01789>>>
zebra willow cinder cobble thistle mistral onyx nimbus orbit thistle boulder glacier harbor meadow marble willow pewter copper mistral fathom fathom copper ember auburn #fd9715a6
<<<ANSWER END>>>
<<<ANSWER key=K01982>>>
verdant onyx marble quartz spruce cinder saffron lantern spruce marble garnet cobble cobalt kindle glacier cobble cedar thistle pewter willow russet indigo garnet crimson #ea220dd0
<<<ANSWER END>>>
<<<ANSWER key=K00929>>>
trellis pewter fathom ember garnet russet thistle zebra falcon cobalt verdant mistral thistle russet russet mistral onyx kindle copper ember cedar saffron cobalt kindle #e0cbf7e1
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
