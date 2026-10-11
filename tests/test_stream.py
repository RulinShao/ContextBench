"""The turn protocol: rendering, readiness, and what does not count as readiness."""

from __future__ import annotations

import pytest

from contextbench import stream as proto
from contextbench.stream import Op, render_op


def test_render_op_counts_what_follows() -> None:
    op = Op(index=0, header="set batch (keys 0-99)", body="SET K00000 = x")
    assert render_op(op, remaining=3) == (
        "=== set batch (keys 0-99) (3 op(s) remaining after this) ===\n"
        "SET K00000 = x"
    )
    assert "(0 op(s) remaining after this)" in render_op(op, remaining=0)


@pytest.mark.parametrize(
    "reply",
    [
        "READY_FOR_NEXT_OP",
        "done.\nREADY_FOR_NEXT_OP",
        "done.\n  READY_FOR_NEXT_OP  \n",
        "done.\n`READY_FOR_NEXT_OP`",
        "kept 4 lines.\nREADY_FOR_NEXT_OP\n",
    ],
)
def test_standalone_line_advances(reply: str) -> None:
    assert proto.is_ready_line(reply)


@pytest.mark.parametrize(
    "reply",
    [
        "",
        "I will say READY_FOR_NEXT_OP when I am done.",
        "grep READY_FOR_NEXT_OP notes.txt",
        "the value is READY_FOR_NEXT_OP_2",
        "<<<ANSWER key=K1>>>\nREADY_FOR_NEXT_OP is in the value\n<<<ANSWER END>>>",
    ],
)
def test_non_standalone_line_does_not_advance(reply: str) -> None:
    assert not proto.is_ready_line(reply)


@pytest.mark.parametrize(
    "command",
    [
        "echo READY_FOR_NEXT_OP",
        "/bin/echo READY_FOR_NEXT_OP",
        "echo 'READY_FOR_NEXT_OP'",
        "printf '<<<ANSWER key=K1>>>\\n'; echo READY_FOR_NEXT_OP",
        "cat notes.txt && echo READY_FOR_NEXT_OP",
    ],
)
def test_standalone_command_advances(command: str) -> None:
    assert proto.is_ready_command(command)


@pytest.mark.parametrize(
    "command",
    [
        "grep READY_FOR_NEXT_OP notes.txt",
        "printf 'READY_FOR_NEXT_OP'",
        "echo READY_FOR_NEXT_OP > /dev/null",
    ],
)
def test_non_standalone_command_does_not_advance(command: str) -> None:
    assert not proto.is_ready_command(command)


def test_a_failed_command_never_advances() -> None:
    """A non-zero exit means the step did not finish, so the op must not be spent."""
    assert not proto.is_ready_command("echo READY_FOR_NEXT_OP", exit_code=1)
    assert not proto.is_ready_command("ls missing && echo READY_FOR_NEXT_OP", exit_code=2)


def test_submit_matching() -> None:
    assert proto.is_submit_line("COMPLETE_TASK_AND_SUBMIT_FINAL_OUTPUT")
    assert proto.is_submit_command("echo COMPLETE_TASK_AND_SUBMIT_FINAL_OUTPUT")
    assert not proto.is_submit_line(
        "I would run COMPLETE_TASK_AND_SUBMIT_FINAL_OUTPUT but the stream is open."
    )
    assert proto.mentions_submit_marker(
        "I would run COMPLETE_TASK_AND_SUBMIT_FINAL_OUTPUT later."
    )


def test_protocol_texts_name_the_marker() -> None:
    for text in (
        proto.REFUSE_SUBMIT_TEXT,
        proto.EXPLAIN_NON_STANDALONE_TEXT,
        proto.NO_MARKER_TEXT,
        proto.MARKER_PARAGRAPH,
        proto.MARKER_PARAGRAPH_REPLY,
    ):
        assert proto.ADVANCE_MARKER in text
    assert proto.SUBMIT_MARKER in proto.SUBMIT_PARAGRAPH


def test_terminated_by_is_the_closed_set() -> None:
    assert set(proto.TERMINATED_BY) == {
        "submit",
        "stream_exhausted",
        "budget_wall",
        "timeout",
        "max_steps",
    }


def test_heredoc_body_is_data_not_a_readiness_statement():
    """An echo line inside a here-document never runs, so it must not advance."""
    from contextbench.stream import is_ready_command, is_submit_command

    assert not is_ready_command("cat <<EOF\nX\necho READY_FOR_NEXT_OP\nEOF")
    assert not is_ready_command("cat <<'EOF'\nboard\necho READY_FOR_NEXT_OP\nEOF")
    assert not is_ready_command("cat <<-EOF\n\techo READY_FOR_NEXT_OP\n\tEOF")
    assert not is_ready_command('python3 -c "print(1)\necho READY_FOR_NEXT_OP"')
    assert not is_submit_command("cat <<EOF\necho COMPLETE_TASK_AND_SUBMIT_FINAL_OUTPUT\nEOF")
    # The marker on the heredoc's opening line, or after the terminator, still counts.
    assert is_ready_command("python3 - <<'PY' && echo READY_FOR_NEXT_OP\nimport re\nPY")
    assert is_ready_command("cat <<'EOF'\nboard\nEOF\necho READY_FOR_NEXT_OP")
    assert is_ready_command("echo 'a\nb'\necho READY_FOR_NEXT_OP")


@pytest.mark.parametrize(
    "command",
    [
        # The review case: separators inside one single-quoted argument are data.
        "printf '%s' 'before;echo READY_FOR_NEXT_OP;after'",
        "printf '%s' 'x && echo READY_FOR_NEXT_OP'",
        "printf '%s' 'x || echo READY_FOR_NEXT_OP'",
        'printf "%s" "before;echo READY_FOR_NEXT_OP;after"',
        'printf "%s" "say \\"hi\\"; echo READY_FOR_NEXT_OP"',
        "echo before\;echo READY_FOR_NEXT_OP",
        "printf '%s' 'unterminated; echo READY_FOR_NEXT_OP",
        "echo 'a\nb; echo READY_FOR_NEXT_OP'",
    ],
)
def test_separators_inside_quotes_do_not_advance(command: str) -> None:
    assert not proto.is_ready_command(command)


@pytest.mark.parametrize(
    "command",
    [
        "printf '%s' 'a;b'; echo READY_FOR_NEXT_OP",
        'printf "%s;%s\\n" x y && echo READY_FOR_NEXT_OP',
        "printf '%s' 'it''s; fine' || true; echo READY_FOR_NEXT_OP",
        "cat <<'EOF' > board.txt\nrow; with; semicolons\nEOF\necho READY_FOR_NEXT_OP",
    ],
)
def test_a_clean_echo_after_quoted_separators_advances(command: str) -> None:
    assert proto.is_ready_command(command)


def test_submit_inside_quotes_does_not_count() -> None:
    assert not proto.is_submit_command(
        "printf '%s' 'x;echo COMPLETE_TASK_AND_SUBMIT_FINAL_OUTPUT;y'")
