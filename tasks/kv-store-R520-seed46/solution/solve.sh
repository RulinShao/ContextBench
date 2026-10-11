#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00170>>>
falcon crimson crimson spruce cobble quartz ember cedar marble mistral lattice lattice russet garnet crimson quartz verdant ember indigo meadow glacier lattice saffron zebra #4a415ca6
<<<ANSWER END>>>
<<<ANSWER key=K00407>>>
russet quartz cobble quartz boulder auburn saffron crimson harbor quartz boulder indigo auburn indigo verdant spruce cedar zebra thistle lattice indigo indigo ember auburn #867bdda1
<<<ANSWER END>>>
<<<ANSWER key=K00091>>>
fathom boulder cobalt lantern boulder harbor meadow pewter zebra spruce crimson cinder nimbus trellis garnet verdant ember falcon verdant willow indigo indigo meadow onyx #b4f64d25
<<<ANSWER END>>>
<<<ANSWER key=K00396>>>
cobble lantern garnet copper harbor saffron falcon pewter thistle mistral indigo russet glacier harbor willow auburn cobalt copper fathom cedar nimbus trellis verdant pewter #d88d4f42
<<<ANSWER END>>>
<<<ANSWER key=K00493>>>
verdant verdant nimbus zebra indigo russet nimbus russet nimbus harbor cedar mistral marble cedar fathom russet zebra spruce cobalt fathom ember onyx ember glacier #481df8b8
<<<ANSWER END>>>
<<<ANSWER key=K00246>>>
nimbus saffron zebra onyx cedar willow nimbus boulder cobble cinder pewter marble quartz auburn garnet harbor willow quartz nimbus glacier cobalt crimson copper fathom #8ce8267f
<<<ANSWER END>>>
<<<ANSWER key=K00444>>>
cobalt glacier nimbus mistral garnet saffron orbit vellum meadow quartz boulder harbor zebra fathom kindle russet meadow spruce harbor verdant pewter fathom marble zebra #13d63074
<<<ANSWER END>>>
<<<ANSWER key=K00504>>>
harbor kindle zebra harbor kindle thistle copper crimson thistle russet cobalt russet quartz auburn boulder saffron harbor vellum cobalt quartz pewter cinder lattice marble #1480bcf8
<<<ANSWER END>>>
<<<ANSWER key=K00161>>>
vellum pewter harbor cinder quartz trellis nimbus ember spruce glacier saffron orbit cobalt mistral spruce spruce saffron nimbus indigo meadow garnet fathom zebra trellis #77ad4f4e
<<<ANSWER END>>>
<<<ANSWER key=K00462>>>
falcon fathom mistral cedar mistral vellum willow lattice crimson boulder onyx saffron verdant zebra fathom vellum falcon fathom orbit willow verdant onyx pewter verdant #339376c2
<<<ANSWER END>>>
<<<ANSWER key=K00395>>>
zebra lantern garnet boulder vellum glacier auburn cobble zebra onyx falcon harbor glacier cobalt boulder quartz pewter spruce boulder lantern glacier lantern mistral mistral #11a14bda
<<<ANSWER END>>>
<<<ANSWER key=K00176>>>
saffron thistle harbor kindle cinder marble vellum indigo mistral ember trellis garnet lattice saffron marble indigo cinder falcon ember auburn glacier trellis trellis spruce #4d00c91a
<<<ANSWER END>>>
<<<ANSWER key=K00200>>>
zebra orbit ember pewter cobble zebra lattice lattice glacier mistral orbit meadow falcon crimson onyx cobble cinder copper orbit cobble falcon crimson kindle vellum #212d94bc
<<<ANSWER END>>>
<<<ANSWER key=K00115>>>
cedar willow thistle cobalt indigo copper orbit meadow marble verdant harbor quartz nimbus garnet spruce cobalt auburn cobalt harbor mistral cedar orbit marble crimson #85b4840f
<<<ANSWER END>>>
<<<ANSWER key=K00485>>>
quartz boulder saffron boulder meadow ember kindle russet cobalt auburn cobble harbor marble ember auburn pewter mistral pewter ember ember orbit boulder lattice auburn #0af02410
<<<ANSWER END>>>
<<<ANSWER key=K00002>>>
glacier meadow boulder ember lattice nimbus lattice kindle harbor mistral cedar meadow spruce thistle verdant nimbus lantern nimbus trellis spruce crimson kindle zebra cedar #ce347bb0
<<<ANSWER END>>>
<<<ANSWER key=K00461>>>
indigo vellum cobble russet cinder willow cobble onyx nimbus crimson fathom spruce vellum willow meadow saffron auburn willow lattice crimson glacier cedar glacier meadow #777f7551
<<<ANSWER END>>>
<<<ANSWER key=K00435>>>
cedar nimbus boulder trellis crimson zebra fathom lantern vellum orbit garnet spruce meadow fathom pewter thistle cedar lantern auburn falcon verdant orbit quartz ember #47150cc3
<<<ANSWER END>>>
<<<ANSWER key=K00482>>>
kindle quartz vellum kindle cobble copper cedar orbit onyx ember lantern lantern garnet willow garnet orbit ember pewter russet mistral mistral glacier mistral meadow #efdcdc19
<<<ANSWER END>>>
<<<ANSWER key=K00459>>>
copper mistral glacier verdant lantern kindle thistle indigo verdant trellis marble cobble onyx copper lantern orbit ember falcon vellum cobble glacier indigo willow glacier #86feccc4
<<<ANSWER END>>>
<<<ANSWER key=K00169>>>
fathom quartz cobalt thistle verdant zebra pewter auburn auburn zebra trellis harbor trellis lattice cobalt cedar zebra cobble copper vellum copper ember crimson garnet #5617bf4a
<<<ANSWER END>>>
<<<ANSWER key=K00106>>>
willow russet orbit auburn pewter vellum lattice verdant cobalt copper boulder russet auburn willow boulder saffron zebra pewter quartz boulder harbor kindle harbor meadow #21eb2e7e
<<<ANSWER END>>>
<<<ANSWER key=K00340>>>
verdant indigo quartz willow pewter russet kindle crimson boulder willow mistral verdant willow zebra boulder indigo marble lattice willow ember lantern fathom quartz zebra #936301c2
<<<ANSWER END>>>
<<<ANSWER key=K00015>>>
cedar boulder harbor vellum ember fathom cobble verdant spruce nimbus cinder saffron cedar verdant glacier thistle marble boulder fathom falcon quartz willow cobble cobble #a258ad53
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
