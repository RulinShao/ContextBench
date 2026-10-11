# Sudoku Sketchpad — process graded (interactive)

You maintain a **sketchpad**: a Sudoku board that lives in your context window. A
sequence of moves is delivered to you ONE AT A TIME, as messages in this
conversation. You do NOT fetch them: each move arrives automatically as the next
user message, and you receive the following move only after you finish the
current turn.

## The sketchpad format

The whole board sits between two sentinel lines as one **`(row,col,value)` tuple
per cell**, row-major. `value` is a digit if placed, `.` if still empty. A
`VERSION: <n>` line just below the BEGIN line tracks how many moves have been
applied (the starting board is version 0). Values are single chars `1`–`9`, then
`A`, `B`, … for 10+. Example (4x4):

```
<<<SKETCHPAD BEGIN>>>
VERSION: <n>
(1,1,v) (1,2,v) ... (1,N,v)
(2,1,v) (2,2,v) ... (2,N,v)
...
(N,1,v) (N,2,v) ... (N,N,v)
<<<SKETCHPAD END>>>
```

Each cell is uniquely identified by its `(row,col,` prefix. Reproduce this format
exactly (real tuples, not the `v` placeholders above). Your STARTING sketchpad is
below; keep it in this format.

{initial_block}

## Each move

Every incoming message is one move `Place S in cell rXcY` (rows count from the
top, columns from the left) and the new version id. Applying it means: bump the
version id and change that cell's tuple `(X,Y,.)` to `(X,Y,S)`. Leave every other
tuple unchanged. Once a move is applied to your sketchpad, the move message and
your working turns for it are stale.

This is a long session of several puzzles. When a board is finished, the next
message is a **NEW BOARD** action that gives you a fresh board and its version id:
replace your whole sketchpad with it and carry on. The version id keeps counting
up across all boards.

## How you are graded

After every move your board (the tuples between the `<<<SKETCHPAD BEGIN>>>` /
`<<<SKETCHPAD END>>>` sentinels) must be exactly correct — cell for cell — and you
are scored on how many of the per-move states are correct across the whole process.
Grading reads your context window, **not** disk — do **not** write the board to a
file.

## Keeping your board in your context (required — every method)

Grading reads ONLY your context (not disk), so after each move the current board
must be visible in your context. IMPORTANT: a turn with no tool call is rejected
as a format error — you cannot keep the board just by writing it as plain text in
your reply. You must SURFACE the board into your context through a tool call,
using your context-management method described below.


## Turn protocol (IMPORTANT)

Each incoming message is ONE move. Apply it (bump the version, edit that one cell)
and SURFACE the updated board into your context, then end your turn by running
this with the `bash` tool to receive the next move:

```
echo READY_FOR_NEXT_OP
```

This is a multi-turn task: the harness RUNS this command and then delivers the
next move as the next user message. If your method surfaces the board with a
`bash` `printf`, you MAY bundle it with the marker in one command, e.g.
`printf '<<<SKETCHPAD BEGIN>>>...board...<<<SKETCHPAD END>>>\n'; echo READY_FOR_NEXT_OP`.
ONLY running `echo READY_FOR_NEXT_OP` advances to the next move — a reply with no
tool call does NOT advance. The run ends automatically after the final move; you
do not need to submit.
