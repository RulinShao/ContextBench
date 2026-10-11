## Your method: MAIN is append-only -- do the reading in a `branch`, print the ANSWER in MAIN

Every operation is delivered into MAIN, lands in your context and stays there; you have no
tool that removes a message. `branch(description, prompt)` starts a sub-agent from a COPY of
your current context; its turns are folded away and all that comes back when it calls
`return(summary)` is one line, "Branch ... finished ... Returned summary: <text>". A branch
cannot delete anything already in MAIN and operations are delivered to MAIN only, so it
cannot keep a batch out of your context: your budget is still the stream, 32,768 tokens with
about 30,720 usable, and the run ends with one final turn when you exceed it. What a branch
does buy you is that long work -- scanning twenty batches and adding up matches -- happens in
the sub-agent's turns and costs MAIN a single line. On a `LOG-BATCH`, release the next
operation in MAIN and do nothing else; there is nothing to fold away yet:

```
echo READY_FOR_NEXT_OP
```

Three things about it matter:

- **An ANSWER block emitted inside a branch is not in MAIN and is not graded.** Whatever the
  branch returns, print it yourself in MAIN inside the block.
- **Never run `echo READY_FOR_NEXT_OP` inside a branch.** A marker run in a branch does not
  advance the stream; it only burns turns. Release the operation in MAIN after the return.
- **Branch turns come out of the same global turn budget,** so branch once per count query
  and tell the sub-agent to return as soon as it has the number.

The whole log is delivered before the first `QUERY`, so when a query arrives it is all in
MAIN. A lookup is one scan; answer it in MAIN directly, printing everything after the
`req=` id, the trailing `#` tag included:

```
printf '<<<ANSWER qid=3>>>\n%s\n<<<ANSWER END>>>\n' 'timeout retry connection refused #ff00aa11'; echo READY_FOR_NEXT_OP
```

A count is what the branch is for. Call `branch` with a description like
`count [ERROR] auth-svc` and this prompt:

> Run `rm -f /tmp/tally.txt` first. Go through the log batches in this context in
> `log batch (lines A-B)` order. For each batch count the lines matching
> `[ERROR] auth-svc req=` and append that number with `echo <n> >> /tmp/tally.txt`, one per
> batch, zeros included. Then run
> `wc -l < /tmp/tally.txt; awk '{s+=$1} END {print s}' /tmp/tally.txt`. Call `return` with
> exactly: `<total> from <k> batches covering lines 0-<B>`.

The `rm -f` matters: without it a second query adds its numbers to the first query's tally
and every later count is too high. Check the return against the headers you saw in MAIN --
`k` must be the number of batches delivered and `B+1` the length of the whole log -- and
re-branch naming the missing range if they disagree. Then answer in MAIN:

```
printf '<<<ANSWER qid=12>>>\n%s\n<<<ANSWER END>>>\n' '137'; echo READY_FOR_NEXT_OP
```

What confirms it worked is the returned line carrying both the total and the coverage, and
the `[context: ~N/M tokens]` readout in MAIN barely moving across a branch.

**Also keep your own trace short.** Nothing in MAIN is ever reclaimed, so every line you write
in MAIN is subtracted from the stream MAIN can still receive. One command per batch turn, no
notes and no acknowledgements; put the long work inside a branch, where the turns fold away, and
bring back one line. A branch prompt is worth writing carefully for that reason: name the
pattern exactly as the query names it, say in what order to walk the batches, and say what
single line to return. Anything a branch returns beyond that line is text MAIN carries for the
rest of the run.

Read the `[context: ~N/M tokens]` readout in MAIN as a countdown: it should rise by about one
batch per delivered operation and by almost nothing across a branch. If it rises by more, the
difference is your own text, and it comes out of the end of the run.

Never copy batches to disk from MAIN: the heredoc is a MAIN turn, so it stores the batch a
second time in the context and removes nothing. Never branch in order to store or summarize
the log -- a branch cannot shrink MAIN and MAIN ends at the same point either way. Never
emit an empty ANSWER, and keep answering while the readout is near the budget: a block
emitted on the final turn is scored like any other.
