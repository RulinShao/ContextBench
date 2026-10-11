#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K07132>>>
verdant cinder kindle trellis meadow orbit trellis kindle cobalt meadow lattice quartz vellum fathom mistral harbor trellis saffron cobble fathom quartz trellis garnet nimbus #65457446
<<<ANSWER END>>>
<<<ANSWER key=K14722>>>
ember cobalt thistle kindle falcon zebra marble indigo harbor cobalt vellum cedar falcon garnet glacier onyx falcon cobalt boulder falcon lattice willow willow pewter #ff2238d0
<<<ANSWER END>>>
<<<ANSWER key=K15298>>>
lattice cedar nimbus saffron garnet auburn ember cinder cinder cobble nimbus indigo mistral vellum auburn zebra trellis cinder trellis meadow boulder boulder boulder boulder #cfd0d7f8
<<<ANSWER END>>>
<<<ANSWER key=K08775>>>
ember marble meadow copper lantern lattice falcon lattice cedar ember nimbus mistral russet meadow harbor cobble falcon spruce cinder ember trellis cinder garnet harbor #77921bb1
<<<ANSWER END>>>
<<<ANSWER key=K05288>>>
lattice spruce falcon zebra zebra glacier saffron marble vellum pewter lattice orbit vellum ember quartz willow harbor ember verdant ember falcon ember copper russet #c97a9aa5
<<<ANSWER END>>>
<<<ANSWER key=K14376>>>
orbit garnet pewter spruce fathom glacier garnet trellis meadow onyx zebra ember cinder glacier trellis nimbus fathom nimbus indigo cinder cobalt auburn cobble garnet #110534d5
<<<ANSWER END>>>
<<<ANSWER key=K11040>>>
trellis ember cobalt lattice crimson saffron harbor quartz onyx cobble kindle crimson lattice vellum zebra saffron cobalt pewter willow willow boulder cinder russet fathom #fb329682
<<<ANSWER END>>>
<<<ANSWER key=K06564>>>
thistle verdant fathom lattice auburn cobble onyx glacier mistral kindle boulder cobalt onyx trellis lantern copper cobble thistle orbit harbor willow harbor nimbus meadow #661e0d31
<<<ANSWER END>>>
<<<ANSWER key=K11459>>>
indigo boulder cobble cobble ember meadow lantern quartz orbit marble lantern boulder onyx meadow auburn willow cedar falcon glacier thistle verdant saffron lattice cedar #7bfcc009
<<<ANSWER END>>>
<<<ANSWER key=K11384>>>
cobble cinder nimbus orbit lantern pewter pewter harbor glacier vellum onyx lantern spruce cedar copper boulder falcon pewter kindle nimbus kindle verdant garnet lattice #3df22762
<<<ANSWER END>>>
<<<ANSWER key=K13305>>>
lantern cinder cobble russet thistle nimbus harbor quartz willow lattice indigo garnet cedar zebra auburn mistral spruce saffron fathom trellis crimson crimson orbit cedar #3561a9fd
<<<ANSWER END>>>
<<<ANSWER key=K08024>>>
nimbus cobalt vellum ember boulder orbit onyx glacier marble mistral cinder thistle lantern harbor saffron kindle vellum falcon cinder orbit garnet cinder lattice zebra #e5d38fbe
<<<ANSWER END>>>
<<<ANSWER key=K14008>>>
harbor mistral verdant trellis fathom fathom zebra russet copper willow falcon crimson pewter willow vellum cobble verdant copper cobalt meadow glacier pewter fathom vellum #eb1e8610
<<<ANSWER END>>>
<<<ANSWER key=K02638>>>
lantern thistle ember indigo willow lattice thistle garnet orbit fathom harbor meadow ember mistral saffron cinder lattice fathom cobble crimson meadow harbor indigo indigo #b02c858c
<<<ANSWER END>>>
<<<ANSWER key=K07275>>>
verdant orbit mistral garnet pewter marble pewter spruce vellum meadow copper orbit lantern crimson garnet onyx lattice fathom quartz cinder spruce lattice boulder orbit #d6e9e685
<<<ANSWER END>>>
<<<ANSWER key=K09196>>>
thistle onyx glacier cinder cedar kindle saffron lantern boulder mistral cobble russet verdant trellis vellum cobalt lattice willow marble meadow kindle mistral falcon orbit #4d0b7aae
<<<ANSWER END>>>
<<<ANSWER key=K10318>>>
marble indigo boulder ember lattice cinder spruce vellum zebra indigo verdant onyx auburn lattice glacier indigo vellum copper thistle spruce russet nimbus mistral mistral #d44b4033
<<<ANSWER END>>>
<<<ANSWER key=K01804>>>
cobble kindle mistral vellum harbor trellis orbit zebra meadow mistral thistle fathom cinder orbit harbor pewter nimbus auburn falcon kindle glacier harbor fathom harbor #0abc9973
<<<ANSWER END>>>
<<<ANSWER key=K02608>>>
fathom quartz cobalt harbor mistral cobalt boulder lantern russet quartz onyx lantern cinder pewter spruce saffron mistral lantern auburn trellis falcon vellum garnet auburn #8cbfd60a
<<<ANSWER END>>>
<<<ANSWER key=K09100>>>
fathom vellum russet boulder quartz russet copper verdant onyx copper saffron fathom mistral auburn trellis boulder fathom vellum harbor boulder nimbus onyx fathom meadow #09c83e82
<<<ANSWER END>>>
<<<ANSWER key=K06202>>>
falcon falcon saffron trellis vellum quartz copper verdant cobble saffron crimson onyx vellum lantern vellum kindle glacier cobalt saffron verdant copper spruce auburn garnet #e1af46c0
<<<ANSWER END>>>
<<<ANSWER key=K04069>>>
falcon glacier copper falcon boulder willow harbor onyx lattice indigo cobble saffron spruce willow zebra onyx orbit pewter onyx quartz lantern cedar auburn quartz #5b19b657
<<<ANSWER END>>>
<<<ANSWER key=K13944>>>
glacier verdant meadow vellum harbor willow saffron mistral glacier verdant meadow lattice ember meadow copper zebra harbor onyx cobalt nimbus garnet meadow marble cobble #1c445c2d
<<<ANSWER END>>>
<<<ANSWER key=K13373>>>
orbit garnet ember trellis boulder falcon ember meadow copper spruce indigo quartz indigo harbor trellis willow copper copper pewter thistle zebra willow cobalt cobalt #7c6bd8d0
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
