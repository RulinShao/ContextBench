"""``cb_stream``: run a Harbor installed CLI agent on a ContextBench stream.

An installed agent runs one CLI invocation per ``run()`` and cannot take a user turn
in the middle of it. ``cb_stream(AgentCls)`` returns a subclass that keeps **one**
session alive across many invocations and passes each op in as the next user
message of that session::

    from harbor.agents.installed.codex import Codex
    from contextbench.harbor.wrap import cb_stream
    CodexStream = cb_stream(Codex)

Ready-made: ``contextbench.harbor.wrap:CodexStream`` and
``contextbench.harbor.wrap:MiniSweAgentStream`` (``harbor trials start -a ...``).

Only CLIs whose session can be resumed are supported, and ``cb_stream`` raises
``TypeError`` for any other class: running a fresh conversation per op would wipe
the context the benchmark measures, so there is no fallback. Supported:

* **codex** (``Codex`` and subclasses): ``codex exec`` starts the session with the
  instruction and op 0; each later user turn is ``codex exec resume <thread>``.
  *Readiness:* a codex turn ends when the model stops calling tools; the op is
  released when the turn has ended **and** its last command was the standalone
  ``echo READY_FOR_NEXT_OP`` (exit 0). A turn that ended any other way gets a
  one-line reminder as the next prompt. Codex's own compaction is the harness
  under test; its context window is set to the ContextBench budget.
* **mini-swe-agent** (``MiniSweAgent`` and subclasses): its CLI cannot resume, so
  the library's own ``DefaultAgent`` is resumed instead, one step per call, from a
  small in-container driver (``_mswea_driver.py``) that reloads the saved messages.
  mini-swe-agent's templates, tool format, observation template and submit handling
  are unchanged; it has no context management of its own. *Readiness:* the
  standalone ``echo READY_FOR_NEXT_OP`` command (exit 0) of a step.

Both write ``context_snapshots/turn-NNNN.json`` built from the session the CLI saved
(what the model is sent next), and ``interactive_stream.json``, through
:class:`~contextbench.harbor.mixin.CBStreamMixin`, and keep the CLI's native logs.
They expect the CLI in the image (``environment/contextbench-cli-agents.def``) and
fall back to Harbor's own install otherwise.
"""

from __future__ import annotations

import asyncio
import json
import re
import shlex
import tempfile
from pathlib import Path, PurePosixPath
from typing import Any

from harbor.agents.installed.codex import Codex
from harbor.agents.installed.mini_swe_agent import MiniSweAgent
from harbor.environments.base import BaseEnvironment
from harbor.models.agent.context import AgentContext

from .. import stream as proto
from .mixin import CBStreamMixin

__all__ = ["CodexStream", "MiniSweAgentStream", "cb_stream", "supported", "unwrap_shell"]

TURN_ENDED_TEXT = (
    f"[Your turn ended without running `echo {proto.ADVANCE_MARKER}`, so the stream "
    "did not advance. Finish the current operation, then run that command on its own "
    "to receive the next one.]"
)

_SHELL_WRAP = re.compile(r"^\s*(?:/usr)?(?:/bin/)?(?:ba|z)?sh\s+-l?c\s+(.+)$", re.DOTALL)


def unwrap_shell(command: str) -> str:
    """``bash -lc '<script>'`` -> ``<script>``; anything else unchanged.

    CLI agents report the command they spawned, which wraps the model's script in a
    login shell. Readiness is judged on the script the model wrote.
    """
    m = _SHELL_WRAP.match(command or "")
    if not m:
        return command or ""
    try:
        parts = shlex.split(m.group(1))
    except ValueError:
        return command
    return parts[0] if len(parts) == 1 else command


class _StreamChain(CBStreamMixin):
    """Shared by the resume strategies: settings and file upload."""

    def _cb_init(self, budget: int, reserve: int, max_steps: int) -> None:
        self.cb_budget = int(budget)
        self.cb_reserve = int(reserve)
        self.cb_max_steps = int(max_steps)

    async def _cb_put_text(self, environment: BaseEnvironment, text: str,
                           target: str) -> None:
        with tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False,
                                         encoding="utf-8") as fh:
            fh.write(text)
            local = fh.name
        try:
            await environment.upload_file(local, target)
        finally:
            Path(local).unlink(missing_ok=True)


