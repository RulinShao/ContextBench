#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00173>>>
cobalt thistle lattice cobble glacier thistle onyx spruce onyx indigo boulder trellis ember trellis mistral glacier boulder thistle saffron cobalt quartz cedar vellum onyx #03b823fc
<<<ANSWER END>>>
<<<ANSWER key=K00054>>>
vellum verdant falcon lantern thistle auburn trellis garnet copper lattice mistral harbor thistle copper lantern crimson indigo zebra saffron boulder kindle falcon pewter boulder #59b15acb
<<<ANSWER END>>>
<<<ANSWER key=K00124>>>
zebra harbor mistral fathom thistle willow vellum glacier zebra spruce cedar marble indigo copper harbor orbit russet harbor orbit cedar copper cobalt verdant onyx #835b9033
<<<ANSWER END>>>
<<<ANSWER key=K00045>>>
harbor boulder mistral lantern copper kindle lattice quartz saffron cedar cobble vellum ember onyx saffron trellis cobble quartz zebra vellum lantern glacier cinder cinder #c2af84a9
<<<ANSWER END>>>
<<<ANSWER key=K00004>>>
fathom vellum thistle vellum cobalt russet harbor pewter meadow cedar falcon copper zebra spruce mistral cinder zebra saffron crimson glacier spruce cinder cobalt marble #856ab7ed
<<<ANSWER END>>>
<<<ANSWER key=K00049>>>
zebra garnet trellis garnet vellum willow ember russet verdant glacier marble indigo cedar cobalt auburn zebra willow garnet marble trellis falcon russet crimson fathom #bef0c576
<<<ANSWER END>>>
<<<ANSWER key=K00206>>>
glacier cinder crimson lattice kindle willow trellis thistle thistle lantern fathom fathom lattice cedar thistle nimbus auburn trellis vellum quartz cobalt thistle boulder quartz #10653e17
<<<ANSWER END>>>
<<<ANSWER key=K00007>>>
nimbus spruce thistle verdant spruce zebra copper mistral harbor pewter verdant willow kindle cedar zebra orbit vellum willow cobble lattice thistle orbit marble crimson #ef323351
<<<ANSWER END>>>
<<<ANSWER key=K00200>>>
orbit zebra pewter cobble mistral cinder onyx auburn vellum falcon spruce verdant russet kindle cobalt quartz cobalt orbit boulder russet thistle pewter zebra lantern #a3268ff0
<<<ANSWER END>>>
<<<ANSWER key=K00130>>>
zebra cobble willow spruce glacier cinder indigo trellis onyx cedar spruce thistle glacier thistle crimson auburn lantern fathom spruce thistle lantern quartz copper thistle #313e962c
<<<ANSWER END>>>
<<<ANSWER key=K00204>>>
glacier spruce auburn garnet harbor auburn garnet zebra meadow quartz nimbus boulder cinder indigo saffron copper orbit orbit quartz cinder marble vellum harbor quartz #eddcea4c
<<<ANSWER END>>>
<<<ANSWER key=K00190>>>
copper mistral cinder harbor cobalt willow saffron garnet lattice lattice cobble cobalt zebra garnet garnet orbit mistral onyx saffron copper cinder copper pewter pewter #bf528ae3
<<<ANSWER END>>>
<<<ANSWER key=K00167>>>
indigo cobble zebra willow thistle willow indigo willow boulder willow boulder cobble willow vellum willow harbor quartz ember kindle russet auburn crimson cobble russet #9933d08f
<<<ANSWER END>>>
<<<ANSWER key=K00138>>>
quartz crimson willow cinder saffron onyx cinder fathom fathom fathom zebra harbor falcon copper cedar cobble mistral cedar fathom quartz marble quartz verdant ember #7e35e55c
<<<ANSWER END>>>
<<<ANSWER key=K00248>>>
indigo russet indigo thistle copper cobalt mistral meadow russet spruce glacier willow fathom cobble indigo spruce cedar verdant cinder cobalt fathom thistle meadow ember #843f436f
<<<ANSWER END>>>
<<<ANSWER key=K00233>>>
indigo fathom willow quartz lantern cobble russet mistral glacier kindle auburn willow russet russet trellis fathom indigo lantern boulder harbor cinder pewter fathom marble #b584ff95
<<<ANSWER END>>>
<<<ANSWER key=K00072>>>
vellum orbit kindle spruce crimson kindle willow falcon lattice zebra auburn fathom harbor mistral glacier ember mistral nimbus fathom cobalt cedar vellum auburn harbor #6bf27415
<<<ANSWER END>>>
<<<ANSWER key=K00148>>>
auburn ember verdant lattice boulder falcon kindle cobble meadow cobalt nimbus falcon garnet kindle verdant cedar auburn garnet lattice cinder quartz nimbus lantern orbit #1c9393e1
<<<ANSWER END>>>
<<<ANSWER key=K00142>>>
onyx saffron trellis falcon spruce thistle kindle garnet lattice meadow indigo meadow mistral zebra copper cobble cobble thistle harbor harbor spruce verdant indigo fathom #8f6a8dbd
<<<ANSWER END>>>
<<<ANSWER key=K00122>>>
verdant boulder zebra saffron falcon crimson orbit indigo spruce marble meadow ember glacier meadow lantern garnet russet russet cobble cinder glacier auburn cinder copper #ddd9fc9f
<<<ANSWER END>>>
<<<ANSWER key=K00178>>>
cinder cobalt nimbus falcon saffron quartz thistle boulder kindle vellum saffron trellis russet auburn cedar lantern indigo pewter pewter auburn onyx cobalt nimbus fathom #6fe557dc
<<<ANSWER END>>>
<<<ANSWER key=K00155>>>
saffron garnet lattice russet cinder trellis kindle mistral cobble thistle falcon harbor willow spruce marble saffron willow fathom zebra spruce crimson lantern cedar falcon #700bcb00
<<<ANSWER END>>>
<<<ANSWER key=K00161>>>
cinder fathom falcon lattice mistral onyx auburn lantern cobalt harbor ember lattice copper vellum thistle verdant glacier ember cedar boulder saffron kindle meadow trellis #3b2e6f91
<<<ANSWER END>>>
<<<ANSWER key=K00185>>>
meadow cobalt onyx auburn lantern crimson boulder marble russet meadow nimbus lattice mistral orbit crimson saffron onyx saffron lattice saffron russet marble kindle cobalt #61cf4dae
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
