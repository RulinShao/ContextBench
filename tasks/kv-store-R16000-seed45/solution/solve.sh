#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K06155>>>
verdant cedar fathom vellum copper glacier verdant onyx pewter cedar garnet fathom crimson trellis thistle marble cobble auburn indigo lantern thistle falcon orbit quartz #22819ea6
<<<ANSWER END>>>
<<<ANSWER key=K08184>>>
auburn cinder copper marble onyx meadow russet falcon nimbus mistral lattice spruce orbit pewter indigo lattice cobalt ember copper indigo cobalt pewter indigo falcon #8ece3b5e
<<<ANSWER END>>>
<<<ANSWER key=K10931>>>
verdant trellis cobble lantern cobalt crimson marble auburn fathom thistle willow onyx pewter trellis meadow russet meadow nimbus mistral spruce russet boulder saffron pewter #4929c74a
<<<ANSWER END>>>
<<<ANSWER key=K15143>>>
falcon mistral nimbus trellis ember boulder copper cedar pewter harbor onyx zebra nimbus cedar falcon orbit quartz copper glacier kindle orbit russet cobalt pewter #89b911b5
<<<ANSWER END>>>
<<<ANSWER key=K14012>>>
saffron cedar zebra lattice marble cedar quartz quartz quartz falcon nimbus vellum quartz russet thistle falcon orbit fathom harbor meadow quartz indigo cobalt onyx #a47610f5
<<<ANSWER END>>>
<<<ANSWER key=K06895>>>
spruce pewter falcon auburn lattice copper lattice falcon garnet glacier ember saffron glacier cobble glacier auburn orbit cedar spruce harbor nimbus garnet glacier verdant #0a5abe06
<<<ANSWER END>>>
<<<ANSWER key=K00646>>>
glacier nimbus meadow boulder russet kindle willow fathom indigo lantern pewter meadow cobble indigo saffron verdant russet auburn ember thistle zebra saffron copper lantern #cad51eea
<<<ANSWER END>>>
<<<ANSWER key=K04517>>>
onyx meadow lantern thistle fathom mistral trellis crimson auburn verdant indigo trellis trellis meadow lattice saffron orbit indigo garnet verdant harbor lattice russet crimson #77a6313d
<<<ANSWER END>>>
<<<ANSWER key=K01461>>>
cobble meadow cobalt crimson auburn cobble thistle glacier lantern onyx trellis kindle verdant trellis glacier thistle lattice marble trellis fathom harbor cobalt lantern trellis #206e8272
<<<ANSWER END>>>
<<<ANSWER key=K08813>>>
copper lantern thistle copper zebra russet meadow quartz verdant copper copper lattice meadow cobble marble pewter copper pewter spruce pewter harbor spruce indigo lattice #c2da69cf
<<<ANSWER END>>>
<<<ANSWER key=K02147>>>
quartz meadow russet cedar marble meadow lantern saffron ember mistral ember spruce auburn garnet mistral meadow marble onyx falcon marble garnet garnet kindle cedar #86c670a9
<<<ANSWER END>>>
<<<ANSWER key=K15645>>>
lattice verdant kindle boulder crimson cinder cedar spruce glacier fathom trellis cobble kindle pewter spruce spruce cinder harbor marble harbor harbor ember lantern garnet #4d5a243e
<<<ANSWER END>>>
<<<ANSWER key=K00082>>>
onyx nimbus zebra thistle saffron fathom zebra vellum copper auburn indigo thistle zebra thistle orbit falcon ember cobalt harbor zebra onyx vellum crimson kindle #8aff8f2a
<<<ANSWER END>>>
<<<ANSWER key=K15384>>>
kindle quartz vellum garnet saffron russet garnet cinder harbor verdant crimson cedar spruce spruce boulder crimson mistral verdant quartz auburn lattice quartz willow saffron #19aa9e88
<<<ANSWER END>>>
<<<ANSWER key=K11759>>>
boulder verdant cobalt auburn copper indigo spruce zebra indigo vellum cobble marble ember marble willow cobble crimson cinder glacier marble cobalt pewter orbit nimbus #3bf6b278
<<<ANSWER END>>>
<<<ANSWER key=K13220>>>
vellum mistral falcon mistral onyx kindle harbor fathom pewter marble onyx vellum cinder zebra harbor lantern cinder falcon pewter kindle meadow nimbus meadow ember #1ec5f3f3
<<<ANSWER END>>>
<<<ANSWER key=K14374>>>
onyx trellis crimson ember nimbus saffron onyx vellum zebra falcon russet falcon lattice pewter glacier falcon marble quartz saffron lantern ember fathom garnet russet #06ba2f30
<<<ANSWER END>>>
<<<ANSWER key=K08069>>>
falcon garnet crimson pewter willow cinder meadow trellis cinder pewter copper trellis verdant willow boulder trellis willow marble nimbus thistle cedar ember lattice vellum #7e2f5a4b
<<<ANSWER END>>>
<<<ANSWER key=K12544>>>
mistral cobalt cinder meadow russet indigo orbit saffron verdant pewter marble falcon verdant cobble nimbus thistle meadow pewter nimbus orbit willow falcon thistle quartz #673897e5
<<<ANSWER END>>>
<<<ANSWER key=K00385>>>
orbit mistral spruce lattice pewter onyx trellis willow thistle auburn marble willow verdant willow cobble kindle kindle copper crimson pewter glacier auburn crimson zebra #38f17350
<<<ANSWER END>>>
<<<ANSWER key=K04977>>>
spruce harbor spruce lattice zebra zebra boulder vellum saffron russet onyx spruce cedar verdant spruce kindle saffron lantern cinder lantern glacier verdant willow verdant #bef72645
<<<ANSWER END>>>
<<<ANSWER key=K00322>>>
lattice thistle cobble auburn cinder indigo indigo cobalt onyx falcon glacier harbor cedar crimson glacier copper quartz garnet onyx auburn lantern trellis vellum boulder #f91a05bf
<<<ANSWER END>>>
<<<ANSWER key=K14921>>>
meadow boulder falcon cobalt fathom thistle spruce falcon orbit ember glacier auburn indigo verdant onyx pewter cinder russet nimbus crimson harbor orbit cinder zebra #de02d95b
<<<ANSWER END>>>
<<<ANSWER key=K11271>>>
harbor mistral fathom indigo kindle vellum thistle vellum meadow mistral verdant marble spruce garnet zebra lattice marble nimbus lantern orbit verdant boulder cobalt meadow #32708e11
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
