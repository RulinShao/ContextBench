#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K08654>>>
onyx ember lantern cobble nimbus kindle meadow marble cinder fathom ember cobble copper lantern fathom boulder kindle cobalt cobble trellis cobalt trellis willow vellum #5d5d2c00
<<<ANSWER END>>>
<<<ANSWER key=K06985>>>
copper willow cinder pewter falcon garnet quartz lattice lantern fathom cinder cedar glacier indigo indigo cobble trellis saffron meadow nimbus mistral auburn kindle garnet #73cd73b9
<<<ANSWER END>>>
<<<ANSWER key=K13430>>>
vellum thistle meadow zebra willow vellum fathom quartz glacier onyx vellum russet kindle copper mistral harbor pewter copper cedar zebra kindle auburn onyx zebra #6ec4d1eb
<<<ANSWER END>>>
<<<ANSWER key=K10894>>>
saffron marble russet marble boulder ember cedar zebra garnet thistle auburn vellum cedar onyx meadow auburn zebra quartz russet cinder fathom russet thistle cedar #c7378478
<<<ANSWER END>>>
<<<ANSWER key=K09454>>>
glacier vellum pewter trellis mistral ember kindle fathom indigo glacier russet marble saffron fathom thistle nimbus harbor cobalt garnet marble pewter onyx saffron orbit #c1397565
<<<ANSWER END>>>
<<<ANSWER key=K14115>>>
glacier auburn nimbus orbit cinder zebra nimbus copper quartz garnet cobble boulder cobble pewter quartz orbit kindle mistral boulder verdant trellis fathom fathom lattice #8eb3810e
<<<ANSWER END>>>
<<<ANSWER key=K09114>>>
kindle vellum ember boulder boulder fathom nimbus auburn harbor indigo indigo indigo vellum ember lantern cobalt nimbus falcon willow orbit harbor marble cobble cobalt #c0d6e059
<<<ANSWER END>>>
<<<ANSWER key=K10724>>>
nimbus russet marble meadow quartz glacier russet orbit cinder trellis willow crimson falcon marble cinder fathom verdant garnet auburn ember harbor fathom cobalt lattice #22a83893
<<<ANSWER END>>>
<<<ANSWER key=K14592>>>
auburn verdant auburn orbit ember willow marble vellum lattice harbor orbit spruce spruce zebra nimbus ember trellis garnet marble vellum cedar lattice pewter nimbus #1884812f
<<<ANSWER END>>>
<<<ANSWER key=K05205>>>
fathom pewter russet auburn trellis quartz falcon fathom meadow onyx cinder russet cobalt glacier marble orbit spruce copper fathom thistle indigo vellum boulder marble #8aeeaee2
<<<ANSWER END>>>
<<<ANSWER key=K15034>>>
falcon pewter fathom glacier garnet nimbus kindle verdant lattice garnet nimbus boulder meadow boulder cobalt cobalt quartz meadow orbit willow spruce lantern trellis quartz #158733db
<<<ANSWER END>>>
<<<ANSWER key=K08289>>>
spruce onyx thistle indigo verdant thistle kindle garnet auburn fathom ember boulder auburn glacier indigo cobalt cobble garnet meadow fathom vellum crimson pewter spruce #6b0677e3
<<<ANSWER END>>>
<<<ANSWER key=K08871>>>
zebra spruce onyx cobble quartz nimbus crimson crimson harbor zebra saffron trellis pewter thistle cedar copper cedar onyx cobble willow vellum willow cedar cinder #601dbd96
<<<ANSWER END>>>
<<<ANSWER key=K04702>>>
auburn harbor indigo crimson falcon cobalt orbit auburn marble fathom vellum russet saffron trellis ember marble mistral zebra lattice falcon cinder lantern cinder garnet #280bde9e
<<<ANSWER END>>>
<<<ANSWER key=K02700>>>
glacier kindle fathom thistle russet onyx lattice saffron onyx pewter lattice fathom fathom falcon saffron cobalt garnet marble pewter quartz garnet saffron thistle cedar #ff402078
<<<ANSWER END>>>
<<<ANSWER key=K11227>>>
copper auburn mistral verdant willow spruce harbor fathom orbit trellis pewter lattice harbor kindle lantern falcon nimbus spruce cinder fathom harbor glacier orbit spruce #e45d7a21
<<<ANSWER END>>>
<<<ANSWER key=K15641>>>
cobalt ember zebra fathom willow ember boulder nimbus falcon saffron mistral cobalt cinder boulder verdant russet verdant mistral onyx auburn orbit lattice garnet lantern #d2a6adfd
<<<ANSWER END>>>
<<<ANSWER key=K04870>>>
trellis zebra quartz lantern cedar glacier cobble boulder meadow russet thistle lantern glacier nimbus falcon spruce falcon trellis indigo crimson spruce quartz lattice pewter #586772fb
<<<ANSWER END>>>
<<<ANSWER key=K04628>>>
copper spruce indigo lantern cobalt nimbus cobble cobble crimson spruce crimson glacier cobble nimbus cobalt onyx onyx verdant marble lantern harbor cedar cedar trellis #79b3d3c8
<<<ANSWER END>>>
<<<ANSWER key=K15679>>>
crimson copper cedar willow indigo verdant marble kindle fathom onyx lantern pewter russet quartz quartz lattice boulder thistle cobalt kindle copper willow spruce vellum #7f45f6c8
<<<ANSWER END>>>
<<<ANSWER key=K07103>>>
harbor verdant crimson fathom kindle thistle marble russet onyx cobble lattice copper glacier auburn zebra zebra glacier ember lantern cobalt willow lantern marble orbit #f1dd1cf1
<<<ANSWER END>>>
<<<ANSWER key=K14718>>>
cobble marble harbor quartz quartz zebra verdant crimson orbit cinder orbit harbor verdant cinder boulder indigo auburn willow nimbus crimson ember fathom onyx vellum #8b449b76
<<<ANSWER END>>>
<<<ANSWER key=K03644>>>
cobalt pewter boulder spruce boulder harbor auburn glacier willow lantern lantern cobble mistral spruce quartz thistle saffron marble garnet indigo boulder lattice zebra harbor #c16c49d4
<<<ANSWER END>>>
<<<ANSWER key=K02545>>>
russet garnet garnet thistle falcon crimson lantern spruce russet lantern ember pewter harbor cobble zebra mistral garnet crimson russet auburn zebra spruce boulder verdant #81884d29
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
