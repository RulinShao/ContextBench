## You decide when your history is compressed: have every batch on disk before you say yes

Past 12.1K tokens (0.37 of the 32,768 budget) the harness sends a probe every two steps asking
four lines: C1, is the last unit of work closed; C2, is the work so far summarizable, with 3–5
cite-able facts; C3, has there been progress; N1, are you stuck. Compression happens only when
C1=Y, C2=Y, C3=Y, N1=N. Then your whole history is replaced by this task message, an
assistant message "Here is my research so far:" carrying your summary, and a user message
telling you to continue. Every delivered op turn is dropped, so a batch that exists only in
your context is gone. The disk is untouched. So on the SAME turn a `SET-BATCH` arrives, copy
the whole block — all 100 `SET` lines, about 19,600 characters — to its own file and release
the next op, with only the batch id substituted:

```
mkdir -p /tmp/store && cat > /tmp/store/kv-0000.txt <<'EOF'
<paste the block exactly, from its <<<SET-BATCH 0000#... BEGIN line through its <<<SET-BATCH 0000#… END>>> line>
EOF
grep -q 'SET-BATCH 0000.* END>>>' /tmp/store/kv-0000.txt && grep -c '^SET ' /tmp/store/kv-0000.txt && echo READY_FOR_NEXT_OP
```

Four things about it matter:

- **A distinct file name per batch** (`kv-0000.txt`, `kv-0001.txt`, ...). One reused name and
  every value but the newest batch's is overwritten.
- **The quoted `'EOF'` delimiter.** Values may contain `$`, backticks or backslashes; an
  unquoted delimiter lets the shell rewrite them, and grading compares character by character.
- **The `&&` chain on the END sentinel.** A truncated paste fails `grep -q`, the marker does
  not run, and you get the turn back with the batch still in your context.
- **Same turn, never later.** The probe can arrive after any step, and the compression it
  authorizes drops every op turn. A batch is safe only once its file exists.

A batch plus its paste is roughly 10K tokens, so you are back over the 12.1K probe threshold
about every second batch. That is expected once the batch is on disk: never hold compression
off to keep a batch in view.

Answer the probe in plain text, with no tool call; that reply is not an op, so run
`echo READY_FOR_NEXT_OP` on your next turn to resume the stream. Answer so that
compression fires as soon as everything you have seen is on disk:

```
C1: Y - the batch delivered last turn is written and verified.
C2: Y - all SET batches 0000-00NN are stored verbatim in /tmp/store/kv-<id>.txt; a value is
recovered with grep -h '^SET <key> = ' /tmp/store/*.txt; the last batch stored is 00NN.
C3: Y - <n> further batches stored since the last compression.
N1: N
```

If a batch you were given is not yet on disk, answer C1 with N, store it, and pass the
next probe two steps later. When a `GET <key>` arrives:

```
v=$(grep -h "^SET K00084 = " /tmp/store/*.txt 2>/dev/null | head -1 | sed 's/^SET [^ ]* = //')
[ -n "$v" ] && printf '<<<ANSWER key=K00084>>>\n%s\n<<<ANSWER END>>>\n' "$v" && echo READY_FOR_NEXT_OP
```

What confirms a store is the count `grep -c` prints back, equal to 100. What confirms a
compression is a history that now starts from "Here is my research so far:" and a
`[context: ~N/M tokens]` readout back near zero.

**Also keep your own trace short.**

Your own turns are what carry you back over the 12.1K probe threshold, so keep them to the paste
and its printed count: one short line per batch, no inventory of what is stored, no plans. The
probe answer is text too -- four lines of fact and a pointer to the files, never a list of
values. And the summary you hand over is the whole of what you keep, so a longer summary is not
a safer one: the same pointer in more tokens brings the next probe forward.

Never emit an empty ANSWER block: if the guard suppressed it and the batch is still in your
context, answer from there -- keys arrive in contiguous ranges, so it is the batch whose range
covers the key -- then store that batch. Never put values in the probe answer
instead of the file, never claim a batch is stored before its count printed, and never answer
the probe with a tool call.
