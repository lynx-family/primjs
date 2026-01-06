// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef ANDROID_PRIMJSWASM_SRC_NATIVE_WASM_REGISTER_H_
#define ANDROID_PRIMJSWASM_SRC_NATIVE_WASM_REGISTER_H_

#include <jni.h>

#define WASM_EXPORT __attribute__((visibility("default")))

#if defined(__cplusplus)
extern "C" {
#endif
// register webassembly to js_context
WASM_EXPORT void RegisterWebAssembly(void* js_context, void* exception);

JNIEXPORT jlong JNICALL
Java_com_lynx_primjs_wasm_RegisterWebAssembly_loadWasmFactory(JNIEnv*, jclass);

#if defined(__cplusplus)
}
#endif

#endif  // ANDROID_PRIMJSWASM_SRC_NATIVE_WASM_REGISTER_H_
