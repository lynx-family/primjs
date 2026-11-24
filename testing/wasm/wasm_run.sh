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

run_qjs_wasm_tests() {
    local cli_bin="${PRIMJS_HOME}/out/default/qjs-cli"
    local probe_js
    probe_js=$(mktemp "${TMPDIR:-/tmp}/primjs-wasm-probe.XXXXXX.js")
    trap 'rm -f "${probe_js}"' RETURN
    cat > "${probe_js}" <<'EOF'
if (typeof WebAssembly !== "object" || typeof WebAssembly.Module !== "function") {
  print("WASM_STUB_BUILD");
} else {
  print("WASM_ENGINE_READY");
}
EOF
    local probe_out
    probe_out=$("${cli_bin}" "${probe_js}")
    if echo "${probe_out}" | grep -q "WASM_STUB_BUILD"; then
        echo "qjs-cli is linked with prism_dummy stub; skipping runtime suites."
        return 0
    fi
    cd "${TESTING_HOME}"
    bash "${TESTING_HOME}"/js-api/tests_run.sh qjs-cli --logging --engine prism
    bash "${TESTING_HOME}"/basic-tests/tests_run.sh qjs-cli --logging --engine prism
}

build_qjs_wasm

run_qjs_wasm_tests
