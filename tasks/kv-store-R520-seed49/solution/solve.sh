#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00204>>>
trellis cobalt lantern cinder crimson cedar kindle harbor willow auburn kindle garnet garnet verdant boulder ember falcon meadow willow indigo lattice cinder thistle crimson #ccb31721
<<<ANSWER END>>>
<<<ANSWER key=K00365>>>
saffron willow fathom saffron meadow boulder saffron harbor indigo russet thistle nimbus cedar cinder glacier cedar orbit onyx willow verdant vellum cinder pewter onyx #4785ffb9
<<<ANSWER END>>>
<<<ANSWER key=K00490>>>
nimbus kindle quartz onyx cobble thistle ember boulder vellum willow fathom vellum copper cinder pewter lantern falcon russet zebra garnet orbit glacier russet ember #eb3cb40c
<<<ANSWER END>>>
<<<ANSWER key=K00450>>>
copper thistle falcon willow ember harbor cobble saffron garnet mistral auburn harbor vellum harbor vellum cedar copper spruce cedar zebra kindle willow zebra cobble #500924b2
<<<ANSWER END>>>
<<<ANSWER key=K00161>>>
harbor copper auburn cinder harbor vellum boulder zebra garnet verdant mistral cobble fathom crimson mistral thistle lattice meadow lattice mistral mistral willow saffron fathom #88582ebe
<<<ANSWER END>>>
<<<ANSWER key=K00064>>>
russet cobalt nimbus zebra pewter trellis verdant thistle mistral lattice copper copper willow ember trellis crimson lattice marble boulder zebra pewter auburn meadow harbor #eb6e27b3
<<<ANSWER END>>>
<<<ANSWER key=K00229>>>
indigo auburn copper trellis crimson meadow kindle garnet cinder ember mistral spruce mistral kindle onyx vellum vellum orbit copper falcon willow glacier garnet fathom #a7bd755a
<<<ANSWER END>>>
<<<ANSWER key=K00298>>>
fathom boulder trellis auburn saffron cobalt indigo fathom cobble crimson mistral meadow meadow garnet zebra falcon mistral zebra saffron garnet willow garnet cobble auburn #d746c0c6
<<<ANSWER END>>>
<<<ANSWER key=K00309>>>
falcon cinder falcon kindle boulder meadow mistral lattice onyx nimbus trellis indigo cobalt zebra fathom cinder indigo spruce lantern boulder willow marble ember boulder #905316d5
<<<ANSWER END>>>
<<<ANSWER key=K00336>>>
boulder onyx indigo orbit cinder spruce copper onyx indigo pewter verdant vellum nimbus glacier onyx russet boulder lantern mistral indigo boulder crimson auburn kindle #ccc00927
<<<ANSWER END>>>
<<<ANSWER key=K00077>>>
willow trellis ember nimbus zebra auburn meadow saffron boulder thistle quartz indigo fathom glacier spruce fathom russet cinder willow quartz glacier lattice boulder falcon #042d2d89
<<<ANSWER END>>>
<<<ANSWER key=K00174>>>
vellum vellum lattice pewter trellis fathom glacier crimson kindle meadow boulder trellis meadow zebra garnet orbit crimson auburn lantern thistle vellum onyx thistle cedar #2889a9e0
<<<ANSWER END>>>
<<<ANSWER key=K00108>>>
quartz pewter saffron cedar ember ember lantern quartz thistle mistral trellis russet nimbus pewter boulder thistle indigo auburn thistle russet falcon russet indigo cobalt #9834e114
<<<ANSWER END>>>
<<<ANSWER key=K00424>>>
thistle russet trellis fathom harbor pewter quartz zebra ember garnet kindle nimbus verdant orbit mistral kindle saffron zebra ember auburn spruce zebra orbit boulder #fcb5f54c
<<<ANSWER END>>>
<<<ANSWER key=K00221>>>
harbor cobalt falcon nimbus boulder falcon saffron cedar quartz cinder orbit zebra glacier nimbus garnet harbor verdant willow vellum zebra vellum garnet indigo fathom #51d3a57b
<<<ANSWER END>>>
<<<ANSWER key=K00469>>>
auburn spruce orbit glacier zebra lattice saffron orbit meadow auburn cinder verdant cedar meadow marble russet pewter trellis saffron spruce trellis orbit lantern willow #5a4f90a3
<<<ANSWER END>>>
<<<ANSWER key=K00383>>>
lattice vellum onyx kindle indigo cobble russet vellum cobble lantern kindle meadow pewter vellum crimson falcon onyx auburn boulder cinder auburn mistral zebra verdant #0c960e6f
<<<ANSWER END>>>
<<<ANSWER key=K00028>>>
quartz falcon orbit nimbus lattice nimbus pewter lattice crimson vellum meadow quartz russet marble zebra nimbus marble fathom auburn russet verdant falcon thistle ember #deeb6c68
<<<ANSWER END>>>
<<<ANSWER key=K00315>>>
glacier auburn lattice garnet mistral glacier fathom pewter cobalt cedar zebra falcon onyx onyx trellis russet zebra orbit harbor falcon pewter saffron falcon crimson #1a0981e0
<<<ANSWER END>>>
<<<ANSWER key=K00354>>>
indigo spruce saffron boulder cedar orbit thistle garnet cinder indigo auburn trellis onyx glacier cedar ember auburn garnet willow ember verdant harbor zebra nimbus #895d7189
<<<ANSWER END>>>
<<<ANSWER key=K00027>>>
thistle nimbus thistle boulder mistral trellis falcon indigo garnet mistral cinder cinder vellum vellum cobalt copper harbor mistral crimson saffron garnet cobble kindle nimbus #4574d1f3
<<<ANSWER END>>>
<<<ANSWER key=K00388>>>
indigo verdant cedar nimbus saffron willow harbor thistle orbit meadow glacier verdant cedar lantern ember indigo boulder indigo nimbus lantern cinder verdant harbor copper #2c21eb1c
<<<ANSWER END>>>
<<<ANSWER key=K00061>>>
boulder mistral zebra harbor harbor boulder cobble saffron trellis cobble cobalt cobalt copper cobalt pewter fathom verdant indigo cobble zebra garnet cobalt cobalt harbor #7e78ea19
<<<ANSWER END>>>
<<<ANSWER key=K00024>>>
auburn cedar russet pewter cinder trellis lattice zebra willow mistral spruce cobalt orbit cedar indigo thistle mistral willow cobalt marble vellum verdant cedar boulder #c00a2487
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
