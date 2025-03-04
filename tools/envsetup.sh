# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

#!/bin/bash
case "$OSTYPE" in
  linux*)
    HOST_TOOLCHAIN_PATH="linux64"
    ;;
  darwin*)
    HOST_TOOLCHAIN_PATH="mac"
    ;;
  *) echo "Unsupported Host OS, abort."; exit 1;;
esac

PRIMJS_envsetup() {
    local OS_NAME=`echo $(uname -s) | awk '{print tolower($0)}'`
    local SCRIPT_DIR=`python3 -c "import os; print(os.path.dirname(os.path.realpath('$1')))"`
    export PRIMJS_ROOT_DIR="$(dirname $SCRIPT_DIR)"
    export PRIMJS_BUILDTOOLS_DIR="${PRIMJS_ROOT_DIR}/buildtools"
    echo $SCRIPT_DIR
    export PATH=${SCRIPT_DIR}:$PATH
    export PATH=${PRIMJS_BUILDTOOLS_DIR}/gn:$PATH
    export PATH=${PRIMJS_BUILDTOOLS_DIR}/ninja:$PATH
    export PATH=${PRIMJS_BUILDTOOLS_DIR}/llvm/bin:$PATH
    export PATH=${SCRIPT_DIR}/cli:$PATH
    export PATH=${SCRIPT_DIR}/release:$PATH

}
PRIMJS_envsetup "${BASH_SOURCE:-$0}"
