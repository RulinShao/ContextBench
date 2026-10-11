"""``Terminus2Stream``: Harbor's own terminus-2 agent, fed by a ContextBench stream.

Terminus 2 talks to the model in plain chat: every turn's user message is the
terminal output of the previous turn (the ``prompt`` variable of its episode loop).
This subclass appends the next op to exactly that user message, so the op enters
the conversation as a ``role="user"`` message appended by the harness, in the one
continuous chat terminus keeps across the run. Nothing else in terminus changes: its
prompt template, JSON command format, output limiting and its own context
summarization are the harness under test.

Overridden, all narrow:

* ``run`` -- loads the :class:`TurnSource` (and removes the stream from the
  container) before terminus starts, and queues op 0 for the first prompt;
* ``_run_agent_loop`` -- wraps the stock loop to end it cleanly when the stream
  says the run is over;
* ``_execute_commands`` -- after the stock execution, asks the TurnSource what the
  last command earned (the next op, an explanation, or nothing);
* ``_handle_llm_interaction`` -- before the stock model call, appends queued texts
  to ``prompt`` and records each op as an ATIF ``user`` step; snapshots the context
  about to be sent (``kind="sent"``) and enforces the budget wall on it; after the
  call, snapshots the context with the reply (``kind="turn"``, so an answer survives
  a later summarization) and refuses ``task_complete`` while ops remain (the refusal
  is delivered with the next prompt);
* ``_check_proactive_summarization`` -- skipped once the run is over (the next
  ``_handle_llm_interaction`` then records the last terminal output and stops).

Readiness is the standalone command ``echo READY_FOR_NEXT_OP`` as the last keystroke
batch of a turn. Terminus types into tmux and cannot observe exit codes, so the batch
counts only when it did not time out **and** the terminal shows the echo's own output
line: keystrokes typed into a program still reading stdin never print it.
"""

from __future__ import annotations

import asyncio
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from harbor.agents.terminus_2.terminus_2 import Command, Terminus2
from harbor.environments.base import BaseEnvironment
from harbor.models.agent.context import AgentContext
from harbor.models.trajectories import Step

from ... import stream as proto
from ...tokens import count_tokens, record_snapshot
from ..turn_source import TurnSource

__all__ = ["Terminus2Stream"]


#: Sent when the readiness command was typed but its output never appeared.
NOT_EXECUTED_TEXT = (
    f"[{proto.ADVANCE_MARKER} did NOT advance: the terminal never printed the line "
    f"`{proto.ADVANCE_MARKER}`, so the echo did not run (is an earlier command still "
    "waiting for input, or did it time out?). Get back to a shell prompt, then run "
    f"`echo {proto.ADVANCE_MARKER}` on its own.]"
)


class _StreamDone(Exception):
    """Raised inside the loop when the TurnSource has a terminal reason."""


