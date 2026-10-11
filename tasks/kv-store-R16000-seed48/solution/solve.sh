#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K14721>>>
willow crimson trellis orbit boulder fathom glacier cobalt cobble indigo copper cedar cinder trellis vellum onyx nimbus zebra onyx marble verdant russet verdant cinder #5d857b8c
<<<ANSWER END>>>
<<<ANSWER key=K06089>>>
falcon lantern verdant saffron orbit indigo cedar harbor cobble vellum pewter falcon ember orbit garnet thistle ember garnet pewter indigo cobalt lantern copper mistral #b79e275f
<<<ANSWER END>>>
<<<ANSWER key=K12188>>>
meadow lantern cinder zebra meadow indigo boulder vellum ember fathom thistle fathom quartz mistral pewter auburn copper verdant auburn cinder pewter fathom onyx kindle #a08016ee
<<<ANSWER END>>>
<<<ANSWER key=K14608>>>
zebra verdant meadow fathom auburn saffron indigo cobalt spruce glacier russet indigo lattice quartz boulder pewter crimson onyx cobble pewter fathom vellum cobble quartz #c67fe80a
<<<ANSWER END>>>
<<<ANSWER key=K02840>>>
verdant cinder cobalt fathom indigo meadow saffron boulder lattice lattice copper spruce copper crimson marble russet lattice falcon ember ember boulder saffron cinder cobble #5052d75b
<<<ANSWER END>>>
<<<ANSWER key=K12387>>>
zebra spruce verdant ember indigo marble marble verdant marble russet pewter meadow zebra kindle zebra marble spruce harbor willow glacier saffron spruce cinder vellum #f4e5f18a
<<<ANSWER END>>>
<<<ANSWER key=K12427>>>
glacier falcon harbor zebra ember quartz quartz auburn fathom orbit cedar russet cinder cobble spruce trellis cinder auburn crimson cedar thistle copper boulder cobble #ce6c8b69
<<<ANSWER END>>>
<<<ANSWER key=K09556>>>
thistle trellis onyx ember nimbus orbit cobble nimbus lattice falcon meadow meadow fathom boulder orbit fathom vellum crimson crimson nimbus lantern meadow vellum saffron #2753b652
<<<ANSWER END>>>
<<<ANSWER key=K14875>>>
willow garnet orbit ember fathom verdant ember thistle lantern pewter trellis indigo glacier boulder lantern onyx cinder trellis trellis fathom kindle garnet falcon crimson #7e909a12
<<<ANSWER END>>>
<<<ANSWER key=K06863>>>
saffron fathom trellis zebra spruce russet glacier thistle indigo cinder meadow garnet verdant lattice pewter thistle glacier meadow willow glacier cinder spruce falcon copper #5d84af8b
<<<ANSWER END>>>
<<<ANSWER key=K11824>>>
meadow spruce cedar lantern cobalt garnet saffron verdant marble auburn crimson lantern meadow lantern crimson garnet cinder lantern copper mistral saffron russet copper ember #e51d00b3
<<<ANSWER END>>>
<<<ANSWER key=K07716>>>
cobalt lantern ember cobble harbor spruce cedar copper auburn trellis auburn vellum willow indigo cinder vellum spruce thistle marble russet meadow russet russet glacier #58238be6
<<<ANSWER END>>>
<<<ANSWER key=K09567>>>
kindle trellis boulder auburn garnet thistle lattice garnet fathom lattice lattice spruce verdant saffron thistle crimson orbit indigo crimson zebra onyx cobble mistral mistral #523e2852
<<<ANSWER END>>>
<<<ANSWER key=K08533>>>
boulder indigo vellum trellis saffron meadow meadow cinder quartz ember boulder thistle garnet thistle willow zebra thistle marble onyx lattice meadow saffron orbit marble #4f26e622
<<<ANSWER END>>>
<<<ANSWER key=K15835>>>
cobble lantern thistle crimson kindle willow auburn cobble cedar copper lattice ember onyx copper marble kindle cobalt verdant cinder harbor auburn quartz cobble kindle #ee907a5c
<<<ANSWER END>>>
<<<ANSWER key=K08912>>>
willow orbit cinder quartz quartz mistral crimson lattice quartz thistle onyx zebra cedar quartz garnet saffron marble glacier indigo cedar quartz indigo zebra cobble #5177bbec
<<<ANSWER END>>>
<<<ANSWER key=K05606>>>
auburn auburn spruce lantern saffron ember ember indigo marble mistral marble mistral trellis russet auburn falcon falcon onyx willow vellum mistral fathom marble kindle #9efc169f
<<<ANSWER END>>>
<<<ANSWER key=K05745>>>
ember harbor thistle thistle glacier russet saffron cinder ember russet meadow lattice lattice willow mistral indigo lattice zebra falcon boulder saffron thistle indigo orbit #2a871050
<<<ANSWER END>>>
<<<ANSWER key=K00236>>>
crimson lattice fathom onyx cinder cinder harbor lantern nimbus harbor crimson boulder pewter quartz cedar copper falcon auburn verdant boulder quartz pewter trellis garnet #5ad03ef2
<<<ANSWER END>>>
<<<ANSWER key=K08174>>>
copper quartz trellis quartz auburn russet boulder vellum kindle vellum lattice orbit zebra cobble indigo auburn meadow ember nimbus russet cinder thistle fathom nimbus #76bb2678
<<<ANSWER END>>>
<<<ANSWER key=K03674>>>
thistle falcon cobble quartz indigo orbit lantern garnet lantern nimbus thistle pewter auburn cobble marble vellum russet boulder willow glacier fathom copper meadow garnet #6394ff98
<<<ANSWER END>>>
<<<ANSWER key=K15220>>>
vellum lattice garnet trellis crimson ember cinder fathom kindle boulder kindle russet indigo orbit mistral nimbus ember copper meadow cinder glacier nimbus saffron willow #b2721308
<<<ANSWER END>>>
<<<ANSWER key=K07365>>>
auburn boulder lattice verdant marble fathom indigo vellum boulder verdant quartz lattice lattice willow spruce fathom onyx fathom glacier zebra saffron crimson willow saffron #80eeb1d5
<<<ANSWER END>>>
<<<ANSWER key=K07872>>>
quartz cobalt saffron mistral harbor onyx indigo thistle garnet meadow onyx glacier cobble cedar vellum saffron spruce onyx ember thistle vellum zebra glacier cinder #3af75b96
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
