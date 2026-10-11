#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00020>>>
kindle lattice meadow lattice vellum lattice cobalt russet meadow ember willow quartz cobble onyx boulder copper saffron orbit spruce willow garnet copper glacier crimson #8303d7db
<<<ANSWER END>>>
<<<ANSWER key=K00079>>>
trellis verdant onyx orbit vellum boulder ember ember nimbus verdant kindle boulder meadow marble copper thistle kindle thistle garnet lattice quartz kindle auburn glacier #edf74cd5
<<<ANSWER END>>>
<<<ANSWER key=K00009>>>
vellum glacier trellis pewter falcon garnet nimbus lattice trellis cinder falcon boulder kindle orbit nimbus trellis quartz willow pewter quartz nimbus fathom cedar indigo #6b205b58
<<<ANSWER END>>>
<<<ANSWER key=K00118>>>
kindle auburn nimbus willow willow nimbus cedar quartz saffron quartz garnet boulder pewter lantern kindle russet falcon garnet glacier cedar marble mistral vellum indigo #c98c1829
<<<ANSWER END>>>
<<<ANSWER key=K00046>>>
garnet harbor glacier verdant russet fathom zebra crimson garnet cobble mistral fathom garnet onyx onyx mistral glacier copper copper cinder lantern thistle vellum garnet #0b37f59f
<<<ANSWER END>>>
<<<ANSWER key=K00066>>>
russet quartz falcon quartz harbor falcon cobble nimbus crimson falcon onyx falcon cinder kindle garnet cobble cedar garnet ember verdant fathom zebra russet zebra #477eb14b
<<<ANSWER END>>>
<<<ANSWER key=K00014>>>
meadow vellum meadow garnet thistle ember crimson indigo fathom kindle spruce marble cobble lantern falcon glacier lattice thistle spruce cobalt quartz lantern kindle meadow #9d7da323
<<<ANSWER END>>>
<<<ANSWER key=K00067>>>
garnet kindle harbor saffron cedar saffron quartz verdant harbor orbit boulder cinder copper onyx nimbus pewter lattice pewter fathom kindle onyx lantern lantern vellum #61a26118
<<<ANSWER END>>>
<<<ANSWER key=K00086>>>
zebra russet cedar cinder vellum vellum orbit garnet willow fathom nimbus lantern cinder thistle auburn orbit falcon fathom copper harbor cobble nimbus vellum meadow #ce25ed72
<<<ANSWER END>>>
<<<ANSWER key=K00047>>>
zebra auburn orbit copper indigo saffron lantern onyx lattice nimbus nimbus falcon boulder indigo vellum auburn harbor trellis auburn auburn auburn orbit falcon ember #74311925
<<<ANSWER END>>>
<<<ANSWER key=K00075>>>
cobble verdant zebra quartz pewter russet saffron russet orbit lattice indigo trellis zebra glacier garnet copper lattice cobalt verdant willow nimbus nimbus lattice kindle #370463e4
<<<ANSWER END>>>
<<<ANSWER key=K00022>>>
cobalt boulder glacier ember russet glacier ember auburn zebra crimson boulder glacier pewter boulder lantern auburn zebra glacier orbit zebra russet spruce ember falcon #d6db15a0
<<<ANSWER END>>>
<<<ANSWER key=K00015>>>
ember cinder zebra meadow cedar thistle cinder fathom crimson copper glacier lattice boulder cinder mistral crimson vellum cobalt crimson lantern orbit crimson cinder saffron #3a8fe078
<<<ANSWER END>>>
<<<ANSWER key=K00114>>>
ember cobalt saffron harbor fathom harbor russet kindle pewter auburn crimson saffron willow ember trellis lantern verdant saffron ember trellis saffron crimson boulder orbit #c8c73d80
<<<ANSWER END>>>
<<<ANSWER key=K00121>>>
cobalt saffron thistle mistral crimson spruce quartz mistral auburn thistle auburn lantern fathom willow fathom thistle copper trellis kindle cinder cedar trellis cobble thistle #87f5b825
<<<ANSWER END>>>
<<<ANSWER key=K00041>>>
fathom glacier thistle onyx orbit ember thistle trellis cobble nimbus indigo ember vellum onyx crimson indigo lattice crimson lattice vellum onyx quartz copper falcon #def20faf
<<<ANSWER END>>>
<<<ANSWER key=K00001>>>
quartz auburn fathom saffron nimbus auburn meadow orbit orbit nimbus orbit harbor boulder saffron meadow kindle thistle orbit thistle garnet verdant verdant kindle vellum #b5adaf8f
<<<ANSWER END>>>
<<<ANSWER key=K00073>>>
harbor cobble mistral onyx thistle willow russet kindle onyx spruce meadow glacier cedar cobalt harbor harbor russet verdant glacier glacier cinder boulder cobalt willow #075de032
<<<ANSWER END>>>
<<<ANSWER key=K00092>>>
mistral lattice lattice copper mistral fathom cobble falcon garnet verdant lattice russet lantern trellis zebra lattice falcon lattice trellis lattice glacier spruce saffron garnet #3915c06b
<<<ANSWER END>>>
<<<ANSWER key=K00094>>>
trellis marble orbit spruce garnet pewter pewter saffron nimbus lattice cedar cinder thistle saffron fathom fathom garnet cinder copper lattice willow crimson auburn harbor #eb054aee
<<<ANSWER END>>>
<<<ANSWER key=K00105>>>
indigo verdant cedar russet crimson falcon russet ember orbit trellis ember lattice auburn thistle quartz meadow lattice nimbus saffron verdant thistle verdant crimson crimson #e49d993e
<<<ANSWER END>>>
<<<ANSWER key=K00010>>>
cobble auburn kindle nimbus indigo thistle fathom lattice quartz thistle cinder trellis fathom indigo thistle willow kindle spruce orbit auburn vellum garnet russet mistral #a6e17d96
<<<ANSWER END>>>
<<<ANSWER key=K00095>>>
fathom orbit boulder cedar nimbus meadow quartz cobble lattice onyx saffron onyx lattice onyx cinder glacier mistral quartz marble cobble cedar willow verdant fathom #49ffb988
<<<ANSWER END>>>
<<<ANSWER key=K00082>>>
cinder ember ember indigo cedar russet thistle fathom copper mistral mistral auburn mistral russet ember orbit lattice cobble cobble zebra auburn cedar thistle fathom #e824ae3d
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
