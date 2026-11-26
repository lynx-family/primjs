// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_module.h"

#include <cstdlib>
#include <cstring>

#include "common/messages.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/js_env_qjs.h"
#include "qjs/qjs_wasm.h"

namespace primjs::qjs {

QJSWasmModule::QJSWasmModule(LEPUSRuntime* rt, LEPUSValue wasm_root,
                             wasm::WasmStoreOwner* store_owner,
                             wasm_module_t* module)
    : QJSWasmWrapperBase(rt, wasm_root, store_owner, DetachModule),
      module_(module) {
#if defined(QJS_UNITTEST)
  wasm::WasmStoreOwner::live_modules_for_testing_.fetch_add(1);
#endif
}

QJSWasmModule::~QJSWasmModule() { UnlinkAndDetach(); }

void QJSWasmModule::DetachModule(QJSWasmWrapperBase* base, LEPUSRuntime*) {
  auto* self = static_cast<QJSWasmModule*>(base);
  if (self->imports_loaded_) {
    wasm_importtype_vec_delete(&self->import_types_);
    self->imports_loaded_ = false;
  }
  if (self->module_) {
    wasm_module_delete(self->module_);
    self->module_ = nullptr;
#if defined(QJS_UNITTEST)
    wasm::WasmStoreOwner::live_modules_for_testing_.fetch_sub(1);
#endif
  }
}

const wasm_importtype_vec_t* QJSWasmModule::ImportTypes() {
  if (!imports_loaded_) {
    wasm_module_imports(module_, &import_types_);
    imports_loaded_ = true;
#if defined(QJS_UNITTEST)
    ++wasm::WasmStoreOwner::import_descriptor_enumerations_for_testing_;
#endif
  }
  return &import_types_;
}

bool QJSWasmModule::Register(LEPUSContext* ctx, LEPUSValue wasm_root) {
  static const LEPUSCFunctionListEntry static_funcs[] = {
      LEPUS_CGETSET_DEF("supportBase64", SupportBase64, nullptr),
  };
  return RegisterWasmClass(ctx, wasm_root, WasmQJSClass::kModule,
                           "WebAssembly.Module", "Module", CallAsConstructor,
                           nullptr, 0, static_funcs, countof(static_funcs));
}

LEPUSValue QJSWasmModule::CallAsConstructor(LEPUSContext* ctx,
                                            LEPUSValueConst new_target,
                                            int argc, LEPUSValueConst* argv) {
  constexpr const char* code = "WebAssembly.Module()";

  QJSEnv* env = RequireConstructorEnv(ctx, new_target, code);
  if (!env) return LEPUS_EXCEPTION;

  if (argc == 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kArrayBufferNeeded_1004);
  }

  bool use_base64 = false;
  if (argc > 1 && LEPUS_IsObject(argv[1])) {
    LEPUSValue encode_val = LEPUS_GetPropertyStr(ctx, argv[1], "encode");
    if (LEPUS_IsException(encode_val)) return LEPUS_EXCEPTION;
    if (!LEPUS_IsUndefined(encode_val)) {
      HandleScope scope(ctx, &encode_val, HANDLE_TYPE_LEPUS_VALUE);
      size_t enc_len = 0;
      const char* encode_str = LEPUS_ToCStringLen(ctx, &enc_len, encode_val);
      FreeValueIfRC(ctx, encode_val);
      if (!encode_str) return LEPUS_EXCEPTION;
      use_base64 = (enc_len == 6 && std::memcmp(encode_str, "base64", 6) == 0);
      if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeCString(ctx, encode_str);
    }
  }

  size_t byte_length = 0;
  WasmResult result = WasmSucceed;
  uint8_t* data = nullptr;
  bool free_cstring_data = false;

  LEPUSValue buffer_source = argv[0];
  if (LEPUS_IsString(buffer_source)) {
    if (!use_base64) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              ErrorMessages::kArrayBufferNeeded_1005);
    }
    data = reinterpret_cast<uint8_t*>(const_cast<char*>(
        LEPUS_ToCStringLen(ctx, &byte_length, buffer_source)));
    if (!data) return LEPUS_EXCEPTION;
    free_cstring_data = true;
  } else {
    data = GetBufferFromBytes(ctx, buffer_source, byte_length, result);
    if (!data) {
      return ThrowIfException(
          ctx, ErrorTypes::kTypeError, code,
          result ? result : ErrorMessages::kArrayBufferNeeded_1005);
    }
  }

  uint8_t* owned_base64 = nullptr;
  if (use_base64) {
    size_t decoded = 0;
    const bool ok =
        wasm::DecodeBase64(data, byte_length, &owned_base64, &decoded);
    if (free_cstring_data && !LEPUS_IsGCMode(ctx)) {
      LEPUS_FreeCString(ctx, reinterpret_cast<const char*>(data));
    }
    free_cstring_data = false;
    if (!ok) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              ErrorMessages::kArrayBufferNeeded_1003);
    }
    data = owned_base64;
    byte_length = decoded;
  }

  wasm_byte_vec_t binary = {byte_length, reinterpret_cast<char*>(data)};
  wasm_module_t* module = wasm_module_new(env->wasm_store(), &binary);
  if (free_cstring_data && !LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeCString(ctx, reinterpret_cast<const char*>(data));
  }
  std::free(owned_base64);

  if (wasm_unlikely(!module)) {
    return ThrowIfException(ctx, ErrorTypes::kError, code,
                            "create prism module failed");
  }

  LEPUSValue module_obj =
      NewWasmWrapperObject(ctx, env, WasmQJSClass::kModule, code);
  if (LEPUS_IsException(module_obj)) {
    wasm_module_delete(module);
    return LEPUS_EXCEPTION;
  }
  LEPUS_SetOpaque(module_obj,
                  new QJSWasmModule(LEPUS_GetRuntime(ctx), env->wasm_root(),
                                    env->store_owner(), module));
  return module_obj;
}

LEPUSValue QJSWasmModule::SupportBase64(LEPUSContext* ctx,
                                        LEPUSValueConst this_val) {
  (void)this_val;
  return LEPUS_NewBool(ctx, true);
}

uint8_t* QJSWasmModule::GetBufferFromBytes(LEPUSContext* ctx,
                                           LEPUSValueConst buffer_source,
                                           size_t& byte_length,
                                           WasmResult& result) {
  if (!LEPUS_IsObject(buffer_source)) return nullptr;

  size_t offset = 0;
  LEPUSValue buffer = LEPUS_UNDEFINED;
  const bool is_typed = LEPUS_IsTypedArray(ctx, buffer_source);
  if (LEPUS_IsArrayBuffer(buffer_source)) {
    buffer = DupValueIfRC(ctx, buffer_source);
  } else if (is_typed) {
    buffer = LEPUS_GetTypedArrayBuffer(ctx, buffer_source, &offset,
                                       &byte_length, nullptr);
    if (LEPUS_IsException(buffer)) return nullptr;
  } else {
    return nullptr;
  }

  size_t buffer_length = 0;
  uint8_t* base = LEPUS_GetArrayBuffer(ctx, &buffer_length, buffer);
  FreeValueIfRC(ctx, buffer);
  if (!base && buffer_length != 0) {
    result = "ArrayBuffer is detached";
    return nullptr;
  }
  if (!is_typed) {
    byte_length = buffer_length;
  }
  if (offset > buffer_length || byte_length > buffer_length - offset) {
    result = "Buffer view is out of bounds";
    return nullptr;
  }
  static uint8_t kEmptyByte = 0;
  return base ? (base + offset) : &kEmptyByte;
}

}  // namespace primjs::qjs
