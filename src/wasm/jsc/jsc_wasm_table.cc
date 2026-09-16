// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_table.h"

#include <JavaScriptCore/JavaScriptCore.h>

#include <cassert>
#include <cmath>
#include <cstddef>
#include <limits>

#include "common/interop_runtime.h"
#include "common/js_type.h"
#include "common/messages.h"
#include "common/wasm_utils.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm_function.h"
#include "jsc/jsc_wasm_memory.h"

namespace primjs::jsc {
using primjs::TableElemType;

namespace {
bool ToPrismTableFunction(JSContextRef ctx, JSCEnv* js_env, JSValueRef value,
                          PrismRuntime* expected_runtime, wasm_func_t** result,
                          JSValueRef* exception, const char* code) {
  *result = nullptr;
  if (js_env->IsNull(value)) return true;
  if (!js_env->IsWasmFunction(value)) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     "Table value must be null or a Prism function", exception);
    return false;
  }
  JSObjectRef function_object = JSValueToObject(ctx, value, exception);
  if ((exception && *exception) || !function_object) return false;
  auto function_opaque =
      static_cast<JSCWasmFunction*>(JSObjectGetPrivate(function_object));
  if (!function_opaque || !function_opaque->function().is<PrismFunction*>()) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     "Table value must be a Prism function", exception);
    return false;
  }
  auto prism_function = function_opaque->function().get<PrismFunction*>();
  if (prism_function->runtime() != expected_runtime) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     "Table value belongs to a different Prism runtime",
                     exception);
    return false;
  }
  *result = prism_function->function();
  return true;
}
}  // namespace

JSClassRef JSCWasmTable::class_ref() {
  static JSClassRef class_ref = JSCWasmTable::InitClassRef();
  return class_ref;
}

JSClassRef JSCWasmTable::prototype_class_ref() {
  static JSClassRef prototype_class_ref = JSCWasmTable::InitProtoClassRef();
  return prototype_class_ref;
}

JSClassRef JSCWasmTable::constructor_class_ref() {
  static JSClassRef constructor_class_ref = JSCWasmTable::InitCtorClassRef();
  return constructor_class_ref;
}

JSClassRef JSCWasmTable::InitClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition("Table", Finalize);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmTable::InitProtoClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Table.Prototype", NULL);
  JSPropertyAttributes default_attr = JSClassCreator::DefaultAttr();
  JSStaticFunction static_funcs[] = {{"set", SetIndexCallback, default_attr},
                                     {"get", GetIndexCallback, default_attr},
                                     {"grow", GrowCallback, default_attr},
                                     {0, 0, 0}};
  def.staticFunctions = static_funcs;
  return JSClassCreate(&def);
}

JSClassRef JSCWasmTable::InitCtorClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition(
      "WebAssembly.Table", NULL, CallAsConstructor);
  return JSClassCreate(&def);
}

void JSCWasmTable::ReleaseClassRef() {
  JSClassRelease(class_ref());
  JSClassRelease(prototype_class_ref());
  JSClassRelease(constructor_class_ref());
}

JSCWasmTable::JSCWasmTable(WasmTableRef table, InteropRuntime* interop)
    : table_(std::move(table)) {
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
};

