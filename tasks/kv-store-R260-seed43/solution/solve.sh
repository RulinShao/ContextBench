#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00129>>>
thistle willow vellum quartz crimson glacier zebra meadow cinder cinder mistral willow kindle cedar nimbus verdant crimson orbit russet mistral verdant crimson trellis boulder #cf24b467
<<<ANSWER END>>>
<<<ANSWER key=K00147>>>
ember quartz vellum indigo thistle trellis harbor indigo harbor verdant mistral orbit quartz saffron lantern cobalt mistral orbit indigo vellum spruce lattice saffron spruce #7b4174a4
<<<ANSWER END>>>
<<<ANSWER key=K00178>>>
thistle orbit lantern marble lattice harbor harbor verdant cedar boulder ember falcon mistral saffron garnet quartz onyx pewter auburn onyx saffron orbit lattice kindle #027bb300
<<<ANSWER END>>>
<<<ANSWER key=K00152>>>
harbor harbor willow onyx pewter kindle garnet thistle mistral zebra fathom marble onyx zebra trellis harbor zebra nimbus russet marble saffron auburn cobble lattice #69f405b3
<<<ANSWER END>>>
<<<ANSWER key=K00079>>>
trellis verdant onyx orbit vellum boulder ember ember nimbus verdant kindle boulder meadow marble copper thistle kindle thistle garnet lattice quartz kindle auburn glacier #edf74cd5
<<<ANSWER END>>>
<<<ANSWER key=K00215>>>
nimbus copper vellum russet spruce cinder saffron orbit meadow trellis mistral crimson kindle orbit zebra meadow fathom thistle russet zebra saffron crimson trellis trellis #a4514e40
<<<ANSWER END>>>
<<<ANSWER key=K00144>>>
verdant mistral copper marble thistle meadow cobalt copper lantern quartz russet lantern cinder nimbus saffron lattice cedar lattice verdant kindle meadow copper ember fathom #9847dbc4
<<<ANSWER END>>>
<<<ANSWER key=K00103>>>
fathom boulder cinder lantern falcon onyx trellis cedar quartz meadow glacier cedar cobble zebra verdant thistle willow quartz ember vellum trellis spruce meadow mistral #8df224c3
<<<ANSWER END>>>
<<<ANSWER key=K00192>>>
cobble cobalt glacier russet crimson russet glacier crimson copper pewter cobalt glacier marble auburn orbit crimson trellis kindle cedar cobble verdant trellis fathom spruce #0a9d5da5
<<<ANSWER END>>>
<<<ANSWER key=K00025>>>
onyx nimbus garnet mistral orbit ember garnet zebra onyx lantern boulder vellum saffron quartz verdant marble indigo auburn lattice kindle auburn thistle verdant boulder #82bf3f30
<<<ANSWER END>>>
<<<ANSWER key=K00184>>>
harbor ember marble lantern orbit saffron nimbus lattice mistral kindle fathom spruce kindle mistral cedar quartz garnet lattice indigo spruce meadow zebra nimbus nimbus #ceb1cf6c
<<<ANSWER END>>>
<<<ANSWER key=K00100>>>
cobble kindle lantern marble fathom fathom cedar saffron kindle marble verdant lattice copper vellum meadow crimson russet cobalt harbor onyx russet lattice meadow vellum #f80ea84d
<<<ANSWER END>>>
<<<ANSWER key=K00146>>>
marble falcon meadow kindle harbor fathom trellis mistral glacier harbor crimson cobble nimbus verdant vellum crimson orbit copper orbit cobble orbit lantern ember boulder #6b60f265
<<<ANSWER END>>>
<<<ANSWER key=K00038>>>
cinder harbor kindle boulder mistral zebra glacier copper boulder crimson cedar quartz crimson cinder verdant cobble lantern auburn cobalt pewter lantern ember crimson orbit #f232ef00
<<<ANSWER END>>>
<<<ANSWER key=K00070>>>
willow spruce glacier cedar fathom indigo mistral meadow cobble falcon cobalt saffron thistle harbor russet fathom garnet cobalt verdant saffron glacier orbit fathom lantern #445d6fa6
<<<ANSWER END>>>
<<<ANSWER key=K00128>>>
boulder cinder glacier trellis cobble fathom willow russet copper cobalt onyx crimson meadow mistral spruce copper zebra zebra auburn cedar pewter spruce quartz zebra #daf34c6e
<<<ANSWER END>>>
<<<ANSWER key=K00065>>>
harbor verdant russet garnet marble indigo spruce spruce verdant onyx onyx garnet kindle marble thistle spruce onyx nimbus glacier mistral auburn crimson copper pewter #e5065938
<<<ANSWER END>>>
<<<ANSWER key=K00041>>>
fathom glacier thistle onyx orbit ember thistle trellis cobble nimbus indigo ember vellum onyx crimson indigo lattice crimson lattice vellum onyx quartz copper falcon #def20faf
<<<ANSWER END>>>
<<<ANSWER key=K00241>>>
glacier trellis onyx pewter boulder pewter kindle quartz orbit crimson kindle marble willow willow copper ember meadow quartz quartz lattice boulder onyx cobalt meadow #f6ee7620
<<<ANSWER END>>>
<<<ANSWER key=K00114>>>
ember cobalt saffron harbor fathom harbor russet kindle pewter auburn crimson saffron willow ember trellis lantern verdant saffron ember trellis saffron crimson boulder orbit #c8c73d80
<<<ANSWER END>>>
<<<ANSWER key=K00012>>>
crimson copper pewter glacier ember onyx garnet orbit lantern cobalt marble thistle cedar pewter falcon zebra spruce zebra ember thistle trellis crimson meadow fathom #161ac7e1
<<<ANSWER END>>>
<<<ANSWER key=K00090>>>
harbor cinder glacier boulder onyx boulder auburn trellis fathom pewter kindle willow nimbus vellum verdant lattice orbit marble zebra russet willow quartz lantern cobalt #33ae25b4
<<<ANSWER END>>>
<<<ANSWER key=K00159>>>
auburn boulder auburn thistle trellis willow lantern vellum boulder russet vellum glacier crimson copper quartz thistle crimson russet boulder cobalt lattice verdant cedar falcon #4ff1770f
<<<ANSWER END>>>
<<<ANSWER key=K00217>>>
spruce copper pewter spruce quartz cobalt cinder zebra spruce copper indigo nimbus quartz thistle quartz fathom mistral lattice falcon copper orbit crimson verdant auburn #b0e604a1
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
