/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "js_native_api_v8.cc.h"

static napi_status napi_run_script(napi_env env, const char* script,
                                   size_t length, const char* filename,
                                   napi_value* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::String> v8_script;
  CHECK_NEW_FROM_UTF8_LEN(env, v8_script, script, length);

  v8::Local<v8::Context> context = env->ctx->context();

  v8::MaybeLocal<v8::Script> maybe_script;
  if (filename) {
    v8::Local<v8::Value> origin_string;
    CHECK_NEW_FROM_UTF8(env, origin_string, filename);
    v8::ScriptOrigin so(env->ctx->isolate, origin_string);
    maybe_script = v8::Script::Compile(context, v8_script, &so);
  } else {
    maybe_script = v8::Script::Compile(context, v8_script);
  }

  CHECK_MAYBE_EMPTY(env, maybe_script, napi_generic_failure);

  auto script_result = maybe_script.ToLocalChecked()->Run(context);
  CHECK_MAYBE_EMPTY(env, script_result, napi_generic_failure);

  *result = v8impl::JsValueFromV8LocalValue(script_result.ToLocalChecked());
  return GET_RETURN_STATUS(env);
}

static napi_status napi_get_dataview_info(napi_env env, napi_value dataview,
                                          size_t* byte_length, void** data,
                                          napi_value* arraybuffer,
                                          size_t* byte_offset) {
  v8::Local<v8::Value> value = v8impl::V8LocalValueFromJsValue(dataview);
  RETURN_STATUS_IF_FALSE(env, value->IsDataView(), napi_invalid_arg);

  v8::Local<v8::DataView> array = value.As<v8::DataView>();

  if (byte_length != nullptr) {
    *byte_length = array->ByteLength();
  }

  v8::Local<v8::ArrayBuffer> buffer;
  if (data != nullptr || arraybuffer != nullptr) {
    // Calling Buffer() may have the side effect of allocating the buffer,
    // so only do this when it’s needed.
    buffer = array->Buffer();
  }

  if (data != nullptr) {
    *data = static_cast<uint8_t*>(buffer->GetBackingStore()->Data()) +
            array->ByteOffset();
  }

  if (arraybuffer != nullptr) {
    *arraybuffer = v8impl::JsValueFromV8LocalValue(buffer);
  }

  if (byte_offset != nullptr) {
    *byte_offset = array->ByteOffset();
  }

  return napi_clear_last_error(env);
}

static napi_status napi_get_arraybuffer_info(napi_env env,
                                             napi_value arraybuffer,
                                             void** data, size_t* byte_length) {
  v8::Local<v8::Value> value = v8impl::V8LocalValueFromJsValue(arraybuffer);
  RETURN_STATUS_IF_FALSE(env, value->IsArrayBuffer(), napi_invalid_arg);

  auto backing_store = value.As<v8::ArrayBuffer>()->GetBackingStore();
  if (data) {
    *data = backing_store->Data();
  }

  if (byte_length) {
    *byte_length = backing_store->ByteLength();
  }

  return napi_clear_last_error(env);
}

static napi_status napi_create_external_arraybuffer(
    napi_env env, void* external_data, size_t byte_length,
    napi_finalize finalize_cb, void* finalize_hint, napi_value* result) {
  v8::Isolate* isolate = env->ctx->isolate;
  std::shared_ptr<v8::BackingStore> backing_store =
      v8::ArrayBuffer::NewBackingStore(external_data, byte_length,
                                       v8::BackingStore::EmptyDeleter, nullptr);
  auto buffer = v8::ArrayBuffer::New(isolate, backing_store);

  if (finalize_cb != nullptr) {
    // Create a self-deleting weak reference that invokes the finalizer
    // callback.
    v8impl::Reference::New(env, buffer, 0, true, finalize_cb, external_data,
                           finalize_hint);
  }

  *result = v8impl::JsValueFromV8LocalValue(buffer);
  return napi_clear_last_error(env);
}

static napi_status napi_create_arraybuffer(napi_env env, size_t byte_length,
                                           void** data, napi_value* result) {
  v8::Isolate* isolate = env->ctx->isolate;
  std::shared_ptr<v8::BackingStore> backing_store =
      v8::ArrayBuffer::NewBackingStore(isolate, byte_length);
  auto buffer = v8::ArrayBuffer::New(isolate, backing_store);

  // Optionally return a pointer to the buffer's data, to avoid another call to
  // retrieve it.
  if (data != nullptr) {
    *data = backing_store->Data();
  }

  *result = v8impl::JsValueFromV8LocalValue(buffer);
  return napi_clear_last_error(env);
}

