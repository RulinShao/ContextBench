#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K14013>>>
meadow willow mistral falcon lattice harbor saffron cobalt russet mistral garnet russet cedar harbor fathom orbit thistle kindle orbit cinder cedar orbit nimbus trellis #ec0eed77
<<<ANSWER END>>>
<<<ANSWER key=K05864>>>
pewter spruce cedar auburn saffron lattice saffron boulder garnet vellum boulder glacier kindle crimson zebra russet falcon verdant cinder thistle falcon ember pewter garnet #92844a90
<<<ANSWER END>>>
<<<ANSWER key=K09966>>>
onyx vellum harbor boulder cobalt harbor harbor glacier falcon orbit crimson vellum glacier saffron spruce vellum nimbus cobalt orbit cedar spruce boulder quartz nimbus #ab310777
<<<ANSWER END>>>
<<<ANSWER key=K11468>>>
cinder falcon thistle glacier indigo spruce mistral marble trellis marble mistral saffron orbit auburn auburn cobalt lantern harbor cinder pewter auburn nimbus orbit zebra #52a37280
<<<ANSWER END>>>
<<<ANSWER key=K08082>>>
lattice indigo vellum marble lantern kindle nimbus boulder zebra cinder cobalt willow marble cobble thistle onyx falcon mistral meadow ember indigo trellis nimbus copper #06117ed8
<<<ANSWER END>>>
<<<ANSWER key=K08177>>>
indigo onyx cinder mistral spruce crimson orbit cobalt cedar indigo cinder falcon glacier cedar kindle nimbus willow spruce trellis garnet cedar lantern spruce spruce #0f867b34
<<<ANSWER END>>>
<<<ANSWER key=K09327>>>
onyx indigo thistle harbor cobalt falcon saffron cobalt auburn spruce thistle kindle spruce garnet indigo lattice garnet harbor russet fathom quartz fathom quartz orbit #b319585a
<<<ANSWER END>>>
<<<ANSWER key=K14118>>>
spruce saffron spruce verdant cobble vellum lantern thistle saffron auburn crimson falcon garnet nimbus onyx mistral cobalt lantern auburn orbit falcon harbor lantern kindle #aa368cca
<<<ANSWER END>>>
<<<ANSWER key=K11715>>>
garnet spruce marble lattice lattice boulder saffron spruce orbit verdant cobalt copper ember glacier pewter ember boulder zebra indigo mistral zebra lantern copper zebra #590bcb29
<<<ANSWER END>>>
<<<ANSWER key=K09519>>>
crimson saffron kindle vellum russet boulder copper indigo saffron falcon pewter verdant cinder harbor copper quartz lattice onyx nimbus meadow pewter copper fathom marble #a6f512d4
<<<ANSWER END>>>
<<<ANSWER key=K15281>>>
indigo thistle kindle falcon mistral mistral pewter lattice cinder falcon orbit onyx quartz cobble garnet boulder harbor russet willow vellum spruce auburn crimson onyx #f1e07603
<<<ANSWER END>>>
<<<ANSWER key=K12549>>>
falcon cinder ember pewter indigo harbor garnet glacier vellum verdant ember mistral vellum kindle onyx onyx boulder cedar verdant pewter vellum onyx orbit cinder #b1cfa1fc
<<<ANSWER END>>>
<<<ANSWER key=K02014>>>
cobalt quartz fathom mistral cedar vellum garnet quartz zebra trellis auburn vellum cobble quartz boulder mistral garnet auburn russet mistral kindle verdant auburn fathom #2c1cf88e
<<<ANSWER END>>>
<<<ANSWER key=K14086>>>
russet cinder mistral crimson cinder saffron verdant indigo mistral boulder cobble kindle cedar cinder nimbus kindle spruce boulder cedar crimson mistral kindle crimson glacier #99798adf
<<<ANSWER END>>>
<<<ANSWER key=K12431>>>
glacier lattice meadow garnet harbor auburn willow indigo crimson cobble mistral harbor willow cedar harbor marble glacier saffron garnet onyx willow vellum trellis quartz #b962f3f5
<<<ANSWER END>>>
<<<ANSWER key=K15529>>>
zebra cedar vellum lantern vellum saffron falcon saffron spruce thistle falcon cobble onyx glacier verdant vellum harbor orbit auburn harbor cinder nimbus onyx crimson #78552b33
<<<ANSWER END>>>
<<<ANSWER key=K12124>>>
cedar kindle falcon cedar vellum harbor orbit cinder copper meadow kindle glacier cobble auburn saffron cedar ember russet harbor nimbus kindle cobble russet cedar #eac02d46
<<<ANSWER END>>>
<<<ANSWER key=K09044>>>
fathom pewter verdant spruce verdant onyx zebra marble russet pewter lattice harbor boulder cinder thistle meadow zebra cobble pewter ember zebra vellum marble saffron #c7ca242c
<<<ANSWER END>>>
<<<ANSWER key=K11747>>>
indigo trellis cedar verdant boulder saffron auburn auburn thistle indigo vellum lantern cobalt willow meadow copper crimson crimson lattice boulder thistle verdant lattice falcon #9753b14b
<<<ANSWER END>>>
<<<ANSWER key=K07512>>>
trellis nimbus cedar saffron kindle verdant pewter meadow ember ember auburn ember mistral russet kindle indigo pewter marble onyx trellis copper cobble auburn vellum #c0a11a07
<<<ANSWER END>>>
<<<ANSWER key=K06800>>>
garnet copper harbor boulder cobble thistle fathom fathom cinder cinder orbit indigo pewter trellis fathom lantern mistral cobble marble indigo crimson cedar ember zebra #91a9a94f
<<<ANSWER END>>>
<<<ANSWER key=K08222>>>
auburn falcon zebra willow lattice garnet cobble copper spruce nimbus crimson boulder onyx lantern falcon crimson garnet crimson falcon cinder meadow pewter cobalt zebra #d7910c16
<<<ANSWER END>>>
<<<ANSWER key=K15924>>>
cobble cobble crimson glacier meadow lattice cobble trellis spruce verdant marble meadow falcon meadow harbor ember lantern lantern boulder zebra russet ember mistral pewter #15a68b3b
<<<ANSWER END>>>
<<<ANSWER key=K11660>>>
verdant trellis onyx willow lattice thistle auburn cinder crimson nimbus nimbus zebra cobalt lantern boulder cedar mistral harbor pewter indigo verdant meadow copper indigo #73f1516d
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
