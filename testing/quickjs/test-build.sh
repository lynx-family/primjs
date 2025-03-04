#!/bin/bash
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.
gn gen out/Default --args="enable_unittests=true is_asan=true is_ubsan=true use_clang_coverage = true"
ninja -C out/Default -j32 qjs
