## Your method: delivered pieces stay in MAIN, so keep the window for the stream

Every piece arrives as a user message in MAIN and stays there, needles and filler together.
You have two extra tools, `branch` and `return`: `branch` starts a sub-agent from a COPY of
your current context, and when it calls `return(summary)` its own turns are folded away and
MAIN receives only "Branch ... finished ... Returned summary: <text>". That folding applies
to the sub-agent's turns and nothing else -- a branch cannot delete anything that is already
in MAIN, and the filler you would want gone is already in MAIN before your turn begins.
Pieces are delivered to MAIN only, so a marker run inside a branch delivers nothing, and the
branch's turns come out of the same global turn budget as yours.

So your context is everything delivered plus everything you write, the `[context: ~N/M
tokens]` readout after each bash result is the whole picture, and when it passes the budget
you get one final turn and the run ends -- with every needle line still visible counting. The
score is how much of the stream you take in before the window fills, and the only part of
that you control is your own text.

Per piece, one command, nothing before it and nothing after it:

```
echo READY_FOR_NEXT_OP
```

Three things about it matter:

- **Do not open a branch.** It starts from a copy of a context that already holds this
  chunk's filler, it cannot remove that filler, and whatever it returns arrives as a summary
  message in MAIN -- a second copy of needle lines you already hold, bought with turns from
  the same budget.
- **Never re-type a needle.** It is already in your context verbatim, exactly as the grader
  wants it. A second copy is worth nothing and costs the same as the first, so each one is
  about one needle line of stream you will not live to receive.
- **No notes and no printing.** Your turns and your tool output are mirrored into the same
  window as the stream; a few lines of commentary per piece adds up to a chunk of needles
  across the run.

How the task gets answered: it answers itself. Each delivered chunk puts its needle lines
into your context verbatim, and your job is to keep receiving chunks for as long as the
budget allows while adding nothing of your own.

What confirms it worked: after each marker, `[context: ~N/M tokens]` should rise by about one
chunk and by nothing else. If it rises by more, the difference is something you wrote, and it
is coming out of the end of the run.

**Also keep your own trace short.** Nothing in MAIN is ever reclaimed -- not by a branch, not by
anything else -- so your own text is the only part of the window you decide, and every token of
it is subtracted from the stream MAIN still gets to receive. One command per piece, and that
command is the marker.

**Read the readout as a countdown.** After each marker, `[context: ~N/M tokens]` tells you what
the stream has taken. A chunk is about 15,600 characters, roughly 3.9K tokens; the gap between N
and M divided by that is how many more pieces MAIN can take in. It should move by one chunk per
piece and by nothing else.

**If you open a branch at all, open one and keep it short.** Its turns come out of the same
global budget as the turns that receive pieces, and the summary it returns is a message in MAIN
like any other -- so a branch that returns needle lines has bought you a second copy of lines
you already hold, paid for in both turns and window. There is no reading task here that MAIN
cannot do in place.

Never run the marker inside a branch -- nothing is delivered and the turn is spent. Never
write needles to disk: the grader ignores disk, and the heredoc that would paste them there
puts a second full copy in your context on the way. Never reply without a tool call: it does
not advance the stream and the reply still costs you window.
