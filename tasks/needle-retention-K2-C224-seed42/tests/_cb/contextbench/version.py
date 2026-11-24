"""The ContextBench version: the one place it is defined.

``BENCHMARK_VERSION`` names the benchmark's rules (task streams, gold, how runs are
recorded and graded); every grade records it (``benchmark_version`` in the grader's
result and ``contextbench_result.json``, and as a number in ``reward.json``).
``PACKAGE_VERSION`` is the Python distribution's version (``pyproject.toml``).

Standard library only: the copy of the graders in each task's ``tests/_cb`` carries
this file too.
"""

BENCHMARK_VERSION = "0.1"
PACKAGE_VERSION = "0.1.0"

__all__ = ["BENCHMARK_VERSION", "PACKAGE_VERSION"]
