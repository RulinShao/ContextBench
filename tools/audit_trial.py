#!/usr/bin/env python3
"""Audit the trace of one ContextBench Harbor trial and print a Markdown section.

usage: tools/audit_trial.py TRIAL_DIR [--title TITLE] [--json]

Checks, from the trial's own files (never from the agent's claims):

* reward dict and ``terminated_by`` (verifier outputs, ``interactive_stream.json``);
* every delivered op reached the model as a ``role="user"`` message: the op's header
  line is looked up in the per-turn context snapshots (and in the ATIF trajectory when
  there is one), and the role of its **first** appearance is reported;
* no op was released by anything but a standalone readiness command (delivery log),
  and in the snapshot where op k first appears, the last command the agent ran before
  it is that readiness command;
* early-submit refusals, peak context tokens against the budget;
* harness-specific evidence: CLM context edits, terminus summarizations, codex
  compactions.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from contextbench.graders.base import _decoded_tool_json, atif_messages  # noqa: E402
from contextbench.stream import is_ready_command, is_ready_line  # noqa: E402
from contextbench.tokens import snapshot_paths  # noqa: E402

_HEADER_RE = re.compile(r"^=== .* \((\d+) op\(s\) remaining after this\) ===$", re.MULTILINE)
#: Text a harness puts in place of the history it compacted: terminus-2's handoff
#: prompt, codex's compaction summary. An op delivered right after one has no
#: terminal output before it, because the harness replaced that output.
_HANDOFFS = (
    "Continue working on this task from where the previous agent left off",
    "Another language model started to solve this problem and produced a summary",
)


def _is_handoff(text: str) -> bool:
    return any(h in text for h in _HANDOFFS)
_SHELL_WRAP = re.compile(r"^\s*(?:/usr)?(?:/bin/)?(?:ba|z)?sh\s+-l?c\s+(.+)$", re.DOTALL)


def _text(content: Any) -> str:
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        return "\n".join(str(p.get("text") or p.get("content") or "") if isinstance(p, dict)
                         else str(p) for p in content)
    return "" if content is None else str(content)


def _commands(msg: dict) -> list[str]:
    out = []
    for call in msg.get("tool_calls") or []:
        fn = call.get("function") or {}
        args = fn.get("arguments")
        if isinstance(args, str):
            try:
                args = json.loads(args)
            except Exception:
                args = {"command": args}
        if isinstance(args, dict):
            cmd = args.get("command") or args.get("cmd") or args.get("keystrokes") or ""
            if isinstance(cmd, list):
                cmd = " ".join(cmd)
            m = _SHELL_WRAP.match(str(cmd))
            out.append(str(cmd) if not m else m.group(1).strip("'\""))
    return out


def _terminus_commands(content: str) -> list[str]:
    """terminus-2 puts its commands in a JSON body inside the assistant text."""
    cmds = re.findall(r'"keystrokes"\s*:\s*"((?:[^"\\]|\\.)*)"', content or "")
    out = []
    for c in cmds:
        try:
            out.append(json.loads(f'"{c}"'))
        except Exception:
            out.append(c)
    return out


def _released_by_ready(entry: dict) -> bool | None:
    """The TurnSource's own verdict when logged, else re-checked from the trigger.

    ``None``: a log written before the verdict was recorded, whose trigger was cut
    at 200 characters; the snapshot order check is the evidence for those.
    """
    if entry.get("via"):
        return entry["via"] == "ready"
    trig = entry.get("trigger") or ""
    if is_ready_command(trig, 0):
        return True
    return None if len(trig) >= 200 else False


def load(trial: Path) -> dict:
    agent = trial / "agent"
    d: dict[str, Any] = {"trial": trial, "agent": agent}
    for name, rel in (("stream", agent / "interactive_stream.json"),
                      ("reward", trial / "verifier" / "reward.json"),
                      ("cb_result", trial / "verifier" / "contextbench_result.json"),
                      ("result", trial / "result.json"),
                      ("usage", agent / "usage.json")):
        try:
            d[name] = json.loads(rel.read_text())
        except Exception:
            d[name] = None
    frames = []
    for p in snapshot_paths(agent):
        try:
            obj = json.loads(p.read_text())
        except Exception:
            continue
        frames.append((p.name, obj.get("tokens") or 0, obj.get("messages") or [], obj))
    d["frames"] = frames
    traj = agent / "trajectory.json"
    d["atif"] = None
    if traj.is_file():
        try:
            t = json.loads(traj.read_text())
            if isinstance(t, dict) and isinstance(t.get("steps"), list):
                d["atif"] = t
        except Exception:
            pass
    return d


def audit(d: dict) -> dict:
    st = d["stream"] or {}
    frames = d["frames"]
    n_del = st.get("n_ops_delivered", 0)
    log = st.get("log") or []
    op_log = [e for e in log if e.get("kind") == "op"]
    flags: list[str] = []

    # --- delivery log: every op after the first released by a readiness command
    bad_triggers = [e for e in op_log[1:] if _released_by_ready(e) is False]
    if bad_triggers:
        flags.append(f"{len(bad_triggers)} op(s) released by a non-readiness trigger")
    if op_log and op_log[0].get("trigger") != "<start>":
        flags.append("op 0 not delivered at start")

    # --- first appearance of each op header in the snapshots
    first_seen: dict[int, tuple[str, str, int, int]] = {}  # remaining -> (frame, role, fidx, midx)
    for fi, (name, _tok, msgs, _obj) in enumerate(frames):
        for mi, m in enumerate(msgs):
            if not isinstance(m, dict):
                continue
            for hm in _HEADER_RE.finditer(_text(m.get("content"))):
                rem = int(hm.group(1))
                if rem not in first_seen:
                    first_seen[rem] = (name, m.get("role"), fi, mi)
    n_total = st.get("n_ops_total", 0)
    roles = {}
    for rem, (_n, role, _fi, _mi) in first_seen.items():
        roles[role] = roles.get(role, 0) + 1
    user_ops = roles.get("user", 0)
    non_user = {r: c for r, c in roles.items() if r != "user"}
    if non_user:
        flags.append(f"op header first seen in non-user role(s): {non_user}")
    if first_seen and user_ops != n_del:
        flags.append(f"ops seen as user turns in snapshots = {user_ops}, delivered = {n_del}")

    # --- ordering: the last command before each op k>=1 is the readiness command
    order_bad = []
    for rem, (_n, role, fi, mi) in sorted(first_seen.items(), reverse=True):
        k = n_total - 1 - rem
        if k == 0:
            continue
        msgs = frames[fi][2]
        last_cmd = None
        for m in reversed(msgs[:mi + 1]):
            if not isinstance(m, dict):
                continue
            if m.get("role") == "assistant":
                cmds = _commands(m) or _terminus_commands(_text(m.get("content")))
                if cmds:
                    last_cmd = cmds[-1]
                    break
        if last_cmd is None or not is_ready_command(last_cmd.strip(), 0):
            prev = [_text(m.get("content")) for m in msgs[max(0, mi - 3):mi + 1]
                    if isinstance(m, dict)]
            compacted = any(isinstance(m, dict) and m.get("role") != "assistant"
                            and _is_handoff(_text(m.get("content"))) for m in msgs)
            if not any(_is_handoff(t) for t in prev) and not (
                    compacted and msgs[mi - 1].get("role") == "user"):
                order_bad.append((k, (last_cmd or "")[:80]))
    # --- executed evidence: the echo's own output line precedes each op k>=1
    not_run: list[int] = []
    after_summary: list[int] = []
    for rem, (_n, role, fi, mi) in sorted(first_seen.items(), reverse=True):
        k = n_total - 1 - rem
        if k == 0:
            continue
        msgs = frames[fi][2]
        hdr = _HEADER_RE.search(_text(msgs[mi].get("content")))
        before = [_text(msgs[mi].get("content"))[:hdr.start()] if hdr else ""]
        for m in reversed(msgs[:mi]):
            if not isinstance(m, dict) or m.get("role") == "assistant":
                break
            if _HEADER_RE.search(_text(m.get("content"))) and not _is_handoff(
                    _text(m.get("content"))):
                before.append(_text(m.get("content")))
                continue
            t = _text(m.get("content"))
            if m.get("role") == "tool":
                t = _decoded_tool_json(t) or t
            before.append(t)
        if not any(is_ready_line(t) for t in before):
            frame_compacted = any(isinstance(m, dict) and m.get("role") != "assistant"
                                  and _is_handoff(_text(m.get("content"))) for m in msgs)
            # A compacting harness keeps past user turns and drops the tool output
            # between them; an op first seen in a compacted frame has no echo before it.
            if any(_is_handoff(t) for t in before) or _is_handoff(
                    _text(msgs[mi].get("content"))) or (
                    frame_compacted and msgs[mi - 1].get("role") == "user"):
                after_summary.append(k)  # the harness replaced the observation
            else:
                not_run.append(k)
    if not_run:
        flags.append(f"{len(not_run)} op(s) delivered without the echo's output line "
                     f"READY_FOR_NEXT_OP before them (ops {not_run[:8]}"
                     f"{'...' if len(not_run) > 8 else ''}): the readiness command may "
                     f"not have run")

    if order_bad:
        flags.append(f"{len(order_bad)} op(s) whose preceding command in the snapshot is not "
                     f"the readiness command (first: op {order_bad[0][0]}: {order_bad[0][1]!r})")

    # --- ATIF: ops as user steps
    atif_ops = None
    if d["atif"]:
        steps = d["atif"]["steps"]
        atif_ops = sum(1 for s in steps if s.get("source") == "user"
                       and ((s.get("extra") or {}).get("contextbench") or {}).get("kind") == "op")
        atif_obs = sum(1 for m in atif_messages(steps) if m["role"] == "tool"
                       and _HEADER_RE.search(m["content"]))
        if atif_ops and atif_ops != n_del:
            flags.append(f"ATIF op user steps = {atif_ops}, delivered = {n_del}")
        if atif_obs:
            flags.append(f"{atif_obs} ATIF observation(s) contain an op header")

    tokens = [t for _n, t, _m, _o in frames]
    peak = max(tokens) if tokens else 0
    budget = (frames[0][3].get("budget") if frames else None) or 32768
    reserve = (frames[0][3].get("reserve") if frames else None) or 2048

    return {"not_run": not_run, "after_summary": after_summary, "flags": flags, "first_seen": first_seen, "roles": roles, "user_ops": user_ops,
            "order_bad": order_bad, "atif_ops": atif_ops, "peak": peak, "budget": budget,
            "reserve": reserve, "n_frames": len(frames), "op_log": op_log}


def excerpts(d: dict) -> dict:
    ex: dict[str, str] = {}
    frames = d["frames"]
    for _n, _t, msgs, _o in frames:
        for m in msgs:
            if isinstance(m, dict) and m.get("role") == "user":
                h = _HEADER_RE.search(_text(m.get("content")))
                if h:
                    ex["op_header"] = h.group(0)
                    break
        if "op_header" in ex:
            break
    trig = [e["trigger"] for e in (d["stream"] or {}).get("log") or []
            if e.get("kind") == "op" and e.get("trigger") != "<start>"]
    if trig:
        ex["ready"] = min(trig, key=len)  # the plainest release, to quote
    pats = (r"<<<ANSWER[^>]*>>>.*?<<<ANSWER END>>>",
            r"<<<SKETCHPAD BEGIN>>>.*?<<<SKETCHPAD END>>>")
    for role in ("tool", "user", "assistant"):
        for _n, _t, msgs, _o in frames:
            for m in msgs:
                if not isinstance(m, dict) or m.get("role") != role:
                    continue
                for pat in pats:
                    for mm in re.finditer(pat, _text(m.get("content")), re.DOTALL):
                        block = mm.group(0)
                        # skip templates and the instruction's starting panel
                        if any(t in block for t in ("%s", "$", "<the ", "...", "<exact",
                                                    "VERSION: 0\n")):
                            continue
                        ex["answer"] = f"[{role}] " + block
                        return ex
    return ex


def clm_edits(d: dict) -> tuple[int | None, str | None]:
    usage = d.get("usage") or {}
    n = usage.get("n_ctx_syncs_real", usage.get("n_ctx_syncs"))
    snippet = None
    for _n, _t, msgs, _o in d["frames"]:
        for i, m in enumerate(msgs):
            if isinstance(m, dict) and m.get("role") != "user" and \
                    "_CTX_MAIN.txt: edit applied" in _text(m.get("content")):
                prev = next((x for x in reversed(msgs[:i]) if isinstance(x, dict)
                             and x.get("role") == "assistant" and _commands(x)), None)
                cmd = _commands(prev)[-1] if prev else ""
                note = next(ln for ln in _text(m.get("content")).splitlines()
                            if "_CTX_MAIN.txt: edit applied" in ln)
                snippet = "\n".join(cmd.splitlines()[:3]) + "\n...\n" + note
                break
        if snippet:
            break
    return n, snippet


# ------------------------------------------------------------ trace fidelity
def _key(m: Any) -> str:
    """A message's identity for comparison: role, text and tool-call arguments."""
    if not isinstance(m, dict):
        return json.dumps(m, sort_keys=True, default=str)
    calls = [((c.get("function") or {}).get("name"), (c.get("function") or {}).get("arguments"))
             for c in m.get("tool_calls") or [] if isinstance(c, dict)]
    return json.dumps([m.get("role"), _text(m.get("content")), calls], default=str)


