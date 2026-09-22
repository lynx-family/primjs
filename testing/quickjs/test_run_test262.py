# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

import importlib.util
from pathlib import Path
import tempfile
import unittest


MODULE_PATH = Path(__file__).with_name("run_test262.py")
SPEC = importlib.util.spec_from_file_location("run_test262", MODULE_PATH)
RUNNER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RUNNER)


class RunTest262Test(unittest.TestCase):

  def test_extract_json_report_accepts_array_and_ndjson(self):
    array = '[{"result": {"pass": true}, "file": "a.js"}]'
    self.assertEqual(RUNNER.extract_json_report(array)[0]["file"], "a.js")
    ndjson = (
        '{"result": {"pass": true}, "file": "a.js"}\n'
        ',{"result": {"pass": false}, "file": "b.js"}'
    )
    self.assertEqual(len(RUNNER.extract_json_report(ndjson)), 2)

  def test_resolve_test262_paths_from_nested_directory(self):
    with tempfile.TemporaryDirectory() as directory:
      root = Path(directory)
      (root / "package.json").write_text("{}", encoding="utf-8")
      (root / "harness").mkdir()
      nested = root / "test" / "language"
      nested.mkdir(parents=True)
      resolved_root, test_root = RUNNER.resolve_test262_paths(nested)
      self.assertEqual(resolved_root, root.resolve())
      self.assertEqual(test_root, nested.resolve())

  def test_batches_use_integer_boundaries(self):
    values = [Path(str(index)) for index in range(5)]
    self.assertEqual([len(batch) for batch in RUNNER.batches(values, 2)],
                     [2, 2, 1])


if __name__ == "__main__":
  unittest.main()
