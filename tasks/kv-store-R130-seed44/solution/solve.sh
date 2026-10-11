#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00027>>>
crimson cobalt harbor boulder auburn auburn boulder cedar marble ember lattice verdant spruce onyx lattice thistle garnet russet quartz garnet fathom harbor cedar kindle #f36ca91a
<<<ANSWER END>>>
<<<ANSWER key=K00017>>>
lantern glacier auburn indigo lantern nimbus thistle garnet indigo cedar trellis crimson zebra nimbus copper cinder cinder boulder cinder kindle cobalt trellis lantern onyx #be44d348
<<<ANSWER END>>>
<<<ANSWER key=K00020>>>
cedar fathom crimson falcon cinder crimson zebra harbor ember garnet lattice garnet mistral pewter lattice lattice quartz cobalt cobble zebra orbit spruce falcon saffron #2a796553
<<<ANSWER END>>>
<<<ANSWER key=K00121>>>
meadow kindle thistle vellum meadow fathom cobalt lattice onyx cedar saffron spruce crimson garnet marble cedar glacier quartz crimson thistle kindle cedar onyx cobble #4f37903b
<<<ANSWER END>>>
<<<ANSWER key=K00069>>>
thistle crimson spruce lattice saffron quartz trellis glacier garnet thistle cobalt garnet kindle fathom garnet meadow copper saffron vellum onyx ember garnet ember nimbus #caadfb61
<<<ANSWER END>>>
<<<ANSWER key=K00087>>>
spruce ember cedar harbor boulder meadow trellis kindle auburn auburn quartz marble boulder lantern spruce zebra vellum saffron auburn ember saffron cinder lantern meadow #b0b970f3
<<<ANSWER END>>>
<<<ANSWER key=K00014>>>
verdant zebra spruce glacier garnet mistral indigo lattice harbor zebra russet cobble thistle saffron trellis falcon boulder kindle pewter garnet lantern cobalt cedar cobble #f3ceb5dc
<<<ANSWER END>>>
<<<ANSWER key=K00035>>>
cobble kindle garnet onyx boulder thistle saffron meadow zebra spruce pewter onyx orbit cobalt copper pewter glacier zebra trellis garnet kindle zebra crimson indigo #0f258963
<<<ANSWER END>>>
<<<ANSWER key=K00128>>>
orbit lattice pewter cobble harbor garnet indigo willow crimson crimson indigo garnet marble copper meadow lattice lantern cobble orbit glacier cobalt copper falcon zebra #418fd074
<<<ANSWER END>>>
<<<ANSWER key=K00077>>>
mistral pewter zebra trellis cobble verdant willow copper quartz saffron cobalt spruce saffron cinder mistral lattice mistral vellum verdant zebra auburn harbor glacier kindle #905502c2
<<<ANSWER END>>>
<<<ANSWER key=K00011>>>
trellis auburn ember harbor vellum indigo orbit marble kindle crimson copper meadow orbit orbit crimson verdant cobble ember mistral verdant vellum marble mistral cobble #01754ca1
<<<ANSWER END>>>
<<<ANSWER key=K00052>>>
ember auburn lattice willow lantern cobble russet cobalt indigo kindle cedar ember crimson falcon cedar ember falcon fathom trellis onyx cobalt spruce onyx nimbus #fdedf14d
<<<ANSWER END>>>
<<<ANSWER key=K00043>>>
spruce boulder orbit kindle zebra mistral saffron meadow nimbus orbit indigo boulder cinder russet cinder thistle harbor trellis copper saffron nimbus meadow boulder cinder #7169d741
<<<ANSWER END>>>
<<<ANSWER key=K00061>>>
copper crimson falcon boulder thistle kindle nimbus meadow garnet indigo vellum harbor orbit kindle garnet harbor cedar vellum boulder orbit meadow harbor trellis spruce #aead4432
<<<ANSWER END>>>
<<<ANSWER key=K00073>>>
russet orbit cobalt harbor trellis crimson cedar crimson onyx garnet cinder onyx cinder crimson falcon indigo quartz ember lantern indigo ember willow kindle copper #0fd1bc0b
<<<ANSWER END>>>
<<<ANSWER key=K00127>>>
vellum cedar copper cobble orbit marble saffron russet meadow meadow boulder fathom crimson cobble meadow kindle garnet orbit glacier mistral cedar kindle lantern trellis #1c8c73d7
<<<ANSWER END>>>
<<<ANSWER key=K00056>>>
thistle boulder copper trellis verdant pewter cedar falcon onyx kindle ember russet cobalt boulder zebra cinder quartz cedar orbit boulder glacier boulder kindle vellum #8fa7ae8f
<<<ANSWER END>>>
<<<ANSWER key=K00125>>>
lattice harbor verdant fathom pewter spruce lantern verdant quartz russet garnet thistle marble nimbus copper lantern lantern spruce garnet boulder lattice indigo lantern spruce #4bb5f6ca
<<<ANSWER END>>>
<<<ANSWER key=K00109>>>
boulder trellis russet vellum marble cinder falcon orbit cedar pewter zebra spruce cedar meadow cobalt lantern ember thistle thistle harbor lattice copper falcon ember #55209a16
<<<ANSWER END>>>
<<<ANSWER key=K00012>>>
crimson zebra lantern spruce crimson cobalt ember marble cinder orbit auburn russet kindle pewter meadow mistral auburn ember kindle quartz pewter thistle indigo saffron #de8330b7
<<<ANSWER END>>>
<<<ANSWER key=K00090>>>
boulder willow crimson crimson zebra quartz russet onyx orbit lantern glacier cobble spruce lantern orbit boulder lattice onyx auburn falcon garnet quartz thistle ember #ca794853
<<<ANSWER END>>>
<<<ANSWER key=K00078>>>
lattice verdant garnet indigo meadow crimson fathom cinder verdant quartz indigo spruce cobble cobalt auburn cobble pewter pewter glacier glacier cobble indigo cedar pewter #244142ba
<<<ANSWER END>>>
<<<ANSWER key=K00007>>>
meadow ember thistle spruce mistral fathom orbit trellis spruce quartz saffron harbor meadow glacier mistral glacier boulder crimson zebra pewter ember cedar crimson harbor #ef966207
<<<ANSWER END>>>
<<<ANSWER key=K00101>>>
crimson thistle zebra fathom mistral nimbus orbit cedar marble falcon cobalt trellis trellis indigo russet russet cedar mistral nimbus lantern copper vellum russet quartz #a2bcf355
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
