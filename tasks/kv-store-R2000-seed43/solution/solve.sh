#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K01807>>>
mistral cobble glacier boulder cobble orbit crimson spruce trellis glacier cinder pewter thistle auburn fathom falcon spruce cobble ember onyx garnet meadow lantern meadow #a5667556
<<<ANSWER END>>>
<<<ANSWER key=K01634>>>
vellum saffron fathom zebra lattice garnet pewter zebra kindle glacier marble russet cinder falcon vellum cedar ember glacier verdant trellis boulder saffron zebra saffron #4b56c643
<<<ANSWER END>>>
<<<ANSWER key=K01562>>>
vellum cobble ember ember russet ember ember marble harbor cobble cobble copper copper russet boulder orbit copper falcon kindle garnet auburn nimbus spruce cobble #0afd62a5
<<<ANSWER END>>>
<<<ANSWER key=K00241>>>
glacier trellis onyx pewter boulder pewter kindle quartz orbit crimson kindle marble willow willow copper ember meadow quartz quartz lattice boulder onyx cobalt meadow #f6ee7620
<<<ANSWER END>>>
<<<ANSWER key=K01961>>>
crimson copper onyx willow willow spruce zebra lattice garnet pewter crimson boulder onyx trellis saffron indigo vellum meadow mistral boulder cinder indigo fathom crimson #dedfcc8d
<<<ANSWER END>>>
<<<ANSWER key=K00267>>>
garnet fathom auburn willow fathom cinder saffron orbit trellis ember marble mistral thistle marble falcon onyx glacier orbit fathom cedar pewter onyx spruce russet #b7f46eff
<<<ANSWER END>>>
<<<ANSWER key=K01608>>>
lantern falcon auburn russet meadow falcon saffron vellum copper crimson orbit crimson fathom nimbus mistral marble falcon auburn kindle lantern verdant pewter verdant willow #39ab00eb
<<<ANSWER END>>>
<<<ANSWER key=K00532>>>
lattice cedar fathom pewter vellum spruce thistle orbit onyx cedar lantern trellis cobble quartz garnet kindle verdant auburn pewter onyx kindle garnet falcon pewter #4925327d
<<<ANSWER END>>>
<<<ANSWER key=K01665>>>
thistle marble onyx cedar crimson auburn russet cobble lantern cinder garnet russet cinder cedar saffron quartz vellum copper lantern quartz ember boulder fathom auburn #e99b228f
<<<ANSWER END>>>
<<<ANSWER key=K01678>>>
willow nimbus marble copper boulder cinder crimson onyx cobalt harbor cobble crimson cinder mistral mistral kindle pewter lattice willow thistle kindle willow auburn indigo #0629368f
<<<ANSWER END>>>
<<<ANSWER key=K01200>>>
orbit pewter spruce garnet quartz thistle russet onyx thistle cobble glacier copper quartz trellis fathom glacier ember crimson boulder kindle copper fathom zebra russet #e4bc0275
<<<ANSWER END>>>
<<<ANSWER key=K01100>>>
quartz harbor onyx cedar falcon russet pewter cedar ember crimson saffron glacier thistle crimson trellis copper kindle meadow kindle trellis kindle vellum quartz orbit #89e91483
<<<ANSWER END>>>
<<<ANSWER key=K01192>>>
fathom harbor pewter meadow cobalt trellis copper zebra cinder glacier mistral boulder onyx orbit cobble mistral boulder falcon cobalt lattice nimbus spruce cobalt cedar #5aee18fb
<<<ANSWER END>>>
<<<ANSWER key=K00287>>>
kindle garnet onyx harbor saffron indigo vellum cobble nimbus orbit kindle ember quartz ember cinder saffron cedar willow zebra lattice mistral falcon cinder cedar #f06c1fcd
<<<ANSWER END>>>
<<<ANSWER key=K00146>>>
marble falcon meadow kindle harbor fathom trellis mistral glacier harbor crimson cobble nimbus verdant vellum crimson orbit copper orbit cobble orbit lantern ember boulder #6b60f265
<<<ANSWER END>>>
<<<ANSWER key=K00092>>>
mistral lattice lattice copper mistral fathom cobble falcon garnet verdant lattice russet lantern trellis zebra lattice falcon lattice trellis lattice glacier spruce saffron garnet #3915c06b
<<<ANSWER END>>>
<<<ANSWER key=K01436>>>
trellis marble boulder willow marble cobalt cinder lattice copper auburn cinder thistle nimbus willow lattice crimson ember russet falcon fathom crimson orbit onyx harbor #3fd3a553
<<<ANSWER END>>>
<<<ANSWER key=K00775>>>
saffron ember crimson glacier crimson auburn crimson lantern indigo harbor cedar trellis garnet mistral quartz zebra glacier spruce ember ember thistle kindle orbit fathom #1a9eaa6f
<<<ANSWER END>>>
<<<ANSWER key=K00684>>>
quartz orbit cobble pewter zebra vellum garnet lattice verdant verdant russet garnet cobalt quartz crimson marble cobble harbor harbor marble cedar orbit verdant russet #3f1cb25e
<<<ANSWER END>>>
<<<ANSWER key=K00515>>>
kindle onyx boulder copper quartz verdant crimson nimbus garnet crimson harbor orbit orbit pewter lantern indigo trellis saffron harbor pewter cedar crimson meadow marble #f3c7cf25
<<<ANSWER END>>>
<<<ANSWER key=K00074>>>
fathom verdant quartz glacier lattice saffron trellis orbit trellis meadow boulder vellum auburn cobalt crimson orbit lantern thistle cedar ember orbit fathom cobalt willow #ee5c818f
<<<ANSWER END>>>
<<<ANSWER key=K01814>>>
falcon garnet thistle pewter trellis meadow falcon onyx indigo lantern russet crimson glacier cedar quartz zebra russet trellis russet russet cobalt meadow falcon pewter #c7285d15
<<<ANSWER END>>>
<<<ANSWER key=K01257>>>
vellum quartz fathom cobble vellum onyx auburn falcon falcon indigo mistral crimson thistle lattice spruce thistle falcon cobalt glacier copper cobble meadow ember mistral #0fbfa565
<<<ANSWER END>>>
<<<ANSWER key=K01211>>>
onyx willow russet cinder willow garnet spruce fathom boulder ember vellum boulder saffron cobble thistle ember cobalt vellum falcon saffron russet verdant indigo fathom #89459f2b
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
