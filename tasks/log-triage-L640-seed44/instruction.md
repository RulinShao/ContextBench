# Incident Log Triage - process graded (interactive)

You are an on-call engineer. A long service log is streamed to you in batches,
followed by incident questions. Operations are delivered to you ONE AT A TIME, as
messages in this conversation. You do NOT fetch them: each operation arrives
automatically as the next user message, and you receive the following operation
only after you finish the current turn. There are two kinds of operations:

- A **LOG-BATCH** block, delimited by unique `<<<LOG-BATCH <id> BEGIN ...>>>` /
  `<<<LOG-BATCH <id> END>>>` sentinel lines and carrying many log lines of the form:

```
<ISO-timestamp> [LEVEL] <service> req=<id> <message> #<tag>
```

- A **QUERY** - `QUERY <n>: <question>` about the log seen so far. Questions are
  either an exact lookup (the message of a line with a given `req=<id>`) or a
  count (how many lines match a given level + service).

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
command — in fact the cleanest way to answer a QUERY is to emit the ANSWER block
and the marker together, e.g.:

```
printf '<<<ANSWER qid=3>>>\n%s\n<<<ANSWER END>>>\n' "$ans"; echo READY_FOR_NEXT_OP
```

ONLY running `echo READY_FOR_NEXT_OP` advances to the next operation — a reply
with no tool call does NOT advance (it just prompts you to keep going). Do NOT run
the marker until you have fully handled the current operation (offloaded the
batch, or emitted the QUERY ANSWER block).

## How to answer a QUERY

Reply (in that same turn) with an **ANSWER block** on its own lines:

```
<<<ANSWER qid=<n>>>>
<your answer: the exact message text, or the integer count>
<<<ANSWER END>>>
```

You are NOT told the questions in advance, so you must be able to consult the
**entire** log when a QUERY arrives.

## How you are graded

Process-graded: for every `QUERY`, the ANSWER block you emit must be correct.
Grading reads your **context** (the ANSWER blocks across your turns). You MAY use
the disk as scratch/storage, but FINDING a value (e.g. with `grep`) is NOT
answering — only an ANSWER block that actually appears in your context is scored,
so you must PRINT the value inside `<<<ANSWER ...>>>` ... `<<<ANSWER END>>>`.
The run ends automatically after the final operation; you do not need to submit.
