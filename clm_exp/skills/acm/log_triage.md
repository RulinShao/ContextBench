## Keep your context small: call `manage_context` before a batch would overflow it, `query_memory` to read the log back

The log is far too large to keep in your context. Nothing leaves your context by itself:
there is no automatic compaction and no reminder. You have two tools besides `bash`, and
they are the whole method:

- **`manage_context`** takes no arguments. It takes everything since your previous
  `manage_context` call (or since this task message, on the first call), up to and including
  the turn in which you call it, and replaces it with one message `[summary_id: N] <summary>`.
  The system prompt and this task message are never included. The summary is written by a
  separate call to the same model, which sees the compressed messages as `[role] text`
  blocks and is asked for a `## Knowledge state` and a `## Thoughts` section, identifiers
  preserved verbatim. The original messages are saved verbatim by the harness as summary N;
  they are not in the sandbox and `bash` cannot read them.
- **`query_memory(summary_id, query)`** has the same model read the saved originals of one
  summary and return what matches your query as compact bullets that keep identifiers,
  messages and numbers verbatim, prefixed `[query_memory: summary_id=N]`. The result is an
  ordinary tool result: it stays in your context until the next `manage_context`.

The whole log is delivered before the first `QUERY`, in `LOG-BATCH` blocks under `log batch
(lines A-B)` headers. The budget is 32,768 tokens, about 30,720 usable, and the `[context:
~N/M tokens]` line after every command is your gauge. **The rule: read the gauge after every
batch; when it is above 22,000, call `manage_context` on your very next turn, before you
release another batch.** Below that, release the next batch with the marker and nothing else:

```
echo READY_FOR_NEXT_OP
```

Four things about the rule matter:

- **One tool call per turn.** A `manage_context` call is a turn of its own: call it, read the
  `[summary_id: N]` message that comes back, then send the marker on the next turn.
- **22,000 is the last safe point.** Past about 25,000 a batch arriving on top of what you
  hold ends the run, with one final turn, no rollback and no retry. Compress late enough that
  each summary covers several batches: every summary stays in your context for the rest of
  the run and is never compressed again.
- **A summary is a paraphrase; a line is exact only in the batch.** After a compression the
  lines of those batches live in the saved originals, reachable only through `query_memory`
  on that summary's id. Summaries are numbered in order and batches arrive in line order, so
  summary 1 covers the lowest line ranges, summary 2 the next, and so on; the header ranges
  the summary lists tell you which.
- **Do not copy batches to disk and do not write notes.** A heredoc paste puts a second copy
  of the batch into your context; a running note costs budget until it is compressed.

A lookup asks for the message of the line carrying a given `req=` id. If that line is in a
batch still in your context, print everything after the id, the trailing `#` tag included:

```
printf '<<<ANSWER qid=3>>>\n%s\n<<<ANSWER END>>>\n' 'timeout retry connection refused #ff00aa11'; echo READY_FOR_NEXT_OP
```

If the batch was compressed, spend one turn on `query_memory(N, "the full log line with
req=<id>, verbatim")` for the summary whose line ranges cover it, then print from the
returned bullet on the next turn.

A count is over the whole log, every batch from the first to the last: count the lines
matching the level and service the question names in each batch, one number per header,
zeros included, and let the shell add them up:

```
n=$(printf '%s\n' 7 3 0 5 9 2 | awk '{s+=$1} END {print s}')
printf '<<<ANSWER qid=12>>>\n%s\n<<<ANSWER END>>>\n' "$n"; echo READY_FOR_NEXT_OP
```

For compressed batches the per-batch numbers must come from somewhere exact: from
`query_memory(N, "for each log batch header covered, the number of lines with level <X> and
service <Y>, one number per header")`, one query per summary, never from the summary's prose.
A count is the one answer that comes back wrong without looking wrong, so check completeness
against the headers before you trust the sum: the batches run `lines 0-A`, `lines A+1-C`, ...
with no gap, and you must have exactly one number per header, from context or from a query.

Every `query_memory` result stays in context, so during the queries keep reading the gauge
and call `manage_context` again when it passes 22,000: answers already printed stay counted
after they are compressed.

What confirms a compression is the `[summary_id: N]` message and a `[context: ~N/M tokens]`
readout lower than the turn before. What confirms an answer is the ANSWER block coming back
in the command output. Never emit an empty ANSWER: if a query returns nothing, query the
neighbouring summary id, and only then answer.

### Also keep your own trace short

One command per batch turn, no plans, no notes, no per-batch confirmations: everything you
write is compressed along with the batches and is what the summarizer has to cover. Never
paste log lines into a file and never re-print a batch. When the readout says you are close
to the budget, keep answering: a block emitted on the final turn is scored like the first.
