#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00705>>>
cinder lattice glacier boulder nimbus fathom quartz trellis ember cobalt cinder verdant crimson quartz lantern zebra zebra willow trellis lattice marble marble meadow falcon #f7afbdad
<<<ANSWER END>>>
<<<ANSWER key=K00234>>>
garnet harbor boulder copper quartz fathom thistle spruce thistle glacier meadow trellis mistral garnet spruce onyx falcon falcon harbor russet auburn meadow verdant pewter #4a8c43e7
<<<ANSWER END>>>
<<<ANSWER key=K01814>>>
lantern verdant pewter cobble auburn pewter harbor garnet harbor cobble boulder auburn nimbus nimbus spruce fathom russet glacier cedar cobalt meadow copper harbor indigo #fe7fdb47
<<<ANSWER END>>>
<<<ANSWER key=K00395>>>
mistral thistle auburn indigo pewter vellum marble glacier saffron pewter spruce willow vellum marble cinder lattice willow russet cobalt cobble nimbus garnet nimbus nimbus #398b36a4
<<<ANSWER END>>>
<<<ANSWER key=K00925>>>
verdant fathom copper kindle kindle cedar mistral harbor glacier cinder russet quartz spruce nimbus crimson fathom saffron spruce russet quartz harbor lattice trellis pewter #a861a71f
<<<ANSWER END>>>
<<<ANSWER key=K00558>>>
falcon lattice willow falcon cobble cedar spruce zebra copper orbit russet thistle kindle cobalt glacier kindle mistral kindle spruce mistral cedar boulder glacier quartz #217ea118
<<<ANSWER END>>>
<<<ANSWER key=K01349>>>
saffron cobalt russet cinder orbit crimson cedar cobble thistle onyx boulder lattice thistle lantern boulder copper cobble falcon saffron onyx cinder trellis indigo cobble #71aed4e3
<<<ANSWER END>>>
<<<ANSWER key=K01798>>>
cobble saffron orbit trellis cedar cobble cobalt trellis harbor onyx willow russet marble lattice lantern spruce zebra orbit meadow willow cinder onyx boulder auburn #01d83352
<<<ANSWER END>>>
<<<ANSWER key=K00013>>>
verdant pewter indigo fathom cobble indigo orbit cobalt cinder saffron zebra lantern verdant quartz indigo harbor vellum cinder lantern ember meadow willow mistral zebra #c9232651
<<<ANSWER END>>>
<<<ANSWER key=K01596>>>
vellum lantern nimbus auburn auburn falcon fathom harbor lantern russet ember copper trellis cobalt glacier ember marble marble thistle meadow russet fathom onyx orbit #34db0084
<<<ANSWER END>>>
<<<ANSWER key=K00261>>>
ember russet pewter marble glacier copper saffron fathom cinder saffron orbit meadow lattice copper vellum cobble fathom kindle ember russet mistral mistral boulder vellum #4f5e53fb
<<<ANSWER END>>>
<<<ANSWER key=K01088>>>
nimbus harbor marble cedar onyx pewter ember crimson auburn harbor zebra lantern cobble cedar crimson quartz indigo nimbus auburn cinder quartz indigo vellum lattice #b3df9314
<<<ANSWER END>>>
<<<ANSWER key=K01326>>>
crimson cedar indigo crimson cobalt onyx lattice zebra mistral ember meadow cedar onyx indigo crimson falcon saffron kindle indigo saffron cedar russet garnet zebra #35c7eff9
<<<ANSWER END>>>
<<<ANSWER key=K01601>>>
pewter meadow marble indigo cinder glacier orbit nimbus cobble glacier fathom cinder orbit falcon trellis copper auburn cedar falcon pewter mistral willow falcon trellis #e38fb555
<<<ANSWER END>>>
<<<ANSWER key=K00334>>>
willow willow russet trellis verdant boulder lattice lantern kindle willow orbit falcon fathom orbit cinder copper cedar cedar cedar meadow verdant cedar russet garnet #6638919e
<<<ANSWER END>>>
<<<ANSWER key=K00856>>>
harbor lattice cobble verdant copper kindle quartz kindle ember orbit nimbus willow meadow vellum garnet mistral meadow quartz trellis kindle mistral cedar vellum cobalt #80e840c6
<<<ANSWER END>>>
<<<ANSWER key=K01676>>>
quartz nimbus zebra crimson orbit glacier lantern glacier boulder copper ember vellum marble auburn glacier lattice boulder zebra glacier meadow marble saffron trellis nimbus #74b0c605
<<<ANSWER END>>>
<<<ANSWER key=K00729>>>
willow pewter cobble boulder orbit cobble russet saffron falcon marble nimbus glacier cinder nimbus pewter fathom boulder ember vellum lantern meadow indigo harbor cinder #aa9edcc6
<<<ANSWER END>>>
<<<ANSWER key=K01633>>>
willow copper trellis falcon meadow spruce marble meadow glacier fathom trellis onyx saffron russet quartz verdant onyx orbit boulder auburn garnet fathom harbor zebra #63036045
<<<ANSWER END>>>
<<<ANSWER key=K01665>>>
russet orbit verdant lattice trellis kindle zebra russet cobalt nimbus auburn thistle glacier boulder nimbus russet lantern orbit quartz falcon pewter thistle pewter quartz #67bf8986
<<<ANSWER END>>>
<<<ANSWER key=K01320>>>
kindle harbor falcon cinder cobble mistral pewter cobble cedar spruce cedar willow falcon mistral crimson zebra indigo falcon onyx indigo vellum lattice kindle trellis #b9b940e2
<<<ANSWER END>>>
<<<ANSWER key=K01580>>>
lantern zebra pewter harbor russet pewter crimson pewter quartz trellis kindle nimbus vellum trellis auburn pewter glacier quartz marble verdant onyx cobalt ember fathom #12c47b8f
<<<ANSWER END>>>
<<<ANSWER key=K00883>>>
kindle cobalt glacier cobalt lattice indigo verdant fathom willow trellis willow crimson cedar indigo lantern meadow lattice pewter glacier falcon saffron onyx onyx crimson #bfa549d6
<<<ANSWER END>>>
<<<ANSWER key=K01974>>>
ember ember cobalt cinder nimbus russet thistle indigo pewter lattice cedar indigo ember zebra spruce thistle onyx glacier lantern indigo cobble nimbus glacier copper #bf2ec744
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
