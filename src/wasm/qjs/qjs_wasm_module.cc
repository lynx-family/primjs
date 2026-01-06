// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_module.h"

#include <cstddef>

#include "basic/modp_b64/modp_b64.h"
#include "common/interop_runtime.h"
#include "common/messages.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/qjs_ext_api.h"
#include "qjs/qjs_wasm.h"

namespace primjs::qjs {
QJSWasmModule::QJSWasmModule(InteropRuntime* interop, WasmModuleRef module)
    : module_(std::move(module)) {
  WLOGD("Running QJSWasmModule::%s...", __func__);
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
}

QJSWasmModule::~QJSWasmModule() {
  WLOGD("Running QJSWasmModule::%s...", __func__);
  if (module_.is<Wasm3Module*>()) {
    delete module_.get<Wasm3Module*>();
  } else {
    delete module_.get<PrismModule*>();
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

LEPUSValue QJSWasmModule::CreateConstructor(LEPUSContext* ctx,
                                            LEPUSValue wasm_root) {
  LEPUSClassDef def = {.class_name = "WebAssembly.Module",
                       .finalizer = Finalize,
                       .gc_mark = QJSWasmModule::GCMark};
  if (JSSafeNewClass(ctx, class_id(), &def) != 0) {
    WLOGE("New Class failed in WebAssembly.Module.");
    return LEPUS_EXCEPTION;
  }

  LEPUSValue proto = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &proto, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetClassProto(ctx, class_id(), proto);

  const char* name = "Module";
  LEPUSValue constructor =
      InitConstructor(ctx, wasm_root, name, CallAsConstructor, 1, proto);
  func_scope.PushHandle(&constructor, HANDLE_TYPE_LEPUS_VALUE);

  // Note: All methods on a class are declared here.
  static const LEPUSCFunctionListEntry func_list[] = {
      LEPUS_CFUNC_DEF("customSections", 2, CustomSections),
      LEPUS_CFUNC_DEF("exports", 1, Exports),
      LEPUS_CFUNC_DEF("imports", 1, Imports),
      LEPUS_CGETSET_DEF("supportBase64", SupportBase64, nullptr),
  };
  LEPUS_SetPropertyFunctionList(ctx, constructor, func_list,
                                countof(func_list));
  return constructor;
}

void QJSWasmModule::Finalize(LEPUSRuntime* rt, LEPUSValue obj) {
  WLOGD("Running QJSWasmModule::%s...", __func__);

  auto opaque = static_cast<QJSWasmModule*>(LEPUS_GetOpaque(obj, class_id()));
  if (opaque && !LEPUS_IsGCModeRT(rt)) LEPUS_FreeValueRT(rt, opaque->bytes_);
  delete opaque;
  LEPUS_SetOpaque(obj, nullptr);
}

LEPUSValue QJSWasmModule::CallAsConstructor(LEPUSContext* ctx,
                                            LEPUSValueConst new_target,
                                            int argc, LEPUSValueConst* argv) {
  WLOGD("Running QJSWasmModule::%s...", __func__);

  constexpr const char* code = "WebAssembly.Module()";

  if (argc == 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kArrayBufferNeeded_1004);
  }
  bool useBase64 = false;
  if (argc > 1) {
    LEPUSValue encode_obj = argv[1];
    if (LEPUS_IsObject(encode_obj)) {
      LEPUSValue encode = LEPUS_GetPropertyStr(ctx, encode_obj, "encode");
      const char* encode_str = LEPUS_ToCString(ctx, encode);
      if (strcmp(encode_str, "base64") == 0) {
        useBase64 = true;
      }
    }
  }
  size_t byte_length = 0;
  WasmResult result = WasmSucceed;
  uint8_t* data = nullptr;

  // 1. Let stableBytes be a copy of the bytes held by the buffer bytes.
  LEPUSValue buffer_source = argv[0];
  bool useBase64Str = false;
  if (LEPUS_IsString(buffer_source)) {
    if (useBase64) {
      useBase64Str = true;
      data = (uint8_t*)LEPUS_ToCStringLen(ctx, &byte_length, buffer_source);
    } else {
      return ThrowIfException(
          ctx, ErrorTypes::kTypeError,
          "First argument must be a ArrayBuffer when not using base64 encode",
          result);
    }
  } else if (!LEPUS_IsArrayBuffer(buffer_source) &&
             !LEPUS_IsTypedArray(ctx, buffer_source) &&
             !LEPUS_IsDataView(ctx, buffer_source)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kArrayBufferNeeded_1005);
  } else {
    data = GetBufferFromBytes(ctx, buffer_source, byte_length, result);
  }

  if (!data) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code, result);
  }
  if (useBase64) {
    size_t decode_len = modp_b64_decode_len(byte_length);
    uint8_t* wasm_data = (uint8_t*)std::malloc(decode_len);
    byte_length =
        modp_b64_decode((char*)wasm_data, (const char*)data, byte_length);
    if (useBase64Str) {
      if (!LEPUS_IsGCMode(ctx)) {
        LEPUS_FreeCString(ctx, (const char*)data);
      }
    }
    data = wasm_data;
  }

  // 2. Compile the WebAssembly module stableBytes and store the result as
  //    module.
  auto interop =
      static_cast<InteropRuntime*>(JSGetPrivateData(ctx, new_target));
  WasmModuleRef module = interop->CreateWasmModule(data, byte_length, result);
  if (result != WasmSucceed) {
    return ThrowIfException(ctx, ErrorTypes::kError, code, result);
  }
  LEPUSValue module_obj = LEPUS_NewObjectClass(ctx, class_id());
  if (LEPUS_IsException(module_obj)) {
    return ThrowIfException(
        ctx, ErrorTypes::kTypeError, code,
        "Exception happened when constructing Wasm Module...");
  }
  HandleScope func_scope(ctx, &module_obj, HANDLE_TYPE_LEPUS_VALUE);
  auto opaque = new QJSWasmModule(interop, module);
  LEPUS_SetOpaque(module_obj, opaque);

  // 3. If module is error, throw a CompileError exception. skip...
  // 4. Set this.[[Module]] to module.
  // 5. Set this.[[Bytes]] to stableBytes.
  LEPUSValue stable_bytes =
      useBase64 ? LEPUS_NewArrayBuffer(
                      ctx, data, byte_length,
                      [](LEPUSRuntime* rt, void* opaque, void* ptr) {
                        std::free(ptr);
                      },
                      nullptr, false)
                : LEPUS_NewArrayBufferCopy(ctx, data, byte_length);
  opaque->set_bytes(ctx, stable_bytes);
  return module_obj;
}

