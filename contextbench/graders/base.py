"""Grader plumbing: where a run's context is read from, and what is checked first.

Every ContextBench reward is computed out of the agent's own messages, never off
disk. Three sources exist, and a caller names the one it wants (``mode``); there is
no fallback from one to another:

1. ``harness`` (scored runs) -- the per-turn ``context_snapshots/turn-*.json`` a
   harness wrote through :class:`contextbench.tokens.SnapshotLog` into a snapshot
   root the agent cannot reach (for Harbor ``<trial_dir>/contextbench_harness``).
   Only files listed in the root's closed ``snapshot_manifest.jsonl`` with a matching
   sha256 are read; an unlisted file, a missing or changed file, an unreadable file,
   a manifest that was never closed or that records a failed write all make the run
   **invalid**. ``graded_from="snapshots"``.
2. ``legacy`` (offline re-grading only) -- the snapshots of a trial recorded before
   the snapshot root existed, in the agent's logs dir, with no manifest. Every file
   must parse. ``graded_from="legacy_snapshots"``.
3. ``oracle`` -- the gold answers that ``solution/solve.sh`` writes as
   ``final_report.txt``; only for checking that a task, its gold and its grader
   agree. ``graded_from="final_report"``, never comparable to a context grade.

Before scoring, the harness and legacy sources are checked against the task's token
budget (:func:`check_budget`). ANSWER blocks (kv store, log triage) are read only
from what the agent produced -- assistant messages and tool output
(:func:`answer_messages`). Needle retention reads the whole final context, because
retaining the delivered lines is what it measures, and the sudoku grader reads every
message of every frame, as before (a context-editing harness such as CLM keeps the
edited board in a rewritten message whose role is ``user``).
"""

from __future__ import annotations

import json
import os
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Sequence

from ..tokens import (
    HARNESS_DIRNAME,
    MANIFEST_NAME,
    SNAPSHOT_DIRNAME,
    count_tokens,
    encoder_name,
    snapshot_paths,
)

__all__ = [
    "GRADE_MODES",
    "ContextSource",
    "InvalidRun",
    "answer_messages",
    "answer_text",
    "atif_messages",
    "check_budget",
    "Grader",
    "read_harness_snapshots",
    "read_legacy_snapshots",
    "read_oracle_report",
    "resolve_snapshot_root",
    "find_snapshots_dir",
    "find_trajectory",
    "messages_text",
    "normalize",
    "read_context",
    "read_final_report",
    "read_snapshots",
    "read_trajectory",
]

#: Filenames a run may use for its closing report, most specific first.
FINAL_REPORT_NAMES = (
    "final_report.txt",
    "final_report.md",
    "final_report.json",
    "report.txt",
    "report.md",
)


#: ``harness`` (scored), ``legacy`` (offline re-grade of old trials), ``oracle``.
GRADE_MODES = ("harness", "legacy", "oracle")


class InvalidRun(Exception):
    """The run cannot be graded; the reason is the message. Never a zero score."""


def normalize(text: str) -> str:
    """Collapse whitespace, so a reward never turns on reflow or indentation."""
    return re.sub(r"\s+", " ", text.strip())


def _decoded_tool_json(content: str) -> str | None:
    """The string fields of a tool result that is one JSON object, else ``None``.

    Some harnesses render a command's output as a JSON object (``{"returncode": 0,
    "output": "..."}``), which escapes ``<`` and ``>`` and turns newlines into
    ``\\n``. The model reads the decoded text; so does the grader.
    """
    text = content.strip()
    if not (text.startswith("{") and text.endswith("}")):
        return None
    try:
        obj = json.loads(text)
    except Exception:
        return None
    if not isinstance(obj, dict):
        return None
    parts = [v for v in obj.values() if isinstance(v, str)]
    return "\n".join(parts) if parts else None


