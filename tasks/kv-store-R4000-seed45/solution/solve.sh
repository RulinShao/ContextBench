#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00005>>>
spruce kindle mistral lantern onyx zebra garnet orbit marble marble marble orbit orbit cobalt lattice boulder glacier vellum kindle auburn orbit spruce garnet auburn #cb0df809
<<<ANSWER END>>>
<<<ANSWER key=K03289>>>
cobble onyx cobalt harbor nimbus vellum meadow ember cobalt verdant spruce nimbus auburn mistral willow boulder onyx harbor crimson pewter vellum lattice cedar crimson #7ba764d3
<<<ANSWER END>>>
<<<ANSWER key=K01781>>>
copper garnet cinder russet harbor vellum indigo cinder glacier harbor mistral boulder nimbus quartz ember quartz willow falcon auburn cinder zebra copper cobble lattice #7bf54852
<<<ANSWER END>>>
<<<ANSWER key=K03067>>>
indigo quartz ember thistle falcon indigo saffron verdant lantern glacier cedar kindle glacier lantern spruce cedar willow spruce marble cobalt saffron quartz kindle kindle #3cc6f4be
<<<ANSWER END>>>
<<<ANSWER key=K03328>>>
meadow falcon pewter saffron zebra cobalt nimbus mistral lantern pewter marble boulder pewter onyx cedar verdant russet lattice copper willow spruce zebra orbit falcon #ca84708f
<<<ANSWER END>>>
<<<ANSWER key=K01393>>>
trellis lattice lantern cinder pewter glacier crimson trellis nimbus ember verdant garnet boulder cedar marble glacier harbor willow meadow lattice thistle glacier cinder russet #382e7f7b
<<<ANSWER END>>>
<<<ANSWER key=K03751>>>
pewter quartz garnet crimson kindle kindle cinder meadow lattice ember willow saffron nimbus harbor russet falcon cobble boulder kindle boulder mistral spruce russet boulder #baa9cc9c
<<<ANSWER END>>>
<<<ANSWER key=K00747>>>
falcon cobalt auburn lattice mistral willow marble saffron crimson mistral auburn spruce indigo lantern cedar copper lantern willow garnet fathom russet fathom saffron harbor #eed1068b
<<<ANSWER END>>>
<<<ANSWER key=K01689>>>
garnet cinder indigo glacier cedar lattice vellum onyx pewter indigo pewter cobalt onyx cinder indigo verdant meadow orbit pewter pewter meadow crimson nimbus spruce #591b15c9
<<<ANSWER END>>>
<<<ANSWER key=K01987>>>
copper thistle garnet boulder cinder crimson kindle falcon falcon kindle quartz cobalt russet lantern lantern auburn garnet falcon lantern ember vellum kindle auburn cinder #009370bb
<<<ANSWER END>>>
<<<ANSWER key=K01449>>>
mistral cedar saffron willow fathom thistle cobalt meadow fathom trellis auburn indigo spruce crimson saffron cobalt zebra ember spruce nimbus spruce lattice spruce meadow #c5d8585e
<<<ANSWER END>>>
<<<ANSWER key=K03835>>>
ember pewter saffron kindle saffron spruce nimbus cobble orbit orbit orbit mistral harbor onyx lattice thistle indigo verdant glacier meadow russet ember cedar harbor #8d61e2bc
<<<ANSWER END>>>
<<<ANSWER key=K01943>>>
mistral ember spruce crimson cedar zebra crimson trellis russet thistle copper lattice harbor spruce fathom kindle saffron boulder quartz fathom meadow thistle thistle cinder #b770ff7e
<<<ANSWER END>>>
<<<ANSWER key=K01023>>>
zebra falcon cobalt quartz indigo mistral cobble glacier fathom nimbus fathom kindle mistral pewter lattice mistral crimson lantern cobalt lantern onyx ember crimson saffron #210007fa
<<<ANSWER END>>>
<<<ANSWER key=K02284>>>
lantern pewter cobalt willow trellis zebra cedar kindle vellum garnet verdant onyx marble fathom trellis cobalt nimbus onyx crimson zebra garnet harbor russet indigo #934490de
<<<ANSWER END>>>
<<<ANSWER key=K00047>>>
crimson mistral fathom lattice lantern fathom falcon cedar russet verdant zebra harbor trellis thistle glacier kindle ember cobalt trellis orbit quartz vellum cobalt cedar #e58a860f
<<<ANSWER END>>>
<<<ANSWER key=K00027>>>
kindle cinder orbit marble pewter falcon cobalt cedar falcon onyx glacier nimbus auburn ember saffron ember saffron zebra harbor trellis fathom copper onyx fathom #d623bade
<<<ANSWER END>>>
<<<ANSWER key=K00695>>>
verdant spruce fathom willow trellis nimbus cedar spruce lantern crimson marble russet russet vellum cinder cobalt fathom indigo zebra indigo cobble lattice auburn mistral #bf994e62
<<<ANSWER END>>>
<<<ANSWER key=K02608>>>
cobalt mistral saffron thistle mistral lantern onyx indigo thistle marble ember ember vellum russet auburn willow verdant crimson pewter quartz marble mistral zebra garnet #1536aef0
<<<ANSWER END>>>
<<<ANSWER key=K03100>>>
vellum zebra glacier quartz nimbus kindle zebra auburn pewter thistle indigo boulder auburn cedar cinder meadow onyx spruce nimbus cobble kindle zebra pewter lantern #ffa6bb43
<<<ANSWER END>>>
<<<ANSWER key=K02935>>>
thistle auburn cinder vellum indigo verdant garnet cobalt glacier lattice vellum marble harbor mistral mistral garnet verdant lattice fathom crimson cedar verdant crimson marble #6fe81071
<<<ANSWER END>>>
<<<ANSWER key=K03280>>>
mistral cinder copper glacier ember thistle auburn cobalt lantern garnet quartz glacier crimson cobalt mistral nimbus lantern indigo orbit trellis auburn falcon trellis quartz #26365232
<<<ANSWER END>>>
<<<ANSWER key=K03346>>>
auburn marble marble trellis harbor saffron glacier harbor garnet quartz pewter trellis harbor indigo cobble zebra cobble lattice marble auburn copper cinder zebra spruce #726a2a93
<<<ANSWER END>>>
<<<ANSWER key=K03713>>>
lattice trellis auburn cedar ember auburn crimson auburn cedar cobble russet boulder orbit orbit zebra lantern saffron saffron auburn spruce saffron quartz thistle saffron #ef484987
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
