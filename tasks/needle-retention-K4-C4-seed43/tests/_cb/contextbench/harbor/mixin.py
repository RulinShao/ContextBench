"""``CBStreamMixin``: ContextBench support for any Python agent loop under Harbor.

Add the mixin to your Harbor agent and three calls to its loop::

    class MyAgent(CBStreamMixin, BaseAgent):
        async def run(self, instruction, environment, context):
            await self.cb_setup(environment)                               # 1
            messages = [system, {"role": "user", "content": instruction}]
            messages += self.cb_user_turns(self.cb_initial_turns())
            while not self.cb_done:
                ...                                                        # model call
                messages.append(tool_result_message)
                messages += self.cb_user_turns(                            # 2
                    self.cb_pending(command, exit_code))
                if self.cb_over_budget(messages):                          # 3
                    break

The mixin owns everything else: loading and verifying the stream (and removing it
from the container), the readiness rule, the early-submit refusal, the terminal
reason, ``interactive_stream.json`` and the ``context_snapshots/turn-NNNN.json`` the
graders read. ``cb_over_budget`` both snapshots the context you are about to send
and enforces the budget wall on it; call it right before every model call (or where
your loop sends), and call :meth:`cb_finish` in a ``finally``: it writes the closing
line of the snapshot manifest, without which the run is graded as invalid.

The snapshots go to a host-only root, ``<trial_dir>/contextbench_harness/`` (see
:func:`contextbench.tokens.harness_dir_for`), not to the logs dir Harbor mounts into
the container at ``/logs/agent``, so the agent can neither read nor plant them. Set
``cb_snapshot_root`` before ``cb_setup`` to put them elsewhere. A snapshot that cannot
be written raises :class:`contextbench.tokens.SnapshotWriteError`.
"""

from __future__ import annotations

from pathlib import Path
from typing import Any

from ..tokens import SnapshotLog, harness_dir_for
from .turn_source import TurnSource

__all__ = ["CBStreamMixin"]


class CBStreamMixin:
    """Stream delivery, snapshots and the budget wall for a Harbor agent loop."""

    logs_dir: Path

    #: Budget of record; override per instance with ``cb_setup(budget=...)``.
    cb_budget: int = 32768
    cb_reserve: int = 2048
    #: Where the snapshots go; ``None``: ``harness_dir_for(self.logs_dir)``.
    cb_snapshot_root: Path | None = None

    # ------------------------------------------------------------------ setup
    async def cb_setup(self, environment: Any, *, budget: int | None = None,
                       reserve: int | None = None, **load_kwargs: Any) -> TurnSource:
        """Load the task's stream (verified, then removed from the container)."""
        if budget is not None:
            self.cb_budget = int(budget)
        if reserve is not None:
            self.cb_reserve = int(reserve)
        root = Path(self.cb_snapshot_root) if self.cb_snapshot_root else \
            harness_dir_for(self.logs_dir)
        self.cb_snapshots = SnapshotLog(root)
        self.cb_source = await TurnSource.load(
            environment, logs_dir=self.logs_dir, **load_kwargs)
        self.cb_source.harness_dir = root
        self.cb_source.write()
        self._cb_snap_step = 0
        self.cb_peak_tokens = 0
        return self.cb_source

    @property
    def cb_turn_source(self) -> TurnSource | None:
        return getattr(self, "cb_source", None)

    # --------------------------------------------------------------- delivery
    def cb_initial_turns(self) -> list[str]:
        """The user turns to append after the instruction: op 0."""
        first = self.cb_source.first_turn(turn=0)
        return [first] if first is not None else []

    def cb_pending(self, last_command: str | None, last_exit: int | None = 0, *,
                   turn: int | None = None) -> list[str]:
        """The user turns to append right after the tool result of ``last_command``."""
        return self.cb_source.pending(last_command, last_exit, turn=turn)

    def cb_submit(self, *, trigger: str = "<submit>") -> list[str]:
        """The harness's own finish signal: refused (texts returned) until the drain."""
        return self.cb_source.on_submit(trigger=trigger)

    @property
    def cb_done(self) -> bool:
        src = self.cb_turn_source
        return bool(src and src.done)

    @staticmethod
    def cb_user_turns(texts: list[str]) -> list[dict[str, str]]:
        return [{"role": "user", "content": t} for t in texts]

    # ------------------------------------------------------ snapshots and wall
    def cb_snapshot(self, messages: list[Any], kind: str = "sent",
                    extra: dict[str, Any] | None = None) -> int:
        """Write ``context_snapshots/turn-NNNN.json``; returns its token count.

        Raises :class:`~contextbench.tokens.SnapshotWriteError` if it cannot be
        written (the run is then graded as invalid)."""
        src = self.cb_turn_source
        log = getattr(self, "cb_snapshots", None)
        if log is None:
            raise RuntimeError("cb_snapshot before cb_setup: no snapshot log")
        step = getattr(self, "_cb_snap_step", 0)
        self._cb_snap_step = step + 1
        _, tokens = log.record(
            step, list(messages),
            {"kind": kind, "n_ops_delivered": src.n_delivered if src else 0,
             "n_ops_total": src.n_total if src else 0,
             "budget": self.cb_budget, "reserve": self.cb_reserve, **(extra or {})},
        )
        self.cb_peak_tokens = max(getattr(self, "cb_peak_tokens", 0), tokens)
        return tokens

    def cb_over_budget(self, messages: list[Any]) -> bool:
        """Snapshot what is about to be sent; True (and ``budget_wall``) if it is over."""
        if self.cb_snapshot(messages, "sent") > self.cb_budget - self.cb_reserve:
            self.cb_source.terminate("budget_wall")
            return True
        return False

    def cb_finish(self, reason: str | None = None,
                  messages: list[Any] | None = None) -> None:
        """Record a terminal reason if none was set, snapshot the final context, and
        close the snapshot manifest (the graders require the closing line)."""
        src = self.cb_turn_source
        if src is None:
            return
        if reason and not src.done:
            src.terminate(reason)
        try:
            if messages is not None:
                self.cb_snapshot(messages, "final")
        finally:
            src.write()
            log = getattr(self, "cb_snapshots", None)
            if log is not None:
                log.close(terminated_by=src.terminated_by,
                          n_ops_delivered=src.n_delivered, n_ops_total=src.n_total)
