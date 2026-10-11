#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K03002>>>
quartz zebra crimson harbor willow lantern harbor saffron indigo mistral lattice harbor falcon cobble harbor nimbus spruce lattice cobble zebra russet cedar saffron orbit #6b51434e
<<<ANSWER END>>>
<<<ANSWER key=K13145>>>
cedar harbor indigo lattice auburn lantern boulder lantern thistle ember indigo auburn mistral russet garnet russet quartz zebra indigo kindle cinder willow trellis onyx #6ba7979c
<<<ANSWER END>>>
<<<ANSWER key=K15644>>>
pewter kindle kindle vellum vellum glacier auburn cobble meadow copper meadow harbor falcon meadow crimson cobble garnet cobalt willow zebra saffron fathom verdant vellum #50380c41
<<<ANSWER END>>>
<<<ANSWER key=K00449>>>
quartz kindle crimson pewter copper harbor mistral trellis garnet kindle kindle willow onyx indigo orbit spruce spruce garnet saffron ember copper falcon cobalt fathom #3b72e2cc
<<<ANSWER END>>>
<<<ANSWER key=K15737>>>
nimbus quartz willow onyx saffron cedar indigo boulder glacier onyx cinder pewter cedar crimson russet cinder meadow indigo cobble nimbus thistle russet orbit fathom #fbfeac4b
<<<ANSWER END>>>
<<<ANSWER key=K02253>>>
willow spruce marble zebra verdant russet cobble marble indigo auburn orbit mistral garnet pewter willow crimson thistle auburn falcon spruce quartz cedar cobble spruce #86a9c6e3
<<<ANSWER END>>>
<<<ANSWER key=K07296>>>
marble cobble thistle falcon orbit trellis auburn falcon spruce russet kindle verdant spruce cedar orbit marble willow cedar harbor copper verdant falcon thistle glacier #a7137f02
<<<ANSWER END>>>
<<<ANSWER key=K14394>>>
pewter meadow pewter cobble russet ember vellum garnet fathom onyx vellum willow falcon quartz trellis glacier thistle trellis quartz indigo falcon saffron verdant harbor #f06e021a
<<<ANSWER END>>>
<<<ANSWER key=K00907>>>
crimson garnet russet marble marble meadow willow garnet spruce onyx indigo verdant copper lattice cedar saffron verdant indigo cobble pewter verdant trellis quartz thistle #b6be7d6f
<<<ANSWER END>>>
<<<ANSWER key=K13877>>>
nimbus verdant fathom willow trellis cobble trellis glacier pewter orbit pewter trellis verdant onyx cobble lantern lattice kindle lantern falcon falcon willow onyx trellis #5d5c5dfb
<<<ANSWER END>>>
<<<ANSWER key=K11556>>>
indigo cobalt lantern nimbus pewter saffron falcon falcon mistral saffron meadow harbor onyx russet trellis harbor ember marble indigo garnet cinder thistle saffron cinder #d90fa6b6
<<<ANSWER END>>>
<<<ANSWER key=K14239>>>
saffron boulder ember spruce harbor boulder mistral fathom harbor cobalt cobble garnet cinder willow crimson boulder verdant cedar trellis garnet falcon trellis auburn meadow #5fcdbb3d
<<<ANSWER END>>>
<<<ANSWER key=K05881>>>
lattice saffron falcon indigo nimbus garnet glacier auburn cobble onyx verdant falcon lattice saffron copper vellum glacier crimson trellis marble harbor falcon vellum pewter #d1531673
<<<ANSWER END>>>
<<<ANSWER key=K07857>>>
russet mistral falcon zebra verdant boulder ember fathom kindle ember zebra vellum cobalt vellum willow boulder indigo nimbus meadow mistral indigo pewter crimson lantern #2f57fedc
<<<ANSWER END>>>
<<<ANSWER key=K07896>>>
garnet pewter cobble vellum vellum pewter cobble nimbus cobble boulder willow glacier mistral willow zebra willow orbit cedar meadow russet pewter zebra harbor kindle #27c4446d
<<<ANSWER END>>>
<<<ANSWER key=K08268>>>
saffron garnet trellis cinder cobalt mistral spruce trellis lattice crimson auburn thistle zebra verdant verdant marble spruce cobble spruce vellum cinder garnet cedar vellum #8f6ef7ea
<<<ANSWER END>>>
<<<ANSWER key=K14021>>>
meadow trellis cobble ember falcon harbor mistral marble marble lantern copper willow pewter crimson pewter thistle saffron cobalt willow nimbus verdant boulder fathom marble #a78930aa
<<<ANSWER END>>>
<<<ANSWER key=K05242>>>
copper boulder willow cinder glacier boulder glacier russet spruce garnet garnet kindle kindle boulder auburn cedar marble boulder zebra cedar boulder garnet cedar harbor #9920674a
<<<ANSWER END>>>
<<<ANSWER key=K01322>>>
kindle thistle kindle spruce spruce russet garnet willow falcon mistral cinder zebra indigo verdant verdant willow meadow cedar russet falcon nimbus fathom indigo copper #36652b74
<<<ANSWER END>>>
<<<ANSWER key=K12364>>>
cobalt saffron saffron marble onyx indigo garnet verdant mistral meadow copper pewter ember cedar kindle pewter glacier mistral zebra russet marble vellum quartz willow #18cec3b6
<<<ANSWER END>>>
<<<ANSWER key=K01862>>>
lattice cobalt willow willow auburn meadow onyx ember copper harbor kindle indigo quartz russet fathom thistle lantern spruce willow lantern lantern crimson fathom lantern #d4657cad
<<<ANSWER END>>>
<<<ANSWER key=K15982>>>
auburn vellum saffron zebra fathom willow glacier lantern fathom kindle marble copper fathom lantern onyx vellum harbor crimson cedar spruce garnet auburn crimson quartz #a701d645
<<<ANSWER END>>>
<<<ANSWER key=K02197>>>
quartz russet copper fathom marble lantern pewter crimson orbit cinder cinder vellum cedar auburn trellis saffron willow cobble cinder fathom cedar glacier saffron mistral #7688e968
<<<ANSWER END>>>
<<<ANSWER key=K00049>>>
willow saffron lattice willow verdant mistral lattice quartz willow cinder onyx glacier nimbus auburn crimson thistle cinder harbor meadow thistle quartz thistle meadow pewter #eddaf9c7
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