def _sent_frames(d: dict) -> list[tuple[str, list, dict]]:
    """The snapshots of what was sent to the model, in order."""
    kinds = {f[3].get("kind") for f in d["frames"]}
    # codex is snapshotted once per resumed turn (several model calls): coarser.
    wanted = ({"sent", "agent"} if kinds & {"sent", "agent"}
              else {"turn"} if "turn" in kinds else {None})
    return [(name, msgs, obj) for name, _t, msgs, obj in d["frames"]
            if obj.get("kind") in wanted]


def _compaction_event(prev_obj: dict, obj: dict, new_msgs: list) -> str | None:
    """The recorded event that explains a non-append transition, if any."""
    if (obj.get("summarization_count") or 0) > (prev_obj.get("summarization_count") or 0):
        return "terminus summarization"
    for m in new_msgs:
        t = _text(m.get("content")) if isinstance(m, dict) else ""
        if "_CTX_MAIN.txt: edit applied" in t:
            return "CLM context edit"
        if _is_handoff(t):
            return "compaction summary"
    return None


def fidelity(d: dict) -> dict:
    """Consecutive sent snapshots: append-only, or changed by a recorded event.

    Also, for terminus, each post-reply snapshot must equal the sent snapshot of the
    same call plus exactly one assistant message.
    """
    sent = _sent_frames(d)
    res = {"n_sent": len(sent), "append": 0, "explained": {}, "unexplained": [],
           "edit_cmd_visible": 0, "edit_cmd_missing": [], "turn_ok": 0, "turn_bad": []}
    for (pn, pm, po), (n, m, o) in zip(sent, sent[1:]):
        pk = [_key(x) for x in pm]
        k = [_key(x) for x in m]
        if k[:len(pk)] == pk:
            res["append"] += 1
            continue
        prev = set(pk)
        new = [x for x, kx in zip(m, k) if kx not in prev]
        ev = _compaction_event(po, o, new)
        if ev is None and any(
                isinstance(x, dict) and _is_handoff(_text(x.get("content"))) for x in m):
            ev = "compaction summary"  # the history was replaced by a summarized one
        if ev is None:
            res["unexplained"].append(n)
            continue
        res["explained"][ev] = res["explained"].get(ev, 0) + 1
        if ev == "CLM context edit":
            # the command that edited the mirror must be visible in the turn before
            cmds = [c for x in new if isinstance(x, dict) and x.get("role") == "assistant"
                    for c in _commands(x)]
            if any("_CTX_MAIN.txt" in c or "live_ctx" in c for c in cmds):
                res["edit_cmd_visible"] += 1
            else:
                res["edit_cmd_missing"].append(n)
    # terminus: "turn" snapshot == preceding "sent" snapshot + one assistant message
    frames = d["frames"]
    for (n1, _t1, m1, o1), (n2, _t2, m2, o2) in zip(frames, frames[1:]):
        if o1.get("kind") == "sent" and o2.get("kind") == "turn":
            ok = ([_key(x) for x in m2[:-1]] == [_key(x) for x in m1]
                  and isinstance(m2[-1], dict) and m2[-1].get("role") == "assistant")
            if ok:
                res["turn_ok"] += 1
            else:
                res["turn_bad"].append(n2)
    return res