def _decoded_assistant_json(content: str) -> str | None:
    """An assistant reply that ends in one JSON object, with that object decoded.

    terminus-2 asks the model for a JSON reply (``{"analysis": ..., "plan": ...,
    "commands": [...], "task_complete": ...}``), often after free reasoning text. In
    the raw reply a newline inside a string is the two characters ``\\n``, so an
    ANSWER block the model wrote in ``analysis`` has no marker at the start of a line.
    The model's own text is the decoded one: this returns the text before the object
    followed by the object's top-level string fields (as for a JSON tool result; the
    keystrokes inside ``commands`` are commands, whose output arrives as the next
    terminal screen). ``None`` when the reply does not end in a JSON object.
    """
    text = content.rstrip()
    if text.endswith("```"):
        text = text[:-3].rstrip()
    if not text.endswith("}"):
        return None
    decoder = json.JSONDecoder()
    for m in re.finditer(r"^[ \t]*(?:```(?:json)?[ \t]*\n[ \t]*)?\{", text, re.M):
        start = m.end() - 1
        try:
            obj, end = decoder.raw_decode(text, start)
        except ValueError:
            continue
        if text[end:].strip() or not isinstance(obj, dict):
            continue
        parts = [v for v in obj.values() if isinstance(v, str)]
        return text[:m.start()] + "\n".join(parts)
    return None


def answer_text(messages: Sequence[Any] | None) -> str:
    """:func:`messages_text` of the answer messages, with JSON assistant replies
    decoded (:func:`_decoded_assistant_json`)."""
    out: list[Any] = []
    for msg in messages or []:
        if isinstance(msg, dict) and msg.get("role") == "assistant" and \
                isinstance(msg.get("content"), str):
            decoded = _decoded_assistant_json(msg["content"])
            if decoded is not None:
                msg = {**msg, "content": decoded}
        out.append(msg)
    return messages_text(out)


def messages_text(messages: Sequence[Any] | None) -> str:
    """Flatten a message list into the text the grader scans."""
    texts: list[str] = []
    for msg in messages or []:
        content = msg.get("content") if isinstance(msg, dict) else msg
        if isinstance(content, str):
            if isinstance(msg, dict) and msg.get("role") == "tool":
                decoded = _decoded_tool_json(content)
                if decoded is not None:
                    content = decoded
            texts.append(content)
        elif isinstance(content, list):
            for item in content:
                texts.append(
                    str(item.get("text") or item.get("content") or "")
                    if isinstance(item, dict)
                    else str(item)
                )
    return "\n".join(texts)


#: Roles whose text is the agent's own output.
ANSWER_ROLES = ("assistant", "tool")


def answer_messages(frame: Sequence[Any], *,
                    tool_output_in_user_turns: bool = False) -> list[Any]:
    """The messages of one frame an answer may come from: what the agent produced.

    Assistant messages and tool output count; user and system text (the instruction,
    with its example ANSWER block, and the ops) never does. A harness that delivers
    tool output as user turns (terminus-2, whose user turns after the first are the
    terminal screen) records ``tool_output_in_user_turns`` in its snapshots; then the
    user turns after the first user turn count as tool output.
    """
    out: list[Any] = []
    seen_user = False
    for msg in frame or []:
        if not isinstance(msg, dict):
            continue
        role = msg.get("role")
        if role in ANSWER_ROLES:
            out.append(msg)
        elif role == "user":
            if seen_user and tool_output_in_user_turns:
                out.append(msg)
            seen_user = True
    return out


# ----------------------------------------------------------------- locating files
def _candidate_dirs(run_dir: Path) -> list[Path]:
    """``run_dir`` itself and the usual agent subdirectories, in preference order."""
    return [run_dir, run_dir / "agent", run_dir / "logs", run_dir / "logs" / "agent"]


def find_snapshots_dir(run_dir: Path | str) -> Path | None:
    """The run's ``context_snapshots`` directory, if it has one."""
    run_dir = Path(run_dir)
    for cand in _candidate_dirs(run_dir):
        if (cand / SNAPSHOT_DIRNAME).is_dir():
            return cand / SNAPSHOT_DIRNAME
    hits = sorted(run_dir.glob(f"**/{SNAPSHOT_DIRNAME}"))
    return hits[0] if hits else None


def find_trajectory(run_dir: Path | str) -> Path | None:
    """The run's ATIF ``trajectory.json``, if it has one."""
    run_dir = Path(run_dir)
    for cand in _candidate_dirs(run_dir):
        if (cand / "trajectory.json").is_file():
            return cand / "trajectory.json"
    hits = sorted(run_dir.glob("**/trajectory.json"))
    return hits[0] if hits else None


