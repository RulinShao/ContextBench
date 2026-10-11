#!/usr/bin/env bash
# Oracle: writes every gold answer into the agent log dir as a final report.
# Graded as graded_from=final_report, never comparable to a context grade.
set -euo pipefail
mkdir -p /logs/agent
cat > /logs/agent/final_report.txt <<'CONTEXTBENCH_ORACLE_EOF'
kept 4 needle line(s).
kept 8 needle line(s).
kept 12 needle line(s).
<<<NEEDLES BEGIN>>>
[n00000i00#f56502a0] glacier orbit lantern lattice quartz ember ember meadow lattice orbit.
[n00000i01#0a048867] verdant lattice saffron zebra boulder pewter crimson lantern zebra thistle.
[n00000i02#9116f77c] ember indigo trellis lantern saffron thistle copper glacier copper saffron.
[n00000i03#4827e3e3] pewter ember marble boulder quartz spruce cinder lantern auburn spruce.
[n00001i00#d522b378] copper spruce cedar cedar verdant spruce onyx glacier meadow falcon.
[n00001i01#d2b933d3] crimson meadow indigo boulder harbor cinder orbit cinder cinder marble.
[n00001i02#4c6be8ae] orbit indigo marble lantern lattice meadow pewter cinder glacier meadow.
[n00001i03#5712ea27] zebra falcon spruce quartz harbor trellis copper cedar glacier zebra.
[n00002i00#8976556a] meadow auburn nimbus indigo saffron orbit harbor ember marble orbit.
[n00002i01#20dfde32] quartz marble ember meadow orbit crimson willow cedar cinder trellis.
[n00002i02#d9da2f2a] pewter ember cinder cobalt onyx harbor boulder lattice harbor thistle.
[n00002i03#b94bb893] auburn cobalt falcon indigo marble falcon willow falcon lantern zebra.
[n00003i00#99efbef1] lattice marble saffron thistle pewter orbit lattice onyx glacier auburn.
[n00003i01#75f39967] ember willow cinder crimson marble quartz nimbus cinder onyx zebra.
[n00003i02#51db856b] marble cinder orbit auburn spruce ember thistle spruce lattice boulder.
[n00003i03#95929741] copper nimbus cinder copper trellis glacier pewter cobalt trellis meadow.
<<<NEEDLES END>>>
CONTEXTBENCH_ORACLE_EOF
