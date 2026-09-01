#!/usr/bin/env python3
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

"""Run test262-harness in bounded parallel batches.

The output format intentionally stays compatible with the previous runner:
one ``<pass> <file>`` record per harness result.
"""

import argparse
import concurrent.futures
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
from typing import Any, Iterable


def resolve_test262_paths(test262_dir: Path) -> tuple[Path, Path]:
  selected = test262_dir.resolve()
  if not selected.is_dir():
    raise ValueError(f"test262 directory does not exist: {selected}")
  for candidate in (selected, *selected.parents):
    if (candidate / "package.json").is_file() and (candidate / "harness").is_dir():
      return candidate, selected / "test" if (selected / "test").is_dir() else selected
  raise ValueError(
      f"cannot locate test262 root from {selected}; expected package.json and harness/")


def collect_tests(test_root: Path) -> list[Path]:
  return sorted(path for path in test_root.rglob("*.js") if path.is_file())


def batches(items: list[Path], size: int) -> Iterable[list[Path]]:
  for start in range(0, len(items), size):
    yield items[start:start + size]


def extract_json_report(output: str) -> list[dict[str, Any]]:
  stripped = output.strip()
  candidates = [stripped]
  first = stripped.find("[")
  last = stripped.rfind("]")
  if first >= 0 and last > first:
    candidates.append(stripped[first:last + 1])

  for candidate in candidates:
    if not candidate:
      continue
    try:
      value = json.loads(candidate)
    except json.JSONDecodeError:
      continue
    if isinstance(value, list) and all(isinstance(item, dict) for item in value):
      return value
    if isinstance(value, dict):
      return [value]

  records = []
  for line in stripped.splitlines():
    line = line.strip().lstrip(",")
    if not line:
      continue
    try:
      value = json.loads(line)
    except json.JSONDecodeError:
      continue
    if isinstance(value, dict):
      records.append(value)
  return records


def run_batch(harness: str, test262_root: Path, host_type: str, host_path: Path,
              tests: list[Path]) -> list[tuple[str, str]]:
  command = [
      harness, "--reporter", "json", "--reporter-keys",
      "result,file", "--host-type", host_type, "--host-path",
      str(host_path), "--test262-dir", str(test262_root),
      "--includes-dir", str(test262_root / "harness"),
      *(str(path) for path in tests)
  ]
  proc = subprocess.run(command, stdout=subprocess.PIPE,
                        stderr=subprocess.STDOUT, text=True, check=False)
  records = extract_json_report(proc.stdout)
  if not records:
    detail = proc.stdout.strip() or f"exit status {proc.returncode}"
    raise RuntimeError(f"test262-harness produced no JSON report:\n{detail}")

  results = []
  for record in records:
    result = record.get("result")
    filename = record.get("file")
    if not isinstance(result, dict) or "pass" not in result or not filename:
      raise RuntimeError(f"invalid test262-harness record: {record!r}")
    pass_value = result["pass"]
    if isinstance(pass_value, bool):
      passed = str(pass_value).lower()
    elif isinstance(pass_value, str) and pass_value.lower() in ("true", "false"):
      passed = pass_value.lower()
    else:
      raise RuntimeError(f"invalid test262 pass value: {pass_value!r}")
    results.append((str(filename), passed))
  return results


def parse_args() -> argparse.Namespace:
  parser = argparse.ArgumentParser(description="Run test262 cases")
  parser.add_argument("--test262Dir", default=".",
                      help="test262 root directory or its test directory")
  parser.add_argument("--type", required=True,
                      help="test262-harness host type, for example qjs")
  parser.add_argument("--bin", required=True,
                      help="path to the host VM executable")
  parser.add_argument("--output", default="./result.output",
                      help="output file")
  parser.add_argument("--t", type=int, default=5,
                      help="maximum concurrent harness processes")
  parser.add_argument("--batch-size", type=int, default=100,
                      help="maximum tests passed to one harness process")
  parser.add_argument("--harness", default=os.environ.get(
      "TEST262_HARNESS", "test262-harness"),
                      help="test262-harness executable")
  return parser.parse_args()


def main() -> int:
  args = parse_args()
  if args.t <= 0:
    raise ValueError("--t must be greater than zero")
  if args.batch_size <= 0:
    raise ValueError("--batch-size must be greater than zero")

  harness = shutil.which(args.harness)
  if harness is None:
    raise RuntimeError(
        f"cannot find {args.harness!r}; install test262-harness or pass "
        "--harness /absolute/path/to/test262-harness")
  host_path = Path(args.bin).expanduser().resolve()
  if not host_path.is_file() or not os.access(host_path, os.X_OK):
    raise ValueError(f"host executable is not executable: {host_path}")

  test262_root, test_root = resolve_test262_paths(Path(args.test262Dir))
  tests = collect_tests(test_root)
  if not tests:
    raise ValueError(f"no JavaScript tests found under {args.test262Dir}")
  work = list(batches(tests, args.batch_size))
  print(f"Total cases: {len(tests)} in {len(work)} batches")

  all_results = []
  with concurrent.futures.ThreadPoolExecutor(max_workers=args.t) as executor:
    futures = [executor.submit(run_batch, harness, test262_root, args.type,
                               host_path, batch)
               for batch in work]
    for completed, future in enumerate(concurrent.futures.as_completed(futures),
                                       start=1):
      all_results.extend(future.result())
      print(f"Finished batches: {completed}/{len(work)}", flush=True)

  all_results.sort(key=lambda item: item[0])
  output = Path(args.output).expanduser()
  output.parent.mkdir(parents=True, exist_ok=True)
  with output.open("w", encoding="utf-8") as stream:
    for filename, passed in all_results:
      stream.write(f"{passed} {filename}\n")

  passed_count = sum(passed == "true" for _, passed in all_results)
  print(f"Reported cases: {len(all_results)}; passed: {passed_count}; "
        f"failed: {len(all_results) - passed_count}")
  return 0


if __name__ == "__main__":
  try:
    raise SystemExit(main())
  except (OSError, RuntimeError, ValueError) as error:
    print(f"run_test262: {error}", file=sys.stderr)
    raise SystemExit(2)
