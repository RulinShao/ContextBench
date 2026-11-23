"""Token counting and per-turn context snapshots.

Every part of ContextBench that asks "how big is this context right now?" goes
through :func:`count_tokens`: exact ``o200k_base`` counts when ``tiktoken`` can be
imported, and a ``len // 3`` character estimate otherwise, so the package works
with no optional dependency and no network.

Per-turn context snapshots are the graders' source of truth: an agent that offloads
content to disk and reads a value back only transiently still has that value captured
in the snapshot of the turn where it surfaced. A harness writes them through
:class:`SnapshotLog`, into a *snapshot root* that the agent cannot reach (for Harbor,
``<trial_dir>/contextbench_harness/``, next to the mounted ``agent/`` directory; see
:func:`harness_dir_for`). Every write appends a line with the file's sha256 to
``snapshot_manifest.jsonl`` in the root, and the harness closes the manifest when the
run ends. The graders accept only manifest-listed, unmodified files from a closed
manifest; a write that fails raises :class:`SnapshotWriteError` and leaves the
manifest marked as failed, so the run is graded as invalid rather than silently
graded from whatever is left.
"""

from __future__ import annotations

import hashlib
import json
import os
import shutil
from pathlib import Path
from typing import Any, Iterator

__all__ = [
    "HARNESS_DIRNAME",
    "MANIFEST_NAME",
    "SNAPSHOT_DIRNAME",
    "SnapshotLog",
    "SnapshotWriteError",
    "count_text",
    "count_tokens",
    "get_encoder",
    "harness_dir_for",
    "iter_text",
    "record_snapshot",
    "snapshot_paths",
]

SNAPSHOT_DIRNAME = "context_snapshots"

#: The snapshot root of a Harbor trial: ``<trial_dir>/contextbench_harness``. Harbor
#: mounts only ``agent/``, ``verifier/`` and ``artifacts/logs/artifacts`` of the trial
#: directory into the container, so this sibling of ``agent/`` is host-only.
HARNESS_DIRNAME = "contextbench_harness"

#: One JSON line per snapshot written, then a closing line; lives in the snapshot root.
MANIFEST_NAME = "snapshot_manifest.jsonl"
MANIFEST_VERSION = 1

#: The character-per-token divisor used when tiktoken is unavailable.
FALLBACK_CHARS_PER_TOKEN = 3

_ENCODER: Any = None
_ENCODER_NAME: str | None = None


def get_encoder() -> Any:
    """A cached ``tiktoken`` encoder, or ``None`` when tiktoken is unavailable.

    Defaults to ``o200k_base``; ``TIKTOKEN_ENCODING`` overrides it and
    ``cl100k_base`` is the second choice (its vocabulary may be cached when
    ``o200k_base`` is not).
    """
    global _ENCODER, _ENCODER_NAME
    if _ENCODER is not None or _ENCODER_NAME == "_failed":
        return _ENCODER
    try:
        import tiktoken
    except Exception:
        _ENCODER_NAME = "_failed"
        return None
    for name in (os.environ.get("TIKTOKEN_ENCODING") or "o200k_base", "cl100k_base"):
        try:
            _ENCODER = tiktoken.get_encoding(name)
            _ENCODER_NAME = name
            return _ENCODER
        except Exception:
            continue  # e.g. the vocabulary download is blocked offline
    _ENCODER_NAME = "_failed"
    return None


def encoder_name() -> str:
    """The method label that :func:`count_tokens` reports."""
    get_encoder()
    if _ENCODER_NAME in (None, "_failed"):
        return f"approx_chars{FALLBACK_CHARS_PER_TOKEN}"
    return f"tiktoken:{_ENCODER_NAME}"


def iter_text(messages: list[Any] | None) -> Iterator[str]:
    """Yield every text piece of ``messages`` that reaches the model.

    This includes ``tool_calls[*].function.arguments``, where a shell command
    lives: a tool-heavy agent keeps most of its bytes there, so counting only
    ``content`` would undercount the real prompt by roughly a factor of two.
    """
    for msg in messages or []:
        content: Any
        if isinstance(msg, dict):
            reasoning = msg.get("reasoning_content")
            if isinstance(reasoning, str):
                yield reasoning
            content = msg.get("content")
            for call in msg.get("tool_calls") or []:
                fn = call.get("function") if isinstance(call, dict) else None
                if isinstance(fn, dict):
                    if fn.get("name"):
                        yield str(fn["name"])
                    if fn.get("arguments"):
                        yield str(fn["arguments"])
        else:
            content = msg
        if isinstance(content, str):
            yield content
        elif isinstance(content, list):
            for item in content:
                if isinstance(item, dict):
                    yield str(item.get("text") or item.get("content") or "")
                else:
                    yield str(item)


