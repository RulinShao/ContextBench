#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K07502>>>
orbit onyx auburn orbit falcon lantern cinder quartz cedar boulder cobble lantern lattice lattice vellum zebra spruce glacier thistle auburn ember verdant pewter meadow #cbc0b960
<<<ANSWER END>>>
<<<ANSWER key=K06032>>>
quartz zebra verdant marble garnet vellum thistle cinder nimbus saffron onyx copper marble meadow quartz cinder willow verdant ember vellum pewter boulder crimson boulder #0c4e79ba
<<<ANSWER END>>>
<<<ANSWER key=K07399>>>
zebra meadow pewter zebra lantern trellis quartz boulder russet indigo spruce ember nimbus trellis fathom copper trellis cinder verdant cinder nimbus copper onyx lantern #8823f803
<<<ANSWER END>>>
<<<ANSWER key=K01674>>>
lantern trellis fathom lantern saffron cobalt trellis crimson cobalt mistral cinder pewter cobble nimbus cobalt orbit crimson zebra pewter harbor indigo marble pewter boulder #2bd332cb
<<<ANSWER END>>>
<<<ANSWER key=K00763>>>
meadow verdant lantern ember ember willow garnet pewter vellum garnet ember cedar indigo fathom nimbus marble cobalt willow harbor spruce orbit auburn copper auburn #d1bc4f40
<<<ANSWER END>>>
<<<ANSWER key=K06026>>>
lantern mistral vellum mistral auburn garnet cobble saffron marble zebra zebra pewter garnet auburn lantern thistle glacier russet marble harbor vellum mistral spruce pewter #615c77f4
<<<ANSWER END>>>
<<<ANSWER key=K05202>>>
verdant harbor auburn pewter auburn fathom indigo glacier willow harbor copper mistral meadow trellis marble falcon harbor ember thistle spruce meadow saffron glacier harbor #2ef30d35
<<<ANSWER END>>>
<<<ANSWER key=K04067>>>
onyx auburn saffron trellis russet mistral zebra russet lantern meadow cobble mistral zebra marble marble marble nimbus spruce cedar garnet fathom zebra fathom meadow #3c572860
<<<ANSWER END>>>
<<<ANSWER key=K02832>>>
lattice spruce mistral russet thistle vellum zebra ember nimbus falcon garnet cinder quartz pewter falcon boulder falcon lattice meadow verdant lattice cobalt glacier russet #8cc5e269
<<<ANSWER END>>>
<<<ANSWER key=K06985>>>
saffron thistle copper falcon cinder vellum saffron willow crimson quartz indigo indigo auburn lantern cinder saffron fathom indigo russet trellis cinder garnet copper saffron #6056523f
<<<ANSWER END>>>
<<<ANSWER key=K00250>>>
russet meadow indigo cinder garnet falcon cobalt lantern thistle willow willow marble indigo nimbus garnet glacier lantern zebra kindle verdant cedar thistle cinder quartz #89bd9cb4
<<<ANSWER END>>>
<<<ANSWER key=K06476>>>
trellis verdant fathom saffron thistle verdant marble orbit garnet trellis kindle ember ember spruce cobble thistle zebra falcon verdant glacier pewter kindle cobalt orbit #ac24e2de
<<<ANSWER END>>>
<<<ANSWER key=K05456>>>
mistral indigo meadow lantern fathom orbit copper marble spruce glacier marble russet willow auburn trellis pewter orbit cedar ember fathom harbor falcon zebra lantern #f53aadce
<<<ANSWER END>>>
<<<ANSWER key=K03389>>>
saffron falcon kindle spruce spruce onyx orbit fathom pewter cinder lantern spruce pewter ember cinder nimbus quartz falcon quartz russet thistle cobalt verdant boulder #f12c9174
<<<ANSWER END>>>
<<<ANSWER key=K07448>>>
crimson russet marble nimbus cedar falcon harbor thistle spruce nimbus cedar thistle zebra lattice russet crimson auburn ember cobalt orbit ember cedar copper indigo #21d217c1
<<<ANSWER END>>>
<<<ANSWER key=K06410>>>
onyx pewter cedar cinder indigo zebra meadow garnet copper garnet ember spruce pewter pewter cedar ember cinder glacier falcon glacier meadow onyx copper ember #0c593292
<<<ANSWER END>>>
<<<ANSWER key=K05174>>>
lantern cedar ember trellis mistral cedar spruce saffron onyx verdant cobble lantern trellis verdant glacier quartz lantern zebra ember cobalt verdant cedar saffron pewter #dbcfd42a
<<<ANSWER END>>>
<<<ANSWER key=K00616>>>
quartz spruce mistral verdant lantern nimbus lantern mistral verdant harbor falcon orbit vellum pewter nimbus onyx pewter spruce spruce cobble meadow onyx trellis saffron #5a1e168c
<<<ANSWER END>>>
<<<ANSWER key=K02121>>>
glacier trellis trellis cinder crimson trellis cinder auburn cobble indigo willow harbor verdant orbit verdant onyx copper meadow quartz russet vellum cedar zebra crimson #3720b47e
<<<ANSWER END>>>
<<<ANSWER key=K04815>>>
quartz russet cobble garnet harbor kindle trellis boulder pewter copper crimson crimson cobalt lattice orbit onyx indigo thistle quartz cobble meadow orbit ember lattice #d861e8a2
<<<ANSWER END>>>
<<<ANSWER key=K07591>>>
kindle cinder russet marble cedar ember falcon harbor garnet auburn quartz vellum fathom zebra cobble pewter lantern garnet lantern lantern boulder mistral saffron marble #841ab775
<<<ANSWER END>>>
<<<ANSWER key=K04586>>>
pewter fathom cobble ember boulder saffron onyx meadow verdant onyx verdant mistral cobalt lattice russet quartz verdant boulder zebra lantern falcon russet cedar meadow #1b347991
<<<ANSWER END>>>
<<<ANSWER key=K02995>>>
garnet vellum willow spruce falcon cedar crimson lantern nimbus pewter verdant indigo cedar cobalt willow harbor marble lantern marble spruce quartz cinder marble indigo #bf4118ae
<<<ANSWER END>>>
<<<ANSWER key=K03042>>>
harbor saffron quartz ember mistral indigo cedar falcon cobalt verdant quartz copper vellum thistle saffron crimson meadow garnet lattice cobalt spruce pewter lattice zebra #7ed7dc18
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
