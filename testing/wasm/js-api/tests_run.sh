#!/bin/bash
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

set -e

SCRIPT_DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"

PRIMJS_HOME=${SCRIPT_DIR}/../../..
# TESTS_HOME=${SCRIPT_DIR}

function usage() {
  cat <<EOF
  Usage: $0 [options]
  Options:
      --cli  bin        cli binary options: [qjs-cli]
      -h|--help         Print This Message
      --abort           Abort Testing While Case Failure
      --logging         Show Testing Logs
EOF
  exit 0
}

cli_bin=qjs-cli
abort_fail=false
show_logging=false
wasm_engine=wasm3
function options_parse() {
  while test $# -gt 0; do
    case "$1" in
    -h | --help)
      usage
      ;;
    --abort)
      abort_fail=true
      ;;
    --logging)
      show_logging=true
      ;;
    --cli)
      shift
      cli_bin=$1
      ;;
    --engine)
      shift
      wasm_engine=$1
      ;;
    *)
      cli_bin=$1
      ;;
    esac
    shift
  done
}

function check_cli_binary() {
  local cli_binary=$1
  local exec_cli=${PRIMJS_HOME}/out/default/${cli_binary}
  if [[ ! -f ${exec_cli} ]]; then
    echo "${cli_binary} is missing. Please build ${cli_binary} before running this script."
    exit 1
  fi
}

function run_test_case() {
  local test_case=$1
  local index=$2

  echo "[${index}] : start run ${test_case}"
  ${EXEC_CLI} "--wasm-engine" "${wasm_engine}" "${up_dir}""${test_case}"

  local exit_code=$?
  if [[ ${exit_code} -eq 0 ]]; then
    ((suc_cases++))
    echo "[${index}]: ${test_case} passed!"
    test_logs+=("[${index}]: ${EXEC_CLI} ${wasm_engine} ${test_case} passed!")
  else
    echo "x[${index}]: ${test_case} failed!"
    test_logs+=("x[${index}]: ${EXEC_CLI} ${wasm_engine} ${test_case} failed!")
    if [[ "${abort_fail}" == true ]]; then
      exit 1
    fi
  fi
}

function print_test_logs() {
  for log in "${test_logs[@]}"; do
    echo "${log}"
  done
}

function main() {
  options_parse "$@"
  check_cli_binary "${cli_bin}"

  EXEC_CLI=${PRIMJS_HOME}/out/default/${cli_bin}

  test_logs=()
  test_suit=js-api
  test_cases=(
    "adapter-frame.js"
    "export-table.js"
    "float-constant-folding.js"
    "function-prototype.js"
    "params.js"
    "test-wasm-module-builder.js"
    "verify-module-basic-errors.js"
    "wasm-object-api.js"
    "memory-size.js"
    "start-function.js"
    "import-memory.js"
  )
  test_cases+=("table.js" "globals.js")

  up_dir="$( dirname "${BASH_SOURCE[0]}" )/"
  total_cases=${#test_cases[@]}
  suc_cases=0

  for ((i = 0; i < total_cases; i++)); do
    run_test_case "${test_cases[${i}]}" "${i}"
  done

  echo ""
  echo "${test_suit}[${suc_cases}/${total_cases}]: ${suc_cases} success out of ${total_cases} cases!"
  echo "=================================================="

  if [[ "${show_logging}" = true ]]; then
    print_test_logs
  fi

  if [[ "${suc_cases}" -ne "${total_cases}" ]]; then
    if [[ "${show_logging}" = true ]]; then
      print_test_logs
    fi
    exit 1
  fi
}

main "$@"
