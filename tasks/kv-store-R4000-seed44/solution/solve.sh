#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00677>>>
vellum orbit lantern cinder meadow copper indigo onyx kindle zebra cedar marble indigo onyx willow lantern ember cobble russet vellum russet falcon glacier verdant #3662880a
<<<ANSWER END>>>
<<<ANSWER key=K02909>>>
nimbus indigo willow thistle willow lattice verdant cinder lattice onyx garnet cinder lattice meadow crimson lantern cinder trellis quartz cobalt cedar cedar lantern trellis #de082571
<<<ANSWER END>>>
<<<ANSWER key=K00050>>>
glacier russet ember marble copper trellis copper cobble harbor kindle indigo trellis harbor crimson spruce nimbus pewter copper lattice nimbus spruce mistral boulder cedar #bc3666ab
<<<ANSWER END>>>
<<<ANSWER key=K00908>>>
lattice willow quartz harbor lantern falcon mistral pewter cinder willow willow ember orbit lattice cobalt harbor cobalt spruce saffron boulder marble orbit zebra garnet #8d09d41c
<<<ANSWER END>>>
<<<ANSWER key=K02891>>>
indigo cobalt harbor orbit lantern mistral pewter lattice orbit russet spruce cinder garnet auburn marble ember verdant russet saffron cedar ember lattice thistle kindle #e37955c3
<<<ANSWER END>>>
<<<ANSWER key=K02968>>>
meadow pewter cedar kindle russet vellum boulder onyx fathom crimson quartz russet onyx trellis lattice nimbus boulder quartz falcon falcon nimbus boulder spruce lantern #3de959b8
<<<ANSWER END>>>
<<<ANSWER key=K01534>>>
pewter ember spruce trellis nimbus willow fathom spruce ember vellum saffron cobalt cedar boulder vellum fathom meadow mistral lantern auburn crimson fathom cinder vellum #c7b78452
<<<ANSWER END>>>
<<<ANSWER key=K01918>>>
lantern russet indigo pewter fathom garnet copper cobble saffron ember cedar lattice quartz lantern russet zebra verdant cobalt cedar meadow thistle orbit verdant spruce #f39ed541
<<<ANSWER END>>>
<<<ANSWER key=K02421>>>
willow fathom mistral ember nimbus onyx marble thistle nimbus russet cinder trellis thistle thistle mistral russet boulder saffron crimson indigo boulder vellum willow crimson #30373a76
<<<ANSWER END>>>
<<<ANSWER key=K00039>>>
lattice cinder marble boulder harbor spruce ember ember cobalt pewter spruce willow kindle nimbus zebra nimbus cobble kindle copper glacier ember trellis trellis verdant #b14cd6e6
<<<ANSWER END>>>
<<<ANSWER key=K02627>>>
falcon verdant verdant mistral cobalt fathom meadow saffron thistle cobble meadow pewter ember auburn copper pewter orbit spruce fathom trellis copper russet glacier russet #7547e4bd
<<<ANSWER END>>>
<<<ANSWER key=K00072>>>
boulder onyx glacier boulder copper ember cobalt glacier falcon mistral mistral auburn quartz cobalt trellis verdant lattice cinder fathom zebra falcon orbit trellis thistle #a1b2e739
<<<ANSWER END>>>
<<<ANSWER key=K03129>>>
orbit verdant spruce mistral nimbus mistral cedar cobble auburn onyx willow fathom indigo crimson auburn nimbus kindle harbor lantern pewter mistral trellis boulder lantern #2186cdeb
<<<ANSWER END>>>
<<<ANSWER key=K01185>>>
crimson copper cedar vellum crimson lantern trellis kindle pewter lattice nimbus cobble vellum mistral onyx pewter kindle kindle crimson lantern cedar willow saffron glacier #b187fc0d
<<<ANSWER END>>>
<<<ANSWER key=K03917>>>
harbor mistral vellum ember zebra cedar garnet cinder mistral copper thistle quartz thistle marble verdant trellis fathom kindle saffron marble glacier auburn orbit kindle #2a08735e
<<<ANSWER END>>>
<<<ANSWER key=K02080>>>
russet pewter garnet saffron auburn pewter crimson cobble lattice indigo auburn falcon mistral fathom boulder pewter garnet lattice boulder falcon fathom thistle copper orbit #cdf570a4
<<<ANSWER END>>>
<<<ANSWER key=K01642>>>
spruce garnet orbit indigo russet harbor glacier saffron glacier pewter zebra pewter lattice cobble zebra saffron glacier willow vellum thistle verdant cobble indigo onyx #c287e8bb
<<<ANSWER END>>>
<<<ANSWER key=K03299>>>
mistral meadow quartz cedar harbor cobble verdant saffron crimson ember cedar spruce meadow harbor glacier onyx nimbus orbit falcon auburn willow onyx thistle vellum #74cf6d9c
<<<ANSWER END>>>
<<<ANSWER key=K00825>>>
lantern spruce lattice saffron ember indigo quartz cobble lantern nimbus glacier mistral mistral russet willow harbor cobalt marble mistral harbor cobble mistral glacier lantern #dd5344da
<<<ANSWER END>>>
<<<ANSWER key=K00665>>>
cedar auburn trellis meadow ember vellum falcon harbor trellis marble auburn boulder garnet kindle cobalt fathom copper trellis onyx nimbus boulder copper marble cobalt #cef2f5ad
<<<ANSWER END>>>
<<<ANSWER key=K02045>>>
lantern russet quartz willow auburn cobble quartz willow cinder indigo auburn fathom lattice willow zebra russet nimbus onyx cedar garnet quartz thistle verdant ember #d12285de
<<<ANSWER END>>>
<<<ANSWER key=K02654>>>
nimbus fathom lattice boulder cinder cobalt garnet lantern verdant auburn cobble glacier cinder glacier trellis falcon garnet trellis ember quartz willow glacier garnet marble #1d1d3cf9
<<<ANSWER END>>>
<<<ANSWER key=K00289>>>
pewter verdant cobble quartz crimson boulder boulder copper pewter cobble orbit thistle glacier auburn thistle cinder orbit marble boulder cobalt harbor mistral lantern trellis #1fab057c
<<<ANSWER END>>>
<<<ANSWER key=K03425>>>
garnet verdant russet mistral lantern cobble garnet auburn orbit orbit spruce copper mistral russet russet mistral cedar zebra auburn marble marble kindle saffron onyx #f5e95cf2
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
