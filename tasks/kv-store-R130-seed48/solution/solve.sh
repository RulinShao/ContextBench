#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00009>>>
spruce mistral mistral verdant copper copper pewter harbor cobble fathom cobalt marble nimbus trellis cinder meadow falcon indigo russet cinder kindle indigo garnet cobalt #38513ede
<<<ANSWER END>>>
<<<ANSWER key=K00124>>>
zebra harbor mistral fathom thistle willow vellum glacier zebra spruce cedar marble indigo copper harbor orbit russet harbor orbit cedar copper cobalt verdant onyx #835b9033
<<<ANSWER END>>>
<<<ANSWER key=K00039>>>
copper saffron verdant glacier cobble cedar cobble boulder nimbus quartz cedar cedar cobalt auburn lattice harbor onyx cedar garnet harbor kindle crimson falcon meadow #aadaa5cd
<<<ANSWER END>>>
<<<ANSWER key=K00050>>>
cinder onyx indigo russet quartz nimbus trellis spruce mistral cedar lantern meadow verdant cinder boulder saffron garnet lattice mistral lattice pewter thistle cinder cobble #3502bb9e
<<<ANSWER END>>>
<<<ANSWER key=K00094>>>
onyx cobalt pewter ember kindle russet verdant glacier russet cobble marble vellum garnet meadow marble auburn auburn spruce willow nimbus spruce cinder willow saffron #5b000c24
<<<ANSWER END>>>
<<<ANSWER key=K00041>>>
saffron falcon mistral cobble meadow russet ember vellum crimson meadow copper saffron saffron thistle boulder cedar cedar pewter onyx zebra willow willow nimbus marble #7687c45b
<<<ANSWER END>>>
<<<ANSWER key=K00055>>>
verdant falcon cobalt trellis cobble harbor willow russet cedar vellum cedar cobble harbor cobble harbor vellum boulder lantern glacier boulder vellum verdant lattice willow #b24fa2e4
<<<ANSWER END>>>
<<<ANSWER key=K00102>>>
zebra glacier glacier thistle mistral spruce onyx glacier lantern willow marble quartz lantern zebra quartz cinder spruce willow willow falcon ember saffron falcon vellum #140913bb
<<<ANSWER END>>>
<<<ANSWER key=K00033>>>
vellum willow orbit indigo lattice onyx boulder glacier nimbus crimson copper harbor kindle quartz verdant russet zebra orbit kindle willow glacier lattice pewter pewter #3b5f35fd
<<<ANSWER END>>>
<<<ANSWER key=K00038>>>
ember copper cinder fathom trellis pewter cobble saffron garnet meadow garnet quartz harbor cobalt kindle kindle harbor harbor boulder zebra vellum spruce willow thistle #9aa8216a
<<<ANSWER END>>>
<<<ANSWER key=K00077>>>
vellum cinder copper lattice glacier harbor thistle fathom zebra verdant cobble saffron ember harbor lattice fathom thistle zebra cinder kindle falcon glacier copper fathom #372358f9
<<<ANSWER END>>>
<<<ANSWER key=K00084>>>
auburn saffron trellis fathom copper trellis cedar cobalt auburn lantern indigo spruce glacier boulder harbor crimson crimson saffron fathom fathom cedar mistral orbit boulder #dcfe4c88
<<<ANSWER END>>>
<<<ANSWER key=K00053>>>
cobble cobble orbit pewter mistral pewter verdant falcon ember zebra verdant falcon spruce marble vellum lantern cinder crimson pewter trellis cedar cinder lantern auburn #5693bb1f
<<<ANSWER END>>>
<<<ANSWER key=K00081>>>
ember willow cinder indigo cedar trellis mistral lantern cobble auburn fathom pewter cedar kindle pewter cobalt mistral harbor spruce boulder spruce orbit glacier orbit #f1068645
<<<ANSWER END>>>
<<<ANSWER key=K00106>>>
glacier indigo lattice ember thistle cinder spruce indigo falcon zebra spruce cobble ember harbor mistral thistle trellis nimbus indigo quartz indigo glacier russet fathom #a250a676
<<<ANSWER END>>>
<<<ANSWER key=K00024>>>
cinder garnet spruce boulder marble thistle harbor russet trellis spruce vellum quartz glacier kindle willow quartz fathom fathom garnet falcon trellis meadow quartz glacier #af8357c2
<<<ANSWER END>>>
<<<ANSWER key=K00051>>>
saffron glacier quartz onyx indigo zebra marble russet fathom cedar trellis ember saffron orbit vellum harbor mistral copper marble mistral crimson nimbus spruce orbit #e89906f2
<<<ANSWER END>>>
<<<ANSWER key=K00088>>>
lantern quartz boulder trellis kindle vellum auburn saffron fathom meadow marble garnet russet orbit mistral crimson marble lattice cobalt meadow kindle boulder harbor vellum #32907fc5
<<<ANSWER END>>>
<<<ANSWER key=K00012>>>
orbit garnet cinder marble spruce cobalt zebra garnet quartz trellis marble pewter crimson auburn boulder onyx meadow cobble crimson lattice cobalt harbor nimbus spruce #ba08bcb5
<<<ANSWER END>>>
<<<ANSWER key=K00072>>>
vellum orbit kindle spruce crimson kindle willow falcon lattice zebra auburn fathom harbor mistral glacier ember mistral nimbus fathom cobalt cedar vellum auburn harbor #6bf27415
<<<ANSWER END>>>
<<<ANSWER key=K00100>>>
spruce fathom cobble marble nimbus boulder crimson saffron trellis cedar lattice falcon verdant vellum marble orbit copper onyx falcon ember cobalt lantern boulder crimson #0579c9d0
<<<ANSWER END>>>
<<<ANSWER key=K00091>>>
onyx saffron vellum marble falcon boulder pewter falcon thistle onyx pewter meadow trellis indigo quartz indigo saffron boulder onyx indigo auburn marble trellis mistral #82c243a1
<<<ANSWER END>>>
<<<ANSWER key=K00128>>>
zebra zebra thistle marble vellum crimson fathom auburn marble crimson marble cobalt thistle marble ember verdant kindle trellis kindle marble falcon marble vellum thistle #63f0b51a
<<<ANSWER END>>>
<<<ANSWER key=K00013>>>
thistle crimson lattice thistle marble cobble thistle russet saffron meadow zebra cobble fathom pewter garnet kindle thistle glacier cobble onyx garnet thistle willow ember #37e146a1
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
