#!/bin/bash
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

set -e

SCRIPT_DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"
PRIMJS_HOME=${SCRIPT_DIR}/../..
source ${PRIMJS_HOME}/tools/envsetup.sh

function usage() {
  cat <<EOF
  Usage: $0 [options]
  Options:
      -f|--force        force clean
      -h|--help         Print This Message
EOF
  exit 0
}

force_clean=false
function options_parse() {
  while test $# -gt 0; do
    case "$1" in
    -h | --help)
      usage
      ;;
    -f | --force)
      force_clean=true
      ;;
    esac
    shift
  done
}

echo $0 $@
options_parse $@

cd ${PRIMJS_HOME}
if [ -d ${PRIMJS_HOME}/out/default -a x"$force_clean" = x"true" ]; then
  echo "force clean ${PRIMJS_HOME}/out/default"
  rm -rf ${PRIMJS_HOME}/out/default
fi

set -x
gn gen out/default --args="is_debug=true enable_compatible_mm=false"
set +x

ninja -C out/default qjs-cli