# =============================================================== mini-swe-agent
class _MiniSweResume(_StreamChain):
    """mini-swe-agent: one resumed ``DefaultAgent`` step per call."""

    _WORK = PurePosixPath("/tmp/cb_mswea")
    _STATE_NAME = "mswea_state.json"
    _PYTHONS = ("/opt/mswea/bin/python",
                "$HOME/.local/share/uv/tools/mini-swe-agent/bin/python")

    def __init__(self, *args: Any, api_base: str | None = None,
                 temperature: float | None = 0.7, top_p: float | None = 0.95,
                 max_tokens: int = 8192,
                 chat_template_kwargs: dict[str, Any] | None = None,
                 context_budget_tokens: int = 32768,
                 context_budget_reserve_tokens: int = 2048,
                 max_steps: int = 100000, command_timeout: int = 120,
                 step_timeout: int = 1800, **kwargs: Any):
        super().__init__(*args, **kwargs)
        self._cb_init(context_budget_tokens, context_budget_reserve_tokens, max_steps)
        self.api_base = api_base
        kw: dict[str, Any] = {"max_tokens": int(max_tokens), "drop_params": True}
        if api_base:
            kw["api_base"] = api_base
        if temperature is not None:
            kw["temperature"] = temperature
        if top_p is not None:
            kw["top_p"] = top_p
        ctk = {"enable_thinking": True} if chat_template_kwargs is None \
            else chat_template_kwargs
        if ctk:
            kw["extra_body"] = {"chat_template_kwargs": ctk}
        self.cb_model_kwargs = kw
        self.cb_command_timeout = int(command_timeout)
        self.cb_step_timeout = int(step_timeout)
        self._cb_python: str | None = None


    async def _find_python(self, environment: BaseEnvironment) -> str | None:
        for py in self._PYTHONS:
            res = await environment.exec(f'{py} -c "import minisweagent"', timeout_sec=120)
            if res.return_code == 0:
                return py
        return None

    async def install(self, environment: BaseEnvironment) -> None:
        self._cb_python = await self._find_python(environment)
        if self._cb_python is None:
            await super().install(environment)
            self._cb_python = await self._find_python(environment)
        if self._cb_python is None:
            raise RuntimeError("mini-swe-agent is not importable in the container")

    def _driver_env(self) -> dict[str, str]:
        env = {"MSWEA_CONFIGURED": "true", "MSWEA_COST_TRACKING": "ignore_errors",
               "OPENAI_API_KEY": self._get_env("OPENAI_API_KEY") or "EMPTY",
               "LITELLM_LOG": "ERROR", "LITELLM_LOCAL_MODEL_COST_MAP": "True"}
        if self.api_base:
            env["OPENAI_API_BASE"] = self.api_base
            env["OPENAI_BASE_URL"] = self.api_base
        return env

    async def _driver(self, environment: BaseEnvironment, *flags: str) -> dict[str, Any]:
        state = PurePosixPath("/logs/agent") / self._STATE_NAME
        cmd = " ".join([
            self._cb_python or "python3", shlex.quote(str(self._WORK / "driver.py")),
            "--state", shlex.quote(str(state)),
            "--model", shlex.quote(self.model_name or ""),
            "--model-kwargs", shlex.quote(json.dumps(self.cb_model_kwargs)),
            "--timeout", str(self.cb_command_timeout), *flags,
        ])
        res = await environment.exec(cmd, env=self._driver_env(),
                                     timeout_sec=self.cb_step_timeout)
        out = res.stdout or ""
        (self.logs_dir / "mini-swe-agent.txt").open("a", encoding="utf-8").write(
            out[-20000:] + (res.stderr or "")[-5000:] + "\n")
        for line in reversed(out.splitlines()):
            if line.startswith("CB_DRIVER_RESULT "):
                return json.loads(line[len("CB_DRIVER_RESULT "):])
        raise RuntimeError(f"mini-swe-agent driver failed (rc={res.return_code}): "
                           f"{(res.stderr or out)[-1500:]}")

    def _state_messages(self) -> list[dict[str, Any]]:
        path = self.logs_dir / self._STATE_NAME
        state = json.loads(path.read_text(encoding="utf-8"))
        return [{k: v for k, v in m.items() if k != "extra"}
                for m in state.get("messages") or [] if m.get("role") != "exit"]

    async def run(self, instruction: str, environment: BaseEnvironment,
                  context: AgentContext) -> None:
        ts = await self.cb_setup(environment)
        if self._cb_python is None:
            self._cb_python = await self._find_python(environment)
        await environment.exec(f"mkdir -p {self._WORK}", timeout_sec=60)
        await environment.upload_file(Path(__file__).with_name("_mswea_driver.py"),
                                      str(self._WORK / "driver.py"))
        await self._cb_put_text(environment, instruction, str(self._WORK / "task.md"))
        first = ts.first_turn(turn=0)
        pending = [first] if first is not None else []
        usable = self.cb_budget - self.cb_reserve
        step = 0
        try:
            await self._cb_put_text(environment, json.dumps(pending),
                                    str(self._WORK / "user.json"))
            await self._driver(environment, "--init", "--task-file",
                               str(self._WORK / "task.md"), "--user-file",
                               str(self._WORK / "user.json"), "--no-step")
            pending = []
            while not ts.done:
                if step >= self.cb_max_steps:
                    ts.terminate("max_steps")
                    break
                flags: list[str] = []
                if pending:
                    await self._cb_put_text(environment, json.dumps(pending),
                                            str(self._WORK / "user.json"))
                    flags = ["--user-file", str(self._WORK / "user.json"), "--no-step"]
                    await self._driver(environment, *flags)
                    pending = []
                tokens = self.cb_snapshot(self._state_messages(), "sent")
                if tokens > usable:
                    ts.terminate("budget_wall")
                    break
                result = await self._driver(environment)
                step += 1
                for item in result.get("executed") or []:
                    pending += ts.pending(item.get("command", ""),
                                         item.get("returncode", 1), turn=step)
                if result.get("exit") and not ts.done:
                    if result.get("exit_status") == "Submitted":
                        pending += ts.on_submit(trigger="mini-swe-agent submit", turn=step)
                    else:
                        # mini-swe-agent gave up (format errors, limits): no terminal
                        # reason of the protocol fits, so the run is recorded as a cap.
                        ts.terminate("max_steps")
        except asyncio.CancelledError:
            ts.terminate("timeout")
            raise
        finally:
            try:
                self.cb_snapshot(self._state_messages(), "final")
            except Exception:
                pass
            ts.write()
            context.metadata = {"terminated_by": ts.terminated_by,
                                "n_ops_delivered": ts.n_delivered,
                                "n_ops_total": ts.n_total, "n_steps": step,
                                "peak_context_tokens": self.cb_peak_tokens}

    def populate_context_post_run(self, context: AgentContext) -> None:
        """Keep the stream metadata; the stock converter expects its own file name."""
        state = self.logs_dir / self._STATE_NAME
        native = self.logs_dir / "mini-swe-agent.trajectory.json"
        if state.is_file() and not native.exists():
            try:
                data = json.loads(state.read_text(encoding="utf-8"))
                native.write_text(json.dumps({
                    "info": {"model_stats": {"instance_cost": data.get("cost", 0.0),
                                             "api_calls": data.get("n_calls", 0)}},
                    "messages": data.get("messages") or [],
                    "trajectory_format": "mini-swe-agent-1.1",
                }), encoding="utf-8")
            except Exception:
                pass
        meta = dict(context.metadata or {})
        try:
            super().populate_context_post_run(context)
        finally:
            merged = dict(context.metadata or {})
            merged.update(meta)
            context.metadata = merged


