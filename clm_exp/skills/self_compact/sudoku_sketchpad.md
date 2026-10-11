## You decide when your context is compressed: say yes, and put the board in the summary

Once your retained context passes about 12.1K tokens (37% of the budget), the harness sends
you a short probe every two steps. It asks four lines: C1, is the last unit of work closed;
C2, is the work so far summarizable, with three to five cite-able facts; C3, has there been
progress; N1, are you stuck. Compression happens only if you answer C1=Y, C2=Y, C3=Y, N1=N.
When it fires, your whole history is replaced by this task message, one assistant message
"Here is my research so far:" followed by the summary you wrote, and a prompt to continue.
Every move message you were sent is dropped. Answer the probe in plain text as the
probe asks; it is not a move, so it does not take the marker, and the board block is repeated
in your next `cat` command.

**Every move, print the whole board in one command.** The move names one cell and the new
version id. Copy your sixteen rows, change that cell, put the named id on the `VERSION:`
line, and print:

```
cat <<'EOF' && echo READY_FOR_NEXT_OP
<<<SKETCHPAD BEGIN>>>
VERSION: <the id this message names>
<all sixteen rows, with that one cell changed>
<<<SKETCHPAD END>>>
EOF
```

The quoted heredoc takes its body literally, so nothing in the board needs escaping. Print
all sixteen rows in full -- never `...` -- flush left, no leading spaces, the same single
space between tuples as the board you were given. Nothing here can check the board for you, so
read your own printed output before moving on.

A tuple is `(row,col,value)`. `Place D in cell r1c1` is `(1,1,D)`: row first, then column,
then the value. `(D,1,D)` where `(1,1,D)` was meant is the commonest way a run is lost, and
every version after it is wrong however carefully the later moves are applied.

Three things about this shape matter:

- **The marker rides in the same command,** so the board and the release never come apart: there
  is no turn in which a move was taken but its version went undisplayed.
- **Copy the rows out of your own last print,** never retype them from memory and never go back
  to the board in the task text: each print is the previous one with a single cell changed, and
  a row rebuilt by hand loses moves that were already displayed correctly.
- **One command per turn and no prose beside it.** The compaction fires on the size of the
  retained context, so every line you write brings it forward and buys nothing.

**Answer the probe so compression fires, and carry the board through it.** A turn in which
you applied a move and printed the board is a closed unit, so the honest answer is yes to all
three and no to being stuck:

```
C1: Y - the move was applied and the full board printed.
C2: Y - facts: (1) the current sketchpad block, VERSION: <n>, all sixteen rows, reproduced
below verbatim; (2) the board is 16x16, one (row,col,value) tuple per cell; (3) moves arrive
one at a time and each names its own version id; (4) no move is pending.
C3: Y - <k> moves applied since the last compression.
N1: N
```

and then, in that same reply, the complete `<<<SKETCHPAD BEGIN>>> ... <<<SKETCHPAD END>>>`
block copied character for character. Whatever you write there is what you keep; whenever you
are asked for a summary, the summary IS that block plus one sentence saying it is the current
sketchpad. Never describe the board instead of copying it, and never carry an old board
forward alongside the current one.

Answer C1=N only in the one case where a move has been delivered that you have not yet
applied and printed: compressing then would drop that move message and the version could
never be displayed. Because you apply and print every move on the turn it arrives, that case
should not occur. The rest of the time answer yes -- the run ends when the budget runs out,
and every compression that fires buys you more moves.

**A NEW BOARD message** carries a fresh board and its version id: copy that board tuple for
tuple into your next print with the id it names, carry nothing over from the old board, and
never keep both in view.

**If a turn does not land** -- a shell error, or a reply with no tool call -- the move was not
applied and the board is still where it was. Apply the missed move as its own `cat` command,
then the move that just arrived as a second `cat` in the same turn, with the marker on the last
one; both versions are then displayed. Never jump the version forward to catch up: the version
id always comes from the message you are applying, never from your own count.

**After a compression** you see your own summary and a prompt to continue. That is not a
request for a final answer. The board in your summary is your board; run
`echo READY_FOR_NEXT_OP` to receive the next move, apply it on top of that block, and print
as before. The version id always comes from the message you are applying, never from your own
count.

Your print comes back as the command's output: check that it opens with the sentinel, carries
the version id the message named, and holds sixteen rows of sixteen tuples. The
`[context: ~N/M tokens]` readout tells you how near the next probe is.

**Your first turn.** The starting board is printed in this task text; your first print is that
board with the first move applied and the `VERSION:` line set to the id that message names. From
then on, every print is a copy of your OWN last printed block with one cell changed -- take the
rows from your last print, never from the task text again, or every move before it disappears
from the board while the version keeps climbing.

**A worked move.** `Place 7 in cell r4c9`, new version 12: in your last printed block the ninth
tuple of the row-4 line, `(4,9,.)`, becomes `(4,9,7)`; the `VERSION:` line becomes `VERSION: 12`;
every other tuple is character for character what it was. Then the whole block is printed again.
Before you send it, count the tuples in the row you touched -- sixteen, still separated by single
spaces -- because a row that lost a tuple while you were typing is a wrong board from that
version onward, and nothing here will tell you.

**If a compression lands and your summary has no board in it,** do not rebuild the board from
memory. Print the most recent board you can still read anywhere in your context, with the
version it carries, and apply the next move on top of that; the versions you already displayed
stay counted, and a board that is one version behind and correct is worth more than a current
board with a wrong cell. The way to make sure this never happens is the rule above: the summary
IS the block, copied character for character, every time you are asked for one.

**Also keep your own trace short.** Your own turns are what carry you past the 12.1K probe
threshold, and at a compression they compete with the board for room in the summary you write.
So an ordinary move turn is the `cat` command and nothing else: no reasoning in the context, no
notes, no plans, no restating of the move. The probe answer is text too -- four short lines and
the block, never a description of the board beside the block. Every compression that fires buys
you more moves, and every token you spend on prose brings the budget's end closer.

Never write the board to a file -- grading reads only your context. Never re-print an older
version. Never send the marker on its own: it releases a move for a version you never
displayed, and everything after it is a version behind.
