"""Token counting and the per-turn snapshot format."""

from __future__ import annotations

import json
from pathlib import Path

from contextbench import tokens as tk


def test_count_tokens_reports_its_method() -> None:
    n, method = tk.count_tokens([{"role": "user", "content": "hello world"}])
    assert n > 0
    assert method.startswith("tiktoken:") or method.startswith("approx_chars")


def test_count_tokens_grows_with_content() -> None:
    small, _ = tk.count_tokens([{"role": "user", "content": "one line"}])
    large, _ = tk.count_tokens([{"role": "user", "content": "one line " * 200}])
    assert large > small
    assert tk.count_tokens([])[0] == 0
    assert tk.count_tokens(None)[0] == 0


def test_tool_call_arguments_are_counted() -> None:
    """A tool-heavy agent keeps most of its bytes in the call arguments."""
    plain = [{"role": "assistant", "content": "ok"}]
    with_call = [
        {
            "role": "assistant",
            "content": "ok",
            "tool_calls": [
                {
                    "function": {
                        "name": "bash",
                        "arguments": json.dumps({"command": "echo " + "x" * 400}),
                    }
                }
            ],
        }
    ]
    assert tk.count_tokens(with_call)[0] > tk.count_tokens(plain)[0]


def test_structured_content_is_counted() -> None:
    n, _ = tk.count_tokens(
        [{"role": "user", "content": [{"type": "text", "text": "hello world"}]}]
    )
    assert n > 0


def test_count_text_fallback_is_chars_over_three(monkeypatch) -> None:
    monkeypatch.setattr(tk, "get_encoder", lambda: None)
    monkeypatch.setattr(tk, "_ENCODER_NAME", "_failed", raising=False)
    text = "a" * 300
    assert tk.count_text(text) == 100
    assert tk.encoder_name() == "approx_chars3"


def test_record_snapshot_shape(tmp_path: Path) -> None:
    messages = [
        {"role": "system", "content": "sys"},
        {"role": "user", "content": "op 0"},
        {"role": "assistant", "content": "READY_FOR_NEXT_OP"},
    ]
    path = tk.record_snapshot(tmp_path, 7, messages, {"n_ops_delivered": 1})
    assert path == tmp_path / "context_snapshots" / "turn-0007.json"
    obj = json.loads(path.read_text(encoding="utf-8"))
    assert obj["step"] == 7
    assert obj["n_messages"] == 3
    assert obj["n_ops_delivered"] == 1
    assert obj["tokens"] > 0
    assert obj["token_method"]
    assert obj["messages"] == messages
    # The accounting comes before the bulk, so a human reading the file sees it first.
    assert list(obj)[-1] == "messages"


def test_snapshot_paths_are_in_turn_order(tmp_path: Path) -> None:
    for step in (3, 1, 12, 2):
        tk.record_snapshot(tmp_path, step, [{"role": "user", "content": "x"}])
    assert [p.name for p in tk.snapshot_paths(tmp_path)] == [
        "turn-0001.json",
        "turn-0002.json",
        "turn-0003.json",
        "turn-0012.json",
    ]


def test_record_snapshot_never_raises(tmp_path: Path) -> None:
    """Snapshotting is a logging side effect: it must not break a run."""
    blocked = tmp_path / "file"
    blocked.write_text("not a directory", encoding="utf-8")
    assert tk.record_snapshot(blocked, 1, [{"role": "user", "content": "x"}]) is None
