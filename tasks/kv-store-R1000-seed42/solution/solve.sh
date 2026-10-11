#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00048>>>
kindle boulder garnet fathom cinder thistle ember pewter cinder vellum marble onyx verdant garnet spruce onyx thistle glacier cinder glacier indigo lattice willow russet #948823b5
<<<ANSWER END>>>
<<<ANSWER key=K00465>>>
harbor lattice zebra boulder willow crimson thistle pewter glacier fathom fathom copper pewter auburn zebra willow auburn cobalt meadow marble fathom onyx mistral ember #a95c5171
<<<ANSWER END>>>
<<<ANSWER key=K00600>>>
ember glacier lattice spruce kindle spruce marble copper onyx thistle marble garnet willow cedar lantern fathom thistle cobble willow meadow trellis falcon spruce trellis #b68a208a
<<<ANSWER END>>>
<<<ANSWER key=K00135>>>
pewter falcon meadow copper indigo thistle lantern orbit auburn vellum onyx harbor onyx cobble auburn copper mistral auburn thistle russet marble harbor vellum meadow #38614f46
<<<ANSWER END>>>
<<<ANSWER key=K00224>>>
onyx nimbus harbor boulder nimbus garnet lattice zebra cobalt trellis glacier lattice auburn meadow cinder meadow boulder russet quartz ember saffron verdant kindle onyx #4191f4d6
<<<ANSWER END>>>
<<<ANSWER key=K00492>>>
verdant glacier harbor lattice kindle lantern spruce onyx orbit meadow cedar fathom willow saffron cobalt nimbus vellum zebra saffron cedar fathom onyx nimbus lantern #f68ab589
<<<ANSWER END>>>
<<<ANSWER key=K00798>>>
copper quartz lattice copper pewter falcon willow harbor willow vellum marble cedar kindle nimbus lantern boulder lattice russet marble copper marble quartz marble cinder #a0f5d114
<<<ANSWER END>>>
<<<ANSWER key=K00150>>>
cobble cobalt quartz cinder cinder spruce cinder russet auburn lantern zebra mistral cedar lattice lantern glacier kindle cedar crimson lantern falcon marble copper trellis #94342d3b
<<<ANSWER END>>>
<<<ANSWER key=K00603>>>
russet indigo mistral cobalt cobalt falcon thistle garnet auburn verdant falcon russet zebra glacier trellis vellum pewter onyx thistle lantern quartz crimson fathom vellum #71fb2dea
<<<ANSWER END>>>
<<<ANSWER key=K00568>>>
harbor lattice crimson cinder trellis willow zebra garnet onyx mistral marble spruce quartz copper pewter spruce onyx onyx garnet vellum vellum auburn garnet lattice #a66280c1
<<<ANSWER END>>>
<<<ANSWER key=K00147>>>
glacier quartz crimson cobble boulder indigo onyx spruce auburn zebra cedar verdant marble mistral russet copper fathom trellis harbor nimbus boulder thistle russet quartz #0d8bf269
<<<ANSWER END>>>
<<<ANSWER key=K00396>>>
cedar cobble nimbus boulder crimson trellis harbor nimbus spruce cedar meadow willow meadow cinder falcon garnet spruce thistle kindle quartz lantern thistle auburn auburn #144b8f86
<<<ANSWER END>>>
<<<ANSWER key=K00566>>>
willow glacier orbit ember meadow onyx kindle mistral crimson harbor glacier lattice zebra willow thistle marble lantern auburn lantern orbit auburn ember marble zebra #6438087d
<<<ANSWER END>>>
<<<ANSWER key=K00621>>>
onyx trellis harbor kindle meadow marble cobalt orbit nimbus boulder russet cinder harbor falcon crimson cedar meadow meadow thistle saffron nimbus mistral ember garnet #92830246
<<<ANSWER END>>>
<<<ANSWER key=K00914>>>
cinder falcon lantern mistral marble zebra spruce glacier indigo orbit harbor copper glacier thistle marble marble quartz garnet harbor cobble nimbus mistral cobalt harbor #bebb22d5
<<<ANSWER END>>>
<<<ANSWER key=K00236>>>
quartz lantern willow willow vellum mistral boulder auburn vellum cedar pewter glacier trellis trellis cinder copper cobalt lantern fathom spruce quartz boulder orbit lattice #ebf3e4e4
<<<ANSWER END>>>
<<<ANSWER key=K00229>>>
pewter kindle trellis nimbus ember lattice zebra cedar cobalt vellum fathom crimson russet fathom willow cedar verdant russet kindle trellis glacier willow thistle kindle #ff2f10be
<<<ANSWER END>>>
<<<ANSWER key=K00281>>>
garnet zebra zebra nimbus trellis harbor cobble cinder quartz trellis auburn cobble ember cobble mistral russet russet harbor fathom orbit spruce indigo cobble auburn #6244f10d
<<<ANSWER END>>>
<<<ANSWER key=K00927>>>
cobalt harbor harbor falcon saffron cobalt boulder nimbus lantern lantern onyx spruce harbor vellum zebra quartz onyx spruce lantern indigo verdant orbit lattice cinder #0da51e66
<<<ANSWER END>>>
<<<ANSWER key=K00723>>>
fathom ember zebra pewter crimson onyx marble thistle vellum spruce saffron cobalt cobble harbor cinder kindle zebra mistral lantern kindle thistle lattice vellum thistle #bdfdd7d5
<<<ANSWER END>>>
<<<ANSWER key=K00523>>>
trellis fathom trellis glacier kindle russet thistle trellis pewter willow glacier harbor cedar spruce harbor harbor harbor glacier kindle russet onyx saffron marble indigo #76d686b6
<<<ANSWER END>>>
<<<ANSWER key=K00678>>>
zebra cedar orbit kindle pewter lattice auburn spruce cobalt crimson auburn willow garnet meadow glacier pewter thistle nimbus pewter indigo verdant copper orbit cinder #a4fdac81
<<<ANSWER END>>>
<<<ANSWER key=K00952>>>
falcon pewter glacier russet spruce fathom garnet cobble vellum nimbus lattice cinder lantern trellis ember falcon indigo kindle nimbus orbit kindle indigo falcon thistle #1629cb95
<<<ANSWER END>>>
<<<ANSWER key=K00869>>>
zebra copper vellum garnet quartz lantern saffron saffron meadow crimson orbit cobble saffron thistle pewter harbor saffron lattice falcon meadow orbit russet trellis thistle #64a082b2
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
