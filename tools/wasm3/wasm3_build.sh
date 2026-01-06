#!/bin/bash
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

set -ex

SCRIPT_DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"
PRIMJS_HOME="${SCRIPT_DIR}/../../"

WASM3_HOME="${PRIMJS_HOME}/third_party/wasm3"
WASM3_INSTALL_DIR=""
WASM3_BUILD_FORCE=false
BUILD_TYPE=Release
CC=""
CXX=""
ARCH=""

function usage() {
  cat <<EOF
  Usage: $0 [options]
  Options:
      --wasm3           Set WASM3's Source Root
      --install         Set The Output Directory
      --force           Force to rebuild all
      -d|--debug        Build debug version
EOF
}

function options_parse() {
  while test $# -gt 0; do
    case "$1" in
    --wasm3)
      shift
      WASM3_HOME=$1
      ;;
    --install)
      shift
      WASM3_INSTALL_DIR=$1
      ;;
    --force)
      WASM3_BUILD_FORCE=true
      ;;
    -cc | --c_compiler)
      shift
      CC=$1
      ;;
    -cxx | --cxx_compiler)
      shift
      CXX=$1
      ;;
    -d | --debug)
      BUILD_TYPE=Debug
      ;;
    -arch)
      shift
      ARCH=$1
      ;;
    esac
    shift
  done
}

echo $0 $@
options_parse $@

if [ ! -z "$WASM3_HOME" -a x"${WASM3_HOME:0:1}" != x"/" ]; then
  WASM3_HOME="$(pwd)/${WASM3_HOME}"
fi

# FIXME(set WASM3_HOME auto with platform type)
# WASM3_PRODUCT_DARWIN=${WASM3_HOME}/platforms/darwin
WASM3_PRODUCT_DARWIN=${WASM3_HOME}
WASM3_PRODUCT=${WASM3_PRODUCT_DARWIN}
if [ -z $WASM3_INSTALL_DIR ]; then
  WASM3_INSTALL_DIR=${WASM3_HOME}/out
fi
if [ ! -z "$WASM3_INSTALL_DIR" -a x"${WASM3_INSTALL_DIR:0:1}" != x"/" ]; then
  WASM3_INSTALL_DIR="$(pwd)/${WASM3_INSTALL_DIR}"
fi

if [ x"true" == x"$WASM3_BUILD_FORCE" ]; then
  rm -rf ${WASM3_INSTALL_DIR}
fi

# Use out-of-source build to avoid polluting the source directory
BUILD_DIR=$(dirname ${WASM3_INSTALL_DIR})/wasm3_build_obj
if [ -d ${BUILD_DIR} ]; then
  rm -rf ${BUILD_DIR}
fi
mkdir -p ${BUILD_DIR} && cd ${BUILD_DIR}

echo "Current Directory: $(pwd)"
echo "Source Directory: ${WASM3_PRODUCT}"

cmake ${WASM3_PRODUCT} \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -DCMAKE_INSTALL_PREFIX=${WASM3_INSTALL_DIR} \
  -DCMAKE_C_COMPILER=${CC} \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DTARGET_ARCH=${ARCH} \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON

make -j$nproc
make install
