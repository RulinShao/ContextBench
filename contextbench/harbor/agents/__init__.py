"""Harbor agents that consume a ContextBench stream through ``TurnSource``.

* ``ContextBenchAgent`` -- minimal bash-tool loop (append-only baseline, base class
  for Python harnesses);
* ``Terminus2Stream`` -- Harbor's terminus-2 with ops appended to its user turns;
* ``CodexStream`` / ``MiniSweAgentStream`` -- re-exported from
  :mod:`contextbench.harbor.wrap`, where ``cb_stream(AgentCls)`` builds them.

Import paths for a trial config: ``contextbench.harbor.agents:ContextBenchAgent``
``contextbench.harbor.agents:Terminus2Stream``,
``contextbench.harbor.agents:CodexStream`` and
``contextbench.harbor.agents:MiniSweAgentStream``.
"""

from __future__ import annotations

from typing import Any

__all__ = ["CodexStream", "ContextBenchAgent", "MiniSweAgentStream", "Terminus2Stream"]


def __getattr__(name: str) -> Any:
    if name == "ContextBenchAgent":
        from .base import ContextBenchAgent

        return ContextBenchAgent
    if name == "Terminus2Stream":
        from .terminus2_stream import Terminus2Stream

        return Terminus2Stream
    if name in ("CodexStream", "MiniSweAgentStream"):
        from .. import wrap

        return getattr(wrap, name)
    raise AttributeError(name)
