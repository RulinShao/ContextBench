#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00101>>>
cobalt indigo willow meadow lattice zebra lattice spruce lattice russet vellum crimson trellis lattice meadow nimbus onyx cobble cobalt cedar onyx marble glacier quartz #fb248fcb
<<<ANSWER END>>>
<<<ANSWER key=K00011>>>
thistle lantern cobble russet meadow boulder thistle pewter vellum cobalt mistral cinder russet willow nimbus copper lantern cobalt indigo verdant zebra cobalt glacier nimbus #1455732a
<<<ANSWER END>>>
<<<ANSWER key=K00313>>>
quartz glacier trellis cedar copper lantern cobalt mistral indigo cobble verdant trellis fathom mistral willow falcon cobble spruce lantern onyx willow cobble cedar meadow #4fe15478
<<<ANSWER END>>>
<<<ANSWER key=K00307>>>
orbit nimbus russet trellis orbit verdant glacier pewter boulder indigo fathom auburn spruce nimbus mistral onyx boulder cinder trellis saffron lattice cobalt cinder copper #4ee12e40
<<<ANSWER END>>>
<<<ANSWER key=K00769>>>
russet zebra lantern cobble fathom fathom spruce pewter crimson falcon verdant glacier onyx spruce lattice cedar falcon nimbus spruce ember meadow mistral orbit meadow #371e4cae
<<<ANSWER END>>>
<<<ANSWER key=K00979>>>
lattice thistle cedar marble willow nimbus harbor boulder garnet cobble cobalt kindle lantern quartz copper fathom lattice cinder onyx falcon nimbus copper saffron fathom #439f0f2b
<<<ANSWER END>>>
<<<ANSWER key=K00697>>>
garnet falcon cobalt glacier cobble lantern ember cobble cedar ember quartz garnet harbor zebra glacier cobble marble trellis cinder falcon copper lattice cinder cobalt #45006b65
<<<ANSWER END>>>
<<<ANSWER key=K00485>>>
kindle pewter cedar lantern kindle falcon trellis lattice garnet pewter zebra verdant boulder fathom kindle quartz saffron indigo ember onyx copper fathom copper thistle #b2624d46
<<<ANSWER END>>>
<<<ANSWER key=K00974>>>
boulder boulder harbor thistle crimson garnet trellis cobalt cedar cinder russet cobalt zebra cedar meadow crimson crimson trellis saffron boulder orbit kindle meadow meadow #3eafa2e4
<<<ANSWER END>>>
<<<ANSWER key=K00827>>>
saffron falcon cedar kindle russet auburn kindle quartz indigo glacier kindle cobalt boulder cobble willow ember saffron cinder glacier mistral cinder harbor trellis auburn #250cfa16
<<<ANSWER END>>>
<<<ANSWER key=K00203>>>
russet willow garnet vellum lattice trellis fathom cinder harbor lantern cobble trellis fathom saffron cobble lattice spruce cedar zebra meadow meadow russet mistral garnet #9b3f786a
<<<ANSWER END>>>
<<<ANSWER key=K00565>>>
lattice ember pewter zebra cinder onyx cobble falcon copper cobalt quartz pewter auburn onyx quartz ember fathom onyx quartz boulder falcon boulder thistle meadow #f5d97b96
<<<ANSWER END>>>
<<<ANSWER key=K00704>>>
copper garnet onyx cobalt vellum fathom meadow thistle quartz copper mistral copper cobble ember cobalt orbit cobalt fathom cinder trellis meadow cobble cinder harbor #4140461e
<<<ANSWER END>>>
<<<ANSWER key=K00358>>>
verdant vellum falcon meadow thistle kindle cedar mistral crimson zebra cinder onyx pewter copper falcon nimbus meadow boulder willow kindle kindle vellum auburn meadow #e113fff3
<<<ANSWER END>>>
<<<ANSWER key=K00665>>>
cinder boulder fathom cedar zebra willow falcon lattice ember indigo boulder lattice cinder thistle crimson glacier onyx mistral marble pewter spruce garnet garnet copper #bf7d41cd
<<<ANSWER END>>>
<<<ANSWER key=K00586>>>
quartz garnet indigo fathom falcon garnet ember mistral cinder thistle meadow copper orbit lattice marble ember harbor fathom marble cinder russet kindle onyx thistle #b3bb03d6
<<<ANSWER END>>>
<<<ANSWER key=K00867>>>
spruce orbit pewter marble glacier harbor copper russet indigo vellum boulder cobalt thistle cedar orbit onyx cinder boulder cobble nimbus verdant cedar cobalt auburn #113644f8
<<<ANSWER END>>>
<<<ANSWER key=K00879>>>
saffron cobble verdant russet russet glacier boulder saffron orbit thistle cedar harbor cobalt meadow falcon nimbus crimson russet verdant harbor kindle nimbus lattice saffron #afdce33c
<<<ANSWER END>>>
<<<ANSWER key=K00091>>>
russet russet meadow onyx onyx marble onyx cedar kindle copper indigo lantern orbit orbit cobble cinder nimbus falcon harbor spruce onyx vellum spruce verdant #572d466b
<<<ANSWER END>>>
<<<ANSWER key=K00989>>>
vellum ember garnet cinder cedar auburn lantern verdant lantern meadow pewter auburn quartz mistral onyx cedar mistral thistle lattice willow orbit zebra saffron kindle #9a393c5a
<<<ANSWER END>>>
<<<ANSWER key=K00265>>>
zebra mistral zebra copper orbit quartz orbit falcon trellis kindle cedar ember kindle trellis trellis marble zebra vellum marble saffron quartz orbit auburn willow #267f7a97
<<<ANSWER END>>>
<<<ANSWER key=K00207>>>
saffron russet cobalt cinder falcon lantern boulder auburn meadow indigo kindle marble saffron willow onyx glacier thistle quartz ember kindle spruce garnet fathom saffron #2fca0dfc
<<<ANSWER END>>>
<<<ANSWER key=K00930>>>
indigo fathom cedar harbor ember russet verdant nimbus boulder thistle glacier trellis nimbus verdant orbit cedar harbor cobble spruce cobble verdant cinder cobble cinder #8165442b
<<<ANSWER END>>>
<<<ANSWER key=K00031>>>
falcon garnet zebra lantern saffron russet ember lantern verdant cedar pewter vellum glacier harbor fathom crimson fathom boulder fathom thistle fathom auburn russet trellis #5283b3f0
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