LEPUSValue QJSWasmModule::CustomSections(LEPUSContext* ctx,
                                         LEPUSValueConst this_val, int argc,
                                         LEPUSValueConst* argv) {
  return LEPUS_ThrowSyntaxError(
      ctx, "WebAssembly.Module.customSections has not been implemented yet.");
}

LEPUSValue QJSWasmModule::Exports(LEPUSContext* ctx, LEPUSValueConst this_val,
                                  int argc, LEPUSValueConst* argv) {
  if (argc < 1 || !LEPUS_IsObject(argv[0]) ||
      LEPUS_GetClassID(ctx, argv[0]) != class_id()) {
    return LEPUS_EXCEPTION;
  }
  LEPUSValue exports_val = LEPUS_NewArray(ctx);
  if (LEPUS_IsException(exports_val)) {
    return exports_val;
  }
  HandleScope func_scope(ctx, &exports_val, HANDLE_TYPE_LEPUS_VALUE);
  auto js_module =
      static_cast<QJSWasmModule*>(LEPUS_GetOpaque(argv[0], class_id()));
  WasmModuleRef module = js_module->module_;

  auto interop_runtime = js_module->interop_runtime_;
  auto js_env = interop_runtime->js_env<QJSEnv*>();

  if (module.is<Wasm3Module*>()) {
    auto wasm3_module = module.get<Wasm3Module*>();
    wasm3_module->exports(js_env, exports_val, nullptr);
  } else {
    auto prism_module = module.get<PrismModule*>();
    prism_module->exports(js_env, exports_val, nullptr);
  }
  return exports_val;
}

LEPUSValue QJSWasmModule::Imports(LEPUSContext* ctx, LEPUSValueConst this_val,
                                  int argc, LEPUSValueConst* argv) {
  return LEPUS_UNDEFINED;
}

LEPUSValue QJSWasmModule::SupportBase64(LEPUSContext* ctx,
                                        LEPUSValueConst this_val) {
  return LEPUS_NewBool(ctx, true);
}

uint8_t* QJSWasmModule::GetBufferFromBytes(LEPUSContext* ctx,
                                           LEPUSValueConst buffer_source,
                                           size_t& byte_length,
                                           WasmResult& result) {
  if (!LEPUS_IsObject(buffer_source)) return nullptr;

  size_t offset = 0;
  LEPUSValue buffer = LEPUS_UNDEFINED;

  if (LEPUS_IsArrayBuffer(buffer_source)) {
    if (!LEPUS_IsGCMode(ctx)) {
      LEPUS_DupValue(ctx, buffer_source);
    }
    buffer = buffer_source;
  } else if (LEPUS_IsTypedArray(ctx, buffer_source)) {
    buffer = LEPUS_GetTypedArrayBuffer(ctx, buffer_source, &offset,
                                       &byte_length, nullptr);
  } else if (LEPUS_IsDataView(ctx, buffer_source)) {
    result = "Cannot get ArrayBuffer from DataView";
    return nullptr;
  }

  // Get pointer from array buffer, not copy, do not delete
  size_t buffer_length = 0;
  uint8_t* data = LEPUS_GetArrayBuffer(ctx, &buffer_length, buffer) + offset;

  // If buffer_source is instanceof TypedArray, byte_length may not as long
  // as buffer_length because of offset
  if (byte_length == 0) byte_length = buffer_length;

  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, buffer);
  }

  return data;
}

// static
void QJSWasmModule::GCMark(LEPUSRuntime* rt, LEPUSValueConst obj,
                           LEPUS_MarkFunc* mark_func, uint64_t trace_tool) {
  auto opaque = static_cast<QJSWasmModule*>(LEPUS_GetOpaque(obj, class_id()));
  WASM_DCHECK(opaque != nullptr);
  if (opaque) {
    LEPUS_MarkValue(rt, opaque->bytes_, mark_func, trace_tool);
  }
}

}  // namespace primjs::qjs
