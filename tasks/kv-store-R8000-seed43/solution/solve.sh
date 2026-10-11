#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K07360>>>
marble vellum spruce indigo marble kindle harbor onyx mistral kindle harbor cedar lantern indigo quartz pewter auburn fathom boulder copper falcon kindle cinder willow #430875e5
<<<ANSWER END>>>
<<<ANSWER key=K02144>>>
ember thistle mistral garnet garnet quartz harbor russet onyx lattice orbit kindle kindle falcon mistral cedar boulder falcon nimbus trellis auburn cobble mistral zebra #373695f2
<<<ANSWER END>>>
<<<ANSWER key=K05700>>>
auburn fathom indigo spruce mistral cobble cedar cobble russet cedar indigo crimson cedar garnet garnet meadow kindle copper saffron ember falcon mistral copper verdant #4910773c
<<<ANSWER END>>>
<<<ANSWER key=K01537>>>
indigo garnet falcon lattice pewter falcon marble pewter saffron cobalt onyx nimbus orbit harbor spruce trellis fathom willow lattice meadow verdant orbit lantern boulder #68d0eab3
<<<ANSWER END>>>
<<<ANSWER key=K01829>>>
russet cinder harbor thistle auburn spruce thistle garnet thistle orbit trellis vellum kindle pewter copper cobalt nimbus crimson cedar quartz copper indigo fathom trellis #0d801f7d
<<<ANSWER END>>>
<<<ANSWER key=K05815>>>
harbor nimbus quartz marble zebra saffron trellis zebra trellis cobble garnet indigo zebra meadow lantern spruce nimbus kindle zebra spruce crimson trellis boulder cedar #9cadc538
<<<ANSWER END>>>
<<<ANSWER key=K04421>>>
ember orbit lattice glacier russet spruce meadow onyx boulder glacier fathom marble trellis boulder lattice fathom copper mistral nimbus spruce kindle saffron lantern quartz #584d4a4e
<<<ANSWER END>>>
<<<ANSWER key=K02179>>>
boulder auburn fathom willow cobalt marble mistral cobalt fathom meadow marble cedar willow saffron auburn verdant harbor fathom copper indigo orbit auburn crimson fathom #eafddd2a
<<<ANSWER END>>>
<<<ANSWER key=K01390>>>
cinder cobble boulder copper garnet orbit ember onyx meadow auburn copper pewter boulder crimson vellum falcon onyx nimbus thistle fathom meadow cobble fathom crimson #3a70c7b8
<<<ANSWER END>>>
<<<ANSWER key=K00663>>>
mistral crimson harbor willow copper thistle orbit harbor cobble onyx vellum kindle cinder lantern nimbus kindle fathom willow thistle lantern indigo fathom willow onyx #ec209056
<<<ANSWER END>>>
<<<ANSWER key=K05208>>>
quartz trellis crimson zebra cinder verdant lantern trellis thistle garnet saffron glacier marble harbor vellum spruce harbor trellis lantern trellis crimson cobalt crimson ember #7ce6d2d2
<<<ANSWER END>>>
<<<ANSWER key=K03863>>>
nimbus willow willow garnet spruce lantern saffron thistle onyx vellum cinder vellum willow russet meadow verdant russet spruce vellum indigo spruce boulder verdant fathom #7551b49c
<<<ANSWER END>>>
<<<ANSWER key=K07029>>>
pewter lattice cobble cedar saffron spruce copper vellum russet lantern russet pewter saffron russet lattice trellis lantern onyx kindle lantern lantern saffron lattice indigo #88a7614e
<<<ANSWER END>>>
<<<ANSWER key=K03005>>>
nimbus crimson mistral russet trellis falcon glacier garnet quartz marble pewter quartz trellis pewter harbor trellis pewter trellis meadow meadow crimson lantern russet saffron #7de0d400
<<<ANSWER END>>>
<<<ANSWER key=K06744>>>
cobble cedar cobble cobalt ember kindle verdant indigo cobalt cobble lantern zebra willow mistral meadow mistral russet copper thistle lattice cinder verdant boulder meadow #e546f97c
<<<ANSWER END>>>
<<<ANSWER key=K06345>>>
verdant kindle lantern willow willow onyx zebra auburn zebra crimson garnet verdant lantern thistle onyx harbor cobalt orbit copper glacier russet boulder cedar boulder #ab3363b7
<<<ANSWER END>>>
<<<ANSWER key=K00470>>>
cedar thistle onyx indigo indigo indigo harbor nimbus lantern verdant cinder willow copper auburn kindle thistle cinder cobalt cobble cinder harbor auburn orbit meadow #d5051a4c
<<<ANSWER END>>>
<<<ANSWER key=K03188>>>
lattice spruce falcon nimbus orbit spruce crimson fathom russet meadow fathom orbit marble thistle indigo thistle auburn quartz verdant quartz vellum lattice cobalt orbit #8d828b4b
<<<ANSWER END>>>
<<<ANSWER key=K00444>>>
meadow pewter onyx trellis fathom trellis garnet spruce nimbus glacier copper falcon garnet cobble kindle meadow cinder thistle meadow meadow garnet saffron indigo verdant #9ae1f28b
<<<ANSWER END>>>
<<<ANSWER key=K07944>>>
falcon indigo cobble nimbus kindle boulder glacier trellis nimbus saffron orbit fathom ember boulder garnet willow vellum lattice onyx pewter lattice pewter pewter spruce #cc019b2a
<<<ANSWER END>>>
<<<ANSWER key=K02174>>>
nimbus quartz nimbus lattice onyx marble vellum willow quartz mistral mistral willow cobalt cobble thistle orbit falcon auburn nimbus spruce garnet harbor verdant glacier #72ba2917
<<<ANSWER END>>>
<<<ANSWER key=K04350>>>
verdant trellis garnet cobalt onyx lantern harbor marble indigo saffron orbit meadow falcon marble fathom crimson harbor lattice indigo nimbus orbit nimbus quartz quartz #8078c1a1
<<<ANSWER END>>>
<<<ANSWER key=K03168>>>
marble nimbus zebra crimson lantern spruce russet meadow willow russet willow mistral quartz pewter meadow quartz copper mistral fathom cedar boulder ember crimson saffron #c7f0a703
<<<ANSWER END>>>
<<<ANSWER key=K01963>>>
lantern marble meadow glacier garnet ember saffron cinder lantern cinder onyx cobalt zebra onyx cobalt quartz lantern russet meadow copper trellis verdant marble russet #521ed3cf
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