# ---------------------------------------------------------- answer provenance
_KV_ANSWER = re.compile(r"<<<\s*ANSWER\s+key\s*=\s*([^\s>]+)\s*>>>(.*?)<<<\s*ANSWER\s+END\s*>>>",
                        re.DOTALL | re.IGNORECASE)


def _norm(t: str) -> str:
    return re.sub(r"\s+", " ", t).strip()


def _gold(d: dict) -> dict | None:
    try:
        cfg = json.loads((d["trial"] / "config.json").read_text())
        path = Path(cfg["task"]["path"]) / "tests" / "gold.json"
        return json.loads(path.read_text())
    except Exception:
        return None


def provenance(d: dict, gold: dict) -> dict:
    """For every kv GET: was the gold value in what the model had when it answered?

    The answering call is the first sent-snapshot transition whose new messages
    contain an ANSWER block for the key carrying the gold value (else the first
    ANSWER block for the key). ``context``: the value is in the snapshot the model
    was sent, or in an earlier message of the same step (a grep result). ``tool``:
    the value appears only in the output of the answering command and the command
    itself does not contain it (the environment produced it, e.g. from disk).
    """
    sent = _sent_frames(d)
    final = d["frames"][-1][2] if d["frames"] else []
    series = [(n, m) for n, m, _o in sent] + [("final", final)]
    counts = {"correct_present": 0, "correct_absent": 0, "wrong_present": 0,
              "wrong_absent": 0, "unanswered": 0}
    via = {"context": 0, "tool": 0}
    absent_notes = []
    for q in gold.get("queries") or []:
        key, want = str(q["key"]), _norm(str(q["value"]))
        found = None
        for (pn, pm), (n, m) in zip(series, series[1:]):
            prev = {_key(x) for x in pm}
            new = [x for x in m if _key(x) not in prev]
            for i, x in enumerate(new):
                if not isinstance(x, dict):
                    continue
                for k, v in _KV_ANSWER.findall(_text(x.get("content"))):
                    if k.strip() != key or "%s" in v or "$" in v:
                        continue
                    hit = (want in _norm(v), pm, new, i, x)
                    if found is None or (hit[0] and not found[0]):
                        found = hit
            if found and found[0]:
                break
        if found is None:
            counts["unanswered"] += 1
            continue
        correct, pm, new, i, x = found
        prior = _norm("\n".join(_text(y.get("content")) for y in pm if isinstance(y, dict))
                      + "\n" + "\n".join(_text(y.get("content")) for y in new[:i]
                                          if isinstance(y, dict)))
        cmd_text = _norm(" ".join(c for y in new[:i + 1] if isinstance(y, dict)
                                  for c in _commands(y)))
        if want in prior:
            src = "context"
        elif (x.get("role") in ("tool", "user") and want in _norm(_text(x.get("content")))
              and want not in cmd_text):
            src = "tool"
        else:
            src = None
        if src:
            via[src] += 1
        tag = ("correct" if correct else "wrong") + ("_present" if src else "_absent")
        counts[tag] += 1
        if correct and not src:
            absent_notes.append(key)
    return {"counts": counts, "via": via, "correct_absent_keys": absent_notes}