JSCWasmTable::~JSCWasmTable() {
  if (table_.is<Wasm3Table*>()) {
    delete table_.get<Wasm3Table*>();
  } else {
    delete table_.get<PrismTable*>();
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

void JSCWasmTable::Finalize(JSObjectRef object) {
  WLOGD("Running JSCWasmTable::%s...", __func__);
  auto table = static_cast<JSCWasmTable*>(JSObjectGetPrivate(object));
  delete table;
}

JSObjectRef JSCWasmTable::CreatePrototype(JSContextRef ctx,
                                          JSValueRef* exception) {
  JSObjectRef prototype = JSObjectMake(ctx, prototype_class_ref(), NULL);

  // NOTE(TL;DR)
  // JSStaticValue will define static property for prototype object, where
  // The "thisObject" in Getter and "Setter" is the prototype rather than
  // the instance object itself; likely, The "jsObject" in
  // JSStaticValue.JSObjectGetProperty(ctx, jsObject, ...) is the object
  // which jsclass directly binded(created with jsclass).
  // In order to set property with callback binding to instance object,
  // we need to adopt the JSCExtAPI::DefineProperty to set properties.
  //
  // JSStaticValue static_values[] = {
  //     {"length", GetLengthCallback, 0, default_attr}, {0, 0, 0, 0}};
  // def.staticValues = static_values;
  PropertyDescriptor instance_values[] = {
      {"length", GetLengthCallback, 0, PropertyAttributes::None},
      {0, 0, 0, PropertyAttributes::None}};
  DefineProperties(ctx, prototype, instance_values, exception);

  return prototype;
}

JSObjectRef JSCWasmTable::CreateConstructor(JSContextRef ctx,
                                            InteropRuntime* interop,
                                            JSValueRef* exception) {
  // set the private data with wctx object(PrismRuntime*)
  JSObjectRef ctor = JSObjectMake(ctx, constructor_class_ref(), interop);

  JSObjectRef prototype = CreatePrototype(ctx, exception);
  InitConstructor(ctx, ctor, "Table", prototype, exception);

  auto js_env = interop->js_env<JSCEnv*>();
  js_env->SetTableConstructor(ctor);

  return ctor;
}

JSObjectRef JSCWasmTable::CreateJSObject(JSContextRef ctx,
                                         JSObjectRef constructor,
                                         WasmTableRef table,
                                         JSValueRef* exception) {
  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  WASM_DCHECK(interop != nullptr);
  JSCWasmTable* table_data = new JSCWasmTable(table, interop);

  JSObjectRef obj = JSObjectMake(ctx, class_ref(), table_data);

  JSValueRef prototype = JSObjectGetProperty(
      ctx, constructor, JSCBuiltinObjects::PrototypeStr(), exception);
  prototype = JSValueToObject(ctx, prototype, exception);
  JSObjectSetPrototype(ctx, obj, prototype);

  return obj;
}

bool JSCWasmTable::IsJSCWasmTable(JSContextRef ctx, JSValueRef target) {
  return JSValueIsObjectOfClass(ctx, target, class_ref());
}

JSObjectRef JSCWasmTable::CallAsConstructor(JSContextRef ctx,
                                            JSObjectRef constructor,
                                            size_t argc,
                                            const JSValueRef argv[],
                                            JSValueRef* exception) {
  WLOGD("Running JSCWasmTable::%s...", __func__);
  constexpr const char* code = "WebAssembly.Table()";

  if (argc < 1 || !JSValueIsObject(ctx, argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kDescriptorNeeded_1003, exception);
  }

  JSObjectRef table_desc = JSValueToObject(ctx, argv[0], exception);
  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  bool is_prism = interop->wasm_runtime().is<PrismRuntime*>();
  if (is_prism && ((exception && *exception) || !table_desc)) return nullptr;
  JSValueRef* descriptor_exception = is_prism ? exception : nullptr;

  auto read_size = [&](JSValueRef value, int32_t* result) {
    if (!is_prism) return JSValueGetInt32(ctx, value, result);
    double number = JSValueToNumber(ctx, value, exception);
    if ((exception && *exception) || !std::isfinite(number) ||
        number > std::numeric_limits<int32_t>::max() ||
        number < std::numeric_limits<int32_t>::min()) {
      if ((!exception || !*exception) && exception) {
        ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                         "Table size must be a finite int32", exception);
      }
      return false;
    }
    *result = static_cast<int32_t>(number);
    return true;
  };

  JSValueRef init_value = JSObjectGetProperty(
      ctx, table_desc, JSString("initial"), descriptor_exception);
  if (is_prism && exception && *exception) return nullptr;
  if (JSValueIsUndefined(ctx, init_value)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Property 'initial' is required", exception);
  }
  int32_t init_num;
  if (!read_size(init_value, &init_num)) {
    if (is_prism && exception && *exception) return nullptr;
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoNegative_1001, exception);
  }
  if (init_num < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoNegative_1001, exception);
  }
  if (init_num > MaxSaneTableSize) {
    return ThrowIfException(
        ctx, ErrorTypes::kRangeError, code,
        "Property 'initial' is above the upper bound 100000", exception);
  }

  // get max page size
  JSValueRef max_value = JSObjectGetProperty(
      ctx, table_desc, JSString("maximum"), descriptor_exception);
  if (is_prism && exception && *exception) return nullptr;
  int32_t max_num = MaxSaneTableSize;
  if (!JSValueIsUndefined(ctx, max_value) && !read_size(max_value, &max_num)) {
    if (is_prism && exception && *exception) return nullptr;
    return ThrowIfException(
        ctx, ErrorTypes::kTypeError, code,
        "Property 'maximum' must be convertible to a valid number", exception);
  }
  if (max_num < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Property 'maximum' must be non-negative",
                            exception);
  }
  if (max_num < init_num) {
    return ThrowIfException(
        ctx, ErrorTypes::kRangeError, code,
        "Property 'maximum': value is below the lower bound 'initial'",
        exception);
  }
  if (max_num > MaxSaneTableSize) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Property 'maximum' must be within 100000",
                            exception);
  }

  JSValueRef element_type = JSObjectGetProperty(
      ctx, table_desc, JSString("element"), descriptor_exception);
  if (is_prism && exception && *exception) return nullptr;
  JSStringRef ty_str = NULL;
  if (is_prism || JSValueIsString(ctx, element_type)) {
    ty_str = JSValueToStringCopy(ctx, element_type, descriptor_exception);
  }
  if (is_prism && exception && *exception) return nullptr;

  bool supported_type =
      ty_str && JSStringIsEqualToUTF8CString(ty_str, "anyfunc");
  if (is_prism && ty_str) JSStringRelease(ty_str);
  if (!supported_type) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kUnsupportedElemType_1001,
                            exception);
  }

  // NOTE: only support "anyfunc".
  WasmTableRef table;
  if (is_prism) {
    table =
        interop->CreatePrismTable(init_num, max_num, TableElemType::kFuncRef);
  } else {
    table =
        interop->CreateWasmTable(init_num, max_num, TableElemType::kFuncRef);
  }
  if (table == nullptr) {
    return ThrowIfException(
        ctx, is_prism ? ErrorTypes::kRangeError : ErrorTypes::kError, code,
        ErrorMessages::kInternalError_1001, exception);
  }
  return CreateJSObject(ctx, constructor, table, exception);
}

