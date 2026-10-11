## You are a Recursive Language Model here: operations arrive as REPL variables, and your Python state is your store

This harness has no `bash` tool and no `READY_FOR_NEXT_OP` marker: the shell commands and the
marker described above do not exist for you, and nothing you write as plain text is a tool call.
Every operation is
delivered instead into ONE persistent Python REPL variable, `context`: the first operation is the whole of
`context`, and every later operation is APPENDED to its end -- `context` is the whole stream so far and grows
between turns; each operation inside it begins with its own `=== ... ===` header line.
**The newest operation is ALWAYS the LAST block of `context`:** `context[context.rfind("=== "):]`. Take only that
last block on every operation after the first -- the front of `context` is the oldest operation, not the current one. Your conversation is CONTINUOUS across operations: this task text is sent once, each new operation is appended to
`context`, every earlier turn of yours stays in your message history, and **the REPL namespace
persists**: every variable and function you define survives from one operation to the next. That
persistence is your store, and nothing else is.

You release the next operation by submitting: set `answer["content"]` to your reply for this
operation and `answer["ready"] = True` inside one ```repl``` block. Whatever is in
`answer["content"]` is appended to your transcript verbatim and is exactly what the grader reads,
so a GET is answered by placing the ANSWER block there -- not by printing it.

**Code runs only inside a correctly fenced block.** Every block you want executed must open with a line
that is exactly ```repl and close with a line that is exactly ``` (three backticks, nothing else on the
line). A block closed with `</repl>`, a block whose closing line is missing, or a reply that is prose
with no block at all executes NOTHING -- the turn is silently wasted, no output comes back, and the
operation is not advanced. Before you send a reply, check that its last line is ``` and that exactly one
```repl opener precedes it.

Handle every operation in two turns. Turn 1 (you may not submit yet): look at your state and the
head of the newest context, the newest being the last block of `context`:

```repl
print(SHOW_VARS()); print(len(context)); print(context[context.rfind("=== "):][:200])
```

Turn 2: process it and submit. On the first operation define the store and the handler once;
on every later operation only call them:

```repl
import re
kv = {}
def take(ctx):
    for k, v in re.findall(r"^SET (K\d+) = (.*)$", ctx, re.M):
        kv[k] = v.rstrip()
def reply(ctx):
    m = re.search(r"^GET (K\d+)", ctx, re.M)
    if m is None:
        take(ctx); return "stored %d keys so far" % len(kv)
    k = m.group(1); v = kv.get(k)
    return None if v is None else "<<<ANSWER key=%s>>>\n%s\n<<<ANSWER END>>>" % (k, v)
out = reply(context); print(out)
answer["content"] = out; answer["ready"] = True
```

Later operations are one line of work: `out = reply(context[context.rfind("=== "):]); print(out); answer["content"] = out; answer["ready"] = True`.

Four things about this matter:

- **Values verbatim, tag included.** A value is everything after `SET <key> = ` to the end of
  its line, including the trailing `#xxxxxxxx` tag. Never trim, reformat or re-type it: the regex
  copies it exactly, and the ANSWER block must carry that exact string.
- **Parse only the newest context, once.** Every batch is parsed on the operation that delivered
  it. Re-reading the front of `context` is harmless but costs turns.
- **Never print a whole batch.** REPL output over ~20K characters is truncated, and everything
  you print is carried in this conversation's window. Print counts and single values.
- **No sub-LLM is needed.** `llm_query` is for text a regex cannot pin; every SET and GET line
  here is mechanical. Python is exact and instant; a sub-LLM paraphrases and can drop a tag.

If `kv.get(k)` comes back `None`, the store lost a batch (a REPL error or timeout reset your
variables, and `SHOW_VARS()` on turn 1 will have shown no `kv`). Rebuild before answering: run `take(b)` over every block of `context` (`for b in context.split("
=== ")`) -- then answer.
Never submit an empty ANSWER block or a guessed value; if a key is absent even after rebuilding,
put a one-line note in `answer["content"]` with no ANSWER block.

What confirms it is working: `print(out)` shows `stored N keys so far` growing by one batch per
SET operation, and on a GET it shows the ANSWER block with the full value ending in its `#` tag
before you submit. `SHOW_VARS()` listing `kv` and `reply` on turn 1 is the sign your state
is still present.

Never set `answer["ready"] = True` before `answer["content"]` holds the reply. Never answer from
memory of an earlier conversation -- the dictionary is the only verbatim copy. Never write batches
to files or ask a sub-LLM to summarise them: the REPL variable already holds them exactly.