napi_status napi_get_typedarray_info(napi_env env, napi_value typedarray,
                                     napi_typedarray_type* type, size_t* length,
                                     void** data, napi_value* arraybuffer,
                                     size_t* byte_offset) {
  v8::Local<v8::Value> value = v8impl::V8LocalValueFromJsValue(typedarray);
  RETURN_STATUS_IF_FALSE(env, value->IsTypedArray(), napi_invalid_arg);

  v8::Local<v8::TypedArray> array = value.As<v8::TypedArray>();

  if (type != nullptr) {
    if (value->IsInt8Array()) {
      *type = napi_int8_array;
    } else if (value->IsUint8Array()) {
      *type = napi_uint8_array;
    } else if (value->IsUint8ClampedArray()) {
      *type = napi_uint8_clamped_array;
    } else if (value->IsInt16Array()) {
      *type = napi_int16_array;
    } else if (value->IsUint16Array()) {
      *type = napi_uint16_array;
    } else if (value->IsInt32Array()) {
      *type = napi_int32_array;
    } else if (value->IsUint32Array()) {
      *type = napi_uint32_array;
    } else if (value->IsFloat32Array()) {
      *type = napi_float32_array;
    } else if (value->IsFloat64Array()) {
      *type = napi_float64_array;
    } else if (value->IsBigInt64Array()) {
      *type = napi_bigint64_array;
    } else if (value->IsBigUint64Array()) {
      *type = napi_biguint64_array;
    }
  }

  if (length != nullptr) {
    *length = array->Length();
  }

  v8::Local<v8::ArrayBuffer> buffer;
  if (data != nullptr || arraybuffer != nullptr) {
    // Calling Buffer() may have the side effect of allocating the buffer,
    // so only do this when it’s needed.
    buffer = array->Buffer();
  }

  if (data != nullptr) {
    *data = static_cast<uint8_t*>(buffer->GetBackingStore()->Data()) +
            array->ByteOffset();
  }

  if (arraybuffer != nullptr) {
    *arraybuffer = v8impl::JsValueFromV8LocalValue(buffer);
  }

  if (byte_offset != nullptr) {
    *byte_offset = array->ByteOffset();
  }

  return napi_clear_last_error(env);
}

#ifdef ENABLE_CODECACHE

static napi_status napi_run_script_cache(napi_env env, const char* script,
                                         size_t length, const char* filename,
                                         napi_value* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::String> v8_script;
  CHECK_NEW_FROM_UTF8_LEN(env, v8_script, script, length);

  v8::Local<v8::Context> context = env->ctx->context();

  v8::MaybeLocal<v8::Script> maybe_script;
  bool need_mkcache = false;
  {
    v8::Local<v8::Value> origin_string;
    CHECK_NEW_FROM_UTF8(env, origin_string, filename);
    v8::ScriptOrigin so(env->ctx->isolate, origin_string);
    {
      const uint8_t* data = nullptr;
      int length = -1;
      // find_codecache(env, filename, &data, &length);
      env->napi_get_code_cache(env, filename, &data, &length);
      // if lenght equals 0, it means CacheBlob is being modified
      // and thus reading is not allowed yet, but there is no actual
      // need to make cache immediately to void duplicated cache-making
      need_mkcache = data == nullptr && length != -1;
      if (data != nullptr) {
        // The following v8::ScriptCompiler::Source will release this
        // cached_data.
        uint8_t* cache = new uint8_t[length];
        memcpy(cache, data, length);
        v8::ScriptCompiler::CachedData* cached_data =
            new v8::ScriptCompiler::CachedData(
                cache, length, v8::ScriptCompiler::CachedData::BufferOwned);
        v8::ScriptCompiler::Source src(v8_script, so, cached_data);
        LOG_TIME_START();
        maybe_script = v8::ScriptCompiler::Compile(
            context, &src, v8::ScriptCompiler::kConsumeCodeCache);
        LOG_TIME_END("----- script compilation with cache -----");
        need_mkcache = cached_data->rejected;
      }
    }
  }
  if (maybe_script.IsEmpty()) {
    LOG_TIME_START();
    maybe_script = v8::Script::Compile(context, v8_script);
    LOG_TIME_END("----- script compilation -----");
  }

  CHECK_MAYBE_EMPTY(env, maybe_script, napi_generic_failure);

  LOG_TIME_START();
  auto script_result = maybe_script.ToLocalChecked()->Run(context);
  LOG_TIME_END("----- script execution -----");
  CHECK_MAYBE_EMPTY(env, script_result, napi_generic_failure);

  if (need_mkcache) {
    v8::Isolate* iso = env->ctx->isolate;
    v8::Persistent<v8::Script> pscr(iso, maybe_script.ToLocalChecked());
    create_codecache(env, &pscr, iso, filename);
  }

  *result = v8impl::JsValueFromV8LocalValue(script_result.ToLocalChecked());
  return GET_RETURN_STATUS(env);
}
#endif

void napi_attach_v8(napi_env env, v8::Local<v8::Context> ctx) {
#define SET_METHOD(API) env->napi_##API = &napi_##API;

  FOR_EACH_NAPI_ENGINE_CALL(SET_METHOD)

#undef SET_METHOD

  env->ctx = new napi_context__v8(env, ctx);
}

void napi_detach_v8(napi_env env) {
  delete env->ctx;
  env->ctx = nullptr;
}

v8::Local<v8::Context> napi_get_env_context_v8(napi_env env) {
  return env->ctx->context();
}
