#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00033>>>
vellum cobalt glacier pewter glacier thistle indigo kindle harbor saffron lattice quartz harbor cobalt nimbus orbit fathom nimbus thistle boulder zebra glacier nimbus cobalt #ad93d4c5
<<<ANSWER END>>>
<<<ANSWER key=K00121>>>
fathom pewter willow indigo boulder marble crimson verdant russet indigo lantern lattice cobble mistral mistral falcon saffron ember russet fathom harbor ember garnet orbit #5f307f97
<<<ANSWER END>>>
<<<ANSWER key=K00203>>>
cinder cobble lattice pewter cedar nimbus saffron marble meadow mistral cobalt harbor falcon lattice lattice ember russet harbor thistle cinder zebra pewter zebra falcon #5b885cbf
<<<ANSWER END>>>
<<<ANSWER key=K00188>>>
cobalt vellum cedar kindle lantern indigo thistle copper ember russet mistral crimson boulder boulder thistle meadow orbit meadow onyx mistral kindle thistle pewter kindle #e0ae3071
<<<ANSWER END>>>
<<<ANSWER key=K00091>>>
lattice marble orbit kindle lantern boulder nimbus russet nimbus cobble boulder fathom willow mistral vellum lattice cobble cedar cobalt falcon onyx kindle thistle falcon #f216545c
<<<ANSWER END>>>
<<<ANSWER key=K00164>>>
verdant verdant zebra thistle nimbus crimson quartz kindle verdant saffron lattice pewter trellis meadow lantern cobble mistral boulder quartz auburn lattice marble kindle kindle #991b529d
<<<ANSWER END>>>
<<<ANSWER key=K00253>>>
nimbus garnet kindle copper glacier copper boulder fathom crimson vellum glacier saffron kindle pewter cobalt cinder copper vellum glacier cedar kindle garnet cedar auburn #24bb948e
<<<ANSWER END>>>
<<<ANSWER key=K00113>>>
copper auburn orbit ember auburn trellis cobble glacier cobalt indigo lattice nimbus cobalt glacier saffron nimbus vellum crimson onyx spruce cinder cobble mistral onyx #5fb5f0b7
<<<ANSWER END>>>
<<<ANSWER key=K00122>>>
pewter kindle verdant fathom zebra verdant auburn russet cobalt cinder saffron meadow verdant nimbus onyx thistle kindle cobalt vellum willow auburn mistral copper cinder #60c146ad
<<<ANSWER END>>>
<<<ANSWER key=K00227>>>
quartz zebra orbit nimbus marble indigo kindle harbor cedar fathom indigo quartz spruce harbor glacier kindle ember onyx meadow onyx lattice zebra nimbus harbor #9f6ac71e
<<<ANSWER END>>>
<<<ANSWER key=K00028>>>
cobalt mistral verdant russet marble orbit glacier trellis auburn indigo orbit meadow indigo garnet fathom marble fathom fathom cobble boulder glacier cinder kindle falcon #f49583ef
<<<ANSWER END>>>
<<<ANSWER key=K00034>>>
vellum saffron thistle trellis cedar cobble willow quartz falcon mistral falcon trellis indigo garnet crimson trellis cedar crimson cinder nimbus saffron cobble cedar vellum #cce2ae02
<<<ANSWER END>>>
<<<ANSWER key=K00085>>>
lattice copper marble verdant indigo onyx zebra cedar boulder orbit nimbus spruce cobalt saffron russet ember orbit orbit willow boulder harbor russet kindle auburn #b75a8a52
<<<ANSWER END>>>
<<<ANSWER key=K00154>>>
cinder cobalt saffron russet zebra russet vellum meadow russet willow onyx cedar kindle garnet boulder trellis fathom crimson saffron kindle willow indigo willow lantern #a528ba8e
<<<ANSWER END>>>
<<<ANSWER key=K00178>>>
quartz marble lantern cinder harbor ember auburn meadow cedar cedar lattice kindle onyx lattice fathom auburn cobalt vellum verdant nimbus cinder auburn cedar crimson #e5abe42b
<<<ANSWER END>>>
<<<ANSWER key=K00211>>>
nimbus kindle trellis orbit trellis lattice nimbus marble lattice verdant lattice garnet cobalt cedar fathom boulder cinder orbit cobalt trellis ember orbit fathom marble #9e08f6cb
<<<ANSWER END>>>
<<<ANSWER key=K00146>>>
copper lantern lattice crimson copper vellum saffron glacier garnet pewter verdant quartz onyx willow cinder vellum cobble saffron orbit thistle lantern fathom lattice zebra #a681fcfa
<<<ANSWER END>>>
<<<ANSWER key=K00137>>>
cobble quartz harbor auburn willow cedar trellis falcon glacier cedar indigo spruce falcon falcon garnet spruce quartz cobalt willow auburn spruce garnet spruce quartz #3c5fcb49
<<<ANSWER END>>>
<<<ANSWER key=K00223>>>
meadow garnet garnet kindle harbor harbor indigo mistral kindle cinder marble quartz cobble mistral lattice verdant orbit lattice russet lattice copper lattice harbor vellum #453c7dc2
<<<ANSWER END>>>
<<<ANSWER key=K00077>>>
garnet vellum crimson zebra cobble garnet pewter ember spruce glacier cinder lattice harbor boulder onyx russet falcon boulder garnet verdant auburn kindle trellis cinder #54dc88d6
<<<ANSWER END>>>
<<<ANSWER key=K00007>>>
thistle garnet garnet saffron mistral crimson cedar boulder zebra indigo mistral russet auburn meadow thistle kindle russet mistral lattice trellis onyx pewter cobalt thistle #08d22c14
<<<ANSWER END>>>
<<<ANSWER key=K00038>>>
copper copper cobalt cobble indigo saffron lattice pewter orbit indigo cobble marble thistle kindle trellis nimbus spruce saffron cedar kindle saffron harbor harbor glacier #a170a0e5
<<<ANSWER END>>>
<<<ANSWER key=K00004>>>
copper kindle spruce thistle saffron vellum lantern ember onyx meadow lattice crimson indigo zebra quartz nimbus fathom cobble cedar cobble kindle garnet lantern meadow #74ea6336
<<<ANSWER END>>>
<<<ANSWER key=K00078>>>
verdant vellum lantern willow falcon copper marble ember trellis cobalt russet glacier thistle glacier lantern spruce cedar kindle saffron mistral falcon quartz zebra orbit #562d85ed
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
