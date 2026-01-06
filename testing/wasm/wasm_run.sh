#!/bin/bash
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

set -ex

SCRIPT_DIR="$(
    cd "$(dirname "$0")"
    pwd -P
)"

PRIMJS_HOME=${SCRIPT_DIR}/../..
TESTING_HOME="${PRIMJS_HOME}"/testing/wasm

build_qjs_wasm() {
    bash "${PRIMJS_HOME}"/tools/qjs-cli/build.sh
}

run_qjs_wasm3_tests() {
    cd "${TESTING_HOME}"
    bash "${TESTING_HOME}"/js-api/tests_run.sh qjs-cli --logging --engine wasm3
    bash "${TESTING_HOME}"/basic-tests/tests_run.sh qjs-cli --logging --engine wasm3
}

build_qjs_wasm

run_qjs_wasm3_tests