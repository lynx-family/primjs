#!/usr/bin/env python
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.
import subprocess
import sys
import os
import time
import optparse

primjs_root_dir = sys.path[0] + "/../.."
qjs = primjs_root_dir + "/out/Default/qjs"
tests = primjs_root_dir + "/out/Default/qjs_tests"
total_case = 0
total_passed = 0

def readFile(dirName):
    files = os.listdir(dirName)
    result_list = []
    for f in files:
        abs_file = os.path.join(dirName, f)
        result_list.append(abs_file)
        if os.path.isdir(abs_file):
            for actual_files in readFile(abs_file):
                result_list.append(actual_files)

    return result_list

def runCommand(f, flags):
    # # !!! TODO: skip local_variables.js
    if f.endswith("local_variables.js"):
        print("skip local_variables.js")
        return 0
    returncode = 0
    output = None
    timeout = False
    try:
        output = subprocess.run(
            [qjs, f],
            timeout=30,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
        )
        print(output.stdout.decode(), output.stderr.decode())
    except subprocess.TimeoutExpired:
        timeout = True
        returncode = -1
    except subprocess.CalledProcessError as e:
        returncode = e.returncode
        output = e.output
        print("return code:{}, output: {}".format(returncode, output))
    if returncode == 0:
        return 0

    if timeout:
        print("TIMEOUT")
    else:
        for line in output:
            print(line)
        print("exit code %d CRASHED" % returncode)
    return -1


def runCase(file, default_flags):
    global total_case
    global total_passed
    total_case = total_case + 1
    returncode = runCommand(file, default_flags)
    if returncode == 0:
        total_passed = total_passed + 1


def Main():
    parser = optparse.OptionParser()
    parser.add_option(
        "-b",
        "--binary",
        default="out/Default",
        help="The binary directory, default is 'out/Default'.",
    )
    opts, args = parser.parse_args()
    global qjs
    global tests
    qjs = primjs_root_dir + "/" + opts.binary + "/qjs"
    tests = primjs_root_dir + "/" + opts.binary + "/qjs_tests"
    for f in readFile(tests):
        t = f.split(".")[-1]
        if t == "js":
            runCase(f, "")
    print("Test passed %d of %d" % (total_passed, total_case))
    if total_case != total_passed:
        raise RuntimeError("failed")


if __name__ == "__main__":
    sys.exit(Main())
