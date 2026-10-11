#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00974>>>
boulder boulder harbor thistle crimson garnet trellis cobalt cedar cinder russet cobalt zebra cedar meadow crimson crimson trellis saffron boulder orbit kindle meadow meadow #3eafa2e4
<<<ANSWER END>>>
<<<ANSWER key=K01968>>>
willow meadow cobble verdant vellum harbor saffron cobble russet cobalt trellis ember kindle willow falcon boulder verdant vellum vellum indigo cobalt cobble quartz willow #1704e95a
<<<ANSWER END>>>
<<<ANSWER key=K01506>>>
spruce cobble willow spruce zebra willow nimbus ember marble garnet trellis zebra kindle pewter glacier harbor nimbus vellum cinder thistle marble crimson willow quartz #73142c10
<<<ANSWER END>>>
<<<ANSWER key=K01690>>>
cobble cinder nimbus indigo auburn orbit falcon indigo auburn orbit verdant marble vellum nimbus marble zebra copper russet boulder auburn ember spruce boulder zebra #1ca15a8e
<<<ANSWER END>>>
<<<ANSWER key=K00284>>>
orbit cedar cinder cedar auburn cobble indigo meadow russet onyx falcon falcon lantern lattice kindle cinder onyx zebra trellis kindle meadow willow onyx garnet #dee5f7b3
<<<ANSWER END>>>
<<<ANSWER key=K02938>>>
mistral cobble kindle kindle fathom boulder boulder mistral cobble boulder lantern zebra kindle lattice pewter mistral trellis pewter cedar onyx thistle willow willow garnet #3a1a1386
<<<ANSWER END>>>
<<<ANSWER key=K00298>>>
auburn copper vellum fathom spruce glacier onyx ember mistral auburn falcon boulder auburn mistral onyx quartz spruce marble cobalt onyx quartz verdant boulder cinder #7fb76499
<<<ANSWER END>>>
<<<ANSWER key=K02491>>>
garnet thistle fathom saffron garnet mistral russet lattice ember cobalt cobalt indigo crimson trellis quartz auburn cobble nimbus cobble fathom zebra auburn mistral spruce #fcc07c7c
<<<ANSWER END>>>
<<<ANSWER key=K01014>>>
auburn cobalt quartz kindle indigo spruce willow kindle onyx saffron cinder lantern boulder kindle auburn meadow trellis quartz cinder zebra zebra thistle willow zebra #1c038e0f
<<<ANSWER END>>>
<<<ANSWER key=K03969>>>
mistral fathom boulder garnet cedar cobble zebra harbor saffron russet nimbus meadow spruce lantern cobble marble orbit trellis onyx harbor garnet meadow meadow trellis #e684431e
<<<ANSWER END>>>
<<<ANSWER key=K01414>>>
nimbus nimbus cobble willow kindle copper vellum zebra spruce zebra meadow russet quartz crimson cedar spruce russet garnet cobalt vellum harbor mistral vellum saffron #6369a8bf
<<<ANSWER END>>>
<<<ANSWER key=K01192>>>
fathom harbor pewter meadow cobalt trellis copper zebra cinder glacier mistral boulder onyx orbit cobble mistral boulder falcon cobalt lattice nimbus spruce cobalt cedar #5aee18fb
<<<ANSWER END>>>
<<<ANSWER key=K03511>>>
willow zebra indigo vellum verdant thistle copper lantern lattice vellum kindle quartz quartz spruce crimson auburn willow kindle zebra verdant marble vellum lattice orbit #5c5aa3b5
<<<ANSWER END>>>
<<<ANSWER key=K03150>>>
cobble cedar lantern willow kindle verdant thistle russet cinder copper auburn boulder harbor garnet lattice nimbus copper pewter quartz auburn nimbus quartz trellis onyx #09c93f9b
<<<ANSWER END>>>
<<<ANSWER key=K02605>>>
glacier cobble saffron cedar orbit cedar vellum crimson pewter spruce russet nimbus cobble vellum zebra onyx auburn kindle russet cedar cinder russet cobalt spruce #6ae18bbe
<<<ANSWER END>>>
<<<ANSWER key=K01723>>>
orbit nimbus willow fathom fathom marble glacier russet nimbus copper auburn ember trellis auburn kindle meadow onyx glacier garnet orbit trellis cinder lantern onyx #deb4feec
<<<ANSWER END>>>
<<<ANSWER key=K02805>>>
trellis lattice glacier willow marble saffron saffron pewter quartz pewter mistral lantern russet spruce cinder quartz harbor russet cedar indigo meadow mistral garnet glacier #df30e90d
<<<ANSWER END>>>
<<<ANSWER key=K00034>>>
kindle harbor glacier crimson orbit lantern thistle willow lattice kindle cobalt cobalt saffron pewter kindle nimbus thistle lantern mistral cinder cedar boulder orbit verdant #8f5bc346
<<<ANSWER END>>>
<<<ANSWER key=K01744>>>
auburn boulder spruce willow pewter fathom cobalt willow quartz saffron copper nimbus pewter glacier falcon garnet quartz falcon cobalt boulder willow auburn vellum mistral #2e1f8575
<<<ANSWER END>>>
<<<ANSWER key=K02728>>>
mistral spruce garnet thistle quartz harbor glacier cinder orbit glacier auburn cobble verdant indigo verdant verdant onyx crimson quartz cedar kindle glacier garnet ember #9ad7b0f3
<<<ANSWER END>>>
<<<ANSWER key=K01183>>>
garnet vellum cedar spruce harbor cinder cedar falcon cobble marble falcon cobble cedar lantern orbit marble spruce trellis saffron nimbus indigo orbit meadow meadow #7c814e49
<<<ANSWER END>>>
<<<ANSWER key=K00058>>>
auburn harbor russet willow glacier fathom russet copper auburn copper ember verdant boulder copper cedar cobalt garnet pewter ember crimson ember copper saffron cedar #71cb7f99
<<<ANSWER END>>>
<<<ANSWER key=K02431>>>
glacier falcon quartz ember lantern zebra lattice boulder spruce zebra russet vellum quartz cobble cedar glacier crimson glacier verdant willow onyx meadow harbor mistral #b7f6961e
<<<ANSWER END>>>
<<<ANSWER key=K02140>>>
pewter fathom glacier pewter garnet crimson falcon garnet garnet harbor auburn cedar indigo harbor cedar onyx trellis pewter cobalt zebra cobalt harbor marble boulder #f276d47c
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
