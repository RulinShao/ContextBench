#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K02285>>>
kindle saffron copper mistral crimson orbit auburn spruce crimson trellis garnet kindle cedar orbit onyx willow cinder boulder spruce verdant fathom mistral cobble nimbus #5076461b
<<<ANSWER END>>>
<<<ANSWER key=K03497>>>
mistral verdant thistle harbor boulder marble quartz lattice auburn verdant lantern boulder boulder onyx boulder lattice lattice onyx lantern pewter cedar spruce copper saffron #0fb5f173
<<<ANSWER END>>>
<<<ANSWER key=K02915>>>
lantern lattice trellis kindle kindle lattice orbit garnet pewter willow lattice garnet cobalt onyx nimbus orbit russet russet harbor onyx quartz lattice nimbus pewter #985b6739
<<<ANSWER END>>>
<<<ANSWER key=K00224>>>
onyx nimbus harbor boulder nimbus garnet lattice zebra cobalt trellis glacier lattice auburn meadow cinder meadow boulder russet quartz ember saffron verdant kindle onyx #4191f4d6
<<<ANSWER END>>>
<<<ANSWER key=K00363>>>
indigo onyx vellum thistle harbor cobalt boulder cobalt auburn ember saffron meadow verdant crimson falcon russet cobble thistle lantern orbit saffron lantern zebra thistle #af94a2e7
<<<ANSWER END>>>
<<<ANSWER key=K03939>>>
trellis vellum nimbus cedar crimson lantern auburn vellum nimbus fathom harbor glacier harbor boulder indigo nimbus pewter falcon cobalt cobalt pewter nimbus vellum russet #70ccfc34
<<<ANSWER END>>>
<<<ANSWER key=K00977>>>
nimbus crimson thistle indigo lantern meadow cinder cedar marble nimbus kindle saffron boulder quartz pewter trellis cobble meadow kindle willow lantern russet verdant glacier #cac813c2
<<<ANSWER END>>>
<<<ANSWER key=K02004>>>
cedar indigo nimbus cobble harbor trellis vellum garnet thistle ember copper vellum garnet cedar russet mistral cobalt verdant onyx ember spruce harbor meadow cobble #a5f6dac1
<<<ANSWER END>>>
<<<ANSWER key=K01239>>>
vellum cobble marble russet glacier trellis cedar cedar zebra vellum kindle thistle ember meadow vellum thistle cinder orbit zebra saffron crimson harbor cobalt saffron #93d67ba7
<<<ANSWER END>>>
<<<ANSWER key=K00756>>>
fathom orbit russet saffron onyx quartz cedar glacier trellis onyx glacier thistle zebra lantern cedar crimson garnet spruce nimbus lantern lattice saffron verdant auburn #9dea6005
<<<ANSWER END>>>
<<<ANSWER key=K01478>>>
glacier pewter vellum glacier mistral willow spruce kindle quartz lattice orbit mistral thistle saffron trellis zebra nimbus cedar quartz cedar copper lattice marble copper #4e9df11f
<<<ANSWER END>>>
<<<ANSWER key=K03836>>>
orbit thistle orbit cobalt spruce pewter willow orbit lantern orbit trellis harbor thistle mistral pewter auburn zebra cobble cedar cedar ember nimbus lattice onyx #1b447b71
<<<ANSWER END>>>
<<<ANSWER key=K02192>>>
indigo glacier copper cinder verdant nimbus pewter nimbus quartz thistle trellis mistral trellis saffron cobalt cedar lattice cobalt vellum spruce cedar pewter orbit falcon #3f13d401
<<<ANSWER END>>>
<<<ANSWER key=K02045>>>
auburn russet nimbus onyx crimson verdant kindle cinder copper marble cobalt saffron pewter saffron nimbus nimbus zebra cobble zebra boulder pewter cobalt zebra garnet #4ba5a2ce
<<<ANSWER END>>>
<<<ANSWER key=K00325>>>
lantern orbit russet saffron indigo auburn copper pewter fathom boulder zebra harbor mistral meadow trellis cobalt spruce ember quartz saffron cinder pewter fathom glacier #3e9a67a9
<<<ANSWER END>>>
<<<ANSWER key=K00404>>>
quartz kindle trellis russet onyx verdant vellum lantern boulder ember willow orbit zebra nimbus fathom harbor lantern spruce cinder garnet indigo fathom trellis marble #b26b1380
<<<ANSWER END>>>
<<<ANSWER key=K01689>>>
harbor trellis lattice glacier fathom thistle cobble zebra kindle marble falcon copper meadow boulder nimbus indigo saffron onyx spruce falcon zebra zebra zebra indigo #6c0cdf80
<<<ANSWER END>>>
<<<ANSWER key=K03596>>>
cinder cobalt trellis spruce ember thistle garnet garnet auburn auburn pewter cobalt ember crimson mistral cedar garnet cedar verdant willow garnet pewter onyx russet #7376b3d3
<<<ANSWER END>>>
<<<ANSWER key=K02034>>>
cinder spruce russet trellis trellis onyx cobble zebra cobble ember ember kindle verdant meadow ember ember lattice cobble mistral garnet quartz falcon orbit cedar #69077f50
<<<ANSWER END>>>
<<<ANSWER key=K00388>>>
marble ember quartz spruce zebra saffron cedar willow cinder crimson cedar cobalt orbit auburn onyx kindle trellis marble marble verdant cinder russet orbit fathom #9dc7f7db
<<<ANSWER END>>>
<<<ANSWER key=K01250>>>
ember meadow trellis marble marble zebra cinder indigo crimson kindle crimson glacier cobble russet cobalt verdant glacier copper orbit auburn harbor russet kindle russet #eacfc430
<<<ANSWER END>>>
<<<ANSWER key=K02910>>>
cedar russet russet boulder nimbus harbor onyx vellum meadow auburn boulder indigo falcon copper ember boulder copper boulder spruce quartz auburn zebra glacier verdant #88ff9b59
<<<ANSWER END>>>
<<<ANSWER key=K00532>>>
vellum vellum spruce cedar pewter auburn ember cobalt nimbus fathom kindle ember harbor pewter ember cobble copper glacier onyx cedar pewter cobalt fathom lattice #cac05cd5
<<<ANSWER END>>>
<<<ANSWER key=K00695>>>
harbor quartz zebra verdant zebra marble mistral cinder indigo fathom boulder quartz trellis verdant fathom meadow cobalt boulder copper vellum mistral fathom garnet zebra #140ac9c6
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