JSValueRef JSCWasmTable::GetLengthCallback(JSContextRef ctx,
                                           JSObjectRef function,
                                           JSObjectRef thisObject, size_t argc,
                                           const JSValueRef argv[],
                                           JSValueRef* exception) {
  WLOGD("Running JSCWasmTable::%s...", __func__);
  constexpr const char* code = "WebAssembly.Table.length";

  if (!JSValueIsObjectOfClass(ctx, thisObject, class_ref())) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidArgs_1003, exception);
  }
  auto table = static_cast<JSCWasmTable*>(JSObjectGetPrivate(thisObject));
  WASM_DCHECK(table != nullptr);

  uint32_t length = 0;
  if (table->table_.is<Wasm3Table*>()) {
    WASM_DCHECK(table->table_.get<Wasm3Table*>() != nullptr);
    length = table->table_.get<Wasm3Table*>()->size();
  } else {
    WASM_DCHECK(table->table_.get<PrismTable*>() != nullptr);
    length = table->table_.get<PrismTable*>()->size();
  }

  return JSValueMakeNumber(ctx, length);
}

JSValueRef JSCWasmTable::GetIndexCallback(JSContextRef ctx,
                                          JSObjectRef function,
                                          JSObjectRef thisObject, size_t argc,
                                          const JSValueRef argv[],
                                          JSValueRef* exception) {
  WLOGD("Running JSCWasmTable::%s...", __func__);
  constexpr const char* code = "WebAssembly.Table.get()";

  auto table_opaque =
      static_cast<JSCWasmTable*>(JSObjectGetPrivate(thisObject));
  if (wasm_unlikely(!table_opaque || argc < 1)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1003, exception);
  }

  int32_t index;
  if (wasm_unlikely(!JSValueGetInt32(ctx, argv[0], &index) || index < 0)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1004, exception);
  }

  auto interop_runtime = table_opaque->interop_runtime_;
  WASM_DCHECK(interop_runtime != nullptr);
  auto js_env = interop_runtime->js_env<JSCEnv*>();
  WASM_DCHECK(js_env != nullptr);

  JSObjectRef func_value = nullptr;

  auto wasm_table = table_opaque->table_;
  if (wasm_table.is<Wasm3Table*>()) {
    auto wasm3_table = wasm_table.get<Wasm3Table*>();
    WASM_DCHECK(wasm3_table != nullptr);
    if (index >= wasm3_table->size()) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kInvalidTableIndex_1001,
                              exception);
    }

    IM3Function func_ref = wasm3_table->get(index);
    if (!func_ref) return js_env->MakeNull();

    auto& func_cache = js_env->wasm_func_cache();
    uintptr_t ptr = reinterpret_cast<uintptr_t>(func_ref);
    if (func_cache.count(ptr)) {
      if (!js_env->IsWasmFunction(func_cache[ptr])) {
        auto func_data =
            new Wasm3Function(func_cache[ptr], wasm3_table->runtime(),
                              wasm3_table->instance(), func_ref);
        func_cache[ptr] =
            js_env->MakeWasmFunction(interop_runtime, nullptr, func_data);
      }
      func_value = func_cache[ptr];
    } else {
      auto func_data = new Wasm3Function(func_ref, wasm3_table->runtime(),
                                         wasm3_table->instance());
      func_value =
          js_env->MakeWasmFunction(interop_runtime, nullptr, func_data);
      func_cache[ptr] = func_value;
    }
  } else {
    auto prism_table = wasm_table.get<PrismTable*>();
    if (wasm_unlikely(index >= prism_table->size())) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kInvalidTableIndex_1002,
                              exception);
    }
    uintptr_t ptr = prism_table->function_identity(index);
    if (wasm_unlikely(!ptr)) return js_env->MakeNull();
    JSCEnv::JSObject cached_func;
    if (prism_table->runtime()->GetExportFunctionObject<JSCEnv>(ptr,
                                                                &cached_func) &&
        js_env->IsWasmFunction(cached_func)) {
      func_value = cached_func;
    } else {
      auto& func_cache = js_env->wasm_func_cache();
      if (!func_cache.count(ptr) || !js_env->IsWasmFunction(func_cache[ptr])) {
        auto func_ref = prism_table->get(index);
        if (wasm_unlikely(!func_ref)) return js_env->MakeNull();
        auto func_data = new PrismFunction(func_ref, prism_table->runtime(),
                                           prism_table->instance(), false);
        JSObjectRef wrapper =
            js_env->MakeWasmFunction(interop_runtime, nullptr, func_data);
        if (wasm_unlikely(!wrapper)) {
          delete func_data;
          return ThrowIfException(ctx, ErrorTypes::kError, code,
                                  "Unable to create Prism function wrapper",
                                  exception);
        }
        js_env->CacheWasmFunction(ptr, wrapper);
      }
      prism_table->runtime()->CacheExportFunctionObject<JSCEnv>(
          ptr, func_cache[ptr]);
      func_value = func_cache[ptr];
    }
  }

  return func_value;
}

