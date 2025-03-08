#!/usr/bin/env python
# Copyright 2020 The Lynx Authors. All rights reserved.

import os
import subprocess
import sys
import argparse
import platform
from collections import namedtuple

OS_PLATFORM = ""
TARGET_OS = ""
if sys.platform == "darwin":
    OS_PLATFORM = "mac"
    TARGET_OS = 'target_os = "mac"'
elif sys.platform.startswith("linux"):
    OS_PLATFORM = "linux64"
    TARGET_OS = 'target_os = "linux"'
else:
    print("Error, host OS not supported!")
    sys.exit(1)

TARGET_CPU = ""
print("cpu arch: ", platform.machine())
if platform.machine() == "arm64":
    TARGET_CPU = 'target_cpu = "arm64"'


def CheckUnitTestsBuild(options):
    print("Starting checking if unittests can be built.")
    cwd = os.getcwd()
    gn_path = os.path.join(cwd, "tools/buildtools/gn/", OS_PLATFORM)
    ninja_path = os.path.join(cwd, "tools/buildtools/ninja/", OS_PLATFORM)

    os.environ["PATH"] = ":".join([ninja_path, gn_path, os.environ["PATH"]])

    gn_common_build_args = """
    enable_unittests = true
    is_asan = true
    # is_ubsan = true
    use_lepusng = true
    enable_coverage = true
    use_rtti = true
    is_debug = true
    enable_quickjs_debugger = true
    {}
    {}
  """.format(
        TARGET_CPU, TARGET_OS
    )

    gn_gen_cmd = """ gn gen out/Default --args='%s' """ % (gn_common_build_args)
    print("gn_gen_cmd: ", gn_gen_cmd)

    gn_clean_cmd = "gn clean out/Default"
    build_qjs_cmd = "ninja -C out/Default qjs"
    build_test262 = "ninja -C out/Default run_test262"
    build_quickjs_unittest = "ninja -C out/Default quickjs_unittest"
    build_qjs_debug_unittest = "ninja -C out/Default qjs_debug_test"
    build_napi_unittest = "ninja -C out/Default napi_unittest"

    # enable_snapishot cannot use rtti when compiling
    gn_primjs_snapshot_build_args = """
        enable_unittests = true
        # is_asan = true
        # is_ubsan = true
        use_lepusng = true
        enable_primjs_snapshot = true
        enable_compatible_mm = true
        enable_tracing_gc = true
        enable_coverage = true
        use_rtti = true
        enable_quickjs_debugger = true
        {}
        {}
  """.format(
        TARGET_CPU, TARGET_OS
    )

    gn_primjs_snapshot_gen_cmd = """ gn gen out/Default_snapshot --args='%s' """ % (
        gn_primjs_snapshot_build_args
    )

    gn_primjs_snapshot_clean_cmd = "gn clean out/Default_snapshot"
    build_primjs_snapshot_cmd = "ninja -C out/Default_snapshot qjs"
    build_primjs_snapshot_test262 = "ninja -C out/Default_snapshot run_test262"
    build_primjs_snapshot_quickjs_unittest = (
        "ninja -C out/Default_snapshot quickjs_unittest"
    )
    build_primjs_snapshot_qjs_debug_unittest = (
        "ninja -C out/Default_snapshot qjs_debug_test"
    )
    build_primjs_snapshot_napi_unittest = "ninja -C out/Default_snapshot napi_unittest"

    subprocess.check_call(gn_gen_cmd, shell=True)
    subprocess.check_call(gn_clean_cmd, shell=True)
    subprocess.check_call(build_qjs_cmd, shell=True)
    subprocess.check_call(build_test262, shell=True)
    subprocess.check_call(build_quickjs_unittest, shell=True)
    subprocess.check_call(build_qjs_debug_unittest, shell=True)
    subprocess.check_call(build_napi_unittest, shell=True)

    subprocess.check_call(gn_primjs_snapshot_gen_cmd, shell=True)
    subprocess.check_call(gn_primjs_snapshot_clean_cmd, shell=True)
    subprocess.check_call(build_primjs_snapshot_cmd, shell=True)
    subprocess.check_call(build_primjs_snapshot_test262, shell=True)
    subprocess.check_call(build_primjs_snapshot_quickjs_unittest, shell=True)
    subprocess.check_call(build_primjs_snapshot_qjs_debug_unittest, shell=True)
    subprocess.check_call(build_primjs_snapshot_napi_unittest, shell=True)
    sys.exit(0)


def main():
    parser = argparse.ArgumentParser()
    args = parser.parse_args()
    Option = namedtuple("Option", ["android"])
    option = Option(android=False)
    CheckUnitTestsBuild(option)


if __name__ == "__main__":
    sys.exit(main())
