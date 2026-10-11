## You are a Recursive Language Model here: pieces arrive as REPL variables, and only your submitted reply is your context

This harness has no `bash` tool and no `READY_FOR_NEXT_OP` marker: the shell commands and the
marker described above do not exist for you, and nothing you write as plain text is a tool call.
Every piece is
delivered instead into ONE persistent Python REPL variable, `context`: the first piece is the whole of
`context`, and every later piece is APPENDED to its end -- `context` is the whole stream so far and grows
between turns; each piece inside it begins with its own `=== ... ===` header line.
**The newest piece is ALWAYS the LAST block of `context`:** `context[context.rfind("=== "):]`. Take only that
last block on every piece after the first -- the front of `context` is the oldest piece, not the current one. Your conversation is CONTINUOUS across pieces: this task text is sent once, each new piece is appended to
`context`, every earlier turn of yours stays in your message history, and **the REPL namespace
persists**: every
variable and function you define survives from one piece to the next.

This changes what "your context window" means for grading. The pieces never enter your
conversation -- they sit in REPL variables, which the grader does not read. What the grader reads
is your transcript, and the only text you add to it, apart from what you print, is the reply you
submit: set `answer["content"]` to a string and `answer["ready"] = True` inside one ```repl```
block, and that string is appended to your transcript verbatim and the next piece is delivered.
So the needles are kept by **submitting them as your reply, one needle per line, every piece**.

**Code runs only inside a correctly fenced block.** Every block you want executed must open with a line
that is exactly ```repl and close with a line that is exactly ``` (three backticks, nothing else on the
line). A block closed with `</repl>`, a block whose closing line is missing, or a reply that is prose
with no block at all executes NOTHING -- the turn is silently wasted, no output comes back, and the
piece is not advanced. Before you send a reply, check that its last line is ``` and that exactly one
```repl opener precedes it.

Handle every piece in two turns. Turn 1 (you may not submit yet): look at your state and the length
of the newest piece -- never its text -- the newest being the last block of `context`:

```repl
print(SHOW_VARS()); print(len(context)); print(context[context.rfind("=== "):][:200])
```

Turn 2: gather and submit. On the first piece define the store and the handler once; on every
later piece only call it:

```repl
import re
needles = []
def keep(ctx):
    for l in re.findall(r"^\[n\d+i\d+#[0-9a-f]+\].*$", ctx, re.M):
        if l not in needles: needles.append(l)
    return "\n".join(needles)
out = keep(context); print(len(needles), "needles kept")
answer["content"] = out; answer["ready"] = True
```

Later pieces are one line of work: `out = keep(context[context.rfind("=== "):]); print(len(needles), "needles kept"); answer["content"] = out; answer["ready"] = True`.

Four things about this matter:

- **Every needle, every piece.** The reply carries the whole set so far, not just the new ones.
  The string is built in Python, so its size costs you nothing to write, and each submission is a
  complete, self-contained copy in your transcript: a later failure can never take it back.
- **One needle per line, verbatim.** Grading matches whole lines. The regex takes the full needle
  line from its `[n` tag to its final period; never re-type, trim, sort into one line, or number
  them. `"\n".join(...)` is the whole formatting.
- **`^\[n` and nothing looser.** It takes needle lines only and skips the `<<<FILLER-BLOCK ...>>>`
  sentinels and every `[f...]` filler line. Filler in your reply is harmless to the score but
  bloats the transcript for nothing.
- **Never print any part of a piece, not even a head or a sample line.** Whatever you print lands in the
  transcript; a needle line printed by accident would be graded as kept when you never kept it. Print
  lengths and counts only; the needle lines travel in your submitted reply and nowhere else.

If `SHOW_VARS()` on turn 1 shows no `needles`, your variables were reset (a REPL error or timeout).
Rebuild before submitting: run `keep(b)` over every block of `context` (`for b in context.split("
=== ")`) and submit the full set.

What confirms it is working: the printed count grows by the needles in the newest piece (the
piece header says how many pieces there are; each carries the same number of `[n...]` lines), and
it never falls. On the final piece the count equals the total needle count, and your last reply
holds them all.

Never submit an empty reply on a piece that carried needles. Never hand a piece to a sub-LLM to
"extract" the needles -- `llm_query` paraphrases and a paraphrased needle is a lost needle; the
regex is exact. Never write needles to disk: disk is not graded. Never set
`answer["ready"] = True` before `answer["content"]` holds the joined lines.