# ------------------------------------------------------------------- the readers
@dataclass
class ContextSource:
    """The messages a grader scores, and where they came from."""

    graded_from: str
    #: One message list per turn. A report yields a single frame.
    frames: list[list[Any]] = field(default_factory=list)
    #: Per-turn context size (after :func:`check_budget`: the grader's own count).
    tokens: list[int] = field(default_factory=list)
    n_snapshots: int = 0
    #: Per-frame snapshot fields other than ``messages`` (empty for a report).
    records: list[dict[str, Any]] = field(default_factory=list)
    #: The run's terminal reason as the harness recorded it, when known.
    terminated_by: str | None = None

    @property
    def final_frame(self) -> list[Any]:
        return self.frames[-1] if self.frames else []

    def texts(self) -> list[str]:
        return [messages_text(frame) for frame in self.frames]

    def all_text(self) -> str:
        return "\n".join(self.texts())

    def answer_texts(self) -> list[str]:
        """Per frame, the text of the messages an answer may come from."""
        out = []
        for i, frame in enumerate(self.frames):
            rec = self.records[i] if i < len(self.records) else {}
            out.append(answer_text(answer_messages(
                frame, tool_output_in_user_turns=bool(
                    rec.get("tool_output_in_user_turns")))))
        return out


def _recorded_tokens(value: Any) -> int:
    """A snapshot's recorded count for display before :func:`check_budget` (which
    rejects a malformed one); 0 when absent or malformed."""
    return value if isinstance(value, int) and not isinstance(value, bool) else 0


#: Harbor's name for a trial's agent logs dir (mounted at ``/logs/agent``).
AGENT_DIRNAME = "agent"

#: Files and folders an agent logs dir holds and a snapshot root never does.
AGENT_LOG_MARKERS = ("final_report.txt", "sessions", "terminus_2.pane",
                     "mswea_state.json", "codex_stream.json", "usage.json",
                     "mini-swe-agent.txt")


def resolve_snapshot_root(path: Path | str) -> Path:
    """``path`` if it holds a snapshot manifest, else ``path/contextbench_harness``.

    Never searches an agent's logs dir, and refuses (:class:`InvalidRun`) a root that
    is one or lies inside one -- a directory named ``agent``, or one holding agent
    log files (:data:`AGENT_LOG_MARKERS`) -- so a manifest the agent planted there is
    never graded by mistake. Pass the trial dir or its ``contextbench_harness/``.
    """
    path = Path(path)
    if (path / MANIFEST_NAME).is_file() or path.name == HARNESS_DIRNAME:
        root = path
    else:
        root = path / HARNESS_DIRNAME
    where = Path(os.path.normpath(os.path.abspath(root)))
    if AGENT_DIRNAME in (where.name, where.parent.name):
        raise InvalidRun(f"{root} is (inside) an agent logs dir, which the agent can "
                         "write: harness mode grades the trial's host-only "
                         f"{HARNESS_DIRNAME}/ (pass the trial dir)")
    markers = [m for m in AGENT_LOG_MARKERS if (root / m).exists()]
    if markers:
        raise InvalidRun(f"{root} holds agent log files ({', '.join(markers)}): "
                         "harness mode never grades an agent logs dir")
    return root


def _read_manifest(root: Path) -> list[dict[str, Any]]:
    path = root / MANIFEST_NAME
    if not path.is_file():
        raise InvalidRun(f"no snapshot manifest at {path}: the harness wrote no "
                         "snapshots there (no fallback to other sources)")
    lines: list[dict[str, Any]] = []
    for n, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if not raw.strip():
            continue
        try:
            obj = json.loads(raw)
        except Exception:
            raise InvalidRun(f"{path.name} line {n} is not JSON") from None
        if not isinstance(obj, dict):
            raise InvalidRun(f"{path.name} line {n} is not an object")
        lines.append(obj)
    return lines


