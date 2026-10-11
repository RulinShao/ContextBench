## Your method: print the board every move; before the budget fills, `manage_context`, then `query_memory` the board back

Your score is how many versions you print correctly before the run ends. Each version is
graded from the context as it stood on the turn it was current, so a version you displayed
stays counted after it is compressed. Nothing leaves your context by itself: there is no
automatic compaction and no reminder. You have two tools besides `bash`, and they are the
whole method:

- **`manage_context`** takes no arguments. It takes everything since your previous
  `manage_context` call (or since this task message, on the first call), up to and including
  the turn in which you call it, and replaces it with one message `[summary_id: N] <summary>`.
  The summary is written by a separate call to the same model, asked for a `## Knowledge
  state` and a `## Thoughts` section with identifiers preserved verbatim. The original
  messages are saved verbatim by the harness as summary N; `bash` cannot read them.
- **`query_memory(summary_id, query)`** has the same model read the saved originals of one
  summary and return what matches your query, prefixed `[query_memory: summary_id=N]`. The
  reply is capped at about 2,000 tokens, enough for one whole board. It stays in your
  context until the next `manage_context`.

**Every move, print the whole board in one command -- and write nothing else at all.** The
move names one cell and the new version id. Copy your sixteen rows, change that cell, put the
named id on the `VERSION:` line, and release the next move on the same line:

```
cat <<'EOF' && echo READY_FOR_NEXT_OP
<<<SKETCHPAD BEGIN>>>
VERSION: <the id this message names>
<all sixteen rows, with that one cell changed>
<<<SKETCHPAD END>>>
EOF
```

All sixteen rows in full, never `...`, flush left, the same single space between tuples as
the board you were given; `EOF` alone on the last line. A tuple is `(row,col,value)`:
`Place D in cell r1c1` is `(1,1,D)` -- row, then column, then the value last. Writing the
value into the row slot is the single most common way a run is lost, because the board is
then wrong from that version on. Your first print is the starting board in this task text
with the first move applied.

A 16x16 block is about two thousand characters, and the command that prints it carries a
second copy in your turn, so a move costs about a thousand tokens; the budget is 32,768,
about 30,720 usable, and the `[context: ~N/M tokens]` line after every command is your
gauge. **The rule: when the gauge is above 24,000, the next move is applied in three turns
instead of one:**

1. Call `manage_context`. This compresses everything since the last summary, including your
   last printed board. Read the `[summary_id: N]` message that comes back.
2. Call `query_memory(N, "the most recent SKETCHPAD block: its VERSION line and all sixteen
   rows, exactly as printed, one row per line, no bullets")`.
3. Print the board from that reply with the pending move applied and the version the move
   names, with the `cat` command above, marker included.

Four things about this matter:

- **One tool call per turn.** Neither tool can share a turn with a command; a move handled
  with a compression is three turns, and that is fine -- there is no step cap, only the
  budget.
- **Do the three turns while the move is pending, never after the marker.** The marker
  releases the next move; if you compress after releasing it, two moves are pending and one
  version is never displayed.
- **Rebuild from the recall, not from memory.** Read every row off the `[query_memory]`
  reply, apply the one cell, and check you have sixteen rows of sixteen tuples before you
  print. A summary is a paraphrase and is never a source for the board.
- **Every summary stays in your context for the rest of the run** and is never compressed
  again, so compress as late as 24,000 allows, and never twice in a row.

Every print is a copy of your OWN last printed block with one cell changed, so when the
board is still in front of you, copy it from there and do not query. Never re-print an older
version and never shorten the block: it is graded character for character.

A NEW BOARD message carries a fresh board and its version id: copy that board tuple for tuple
into your next print, with the id it names. The version id always comes from the message you
are applying, never from your own count. If a turn fails, the move was not applied; apply the
missed move as its own `cat` command, then the move that just arrived as a second `cat` in the
same turn, with the marker on the last one.

What confirms a compression is the `[summary_id: N]` message and a gauge lower than the turn
before; what confirms a recall is a reply with sixteen rows; what confirms a move is your
block coming back in the command output with the version the message named. Never send
`echo READY_FOR_NEXT_OP` on its own: it releases a move for a version you never displayed.

### Also keep your own trace short

One command per move turn, no prose, no plans, no notes, no restating the move. Never write
the board to a file -- grading reads your context, not disk. When the harness tells you the
run is ending, spend that last turn printing the current board.
