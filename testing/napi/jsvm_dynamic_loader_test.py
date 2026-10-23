#!/usr/bin/env python3
# Copyright 2026 The PrimJS Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

"""Host regression tests for the optional Harmony JSVM dynamic loader.

Run with Python 3 and a host C++ compiler, for example:
  python3 oss/testing/napi/jsvm_dynamic_loader_test.py \
      --sdk-include /path/to/native/sysroot/usr/include

Only the SDK's ark_runtime and info headers are exposed to the host compiler;
its C and C++ standard library headers continue to come from the host toolchain.
All build products and mock libraries live in a temporary directory. One mock
API verifies function-pointer forwarding; the others test symbol discovery.
"""

import argparse
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys
import tempfile


HARNESS = r"""
#include <dlfcn.h>

#include <atomic>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <thread>
#include <vector>

#include "napi/harmony/jsvm_dynamic_loader.h"

namespace {
std::atomic<int> open_count{0};
std::atomic<int> symbol_count{0};
std::atomic<int> close_count{0};

void Check(bool condition, const char* expression, int line) {
  if (!condition) {
    std::cerr << "line " << line << ": " << expression << '\n';
    std::exit(1);
  }
}
#define CHECK(expression) Check((expression), #expression, __LINE__)

constexpr int kFunctionCount = 0
#define JSVM_FUNCTION(name) + 1
#include "napi/harmony/jsvm_functions.inc"
#undef JSVM_FUNCTION
;

void CheckFunctions(const primjs::harmony::JSVMFunctions* functions) {
  CHECK(functions != nullptr);
#define JSVM_FUNCTION(name) CHECK(functions->name != nullptr);
#include "napi/harmony/jsvm_functions.inc"
#undef JSVM_FUNCTION
}

void CheckExplicitLoader(const char* path, bool expected_available) {
  primjs::harmony::JSVMDynamicLoader loader(path);
  CHECK(open_count.load() == 1);
  const auto* functions = loader.GetFunctions();
  CHECK((functions != nullptr) == expected_available);
  if (expected_available) {
    CheckFunctions(functions);
    CHECK(symbol_count.load() == kFunctionCount);
    const auto mock_env = reinterpret_cast<JSVM_Env>(0x1234);
    const auto mock_value = reinterpret_cast<JSVM_Value>(0x5678);
    JSVM_Value result = nullptr;
    CHECK(functions->OH_JSVM_GetBoolean(mock_env, true, &result) ==
          JSVM_PENDING_EXCEPTION);
    CHECK(result == mock_value);
    result = nullptr;
    CHECK(functions->OH_JSVM_GetBoolean(mock_env, false, &result) ==
          JSVM_INVALID_ARG);
    CHECK(result == nullptr);
  } else {
    CHECK(loader.GetError() != nullptr);
    CHECK(std::strlen(loader.GetError()) > 0);
  }
  const int loaded_symbols = symbol_count.load();
  for (int i = 0; i < 128; ++i) {
    CHECK(loader.GetFunctions() == functions);
  }
  CHECK(open_count.load() == 1);
  CHECK(symbol_count.load() == loaded_symbols);
}

void CheckConcurrentSingleton() {
  constexpr int kThreads = 32;
  std::atomic<int> ready{0};
  std::atomic<bool> start{false};
  std::vector<const primjs::harmony::JSVMDynamicLoader*> instances(kThreads);
  std::vector<std::thread> threads;
  for (int i = 0; i < kThreads; ++i) {
    threads.emplace_back([&, i]() {
      ready.fetch_add(1, std::memory_order_release);
      while (!start.load(std::memory_order_acquire)) {
        std::this_thread::yield();
      }
      for (int j = 0; j < 64; ++j) {
        const auto& instance = primjs::harmony::JSVMDynamicLoader::GetInstance();
        CheckFunctions(instance.GetFunctions());
        if (j == 0) {
          instances[i] = &instance;
        } else {
          CHECK(instances[i] == &instance);
        }
      }
    });
  }
  while (ready.load(std::memory_order_acquire) != kThreads) {
    std::this_thread::yield();
  }
  start.store(true, std::memory_order_release);
  for (auto& thread : threads) {
    thread.join();
  }
  for (const auto* instance : instances) {
    CHECK(instance == instances[0]);
  }
  CHECK(open_count.load() == 1);
  CHECK(symbol_count.load() == kFunctionCount);
  CHECK(close_count.load() == 0);
}
}  // namespace

// Compile-time interposition counts the production loader's real dlopen/dlsym
// calls, without adding hooks or reset behavior to its production API.
extern "C" void* PrimJSTestDlopen(const char* path, int flags) {
  open_count.fetch_add(1);
  CHECK((flags & RTLD_NOW) != 0);
  CHECK((flags & RTLD_GLOBAL) == 0);
  return dlopen(path, flags);
}

extern "C" void* PrimJSTestDlsym(void* handle, const char* name) {
  symbol_count.fetch_add(1);
  return dlsym(handle, name);
}

extern "C" int PrimJSTestDlclose(void* handle) {
  close_count.fetch_add(1);
  return dlclose(handle);
}

int main(int argc, char** argv) {
  CHECK(argc >= 2);
  const std::string scenario(argv[1]);
  if (scenario == "concurrent") {
    CheckConcurrentSingleton();
  } else {
    CHECK(argc == 3);
    CheckExplicitLoader(argv[2], scenario == "complete");
    // A partially resolved library is closed immediately; a complete explicit
    // loader closes it on destruction. An absent library never opens a handle.
    CHECK(close_count.load() == (scenario == "absent" ? 0 : 1));
  }
  std::cout << "PASS " << scenario << " (" << kFunctionCount
            << " required symbols)\n";
}
"""


