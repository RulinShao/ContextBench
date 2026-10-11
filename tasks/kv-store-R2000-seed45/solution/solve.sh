#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00363>>>
cedar zebra onyx indigo kindle boulder glacier indigo indigo cinder lattice zebra cinder marble glacier lattice boulder auburn garnet orbit glacier saffron falcon glacier #b618003d
<<<ANSWER END>>>
<<<ANSWER key=K00990>>>
lattice crimson copper willow cobble zebra cinder copper ember vellum auburn pewter falcon pewter nimbus meadow verdant nimbus nimbus harbor vellum orbit marble onyx #db8fd331
<<<ANSWER END>>>
<<<ANSWER key=K00725>>>
cinder garnet ember trellis marble crimson thistle orbit quartz nimbus falcon garnet quartz trellis willow verdant russet kindle thistle garnet lantern meadow orbit trellis #a3889c7d
<<<ANSWER END>>>
<<<ANSWER key=K00445>>>
quartz quartz lattice russet willow ember indigo orbit spruce trellis kindle lantern boulder quartz glacier ember meadow glacier saffron willow willow nimbus boulder zebra #f8f225a5
<<<ANSWER END>>>
<<<ANSWER key=K00033>>>
cobble harbor lattice copper pewter vellum willow kindle meadow boulder cinder fathom russet quartz meadow boulder copper glacier garnet lantern garnet cedar mistral boulder #faac4e69
<<<ANSWER END>>>
<<<ANSWER key=K01599>>>
thistle cobble cobalt saffron fathom lantern nimbus saffron copper spruce mistral orbit auburn trellis falcon orbit russet onyx copper onyx saffron nimbus harbor pewter #0a3078e3
<<<ANSWER END>>>
<<<ANSWER key=K00161>>>
indigo onyx fathom auburn quartz fathom falcon ember pewter lattice crimson lattice orbit glacier orbit kindle lantern quartz falcon cinder zebra indigo auburn crimson #c0847344
<<<ANSWER END>>>
<<<ANSWER key=K01225>>>
harbor cinder russet cinder cinder garnet glacier nimbus orbit trellis boulder kindle cobalt lattice orbit orbit russet marble meadow cinder glacier pewter lattice quartz #233e1d26
<<<ANSWER END>>>
<<<ANSWER key=K00818>>>
auburn indigo saffron nimbus cobble copper cobalt mistral onyx lattice meadow cobble cinder vellum nimbus cedar boulder marble glacier verdant cedar crimson cedar lantern #d584f642
<<<ANSWER END>>>
<<<ANSWER key=K00392>>>
auburn willow zebra cinder nimbus saffron lattice crimson kindle verdant mistral kindle trellis crimson cedar auburn glacier nimbus onyx thistle saffron spruce onyx glacier #ce3038f2
<<<ANSWER END>>>
<<<ANSWER key=K01525>>>
verdant cobalt orbit pewter spruce ember marble cobalt cinder willow glacier copper harbor fathom zebra meadow fathom harbor spruce boulder orbit glacier auburn trellis #873eda7e
<<<ANSWER END>>>
<<<ANSWER key=K01523>>>
cobble orbit spruce thistle indigo ember marble spruce trellis cedar ember ember harbor cobalt vellum cinder falcon quartz lantern onyx crimson lantern kindle copper #99e230c3
<<<ANSWER END>>>
<<<ANSWER key=K00095>>>
harbor russet mistral kindle zebra trellis crimson auburn crimson harbor onyx onyx indigo meadow quartz willow meadow vellum zebra copper glacier glacier fathom copper #8810168c
<<<ANSWER END>>>
<<<ANSWER key=K01055>>>
meadow boulder garnet indigo pewter vellum cobble saffron marble indigo saffron quartz trellis cedar lattice trellis marble falcon cedar verdant glacier harbor trellis cobalt #c1bec1af
<<<ANSWER END>>>
<<<ANSWER key=K01541>>>
saffron quartz saffron glacier quartz quartz pewter saffron crimson lantern harbor auburn copper glacier pewter trellis zebra verdant fathom fathom orbit lantern nimbus garnet #b5c56f17
<<<ANSWER END>>>
<<<ANSWER key=K01751>>>
cedar crimson cobble harbor crimson lattice mistral pewter glacier meadow pewter verdant trellis fathom zebra willow cedar ember willow fathom onyx garnet marble crimson #b2d06d1b
<<<ANSWER END>>>
<<<ANSWER key=K00559>>>
onyx crimson fathom mistral saffron glacier vellum cobalt harbor quartz zebra quartz verdant indigo zebra vellum mistral lantern onyx cinder falcon fathom cobble marble #dd9ce102
<<<ANSWER END>>>
<<<ANSWER key=K00759>>>
lantern glacier spruce lattice cinder spruce glacier meadow falcon quartz auburn cobble kindle verdant verdant auburn mistral meadow ember saffron crimson quartz boulder falcon #d14bbb90
<<<ANSWER END>>>
<<<ANSWER key=K01868>>>
garnet cobble verdant cobble onyx marble cobble cobble lantern marble boulder spruce russet zebra trellis harbor pewter cobble cinder pewter falcon willow saffron lattice #94dfffee
<<<ANSWER END>>>
<<<ANSWER key=K01728>>>
glacier lattice kindle glacier falcon russet vellum lantern trellis kindle trellis orbit crimson lantern cedar crimson vellum zebra nimbus meadow cobalt glacier cobble cobble #a9116841
<<<ANSWER END>>>
<<<ANSWER key=K00265>>>
crimson crimson fathom pewter vellum lattice quartz spruce orbit auburn cinder thistle garnet glacier thistle quartz verdant cobalt fathom auburn copper pewter pewter boulder #b0cb01e9
<<<ANSWER END>>>
<<<ANSWER key=K00192>>>
auburn orbit indigo auburn kindle crimson marble garnet spruce thistle mistral auburn falcon harbor falcon auburn cedar lattice garnet mistral ember cobble onyx saffron #86ea9650
<<<ANSWER END>>>
<<<ANSWER key=K00076>>>
willow verdant cobble marble cobble verdant russet falcon indigo lantern glacier kindle nimbus pewter kindle quartz trellis spruce cedar willow onyx mistral cobble harbor #0a1c28a7
<<<ANSWER END>>>
<<<ANSWER key=K01444>>>
cobalt mistral vellum meadow saffron russet auburn harbor marble fathom ember auburn kindle boulder fathom mistral saffron cobble lantern nimbus mistral nimbus thistle copper #34f3d325
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
