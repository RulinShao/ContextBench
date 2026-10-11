#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00085>>>
lattice copper marble verdant indigo onyx zebra cedar boulder orbit nimbus spruce cobalt saffron russet ember orbit orbit willow boulder harbor russet kindle auburn #b75a8a52
<<<ANSWER END>>>
<<<ANSWER key=K00035>>>
lantern lattice falcon spruce fathom nimbus nimbus nimbus orbit pewter glacier spruce trellis saffron cobalt trellis marble zebra russet trellis falcon boulder garnet nimbus #17e6a22a
<<<ANSWER END>>>
<<<ANSWER key=K00049>>>
willow saffron lattice willow verdant mistral lattice quartz willow cinder onyx glacier nimbus auburn crimson thistle cinder harbor meadow thistle quartz thistle meadow pewter #eddaf9c7
<<<ANSWER END>>>
<<<ANSWER key=K00010>>>
crimson auburn garnet nimbus auburn zebra nimbus nimbus meadow cobble onyx orbit marble garnet nimbus spruce lantern quartz meadow auburn lantern auburn cobble garnet #436701db
<<<ANSWER END>>>
<<<ANSWER key=K00115>>>
zebra crimson harbor pewter ember harbor mistral spruce thistle verdant crimson falcon cedar russet harbor russet nimbus indigo orbit zebra nimbus harbor harbor kindle #adff8db7
<<<ANSWER END>>>
<<<ANSWER key=K00125>>>
cobalt cobalt cedar cobalt meadow lattice boulder boulder vellum harbor auburn garnet lattice vellum lantern copper saffron russet meadow verdant cobble indigo indigo russet #c965c202
<<<ANSWER END>>>
<<<ANSWER key=K00037>>>
glacier verdant ember auburn cinder quartz cobalt cinder falcon falcon lantern indigo mistral crimson verdant spruce mistral trellis cedar indigo meadow orbit falcon nimbus #de563521
<<<ANSWER END>>>
<<<ANSWER key=K00078>>>
verdant vellum lantern willow falcon copper marble ember trellis cobalt russet glacier thistle glacier lantern spruce cedar kindle saffron mistral falcon quartz zebra orbit #562d85ed
<<<ANSWER END>>>
<<<ANSWER key=K00099>>>
garnet falcon russet trellis kindle cinder willow boulder glacier cinder indigo meadow garnet lattice nimbus lattice orbit lattice fathom pewter orbit crimson lantern marble #f1beb075
<<<ANSWER END>>>
<<<ANSWER key=K00127>>>
nimbus cedar lantern orbit thistle thistle garnet lantern cobalt zebra meadow garnet pewter pewter saffron falcon garnet indigo pewter cedar kindle marble auburn cedar #110e7873
<<<ANSWER END>>>
<<<ANSWER key=K00057>>>
crimson garnet willow mistral copper spruce cobalt cobalt meadow onyx fathom willow nimbus harbor vellum meadow pewter lattice auburn cedar cobble meadow cobble cedar #1b6c6459
<<<ANSWER END>>>
<<<ANSWER key=K00054>>>
indigo lattice lattice lattice harbor cobalt indigo cobalt russet mistral fathom garnet verdant auburn harbor boulder ember vellum cinder indigo falcon falcon zebra harbor #f4df9d68
<<<ANSWER END>>>
<<<ANSWER key=K00041>>>
falcon cobble lattice cedar cinder nimbus garnet marble zebra onyx garnet marble cinder crimson cinder fathom meadow cobble cedar spruce cedar lantern falcon cobble #1e84249b
<<<ANSWER END>>>
<<<ANSWER key=K00095>>>
trellis saffron auburn lantern saffron lantern trellis onyx willow saffron cobalt verdant cinder vellum russet kindle verdant quartz copper thistle ember nimbus verdant boulder #42f4c0f8
<<<ANSWER END>>>
<<<ANSWER key=K00029>>>
verdant pewter nimbus cedar falcon zebra crimson fathom indigo boulder cedar verdant verdant fathom nimbus glacier lattice nimbus harbor cobble meadow zebra spruce garnet #2b43e1ed
<<<ANSWER END>>>
<<<ANSWER key=K00097>>>
meadow lantern meadow marble fathom thistle russet auburn quartz copper trellis lantern kindle glacier cinder russet willow crimson ember boulder indigo mistral kindle meadow #581a7f8f
<<<ANSWER END>>>
<<<ANSWER key=K00063>>>
cinder harbor kindle mistral marble cobble onyx zebra copper trellis falcon russet falcon pewter cobalt cobble auburn pewter cobble crimson glacier falcon cedar verdant #bc076a5d
<<<ANSWER END>>>
<<<ANSWER key=K00123>>>
crimson russet cinder nimbus cedar onyx lattice marble orbit zebra meadow onyx cedar indigo auburn lattice glacier saffron indigo mistral indigo auburn thistle cobble #92dfb910
<<<ANSWER END>>>
<<<ANSWER key=K00111>>>
copper crimson kindle saffron fathom nimbus cobble lantern garnet meadow falcon saffron ember lattice verdant boulder garnet kindle thistle cobble falcon zebra lantern cobble #156f34e8
<<<ANSWER END>>>
<<<ANSWER key=K00124>>>
pewter garnet indigo falcon lattice garnet pewter orbit auburn meadow cobble auburn pewter orbit trellis ember marble crimson cinder pewter marble pewter fathom pewter #72e2cf12
<<<ANSWER END>>>
<<<ANSWER key=K00009>>>
orbit willow russet lantern crimson cinder garnet kindle vellum indigo boulder thistle trellis ember harbor cinder verdant cobble cinder falcon fathom fathom indigo glacier #8ce99a30
<<<ANSWER END>>>
<<<ANSWER key=K00044>>>
nimbus auburn saffron kindle meadow mistral willow falcon glacier garnet kindle indigo thistle copper indigo lantern saffron mistral saffron garnet kindle garnet willow lattice #5de14f70
<<<ANSWER END>>>
<<<ANSWER key=K00106>>>
vellum zebra onyx cinder crimson saffron marble verdant glacier harbor cobble kindle cinder trellis glacier copper kindle zebra russet cobble boulder meadow vellum harbor #26ebebb0
<<<ANSWER END>>>
<<<ANSWER key=K00128>>>
thistle indigo cinder spruce nimbus cedar quartz vellum thistle saffron russet kindle orbit ember fathom ember falcon auburn mistral orbit harbor boulder orbit mistral #9d6014e8
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
