#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K02480>>>
garnet saffron boulder nimbus kindle quartz pewter cinder marble marble zebra verdant harbor harbor harbor meadow cinder cobble cinder orbit thistle mistral pewter fathom #6618bfd1
<<<ANSWER END>>>
<<<ANSWER key=K00489>>>
crimson glacier cobble mistral indigo indigo kindle nimbus onyx marble pewter glacier fathom zebra mistral fathom fathom spruce mistral verdant cobble garnet spruce auburn #8eda0ecd
<<<ANSWER END>>>
<<<ANSWER key=K02548>>>
cedar verdant cobble crimson cobble cedar fathom kindle zebra lantern cobble russet cedar nimbus zebra auburn ember mistral onyx copper quartz nimbus harbor willow #a4097a89
<<<ANSWER END>>>
<<<ANSWER key=K01715>>>
glacier mistral trellis trellis glacier pewter crimson cobalt marble pewter fathom pewter fathom harbor nimbus lattice fathom lantern orbit lattice crimson pewter quartz ember #bc644c2e
<<<ANSWER END>>>
<<<ANSWER key=K00841>>>
copper harbor auburn nimbus nimbus lantern saffron russet russet cedar garnet cobalt falcon trellis meadow harbor glacier ember cedar ember ember vellum willow willow #f845bc41
<<<ANSWER END>>>
<<<ANSWER key=K03360>>>
spruce meadow garnet lantern copper onyx pewter lantern glacier vellum fathom meadow ember trellis falcon orbit cobble verdant spruce crimson zebra nimbus cinder falcon #73931a2f
<<<ANSWER END>>>
<<<ANSWER key=K00567>>>
harbor garnet quartz spruce cobalt falcon trellis glacier cobble lantern onyx lattice glacier glacier kindle spruce crimson zebra orbit willow orbit auburn orbit lattice #014fedb8
<<<ANSWER END>>>
<<<ANSWER key=K03778>>>
copper ember cobble garnet fathom fathom boulder verdant glacier verdant pewter meadow glacier boulder pewter cedar cobble indigo ember saffron fathom saffron ember fathom #d655f65b
<<<ANSWER END>>>
<<<ANSWER key=K03399>>>
cinder lattice crimson ember onyx kindle onyx vellum orbit marble pewter indigo russet nimbus nimbus cedar thistle nimbus lattice nimbus russet cinder indigo garnet #127a9efd
<<<ANSWER END>>>
<<<ANSWER key=K01225>>>
auburn thistle meadow cobalt quartz quartz cedar boulder mistral cinder trellis marble glacier copper quartz meadow mistral marble harbor verdant garnet meadow cedar lantern #35fe0eb1
<<<ANSWER END>>>
<<<ANSWER key=K03099>>>
nimbus nimbus lattice fathom fathom cobalt boulder fathom zebra nimbus russet cedar vellum lattice nimbus marble trellis kindle lattice saffron garnet mistral copper indigo #5b74fd6b
<<<ANSWER END>>>
<<<ANSWER key=K02042>>>
thistle lantern ember indigo boulder vellum lantern glacier zebra falcon auburn nimbus boulder pewter lantern cedar russet indigo auburn copper marble thistle zebra lattice #b8d85e53
<<<ANSWER END>>>
<<<ANSWER key=K03663>>>
saffron vellum cobble willow verdant onyx saffron lattice onyx ember crimson cobble thistle auburn crimson crimson willow thistle meadow cobble verdant vellum cobble harbor #42af2590
<<<ANSWER END>>>
<<<ANSWER key=K00404>>>
lattice meadow quartz falcon trellis garnet nimbus cedar verdant willow orbit cedar willow glacier onyx lattice meadow harbor cobble auburn cinder spruce cobble kindle #6e368e39
<<<ANSWER END>>>
<<<ANSWER key=K01176>>>
quartz cedar russet glacier trellis russet pewter pewter thistle garnet cinder ember cinder boulder quartz willow willow crimson quartz ember thistle mistral pewter cobalt #ddbc715a
<<<ANSWER END>>>
<<<ANSWER key=K02283>>>
garnet lantern garnet harbor cobalt lattice glacier trellis boulder zebra zebra lantern copper copper harbor spruce lattice lattice copper spruce cobble russet lattice trellis #f73ac13e
<<<ANSWER END>>>
<<<ANSWER key=K02230>>>
meadow trellis spruce lattice fathom orbit boulder ember pewter russet auburn onyx cinder boulder willow trellis marble cobalt orbit boulder cobalt verdant spruce cinder #ef74b81d
<<<ANSWER END>>>
<<<ANSWER key=K02658>>>
pewter mistral auburn cobalt ember spruce nimbus auburn russet marble meadow lattice mistral fathom mistral russet thistle lattice crimson zebra cedar garnet kindle glacier #0fc43d42
<<<ANSWER END>>>
<<<ANSWER key=K03168>>>
spruce fathom falcon saffron onyx pewter fathom cobble kindle kindle crimson marble indigo lattice vellum pewter marble lattice cobble pewter ember kindle ember kindle #9bff2b35
<<<ANSWER END>>>
<<<ANSWER key=K02519>>>
kindle nimbus thistle vellum zebra pewter willow quartz lantern kindle nimbus crimson crimson marble quartz glacier indigo onyx ember meadow harbor auburn indigo onyx #6fc2214b
<<<ANSWER END>>>
<<<ANSWER key=K00134>>>
cobble crimson cobble ember onyx marble russet cobalt quartz crimson cedar marble marble mistral mistral crimson cobalt cobalt glacier zebra falcon ember falcon willow #42c8dc62
<<<ANSWER END>>>
<<<ANSWER key=K03821>>>
crimson ember orbit garnet cobalt kindle falcon quartz falcon cobble cobble willow zebra thistle auburn mistral copper nimbus marble marble auburn ember vellum lantern #affb1f2a
<<<ANSWER END>>>
<<<ANSWER key=K01186>>>
marble ember meadow trellis crimson harbor trellis mistral quartz kindle nimbus quartz quartz nimbus cobalt saffron cobalt saffron thistle cobalt mistral kindle onyx saffron #2360c5b6
<<<ANSWER END>>>
<<<ANSWER key=K00649>>>
russet fathom falcon cedar trellis fathom cedar kindle mistral quartz cobalt auburn glacier crimson glacier thistle cinder lantern garnet verdant mistral verdant onyx nimbus #4fcc45fd
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