# ======================================================================== codex
class _CodexResume(_StreamChain):
    """codex: one ``codex exec resume`` per user turn."""

    _WORK = PurePosixPath("/tmp/cb_codex")

    #: codex sends ``role="developer"`` messages (permissions, apps, collaboration
    #: mode, environment context, skills, plugins, multi-agent, goals), which an
    #: OpenAI-compatible Responses endpoint without that role (vLLM 0.19) rejects
    #: with "Unexpected message role". These switches (plus the ``include_*``
    #: keys written to config.toml) keep codex's own system instructions, tools and
    #: compaction, and drop only those extra blocks and features.
    COMPAT_FLAGS = ("-c skills.include_instructions=false --disable skill_search "
                    "--disable plugins --disable apps --disable multi_agent "
                    "--disable goals")

    def __init__(self, *args: Any, api_base: str | None = None,
                 context_budget_tokens: int = 32768,
                 context_budget_reserve_tokens: int = 2048,
                 max_steps: int = 100000, max_consecutive_reminders: int = 20,
                 turn_timeout: int = 3600, compat_flags: bool = True,
                 stream_idle_timeout_ms: int = 1800000, **kwargs: Any):
        super().__init__(*args, **kwargs)
        self.cb_stream_idle_ms = int(stream_idle_timeout_ms)
        self.cb_compat = str(compat_flags).strip().lower() in ("1", "true", "yes")
        self._cb_init(context_budget_tokens, context_budget_reserve_tokens, max_steps)
        self.api_base = api_base
        self.cb_max_reminders = int(max_consecutive_reminders)
        self.cb_turn_timeout = int(turn_timeout)
        self.thread_id: str | None = None


    async def install(self, environment: BaseEnvironment) -> None:
        res = await environment.exec("command -v codex && codex --version", timeout_sec=120)
        if res.return_code == 0:
            return
        await super().install(environment)

    def _env(self) -> dict[str, str]:
        return {"CODEX_HOME": self._REMOTE_CODEX_HOME.as_posix(),
                "OPENAI_API_KEY": self._get_env("OPENAI_API_KEY") or "EMPTY"}

    async def _configure(self, environment: BaseEnvironment) -> None:
        model = (self.model_name or "").split("/")[-1]
        base = self.api_base or self._get_env("OPENAI_BASE_URL") or ""
        compat = [
            "include_permissions_instructions = false",
            "include_apps_instructions = false",
            "include_collaboration_mode_instructions = false",
            "include_environment_context = false",
        ] if self.cb_compat else []
        toml = "\n".join([
            *compat,
            f"model = {json.dumps(model)}",
            'model_provider = "contextbench"',
            f"model_context_window = {self.cb_budget}",
            "",
            "[model_providers.contextbench]",
            'name = "OpenAI-compatible endpoint"',
            f"base_url = {json.dumps(base)}",
            'wire_api = "responses"',
            'env_key = "OPENAI_API_KEY"',
            # A local server under load can think for minutes before its first
            # token; codex's default idle timeout then drops and re-sends the turn.
            f"stream_idle_timeout_ms = {int(self.cb_stream_idle_ms)}",
            "",
        ])
        home = self._REMOTE_CODEX_HOME.as_posix()
        await environment.exec(f"mkdir -p {home} {self._WORK} /logs/agent",
                               env=self._env(), timeout_sec=60)
        await self._cb_put_text(environment, toml, f"{home}/config.toml")

    async def _turn(self, environment: BaseEnvironment, prompt: str,
                    n: int) -> list[dict[str, Any]]:
        await self._cb_put_text(environment, prompt, str(self._WORK / "prompt.txt"))
        model = (self.model_name or "").split("/")[-1]
        head = "codex exec"
        if self.thread_id:
            head = f"codex exec resume {shlex.quote(self.thread_id)}"
        log = f"/logs/agent/codex-turn-{n:04d}.jsonl"
        cmd = (
            "if [ -s ~/.nvm/nvm.sh ]; then . ~/.nvm/nvm.sh; fi; "
            f"{head} {self.COMPAT_FLAGS if self.cb_compat else ''} "
            "--dangerously-bypass-approvals-and-sandbox --skip-git-repo-check "
            f"--model {shlex.quote(model)} --json "
            f'-- "$(cat {self._WORK / "prompt.txt"})" 2>&1 </dev/null | tee {log}'
        )
        await environment.exec(cmd, env=self._env(), timeout_sec=self.cb_turn_timeout)
        events: list[dict[str, Any]] = []
        path = self.logs_dir / Path(log).name
        text = path.read_text(encoding="utf-8", errors="replace") if path.is_file() else ""
        for line in text.splitlines():
            line = line.strip()
            if line.startswith("{"):
                try:
                    events.append(json.loads(line))
                except json.JSONDecodeError:
                    pass
        for ev in events:
            if ev.get("type") == "thread.started" and ev.get("thread_id"):
                self.thread_id = ev["thread_id"]
        return events

    async def _session_messages(self, environment: BaseEnvironment) -> list[dict[str, Any]]:
        """The model-facing history from codex's rollout file, after compactions."""
        home = self._REMOTE_CODEX_HOME.as_posix()
        await environment.exec(
            f'rm -rf /logs/agent/sessions; cp -R {home}/sessions /logs/agent/sessions',
            env=self._env(), timeout_sec=120)
        files = sorted((self.logs_dir / "sessions").rglob("rollout-*.jsonl"))
        if self.thread_id:
            files = [f for f in files if self.thread_id in f.name] or files
        if not files:
            return []
        messages: list[dict[str, Any]] = []
        system: list[dict[str, Any]] = []
        for line in files[-1].read_text(encoding="utf-8", errors="replace").splitlines():
            try:
                rec = json.loads(line)
            except json.JSONDecodeError:
                continue
            kind, payload = rec.get("type"), rec.get("payload") or {}
            if kind == "session_meta":
                base = payload.get("base_instructions")
                text = base.get("text") if isinstance(base, dict) else base
                if text:
                    system = [{"role": "system", "content": str(text)}]
            elif kind == "compacted":
                repl = payload.get("replacement_history")
                messages = _codex_items(repl) if isinstance(repl, list) else [
                    {"role": "user", "content": str(payload.get("message") or "")}]
            elif kind == "response_item":
                messages += _codex_items([payload])
        return system + messages

    async def run(self, instruction: str, environment: BaseEnvironment,
                  context: AgentContext) -> None:
        ts = await self.cb_setup(environment)
        await self._configure(environment)
        first = ts.first_turn(turn=0)
        prompt = instruction.rstrip("\n") + ("\n\n" + first if first else "")
        usable = self.cb_budget - self.cb_reserve
        n = 0
        reminders = 0
        failures = 0
        try:
            while not ts.done:
                if n >= self.cb_max_steps:
                    ts.terminate("max_steps")
                    break
                events = await self._turn(environment, prompt, n)
                n += 1
                failed = [ev for ev in events if ev.get("type") == "turn.failed"]
                if failed:
                    failures += 1
                    if failures >= 3:
                        raise RuntimeError(
                            "codex turn failed 3 times in a row: "
                            + str((failed[-1].get("error") or {}).get("message"))[:500])
                    continue  # same prompt again: the failed turn added nothing
                failures = 0
                cmds = [ev["item"] for ev in events
                        if ev.get("type") == "item.completed"
                        and (ev.get("item") or {}).get("type") == "command_execution"]
                messages = await self._session_messages(environment)
                tokens = self.cb_snapshot(messages, "turn")
                texts: list[str] = []
                if cmds:
                    last = cmds[-1]
                    code = last.get("exit_code")
                    texts = ts.pending(unwrap_shell(str(last.get("command") or "")),
                                       1 if code is None else int(code), turn=n)
                if ts.done:
                    break
                if tokens > usable:
                    ts.terminate("budget_wall")
                    break
                if texts:
                    reminders = 0
                    prompt = "\n\n".join(texts)
                else:
                    reminders += 1
                    if reminders > self.cb_max_reminders:
                        ts.terminate("max_steps")
                        break
                    prompt = TURN_ENDED_TEXT
        except asyncio.CancelledError:
            ts.terminate("timeout")
            raise
        finally:
            ts.write()
            (self.logs_dir / "codex_stream.json").write_text(json.dumps(
                {"thread_id": self.thread_id, "n_invocations": n,
                 "peak_context_tokens": self.cb_peak_tokens}, indent=2) + "\n")
            context.metadata = {"terminated_by": ts.terminated_by,
                                "n_ops_delivered": ts.n_delivered,
                                "n_ops_total": ts.n_total, "n_invocations": n,
                                "peak_context_tokens": self.cb_peak_tokens}

    def populate_context_post_run(self, context: AgentContext) -> None:
        meta = dict(context.metadata or {})
        try:
            super().populate_context_post_run(context)
        except Exception:
            pass
        merged = dict(context.metadata or {})
        merged.update(meta)
        context.metadata = merged