JSValueRef JSCWasmTable::SetIndexCallback(JSContextRef ctx,
                                          JSObjectRef function,
                                          JSObjectRef thisObject, size_t argc,
                                          const JSValueRef argv[],
                                          JSValueRef* exception) {
  WLOGD("Running JSCWasmTable::%s...", __func__);
  constexpr const char* code = "WebAssembly.Table.set()";

  auto table = static_cast<JSCWasmTable*>(JSObjectGetPrivate(thisObject));
  if (!table || argc < 2) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidTableElem_1001, exception);
  }
  int32_t index = 0;
  if (!JSValueGetInt32(ctx, argv[0], &index) || index < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoNegative_1002, exception);
  }

  JSValueRef value_obj = argv[1];

  uint32_t length = 0;
  auto interop_runtime = table->interop_runtime_;
  auto js_env = interop_runtime->js_env<JSCEnv*>();
  WASM_DCHECK(js_env != nullptr);

  if (table->table_.is<Wasm3Table*>()) {
    WASM_DCHECK(table->table_.get<Wasm3Table*>() != nullptr);
    auto wasm3_table = table->table_.get<Wasm3Table*>();
    length = wasm3_table->size();
    if (length <= index) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kOutOfBoundOperation_1001,
                              exception);
    }

    Wasm3Function* wasm3_function = nullptr;
    if (js_env->IsWasmFunction(value_obj)) {
      auto function_opaque = static_cast<JSCWasmFunction*>(
          JSObjectGetPrivate(JSValueToObject(ctx, value_obj, exception)));
      WasmFunctionRef wasm_function = function_opaque->function();
      if (wasm_function.is<Wasm3Function*>()) {
        wasm3_function = wasm_function.get<Wasm3Function*>();
      } else {
        return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                                ErrorMessages::kInvalidTableElem_1002,
                                exception);
      }
    } else if (!js_env->IsNull(value_obj)) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              ErrorMessages::kInvalidTableElem_1003, exception);
    }

    IM3Function func_addr = nullptr;
    if (wasm3_function) {
      auto& func_cache = js_env->wasm_func_cache();
      func_addr = wasm3_function->function();
      uintptr_t ptr = reinterpret_cast<uintptr_t>(func_addr);
      // Table.set allows only exported functions. Therefore, incoming function
      // is already in the function cache. Note that the object cache is now
      // stored in WasmTable instead of JS's agent.
      //
      // Refcount note (do NOT "fix" this without reading the whole comment):
      // Each underlying wasm function pointer (`ptr`) has at most one JS
      // wrapper, so on a cache hit `value_obj` IS the same JSObject as
      // `func_cache[ptr]`. Overwriting the slot with the same object keeps
      // the existing JSValueProtect intact — net protect count stays at 1,
      // there is no leak.
      // - On cache miss we Dup (= JSValueProtect) the new object once.
      // - On cache hit we deliberately do NOT Free + Dup; that pair would
      //   transiently drop the protect count to 0 and is pointless because
      //   the object is identical.
      // Adding `Free(func_cache[ptr])` here without a matching Dup would
      // unprotect a still-cached object → potential UAF after GC.
      // Verified clean by ASan + UBSan js-api/table-jsc.js (10× table.set
      // per slot, prism+wasm3, ref_count returns to 0 at teardown).
      if (!func_cache.count(ptr)) {
        js_env->DupValue(value_obj);
      }
      func_cache[ptr] = JSValueToObject(ctx, value_obj, exception);
    }
    wasm3_table->set(index, func_addr);
  } else {
    WASM_DCHECK(table->table_.get<PrismTable*>() != nullptr);
    auto prism_table = table->table_.get<PrismTable*>();
    length = prism_table->size();
    if (wasm_unlikely(length <= index)) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kOutOfBoundOperation_1002,
                              exception);
    }

    wasm_func_t* func_addr = nullptr;
    if (!ToPrismTableFunction(ctx, js_env, value_obj, prism_table->runtime(),
                              &func_addr, exception, code)) {
      return nullptr;
    }
    if (!prism_table->set(index, func_addr)) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Unable to set Prism table value", exception);
    }
    if (wasm_likely(func_addr)) {
      auto& func_cache = js_env->wasm_func_cache();
      prism_func* func = prism_get_func(func_addr);
      uintptr_t ptr = reinterpret_cast<uintptr_t>(func);
      // Prism keeps one protected identity wrapper for each native function.
      js_env->CacheWasmFunction(ptr,
                                JSValueToObject(ctx, value_obj, exception));
    }
  }

  return JSValueMakeUndefined(ctx);
}

