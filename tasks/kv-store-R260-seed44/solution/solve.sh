#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
<<<ANSWER key=K00199>>>
zebra indigo mistral copper verdant orbit kindle quartz cinder cinder quartz onyx cobalt lantern auburn lattice cobalt glacier trellis glacier cobalt nimbus kindle pewter #ac56592a
<<<ANSWER END>>>
<<<ANSWER key=K00235>>>
thistle falcon cobalt cinder cinder cinder zebra russet trellis garnet onyx willow boulder falcon onyx quartz marble saffron harbor crimson crimson kindle russet harbor #517ddd35
<<<ANSWER END>>>
<<<ANSWER key=K00156>>>
harbor russet pewter kindle cinder saffron crimson boulder lattice meadow falcon quartz cinder vellum orbit lantern indigo lattice willow spruce willow vellum glacier crimson #6e77e9fa
<<<ANSWER END>>>
<<<ANSWER key=K00234>>>
auburn spruce auburn lattice lantern auburn fathom glacier orbit crimson boulder cedar nimbus harbor glacier ember spruce quartz glacier cedar trellis indigo onyx cinder #5df32ab1
<<<ANSWER END>>>
<<<ANSWER key=K00127>>>
vellum cedar copper cobble orbit marble saffron russet meadow meadow boulder fathom crimson cobble meadow kindle garnet orbit glacier mistral cedar kindle lantern trellis #1c8c73d7
<<<ANSWER END>>>
<<<ANSWER key=K00175>>>
nimbus thistle lantern auburn lattice auburn auburn thistle harbor lattice kindle marble willow marble indigo falcon indigo nimbus garnet orbit ember meadow quartz spruce #48d2714f
<<<ANSWER END>>>
<<<ANSWER key=K00214>>>
vellum lattice onyx onyx orbit cedar meadow quartz vellum boulder ember quartz harbor copper ember kindle cinder kindle saffron crimson trellis quartz trellis ember #301477d2
<<<ANSWER END>>>
<<<ANSWER key=K00140>>>
willow cobalt cedar glacier vellum vellum cobble crimson thistle quartz thistle cobalt ember verdant thistle indigo auburn kindle kindle quartz falcon lantern kindle orbit #d6433701
<<<ANSWER END>>>
<<<ANSWER key=K00058>>>
pewter zebra boulder cinder onyx lantern indigo marble vellum nimbus cinder garnet harbor boulder onyx quartz spruce quartz harbor pewter zebra crimson glacier spruce #1ece5bd4
<<<ANSWER END>>>
<<<ANSWER key=K00063>>>
copper quartz saffron nimbus thistle onyx garnet harbor crimson crimson vellum verdant crimson glacier cedar falcon meadow meadow nimbus fathom copper russet russet quartz #d5931b28
<<<ANSWER END>>>
<<<ANSWER key=K00090>>>
boulder willow crimson crimson zebra quartz russet onyx orbit lantern glacier cobble spruce lantern orbit boulder lattice onyx auburn falcon garnet quartz thistle ember #ca794853
<<<ANSWER END>>>
<<<ANSWER key=K00251>>>
auburn saffron marble kindle pewter garnet orbit garnet vellum marble boulder onyx cedar saffron cedar willow trellis vellum harbor auburn russet copper auburn quartz #8690f441
<<<ANSWER END>>>
<<<ANSWER key=K00120>>>
pewter ember verdant boulder cinder nimbus garnet orbit marble thistle boulder pewter crimson lattice lattice saffron lantern falcon trellis cobble marble verdant harbor pewter #3fe6bf08
<<<ANSWER END>>>
<<<ANSWER key=K00001>>>
ember fathom meadow thistle saffron glacier thistle boulder zebra copper auburn thistle russet russet cedar cedar quartz indigo falcon orbit zebra cinder zebra verdant #06024fe6
<<<ANSWER END>>>
<<<ANSWER key=K00167>>>
trellis orbit fathom lattice fathom trellis boulder harbor nimbus cedar lantern auburn ember glacier cobble pewter kindle crimson vellum spruce saffron falcon trellis lattice #4b49218c
<<<ANSWER END>>>
<<<ANSWER key=K00052>>>
ember auburn lattice willow lantern cobble russet cobalt indigo kindle cedar ember crimson falcon cedar ember falcon fathom trellis onyx cobalt spruce onyx nimbus #fdedf14d
<<<ANSWER END>>>
<<<ANSWER key=K00015>>>
trellis falcon kindle marble glacier harbor saffron lantern crimson mistral cobalt onyx russet falcon marble mistral cedar cobble trellis glacier willow spruce trellis spruce #82cc65c4
<<<ANSWER END>>>
<<<ANSWER key=K00227>>>
thistle indigo zebra cobalt kindle auburn thistle saffron mistral spruce cobble vellum harbor mistral cobalt orbit ember cobalt ember marble cobble falcon verdant mistral #ce562bae
<<<ANSWER END>>>
<<<ANSWER key=K00154>>>
saffron indigo copper indigo willow auburn fathom pewter mistral lantern spruce kindle ember vellum kindle zebra indigo saffron thistle fathom vellum marble kindle meadow #8dfa135a
<<<ANSWER END>>>
<<<ANSWER key=K00092>>>
cedar ember indigo crimson harbor willow fathom spruce quartz glacier zebra auburn quartz russet nimbus pewter auburn onyx harbor willow spruce cinder trellis trellis #cb032f13
<<<ANSWER END>>>
<<<ANSWER key=K00169>>>
marble russet trellis lantern cedar zebra vellum harbor quartz trellis cedar cobalt kindle mistral orbit willow marble verdant falcon spruce pewter saffron quartz thistle #9be2be29
<<<ANSWER END>>>
<<<ANSWER key=K00219>>>
boulder saffron orbit garnet spruce cobble zebra zebra lantern falcon glacier russet copper mistral cobble copper glacier auburn willow kindle boulder trellis lantern saffron #ddf99ca4
<<<ANSWER END>>>
<<<ANSWER key=K00111>>>
spruce spruce cobalt harbor kindle garnet boulder nimbus cobble quartz indigo boulder pewter russet indigo nimbus saffron boulder saffron lantern indigo kindle trellis lantern #a69aacaa
<<<ANSWER END>>>
<<<ANSWER key=K00059>>>
orbit boulder vellum vellum pewter meadow ember garnet willow orbit russet cobalt saffron thistle indigo saffron falcon lattice cobble thistle lantern garnet spruce cobble #96f94e49
<<<ANSWER END>>>
CONTEXTBENCH_ORACLE_EOF
