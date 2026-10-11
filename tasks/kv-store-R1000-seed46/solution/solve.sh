#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00078>>>
orbit pewter indigo russet lantern cinder russet trellis fathom falcon onyx thistle lattice spruce boulder trellis crimson meadow cinder marble cedar thistle spruce cinder #b49379bf
<<<ANSWER END>>>
<<<ANSWER key=K00935>>>
quartz saffron spruce verdant willow cobalt glacier thistle quartz harbor verdant falcon indigo harbor copper willow glacier cobalt falcon boulder vellum mistral harbor glacier #324731e8
<<<ANSWER END>>>
<<<ANSWER key=K00133>>>
onyx mistral mistral boulder ember mistral nimbus thistle indigo verdant vellum trellis cobalt quartz crimson trellis lantern indigo garnet marble cinder ember boulder lattice #0fb3abb2
<<<ANSWER END>>>
<<<ANSWER key=K00277>>>
meadow lattice marble auburn onyx lantern vellum meadow harbor marble zebra trellis mistral copper mistral trellis verdant vellum vellum russet cinder orbit copper crimson #a204ba4a
<<<ANSWER END>>>
<<<ANSWER key=K00751>>>
cinder verdant harbor willow lattice copper verdant copper crimson saffron marble russet pewter cobalt willow vellum boulder meadow zebra lantern fathom onyx nimbus mistral #0977d992
<<<ANSWER END>>>
<<<ANSWER key=K00610>>>
auburn spruce lattice russet ember lantern cinder glacier verdant meadow lantern pewter lantern boulder glacier garnet thistle lantern lattice trellis ember lattice marble cedar #772551a8
<<<ANSWER END>>>
<<<ANSWER key=K00710>>>
saffron cobalt mistral fathom lattice verdant willow glacier auburn cobalt glacier quartz onyx pewter lattice onyx marble garnet marble trellis orbit vellum lattice lattice #038ee9e2
<<<ANSWER END>>>
<<<ANSWER key=K00873>>>
copper harbor cedar zebra ember willow falcon kindle indigo willow meadow verdant ember fathom thistle lattice crimson lattice boulder cinder mistral indigo willow fathom #ff7584b7
<<<ANSWER END>>>
<<<ANSWER key=K00677>>>
onyx nimbus willow glacier crimson willow zebra nimbus thistle russet vellum cobble fathom onyx harbor garnet onyx orbit cobalt auburn glacier kindle kindle boulder #163dd8a0
<<<ANSWER END>>>
<<<ANSWER key=K00530>>>
indigo lantern mistral marble cobalt vellum marble glacier vellum verdant indigo onyx garnet orbit crimson boulder quartz vellum vellum lattice glacier lantern indigo falcon #20770280
<<<ANSWER END>>>
<<<ANSWER key=K00848>>>
saffron mistral meadow trellis indigo falcon ember orbit cinder lattice thistle garnet cobble spruce glacier copper quartz orbit ember verdant boulder harbor mistral saffron #a5e76524
<<<ANSWER END>>>
<<<ANSWER key=K00920>>>
ember cobble quartz glacier quartz mistral ember kindle lattice garnet zebra pewter quartz cedar cobble marble harbor quartz crimson russet cinder trellis lattice copper #c3fd16ed
<<<ANSWER END>>>
<<<ANSWER key=K00736>>>
boulder falcon lattice saffron thistle harbor cedar harbor cobble boulder quartz onyx harbor crimson mistral pewter cedar cobalt verdant thistle orbit russet orbit auburn #f685d77c
<<<ANSWER END>>>
<<<ANSWER key=K00156>>>
cobalt cobalt quartz saffron cedar cinder falcon glacier spruce nimbus russet fathom auburn trellis quartz marble auburn willow mistral cobble marble saffron quartz spruce #47bb30d5
<<<ANSWER END>>>
<<<ANSWER key=K00340>>>
verdant indigo quartz willow pewter russet kindle crimson boulder willow mistral verdant willow zebra boulder indigo marble lattice willow ember lantern fathom quartz zebra #936301c2
<<<ANSWER END>>>
<<<ANSWER key=K00838>>>
crimson falcon boulder ember lantern orbit meadow vellum willow cedar kindle thistle marble russet kindle verdant indigo zebra spruce willow lattice willow spruce falcon #0de4ca3e
<<<ANSWER END>>>
<<<ANSWER key=K00571>>>
cobalt lantern trellis boulder marble lattice meadow quartz willow ember indigo willow lattice copper zebra spruce cobble zebra russet garnet trellis ember lattice willow #6b8d9484
<<<ANSWER END>>>
<<<ANSWER key=K00353>>>
copper cinder cobble onyx crimson crimson zebra vellum indigo kindle orbit thistle auburn falcon cedar vellum boulder fathom verdant zebra marble spruce boulder cinder #205fc1ef
<<<ANSWER END>>>
<<<ANSWER key=K00220>>>
garnet harbor thistle nimbus trellis ember saffron spruce kindle copper meadow cedar onyx lantern kindle crimson russet quartz trellis zebra garnet kindle kindle lattice #95d81144
<<<ANSWER END>>>
<<<ANSWER key=K00651>>>
ember kindle onyx marble ember zebra pewter russet fathom russet verdant thistle orbit garnet harbor cinder copper quartz kindle zebra orbit saffron thistle mistral #b907c558
<<<ANSWER END>>>
<<<ANSWER key=K00557>>>
crimson mistral vellum cobalt mistral willow vellum kindle cinder vellum garnet willow mistral cobalt cinder saffron kindle meadow willow cinder onyx falcon garnet mistral #9590dc8c
<<<ANSWER END>>>
<<<ANSWER key=K00518>>>
orbit glacier copper orbit harbor cedar nimbus falcon marble willow saffron boulder lattice thistle thistle lattice orbit zebra thistle mistral meadow saffron onyx mistral #98fb08dc
<<<ANSWER END>>>
<<<ANSWER key=K00728>>>
marble cinder verdant willow meadow zebra glacier verdant boulder falcon marble zebra cinder vellum zebra meadow cinder trellis mistral lattice trellis garnet harbor ember #4615a3d9
<<<ANSWER END>>>
<<<ANSWER key=K00281>>>
verdant zebra crimson willow zebra nimbus pewter falcon falcon trellis marble glacier kindle zebra cobble glacier fathom trellis meadow zebra garnet onyx russet zebra #e21ed4f9
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
