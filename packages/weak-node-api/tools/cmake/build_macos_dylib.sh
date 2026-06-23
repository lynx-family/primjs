#!/usr/bin/env bash
# Copyright (c) 2025 The Lynx Authors.
# Licensed under the Apache License Version 2.0 that can be found in the LICENSE file in the root directory of this source tree.
# Derived work includes upstream generated headers/content; see NOTICE.md for details.
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT_DIR"

# This script builds macOS dylibs for both the default and weak_suffix variants
# in a single invocation. Headers enable weak suffix remapping by default, so
# the default variant explicitly opts out with USE_WEAK_SUFFIX_NAPI=OFF.

echo "[cmake] Preparing headers..."
echo "[cmake] Installing dependencies..."
npm install
npm run prepare:headers

GENERATOR="Xcode"
BASE_CMAKE_ARGS="-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13"

# Build both Debug and Release configurations for each variant. The default
# layout is written under prebuilt/macos/{debug,release} and the weak_suffix
# layout under prebuilt/macos/weak_suffix/{debug,release} so that the two
# variants can coexist.
for VARIANT in default weak_suffix; do
  if [[ "$VARIANT" == "default" ]]; then
    PREBUILT_BASE_DIR="prebuilt/macos"
    CMAKE_EXTRA_ARGS="$BASE_CMAKE_ARGS -DUSE_WEAK_SUFFIX_NAPI=OFF"
    echo "[cmake] ===== Building macOS default variant (USE_WEAK_SUFFIX_NAPI=OFF) ====="
  else
    PREBUILT_BASE_DIR="prebuilt/macos/weak_suffix"
    CMAKE_EXTRA_ARGS="$BASE_CMAKE_ARGS -DUSE_WEAK_SUFFIX_NAPI=ON"
    echo "[cmake] ===== Building macOS weak_suffix variant (USE_WEAK_SUFFIX_NAPI=ON) ====="
  fi

  # Build both Debug and Release configurations for this variant.
  for CONFIG in Debug Release; do
    echo "\n[cmake] Building $CONFIG configuration for variant '$VARIANT'..."

    # Create separate build directory for each configuration. We reuse the same
    # build directory names across variants and reconfigure CMake with the
    # appropriate USE_WEAK_SUFFIX_NAPI value before each build.
    BUILD_DIR="build/macos_${CONFIG}"
    mkdir -p "$BUILD_DIR"

    LIB_NAME="libweak-node-api.dylib"
    CONFIG_LOWER=$(printf '%s' "$CONFIG" | tr '[:upper:]' '[:lower:]')
    
    # Build for each architecture separately
    for ARCH in arm64 x86_64; do
      ARCH_BUILD_DIR="${BUILD_DIR}_${ARCH}"
      mkdir -p "$ARCH_BUILD_DIR"
      
      echo "[cmake] Configuring Xcode project for $ARCH architecture, $CONFIG configuration (variant=$VARIANT)..."
      cmake -S . -B "$ARCH_BUILD_DIR" -G "$GENERATOR" \
        -DCMAKE_BUILD_TYPE="$CONFIG" \
        -DCMAKE_SYSTEM_NAME=Darwin \
        -DCMAKE_OSX_ARCHITECTURES="$ARCH" \
        $CMAKE_EXTRA_ARGS

      echo "[cmake] Building $ARCH architecture, $CONFIG configuration (variant=$VARIANT)..."
      cmake --build "$ARCH_BUILD_DIR" --config "$CONFIG"
    done
    
    # Locate the dylibs for each architecture
    ARM64_LIB=""
    X86_64_LIB=""
    for ARCH in arm64 x86_64; do
      ARCH_BUILD_DIR="${BUILD_DIR}_${ARCH}"
      PREFERRED_ARCH_PATH="build/macos/${CONFIG_LOWER}/${LIB_NAME}"
      ALT_ARCH_PATH="$ARCH_BUILD_DIR/$CONFIG/$LIB_NAME"
      
      if [[ -f "$PREFERRED_ARCH_PATH" ]]; then
        ARCH_LIB_PATH="$PREFERRED_ARCH_PATH"
      elif [[ -f "$ALT_ARCH_PATH" ]]; then
        ARCH_LIB_PATH="$ALT_ARCH_PATH"
      else
        ARCH_LIB_PATH=$(find "$ARCH_BUILD_DIR" -maxdepth 4 -name "$LIB_NAME" -print -quit || true)
      fi
      
      if [[ -z "$ARCH_LIB_PATH" || ! -f "$ARCH_LIB_PATH" ]]; then
        echo "Failed to locate $LIB_NAME for $ARCH architecture, $CONFIG configuration under $ARCH_BUILD_DIR" >&2
        exit 1
      fi
      
      # Copy to a temporary location with architecture-specific name
      TEMP_ARCH_LIB="${BUILD_DIR}_${LIB_NAME}_${ARCH}"
      cp "$ARCH_LIB_PATH" "$TEMP_ARCH_LIB"
      
      if [[ "$ARCH" == "arm64" ]]; then
        ARM64_LIB="$TEMP_ARCH_LIB"
      else
        X86_64_LIB="$TEMP_ARCH_LIB"
      fi
    done
    
    # Merge the architectures with lipo
    echo "[cmake] Merging arm64 and x86_64 architectures into universal dylib..."
    lipo -create "$ARM64_LIB" "$X86_64_LIB" -output "${BUILD_DIR}/${LIB_NAME}"
    
    # Clean up temporary files
    rm "$ARM64_LIB" "$X86_64_LIB"
    
    LIB_PATH="${BUILD_DIR}/${LIB_NAME}"

    if [[ -z "${LIB_PATH}" || ! -f "$LIB_PATH" ]]; then
      echo "Failed to locate $LIB_NAME for configuration $CONFIG under $BUILD_DIR" >&2
      exit 1
    fi

    # Create prebuilt directory for each configuration (lowercase: macos/debug,
    # macos/release, macos/weak_suffix/debug, macos/weak_suffix/release).
    DIST_DIR="${PREBUILT_BASE_DIR}/${CONFIG_LOWER}"
    rm -rf "$DIST_DIR"
    mkdir -p "$DIST_DIR"

    echo "[cmake] Packaging $LIB_PATH to $DIST_DIR/$LIB_NAME (variant=$VARIANT)"
    cp "$LIB_PATH" "$DIST_DIR/$LIB_NAME"

    echo "[cmake] $CONFIG configuration done: ${ROOT_DIR}/${DIST_DIR}/${LIB_NAME}"
  done
done

echo "\n[cmake] All macOS variants built successfully!"
echo "[cmake] - Default Debug:   ${ROOT_DIR}/prebuilt/macos/debug/libweak-node-api.dylib"
echo "[cmake] - Default Release: ${ROOT_DIR}/prebuilt/macos/release/libweak-node-api.dylib"
echo "[cmake] - Weak Debug:      ${ROOT_DIR}/prebuilt/macos/weak_suffix/debug/libweak-node-api.dylib"
echo "[cmake] - Weak Release:    ${ROOT_DIR}/prebuilt/macos/weak_suffix/release/libweak-node-api.dylib"
