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

Your STARTING sketchpad (version 0):

```
<<<SKETCHPAD BEGIN>>>
VERSION: 0
(1,1,.) (1,2,.) (1,3,.) (1,4,.) (1,5,G) (1,6,.) (1,7,.) (1,8,.) (1,9,.) (1,10,.) (1,11,.) (1,12,.) (1,13,.) (1,14,7) (1,15,A) (1,16,.)
(2,1,.) (2,2,.) (2,3,.) (2,4,.) (2,5,1) (2,6,3) (2,7,.) (2,8,.) (2,9,.) (2,10,A) (2,11,4) (2,12,.) (2,13,.) (2,14,.) (2,15,E) (2,16,.)
(3,1,9) (3,2,.) (3,3,.) (3,4,.) (3,5,6) (3,6,.) (3,7,.) (3,8,.) (3,9,.) (3,10,E) (3,11,.) (3,12,5) (3,13,3) (3,14,C) (3,15,B) (3,16,1)
(4,1,.) (4,2,.) (4,3,.) (4,4,.) (4,5,9) (4,6,.) (4,7,A) (4,8,.) (4,9,1) (4,10,.) (4,11,.) (4,12,.) (4,13,.) (4,14,.) (4,15,.) (4,16,6)
(5,1,.) (5,2,F) (5,3,.) (5,4,.) (5,5,.) (5,6,.) (5,7,.) (5,8,8) (5,9,.) (5,10,.) (5,11,.) (5,12,.) (5,13,1) (5,14,B) (5,15,.) (5,16,D)
(6,1,.) (6,2,.) (6,3,.) (6,4,G) (6,5,.) (6,6,.) (6,7,.) (6,8,A) (6,9,D) (6,10,5) (6,11,.) (6,12,B) (6,13,6) (6,14,.) (6,15,.) (6,16,3)
(7,1,3) (7,2,.) (7,3,.) (7,4,.) (7,5,.) (7,6,.) (7,7,5) (7,8,.) (7,9,2) (7,10,.) (7,11,.) (7,12,.) (7,13,.) (7,14,.) (7,15,.) (7,16,.)
(8,1,.) (8,2,5) (8,3,.) (8,4,.) (8,5,.) (8,6,.) (8,7,.) (8,8,.) (8,9,.) (8,10,.) (8,11,6) (8,12,.) (8,13,9) (8,14,A) (8,15,F) (8,16,.)
(9,1,B) (9,2,.) (9,3,.) (9,4,C) (9,5,E) (9,6,5) (9,7,4) (9,8,.) (9,9,.) (9,10,.) (9,11,F) (9,12,.) (9,13,.) (9,14,.) (9,15,.) (9,16,.)
(10,1,.) (10,2,.) (10,3,.) (10,4,.) (10,5,.) (10,6,.) (10,7,.) (10,8,.) (10,9,.) (10,10,.) (10,11,.) (10,12,9) (10,13,5) (10,14,G) (10,15,4) (10,16,E)
(11,1,E) (11,2,4) (11,3,.) (11,4,.) (11,5,.) (11,6,.) (11,7,2) (11,8,.) (11,9,B) (11,10,.) (11,11,.) (11,12,1) (11,13,F) (11,14,.) (11,15,.) (11,16,.)
(12,1,A) (12,2,.) (12,3,.) (12,4,7) (12,5,.) (12,6,F) (12,7,3) (12,8,.) (12,9,E) (12,10,4) (12,11,5) (12,12,.) (12,13,C) (12,14,1) (12,15,.) (12,16,B)
(13,1,F) (13,2,.) (13,3,.) (13,4,A) (13,5,.) (13,6,.) (13,7,.) (13,8,.) (13,9,.) (13,10,.) (13,11,E) (13,12,4) (13,13,.) (13,14,D) (13,15,.) (13,16,.)
(14,1,.) (14,2,1) (14,3,3) (14,4,.) (14,5,.) (14,6,B) (14,7,.) (14,8,D) (14,9,.) (14,10,.) (14,11,.) (14,12,2) (14,13,.) (14,14,4) (14,15,.) (14,16,.)
(15,1,.) (15,2,.) (15,3,.) (15,4,E) (15,5,.) (15,6,.) (15,7,6) (15,8,2) (15,9,.) (15,10,G) (15,11,B) (15,12,.) (15,13,.) (15,14,3) (15,15,.) (15,16,.)
(16,1,.) (16,2,.) (16,3,.) (16,4,B) (16,5,.) (16,6,.) (16,7,9) (16,8,4) (16,9,.) (16,10,1) (16,11,.) (16,12,.) (16,13,.) (16,14,2) (16,15,.) (16,16,F)
<<<SKETCHPAD END>>>
```

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
