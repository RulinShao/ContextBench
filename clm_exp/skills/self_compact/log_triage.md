## You decide when your context is compressed: store every batch, then pass the check

Once your retained context passes about 37% of its budget (~12.1K of 32,768), the harness
sends you a probe every two steps asking four yes/no lines: C1 closed unit, C2
summarizable (with 3-5 cite-able facts), C3 progress, N1 stuck. Your history is replaced by
a summary you write only if C1=Y, C2=Y, C3=Y and N1=N. Answer that probe in plain text, no
tool call; it is not an operation and does not take the marker. On compression everything
becomes: this task text, your own "Here is my research so far: <summary>", and "Continue
your research ...". Every delivered batch is dropped. This is the only way your context
shrinks, so if the four checks never pass together the stream simply runs you out of
budget. The disk survives. On the SAME turn a `LOG-BATCH` arrives -- a block of 14, 27 or 54
log lines, between about 2,500 and 8,900 characters -- copy it into its own file and release
the next operation, in one command:

```
mkdir -p /tmp/store && cat > /tmp/store/log-0000.log <<'BATCH_EOF'
<the whole block, from its <<<LOG-BATCH 0000#a1b2c3d4 BEGIN ...>>> line through its
<<<LOG-BATCH 0000#a1b2c3d4 END>>> line, copied exactly>
BATCH_EOF
grep -q 'LOG-BATCH 0000.* END>>>' /tmp/store/log-0000.log && grep -cE '^[0-9]{4}-' /tmp/store/log-0000.log && echo READY_FOR_NEXT_OP
```

Three things about it matter:

- **A distinct file per batch.** Reuse one name and each batch overwrites the last.
- **The printed number must equal B-A+1** from that batch's `log batch (lines A-B)`
  header; that is your proof the paste was complete, not truncated.
- **`&&` before the marker,** so a paste that lost the END sentinel does not release the
  next batch on top of the one you failed to store.

Answer the probe so that compression happens as soon as every batch delivered so far is
verified on disk:

```
C1: Y - the last operation is a completed, verified batch store.
C2: Y - facts: batches 0000-0007 are stored verbatim in /tmp/store/log-<id>.log; the log
covers lines 0-2399; a lookup is grep -hE '^[0-9]{4}-.* req=<id> ' /tmp/store/*.log; a
count is grep -h '[LEVEL] <service> req=' /tmp/store/*.log | wc -l; nothing in the batches
needs to be remembered.
C3: Y - batches 0004-0007 stored since the last compression.
N1: N
```

Your summary on compression is those same facts in two lines and the id of the last batch
stored. If the most recent paste has not verified, answer `C1: N`, finish the store on the
next turn and pass the probe that follows two steps later; never answer Y while a batch is
in your context but not on disk, because compression then drops it for good.

Every batch is delivered before the first `QUERY`, so by query time the whole log must be
on disk. Before answering any count, check the total:

```
grep -hE '^[0-9]{4}-' /tmp/store/*.log | wc -l
```

It has to equal B+1 of the last `log batch (lines A-B)` header you saw. A missing batch is
silently absent from every count while lookups elsewhere still succeed, so nothing warns
you. Then answer:

```
n=$(grep -h '\[ERROR\] auth-svc req=' /tmp/store/*.log | wc -l)
printf '<<<ANSWER qid=12>>>\n%s\n<<<ANSWER END>>>\n' "$n"; echo READY_FOR_NEXT_OP
```

```
msg=$(grep -hE '^[0-9]{4}-.* req=ab12cd34 ' /tmp/store/*.log | head -1 | sed 's/^.* req=[^ ]* //')
test -n "$msg" && printf '<<<ANSWER qid=3>>>\n%s\n<<<ANSWER END>>>\n' "$msg" && echo READY_FOR_NEXT_OP
```

**Also keep your own trace short.** Your own turns are what carry you back over the 12.1K probe
threshold, so keep them to the paste and its printed count: one short line per batch, no running
inventory of what is stored, no plans. The probe answer is text too -- four lines of fact and a
pointer to the files, never log lines. And the summary you write is the whole of what you keep,
so a longer one is not a safer one: the same two facts in more tokens simply bring the next
probe forward and cost you the batches that would have fitted.

**What confirms a compression** is a history that now begins with your own "Here is my research
so far:" followed by those facts, and a `[context: ~N/M tokens]` readout back near zero. The
probe turn is not an operation, so after answering it run `echo READY_FOR_NEXT_OP` to resume the
stream. What confirms a store is the count printed by `grep -cE '^[0-9]{4}-'` matching B-A+1 for
that batch's header.

Use `grep -h ... | wc -l` and not `grep -c` across several files: `grep -c` prints one
number per file. Never emit an empty ANSWER: if `grep` returns nothing the batch is still
in your context, so answer from there and then store it. Never answer a query from memory,
never put log lines into the summary instead of the file, and never `cat` a stored file
back into your context.