def read_harness_snapshots(root: Path | str) -> ContextSource:
    """Read a snapshot root written by :class:`contextbench.tokens.SnapshotLog`.

    Raises :class:`InvalidRun` unless the manifest has a header, consecutive steps,
    a last line that closes it with no failed write and the right count, and every
    listed file exists unmodified -- and no other ``turn-*.json`` exists.
    """
    root = Path(root)
    lines = _read_manifest(root)
    if not lines or not lines[0].get("header"):
        raise InvalidRun("snapshot manifest has no header line")
    entries = [ln for ln in lines if "file" in ln]
    closes = [ln for ln in lines if ln.get("closed")]
    failed = [ln.get("failed") for ln in lines if ln.get("failed")]
    if failed:
        raise InvalidRun(f"the harness failed to write a snapshot: {failed[0]}")
    if not closes or not lines[-1].get("closed"):
        raise InvalidRun("snapshot manifest was never closed: the run did not finish "
                         "recording (crash, or a failed snapshot write)")
    if int(lines[-1].get("n_snapshots", -1)) != len(entries):
        raise InvalidRun(f"snapshot manifest closes with n_snapshots="
                         f"{lines[-1].get('n_snapshots')} but lists {len(entries)}")
    if not entries:
        raise InvalidRun("the harness recorded no snapshots")
    steps = [int(e.get("step", -1)) for e in entries]
    if any(b != a + 1 for a, b in zip(steps, steps[1:])):
        raise InvalidRun(f"snapshot steps are not consecutive: {steps[:8]}...")
    listed = {}
    for e, st in zip(entries, steps):
        name = str(e.get("file"))
        if name != f"turn-{st:04d}.json" or name in listed:
            raise InvalidRun(f"manifest entry {name!r} for step {st} is malformed")
        listed[name] = e
    on_disk = {p.name for p in snapshot_paths(root)}
    extra = sorted(on_disk - set(listed))
    if extra:
        raise InvalidRun(f"snapshot file(s) the harness did not write: {extra[:5]}")
    missing = sorted(set(listed) - on_disk)
    if missing:
        raise InvalidRun(f"snapshot file(s) listed in the manifest are missing: "
                         f"{missing[:5]}")

    import hashlib

    frames: list[list[Any]] = []
    tokens: list[int] = []
    records: list[dict[str, Any]] = []
    for name, e in listed.items():
        data = (root / SNAPSHOT_DIRNAME / name).read_bytes()
        if hashlib.sha256(data).hexdigest() != e.get("sha256"):
            raise InvalidRun(f"{name} was modified after the harness wrote it")
        try:
            obj = json.loads(data.decode("utf-8"))
        except Exception:
            raise InvalidRun(f"{name} is not readable JSON") from None
        messages = obj.get("messages") if isinstance(obj, dict) else None
        if not isinstance(messages, list) or obj.get("step") != e.get("step"):
            raise InvalidRun(f"{name} has no message list or the wrong step")
        frames.append(messages)
        tokens.append(_recorded_tokens(obj.get("tokens")))
        records.append({k: v for k, v in obj.items() if k != "messages"})
    return ContextSource("snapshots", frames, tokens, len(frames), records,
                         lines[-1].get("terminated_by"))


def read_legacy_snapshots(agent_dir: Path | str) -> ContextSource:
    """Snapshots of a trial recorded before the snapshot root existed (offline only).

    Reads ``<agent_dir>/context_snapshots/turn-*.json`` with no manifest: such files
    sat in the agent's logs dir, so this mode is for re-grading trials whose
    provenance has been checked by other means (``tools/audit_trial.py``). Every file
    must parse; ``terminated_by`` comes from ``<agent_dir>/interactive_stream.json``.
    Terminus2Stream snapshots (recognized by ``summarization_count``) get
    ``tool_output_in_user_turns``, which that harness now records itself.
    """
    agent_dir = Path(agent_dir)
    snap_dir = agent_dir / SNAPSHOT_DIRNAME
    if not snap_dir.is_dir():
        raise InvalidRun(f"no {SNAPSHOT_DIRNAME}/ directory in {agent_dir}")
    frames: list[list[Any]] = []
    tokens: list[int] = []
    records: list[dict[str, Any]] = []
    for path in snapshot_paths(agent_dir):
        try:
            obj = json.loads(path.read_text(encoding="utf-8"))
        except Exception:
            raise InvalidRun(f"{path.name} is not readable JSON") from None
        messages = obj.get("messages") if isinstance(obj, dict) else None
        if not isinstance(messages, list):
            raise InvalidRun(f"{path.name} has no message list")
        rec = {k: v for k, v in obj.items() if k != "messages"}
        # Terminus2Stream snapshots written before the flag existed: that harness
        # alone records ``summarization_count``, and its user turns after the first
        # are always the terminal screen.
        if "summarization_count" in rec:
            rec.setdefault("tool_output_in_user_turns", True)
        frames.append(messages)
        tokens.append(_recorded_tokens(obj.get("tokens")))
        records.append(rec)
    if not frames:
        raise InvalidRun(f"no turn-*.json snapshots in {snap_dir}")
    terminated_by = None
    stream = agent_dir / "interactive_stream.json"
    if stream.is_file():
        try:
            terminated_by = json.loads(stream.read_text(encoding="utf-8")).get(
                "terminated_by")
        except Exception:
            raise InvalidRun("interactive_stream.json is not readable JSON") from None
    return ContextSource("legacy_snapshots", frames, tokens, len(frames), records,
                         terminated_by)


