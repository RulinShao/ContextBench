#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K07659>>>
trellis trellis nimbus verdant copper spruce zebra cobble ember lattice thistle pewter nimbus onyx trellis thistle cobalt lattice harbor zebra saffron falcon marble orbit #c15e9545
<<<ANSWER END>>>
<<<ANSWER key=K06168>>>
cobalt boulder lattice orbit spruce vellum harbor nimbus willow orbit quartz onyx mistral mistral cobble garnet mistral falcon pewter kindle cinder willow glacier thistle #997d7e3f
<<<ANSWER END>>>
<<<ANSWER key=K02999>>>
marble quartz thistle saffron willow boulder harbor willow kindle lantern zebra fathom verdant kindle glacier falcon ember mistral vellum fathom ember pewter indigo cinder #6f4ca93a
<<<ANSWER END>>>
<<<ANSWER key=K07148>>>
kindle indigo cinder crimson falcon lattice quartz kindle lantern ember cobalt zebra garnet vellum cedar falcon boulder willow kindle meadow garnet trellis cedar cobble #c97d7ffd
<<<ANSWER END>>>
<<<ANSWER key=K05570>>>
orbit saffron vellum crimson willow marble garnet nimbus mistral spruce cobalt trellis glacier fathom trellis glacier trellis orbit russet orbit onyx saffron russet willow #c79b4dbd
<<<ANSWER END>>>
<<<ANSWER key=K07365>>>
glacier verdant vellum glacier ember meadow willow glacier copper lantern trellis russet thistle garnet quartz copper verdant pewter willow meadow trellis lattice cobalt cedar #6b80e398
<<<ANSWER END>>>
<<<ANSWER key=K04532>>>
quartz pewter orbit crimson saffron verdant harbor lantern ember copper onyx lattice falcon spruce pewter zebra quartz glacier cedar saffron kindle glacier lattice cobble #1ff1a0a4
<<<ANSWER END>>>
<<<ANSWER key=K00293>>>
indigo nimbus lattice ember falcon lattice lattice russet pewter garnet fathom crimson auburn ember kindle mistral saffron garnet cedar spruce willow spruce cobble cobble #882a6fbc
<<<ANSWER END>>>
<<<ANSWER key=K02446>>>
cobalt willow meadow meadow pewter verdant meadow trellis nimbus orbit lattice russet meadow orbit zebra mistral russet boulder cobble marble onyx boulder ember pewter #25a3fee2
<<<ANSWER END>>>
<<<ANSWER key=K04630>>>
crimson falcon vellum trellis falcon nimbus nimbus lattice falcon vellum marble nimbus vellum vellum russet russet nimbus lattice copper lattice mistral thistle boulder pewter #0ec6a25b
<<<ANSWER END>>>
<<<ANSWER key=K05572>>>
cobalt orbit vellum kindle thistle quartz cobalt thistle marble trellis quartz glacier copper orbit mistral pewter boulder vellum cedar trellis orbit pewter willow indigo #70279f3c
<<<ANSWER END>>>
<<<ANSWER key=K07320>>>
cinder mistral cobble thistle quartz orbit russet indigo zebra vellum auburn zebra cedar ember marble onyx onyx zebra willow copper glacier kindle quartz saffron #ea8033c9
<<<ANSWER END>>>
<<<ANSWER key=K05430>>>
harbor garnet thistle cobble cobble vellum ember vellum harbor spruce willow nimbus thistle zebra boulder thistle boulder copper meadow garnet ember cobalt harbor saffron #46722814
<<<ANSWER END>>>
<<<ANSWER key=K05886>>>
boulder meadow garnet meadow auburn zebra spruce zebra willow boulder mistral verdant cedar orbit trellis boulder cobble garnet falcon trellis trellis russet cedar fathom #aa8add93
<<<ANSWER END>>>
<<<ANSWER key=K00175>>>
cobalt falcon saffron harbor indigo kindle cobalt orbit zebra pewter glacier vellum zebra ember harbor cinder nimbus indigo fathom saffron russet garnet russet zebra #deb2d938
<<<ANSWER END>>>
<<<ANSWER key=K01047>>>
copper willow vellum vellum pewter meadow saffron nimbus spruce meadow quartz trellis indigo cobble copper garnet lattice mistral willow cobble orbit fathom crimson verdant #6a69245d
<<<ANSWER END>>>
<<<ANSWER key=K02090>>>
crimson nimbus saffron lattice kindle zebra auburn orbit saffron glacier harbor spruce nimbus mistral indigo lantern kindle russet harbor spruce garnet mistral verdant russet #b73f9413
<<<ANSWER END>>>
<<<ANSWER key=K06966>>>
onyx glacier onyx kindle quartz verdant onyx thistle nimbus copper lantern crimson fathom garnet trellis willow mistral onyx marble auburn pewter copper saffron falcon #4a684726
<<<ANSWER END>>>
<<<ANSWER key=K03894>>>
russet cedar nimbus crimson zebra auburn cinder willow falcon onyx thistle glacier harbor copper thistle fathom zebra glacier zebra copper mistral lantern thistle willow #5d933500
<<<ANSWER END>>>
<<<ANSWER key=K02333>>>
willow willow crimson auburn verdant orbit onyx cobble marble nimbus nimbus garnet boulder orbit garnet crimson garnet verdant mistral cobble garnet nimbus vellum willow #643a701b
<<<ANSWER END>>>
<<<ANSWER key=K00074>>>
cinder harbor willow spruce lattice meadow willow indigo onyx willow auburn cobalt cinder ember falcon fathom saffron lantern falcon cedar indigo cinder cedar saffron #d6075e0f
<<<ANSWER END>>>
<<<ANSWER key=K02556>>>
quartz quartz copper cinder ember indigo falcon nimbus trellis vellum marble vellum orbit fathom meadow cinder mistral zebra mistral pewter cinder onyx verdant trellis #5e29a5be
<<<ANSWER END>>>
<<<ANSWER key=K02013>>>
kindle cedar cinder cobble mistral kindle lattice kindle falcon indigo harbor crimson willow lantern zebra pewter pewter vellum nimbus saffron copper marble falcon falcon #3d9e9454
<<<ANSWER END>>>
<<<ANSWER key=K02662>>>
meadow kindle orbit willow onyx garnet quartz indigo lantern pewter cedar cedar marble lantern marble auburn crimson cobalt pewter cedar ember marble thistle pewter #0d2c7ad5
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