def sudoku_misses(d: dict, gold: dict, limit: int = 8) -> dict:
    """Gold versions the agent never displayed correctly, with cell diffs."""
    from contextbench.graders.base import read_context
    from contextbench.graders.sudoku import SudokuSketchpadGrader, gold_states

    side = int(gold["meta"]["side"])
    obs = SudokuSketchpadGrader._observe(read_context(d["agent"]), side)
    delivered = (d["stream"] or {}).get("n_ops_delivered", 0)
    missed, undelivered = [], 0
    for v, cells in gold_states(gold):
        if v == 0:
            continue
        panel = tuple(sorted(cells.items()))
        if panel in obs["by_version"].get(v, ()):
            continue
        if v > delivered:
            undelivered += 1
            continue
        seen = obs["by_version"].get(v)
        if not seen:
            missed.append((v, "never displayed with this VERSION", []))
            continue
        best = max(seen, key=lambda p: sum(1 for k, val in cells.items()
                                           if dict(p).get(k) == val))
        diff = [f"{k}: gold {cells[k]}, shown {dict(best).get(k, '-')}"
                for k in sorted(cells) if dict(best).get(k) != cells[k]]
        missed.append((v, f"{len(diff)} cell(s) differ", diff[:6]))
    return {"missed": missed[:limit], "n_missed": len(missed),
            "n_undelivered": undelivered}


