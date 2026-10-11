#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00770>>>
quartz falcon mistral quartz willow indigo orbit fathom verdant pewter verdant trellis lattice cobalt glacier meadow onyx cedar cobalt copper vellum auburn willow ember #519be063
<<<ANSWER END>>>
<<<ANSWER key=K00214>>>
garnet kindle cinder quartz crimson cinder auburn thistle garnet copper saffron nimbus ember kindle crimson meadow pewter vellum cinder boulder crimson lantern ember thistle #6ac6fe50
<<<ANSWER END>>>
<<<ANSWER key=K00617>>>
falcon falcon trellis trellis spruce marble spruce ember boulder indigo harbor quartz cobble marble zebra auburn nimbus verdant spruce meadow willow nimbus ember zebra #e56d3388
<<<ANSWER END>>>
<<<ANSWER key=K00945>>>
indigo vellum nimbus indigo cedar boulder cinder mistral cinder willow kindle quartz cobalt cinder thistle vellum fathom saffron orbit willow cinder spruce trellis lantern #de1d455a
<<<ANSWER END>>>
<<<ANSWER key=K00432>>>
auburn indigo lattice marble pewter boulder onyx glacier nimbus thistle russet auburn crimson fathom pewter zebra crimson falcon harbor orbit boulder lantern nimbus willow #86fc1eaf
<<<ANSWER END>>>
<<<ANSWER key=K00818>>>
indigo spruce onyx ember meadow auburn garnet fathom russet ember garnet cobble vellum cobalt cobalt quartz fathom willow nimbus boulder falcon zebra copper pewter #699bd347
<<<ANSWER END>>>
<<<ANSWER key=K00658>>>
ember verdant copper russet saffron trellis mistral lantern saffron onyx pewter saffron willow cobble harbor zebra crimson pewter willow trellis nimbus trellis cinder boulder #dc224564
<<<ANSWER END>>>
<<<ANSWER key=K00014>>>
russet willow glacier russet lantern ember vellum crimson cedar ember indigo garnet cobalt russet cobalt falcon falcon saffron saffron falcon kindle mistral copper quartz #bff12d57
<<<ANSWER END>>>
<<<ANSWER key=K00092>>>
orbit quartz cobalt kindle zebra indigo crimson falcon garnet harbor spruce thistle lantern lantern crimson nimbus willow ember fathom verdant cedar saffron nimbus trellis #8b647609
<<<ANSWER END>>>
<<<ANSWER key=K00591>>>
zebra cedar vellum vellum orbit indigo russet pewter nimbus orbit spruce fathom verdant mistral zebra pewter falcon kindle verdant verdant falcon ember cobalt glacier #b6fea5be
<<<ANSWER END>>>
<<<ANSWER key=K00270>>>
lantern willow nimbus nimbus auburn pewter garnet copper lattice trellis mistral onyx thistle willow falcon saffron verdant indigo cedar verdant pewter cedar kindle onyx #16fbbc2a
<<<ANSWER END>>>
<<<ANSWER key=K00902>>>
vellum cedar quartz ember russet orbit copper spruce falcon quartz lantern auburn nimbus cinder fathom crimson quartz copper trellis cedar cobble kindle mistral kindle #e0357c2d
<<<ANSWER END>>>
<<<ANSWER key=K00182>>>
kindle nimbus verdant mistral spruce falcon falcon cinder cobble meadow crimson marble onyx boulder fathom willow cobalt spruce nimbus pewter thistle thistle spruce onyx #ada08028
<<<ANSWER END>>>
<<<ANSWER key=K00104>>>
quartz verdant orbit lattice cobalt cedar mistral marble pewter russet ember orbit lattice orbit spruce fathom trellis spruce trellis falcon pewter auburn marble quartz #a3ef7195
<<<ANSWER END>>>
<<<ANSWER key=K00519>>>
spruce pewter auburn cinder verdant boulder falcon pewter cobalt orbit cedar thistle crimson zebra auburn pewter garnet spruce meadow pewter ember willow orbit kindle #bf41bdc3
<<<ANSWER END>>>
<<<ANSWER key=K00129>>>
onyx spruce kindle pewter vellum mistral lattice zebra cinder boulder auburn harbor indigo marble orbit saffron verdant zebra crimson fathom kindle cobalt willow garnet #42c72ac0
<<<ANSWER END>>>
<<<ANSWER key=K00646>>>
glacier garnet lattice kindle boulder zebra glacier harbor cedar crimson verdant spruce spruce cedar russet pewter zebra cobble meadow lattice lantern boulder lantern meadow #523dddcf
<<<ANSWER END>>>
<<<ANSWER key=K00677>>>
harbor marble trellis fathom trellis cedar lattice meadow boulder saffron quartz saffron spruce zebra glacier thistle crimson harbor cinder verdant lantern crimson falcon meadow #ae6361d3
<<<ANSWER END>>>
<<<ANSWER key=K00006>>>
ember quartz cobalt thistle auburn mistral fathom garnet verdant garnet spruce trellis boulder russet cedar quartz lantern garnet onyx marble trellis ember cedar zebra #b2428883
<<<ANSWER END>>>
<<<ANSWER key=K00929>>>
verdant trellis cobble kindle garnet indigo cinder mistral cinder saffron cedar cinder zebra marble cobble saffron pewter kindle vellum cobalt crimson vellum cobalt falcon #06a6279c
<<<ANSWER END>>>
<<<ANSWER key=K00398>>>
cedar kindle nimbus mistral verdant saffron kindle thistle falcon fathom verdant orbit garnet kindle verdant harbor indigo russet kindle auburn kindle thistle willow lattice #2bf80f25
<<<ANSWER END>>>
<<<ANSWER key=K00791>>>
zebra zebra falcon saffron falcon lattice mistral copper zebra kindle copper copper cobalt zebra garnet cedar boulder marble marble cinder zebra lattice fathom trellis #9fa565e3
<<<ANSWER END>>>
<<<ANSWER key=K00846>>>
falcon garnet russet nimbus vellum verdant zebra trellis boulder mistral nimbus fathom meadow lantern indigo garnet boulder lattice cobalt auburn saffron onyx lantern spruce #8367f890
<<<ANSWER END>>>
<<<ANSWER key=K00156>>>
spruce kindle crimson cedar saffron auburn willow crimson spruce harbor falcon vellum zebra auburn cobble thistle lattice cinder thistle copper lattice garnet willow boulder #6dcdba2e
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
