#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K01073>>>
pewter thistle copper cobalt saffron cedar onyx nimbus copper kindle thistle kindle harbor saffron auburn copper garnet onyx onyx spruce pewter indigo cinder copper #4eee26c2
<<<ANSWER END>>>
<<<ANSWER key=K00173>>>
cobalt thistle lattice cobble glacier thistle onyx spruce onyx indigo boulder trellis ember trellis mistral glacier boulder thistle saffron cobalt quartz cedar vellum onyx #03b823fc
<<<ANSWER END>>>
<<<ANSWER key=K00691>>>
zebra pewter boulder lattice auburn onyx auburn auburn cobalt cinder lantern thistle cedar pewter russet verdant indigo falcon indigo zebra fathom trellis ember nimbus #00f7d02d
<<<ANSWER END>>>
<<<ANSWER key=K00421>>>
cobble onyx crimson lattice copper russet falcon cinder indigo meadow zebra indigo mistral orbit fathom marble saffron orbit orbit indigo falcon cobalt pewter vellum #30a1d65b
<<<ANSWER END>>>
<<<ANSWER key=K02138>>>
copper meadow boulder orbit crimson falcon copper cobalt kindle auburn auburn garnet lattice lantern spruce crimson lattice boulder cobalt copper saffron indigo glacier saffron #3f9385fd
<<<ANSWER END>>>
<<<ANSWER key=K03552>>>
harbor thistle saffron kindle spruce kindle quartz meadow onyx trellis boulder cedar saffron willow mistral boulder meadow cedar boulder orbit harbor russet crimson auburn #f2f90e14
<<<ANSWER END>>>
<<<ANSWER key=K03057>>>
fathom nimbus spruce trellis lattice falcon harbor meadow spruce meadow zebra cobalt onyx marble cobalt cedar harbor meadow fathom lantern cedar saffron fathom marble #ab916b94
<<<ANSWER END>>>
<<<ANSWER key=K03715>>>
pewter glacier cobble boulder quartz willow spruce saffron indigo nimbus spruce auburn harbor thistle lantern indigo garnet copper cobalt glacier kindle indigo glacier lattice #b533944a
<<<ANSWER END>>>
<<<ANSWER key=K02814>>>
meadow fathom russet marble orbit copper indigo saffron thistle falcon crimson vellum indigo willow cedar cinder ember lattice zebra zebra lantern auburn lattice garnet #60d78fea
<<<ANSWER END>>>
<<<ANSWER key=K02687>>>
spruce spruce thistle lantern saffron indigo marble cobalt marble zebra cobble ember cinder cinder marble cobble thistle ember vellum pewter cobble saffron meadow cinder #5af0d630
<<<ANSWER END>>>
<<<ANSWER key=K03293>>>
glacier vellum quartz russet marble cedar saffron russet orbit spruce quartz lattice verdant ember marble thistle copper indigo indigo zebra crimson copper copper vellum #f5c47420
<<<ANSWER END>>>
<<<ANSWER key=K02993>>>
meadow cinder lattice cinder willow ember thistle glacier quartz cobble onyx cobble cedar copper falcon auburn lantern kindle cinder willow verdant harbor fathom vellum #86a5b853
<<<ANSWER END>>>
<<<ANSWER key=K03756>>>
orbit falcon thistle marble boulder cedar cobble willow glacier auburn harbor pewter ember orbit garnet marble nimbus marble russet vellum marble onyx nimbus orbit #eeec73ae
<<<ANSWER END>>>
<<<ANSWER key=K01564>>>
willow spruce verdant cobble lantern garnet cedar glacier vellum trellis cedar vellum harbor fathom fathom onyx fathom boulder copper spruce onyx nimbus ember verdant #539cff2a
<<<ANSWER END>>>
<<<ANSWER key=K00543>>>
zebra zebra harbor zebra nimbus boulder garnet cobble crimson meadow auburn auburn onyx indigo meadow boulder lattice indigo saffron cobble auburn harbor saffron spruce #9f0bed59
<<<ANSWER END>>>
<<<ANSWER key=K01236>>>
saffron harbor marble meadow mistral falcon verdant ember saffron garnet lantern cobalt cedar cinder zebra garnet copper cobalt cedar falcon verdant lantern cobble kindle #67e3de47
<<<ANSWER END>>>
<<<ANSWER key=K00463>>>
saffron fathom meadow willow ember auburn indigo cobble nimbus quartz harbor pewter willow fathom orbit lattice pewter kindle spruce kindle cobble fathom zebra cedar #e1c0e417
<<<ANSWER END>>>
<<<ANSWER key=K00745>>>
mistral cedar cinder willow glacier cobalt lantern fathom fathom auburn ember marble orbit kindle russet quartz pewter crimson lattice ember boulder kindle cinder zebra #5def9683
<<<ANSWER END>>>
<<<ANSWER key=K02538>>>
falcon auburn orbit vellum harbor kindle indigo onyx indigo garnet cobalt fathom onyx fathom cobble orbit orbit willow auburn saffron quartz glacier marble auburn #aca63e45
<<<ANSWER END>>>
<<<ANSWER key=K00752>>>
garnet ember falcon garnet orbit meadow auburn orbit saffron saffron copper crimson thistle mistral lantern boulder lattice spruce thistle copper garnet harbor meadow cinder #f2bf76b7
<<<ANSWER END>>>
<<<ANSWER key=K02276>>>
garnet boulder kindle lantern cobalt cedar cedar copper cobble zebra spruce boulder onyx saffron pewter lattice copper trellis kindle falcon lattice kindle falcon copper #ef549da6
<<<ANSWER END>>>
<<<ANSWER key=K02920>>>
orbit marble lattice spruce lattice quartz nimbus spruce onyx pewter meadow meadow cinder fathom cobble indigo glacier saffron trellis garnet meadow russet falcon nimbus #d0c175d0
<<<ANSWER END>>>
<<<ANSWER key=K00609>>>
crimson thistle saffron kindle thistle meadow trellis verdant spruce verdant spruce kindle orbit indigo copper boulder onyx cinder willow russet auburn nimbus nimbus quartz #50c7db74
<<<ANSWER END>>>
<<<ANSWER key=K00859>>>
vellum garnet auburn cobalt trellis orbit trellis cobalt spruce kindle indigo auburn mistral trellis orbit orbit cobalt copper marble cobble crimson crimson cobble saffron #c505d61c
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