#: The only report the oracle mode reads (what ``solution/solve.sh`` writes).
ORACLE_REPORT_NAME = "final_report.txt"


def read_oracle_report(agent_dir: Path | str) -> ContextSource:
    """The oracle's ``final_report.txt`` as one assistant frame."""
    path = Path(agent_dir) / ORACLE_REPORT_NAME
    if not path.is_file():
        raise InvalidRun(f"oracle mode: no {ORACLE_REPORT_NAME} in {agent_dir}")
    text = path.read_text(encoding="utf-8")
    return ContextSource("final_report", [[{"role": "assistant", "content": text}]],
                         [], 0, [{}], None)


def read_snapshots(run_dir: Path | str) -> ContextSource:
    """Back-compat name for :func:`read_legacy_snapshots`."""
    return read_legacy_snapshots(run_dir)


def read_context(run_dir: Path | str, *, mode: str = "harness") -> ContextSource:
    """The context of one run, from exactly the source ``mode`` names.

    ``harness``: ``run_dir`` is a snapshot root (or a directory holding
    ``contextbench_harness/``); ``legacy``: an old-layout agent dir; ``oracle``: the
    agent dir the oracle's ``solve.sh`` wrote into. Raises :class:`InvalidRun`.
    """
    if mode == "harness":
        return read_harness_snapshots(resolve_snapshot_root(run_dir))
    if mode == "legacy":
        return read_legacy_snapshots(run_dir)
    if mode == "oracle":
        return read_oracle_report(run_dir)
    raise ValueError(f"unknown grade mode {mode!r}; known: {', '.join(GRADE_MODES)}")


def _as_int(value: Any, what: str) -> int:
    """``int(value)``, or :class:`InvalidRun` naming ``what`` for a malformed value."""
    if isinstance(value, bool):
        raise InvalidRun(f"{what} is not an integer: {value!r}")
    try:
        return int(value)
    except (TypeError, ValueError):
        raise InvalidRun(f"{what} is not an integer: {value!r}") from None


#: The token method that defines the benchmark's budget.
EXACT_TOKEN_METHOD = "tiktoken:o200k_base"


