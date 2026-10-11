#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00428>>>
auburn cobalt mistral willow glacier cinder pewter crimson verdant marble falcon ember quartz quartz meadow mistral glacier mistral russet fathom lantern russet onyx meadow #f2d3d296
<<<ANSWER END>>>
<<<ANSWER key=K00746>>>
trellis orbit copper lantern marble russet meadow crimson marble orbit glacier saffron lantern glacier spruce garnet garnet falcon kindle auburn verdant pewter cinder thistle #e3cabb88
<<<ANSWER END>>>
<<<ANSWER key=K00294>>>
willow nimbus meadow fathom falcon nimbus copper cinder thistle marble orbit glacier harbor falcon kindle quartz marble marble fathom ember crimson orbit meadow onyx #b5024721
<<<ANSWER END>>>
<<<ANSWER key=K00243>>>
falcon saffron boulder cobble lantern saffron spruce marble marble harbor falcon crimson copper quartz quartz falcon spruce cobble saffron glacier auburn lattice quartz mistral #cbe9046f
<<<ANSWER END>>>
<<<ANSWER key=K00361>>>
cobalt saffron cobalt nimbus glacier russet ember cinder mistral mistral verdant lattice glacier cobble crimson cobble saffron fathom garnet trellis copper crimson lattice pewter #ac989f1f
<<<ANSWER END>>>
<<<ANSWER key=K00220>>>
garnet quartz cobble crimson falcon pewter russet lattice verdant copper cobalt marble meadow thistle willow marble thistle russet falcon russet lantern marble saffron lantern #f7215688
<<<ANSWER END>>>
<<<ANSWER key=K00053>>>
saffron garnet falcon russet nimbus onyx auburn cedar zebra glacier zebra falcon meadow ember saffron falcon russet vellum quartz thistle lantern verdant boulder zebra #c72d4e23
<<<ANSWER END>>>
<<<ANSWER key=K00148>>>
lantern crimson ember mistral trellis glacier lattice quartz indigo orbit pewter cinder orbit saffron trellis crimson harbor mistral indigo quartz willow spruce cedar garnet #5d22ab84
<<<ANSWER END>>>
<<<ANSWER key=K00249>>>
saffron verdant falcon auburn copper cedar quartz glacier pewter ember mistral cedar willow pewter cinder indigo spruce willow auburn glacier auburn russet nimbus fathom #8b065c74
<<<ANSWER END>>>
<<<ANSWER key=K00770>>>
meadow trellis russet indigo saffron cinder meadow nimbus cinder glacier cinder fathom kindle vellum quartz zebra indigo glacier auburn saffron saffron crimson auburn onyx #f3da1fb9
<<<ANSWER END>>>
<<<ANSWER key=K00280>>>
crimson zebra glacier fathom cobalt cinder glacier trellis garnet saffron harbor orbit crimson boulder cedar onyx crimson onyx zebra copper crimson auburn zebra harbor #302a1481
<<<ANSWER END>>>
<<<ANSWER key=K00133>>>
verdant marble willow copper ember quartz cinder verdant indigo fathom russet vellum cinder vellum garnet fathom indigo harbor marble quartz spruce fathom quartz quartz #dfda3895
<<<ANSWER END>>>
<<<ANSWER key=K00399>>>
glacier garnet cinder copper boulder lantern auburn vellum falcon thistle lattice thistle saffron falcon willow zebra cobble zebra onyx indigo lattice willow lattice lattice #c66150f5
<<<ANSWER END>>>
<<<ANSWER key=K00497>>>
vellum cobble copper meadow meadow onyx harbor ember russet verdant cedar saffron pewter auburn boulder kindle mistral cobble falcon marble willow marble onyx orbit #94834794
<<<ANSWER END>>>
<<<ANSWER key=K00778>>>
cedar meadow falcon auburn zebra marble kindle willow cedar copper harbor russet russet lattice thistle quartz ember russet verdant cobble mistral kindle saffron russet #823bfa5e
<<<ANSWER END>>>
<<<ANSWER key=K00244>>>
auburn auburn crimson harbor verdant zebra quartz cobble saffron quartz cobble crimson verdant meadow verdant harbor thistle falcon marble copper verdant kindle willow zebra #264022a4
<<<ANSWER END>>>
<<<ANSWER key=K00552>>>
zebra mistral copper onyx trellis crimson saffron cedar cobble crimson quartz fathom indigo cedar boulder marble pewter lattice lattice cedar quartz trellis spruce vellum #99436268
<<<ANSWER END>>>
<<<ANSWER key=K00823>>>
orbit boulder lattice verdant glacier saffron zebra lantern ember nimbus fathom russet verdant onyx spruce crimson ember meadow cinder saffron cinder cobalt lattice russet #1b54282e
<<<ANSWER END>>>
<<<ANSWER key=K00582>>>
garnet copper lantern saffron garnet harbor vellum marble russet vellum cinder fathom verdant meadow nimbus ember spruce cedar saffron zebra mistral auburn auburn zebra #ebe02429
<<<ANSWER END>>>
<<<ANSWER key=K00959>>>
trellis thistle thistle willow russet verdant nimbus trellis pewter indigo mistral quartz harbor copper indigo verdant orbit spruce cobalt mistral vellum zebra ember nimbus #2a8b8d1e
<<<ANSWER END>>>
<<<ANSWER key=K00968>>>
crimson pewter ember zebra saffron glacier ember thistle verdant thistle spruce lantern cinder cinder mistral fathom ember ember garnet spruce cinder glacier thistle vellum #41b4f686
<<<ANSWER END>>>
<<<ANSWER key=K00535>>>
lantern russet zebra willow willow ember thistle zebra thistle ember harbor garnet verdant orbit cobalt zebra lantern russet orbit meadow pewter indigo nimbus copper #5ca17416
<<<ANSWER END>>>
<<<ANSWER key=K00887>>>
harbor cobalt mistral copper spruce cedar spruce auburn marble russet lattice trellis kindle verdant auburn kindle lantern trellis cobalt russet lattice cedar verdant glacier #164c0ad0
<<<ANSWER END>>>
<<<ANSWER key=K00295>>>
boulder glacier quartz meadow indigo pewter auburn quartz saffron lantern cobble russet falcon saffron lantern falcon auburn saffron cinder onyx lattice trellis spruce pewter #957a7f8f
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
