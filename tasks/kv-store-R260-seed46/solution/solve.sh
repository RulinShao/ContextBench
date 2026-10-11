#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00008>>>
garnet willow marble verdant trellis onyx glacier verdant copper pewter harbor copper lantern falcon russet orbit willow verdant cobalt quartz boulder cobalt vellum falcon #bcd8df62
<<<ANSWER END>>>
<<<ANSWER key=K00145>>>
pewter verdant vellum vellum zebra cobalt garnet copper nimbus pewter orbit indigo verdant willow cobble nimbus orbit cobble saffron harbor onyx ember boulder cobble #e2684eaf
<<<ANSWER END>>>
<<<ANSWER key=K00125>>>
cobble nimbus thistle zebra crimson mistral trellis cobalt kindle onyx ember glacier ember verdant copper meadow pewter marble russet cobble cobble kindle vellum cobble #a3f43b91
<<<ANSWER END>>>
<<<ANSWER key=K00235>>>
auburn willow vellum lattice trellis harbor quartz thistle zebra willow nimbus auburn harbor nimbus onyx lantern saffron cinder glacier pewter onyx spruce boulder zebra #2ec30ec6
<<<ANSWER END>>>
<<<ANSWER key=K00192>>>
cobalt willow onyx crimson cobble cinder cobalt lantern russet cedar spruce russet lantern vellum auburn kindle trellis cobalt thistle indigo copper kindle copper nimbus #431a400a
<<<ANSWER END>>>
<<<ANSWER key=K00130>>>
saffron saffron vellum mistral falcon vellum falcon trellis ember glacier onyx glacier cedar lattice cobalt russet verdant trellis ember zebra garnet cedar pewter cedar #ed6c256e
<<<ANSWER END>>>
<<<ANSWER key=K00099>>>
glacier vellum pewter orbit garnet fathom verdant garnet orbit pewter cobalt zebra quartz marble meadow mistral russet cobalt cobble glacier auburn cobble lattice ember #c5e07872
<<<ANSWER END>>>
<<<ANSWER key=K00206>>>
verdant crimson cedar trellis nimbus copper pewter copper orbit mistral zebra thistle ember thistle lattice garnet auburn kindle cobalt indigo willow kindle lantern kindle #14b394bc
<<<ANSWER END>>>
<<<ANSWER key=K00223>>>
ember spruce glacier thistle boulder saffron zebra russet glacier fathom thistle meadow auburn cedar willow mistral harbor boulder cedar onyx vellum lantern lattice crimson #5caa6f39
<<<ANSWER END>>>
<<<ANSWER key=K00000>>>
meadow spruce zebra marble kindle willow mistral zebra crimson meadow glacier orbit crimson quartz boulder kindle verdant cobalt spruce russet lattice willow russet garnet #f163d1ab
<<<ANSWER END>>>
<<<ANSWER key=K00224>>>
willow falcon garnet cedar fathom ember ember copper copper falcon boulder thistle garnet trellis lattice boulder willow crimson falcon willow trellis garnet indigo spruce #28956d02
<<<ANSWER END>>>
<<<ANSWER key=K00014>>>
cobalt vellum copper onyx thistle onyx russet ember quartz marble cinder russet fathom onyx orbit marble kindle cobble nimbus marble nimbus lattice pewter spruce #551bd250
<<<ANSWER END>>>
<<<ANSWER key=K00086>>>
orbit crimson indigo onyx fathom marble quartz crimson pewter pewter marble orbit fathom orbit lattice indigo boulder cinder trellis meadow crimson auburn orbit zebra #0e1d84ee
<<<ANSWER END>>>
<<<ANSWER key=K00064>>>
willow lantern cobble orbit cobble harbor lantern ember nimbus ember trellis verdant ember fathom indigo marble lantern thistle ember trellis glacier meadow crimson thistle #c770ad9d
<<<ANSWER END>>>
<<<ANSWER key=K00025>>>
spruce mistral quartz trellis lantern cedar marble fathom falcon auburn saffron orbit copper mistral glacier falcon vellum thistle onyx cobalt cedar glacier thistle thistle #8455dbc9
<<<ANSWER END>>>
<<<ANSWER key=K00109>>>
indigo pewter zebra onyx verdant orbit willow orbit lattice willow zebra verdant nimbus mistral mistral indigo copper verdant harbor lantern lattice glacier zebra ember #5e917685
<<<ANSWER END>>>
<<<ANSWER key=K00139>>>
lattice cinder cobalt glacier vellum zebra nimbus mistral quartz pewter lattice russet kindle verdant saffron copper orbit thistle crimson glacier cinder copper willow cedar #f5ae22e3
<<<ANSWER END>>>
<<<ANSWER key=K00017>>>
cobble nimbus cedar crimson spruce thistle cinder thistle lattice saffron ember kindle lattice boulder boulder mistral indigo onyx orbit quartz cobble garnet quartz marble #f9780575
<<<ANSWER END>>>
<<<ANSWER key=K00257>>>
fathom onyx ember harbor cobalt boulder indigo falcon meadow orbit zebra harbor crimson trellis cobalt ember thistle indigo fathom orbit boulder zebra mistral crimson #3efc9480
<<<ANSWER END>>>
<<<ANSWER key=K00147>>>
willow trellis quartz kindle lantern thistle trellis harbor pewter marble cobalt nimbus cinder garnet cobalt boulder cobalt quartz onyx glacier mistral copper russet willow #1b844317
<<<ANSWER END>>>
<<<ANSWER key=K00244>>>
thistle kindle fathom nimbus glacier glacier spruce quartz kindle indigo lattice kindle meadow ember falcon cobalt verdant onyx vellum mistral cobalt nimbus marble cobble #1bf343c8
<<<ANSWER END>>>
<<<ANSWER key=K00159>>>
vellum russet nimbus vellum nimbus indigo mistral boulder orbit ember willow boulder russet russet meadow garnet kindle lattice lantern copper saffron boulder meadow cedar #0d93c49c
<<<ANSWER END>>>
<<<ANSWER key=K00215>>>
harbor indigo glacier nimbus vellum nimbus copper onyx pewter meadow auburn orbit willow cobalt cinder spruce falcon cinder trellis cobble auburn kindle cobble indigo #3a009de3
<<<ANSWER END>>>
<<<ANSWER key=K00158>>>
orbit orbit cobble quartz boulder boulder kindle marble cobalt marble garnet meadow lantern onyx cedar copper verdant indigo zebra orbit mistral harbor garnet spruce #897414d1
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
