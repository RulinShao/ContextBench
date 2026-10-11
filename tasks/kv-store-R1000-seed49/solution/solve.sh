#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00663>>>
auburn cinder saffron verdant fathom orbit cinder thistle kindle ember nimbus crimson lantern willow mistral fathom spruce mistral lattice harbor spruce lantern zebra copper #f1bd21d6
<<<ANSWER END>>>
<<<ANSWER key=K00173>>>
russet pewter verdant willow lattice auburn kindle copper falcon boulder kindle garnet vellum pewter ember kindle lattice onyx spruce fathom orbit pewter meadow kindle #5f713e22
<<<ANSWER END>>>
<<<ANSWER key=K00621>>>
glacier cedar lattice falcon indigo spruce thistle onyx cinder copper spruce vellum nimbus fathom trellis ember glacier russet orbit quartz spruce quartz harbor fathom #75c9cc5c
<<<ANSWER END>>>
<<<ANSWER key=K00125>>>
cedar meadow nimbus cinder trellis trellis boulder crimson glacier lantern cinder spruce willow harbor cobble auburn auburn lantern pewter ember quartz mistral garnet fathom #49afcbe1
<<<ANSWER END>>>
<<<ANSWER key=K00754>>>
willow onyx falcon onyx willow vellum mistral lantern lantern cobalt copper auburn lantern glacier garnet quartz orbit willow trellis kindle pewter willow cobalt saffron #ef0a4ad3
<<<ANSWER END>>>
<<<ANSWER key=K00039>>>
pewter copper falcon cobble mistral boulder kindle meadow kindle copper spruce mistral cedar nimbus willow copper copper spruce vellum thistle kindle zebra boulder willow #09916351
<<<ANSWER END>>>
<<<ANSWER key=K00120>>>
quartz fathom indigo saffron boulder marble vellum mistral copper meadow orbit onyx harbor zebra glacier russet lantern vellum cinder falcon verdant mistral glacier nimbus #5225ffe9
<<<ANSWER END>>>
<<<ANSWER key=K00292>>>
fathom thistle russet verdant nimbus lantern mistral boulder vellum boulder crimson nimbus indigo marble willow glacier lattice meadow trellis cedar russet verdant auburn crimson #cb6eec1a
<<<ANSWER END>>>
<<<ANSWER key=K00111>>>
trellis glacier vellum onyx thistle marble crimson vellum lattice lantern cedar pewter onyx garnet indigo marble saffron onyx saffron mistral cobalt copper vellum russet #6561c3ed
<<<ANSWER END>>>
<<<ANSWER key=K00800>>>
ember vellum pewter meadow vellum copper cinder verdant cinder cinder cinder cobalt ember pewter cobble spruce lattice cobalt zebra saffron cinder verdant thistle fathom #501af291
<<<ANSWER END>>>
<<<ANSWER key=K00662>>>
fathom auburn kindle marble auburn willow quartz quartz cedar crimson trellis glacier indigo kindle mistral zebra orbit thistle pewter onyx meadow falcon fathom cobble #1e6a7dfb
<<<ANSWER END>>>
<<<ANSWER key=K00531>>>
zebra verdant auburn auburn cobalt garnet auburn verdant lattice verdant cobalt saffron cobble willow fathom thistle crimson cobble willow boulder mistral kindle nimbus mistral #dc0204a3
<<<ANSWER END>>>
<<<ANSWER key=K00838>>>
onyx verdant lantern zebra indigo marble indigo harbor harbor quartz cobble garnet cobble lattice spruce lantern lantern quartz ember cinder boulder glacier falcon glacier #d354d802
<<<ANSWER END>>>
<<<ANSWER key=K00041>>>
ember copper copper mistral marble cobalt thistle orbit thistle kindle quartz verdant garnet willow saffron willow russet auburn falcon nimbus copper lantern cobalt crimson #aa741313
<<<ANSWER END>>>
<<<ANSWER key=K00334>>>
crimson falcon ember trellis falcon harbor orbit lattice mistral lattice nimbus spruce cobble thistle lattice cobble onyx copper harbor glacier harbor cinder indigo copper #1a374420
<<<ANSWER END>>>
<<<ANSWER key=K00356>>>
auburn spruce mistral kindle russet mistral pewter nimbus trellis falcon cobble crimson meadow pewter zebra spruce russet fathom garnet verdant russet cedar crimson crimson #2d8f92d4
<<<ANSWER END>>>
<<<ANSWER key=K00842>>>
cobalt mistral lattice onyx quartz boulder glacier copper verdant marble onyx fathom quartz cinder meadow saffron harbor meadow cobalt marble orbit cobalt onyx copper #bb7cface
<<<ANSWER END>>>
<<<ANSWER key=K00457>>>
falcon russet vellum verdant copper kindle orbit meadow copper glacier cobalt lattice cinder lantern mistral ember ember pewter crimson cinder harbor copper ember ember #f041ebdb
<<<ANSWER END>>>
<<<ANSWER key=K00835>>>
vellum garnet cedar cedar onyx boulder auburn zebra zebra mistral garnet indigo garnet russet orbit cedar onyx boulder spruce russet garnet cobble boulder verdant #79169a15
<<<ANSWER END>>>
<<<ANSWER key=K00778>>>
garnet cedar spruce falcon quartz fathom lantern indigo mistral nimbus marble auburn spruce fathom cobble verdant vellum meadow trellis indigo lattice russet cedar kindle #b70c2faf
<<<ANSWER END>>>
<<<ANSWER key=K00893>>>
lattice fathom zebra cobble vellum lantern verdant nimbus marble ember meadow glacier crimson ember vellum spruce zebra crimson saffron thistle trellis trellis spruce crimson #9dbd98e0
<<<ANSWER END>>>
<<<ANSWER key=K00009>>>
verdant pewter lantern lattice verdant cobble zebra saffron marble spruce trellis zebra cedar russet crimson russet harbor trellis cobble vellum thistle russet orbit cedar #3a9a0b7b
<<<ANSWER END>>>
<<<ANSWER key=K00651>>>
kindle ember auburn mistral cinder boulder harbor mistral thistle pewter falcon trellis verdant spruce nimbus ember zebra lattice russet auburn spruce fathom glacier copper #1c53fbdf
<<<ANSWER END>>>
<<<ANSWER key=K00904>>>
onyx thistle verdant lantern cedar meadow falcon glacier cinder saffron harbor ember verdant russet ember vellum vellum boulder kindle thistle lattice russet cedar auburn #c4ba121f
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