def _codex_items(items: list[Any]) -> list[dict[str, Any]]:
    """Codex rollout ``response_item`` payloads -> chat-style messages."""
    out: list[dict[str, Any]] = []
    for it in items or []:
        if not isinstance(it, dict):
            continue
        t = it.get("type")
        if t == "message":
            parts = it.get("content") or []
            text = "\n".join(str(p.get("text") or "") for p in parts if isinstance(p, dict))
            out.append({"role": it.get("role") or "user", "content": text})
        elif t in ("function_call", "custom_tool_call", "local_shell_call"):
            args = it.get("arguments") or it.get("input") or it.get("action") or ""
            out.append({"role": "assistant", "content": "",
                        "tool_calls": [{"id": it.get("call_id") or "",
                                        "type": "function",
                                        "function": {"name": it.get("name") or t,
                                                     "arguments": args if isinstance(args, str)
                                                     else json.dumps(args)}}]})
        elif t in ("function_call_output", "custom_tool_call_output"):
            output = it.get("output")
            if isinstance(output, dict):
                output = output.get("content") or json.dumps(output)
            out.append({"role": "tool", "tool_call_id": it.get("call_id") or "",
                        "content": str(output or "")})
        elif t == "reasoning":
            parts = it.get("content") or it.get("summary") or []
            text = "\n".join(str(p.get("text") or "") for p in parts if isinstance(p, dict))
            if text:
                out.append({"role": "assistant", "content": "", "reasoning_content": text})
    return out


