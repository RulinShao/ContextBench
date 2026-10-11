#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00056>>>
saffron verdant harbor meadow onyx indigo spruce lantern kindle cinder cedar russet russet harbor lantern kindle orbit pewter boulder garnet orbit trellis auburn ember #b3e8ad62
<<<ANSWER END>>>
<<<ANSWER key=K00070>>>
kindle cobalt zebra marble kindle indigo willow mistral crimson pewter pewter ember mistral pewter boulder glacier garnet saffron boulder garnet marble thistle harbor trellis #ed779977
<<<ANSWER END>>>
<<<ANSWER key=K00190>>>
spruce pewter boulder spruce indigo cedar garnet marble garnet onyx auburn vellum zebra cobalt pewter falcon zebra lattice cedar boulder spruce indigo copper cobble #fbe04b88
<<<ANSWER END>>>
<<<ANSWER key=K00171>>>
spruce fathom mistral ember spruce cobalt crimson harbor zebra russet vellum ember zebra glacier copper pewter quartz boulder saffron crimson verdant thistle lantern kindle #d4bf7a72
<<<ANSWER END>>>
<<<ANSWER key=K00196>>>
mistral spruce copper thistle saffron vellum saffron trellis indigo willow saffron quartz lantern lantern auburn crimson cobble willow garnet trellis mistral lantern cedar trellis #34877922
<<<ANSWER END>>>
<<<ANSWER key=K00085>>>
cobalt glacier cobble cinder cinder pewter harbor kindle cedar harbor cinder fathom indigo nimbus fathom cobble auburn cinder orbit meadow fathom russet spruce fathom #b4a12592
<<<ANSWER END>>>
<<<ANSWER key=K00154>>>
fathom falcon quartz indigo verdant garnet trellis onyx quartz crimson cedar garnet harbor verdant copper spruce orbit pewter cobble cobble harbor lantern garnet thistle #2ddb9399
<<<ANSWER END>>>
<<<ANSWER key=K00118>>>
marble marble cinder harbor boulder harbor onyx thistle cedar falcon glacier willow verdant indigo orbit cobalt orbit harbor saffron mistral copper thistle cinder kindle #20aa2655
<<<ANSWER END>>>
<<<ANSWER key=K00255>>>
indigo thistle trellis spruce mistral copper garnet orbit saffron onyx saffron kindle trellis copper indigo verdant orbit verdant verdant ember russet crimson meadow glacier #277c33ba
<<<ANSWER END>>>
<<<ANSWER key=K00097>>>
kindle cobble falcon nimbus lantern boulder copper auburn nimbus nimbus meadow glacier saffron glacier crimson boulder cobalt marble verdant glacier thistle indigo ember falcon #66796ce4
<<<ANSWER END>>>
<<<ANSWER key=K00125>>>
onyx verdant mistral spruce onyx saffron garnet boulder thistle orbit onyx quartz indigo marble auburn spruce willow indigo ember quartz boulder kindle ember meadow #424b6ade
<<<ANSWER END>>>
<<<ANSWER key=K00197>>>
pewter verdant onyx auburn indigo ember spruce verdant boulder thistle glacier trellis ember glacier falcon trellis nimbus crimson vellum thistle thistle cedar boulder ember #300f81eb
<<<ANSWER END>>>
<<<ANSWER key=K00110>>>
garnet fathom saffron spruce russet thistle falcon spruce quartz mistral copper indigo cedar auburn meadow willow cinder ember cobble copper vellum mistral lantern trellis #f5c5c9c1
<<<ANSWER END>>>
<<<ANSWER key=K00064>>>
vellum fathom pewter meadow falcon vellum indigo indigo copper harbor lattice cedar quartz kindle vellum vellum kindle garnet indigo nimbus pewter zebra russet pewter #997087c5
<<<ANSWER END>>>
<<<ANSWER key=K00122>>>
cobalt lattice trellis spruce auburn mistral boulder glacier copper pewter quartz kindle lattice zebra zebra quartz orbit garnet garnet willow ember vellum ember meadow #9182061d
<<<ANSWER END>>>
<<<ANSWER key=K00182>>>
cobalt quartz kindle thistle lantern meadow cedar auburn cobalt mistral glacier indigo trellis verdant cinder copper saffron cobalt lattice lantern lattice lattice spruce glacier #fc3950e6
<<<ANSWER END>>>
<<<ANSWER key=K00037>>>
pewter willow cobalt harbor meadow cedar meadow crimson mistral orbit russet orbit verdant pewter fathom cobalt lattice cedar falcon lattice fathom crimson meadow trellis #0aeaefd0
<<<ANSWER END>>>
<<<ANSWER key=K00107>>>
nimbus nimbus spruce marble mistral cedar pewter trellis indigo marble meadow kindle kindle marble vellum willow meadow onyx mistral glacier saffron cobble cedar mistral #28167525
<<<ANSWER END>>>
<<<ANSWER key=K00212>>>
verdant spruce cedar cedar saffron cobalt thistle garnet boulder trellis zebra onyx harbor fathom mistral fathom nimbus glacier crimson cinder harbor lantern crimson vellum #c2be26c0
<<<ANSWER END>>>
<<<ANSWER key=K00147>>>
fathom vellum pewter cobble cinder russet quartz cobble zebra glacier ember lantern glacier ember zebra glacier saffron russet zebra orbit zebra meadow russet boulder #3d57c5ae
<<<ANSWER END>>>
<<<ANSWER key=K00222>>>
falcon onyx trellis cobalt zebra saffron cobalt indigo harbor copper onyx orbit ember cobalt pewter kindle thistle verdant boulder cedar zebra falcon cobble vellum #fa0881f0
<<<ANSWER END>>>
<<<ANSWER key=K00075>>>
thistle quartz trellis saffron vellum zebra fathom cedar garnet glacier cedar auburn falcon cinder cobalt meadow russet fathom crimson lantern lantern spruce cobble russet #ec872bab
<<<ANSWER END>>>
<<<ANSWER key=K00232>>>
russet pewter crimson willow nimbus lantern nimbus marble falcon spruce cedar kindle boulder saffron mistral boulder auburn lantern quartz cinder garnet willow quartz lantern #1fe50531
<<<ANSWER END>>>
<<<ANSWER key=K00053>>>
garnet boulder fathom willow lattice cedar vellum russet lattice saffron falcon indigo fathom cobble meadow onyx verdant willow garnet meadow falcon verdant copper cedar #8eaf3715
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
