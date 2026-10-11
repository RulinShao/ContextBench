"""``ContextBenchAgent``: a minimal bash-tool agent loop for Harbor.

It is the append-only baseline and the base class for Python harnesses that want
the ContextBench delivery rules without writing them. It is built on
:class:`~contextbench.harbor.mixin.CBStreamMixin`, the same three calls any Python
loop can add: it appends every pending op as a ``role="user"`` message right after
the tool result that asked for it, snapshots the context before every model call,
and enforces the budget wall.

One model call is one turn. The model gets one tool, ``bash``; if it returns
several tool calls, only the first is executed and kept (the rest are dropped from
the message, so the history stays a valid tool-call transcript). A reply with no
tool call gets a one-line reminder, because only a command can advance the stream.

Subclasses change the context policy by overriding :meth:`manage_context`, which
runs after each turn's user messages are appended and may rewrite ``messages`` in
place. The base implementation does nothing: append-only.

Talks to any OpenAI-compatible ``/v1/chat/completions`` endpoint (``api_base``);
``model_name`` may carry a litellm-style provider prefix (``openai/<model>``),
which is stripped.
"""

from __future__ import annotations

import asyncio
import json
import os
import time
from pathlib import Path
from typing import Any

from harbor.agents.base import BaseAgent
from harbor.environments.base import BaseEnvironment
from harbor.models.agent.context import AgentContext

from ... import stream as proto
from ..mixin import CBStreamMixin

__all__ = ["BASH_TOOL", "ContextBenchAgent", "DEFAULT_SYSTEM_PROMPT"]

BASH_TOOL = {
    "type": "function",
    "function": {
        "name": "bash",
        "description": (
            "Run one bash command in the task container and return its exit code, "
            "stdout and stderr. State on disk persists between calls; shell "
            "variables do not."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "command": {"type": "string", "description": "The bash command to run."}
            },
            "required": ["command"],
        },
    },
}

DEFAULT_SYSTEM_PROMPT = (
    "You are an agent working in a Linux container through a `bash` tool. Every "
    "action you take is one `bash` call.\n\n" + proto.MARKER_PARAGRAPH
)

NO_TOOL_CALL_TEXT = (
    "(No tool call in your last turn. Only a `bash` command can advance the task: "
    f"when you have handled the current operation, run `echo {proto.ADVANCE_MARKER}`.)"
)


