"""In-container driver for ``MiniSweAgentStream``: one mini-swe-agent step per call.

mini-swe-agent's CLI has no way to resume a session, so the host adapter drives
the library's own ``DefaultAgent`` one step at a time, resuming the saved message
list on every call. Each call:

1. loads the saved messages (``--state``), or starts a new session (``--init``)
   with mini-swe-agent's builtin config (system and instance templates, tool
   format, observation template -- the harness under test, unchanged);
2. appends the user turns the host passed in (``--user-file``: a JSON list of
   strings), after dropping a trailing ``exit`` message the host refused;
3. runs exactly one ``DefaultAgent.step()`` (skipped with ``--no-step``), with
   mini-swe-agent's own handling of format errors and of its submit command;
4. saves the messages and prints one JSON line: the commands executed this step
   with their return codes, and whether the agent tried to exit.

This file runs with the interpreter that has ``minisweagent`` installed; it
imports nothing from ContextBench.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


#: The host parses the last stdout line starting with this prefix.
RESULT_PREFIX = "CB_DRIVER_RESULT "


def _build(model_name: str, model_kwargs: dict, timeout: int):
    from minisweagent.agents.default import AgentConfig, DefaultAgent
    from minisweagent.config import get_config_from_spec
    from minisweagent.environments import get_environment
    from minisweagent.models import get_model
    from minisweagent.utils.serialize import recursive_merge

    config = recursive_merge(
        get_config_from_spec("mini"),
        {
            "model": {"model_name": model_name, "model_kwargs": model_kwargs},
            "agent": {"cost_limit": 0, "step_limit": 0},
            "environment": {"timeout": timeout},
        },
    )
    model = get_model(config=config.get("model", {}))
    env = get_environment(config.get("environment", {}), default_type="local")
    fields = set(AgentConfig.model_fields)
    agent_cfg = {k: v for k, v in (config.get("agent") or {}).items() if k in fields}
    agent = DefaultAgent(model, env, **agent_cfg)
    return agent


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--state", required=True, type=Path)
    ap.add_argument("--model", required=True)
    ap.add_argument("--model-kwargs", default="{}")
    ap.add_argument("--timeout", type=int, default=120)
    ap.add_argument("--init", action="store_true")
    ap.add_argument("--task-file", type=Path)
    ap.add_argument("--user-file", type=Path)
    ap.add_argument("--no-step", action="store_true")
    a = ap.parse_args(argv)

    from minisweagent.exceptions import FormatError, InterruptAgentFlow

    agent = _build(a.model, json.loads(a.model_kwargs), a.timeout)

    if a.init:
        task = a.task_file.read_text(encoding="utf-8")
        agent.extra_template_vars |= {"task": task}
        agent.messages = []
        agent.add_messages(
            agent.model.format_message(
                role="system", content=agent._render_template(agent.config.system_template)),
            agent.model.format_message(
                role="user", content=agent._render_template(agent.config.instance_template)),
        )
        state = {"task": task, "n_calls": 0, "cost": 0.0}
    else:
        state = json.loads(a.state.read_text(encoding="utf-8"))
        agent.extra_template_vars |= {"task": state.get("task", "")}
        agent.messages = state["messages"]
        agent.n_calls = int(state.get("n_calls", 0))
        agent.cost = float(state.get("cost", 0.0))

    if a.user_file:
        texts = json.loads(a.user_file.read_text(encoding="utf-8"))
        while agent.messages and agent.messages[-1].get("role") == "exit":
            agent.messages.pop()  # the host refused the exit; the session goes on
        for text in texts:
            agent.add_messages(agent.model.format_message(role="user", content=text))

    executed: list[dict] = []
    if not a.no_step:
        orig = agent.env.execute

        def _execute(action, *args, **kwargs):
            try:
                out = orig(action, *args, **kwargs)
            except InterruptAgentFlow:
                executed.append({"command": action.get("command", ""), "returncode": 0})
                raise
            executed.append({"command": action.get("command", ""),
                             "returncode": out.get("returncode", -1)})
            return out

        agent.env.execute = _execute
        try:
            agent.step()
        except FormatError as e:
            agent.add_messages(*e.messages)
        except InterruptAgentFlow as e:
            agent.add_messages(*e.messages)

    last = agent.messages[-1] if agent.messages else {}
    state.update({"messages": agent.messages, "n_calls": agent.n_calls, "cost": agent.cost})
    a.state.parent.mkdir(parents=True, exist_ok=True)
    tmp = a.state.with_suffix(".tmp")
    tmp.write_text(json.dumps(state), encoding="utf-8")
    tmp.replace(a.state)
    print(RESULT_PREFIX + json.dumps({
        "executed": executed,
        "exit": last.get("role") == "exit",
        "exit_status": (last.get("extra") or {}).get("exit_status", ""),
        "n_messages": len(agent.messages),
    }))
    return 0


if __name__ == "__main__":
    sys.exit(main())
