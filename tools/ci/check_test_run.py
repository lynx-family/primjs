#!/usr/bin/env python
# Copyright 2020 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.
"""
This script checks unit test results
"""
import os
import subprocess
import sys

test_case = ["", "_snapshot", "_bytecode_opt"]


def CheckUnitTestRun():
    print("Check unittest cases...", flush=True)
    cwd = os.getcwd()
    for case in test_case:
        info = ""
        if case == "":
            info = "quickjs"
        else:
            info = "primjs" + case
        binary_dir = "./out/Default{}/".format(case)
        os.environ["LLVM_PROFILE_FILE"] = binary_dir + "qjs.profraw"

        # bytecode_opt only runs quickjs_unittest and test262
        if case == "_bytecode_opt":
            unittest_cases = [
                "quickjs_unittest",
            ]
        else:
            unittest_cases = [
                "qjs_debug_test",
                "quickjs_unittest",
                "napi_unittest",
                "heap_unittest",
            ]
        for unittest in unittest_cases:
            print(
                "{}: Check %s cases...".format(info) % unittest,
                flush=True,
            )
            os.environ["LLVM_PROFILE_FILE"] = (
                binary_dir + "%s.profraw" % unittest
            )
            output = subprocess.run(
                [
                    binary_dir + unittest,
                ],
                stderr=sys.stderr,
                stdout=sys.stdout,
                text=True,
                check=True,
            )

        # run js test using qjs (skip for bytecode_opt)
        if case != "_bytecode_opt":
            print("{}: Check quickjs test cases...".format(info), flush=True)
            output = subprocess.run(
                ["python3", "tools/ci/run_quickjs_unittests.py", "-b", binary_dir],
                text=True,
                stdout=sys.stdout,
                stderr=sys.stderr,
                check=True,
            )
        # run test262
        print("{}: Check test262 cases...".format(info), flush=True)
        output = subprocess.run(
            [
                binary_dir + "run_test262",
                "-m",
                "-a",
                "-c",
                binary_dir + "quickjs_test/test262.conf",
            ],
            text= True,
            stdout= sys.stdout,
            stderr= sys.stderr,
            check=True,
        )
    print("Congratulations! All tests are passed.\n", flush=True)


def main():
    CheckUnitTestRun()

if __name__ == "__main__":
    sys.exit(main())
