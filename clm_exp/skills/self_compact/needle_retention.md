## You decide when your history is replaced: replace it with the needle lines

Once your retained context passes about a third of the budget (roughly 12.1K of 32,768), the
harness sends you a probe every second step asking for four lines: C1 are you at a closed
unit of work, C2 is the work so far summarizable (with three to five cite-able facts), C3 has
there been progress, N1 are you stuck. Compression happens only when C1=Y, C2=Y, C3=Y and
N1=N. Answer the probe in plain text, not with a tool call. On compression your whole history
is replaced by: the system prompt, this task, one assistant message "Here is my research so
far:" followed by the summary you wrote, and one user message "Continue your research. Use
your tools to find the answer, or provide your final answer if you have enough information."
Every delivered piece turn is dropped, including the piece that arrived a moment ago.

Grading reads the needle lines out of your FINAL context, so after a compression the only
place a needle can be is that summary. The summary is therefore the needle lines, one per
line, verbatim, and nothing else -- no prose around them, no filler, no headings.

Per piece, one command and nothing else:

```
echo READY_FOR_NEXT_OP
```

On a probe turn, plain text:

```
C1: Y
C2: Y -- [n00001i00#a1b2c3d4] ... / [n00001i01#7f0c22de] ... / [n00002i00#3ba91c05] ...
C3: Y
N1: N
```

and the summary you hand over is every needle line you hold, one per line, copied character
for character.

Four things about it matter:

- **Always Y, Y, Y, N.** There is no probe that is too early. The needle lines are the entire
  content of the summary and they fit -- the stream is built so the mass you must keep is at
  most half the usable window. Every probe you decline leaves that chunk's filler block in
  your context, and the window fills with filler instead of stream.
- **Copy forward what is already under "Here is my research so far".** Each compression
  rewrites the summary from scratch from what you can see; the previous summary is your only
  record of the early chunks. Read its lines out and write them again, then add the lines
  from the chunks delivered since.
- **Include the chunk that just arrived.** Its turn is dropped by the same compression, so
  its needles must already be in the text you write.
- **Verbatim lines only.** Id, `#hash`, and the words after it, unwrapped and untrimmed.
  "All needles from chunks 1-12 retained as delivered" scores zero; the lines themselves are
  the answer.

What confirms it worked: your context now begins with "Here is my research so far:" followed
by your needle lines, then "Continue your research...". Count those lines against the chunks
you have received. The `[context: ~N/M tokens]` readout on your next command shows the drop.
Then run the marker again -- that is what releases the next piece.

**Also keep your own trace short.** Your own turns are what push you past the 12.1K probe
threshold in the first place, and at a compression they compete with your needles for room in
the summary you are writing. So an ordinary piece turn is the marker and nothing else: no
reasoning in the context, no per-chunk notes, no plans. The needle lines are the only text worth
spending the window on.

**A worked compression.** Suppose chunks 1 to 9 have arrived and the probe comes on the turn
after chunk 9. C2's cite-able facts are needle lines, so name three of them there, and the
summary you hand over is every needle line you hold -- the ones under the previous "Here is my
research so far:", then chunks 1 to 9's, including chunk 9's, whose turn this compression will
drop. Twelve lines of needles is a correct summary; a paragraph describing them is not.

Never answer the probe with a tool call, and never answer N1=Y. Never write the needles to
disk (the grader ignores disk). Never replace a needle line with a summary of it.