JSValueRef JSCWasmTable::GrowCallback(JSContextRef ctx, JSObjectRef function,
                                      JSObjectRef thisObject, size_t argc,
                                      const JSValueRef argv[],
                                      JSValueRef* exception) {
  WLOGD("Running JSCWasmTable::%s...", __func__);
  constexpr const char* code = "WebAssembly.Table.grow()";

  auto table = static_cast<JSCWasmTable*>(JSObjectGetPrivate(thisObject));
  if (!table || argc < 1) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1005, exception);
  }

  int32_t num = 0;
  if (!JSValueGetInt32(ctx, argv[0], &num)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1006, exception);
  }
  if (num < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoNegative_1003, exception);
  }

  size_t length = 0;
  uint32_t delta = static_cast<uint32_t>(num);
  if (table->table_.is<Wasm3Table*>()) {
    length = table->table_.get<Wasm3Table*>()->size();
    auto wasm3_table = table->table_.get<Wasm3Table*>();
    if (wasm3_table->OutOfBounds(delta)) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kOutOfBoundOperation_1003,
                              exception);
    }
    if (wasm3_table->grow(delta)) {
      return JSValueMakeNumber(ctx, length);
    }
  } else {
    length = table->table_.get<PrismTable*>()->size();
    auto prism_table = table->table_.get<PrismTable*>();
    if (prism_table->OutOfBounds(delta)) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kOutOfBoundOperation_1004,
                              exception);
    }
    if (prism_table->grow(delta)) {
      return JSValueMakeNumber(ctx, length);
    }
  }

  return ThrowIfException(ctx, ErrorTypes::kError, code,
                          ErrorMessages::kGrowFailed_1002, exception);
}

}  // namespace primjs::jsc
