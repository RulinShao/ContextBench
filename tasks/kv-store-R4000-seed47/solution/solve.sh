#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K01696>>>
ember spruce lattice onyx crimson cedar zebra lantern spruce meadow harbor nimbus cobble glacier onyx lattice cobalt ember auburn kindle crimson zebra cobble cinder #ffde0b65
<<<ANSWER END>>>
<<<ANSWER key=K02347>>>
lantern kindle kindle fathom indigo glacier quartz glacier ember marble orbit russet quartz vellum auburn cedar pewter falcon cedar mistral falcon nimbus thistle copper #f4b905ca
<<<ANSWER END>>>
<<<ANSWER key=K01845>>>
auburn copper trellis glacier nimbus cedar pewter crimson marble kindle harbor indigo boulder auburn crimson meadow marble cobalt cobble lattice quartz ember nimbus willow #a4179d29
<<<ANSWER END>>>
<<<ANSWER key=K01579>>>
lattice fathom mistral harbor orbit russet cinder trellis fathom saffron ember copper harbor cinder willow kindle nimbus orbit lattice spruce orbit onyx marble boulder #6d3f5753
<<<ANSWER END>>>
<<<ANSWER key=K00618>>>
russet crimson cobalt spruce fathom glacier ember trellis ember spruce verdant lantern pewter marble orbit willow glacier cobalt copper cobble marble trellis trellis onyx #21a1a3ad
<<<ANSWER END>>>
<<<ANSWER key=K03692>>>
pewter onyx cedar russet zebra boulder indigo copper crimson glacier onyx trellis orbit garnet lantern boulder nimbus lattice ember auburn thistle pewter marble verdant #ab7133bb
<<<ANSWER END>>>
<<<ANSWER key=K02103>>>
verdant marble zebra indigo quartz willow auburn onyx zebra orbit garnet boulder lattice fathom cobalt cobalt spruce boulder onyx saffron crimson pewter vellum glacier #db58e3fe
<<<ANSWER END>>>
<<<ANSWER key=K00947>>>
copper saffron lantern willow cobalt boulder glacier glacier russet thistle kindle fathom lattice mistral quartz cobble russet onyx cedar orbit meadow auburn auburn vellum #6a1ddb7f
<<<ANSWER END>>>
<<<ANSWER key=K02593>>>
lantern cinder mistral spruce boulder kindle cobalt zebra cinder ember quartz cobalt lantern garnet onyx boulder boulder thistle spruce copper saffron copper pewter vellum #94b8a2b1
<<<ANSWER END>>>
<<<ANSWER key=K00786>>>
auburn pewter auburn pewter kindle marble vellum auburn thistle quartz russet cobble ember saffron meadow orbit cobble vellum lantern nimbus willow boulder cobble harbor #30b03390
<<<ANSWER END>>>
<<<ANSWER key=K03144>>>
nimbus auburn russet orbit quartz lantern indigo marble spruce cedar nimbus lattice kindle verdant vellum lantern meadow orbit trellis garnet cobble quartz falcon copper #e0301c70
<<<ANSWER END>>>
<<<ANSWER key=K00777>>>
pewter cobble meadow fathom indigo nimbus cobble auburn orbit vellum vellum lattice harbor kindle meadow cedar lantern onyx copper verdant zebra cobalt copper marble #f51c8023
<<<ANSWER END>>>
<<<ANSWER key=K03532>>>
fathom orbit nimbus ember crimson spruce willow nimbus willow marble ember willow boulder ember vellum cobalt glacier copper saffron onyx quartz thistle indigo willow #09060d74
<<<ANSWER END>>>
<<<ANSWER key=K00385>>>
willow saffron lantern indigo indigo quartz willow orbit cobalt lattice kindle cobble cedar spruce ember kindle crimson cobalt cedar fathom zebra saffron boulder garnet #00989072
<<<ANSWER END>>>
<<<ANSWER key=K00559>>>
cedar boulder harbor trellis cedar auburn indigo pewter trellis orbit cedar lantern zebra thistle cobble glacier kindle lattice crimson thistle orbit cinder orbit cobalt #354cab39
<<<ANSWER END>>>
<<<ANSWER key=K03757>>>
copper kindle trellis meadow verdant vellum orbit nimbus falcon vellum zebra ember willow cobalt zebra onyx lattice lantern verdant cobble glacier cobalt lantern fathom #9d9ffcdb
<<<ANSWER END>>>
<<<ANSWER key=K03178>>>
lattice marble cobalt pewter nimbus onyx saffron quartz meadow willow mistral indigo ember meadow auburn nimbus harbor pewter falcon nimbus boulder garnet quartz russet #1aaf6726
<<<ANSWER END>>>
<<<ANSWER key=K02471>>>
cedar cinder kindle lattice ember vellum trellis nimbus saffron boulder ember pewter verdant lattice onyx auburn trellis cinder thistle meadow quartz onyx trellis falcon #723e3027
<<<ANSWER END>>>
<<<ANSWER key=K03735>>>
trellis spruce copper mistral auburn meadow ember indigo falcon meadow kindle lattice vellum ember boulder lattice spruce onyx meadow auburn cobble indigo onyx meadow #2a7411a8
<<<ANSWER END>>>
<<<ANSWER key=K00537>>>
russet copper fathom crimson harbor trellis indigo fathom cobble cinder crimson vellum pewter verdant saffron ember lattice indigo indigo nimbus cobble fathom verdant cinder #6b1dfdaf
<<<ANSWER END>>>
<<<ANSWER key=K02274>>>
verdant cinder thistle crimson cinder saffron copper fathom cedar thistle garnet trellis glacier cinder onyx indigo vellum fathom quartz vellum fathom falcon orbit zebra #f8c3433b
<<<ANSWER END>>>
<<<ANSWER key=K02073>>>
lantern boulder orbit pewter cobalt fathom lattice cobble spruce cinder ember boulder verdant mistral boulder verdant lattice orbit orbit lattice ember trellis verdant spruce #0965c2a7
<<<ANSWER END>>>
<<<ANSWER key=K03291>>>
lattice marble trellis quartz cedar spruce ember garnet thistle orbit indigo russet indigo garnet thistle willow marble trellis onyx cobalt cedar russet spruce lattice #2b2eb60b
<<<ANSWER END>>>
<<<ANSWER key=K01089>>>
russet lantern crimson onyx cinder spruce glacier marble orbit cobble fathom saffron vellum cobalt boulder spruce willow cinder zebra cinder russet trellis garnet willow #d9f012f8
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
