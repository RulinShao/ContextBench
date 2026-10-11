## Keep your context small: compress the filler with `manage_context`, then put the needle lines back with `query_memory`

Grading reads the needle lines out of your FINAL context: a line counts if it appears there
by itself as a whole line, exactly as delivered. Every piece arrives as a user message,
needles and filler together, and nothing leaves your context by itself: there is no
automatic compaction and no reminder. You have two tools besides `bash`, and they are the
whole method:

- **`manage_context`** takes no arguments. It takes everything since your previous
  `manage_context` call (or since this task message, on the first call), up to and including
  the turn in which you call it, and replaces it with one message `[summary_id: N] <summary>`.
  The summary is written by a separate call to the same model, asked for a `## Knowledge
  state` and a `## Thoughts` section with identifiers preserved verbatim. The original
  messages are saved verbatim by the harness as summary N; `bash` cannot read them.
- **`query_memory(summary_id, query)`** has the same model read the saved originals of one
  summary and return what matches your query as compact bullets, prefixed
  `[query_memory: summary_id=N]`. The result is an ordinary tool result that stays in your
  context until the next `manage_context`.

A compressed piece is gone from the final context, and a summary that describes the needles
scores zero: only a whole needle line still in the context counts. So the method is a cycle,
and the cycle is the whole job:

1. Release pieces with the marker while the `[context: ~N/M tokens]` gauge is below 22,000.
   A chunk is about 3.9K tokens; the budget is 32,768, about 30,720 usable.
2. When the gauge is above 22,000, call `manage_context` on your next turn. This is a turn of
   its own: one tool call per turn, never bundled with a command.
3. On the turn after the `[summary_id: N]` message, call `query_memory(N, "every needle line
   in these messages, verbatim, one per bullet, nothing else")`. The recall reply is capped at
   about 2,000 tokens, so if the pieces held more needles than fit, ask in slices by chunk
   number and keep asking until the bullets stop.
4. Put the recalled lines back as whole lines with one command, copying each exactly, and
   release the next piece on the same line:

```
printf '%s\n' '<needle line 1>' '<needle line 2>' '<needle line 3>'; echo READY_FOR_NEXT_OP
```

A bullet (`- ...`) is not the line itself; the line must stand alone, exactly as delivered.
Then the cycle repeats: the reprinted lines are compressed with the next `manage_context`,
and the next `query_memory` on the newest summary returns them again together with the new
ones, because they were whole lines in that summary's originals. Always query the newest
summary; it holds everything you had materialised plus the pieces since.

Four things about the cycle matter:

- **Never re-type a needle while its piece is still in context.** The line is already there;
  a second copy costs the same as the first.
- **22,000 is the last safe point.** Past about 25,000 a piece arriving on top of what you
  hold ends the run with one final turn, and whatever was compressed but not reprinted is
  lost from the graded context.
- **Every summary stays in your context for the rest of the run** and is never compressed
  again, so compress late enough that each covers several pieces.
- **The reprint is the only text you ever add.** No notes, no commentary, no restating the
  task, no needles written to disk -- the grader ignores disk and reads your context.

Per piece, when you are not compressing or recalling, one command and nothing else:

```
echo READY_FOR_NEXT_OP
```

What confirms it worked: after each marker the gauge should rise by about one chunk and by
nothing else; after a compression the `[summary_id: N]` message appears and the gauge drops;
after a recall the `[query_memory: summary_id=N]` bullets carry the lines, and your `printf`
puts them back as whole lines in a command output. Never reply without a tool call: a reply
with no call does not advance the stream, and it still costs window. When the harness says
the run is ending, spend the last turn on `query_memory` and the reprint, not on the marker.
