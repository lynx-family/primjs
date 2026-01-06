#!/bin/bash
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

set -e

SCRIPT_DIR="$(
  cd "$(dirname "$0")" || exit
  pwd -P
)"
PRIMJS_HOME=${SCRIPT_DIR}/../../..
TESTS_HOME=${SCRIPT_DIR}

function usage() {
  cat <<EOF
  Usage: $0 [options]
  Options:
      --cli  bin        cli binary options: [qjs-cli]
      -h|--help         Print This Message
      --abort           Abort Testing While Case Failure
      --logging         Show Testing Logs
      --engine          engine options: [wasm3, prism]
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
      echo "$1"
      wasm_engine=$1
      ;;
    *)
      cli_bin=$1
      ;;
    esac
    shift
  done
}

echo $0 $@
options_parse $@
echo "wasm_engine is ${wasm_engine}"

cd ${TESTS_HOME}
EXEC_CLI=${PRIMJS_HOME}/out/default/${cli_bin}
if [ ! -f ${EXEC_CLI} ]; then
  echo "${cli_bin} missed, please build ${cli_bin} before hands!"
  exit -1
fi

test_logs=()
test_suit=basic-tests
test_cases=(
  "array_bytes.js"
  "attributes.js"
  "global.js"
  "memory.js"
  "table.js"
)

# fail_cases=
total_cases=${#test_cases[@]}
suc_cases=0
for ((i = 0; i < ${total_cases}; i++)); do
  echo "[$i] : start run ${test_cases[$i]}"
  ${EXEC_CLI} "--wasm-engine" "${wasm_engine}" ${test_cases[$i]}
  if [ $? -eq 0 ]; then
    ((suc_cases++))
    echo "[$i]: ${test_cases[$i]} passed!"
    test_logs+=("[$i]: ${EXEC_CLI} ${wasm_engine} ${test_cases[$i]} passed!")
  else
    echo "x[$i]: ${test_cases[$i]} failed!"
    test_logs+=("x[$i]: ${EXEC_CLI} ${wasm_engine} ${test_cases[$i]} failed!")
    if [ x"${abort_fail}" = x"true" ]; then
      exit -1
    fi
  fi
done

echo ""
echo "${test_suit}[${suc_cases}/${total_cases}]: ${suc_cases} success out of ${total_cases} cases!"
echo "=================================================="

function show_logs() {
  for log in "${test_logs[@]}"; do
    echo ${log}
  done
}

if [ x"${show_logging}" = x"true" ]; then
  show_logs
fi
if [ ${suc_cases} -ne ${total_cases} ]; then
  if [ x"${show_logs}" = x"true" ]; then
    show_logs
  fi
  exit -1
fi
