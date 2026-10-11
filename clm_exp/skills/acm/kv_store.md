## Keep your context small: call `manage_context` before a batch would overflow it, `query_memory` to read a value back

The values are far too many to keep in your context, and you cannot predict which keys will
be queried. Nothing leaves your context by itself: there is no automatic compaction and no
reminder. You have two tools besides `bash`, and they are the whole method:

- **`manage_context`** takes no arguments. It takes everything since your previous
  `manage_context` call (or since this task message, on the first call), up to and including
  the turn in which you call it, and replaces it with one message `[summary_id: N] <summary>`.
  The system prompt and this task message are never included. The summary is written by a
  separate call to the same model, which sees the compressed messages as `[role] text`
  blocks and is asked for a `## Knowledge state` and a `## Thoughts` section, identifiers
  preserved verbatim. The original messages are saved verbatim by the harness as summary N;
  they are not in the sandbox and `bash` cannot read them.
- **`query_memory(summary_id, query)`** has the same model read the saved originals of one
  summary and return what matches your query as compact bullets that keep identifiers and
  values verbatim, prefixed `[query_memory: summary_id=N]`. The result is an ordinary tool
  result: it stays in your context until the next `manage_context` compresses it.

A `SET-BATCH` carries 100 `SET <key> = <value>` lines and costs about 5K tokens. The budget
is 32,768 tokens, about 30,720 usable, and the `[context: ~N/M tokens]` line after every
command is your gauge. **The rule: read the gauge after every batch; when it is above
22,000, call `manage_context` on your very next turn, before you release another batch.**
Below that, release the next batch with the marker and nothing else:

```
echo READY_FOR_NEXT_OP
```

Four things about the rule matter:

- **One tool call per turn.** A `manage_context` call is a turn of its own: call it, read
  the `[summary_id: N]` message that comes back, then send the marker on the next turn.
  Never bundle it with a command.
- **22,000 is the last safe point.** A batch is 5K and your own turns cost too; past 25,000 a
  batch arriving on top of what you hold ends the run, with one final turn, no rollback and
  no retry. Compress late enough that each summary covers several batches, because every
  summary stays in your context for the rest of the run and is never compressed again.
- **A summary is a paraphrase; a value is exact only in the `SET` line.** After a compression
  the exact values of those batches live in the saved originals, reachable only through
  `query_memory` on that summary's id. Summaries are numbered in order, and batches arrive
  in key order, so summary 1 covers the lowest key ranges, summary 2 the next, and so on.
- **Do not copy batches to disk and do not write notes.** A heredoc paste puts a second copy
  of the batch into your context; a running note costs budget until it is compressed and
  then costs the summarizer space.

The GETs arrive after all the batches. When `GET <key>` arrives and the batch whose range
covers the key is still in your context, print the value from its `SET <key> = ` line:

```
printf '<<<ANSWER key=K00084>>>\n%s\n<<<ANSWER END>>>\n' "<the value, copied exactly>"; echo READY_FOR_NEXT_OP
```

If that batch was compressed, spend one turn on `query_memory(N, "the SET line for key
K00084, verbatim")` with N the summary whose range covers the key (keys arrive in contiguous
ranges, so the summary whose Knowledge state lists neighbouring keys is the one), then print
the value from the returned bullet the same way on the next turn. Every `query_memory` result
stays in context, so during the GETs keep reading the gauge and call `manage_context` again
when it passes 22,000: answers already printed stay counted after they are compressed.

Copy the whole value, every word in order with the original spacing, and stop at the end of
the line. Grading compares character by character; answer each GET on the turn it arrives and
never reprint one.

What confirms a compression is the `[summary_id: N]` message and a `[context: ~N/M tokens]`
readout lower than the turn before. What confirms an answer is the ANSWER block coming back
in the command output. Never emit an empty ANSWER: if `query_memory` returns nothing for the
key, query the neighbouring summary id, and only then answer.

### Also keep your own trace short

One command per batch turn, no plans, no acknowledgements, no per-batch confirmations:
everything you write is compressed along with the batches and is what the summarizer has to
cover. Never paraphrase, truncate or re-space a value. The run ends automatically after the
final operation; you do not need to submit.
