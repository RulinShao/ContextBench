#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K01119>>>
orbit orbit kindle trellis indigo trellis cinder orbit saffron zebra mistral orbit quartz falcon kindle onyx thistle cobalt falcon crimson pewter kindle ember zebra #92aef8a1
<<<ANSWER END>>>
<<<ANSWER key=K01711>>>
boulder willow falcon vellum falcon kindle quartz glacier glacier cedar meadow harbor onyx cinder trellis quartz auburn pewter auburn indigo glacier garnet russet verdant #8af49f7a
<<<ANSWER END>>>
<<<ANSWER key=K01441>>>
saffron ember trellis harbor thistle saffron lattice orbit verdant indigo marble harbor vellum lantern spruce falcon verdant spruce willow cinder indigo copper willow cobalt #ca7e176f
<<<ANSWER END>>>
<<<ANSWER key=K00495>>>
cobble onyx meadow harbor cinder lantern cobalt cobble zebra glacier willow cobalt trellis cedar glacier thistle glacier lantern kindle indigo lattice cinder zebra vellum #e6ccef52
<<<ANSWER END>>>
<<<ANSWER key=K01159>>>
verdant auburn lantern lantern indigo willow crimson thistle saffron vellum copper harbor zebra saffron willow zebra thistle pewter cedar willow russet onyx spruce nimbus #73266665
<<<ANSWER END>>>
<<<ANSWER key=K01065>>>
boulder thistle nimbus indigo garnet indigo zebra cedar spruce meadow falcon trellis mistral thistle meadow verdant vellum trellis nimbus cobalt saffron indigo nimbus saffron #5f8858d8
<<<ANSWER END>>>
<<<ANSWER key=K00641>>>
glacier spruce trellis lattice trellis mistral auburn mistral boulder trellis marble meadow willow mistral glacier cobble glacier orbit garnet cobalt auburn trellis mistral cobble #2a1d9691
<<<ANSWER END>>>
<<<ANSWER key=K01632>>>
nimbus harbor cinder thistle copper saffron kindle onyx ember cobble lantern orbit ember onyx harbor trellis saffron vellum ember fathom cobalt willow russet trellis #28a1b93b
<<<ANSWER END>>>
<<<ANSWER key=K01771>>>
cinder harbor cedar thistle fathom saffron harbor trellis mistral glacier fathom ember trellis mistral thistle zebra boulder zebra crimson trellis onyx pewter thistle trellis #85849347
<<<ANSWER END>>>
<<<ANSWER key=K01399>>>
mistral vellum verdant glacier boulder auburn onyx orbit thistle indigo kindle kindle boulder crimson meadow meadow mistral willow lantern verdant marble cedar onyx cobalt #3e59f24c
<<<ANSWER END>>>
<<<ANSWER key=K00954>>>
pewter fathom willow quartz pewter quartz cobble harbor verdant pewter crimson quartz cobble harbor ember zebra quartz indigo thistle lattice verdant auburn mistral boulder #4b4de23e
<<<ANSWER END>>>
<<<ANSWER key=K01003>>>
spruce spruce copper onyx lattice lantern cobalt harbor marble cedar zebra auburn ember saffron harbor pewter nimbus meadow trellis verdant kindle auburn crimson onyx #9d3a1cb7
<<<ANSWER END>>>
<<<ANSWER key=K00154>>>
saffron indigo copper indigo willow auburn fathom pewter mistral lantern spruce kindle ember vellum kindle zebra indigo saffron thistle fathom vellum marble kindle meadow #8dfa135a
<<<ANSWER END>>>
<<<ANSWER key=K00930>>>
zebra lantern onyx marble thistle glacier thistle kindle cobble kindle fathom vellum fathom falcon falcon spruce spruce verdant trellis indigo pewter zebra falcon zebra #c2eb8b4d
<<<ANSWER END>>>
<<<ANSWER key=K00129>>>
crimson kindle willow zebra russet cinder nimbus kindle indigo ember trellis saffron marble kindle thistle auburn zebra fathom marble zebra verdant falcon orbit crimson #ad3c01c9
<<<ANSWER END>>>
<<<ANSWER key=K00276>>>
kindle cobalt meadow kindle mistral falcon cobble boulder quartz garnet zebra saffron mistral meadow fathom kindle crimson lantern orbit orbit copper marble cobalt lantern #51c56855
<<<ANSWER END>>>
<<<ANSWER key=K01207>>>
mistral lattice meadow ember falcon indigo pewter orbit spruce auburn verdant onyx glacier thistle saffron boulder pewter copper vellum cobalt pewter spruce cobble garnet #281c31e3
<<<ANSWER END>>>
<<<ANSWER key=K00679>>>
willow cedar fathom meadow nimbus onyx garnet indigo copper onyx orbit auburn vellum orbit lattice orbit mistral cedar copper willow fathom meadow falcon garnet #7bb5a890
<<<ANSWER END>>>
<<<ANSWER key=K00856>>>
boulder indigo indigo spruce indigo copper quartz saffron marble lattice pewter ember zebra cobble quartz garnet verdant lattice russet garnet zebra falcon copper thistle #6dab0657
<<<ANSWER END>>>
<<<ANSWER key=K00521>>>
saffron trellis pewter willow fathom fathom zebra pewter quartz garnet cobalt spruce vellum thistle orbit meadow copper thistle saffron cobble spruce glacier spruce verdant #252b1cfb
<<<ANSWER END>>>
<<<ANSWER key=K00932>>>
ember cobble glacier garnet garnet thistle kindle glacier indigo crimson lantern kindle harbor fathom harbor ember russet cinder pewter glacier boulder quartz vellum crimson #9b060f72
<<<ANSWER END>>>
<<<ANSWER key=K00262>>>
cedar fathom marble lantern harbor auburn cobalt cobble verdant ember mistral lantern copper garnet boulder pewter pewter glacier onyx trellis cinder auburn willow harbor #17e3f175
<<<ANSWER END>>>
<<<ANSWER key=K00064>>>
marble indigo pewter willow mistral onyx harbor onyx zebra pewter vellum vellum indigo saffron willow cobble auburn orbit indigo cobble willow marble nimbus lattice #cc3c09c0
<<<ANSWER END>>>
<<<ANSWER key=K01514>>>
thistle boulder crimson boulder meadow thistle crimson verdant lantern cobble nimbus lattice lattice zebra meadow zebra copper fathom lattice boulder orbit auburn cedar zebra #2f2ad6be
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
