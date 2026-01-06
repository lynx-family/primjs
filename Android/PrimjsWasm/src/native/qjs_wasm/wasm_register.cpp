// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "wasm_register.h"

#include "common/wasm_log.h"
#include "qjs/qjs_wasm.h"

#ifndef WASM_EXPORT
#define WASM_EXPORT __attribute__((visibility("default")))
#endif

WASM_EXPORT extern "C" void RegisterWebAssembly(void *js_context,
                                                void *exception) {
  if (!js_context) {
    WLOGE("Register WebAssembly with invalid js context!");
    return;
  }
  WLOGI("Registering WebAssembly from JNI...");

  primjs::qjs::QJSWebAssembly::RegisterWebAssembly(
      static_cast<LEPUSContext *>(js_context), nullptr);
}

extern "C" JNIEXPORT jlong JNICALL
Java_com_lynx_primjs_wasm_RegisterWebAssembly_loadWasmFactory(JNIEnv *,
                                                              jclass) {
  WLOGI("Load WebAssembly factory ...");
  return reinterpret_cast<jlong>(RegisterWebAssembly);
}