def count_text(text: str) -> int:
    """Token count of one string (exact with tiktoken, else ``len // 3``)."""
    if not text:
        return 0
    enc = get_encoder()
    if enc is None:
        return max(1, len(text) // FALLBACK_CHARS_PER_TOKEN)
    return len(enc.encode(text, disallowed_special=()))


def count_tokens(messages: list[Any] | None) -> tuple[int, str]:
    """Token count over a message list. Returns ``(tokens, method)``."""
    total = sum(count_text(piece) for piece in iter_text(messages))
    return total, encoder_name()


def snapshot_paths(root: Path | str) -> list[Path]:
    """Every ``context_snapshots/turn-*.json`` under ``root``, in turn order."""
    import re

    d = Path(root) / SNAPSHOT_DIRNAME
    if not d.is_dir():
        return []

    def _turn(path: Path) -> int:
        m = re.search(r"turn-(\d+)", path.name)
        return int(m.group(1)) if m else -1

    return sorted(d.glob("turn-*.json"), key=_turn)


def harness_dir_for(logs_dir: Path | str) -> Path:
    """The host-only snapshot root of a Harbor agent whose logs dir is ``logs_dir``.

    Harbor's agent logs dir is ``<trial_dir>/agent``, mounted at ``/logs/agent``; the
    root is its sibling ``<trial_dir>/contextbench_harness``, which is not mounted.
    """
    return Path(logs_dir).resolve().parent / HARNESS_DIRNAME


class SnapshotWriteError(RuntimeError):
    """A context snapshot (or its manifest line) could not be written."""


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _append_line(path: Path, record: dict[str, Any]) -> None:
    with path.open("a", encoding="utf-8") as fh:
        fh.write(json.dumps(record, sort_keys=True) + "\n")
        fh.flush()


def _write_snapshot(root: Path, step: int, messages: list[Any],
                    extra: dict[str, Any] | None) -> tuple[Path, int, str]:
    d = root / SNAPSHOT_DIRNAME
    d.mkdir(parents=True, exist_ok=True)
    tokens, method = count_tokens(messages)
    payload: dict[str, Any] = {
        "step": step,
        "tokens": tokens,
        "token_method": method,
        "n_messages": len(messages or []),
    }
    if extra:
        payload.update(extra)
    payload["messages"] = messages
    out = d / f"turn-{step:04d}.json"
    if out.exists():
        raise SnapshotWriteError(f"{out} already exists: snapshot steps must be unique")
    data = (json.dumps(payload, indent=2, default=str) + "\n").encode("utf-8")
    out.write_bytes(data)
    _append_line(root / MANIFEST_NAME, {
        "step": step, "file": out.name, "sha256": _sha256(data), "tokens": tokens,
        "token_method": method, "kind": payload.get("kind"),
    })
    return out, tokens, method


class SnapshotLog:
    """The per-turn snapshots of one run, in a root the agent cannot reach.

    ``SnapshotLog(root)`` starts a fresh log (an earlier run's snapshots and manifest
    in ``root`` are removed, so they can never be credited to this run).
    :meth:`record` writes one snapshot and its manifest line and raises
    :class:`SnapshotWriteError` on any failure; :meth:`close` writes the closing line
    the graders require. A log that saw a failed write closes with
    ``"failed": true``, which the graders treat as an invalid run.
    """

    def __init__(self, root: Path | str, *, fresh: bool = True):
        self.root = Path(root)
        self.n = 0
        self.failed: str | None = None
        self.closed = False
        try:
            if fresh:
                shutil.rmtree(self.root / SNAPSHOT_DIRNAME, ignore_errors=True)
                (self.root / MANIFEST_NAME).unlink(missing_ok=True)
            self.root.mkdir(parents=True, exist_ok=True)
            if fresh:
                _append_line(self.root / MANIFEST_NAME,
                             {"header": True, "version": MANIFEST_VERSION})
        except Exception as exc:
            raise SnapshotWriteError(f"cannot start a snapshot log in {self.root}: "
                                     f"{exc}") from exc

    @property
    def snapshot_dir(self) -> Path:
        return self.root / SNAPSHOT_DIRNAME

    def record(self, step: int, messages: list[Any],
               extra: dict[str, Any] | None = None) -> tuple[Path, int]:
        """Write ``turn-<step>.json``; return ``(path, tokens)``. Raises on failure."""
        try:
            path, tokens, _ = _write_snapshot(self.root, step, list(messages or []), extra)
        except Exception as exc:
            self.failed = f"step {step}: {type(exc).__name__}: {exc}"
            raise exc if isinstance(exc, SnapshotWriteError) else \
                SnapshotWriteError(self.failed) from exc
        self.n += 1
        return path, tokens

    def close(self, **info: Any) -> None:
        """Append the closing line (``closed``, ``n_snapshots``, ``failed`` + ``info``).

        May be called more than once (a harness may close, then record a final
        snapshot, then close again); the graders read the last line.
        """
        record = {"closed": True, "n_snapshots": self.n, "failed": self.failed, **info}
        try:
            _append_line(self.root / MANIFEST_NAME, record)
        except Exception as exc:
            raise SnapshotWriteError(f"cannot close the snapshot manifest in "
                                     f"{self.root}: {exc}") from exc
        self.closed = True


def record_snapshot(
    root: Path | str,
    step: int,
    messages: list[Any],
    extra: dict[str, Any] | None = None,
) -> Path:
    """Write one snapshot and its manifest line into ``root``; raise on failure.

    Writes ``<root>/context_snapshots/turn-NNNN.json`` holding ``step``, ``tokens``,
    ``token_method``, ``n_messages``, anything in ``extra``, and the ``messages``
    themselves (last, so a human reading the file sees the accounting first), and
    appends its sha256 to ``<root>/snapshot_manifest.jsonl``. A harness should use
    :class:`SnapshotLog`, which also starts and closes the manifest; the graders do
    not accept a manifest that was never closed. Unlike earlier versions this raises
    :class:`SnapshotWriteError` instead of returning ``None``: a snapshot that was not
    written must never look like a turn with nothing to grade.
    """
    try:
        return _write_snapshot(Path(root), step, list(messages or []), extra)[0]
    except SnapshotWriteError:
        raise
    except Exception as exc:
        raise SnapshotWriteError(f"step {step}: {type(exc).__name__}: {exc}") from exc