# ================================================================== the wrapper
#: Harbor agent base class -> resume strategy. Order matters: first match wins.
_RESUMERS: list[tuple[type, type]] = [
    (Codex, _CodexResume),
    (MiniSweAgent, _MiniSweResume),
]


def supported() -> list[str]:
    """Names of the Harbor agent classes ``cb_stream`` can wrap."""
    return [base.__name__ for base, _ in _RESUMERS]


def cb_stream(agent_cls: type) -> type:
    """A subclass of ``agent_cls`` that runs one resumed session per trial.

    Raises ``TypeError`` for an agent whose CLI cannot resume a session.
    """
    for base, strategy in _RESUMERS:
        if isinstance(agent_cls, type) and issubclass(agent_cls, base):
            base_name = agent_cls.name()
            name = agent_cls.__name__ + "Stream"
            return type(name, (strategy, agent_cls), {
                "__module__": __name__,
                "__qualname__": name,
                "__doc__": f"{agent_cls.__name__} on a ContextBench stream "
                           f"({strategy.__doc__.strip()})",
                "name": staticmethod(lambda _n=base_name: f"{_n}-contextbench"),
            })
    raise TypeError(
        f"{getattr(agent_cls, '__name__', agent_cls)!r} has no session resume that "
        f"ContextBench can drive (supported: {', '.join(supported())}). Streaming it "
        "would need a fresh conversation per op, which wipes the context under test, "
        "so it is refused rather than degraded."
    )


MiniSweAgentStream = cb_stream(MiniSweAgent)
CodexStream = cb_stream(Codex)
