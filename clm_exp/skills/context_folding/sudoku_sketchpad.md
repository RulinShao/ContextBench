## Append-only: nothing can take a board out of your context, so spend it on boards alone

You can append to your context but never edit or delete it. Every move you are sent and every
board you print stays, and when the total exceeds the usable budget (about 30,720 of 32,768
tokens) the harness gives you one final turn and ends the run. Everything you displayed before
that still counts, so your score is how many versions you print correctly before the budget
runs out, which makes terseness part of the method: a 16x16 block is about two thousand
characters, and the command that prints it carries a second, escaped copy that does not count
as a displayed block. The print is already expensive; anything else you write comes out of
the moves you reach.

**Every move, print the whole board in one command -- and write nothing else.** The move names
one cell and the new version id. Copy your sixteen rows, change that cell, put the named id on
the `VERSION:` line:

```
cat <<'EOF' && echo READY_FOR_NEXT_OP
<<<SKETCHPAD BEGIN>>>
VERSION: <the id this message names>
<all sixteen rows, with that one cell changed>
<<<SKETCHPAD END>>>
EOF
```

The quoted heredoc takes its body literally, so parentheses, dots and the `<<<` sentinels
need no escaping and a stray quote cannot swallow the command. All sixteen rows in full,
never `...`, flush left with no leading spaces, the same single space between tuples as the
board you were given; `EOF` alone on the last line. Copy the rows rather than retyping them.
The marker rides in the same command so the board and the release never come apart -- nothing
here can check the board for you, so read your own printed output before moving on.

A tuple is `(row,col,value)`. `Place D in cell r1c1` is `(1,1,D)`: row from the top, then
column from the left, then the value last. `(D,1,D)` where `(1,1,D)` was meant is the
commonest way a run is lost, and the board is wrong from that version onward however
correctly every later move is applied.

**Do not use `branch` on this task.** A branch starts from a copy of your current context and
folds away only its own turns when it returns; it cannot remove anything that is already in
MAIN, so the boards you have printed stay exactly where they are. Moves are delivered to MAIN
only -- a marker run inside a branch releases nothing -- and branch turns come out of the same
turn budget as your moves. So a branch costs you turns, shrinks your context by nothing, and
every turn spent in one is a version you never display.

Keep everything outside the board block to a minimum -- no reasoning text, no notes, no
re-printing of old versions -- so that the budget goes to versions instead of to your own
words.

Three more things matter:

- **One command per turn, no prose.** No plans, no notes, no restating the move. Nothing here
  reclaims a token of it.
- **Never re-print an older version.** Each version is graded from the context as it stood on
  the turn it was current; a second copy buys nothing and costs a whole move's worth of budget.
- **Never shorten the block.** It is graded character for character: every tuple, the dots for
  empty cells, the same spacing. An abbreviated board is a wrong board, not a cheaper one.

A NEW BOARD message carries a fresh board and its version id: copy it tuple for tuple into
your next print with the id it names, and carry nothing over from the old board.

The version id always comes from the message you are applying, never from your own count. If a
turn fails -- a shell error, or a reply with no tool call -- the move was not applied and the
board is still where it was; apply the missed move as its own `cat` command, then the move
that just arrived as a second `cat` in the same turn, with the marker on the last one. Both
versions are then displayed. Never jump the version forward to catch up.

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

**A board printed inside a branch is not in MAIN.** The sub-agent's turns are folded away when
it returns, and all MAIN receives is one summary line, so a version displayed in a branch was
never displayed where it counts. Every board belongs in MAIN, printed by the `cat` command
above, on the turn its move arrives.

**What a move costs you, and how many you have left.** A printed block is about two thousand
characters, roughly 500 tokens, and the command that prints it carries the same board again as
one escaped line inside your own turn -- so a move costs something like a thousand tokens
whatever you do, and MAIN's usable 30,720 hold on the order of thirty of them. The
`[context: ~N/M tokens]` readout, with the gap between N and M divided by what a move has been
costing, is how many more versions you can still display. A branch changes none of that
arithmetic; it only spends turns from the same budget.

**Also keep your own trace short.** Nothing in MAIN is ever reclaimed, so every line you write
is subtracted from the versions you still get to display. An ordinary move turn is the `cat`
command and nothing else: no reasoning in the context, no notes, no plans, no acknowledgements.
When the readout says the budget is nearly gone, spend the last turn printing the current board
rather than writing about it.

Read your print back: `<<<SKETCHPAD BEGIN>>>`, the version the message named, sixteen rows of
sixteen tuples, `<<<SKETCHPAD END>>>`. The `[context: ~N/M tokens]` readout tells you how many
versions you have left. When the harness tells you the run is ending, spend that last turn
printing the current board rather than writing prose.

Never write the board to a file -- grading reads your context, not disk. Never send
`echo READY_FOR_NEXT_OP` on its own: it releases a move for a version you never displayed, and
every version after it is one behind.
