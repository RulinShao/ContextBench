#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K01726>>>
saffron mistral cobble willow marble willow auburn cobble glacier zebra glacier cobalt cedar spruce meadow kindle cobble thistle thistle copper nimbus fathom indigo cedar #7ad6eb5f
<<<ANSWER END>>>
<<<ANSWER key=K01257>>>
marble onyx onyx indigo lattice trellis thistle meadow ember verdant garnet falcon fathom cedar orbit trellis thistle cobble trellis lattice zebra meadow fathom spruce #32f56003
<<<ANSWER END>>>
<<<ANSWER key=K01294>>>
falcon onyx quartz vellum lantern marble kindle russet cobalt cobble cedar fathom harbor harbor cobalt copper glacier quartz falcon willow orbit trellis copper kindle #72f60a9e
<<<ANSWER END>>>
<<<ANSWER key=K01540>>>
pewter onyx saffron lattice pewter thistle lantern spruce glacier copper cobalt copper quartz meadow lattice lattice onyx saffron trellis trellis willow trellis verdant auburn #5fef5965
<<<ANSWER END>>>
<<<ANSWER key=K01238>>>
crimson falcon vellum cobble kindle vellum onyx lantern quartz cedar orbit copper cobble auburn indigo harbor nimbus lantern falcon quartz indigo zebra zebra trellis #204ca6e4
<<<ANSWER END>>>
<<<ANSWER key=K00600>>>
glacier pewter trellis lantern harbor cinder boulder pewter fathom garnet nimbus falcon cobalt thistle cedar cedar vellum nimbus cedar cedar auburn lantern crimson thistle #58db3f8e
<<<ANSWER END>>>
<<<ANSWER key=K01001>>>
marble pewter copper russet saffron russet quartz quartz mistral glacier garnet cobble saffron russet glacier cinder lattice fathom kindle willow quartz pewter kindle quartz #651ce0c3
<<<ANSWER END>>>
<<<ANSWER key=K00354>>>
cinder pewter nimbus ember mistral nimbus mistral verdant falcon boulder thistle ember cobble spruce lattice verdant glacier vellum mistral orbit meadow zebra onyx lattice #b71eea13
<<<ANSWER END>>>
<<<ANSWER key=K01584>>>
orbit boulder thistle crimson cedar pewter marble ember spruce cedar glacier lantern boulder meadow verdant russet pewter trellis lantern glacier saffron willow kindle orbit #b671f225
<<<ANSWER END>>>
<<<ANSWER key=K01899>>>
russet ember mistral ember willow indigo copper zebra cobble lantern cobble copper zebra trellis meadow onyx spruce spruce quartz verdant spruce thistle falcon spruce #4af5ad6a
<<<ANSWER END>>>
<<<ANSWER key=K01862>>>
kindle harbor orbit glacier trellis cinder lantern meadow indigo lantern nimbus nimbus quartz kindle boulder boulder harbor crimson verdant cobalt onyx garnet cobble marble #61b37923
<<<ANSWER END>>>
<<<ANSWER key=K01784>>>
falcon spruce spruce cobble falcon lantern cinder trellis indigo garnet spruce boulder cinder mistral zebra lantern orbit meadow glacier ember mistral spruce orbit marble #c2a8dc95
<<<ANSWER END>>>
<<<ANSWER key=K01415>>>
meadow harbor onyx indigo auburn russet willow indigo vellum falcon meadow harbor verdant lattice indigo pewter mistral falcon marble ember vellum lantern fathom willow #3891c38d
<<<ANSWER END>>>
<<<ANSWER key=K01677>>>
pewter kindle pewter onyx lantern orbit auburn copper quartz saffron verdant spruce fathom lantern cedar kindle crimson quartz ember glacier spruce auburn verdant trellis #f635cc26
<<<ANSWER END>>>
<<<ANSWER key=K01389>>>
spruce indigo willow mistral mistral glacier marble willow meadow auburn willow cobble marble meadow thistle glacier garnet harbor glacier cedar indigo copper mistral mistral #7546a001
<<<ANSWER END>>>
<<<ANSWER key=K01475>>>
cobble indigo willow indigo cobalt boulder copper mistral saffron copper fathom verdant kindle copper quartz crimson onyx verdant quartz verdant copper meadow mistral meadow #4072b7a4
<<<ANSWER END>>>
<<<ANSWER key=K00961>>>
spruce cedar cinder garnet trellis falcon falcon harbor lantern pewter cinder marble vellum crimson auburn quartz garnet saffron fathom crimson kindle kindle spruce harbor #7b947be2
<<<ANSWER END>>>
<<<ANSWER key=K01622>>>
orbit cobalt zebra garnet meadow trellis cobble lantern kindle trellis harbor cobalt trellis orbit boulder cinder willow zebra cedar garnet lantern fathom meadow nimbus #4a3f80c6
<<<ANSWER END>>>
<<<ANSWER key=K00828>>>
indigo harbor vellum harbor ember boulder pewter cobble zebra spruce copper cobble marble meadow thistle russet russet trellis vellum spruce cinder quartz cedar willow #2a030d45
<<<ANSWER END>>>
<<<ANSWER key=K00800>>>
russet nimbus saffron vellum orbit crimson saffron falcon trellis lantern quartz nimbus crimson trellis saffron quartz garnet quartz willow orbit cobble orbit willow cobble #9eabe07d
<<<ANSWER END>>>
<<<ANSWER key=K00720>>>
kindle vellum lattice nimbus spruce verdant copper lattice zebra russet fathom saffron thistle cobalt zebra fathom auburn kindle russet zebra boulder mistral thistle ember #e1be2be7
<<<ANSWER END>>>
<<<ANSWER key=K00435>>>
cedar nimbus boulder trellis crimson zebra fathom lantern vellum orbit garnet spruce meadow fathom pewter thistle cedar lantern auburn falcon verdant orbit quartz ember #47150cc3
<<<ANSWER END>>>
<<<ANSWER key=K01040>>>
spruce cobble lattice auburn orbit fathom russet pewter copper glacier trellis lantern orbit trellis cobble trellis auburn vellum cobalt cinder vellum saffron marble meadow #f27211e3
<<<ANSWER END>>>
<<<ANSWER key=K00673>>>
boulder glacier cobalt falcon cinder saffron cobalt auburn kindle boulder crimson meadow kindle thistle auburn falcon onyx zebra glacier mistral crimson boulder verdant fathom #10cf8158
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
