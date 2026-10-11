#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00073>>>
quartz harbor cinder mistral trellis auburn thistle cedar auburn russet crimson spruce ember fathom pewter indigo auburn spruce indigo auburn willow meadow vellum boulder #0554df0b
<<<ANSWER END>>>
<<<ANSWER key=K00009>>>
verdant pewter lantern lattice verdant cobble zebra saffron marble spruce trellis zebra cedar russet crimson russet harbor trellis cobble vellum thistle russet orbit cedar #3a9a0b7b
<<<ANSWER END>>>
<<<ANSWER key=K00228>>>
crimson garnet garnet nimbus quartz verdant crimson quartz glacier quartz cinder quartz thistle orbit glacier copper russet cinder cobble lattice boulder orbit saffron verdant #f342dd69
<<<ANSWER END>>>
<<<ANSWER key=K00258>>>
meadow garnet kindle orbit mistral willow russet ember falcon thistle cobble quartz cobble boulder cobalt russet copper mistral garnet crimson meadow pewter cobble kindle #8b46dd9b
<<<ANSWER END>>>
<<<ANSWER key=K00189>>>
garnet orbit russet saffron russet cobble garnet lantern orbit cinder cobble lattice cobalt harbor zebra russet zebra mistral falcon crimson orbit zebra cedar indigo #b395dd70
<<<ANSWER END>>>
<<<ANSWER key=K00162>>>
indigo kindle kindle nimbus lattice cedar ember mistral cinder spruce willow cedar meadow meadow zebra marble trellis trellis harbor quartz marble onyx vellum falcon #e0c0f830
<<<ANSWER END>>>
<<<ANSWER key=K00117>>>
russet falcon vellum trellis fathom harbor spruce glacier cobalt garnet cedar fathom orbit mistral glacier cinder pewter cedar lantern copper willow thistle thistle crimson #b996b2a4
<<<ANSWER END>>>
<<<ANSWER key=K00225>>>
harbor spruce lattice boulder nimbus cedar garnet kindle saffron cinder cobalt cobalt kindle cobalt russet spruce indigo indigo pewter boulder boulder copper falcon falcon #317e7bdc
<<<ANSWER END>>>
<<<ANSWER key=K00095>>>
mistral indigo saffron onyx zebra orbit cedar willow cobalt willow nimbus pewter thistle zebra boulder crimson indigo saffron cobalt boulder nimbus spruce copper vellum #3da1e602
<<<ANSWER END>>>
<<<ANSWER key=K00213>>>
zebra copper russet onyx verdant willow cobalt cobble vellum quartz saffron orbit willow lantern marble boulder cobalt ember saffron trellis vellum vellum thistle nimbus #2d1aedda
<<<ANSWER END>>>
<<<ANSWER key=K00180>>>
crimson nimbus cedar meadow willow russet nimbus orbit cinder cinder quartz auburn cobble cedar kindle lantern falcon mistral crimson kindle falcon lantern copper cobalt #b72fb6f5
<<<ANSWER END>>>
<<<ANSWER key=K00137>>>
cinder ember orbit verdant meadow verdant glacier garnet harbor willow kindle cobalt marble russet indigo lantern indigo ember cinder cobalt lantern meadow russet harbor #572d672c
<<<ANSWER END>>>
<<<ANSWER key=K00241>>>
kindle cedar indigo fathom boulder lantern quartz onyx thistle russet cinder kindle cinder lattice fathom harbor cobble spruce glacier cobalt harbor falcon cobalt marble #1ed2b246
<<<ANSWER END>>>
<<<ANSWER key=K00049>>>
cobalt boulder cobble harbor auburn saffron falcon cedar trellis garnet cobble garnet russet verdant quartz garnet ember trellis willow indigo meadow verdant saffron orbit #3a1b8195
<<<ANSWER END>>>
<<<ANSWER key=K00170>>>
boulder orbit fathom zebra lattice zebra glacier meadow cobalt cobble cobalt lattice copper kindle glacier pewter russet thistle saffron harbor kindle kindle lattice mistral #6d595c5b
<<<ANSWER END>>>
<<<ANSWER key=K00015>>>
thistle auburn cinder lattice meadow indigo lattice cobble garnet thistle mistral mistral glacier indigo saffron crimson verdant russet pewter onyx cinder pewter cinder onyx #887c40ba
<<<ANSWER END>>>
<<<ANSWER key=K00076>>>
pewter quartz auburn marble nimbus russet mistral russet russet pewter pewter saffron copper quartz onyx orbit marble cobble vellum indigo lattice auburn ember mistral #9ab17362
<<<ANSWER END>>>
<<<ANSWER key=K00091>>>
quartz glacier glacier fathom saffron harbor meadow lattice cinder falcon cobble thistle kindle crimson pewter ember verdant harbor falcon pewter lantern zebra kindle cinder #e2028a4c
<<<ANSWER END>>>
<<<ANSWER key=K00038>>>
glacier boulder indigo cedar cedar willow verdant thistle ember pewter glacier ember mistral orbit willow orbit orbit mistral falcon harbor trellis thistle onyx boulder #e5882569
<<<ANSWER END>>>
<<<ANSWER key=K00071>>>
russet spruce cedar spruce verdant falcon boulder saffron trellis saffron vellum ember glacier pewter spruce lantern onyx cobble cobalt verdant verdant mistral ember cinder #e3e9a059
<<<ANSWER END>>>
<<<ANSWER key=K00103>>>
vellum cobalt spruce lantern spruce glacier russet cedar russet zebra orbit willow copper thistle fathom orbit falcon meadow verdant cedar cobble nimbus saffron crimson #e0511c42
<<<ANSWER END>>>
<<<ANSWER key=K00104>>>
kindle lattice copper harbor willow auburn cobble cobalt fathom ember harbor indigo crimson onyx saffron glacier ember spruce boulder saffron garnet pewter zebra cobble #e60497ab
<<<ANSWER END>>>
<<<ANSWER key=K00226>>>
boulder zebra kindle nimbus vellum orbit saffron indigo cobalt glacier cobble harbor zebra indigo boulder zebra crimson willow cobble crimson meadow garnet cedar cobalt #218f34c0
<<<ANSWER END>>>
<<<ANSWER key=K00186>>>
copper meadow boulder ember vellum boulder mistral falcon harbor quartz trellis indigo lattice vellum cobalt mistral indigo pewter auburn cinder cobble harbor meadow marble #e2a49a80
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