class ContextBenchAgent(CBStreamMixin, BaseAgent):
    """Append-only bash agent over an OpenAI-compatible endpoint."""

    SUPPORTS_ATIF = False

    def __init__(
        self,
        logs_dir: Path,
        model_name: str | None = None,
        *args: Any,
        api_base: str | None = None,
        api_key: str | None = None,
        temperature: float | None = 0.7,
        top_p: float | None = 0.95,
        max_tokens: int = 8192,
        chat_template_kwargs: dict[str, Any] | None = None,
        context_budget_tokens: int = 32768,
        context_budget_reserve_tokens: int = 2048,
        max_steps: int = 100000,
        command_timeout: int = 120,
        observation_max_chars: int = 50000,
        system_prompt: str | None = None,
        max_retries: int = 10,
        request_timeout: float = 600.0,
        **kwargs: Any,
    ):
        super().__init__(logs_dir, model_name, *args, **kwargs)
        if not model_name:
            raise ValueError("ContextBenchAgent needs model_name")
        self._model = model_name.split("/", 1)[1] if model_name.startswith("openai/") \
            else model_name
        self.api_base = api_base or os.environ.get("OPENAI_BASE_URL")
        self.api_key = api_key or os.environ.get("OPENAI_API_KEY") or "EMPTY"
        self.temperature = temperature
        self.top_p = top_p
        self.max_tokens = int(max_tokens)
        self.chat_template_kwargs = chat_template_kwargs
        self.budget = int(context_budget_tokens)
        self.reserve = int(context_budget_reserve_tokens)
        self.max_steps = int(max_steps)
        self.command_timeout = int(command_timeout)
        self.observation_max_chars = int(observation_max_chars)
        self.system_prompt = system_prompt or DEFAULT_SYSTEM_PROMPT
        self.max_retries = int(max_retries)
        self.request_timeout = float(request_timeout)

        self.messages: list[dict[str, Any]] = []
        self._client: Any = None
        self._usage = {"prompt_tokens": 0, "completion_tokens": 0}
        self._n_llm_calls = 0
        self._n_commands = 0

    @staticmethod
    def name() -> str:
        return "contextbench-bash"

    def version(self) -> str | None:
        from ... import __version__

        return __version__

    async def setup(self, environment: BaseEnvironment) -> None:
        self.logs_dir.mkdir(parents=True, exist_ok=True)

    # ----------------------------------------------------------------- hooks
    def manage_context(self, messages: list[dict[str, Any]]) -> None:
        """Rewrite ``messages`` in place between turns. Append-only: no-op."""

    def _manage_context_recorded(self) -> None:
        """Run :meth:`manage_context`; if it changed the context, first snapshot the
        context it started from (``kind="turn"``). The turn's tool result is then
        graded even when the policy removes it before the next request, as the paper's
        summary and edit-context harnesses recorded each turn before compacting."""
        before = list(self.messages)
        self.manage_context(self.messages)
        if self.messages != before:
            self.cb_snapshot(before, "turn")

    # ------------------------------------------------------------------ model
    def _get_client(self) -> Any:
        if self._client is None:
            from openai import AsyncOpenAI

            self._client = AsyncOpenAI(
                base_url=self.api_base, api_key=self.api_key,
                timeout=self.request_timeout, max_retries=0,
            )
        return self._client

    async def complete(self, messages: list[dict[str, Any]]) -> dict[str, Any]:
        """One chat completion; returns the assistant message as a dict."""
        import openai

        params: dict[str, Any] = {
            "model": self._model,
            "messages": messages,
            "tools": [BASH_TOOL],
            "max_tokens": self.max_tokens,
        }
        if self.temperature is not None:
            params["temperature"] = self.temperature
        if self.top_p is not None:
            params["top_p"] = self.top_p
        if self.chat_template_kwargs:
            params["extra_body"] = {"chat_template_kwargs": self.chat_template_kwargs}

        delay = 2.0
        for attempt in range(self.max_retries + 1):
            try:
                resp = await self._get_client().chat.completions.create(**params)
                break
            except openai.BadRequestError:
                raise  # context overflow or malformed request: not transient
            except (openai.APIConnectionError, openai.APITimeoutError,
                    openai.InternalServerError, openai.RateLimitError):
                if attempt >= self.max_retries:
                    raise
                await asyncio.sleep(delay)
                delay = min(delay * 2, 60.0)
        self._n_llm_calls += 1
        usage = getattr(resp, "usage", None)
        if usage is not None:
            self._usage["prompt_tokens"] += int(getattr(usage, "prompt_tokens", 0) or 0)
            self._usage["completion_tokens"] += int(
                getattr(usage, "completion_tokens", 0) or 0
            )
        msg = resp.choices[0].message
        out: dict[str, Any] = {"role": "assistant", "content": msg.content or ""}
        reasoning = getattr(msg, "reasoning_content", None) or getattr(msg, "reasoning", None)
        if reasoning:
            out["reasoning_content"] = reasoning
        calls = [c.model_dump() for c in (msg.tool_calls or [])]
        if calls:
            out["tool_calls"] = calls
        return out

    # ---------------------------------------------------------------- the shell
    def _format_result(self, rc: int, stdout: str, stderr: str) -> str:
        text = f"exit_code: {rc}\n{stdout or ''}"
        if stderr:
            text += f"\n[stderr]\n{stderr}"
        cap = self.observation_max_chars
        if cap and len(text) > cap:
            half = cap // 2
            text = (text[:half] + f"\n[... {len(text) - cap} characters elided ...]\n"
                    + text[-half:])
        return text

    async def execute(self, environment: BaseEnvironment, command: str) -> tuple[int, str]:
        self._n_commands += 1
        try:
            res = await environment.exec(command, timeout_sec=self.command_timeout)
        except asyncio.TimeoutError:
            return 124, self._format_result(
                124, "", f"command timed out after {self.command_timeout}s"
            )
        return res.return_code, self._format_result(
            res.return_code, res.stdout or "", res.stderr or ""
        )

    # --------------------------------------------------------------------- run
    async def run(
        self, instruction: str, environment: BaseEnvironment, context: AgentContext
    ) -> None:
        import openai

        src = await self.cb_setup(environment, budget=self.budget, reserve=self.reserve)
        self.messages = [
            {"role": "system", "content": self.system_prompt},
            {"role": "user", "content": instruction},
        ]
        self.messages += self.cb_user_turns(self.cb_initial_turns())

        step = 0
        t0 = time.monotonic()
        try:
            while not self.cb_done:
                if step >= self.max_steps:
                    self.cb_finish("max_steps")
                    break
                if self.cb_over_budget(self.messages):
                    break
                try:
                    msg = await self.complete(self.messages)
                except openai.BadRequestError as exc:
                    text = str(exc).lower()
                    if "context" in text or "too long" in text or "maximum" in text:
                        self.cb_finish("budget_wall")
                        break
                    raise
                step += 1

                calls = msg.get("tool_calls") or []
                if not calls:
                    msg.pop("tool_calls", None)
                    self.messages.append(msg)
                    note = (proto.EXPLAIN_NON_STANDALONE_TEXT
                            if proto.mentions_advance_marker(msg.get("content") or "")
                            else NO_TOOL_CALL_TEXT)
                    self.messages.append({"role": "user", "content": note})
                    self._manage_context_recorded()
                    continue

                call = calls[0]
                msg["tool_calls"] = [call]
                self.messages.append(msg)
                fn = call.get("function") or {}
                try:
                    args = json.loads(fn.get("arguments") or "{}")
                    command = str(args.get("command") or "")
                except Exception:
                    args, command = None, ""
                if fn.get("name") != "bash" or not command:
                    rc, content = 2, (
                        "error: call the `bash` tool with a JSON argument "
                        '{"command": "..."}'
                    )
                else:
                    rc, content = await self.execute(environment, command)
                self.messages.append(
                    {"role": "tool", "tool_call_id": call.get("id") or "",
                     "content": content}
                )
                self.messages += self.cb_user_turns(self.cb_pending(command, rc, turn=step))
                self._manage_context_recorded()
        except asyncio.CancelledError:
            self.cb_finish("timeout")
            raise
        finally:
            # An exception other than cancellation leaves terminated_by unset: a
            # crashed run has no terminal reason and must not look like one.
            self.cb_finish(None, self.messages)
            (self.logs_dir / "usage.json").write_text(
                json.dumps(
                    {**self._usage, "n_llm_calls": self._n_llm_calls,
                     "n_commands": self._n_commands, "n_turns": step,
                     "peak_context_tokens": self.cb_peak_tokens,
                     "wall_s": round(time.monotonic() - t0, 1),
                     "terminated_by": src.terminated_by,
                     "budget": self.budget, "reserve": self.reserve},
                    indent=2,
                ) + "\n",
                encoding="utf-8",
            )
            context.n_input_tokens = self._usage["prompt_tokens"]
            context.n_output_tokens = self._usage["completion_tokens"]
            context.metadata = {
                "n_turns": step,
                "terminated_by": src.terminated_by,
                "n_ops_delivered": src.n_delivered,
                "n_ops_total": src.n_total,
                "peak_context_tokens": self.cb_peak_tokens,
            }
