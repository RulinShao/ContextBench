#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00218>>>
fathom russet lattice nimbus auburn cobble russet quartz harbor cedar marble zebra onyx lantern saffron onyx marble cedar pewter meadow nimbus vellum cobble glacier #78907981
<<<ANSWER END>>>
<<<ANSWER key=K00138>>>
boulder cobalt russet ember trellis spruce russet cobble indigo cobalt mistral auburn nimbus lattice auburn lattice nimbus vellum zebra indigo vellum garnet indigo marble #d50ae449
<<<ANSWER END>>>
<<<ANSWER key=K00106>>>
onyx cobalt ember willow copper trellis verdant garnet pewter kindle russet copper russet thistle vellum vellum glacier meadow trellis zebra ember crimson verdant thistle #ac496726
<<<ANSWER END>>>
<<<ANSWER key=K00041>>>
saffron lantern orbit cobble boulder marble copper marble cedar indigo quartz thistle zebra trellis vellum zebra lattice quartz cobalt boulder glacier onyx nimbus cedar #e095841c
<<<ANSWER END>>>
<<<ANSWER key=K00171>>>
trellis pewter copper pewter onyx fathom willow harbor nimbus marble indigo cedar ember nimbus orbit garnet meadow boulder meadow indigo thistle cedar cobble verdant #5032fdc3
<<<ANSWER END>>>
<<<ANSWER key=K00188>>>
zebra russet lattice glacier cobble saffron cobble nimbus fathom saffron spruce marble quartz orbit kindle cinder russet mistral zebra fathom copper spruce nimbus garnet #d95fc267
<<<ANSWER END>>>
<<<ANSWER key=K00238>>>
boulder quartz quartz lantern meadow crimson willow cobble cinder quartz cobalt quartz onyx garnet cinder nimbus garnet fathom cinder vellum auburn copper marble nimbus #7d938514
<<<ANSWER END>>>
<<<ANSWER key=K00014>>>
lattice willow cinder quartz zebra trellis lattice zebra copper pewter falcon thistle copper onyx willow falcon harbor nimbus onyx crimson nimbus verdant onyx falcon #2fb35fff
<<<ANSWER END>>>
<<<ANSWER key=K00131>>>
glacier marble crimson saffron orbit russet kindle copper marble harbor thistle falcon falcon saffron mistral orbit marble auburn copper nimbus nimbus falcon glacier copper #d5f0a085
<<<ANSWER END>>>
<<<ANSWER key=K00242>>>
falcon cobble nimbus kindle zebra verdant cobalt willow willow cobble onyx auburn falcon vellum harbor pewter copper orbit indigo ember orbit harbor garnet spruce #95de8245
<<<ANSWER END>>>
<<<ANSWER key=K00232>>>
verdant mistral vellum orbit quartz crimson russet orbit thistle auburn orbit cobalt cinder spruce nimbus vellum copper trellis verdant cedar mistral cobalt garnet quartz #689a49f1
<<<ANSWER END>>>
<<<ANSWER key=K00172>>>
copper quartz falcon thistle boulder meadow cedar glacier cobble vellum verdant trellis willow lattice glacier cinder harbor lantern glacier falcon marble cinder saffron lattice #c6361ab7
<<<ANSWER END>>>
<<<ANSWER key=K00093>>>
pewter spruce falcon glacier boulder auburn garnet mistral copper trellis indigo lattice fathom cobble garnet thistle russet glacier pewter lattice glacier onyx zebra marble #2eea73ee
<<<ANSWER END>>>
<<<ANSWER key=K00227>>>
spruce crimson nimbus cedar verdant verdant russet russet zebra quartz russet willow garnet mistral verdant garnet onyx orbit kindle trellis glacier mistral crimson pewter #0857934b
<<<ANSWER END>>>
<<<ANSWER key=K00013>>>
verdant pewter indigo fathom cobble indigo orbit cobalt cinder saffron zebra lantern verdant quartz indigo harbor vellum cinder lantern ember meadow willow mistral zebra #c9232651
<<<ANSWER END>>>
<<<ANSWER key=K00028>>>
indigo marble ember cedar glacier ember mistral nimbus cedar pewter russet saffron kindle boulder thistle cedar boulder marble lattice nimbus trellis lantern mistral quartz #f8af7816
<<<ANSWER END>>>
<<<ANSWER key=K00098>>>
saffron zebra meadow saffron mistral zebra nimbus glacier crimson pewter willow spruce meadow trellis harbor falcon auburn mistral verdant auburn quartz cobalt fathom copper #9e3b34e1
<<<ANSWER END>>>
<<<ANSWER key=K00247>>>
thistle vellum indigo thistle zebra meadow meadow indigo vellum crimson cobble willow lantern zebra auburn saffron willow verdant spruce lantern fathom cobble russet cinder #88a9b646
<<<ANSWER END>>>
<<<ANSWER key=K00119>>>
onyx lattice mistral nimbus russet meadow crimson meadow lantern indigo pewter zebra orbit spruce fathom boulder fathom onyx cinder spruce cobalt mistral mistral willow #b5fb9443
<<<ANSWER END>>>
<<<ANSWER key=K00158>>>
harbor meadow cobble glacier falcon verdant saffron orbit fathom marble auburn spruce falcon cobalt garnet vellum vellum cobalt cobble vellum glacier ember cobble crimson #0dcdfe7d
<<<ANSWER END>>>
<<<ANSWER key=K00010>>>
cinder cobble willow cedar boulder pewter orbit mistral orbit glacier orbit orbit russet fathom kindle harbor orbit fathom cobalt nimbus meadow meadow falcon spruce #02d7872e
<<<ANSWER END>>>
<<<ANSWER key=K00250>>>
zebra verdant orbit verdant zebra spruce ember pewter kindle garnet mistral willow marble meadow zebra willow cobble crimson russet zebra falcon quartz lantern nimbus #05d4f27c
<<<ANSWER END>>>
<<<ANSWER key=K00253>>>
russet quartz pewter willow saffron kindle vellum onyx falcon nimbus zebra nimbus cobble cobalt trellis copper onyx lantern falcon cedar ember kindle thistle lattice #fe1c36f5
<<<ANSWER END>>>
<<<ANSWER key=K00044>>>
mistral quartz auburn garnet lattice mistral onyx willow onyx thistle cobble onyx saffron zebra lattice pewter vellum vellum falcon lattice thistle lattice mistral copper #d81bb32e
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
