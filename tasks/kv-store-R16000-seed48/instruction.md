# Key-Value Store - process graded (interactive)

Operations are delivered to you ONE AT A TIME, as messages in this conversation.
You do NOT fetch them: each operation arrives automatically as the next user
message, and you receive the following operation only after you finish the
current turn. The stream has two phases:

1. a long run of **SET-BATCH** blocks, each delimited by unique
   `<<<SET-BATCH <id> BEGIN ...>>>` / `<<<SET-BATCH <id> END>>>` sentinel lines and
   carrying many lines of the form `SET <key> = <value>` (each `<value>` is a
   random, unguessable token; each key is set exactly once), then
2. a run of **GET** ops at the end: `GET <key>` - report the value you stored
   earlier for `<key>`.

Because every `SET` arrives before any `GET`, you cannot predict which keys will
be queried - you must be able to recall **any** value you have seen.

## Turn protocol (IMPORTANT)
Each incoming message is ONE operation. Do whatever work it needs FIRST (offload,
`grep`, emit an ANSWER block, ...). When you are done with the current operation,
**end your turn** by running this single command with the `bash` tool to receive
the next operation:

```
echo READY_FOR_NEXT_OP
```

This is a multi-turn task: the harness RUNS this command and then delivers the
next operation as the next user message. You MAY bundle real work into the SAME
command — in fact the cleanest way to answer a GET is to pipe the stored value
straight into an ANSWER block and emit the marker together, e.g.:

```
printf '<<<ANSWER key=K00084>>>\n%s\n<<<ANSWER END>>>\n' "$val"; echo READY_FOR_NEXT_OP
```

ONLY running `echo READY_FOR_NEXT_OP` advances to the next operation — a reply
with no tool call does NOT advance (it just prompts you to keep going). Do NOT run
the marker until you have fully handled the current operation (offloaded the
batch, or emitted the GET ANSWER block).

## How to answer a GET

When you read a `GET <key>`, reply with an **ANSWER block** on its own lines,
carrying the value **verbatim**:

```
<<<ANSWER key=<key>>>>
<the exact value you stored for <key>>
<<<ANSWER END>>>
```

## How you are graded

Process-graded: for every `GET`, the ANSWER block you emit must contain the
correct value. Grading reads your **context** (the ANSWER blocks across your
turns). You MAY use the disk as scratch/storage, but FINDING a value (e.g. with
`grep`) is NOT answering — only an ANSWER block that actually appears in your
context is scored, so you must PRINT the value inside `<<<ANSWER ...>>>` ...
`<<<ANSWER END>>>`.
The run ends automatically after the final operation; you do not need to submit.