TYPED_MOCK = r"""
#include <ark_runtime/jsvm.h>

// Use the real SDK declaration to catch signature/calling-convention drift.
// A deliberately non-success status also verifies exact return forwarding.
extern "C" JSVM_Status OH_JSVM_GetBoolean(JSVM_Env env, bool value,
                                         JSVM_Value* result) {
  if (env != reinterpret_cast<JSVM_Env>(0x1234) || !value || !result) {
    return JSVM_INVALID_ARG;
  }
  *result = reinterpret_cast<JSVM_Value>(0x5678);
  return JSVM_PENDING_EXCEPTION;
}
"""


def run(command, **kwargs):
    result = subprocess.run(
        [str(part) for part in command],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=60,
        **kwargs,
    )
    if result.returncode:
        raise RuntimeError(
            "Command failed: "
            + shlex.join([str(part) for part in command])
            + "\n"
            + result.stdout
            + result.stderr
        )
    return result.stdout


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--sdk-include",
        type=Path,
        default=Path(
            "/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/"
            "native/sysroot/usr/include"
        ),
        help="Directory containing ark_runtime/jsvm.h and info/ SDK headers",
    )
    parser.add_argument(
        "--cxx", default=os.environ.get("CXX", "c++"), help="Host C++ compiler"
    )
    args = parser.parse_args()
    cxx = shlex.split(args.cxx)
    oss_root = Path(__file__).resolve().parents[2]
    source_root = oss_root / "src"
    loader_source = source_root / "napi/harmony/jsvm_dynamic_loader.cc"
    function_list = source_root / "napi/harmony/jsvm_functions.inc"
    for required in (
        loader_source,
        function_list,
        args.sdk_include / "ark_runtime/jsvm.h",
    ):
        if not required.is_file():
            parser.error("Required file is missing: " + str(required))

    with tempfile.TemporaryDirectory(prefix="primjs-jsvm-loader-") as temp_name:
        temporary = Path(temp_name)
        host_include = temporary / "include"
        host_include.mkdir()
        for name in ("ark_runtime", "info"):
            sdk_directory = args.sdk_include / name
            if sdk_directory.is_dir():
                (host_include / name).symlink_to(sdk_directory, target_is_directory=True)

        common = [
            *cxx,
            "-std=c++17",
            "-pthread",
            "-Wno-unknown-attributes",
            "-Wno-ignored-attributes",
            "-I" + str(source_root),
            "-I" + str(host_include),
        ]
        harness_source = temporary / "harness.cc"
        harness_source.write_text(HARNESS)
        for codecache in (False, True):
            name = "codecache-on" if codecache else "codecache-off"
            variant = temporary / name
            variant.mkdir()
            definitions = ["-DENABLE_CODECACHE=1"] if codecache else []
            expanded = run(
                [
                    *common,
                    *definitions,
                    "-E",
                    "-P",
                    "-x",
                    "c++",
                    "-",
                ],
                input='#define JSVM_FUNCTION(name) name\n'
                '#include "napi/harmony/jsvm_functions.inc"\n',
            )
            symbols = re.findall(r"\bOH_JSVM_[A-Za-z0-9_]+\b", expanded)
            if not symbols or len(set(symbols)) != len(symbols):
                raise RuntimeError("Invalid or duplicate required JSVM symbols")

            shared_flags = ["-dynamiclib"] if sys.platform == "darwin" else ["-shared", "-fPIC"]
            typed_mock_source = variant / "typed_mock.cc"
            typed_mock_source.write_text(TYPED_MOCK)
            for library_name, exports in (
                ("libjsvm.so", symbols),
                ("libjsvm_missing_symbol.so", symbols[:-1]),
            ):
                mock_source = variant / (library_name + ".cc")
                mock_source.write_text(
                    "// Symbol presence mocks; these functions must never be called.\n"
                    + "\n".join(
                        'extern "C" void ' + symbol + "() {}"
                        for symbol in exports
                        if symbol != "OH_JSVM_GetBoolean"
                    )
                    + "\n"
                )
                run(
                    [
                        *common,
                        *definitions,
                        *shared_flags,
                        mock_source,
                        typed_mock_source,
                        "-o",
                        variant / library_name,
                    ]
                )

            loader_object = variant / "loader.o"
            run(
                [
                    *common,
                    *definitions,
                    "-Ddlopen=PrimJSTestDlopen",
                    "-Ddlsym=PrimJSTestDlsym",
                    "-Ddlclose=PrimJSTestDlclose",
                    "-c",
                    loader_source,
                    "-o",
                    loader_object,
                ]
            )
            executable = variant / "loader_test"
            link_flags = [] if sys.platform == "darwin" else ["-ldl"]
            run(
                [
                    *common,
                    *definitions,
                    harness_source,
                    loader_object,
                    *link_flags,
                    "-o",
                    executable,
                ]
            )
            if shutil.which("nm"):
                undefined = run(["nm", "-u", executable])
                if "OH_JSVM_" in undefined:
                    raise RuntimeError("Loader still has direct undefined JSVM symbols")

            environment = os.environ.copy()
            for key in ("LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"):
                old_value = environment.get(key)
                environment[key] = str(variant) + (os.pathsep + old_value if old_value else "")
            for scenario, library in (
                ("absent", variant / "does-not-exist.so"),
                ("missing-symbol", variant / "libjsvm_missing_symbol.so"),
                ("complete", variant / "libjsvm.so"),
                ("concurrent", None),
            ):
                arguments = [executable, scenario]
                if library is not None:
                    arguments.append(library)
                print(name + ": " + run(arguments, env=environment).strip())


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, subprocess.TimeoutExpired) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
