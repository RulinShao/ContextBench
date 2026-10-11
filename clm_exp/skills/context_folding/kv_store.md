## Every op stays in MAIN: spend the budget on the stream, and do not open a branch

Every operation is delivered to this conversation — MAIN — and stays there; no tool removes a
message from MAIN. You also have `branch(description, prompt)`, which starts a sub-agent from
a COPY of your current context, and `return(summary)`, which ends it: the sub-agent's turns
are folded away and MAIN gets back one line, "Branch ... finished ... Returned summary:
<text>". A branch begins from a copy of a context that already holds every batch and cannot
delete anything from MAIN, so MAIN is as full after it as before. A `SET-BATCH` carries 100
`SET <key> = <value>` lines and runs to about 19,600 characters — roughly 5K tokens — and
MAIN's usable 30,720 tokens hold about six of those, a number no sub-agent changes. The GET
ops arrive only after the batches, so nothing a branch produces comes back as something MAIN
can answer from, and branch turns come from the same global turn budget as your own. So
on a `SET-BATCH`, run one command in MAIN and nothing else:

```
echo READY_FOR_NEXT_OP
```

Three things about it matter:

- **Do not open a branch.** The one line it returns costs MAIN context like any other text,
  and its turns are turns the stream does not get.
- **Do not copy batches to disk.** A `cat` heredoc paste duplicates the batch into MAIN as your
  own text: it costs the full size of what it stores, removes nothing, and buys no recall you
  do not already have.
- **Keep the marker standalone, and write no running notes.** Anything bundled into that
  command adds text and output for no return; a line of prose per batch is a second stream
  alongside the real one.

When a `GET <key>` arrives, answer in MAIN — only ANSWER blocks in MAIN's context are scored —
by finding the `SET <key> = ` line in the batch in front of you and printing its value:

```
printf '<<<ANSWER key=K00084>>>\n%s\n<<<ANSWER END>>>\n' "<the value, copied exactly>"; echo READY_FOR_NEXT_OP
```

Keys arrive in contiguous ranges, so go to the batch whose range covers the key and read the
line there. Copy the whole value — every word, in order, with the original spacing — to
the end of the line. The values are random tokens and grading compares them character by
character, so a dropped word or a tidied-up space scores the same as no answer. An ANSWER
block you have already printed stays counted, so never spend a turn reprinting one.

What tells you where you stand is the `[context: ~N/M tokens]` readout after every command: it
should rise by the size of each batch and by almost nothing else. What confirms an answer is
the value coming back between `<<<ANSWER key=...>>>` and `<<<ANSWER END>>>`.

**Also keep your own trace short.**

Nothing in MAIN is ever reclaimed, so every line you write is subtracted from the stream MAIN
can still receive. One command per batch turn, no notes and no acknowledgements. A batch is
roughly 5K tokens against MAIN's usable 30,720, so a paragraph of prose per batch costs you a
whole batch of keys before the end; read the `[context: ~N/M tokens]` line as a countdown, the
gap between N and M divided by about 5K being how many more batches you can still take in.

If you do open a branch, open exactly one and give it a prompt that ends in a single line of
fact. Its turns come out of the same global budget as the turns that move the stream, and the
line it returns lands in MAIN as text like any other, so a branch that returns a paragraph has
spent twice: once in turns, once in MAIN's context. Keys arrive in contiguous ranges, so the
batch that holds `K00084` is the one whose range covers it, and reading it in MAIN costs nothing
a branch could save.

Never emit an empty ANSWER block. Never run the marker inside a branch: operations are
delivered to MAIN only, so a marker run in a sub-agent advances no stream and spends a turn
from the shared budget. Never ask a branch to print an ANSWER block: it is folded away on
return and never reaches MAIN. Never paraphrase, truncate or re-space a value;
print exactly the text that follows `SET <key> = `.