class Terminus2Stream(Terminus2):
    """terminus-2 with ContextBench ops appended to its user turns."""

    def __init__(
        self,
        logs_dir: Path,
        model_name: str | None = None,
        *args: Any,
        context_budget_tokens: int = 32768,
        context_budget_reserve_tokens: int = 2048,
        **kwargs: Any,
    ):
        # tmux hard-wraps output at the pane width, and a wrapped answer line is a
        # different string ("willow" -> "will\now"). terminus's default of 160
        # columns splits kv values and log lines; 400 fits every ContextBench line.
        kwargs.setdefault("tmux_pane_width", 400)
        # terminus summarizes when its model's context limit minus the history drops
        # below ``proactive_summarization_threshold``. Without ``model_info`` it asks
        # LiteLLM, which knows nothing of the budget (or of a local model). Default the
        # limit to the budget, as CodexStream sets codex's context window; a
        # launcher-provided ``model_info`` wins.
        if not kwargs.get("model_info"):
            kwargs["model_info"] = {
                "max_input_tokens": int(context_budget_tokens),
                "max_output_tokens": 8192,
                "input_cost_per_token": 0.0,
                "output_cost_per_token": 0.0,
            }
        super().__init__(logs_dir, model_name, *args, **kwargs)
        self.cb_budget = int(context_budget_tokens)
        self.cb_reserve = int(context_budget_reserve_tokens)
        self.turn_source: TurnSource | None = None
        #: (text, kind, op index) waiting to ride on the next prompt.
        self._cb_queue: list[tuple[str, str, int | None]] = []
        self._cb_snap_step = 0
        self._cb_peak_tokens = 0
        self._cb_final_done = False
        #: terminus's summarization subagent calls (summary / questions / answers).
        #: They are not turns of the main chat, so the wall does not apply to them and
        #: no snapshot is written; their size is recorded here instead.
        self._cb_subagent_calls: list[dict[str, Any]] = []

    @staticmethod
    def name() -> str:
        return "terminus-2-contextbench"

    # ----------------------------------------------------------------- helpers
    def _cb_snapshot(self, messages: list[Any], kind: str) -> int:
        ts = self.turn_source
        tokens, _ = count_tokens(messages)
        self._cb_peak_tokens = max(self._cb_peak_tokens, tokens)
        record_snapshot(
            self.logs_dir, self._cb_snap_step, list(messages),
            {"kind": kind, "episode": self._n_episodes,
             "summarization_count": self._summarization_count,
             "n_ops_delivered": ts.n_delivered if ts else 0,
             "n_ops_total": ts.n_total if ts else 0,
             "budget": self.cb_budget, "reserve": self.cb_reserve},
        )
        self._cb_snap_step += 1
        return tokens

    def _cb_user_step(self, text: str, kind: str, index: int | None) -> None:
        self._trajectory_steps.append(
            Step(
                step_id=len(self._trajectory_steps) + 1,
                timestamp=datetime.now(timezone.utc).isoformat(),
                source="user",
                message=text,
                extra={"contextbench": {"kind": kind, "op_index": index}},
            )
        )

    # --------------------------------------------------------------- overrides
    async def run(
        self, instruction: str, environment: BaseEnvironment, context: AgentContext
    ) -> None:
        ts = self.turn_source = await TurnSource.load(environment, logs_dir=self.logs_dir)
        first = ts.first_turn(turn=0)
        self._cb_queue = [(first, "op", 0)] if first is not None else []
        try:
            await super().run(instruction, environment, context)
        except asyncio.CancelledError:
            ts.terminate("timeout")
            raise
        finally:
            if self._chat is not None and not self._cb_final_done:
                self._cb_snapshot(self._chat.messages, "final")
            ts.write()
            usable = self.cb_budget - self.cb_reserve
            (Path(self.logs_dir) / "contextbench_subagent_calls.json").write_text(
                json.dumps({"usable": usable, "calls": self._cb_subagent_calls},
                           indent=1) + "\n", encoding="utf-8")
            meta = dict(context.metadata or {})
            meta.update({
                "terminated_by": ts.terminated_by,
                "n_ops_delivered": ts.n_delivered,
                "n_ops_total": ts.n_total,
                "peak_context_tokens": self._cb_peak_tokens,
                "n_subagent_calls": len(self._cb_subagent_calls),
                "n_subagent_calls_over_budget": sum(
                    1 for c in self._cb_subagent_calls if c["tokens"] > usable),
            })
            context.metadata = meta

    async def _run_subagent(self, prompt: str, message_history: list[dict[str, Any]],
                            *args: Any, **kwargs: Any):
        # Measure what the summarization subagent is about to send; the call itself
        # is stock. ``filename_suffix`` names the step (summary / questions / answers).
        tokens, _ = count_tokens(list(message_history) + [{"role": "user", "content": prompt}])
        suffix = kwargs.get("filename_suffix", args[3] if len(args) > 3 else None)
        call = {"summarization": self._summarization_count, "step": suffix,
                "tokens": tokens, "ok": False}
        self._cb_subagent_calls.append(call)
        result = await super()._run_subagent(prompt, message_history, *args, **kwargs)
        call["ok"] = True
        return result

    async def _run_agent_loop(self, initial_prompt: str, chat: Any,
                              original_instruction: str = "") -> None:
        try:
            await super()._run_agent_loop(initial_prompt, chat, original_instruction)
        except _StreamDone:
            self._dump_trajectory()
            return
        ts = self.turn_source
        if ts is not None and not ts.done:
            # The stock loop returned on its own: a confirmed task_complete (only
            # possible after the drain, see _handle_llm_interaction), a dead
            # session, or its episode cap.
            if self._pending_completion and ts.drained:
                ts.terminate("submit")
            else:
                ts.terminate("max_steps")

    async def _check_proactive_summarization(self, chat: Any, original_instruction: str,
                                             session: Any):
        if self.turn_source is not None and self.turn_source.done:
            return None  # no summary; _handle_llm_interaction records and stops
        return await super()._check_proactive_summarization(
            chat, original_instruction, session
        )

    async def _execute_commands(self, commands: list[Command], session: Any):
        timeout_occurred, output = await super()._execute_commands(commands, session)
        ts = self.turn_source
        if ts is not None and commands:
            last = (commands[-1].keystrokes or "").strip()
            # tmux has no exit code. The marker counts only when its echo actually
            # printed: a batch typed into a program still waiting for input (a `sed`
            # with no file, an open heredoc) shows the keystrokes but never the
            # standalone output line.
            ran = not timeout_occurred and proto.is_ready_line(output)
            before = ts.n_delivered
            texts = ts.pending(last, None if ran else 1, turn=self._n_episodes)
            for text in texts:
                if ts.n_delivered > before:
                    self._cb_queue.append((text, "op", before))
                elif text == proto.EXPLAIN_NON_STANDALONE_TEXT and \
                        proto.is_ready_command(last, 0):
                    self._cb_queue.append((NOT_EXECUTED_TEXT, "protocol", None))
                else:
                    self._cb_queue.append((text, "protocol", None))
        return timeout_occurred, output

    async def _handle_llm_interaction(self, chat: Any, prompt: str,
                                      original_instruction: str = "",
                                      session: Any = None):
        ts = self.turn_source
        if ts is not None and ts.done:
            # The last command's output (often the final answer) is in ``prompt``:
            # terminus would send it next. Record it as part of the final context,
            # as a harness that appends tool results does, before stopping.
            self._cb_snapshot(list(chat.messages) + [{"role": "user", "content": prompt}],
                              "final")
            self._cb_final_done = True
            raise _StreamDone()

        if self._cb_queue:
            queued, self._cb_queue = self._cb_queue, []
            for text, kind, index in queued:
                self._cb_user_step(text, kind, index)
            prompt = prompt.rstrip("\n") + "\n\n" + "\n\n".join(t for t, _, _ in queued)

        if ts is not None:
            # The wall is on what is about to be sent, after terminus's own
            # summarization had its chance at the top of the episode.
            sent = list(chat.messages) + [{"role": "user", "content": prompt}]
            if self._cb_snapshot(sent, "sent") > self.cb_budget - self.cb_reserve:
                ts.terminate("budget_wall")
                raise _StreamDone()

        result = await super()._handle_llm_interaction(
            chat, prompt, original_instruction, session
        )
        self._cb_snapshot(chat.messages, "turn")

        commands, is_task_complete, feedback, analysis, plan, llm_response = result
        if is_task_complete and ts is not None and not ts.drained:
            # Refused: the stock loop sees an ordinary turn, and the refusal text
            # rides on the next prompt.
            for text in ts.on_submit(trigger="task_complete", turn=self._n_episodes):
                self._cb_queue.append((text, "protocol", None))
            is_task_complete = False
        return commands, is_task_complete, feedback, analysis, plan, llm_response