def render(d: dict, title: str, relative_to: Path | None = None) -> str:
    a = audit(d)
    ex = excerpts(d)
    st = d["stream"] or {}
    cbr = d["cb_result"] or {}
    rw = d["reward"] or {}
    res = d["result"] or {}
    ag = (res.get("agent_result") or {})
    meta = ag.get("metadata") or {}
    ae = res.get("agent_execution") or {}
    lines = [f"### {title}", ""]
    shown = d["trial"]
    if relative_to is not None:
        try:
            shown = d["trial"].resolve().relative_to(relative_to.resolve())
        except ValueError:
            pass
    lines.append(f"- trial dir: `{shown}`")
    if ae:
        lines.append(f"- agent wall: {ae.get('started_at')} -> {ae.get('finished_at')}")
    exc = res.get("exception_info")
    if exc:
        lines.append(f"- **exception**: {exc.get('exception_type')}: "
                     f"{str(exc.get('exception_message'))[:200]}")
    keys = ("reward", "matched", "total", "n_answered", "reward_versioned", "reward_content",
            "grader_valid", "agent_peak_tokens")
    lines.append("- reward: " + ", ".join(f"{k}={rw[k]:.4g}" if isinstance(rw.get(k), float)
                                         else f"{k}={rw.get(k)}" for k in keys if k in rw)
                 + f", graded_from={cbr.get('graded_from')}")
    lines.append(f"- terminated_by: **{st.get('terminated_by')}**; ops delivered "
                 f"{st.get('n_ops_delivered')}/{st.get('n_ops_total')}; refusals "
                 f"{st.get('n_refusals')}; explanations {st.get('n_explains')}")
    lines.append(f"- stream identity: count {st.get('stream', {}).get('count')}, sha256 "
                 f"{str(st.get('stream', {}).get('sha256'))[:16]}..., removed from container: "
                 f"{st.get('stream', {}).get('removed')}")
    lines.append(f"- op headers in snapshots ({a['n_frames']} frames): first appearance by "
                 f"role {a['roles']} -> {a['user_ops']} op user turns vs "
                 f"{st.get('n_ops_delivered')} delivered")
    if a["atif_ops"] is not None:
        lines.append(f"- ATIF trajectory: {a['atif_ops']} `source=user` op steps")
    verdicts = [_released_by_ready(e) for e in a["op_log"][1:]]
    unk = verdicts.count(None)
    lines.append(f"- delivery log: {len(a['op_log'])} ops; op 0 at start; "
                 f"{verdicts.count(True)} released by a standalone readiness command, "
                 f"{verdicts.count(False)} otherwise"
                 + (f", {unk} with a trigger cut at 200 chars (older log format)" if unk else "")
                 + f"; snapshot order check (last command before each op k>=1 is the "
                 f"readiness command): {len(a['order_bad'])} violation(s); echo output "
                 f"line present before each op k>=1: "
                 f"{len(a['op_log']) - 1 - len(a['not_run']) - len(a['after_summary'])}"
                 f"/{len(a['op_log']) - 1}"
                 + (f" (+{len(a['after_summary'])} delivered "
                    f"right after a harness summary/compaction, which replaces the prior output)"
                    if a["after_summary"] else ""))
    lines.append(f"- peak context: {a['peak']} tokens (budget {a['budget']}, usable "
                 f"{a['budget'] - a['reserve']})")
    if meta.get("summarization_count") is not None:
        # terminus bumps its counter before the summary calls, so a summarization
        # that failed (and left the chat unchanged) is counted too; the fidelity line
        # below counts the ones that changed the context.
        lines.append(f"- terminus summarization attempts: {meta.get('summarization_count')}")
        sub = d["agent"] / "contextbench_subagent_calls.json"
        if sub.is_file():
            sc = json.loads(sub.read_text())
            calls = sc.get("calls") or []
            over = [c for c in calls if c.get("tokens", 0) > sc.get("usable", 0)]
            failed = ["#%s %s" % (c.get("summarization"), c.get("step"))
                      for c in calls if not c.get("ok")]
            top = max((c.get("tokens", 0) for c in calls), default=0)
            lines.append(
                f"- terminus summarizer calls: {len(calls)}; over the usable budget "
                f"{len(over)} (max {top} tokens); failed {len(failed)}"
                + (f" ({', '.join(failed)})" if failed else ""))
    sessions = d["agent"] / "sessions"
    if sessions.is_dir():
        n_comp = sum(f.read_text(errors="replace").count('"type":"compacted"')
                     for f in sessions.rglob("rollout-*.jsonl"))
        lines.append(f"- codex compactions (rollout `compacted` records): {n_comp}")
    n_edits, snip = clm_edits(d)
    if d.get("usage") and "n_ctx_syncs" in (d["usage"] or {}):
        lines.append(f"- CLM context edits (n_ctx_syncs_real): {n_edits}")
        if snip:
            lines += ["", "  one edit (command head, harness note):", "", "  ```"]
            lines += ["  " + ln for ln in snip.splitlines()] + ["  ```"]
    fd = fidelity(d)
    ev = ", ".join(f"{v} {k}" for k, v in fd["explained"].items()) or "none"
    lines.append(f"- snapshot fidelity: {fd['n_sent']} sent snapshots; transitions "
                 f"append-only {fd['append']}, changed by a recorded event {ev}, "
                 f"unexplained {len(fd['unexplained'])}"
                 + (f" ({fd['unexplained'][:4]})" if fd["unexplained"] else ""))
    if fd["explained"].get("CLM context edit"):
        lines.append(f"  - CLM edits whose editing command is visible in the new turn: "
                     f"{fd['edit_cmd_visible']}/{fd['explained']['CLM context edit']}")
    if fd["turn_ok"] or fd["turn_bad"]:
        lines.append(f"  - post-reply snapshot == sent snapshot + one assistant message: "
                     f"{fd['turn_ok']}/{fd['turn_ok'] + len(fd['turn_bad'])}")
    gold = _gold(d)
    fam = ((gold or {}).get("meta") or {}).get("task_family")
    if gold and fam == "kv_store":
        pv = provenance(d, gold)
        c = pv["counts"]
        lines.append(f"- answer provenance (kv): correct & present {c['correct_present']} "
                     f"(in context {pv['via']['context']}, from a tool this call "
                     f"{pv['via']['tool']}), correct & absent {c['correct_absent']}, "
                     f"wrong & present {c['wrong_present']}, wrong & absent "
                     f"{c['wrong_absent']}, unanswered {c['unanswered']}"
                     + (f"; correct & absent keys: {pv['correct_absent_keys'][:6]}"
                        if pv["correct_absent_keys"] else ""))
    if gold and fam == "sudoku_sketchpad":
        sm = sudoku_misses(d, gold)
        lines.append(f"- sudoku versions missed among delivered moves: {sm['n_missed']}; "
                     f"not delivered (run ended): {sm['n_undelivered']}")
        for v, why, diff in sm["missed"]:
            lines.append(f"  - v{v} (op {v - 1}, move v{v}): {why}"
                         + (f": {'; '.join(diff)}" if diff else ""))
    lines.append("")
    lines.append("Excerpts:")
    lines.append("")
    for k, label in (("op_header", "op header"), ("ready", "readiness command"),
                     ("answer", "answer block")):
        if k in ex:
            body = ex[k] if len(ex[k]) < 700 else ex[k][:700] + "\n[...]"
            lines += [f"- {label}:", "", "  ```"] + ["  " + ln for ln in body.splitlines()] \
                + ["  ```"]
    lines.append("")
    lines.append("Flags: " + ("; ".join(a["flags"]) if a["flags"] else "none from the checks above."))
    lines.append("")
    return "\n".join(lines)


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("trial", type=Path)
    ap.add_argument("--title", default=None)
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--relative-to", type=Path, default=None,
                    help="print the trial dir relative to this directory")
    a = ap.parse_args(argv)
    d = load(a.trial)
    if a.json:
        out = audit(d)
        out["first_seen"] = {str(k): v for k, v in out["first_seen"].items()}
        print(json.dumps(out, indent=2, default=str))
    else:
        print(render(d, a.title or a.trial.name, a.relative_to))
    return 0


if __name__ == "__main__":
    sys.exit(main())