def check_budget(source: ContextSource, budget: int | None, reserve: int | None, *,
                 strict_tokens: bool = True) -> dict[str, Any]:
    """Check a snapshot source against the task's budget; raise :class:`InvalidRun`.

    * Every snapshot that records a ``budget`` must record the task's; a harness
      snapshot (``strict_tokens``) must record one. A recorded ``reserve`` may be
      larger than the task's (a stricter wall), never smaller. Malformed numbers make
      the run invalid.
    * Token counts. When the grader counts with the benchmark's method
      (``tiktoken:o200k_base``) it recounts every frame and checks its own count;
      with ``strict_tokens`` a count recorded with that method must equal the
      recount. When it cannot (no tiktoken or no o200k vocabulary here) it never
      judges a run on its character estimate: it checks the harness's recorded
      counts (in harness mode protected by the manifest's sha256; a harness snapshot
      without one is invalid) and reports ``tokens_verified=0`` with a
      ``token_note``. A legacy frame with neither is not size-checked.
    * The budget bounds the context *sent* to the model. When a run records
      ``kind="sent"`` snapshots, those are the frames checked (a post-reply or
      pre-compaction snapshot holds a sent context plus one reply or tool result, and
      may exceed the budget); otherwise every frame is checked. No checked frame may
      exceed the budget, except checked frames at the very end of a run whose harness
      recorded ``terminated_by="budget_wall"`` (the context that hit the wall is
      recorded before the run stops). An agent may enforce a stricter wall.

    On success ``source.tokens`` holds the counts used; returns the fields the reward
    records (``tokens_verified`` 1.0 when every count is the grader's own o200k count).
    """
    if budget is None:
        raise InvalidRun("no task budget given to the grader (contextbench_budget_tokens "
                         "in task.toml metadata)")
    budget = _as_int(budget, "the task budget")
    reserve = _as_int(reserve, "the task reserve") if reserve is not None else None
    method = encoder_name()
    exact = method == EXACT_TOKEN_METHOD
    counted: list[int] = []
    unmeasured: set[int] = set()
    used_recorded = False
    for i, (frame, rec) in enumerate(zip(source.frames, source.records)):
        rb = rec.get("budget")
        if rb is None:
            if strict_tokens:
                raise InvalidRun(f"snapshot {i} records no budget")
        elif _as_int(rb, f"snapshot {i} budget") != budget:
            raise InvalidRun(f"snapshot {i} was recorded under budget {rb}, the task's "
                             f"is {budget}")
        rr = rec.get("reserve")
        if rr is not None and reserve is not None and \
                _as_int(rr, f"snapshot {i} reserve") < reserve:
            raise InvalidRun(f"snapshot {i} was recorded with reserve {rr}, below the "
                             f"task's {reserve}")
        recorded = rec.get("tokens")
        recorded = _as_int(recorded, f"snapshot {i} token count") \
            if recorded is not None else None
        recount, _ = count_tokens(frame)
        same_method = rec.get("token_method") == method
        if same_method and strict_tokens and recorded is not None and recorded != recount:
            raise InvalidRun(f"snapshot {i} records {recorded} tokens, its messages "
                             f"count {recount}")
        if exact:
            tok = recount
            if same_method and not strict_tokens and recorded is not None:
                tok = max(recount, recorded)
        elif recorded is not None:
            # The benchmark's count cannot be reproduced here: judge the run on the
            # harness's own count, never on this grader's character estimate.
            tok = recorded
            used_recorded = True
        elif strict_tokens:
            raise InvalidRun(f"snapshot {i} records no token count")
        else:
            tok = recount
            unmeasured.add(i)
        counted.append(tok)
    sent = [i for i, rec in enumerate(source.records) if rec.get("kind") == "sent"]
    checked = [i for i in (sent or list(range(len(counted)))) if i not in unmeasured]
    over = [i for i in checked if counted[i] > budget]
    if over:
        tail = over == checked[checked.index(over[0]):]
        if not (tail and source.terminated_by == "budget_wall"):
            i = over[0]
            raise InvalidRun(f"snapshot {i} holds {counted[i]} tokens, over the task "
                             f"budget {budget}")
    source.tokens = counted
    info: dict[str, Any] = {
        "budget_tokens": float(budget),
        "reserve_tokens": float(reserve) if reserve is not None else -1.0,
        "tokens_verified": 1.0 if exact else 0.0,
        "n_snapshots_over_budget": float(len(over)),
        "token_method": method,
    }
    if not exact:
        how = "the harness's recorded counts" if used_recorded else "no exact count"
        info["token_note"] = (
            f"unverified: this grader counts with {method}, not {EXACT_TOKEN_METHOD} "
            f"(install tiktoken with the o200k_base vocabulary to verify); the budget "
            f"was checked on {how}"
            + (f"; {len(unmeasured)} frame(s) without a recorded count were not "
               "size-checked" if unmeasured else ""))
    return info


def read_trajectory(run_dir: Path | str) -> ContextSource | None:
    """Read an ATIF ``trajectory.json`` as a single frame."""
    path = find_trajectory(run_dir)
    if path is None:
        return None
    try:
        messages = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return None
    if isinstance(messages, dict):
        if isinstance(messages.get("steps"), list):
            messages = atif_messages(messages["steps"])
        else:
            messages = messages.get("messages") or messages.get("trajectory") or []
    if not isinstance(messages, list):
        return None
    return ContextSource("trajectory", [messages], [], 0)


def _part_text(content: Any) -> str:
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        return "\n".join(
            str(p.get("text") or "") if isinstance(p, dict) else str(p) for p in content
        )
    return "" if content is None else str(content)


