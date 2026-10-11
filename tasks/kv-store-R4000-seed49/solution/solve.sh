#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K02717>>>
kindle vellum cobalt orbit mistral garnet kindle cedar kindle cedar verdant spruce onyx nimbus spruce marble zebra marble cobalt pewter trellis saffron ember lantern #e1772f32
<<<ANSWER END>>>
<<<ANSWER key=K01790>>>
glacier pewter ember falcon meadow ember meadow pewter garnet orbit harbor fathom cedar auburn cobble marble trellis lattice kindle willow fathom thistle lantern vellum #61d0e967
<<<ANSWER END>>>
<<<ANSWER key=K00164>>>
indigo cobalt harbor cedar nimbus quartz trellis kindle cinder pewter onyx trellis boulder zebra orbit pewter meadow zebra saffron willow lantern quartz quartz copper #bfbacd23
<<<ANSWER END>>>
<<<ANSWER key=K03946>>>
cobble harbor vellum meadow pewter ember zebra indigo meadow pewter onyx meadow willow willow nimbus cedar orbit falcon quartz onyx auburn vellum fathom zebra #70a44a01
<<<ANSWER END>>>
<<<ANSWER key=K02337>>>
cobalt cinder orbit saffron cobalt auburn glacier spruce pewter harbor vellum onyx thistle willow nimbus copper meadow willow willow indigo meadow nimbus onyx nimbus #4b20f775
<<<ANSWER END>>>
<<<ANSWER key=K00415>>>
indigo spruce boulder glacier falcon crimson falcon ember cinder nimbus lattice fathom verdant cobalt harbor falcon kindle onyx verdant lattice cobble fathom zebra mistral #8e243824
<<<ANSWER END>>>
<<<ANSWER key=K03467>>>
lattice orbit pewter fathom marble verdant copper crimson pewter cedar pewter zebra quartz garnet thistle trellis fathom cobalt kindle quartz crimson trellis lantern glacier #66788fe2
<<<ANSWER END>>>
<<<ANSWER key=K01188>>>
crimson copper harbor lantern saffron pewter crimson orbit cinder thistle copper verdant saffron boulder trellis cedar trellis cobalt trellis orbit nimbus cinder mistral kindle #2d7cf164
<<<ANSWER END>>>
<<<ANSWER key=K01754>>>
pewter lantern zebra spruce lattice cobalt thistle falcon lantern quartz crimson trellis lattice auburn willow ember auburn crimson willow meadow saffron cobalt falcon russet #43578853
<<<ANSWER END>>>
<<<ANSWER key=K00364>>>
cobalt lattice cinder copper saffron cobalt lattice crimson onyx russet falcon pewter marble mistral crimson glacier garnet auburn cobalt glacier lantern orbit nimbus vellum #61fb89c3
<<<ANSWER END>>>
<<<ANSWER key=K03563>>>
indigo marble trellis nimbus auburn cobble spruce cedar verdant falcon pewter vellum falcon cedar thistle saffron kindle cinder pewter vellum willow verdant vellum saffron #e6f13957
<<<ANSWER END>>>
<<<ANSWER key=K00951>>>
boulder marble mistral thistle mistral willow crimson boulder verdant indigo glacier cobalt mistral lattice indigo garnet quartz falcon kindle verdant trellis lattice onyx fathom #795da28f
<<<ANSWER END>>>
<<<ANSWER key=K01633>>>
falcon verdant willow trellis cinder zebra cobalt marble trellis onyx boulder ember crimson boulder nimbus onyx trellis fathom indigo orbit mistral auburn garnet russet #c7912ef8
<<<ANSWER END>>>
<<<ANSWER key=K00671>>>
copper auburn copper auburn vellum boulder copper falcon vellum marble boulder garnet lattice onyx marble harbor verdant verdant willow zebra cedar cedar lantern spruce #5adcc1cb
<<<ANSWER END>>>
<<<ANSWER key=K03933>>>
fathom nimbus quartz glacier lattice copper meadow glacier meadow spruce copper lattice verdant pewter fathom cobalt cobble vellum quartz lantern thistle garnet kindle ember #3da28a38
<<<ANSWER END>>>
<<<ANSWER key=K00520>>>
cedar copper russet vellum harbor meadow marble mistral boulder trellis verdant meadow harbor thistle onyx pewter garnet lattice crimson trellis copper crimson auburn orbit #c80765d8
<<<ANSWER END>>>
<<<ANSWER key=K01023>>>
saffron mistral thistle spruce indigo cobalt fathom kindle saffron onyx cedar boulder falcon indigo quartz mistral crimson cobble marble vellum trellis garnet boulder cedar #89344ce2
<<<ANSWER END>>>
<<<ANSWER key=K03127>>>
fathom quartz harbor falcon vellum cobble trellis onyx verdant lantern lantern ember orbit marble cedar harbor crimson glacier marble vellum spruce cobalt nimbus indigo #ee4b598b
<<<ANSWER END>>>
<<<ANSWER key=K00739>>>
garnet boulder orbit russet cinder trellis mistral marble crimson cinder pewter nimbus auburn onyx auburn thistle trellis harbor russet cobble ember pewter ember pewter #2746b598
<<<ANSWER END>>>
<<<ANSWER key=K02981>>>
copper cedar zebra boulder glacier auburn onyx quartz boulder auburn thistle glacier meadow auburn orbit saffron cedar ember glacier quartz lattice kindle garnet orbit #e265d83b
<<<ANSWER END>>>
<<<ANSWER key=K00103>>>
vellum cobalt spruce lantern spruce glacier russet cedar russet zebra orbit willow copper thistle fathom orbit falcon meadow verdant cedar cobble nimbus saffron crimson #e0511c42
<<<ANSWER END>>>
<<<ANSWER key=K00994>>>
lattice marble pewter harbor boulder marble quartz cobble auburn lattice spruce onyx ember trellis kindle onyx trellis copper pewter thistle spruce onyx falcon cobble #567a2997
<<<ANSWER END>>>
<<<ANSWER key=K03140>>>
boulder verdant copper willow cobalt zebra spruce lattice zebra nimbus marble meadow orbit vellum marble cinder harbor lantern russet thistle mistral spruce glacier verdant #edb66596
<<<ANSWER END>>>
<<<ANSWER key=K03603>>>
cobble auburn vellum kindle marble spruce trellis cobalt zebra nimbus boulder cinder copper indigo lattice indigo mistral zebra russet thistle saffron nimbus trellis cobalt #e2d8fb60
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
