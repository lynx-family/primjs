#!/usr/bin/env bash
# Copyright (c) 2025 The Lynx Authors.
# Licensed under the Apache License Version 2.0 that can be found in the LICENSE file in the root directory of this source tree.
# Derived work includes upstream generated headers/content; see NOTICE.md for details.
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT_DIR"

echo "[cmake] Preparing headers..."
npm run prepare:headers

GENERATOR="Xcode"

# Build both Debug and Release configurations
for CONFIG in Debug Release; do
  echo "\n[cmake] Building $CONFIG configuration..."
  
  # Create separate build directory for each configuration
  BUILD_DIR="build/macos_${CONFIG}"
  
  mkdir -p "$BUILD_DIR"

  echo "[cmake] Configuring Xcode project (universal arm64;x86_64) for $CONFIG..."
  cmake -S . -B "$BUILD_DIR" -G "$GENERATOR" \
    -DCMAKE_BUILD_TYPE="$CONFIG" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64"

  echo "[cmake] Building $CONFIG..."
  cmake --build "$BUILD_DIR" --config "$CONFIG"

  # Locate produced framework - explicitly look in the CONFIG directory
  FRAME_PATH="$BUILD_DIR/$CONFIG/weak-node-api.framework"
  if [[ -z "${FRAME_PATH}" ]]; then
    echo "Failed to locate weak-node-api.framework under $BUILD_DIR" >&2
    exit 1
  fi

  # Create prebuilt directory for each configuration
  DIST_DIR="prebuilt/macos/${CONFIG}"
  rm -rf "$DIST_DIR"
  mkdir -p "$DIST_DIR"

  echo "[cmake] Packaging $FRAME_PATH to $DIST_DIR/WeakNodeAPI.framework"
  # Use rsync to preserve symlinks if any
  rsync -a "$FRAME_PATH/" "$DIST_DIR/WeakNodeAPI.framework/"

  echo "[cmake] $CONFIG configuration done: $DIST_DIR/WeakNodeAPI.framework"
done

echo "\n[cmake] All configurations built successfully!"
echo "[cmake] - Debug:   ${ROOT_DIR}/prebuilt/macos/Debug/WeakNodeAPI.framework"
echo "[cmake] - Release: ${ROOT_DIR}/prebuilt/macos/Release/WeakNodeAPI.framework"
