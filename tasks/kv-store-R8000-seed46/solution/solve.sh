#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K02332>>>
cobalt boulder willow lattice nimbus glacier cobble lattice harbor trellis ember lantern willow saffron vellum thistle saffron vellum ember russet spruce lattice cobalt cinder #c6f9e638
<<<ANSWER END>>>
<<<ANSWER key=K06719>>>
copper fathom trellis orbit meadow marble cobalt willow meadow russet meadow spruce copper boulder orbit ember trellis cobble crimson cinder falcon nimbus vellum boulder #3b698589
<<<ANSWER END>>>
<<<ANSWER key=K07750>>>
verdant ember russet spruce orbit onyx orbit thistle trellis zebra fathom thistle meadow orbit glacier falcon cobalt zebra lattice spruce cobble saffron vellum fathom #9a4736aa
<<<ANSWER END>>>
<<<ANSWER key=K03581>>>
nimbus spruce orbit auburn saffron thistle indigo glacier marble verdant falcon boulder nimbus mistral zebra crimson cedar zebra trellis orbit lattice kindle verdant meadow #f1fa6525
<<<ANSWER END>>>
<<<ANSWER key=K03288>>>
crimson lantern auburn ember cinder verdant cobble cinder saffron auburn trellis trellis copper cedar kindle meadow glacier onyx trellis crimson nimbus verdant onyx quartz #782a8247
<<<ANSWER END>>>
<<<ANSWER key=K00284>>>
mistral kindle marble orbit thistle meadow indigo auburn ember spruce glacier marble meadow lattice quartz cobalt marble lattice pewter willow lattice indigo fathom onyx #2e96da9e
<<<ANSWER END>>>
<<<ANSWER key=K06432>>>
trellis onyx auburn falcon falcon nimbus fathom spruce nimbus lantern russet auburn copper trellis spruce zebra auburn onyx zebra indigo russet trellis falcon indigo #38825019
<<<ANSWER END>>>
<<<ANSWER key=K00286>>>
boulder ember kindle meadow lattice fathom copper cinder glacier cinder pewter lattice vellum harbor lantern pewter harbor lantern indigo lantern crimson falcon cedar glacier #56d10987
<<<ANSWER END>>>
<<<ANSWER key=K04925>>>
indigo onyx cobalt copper fathom glacier meadow glacier fathom glacier cobble falcon auburn mistral orbit indigo lattice garnet quartz fathom thistle cobalt crimson cobalt #faca91da
<<<ANSWER END>>>
<<<ANSWER key=K01841>>>
meadow auburn orbit spruce thistle saffron spruce pewter willow thistle orbit crimson nimbus orbit vellum cinder falcon marble lattice lattice cinder orbit boulder crimson #fb363108
<<<ANSWER END>>>
<<<ANSWER key=K02846>>>
vellum auburn zebra mistral zebra kindle marble spruce crimson auburn auburn garnet saffron vellum thistle boulder fathom garnet crimson vellum fathom lattice cinder auburn #6fc181b9
<<<ANSWER END>>>
<<<ANSWER key=K00673>>>
boulder glacier cobalt falcon cinder saffron cobalt auburn kindle boulder crimson meadow kindle thistle auburn falcon onyx zebra glacier mistral crimson boulder verdant fathom #10cf8158
<<<ANSWER END>>>
<<<ANSWER key=K00625>>>
copper harbor cinder vellum lantern fathom mistral harbor crimson saffron lantern zebra saffron marble saffron harbor nimbus trellis thistle trellis meadow ember verdant saffron #dd06f589
<<<ANSWER END>>>
<<<ANSWER key=K04791>>>
ember cinder garnet garnet mistral quartz russet boulder mistral harbor ember pewter cinder russet cobalt russet willow kindle crimson harbor glacier cobble kindle crimson #2a26767d
<<<ANSWER END>>>
<<<ANSWER key=K03407>>>
thistle fathom nimbus willow verdant cedar boulder boulder indigo crimson lantern thistle glacier mistral cobalt vellum quartz boulder falcon lattice fathom thistle orbit falcon #f97601aa
<<<ANSWER END>>>
<<<ANSWER key=K01641>>>
lattice trellis pewter cedar auburn saffron russet mistral auburn crimson onyx copper willow falcon willow zebra vellum lattice quartz saffron cinder auburn glacier quartz #c702e091
<<<ANSWER END>>>
<<<ANSWER key=K01495>>>
saffron marble falcon ember pewter onyx glacier onyx ember quartz glacier kindle cobalt marble thistle russet willow spruce onyx zebra quartz kindle nimbus boulder #35562fde
<<<ANSWER END>>>
<<<ANSWER key=K05225>>>
fathom vellum nimbus auburn spruce copper falcon orbit spruce zebra lattice kindle meadow pewter marble harbor cinder onyx fathom onyx cobalt cinder copper vellum #87a8873a
<<<ANSWER END>>>
<<<ANSWER key=K07253>>>
cedar thistle marble pewter cedar lantern saffron marble glacier onyx pewter fathom fathom onyx willow lattice saffron cobble zebra cobalt cedar glacier lantern zebra #6f2fa7b5
<<<ANSWER END>>>
<<<ANSWER key=K01114>>>
vellum quartz ember russet harbor ember orbit orbit auburn auburn fathom boulder falcon orbit mistral marble zebra falcon indigo cedar indigo lantern saffron cinder #c28b5bbe
<<<ANSWER END>>>
<<<ANSWER key=K01064>>>
fathom lattice cinder cobalt copper quartz lantern saffron copper harbor russet willow mistral thistle nimbus harbor onyx zebra thistle indigo harbor quartz pewter trellis #8f38d819
<<<ANSWER END>>>
<<<ANSWER key=K03737>>>
trellis cobalt kindle verdant copper thistle kindle marble boulder meadow lattice vellum cedar falcon verdant boulder cobalt lattice harbor mistral glacier quartz fathom quartz #a968fbe1
<<<ANSWER END>>>
<<<ANSWER key=K06928>>>
crimson copper quartz thistle copper marble auburn vellum cinder fathom auburn cobble nimbus trellis nimbus orbit auburn lattice orbit marble copper garnet marble russet #3c2946bd
<<<ANSWER END>>>
<<<ANSWER key=K00561>>>
harbor meadow auburn cobble glacier lattice saffron onyx harbor boulder zebra copper falcon marble glacier thistle cinder boulder fathom orbit cobalt crimson crimson vellum #12405658
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
