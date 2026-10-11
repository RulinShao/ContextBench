# Needle Retention — final-context graded (interactive)

A long stream is delivered to you in pieces, ONE AT A TIME, as messages in this
conversation. You do NOT fetch them: each piece arrives automatically as the next
user message, and you receive the following piece only after you finish the
current turn. Each piece looks like:

```
NEEDLES (keep these lines verbatim in your context):
[n00007i03#a1b2c3d4] ...            <- needle, KEEP
[n00007i04#...] ...
<<<FILLER-BLOCK 00007#ab12cd34 START -- filler below, through the END line>>>
[f00007x000#...] ...                <- filler
... many filler lines ...
<<<FILLER-BLOCK 00007#ab12cd34 END>>>
```

## Your task

By the end, every **needle** (the lines tagged `[nNNNNNiNN#...]`) from every piece
must still be present, **verbatim, in your context window**.

## How you are graded

Your answer is read **only from your final context window** — what is still
visible when the run ends. There is **no answer file**; do **not** write to disk
(disk is ignored by the grader).

## Turn protocol (IMPORTANT)

Each incoming message is ONE piece. Do the work it needs FIRST (drop its filler
block, keep its needles), then end your turn by running this single command with
the `bash` tool to receive the next piece:

```
echo READY_FOR_NEXT_OP
```

This is a multi-turn task: the harness RUNS this command and then delivers the
next piece as the next user message. ONLY running `echo READY_FOR_NEXT_OP`
advances to the next piece — a reply with no tool call does NOT advance (it just
prompts you to keep going). Do NOT run the marker until you have handled the
current piece (dropped its filler).
The run ends automatically after the final piece; you do not need to submit.