def atif_messages(steps: Sequence[Any]) -> list[dict[str, Any]]:
    """Flatten ATIF ``steps`` into chat messages.

    ``user`` and ``system`` steps become messages of that role; an ``agent`` step
    becomes an ``assistant`` message followed by one ``tool`` message per
    observation result. The flattening is the full history the harness recorded,
    which for a harness that compacts is more than it retained.
    """
    out: list[dict[str, Any]] = []
    for step in steps or []:
        if not isinstance(step, dict):
            continue
        source = step.get("source")
        text = _part_text(step.get("message"))
        if source in ("user", "system"):
            out.append({"role": source, "content": text})
            continue
        out.append({"role": "assistant", "content": text})
        observation = step.get("observation") or {}
        for result in observation.get("results") or []:
            if isinstance(result, dict) and result.get("content") is not None:
                out.append({"role": "tool", "content": _part_text(result["content"])})
    return out


def read_final_report(run_dir: Path | str) -> str:
    """The run's closing report text.

    A file named like ``final_report.txt`` wins; otherwise the assistant messages
    of a trajectory are concatenated, which is what an agent that only talks leaves
    behind.
    """
    run_dir = Path(run_dir)
    for cand in _candidate_dirs(run_dir):
        for name in FINAL_REPORT_NAMES:
            path = cand / name
            if path.is_file():
                return path.read_text(encoding="utf-8")
    source = read_trajectory(run_dir)
    if source is None:
        return ""
    assistant = [
        m
        for m in source.final_frame
        if isinstance(m, dict) and m.get("role") == "assistant"
    ]
    return messages_text(assistant or source.final_frame)


# ---------------------------------------------------------------------- base class
#: ``graded_from`` of each mode, used in an invalid result too.
_GRADED_FROM = {"harness": "snapshots", "legacy": "legacy_snapshots",
                "oracle": "final_report"}


class Grader:
    """A ContextBench grader.

    :meth:`grade` reads the source ``mode`` names, checks it against the task budget
    (harness and legacy modes), and hands it to the family's :meth:`score`. Every
    returned dict carries ``graded_from``, ``grade_mode`` and ``grader_valid``; an
    invalid result has ``reward=None`` and a ``grader_note``, never a zero score.
    """

    family: str = ""
    #: The reward name a caller should read as "the score".
    primary: str = "reward"

    def grade(self, run_dir: Path | str, gold: dict, *, mode: str = "harness",
              budget: int | None = None, reserve: int | None = None) -> dict:
        """Grade one run. ``budget``/``reserve`` are the task's (harness, legacy)."""
        if mode not in GRADE_MODES:
            raise ValueError(f"unknown grade mode {mode!r}")
        self.check_gold(gold)
        try:
            source = read_context(run_dir, mode=mode)
            info: dict[str, Any] = {}
            if mode != "oracle":
                info = check_budget(source, budget, reserve,
                                    strict_tokens=(mode == "harness"))
            result = self.score(source, gold)
        except InvalidRun as exc:
            out = self._invalid(_GRADED_FROM[mode], str(exc))
            out["grade_mode"] = mode
            if budget is not None:
                out["budget_tokens"] = float(budget)
            return out
        result.update({
            "n_snapshots": float(source.n_snapshots),
            "graded_from": source.graded_from,
            "grade_mode": mode,
            "grader_valid": 1.0,
        })
        result.update(info)
        result.update(self._token_stats(source.tokens))
        if source.terminated_by is not None:
            result["terminated_by"] = source.terminated_by
        return result

    def check_gold(self, gold: dict) -> None:
        """Raise ``ValueError`` for a gold this grader must not guess around."""

    def score(self, source: ContextSource, gold: dict) -> dict:
        """The family's rewards for a checked source; raise :class:`InvalidRun`."""
        raise NotImplementedError

    def grade_path(self, run_dir: Path | str, gold_path: Path | str,
                   **kwargs: Any) -> dict:
        gold = json.loads(Path(gold_path).read_text(encoding="utf-8"))
        return self.grade(run_dir, gold, **kwargs)

    # -- helpers shared by the concrete graders --------------------------------
    @staticmethod
    def _token_stats(tokens: list[int]) -> dict[str, float]:
        return {
            "agent_peak_tokens": float(max(tokens)) if tokens else 0.0,
            "agent_mean_tokens": float(sum(tokens) / len(tokens)) if tokens else 0.0,
        }

    @staticmethod
    def _invalid(graded_from: str, why: str) -> dict:
        """A grade that could not be computed: never reported as a zero score."""
        return {
            "reward": None,
            "grader_valid": 0.0,
            "graded_from": graded_from,
            "grader_note": why,
        }
