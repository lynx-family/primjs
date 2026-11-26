// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_instance.h"

#include <cstring>
#include <memory>
#include <string>
#include <vector>

#include "common/messages.h"
#include "common/wasm_utils.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm_function.h"
#include "jsc/jsc_wasm_memory.h"
#include "jsc/jsc_wasm_module.h"
#include "jsc/jsc_wasm_table.h"

namespace primjs::jsc {

namespace {
constexpr const char* kInstanceCode = "WebAssembly.Instance()";

JSValueRef GetJSCPropertyByWasmName(JSContextRef ctx, JSObjectRef obj,
                                    const wasm_name_t* name,
                                    JSValueRef* exception) {
  const char* data = name ? name->data : "";
  const size_t size = name ? name->size : 0;
  char inline_buf[128];
  if (size < sizeof(inline_buf)) {
    if (size) std::memcpy(inline_buf, data, size);
    inline_buf[size] = '\0';
    return JSObjectGetProperty(ctx, obj, JSString(inline_buf), exception);
  }
  std::string heap_str(data, size);
  return JSObjectGetProperty(ctx, obj, JSString(heap_str.c_str()), exception);
}

bool BindJSCImports(JSContextRef ctx, JSCEnv* env, JSObjectRef import_obj,
                    const wasm_importtype_vec_t* import_types,
                    wasm_extern_t** out_externs,
                    std::vector<wasm_func_t*>* owned_bridges,
                    std::vector<wasm_global_t*>* owned_globals,
                    std::vector<JSCWasmTable*>* imported_tables,
                    std::vector<const JSCKeepSet*>* inherited_keeps,
                    std::vector<JSValueRef>* keep_items, uint64_t callback_tx,
                    JSValueRef* exception) {
  if (!import_obj) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                     "Imports argument must be present and must be an object",
                     exception);
    return false;
  }

  for (size_t i = 0; i < import_types->size; ++i) {
    const wasm_importtype_t* imp = import_types->data[i];
    const wasm_externtype_t* ity = wasm_importtype_type(imp);
    if (wasm_unlikely(!ity)) return false;

    JSValueRef mod_val = GetJSCPropertyByWasmName(
        ctx, import_obj, wasm_importtype_module(imp), exception);
    if (exception && *exception) return false;
    if (!JSValueIsObject(ctx, mod_val)) {
      ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                       "import module must be an object", exception);
      return false;
    }
    JSObjectRef mod_obj = JSValueToObject(ctx, mod_val, exception);
    if ((exception && *exception) || !mod_obj) return false;

    JSValueRef target = GetJSCPropertyByWasmName(
        ctx, mod_obj, wasm_importtype_name(imp), exception);
    if (exception && *exception) return false;

    switch (wasm_externtype_kind(ity)) {
      case WASM_EXTERN_FUNC: {
        const wasm_functype_t* expected_ft =
            wasm_externtype_as_functype_const(ity);
        if (wasm_unlikely(!expected_ft)) return false;
        if (!JSValueIsObject(ctx, target)) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "function import requires a callable", exception);
          return false;
        }
        JSObjectRef fn_obj = JSValueToObject(ctx, target, nullptr);
        if (!fn_obj || !JSObjectIsFunction(ctx, fn_obj)) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "function import requires a callable", exception);
          return false;
        }
        if (JSCWasmFunction::IsWasmFunction(ctx, fn_obj)) {
          auto* exported =
              static_cast<JSCWasmFunction*>(JSObjectGetPrivate(fn_obj));
          if (!exported || exported->store_owner() != env->store_owner()) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "function import uses a different runtime",
                             exception);
            return false;
          }
          if (!exported->EnsureSignature() ||
              !exported->signature().Matches(expected_ft)) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "imported function does not match expected type",
                             exception);
            return false;
          }
          if (!exported->keep_set().empty()) {
            inherited_keeps->push_back(&exported->keep_set());
          }
          out_externs[i] = wasm_func_as_extern(exported->function());
        } else {
          keep_items->push_back(fn_obj);
          wasm_func_t* bridge = JSCWasmFunction::CreateImportBridge(
              env, fn_obj, expected_ft, callback_tx);
          if (wasm_unlikely(!bridge)) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "Unable to create host function import",
                             exception);
            return false;
          }
          owned_bridges->push_back(bridge);
          out_externs[i] = wasm_func_as_extern(bridge);
        }
        break;
      }
      case WASM_EXTERN_TABLE: {
        const wasm_tabletype_t* expected_tt =
            wasm_externtype_as_tabletype_const(ity);
        if (!JSCWasmTable::IsJSCWasmTable(ctx, target)) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "table import requires a WebAssembly.Table",
                           exception);
          return false;
        }
        JSObjectRef tbl_obj = JSValueToObject(ctx, target, nullptr);
        auto* tbl = static_cast<JSCWasmTable*>(JSObjectGetPrivate(tbl_obj));
        if (!tbl || tbl->store_owner() != env->store_owner()) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "table import uses a different runtime", exception);
          return false;
        }
        if (!LimitsMatch(wasm_tabletype_limits(expected_tt), tbl->size(),
                         tbl->maximum())) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "table import limits do not match", exception);
          return false;
        }
        keep_items->push_back(tbl_obj);
        imported_tables->push_back(tbl);
        out_externs[i] = wasm_table_as_extern(tbl->table());
        break;
      }
      case WASM_EXTERN_MEMORY: {
        const wasm_memorytype_t* expected_mt =
            wasm_externtype_as_memorytype_const(ity);
        if (!JSCWasmMemory::IsJSCWasmMemory(ctx, target)) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "memory import requires a WebAssembly.Memory",
                           exception);
          return false;
        }
        JSObjectRef mem_obj = JSValueToObject(ctx, target, nullptr);
        auto* mem = static_cast<JSCWasmMemory*>(JSObjectGetPrivate(mem_obj));
        if (!mem || mem->store_owner() != env->store_owner()) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "memory import uses a different runtime", exception);
          return false;
        }
        if (!LimitsMatch(wasm_memorytype_limits(expected_mt),
                         static_cast<uint32_t>(mem->pages()), mem->maximum())) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "memory import limits do not match", exception);
          return false;
        }
        out_externs[i] = wasm_memory_as_extern(mem->memory());
        break;
      }
      case WASM_EXTERN_GLOBAL: {
        const wasm_globaltype_t* expected_gt =
            wasm_externtype_as_globaltype_const(ity);
        if (wasm_unlikely(!expected_gt)) return false;
        if (wasm_globaltype_mutability(expected_gt) != WASM_CONST) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "mutable global import is unsupported", exception);
          return false;
        }
        wasm_val_t val = WASM_INIT_VAL;
        val.kind = wasm_valtype_kind(wasm_globaltype_content(expected_gt));
        if (val.kind == WASM_I64) {
          if (!env->IsBigInt(target)) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "i64 global import requires a BigInt", exception);
            return false;
          }
        } else if (val.kind == WASM_I32 || val.kind == WASM_F32 ||
                   val.kind == WASM_F64) {
          if (!JSValueIsNumber(ctx, target)) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "numeric global import requires a Number",
                             exception);
            return false;
          }
        } else {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "global import value type is unsupported",
                           exception);
          return false;
        }
        if (!env->ToWasmValue(target, val.kind, &val, exception)) {
          return false;
        }
        wasm_global_t* g =
            wasm_global_new(env->wasm_store(), expected_gt, &val);
        if (wasm_unlikely(!g)) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "Unable to allocate global import", exception);
          return false;
        }
        owned_globals->push_back(g);
        out_externs[i] = wasm_global_as_extern(g);
        break;
      }
    }
  }
  return true;
}

bool PopulateJSCExports(JSContextRef ctx, JSCEnv* env, JSObjectRef exports_obj,
                        wasm_module_t* module, wasm_instance_t* instance,
                        const JSCKeepSet& instance_keep,
                        JSValueRef* exception) {
  wasm_exporttype_vec_t export_types = {0, nullptr};
  wasm_extern_vec_t externs = {0, nullptr};
  wasm_module_exports(module, &export_types);
  wasm_instance_exports(instance, &externs);

  struct ExportVecGuard {
    wasm_exporttype_vec_t* types;
    wasm_extern_vec_t* exts;
    size_t transferred = 0;
    ~ExportVecGuard() {
      wasm_exporttype_vec_delete(types);
      for (size_t i = 0; i < transferred && i < exts->size; ++i) {
        exts->data[i] = nullptr;
      }
      wasm_extern_vec_delete(exts);
    }
  } vec_guard{&export_types, &externs, 0};

  if (export_types.size != externs.size) return false;

  JSValueRef cached_func_proto = nullptr;
  for (size_t i = 0; i < externs.size; ++i) {
    wasm_extern_t* ext = externs.data[i];
    const wasm_name_t* name = wasm_exporttype_name(export_types.data[i]);
    char name_buf[128];
    const char* c_name = "";
    std::string heap_name;
    if (name) {
      if (name->size < sizeof(name_buf)) {
        if (name->size) std::memcpy(name_buf, name->data, name->size);
        name_buf[name->size] = '\0';
        c_name = name_buf;
      } else {
        heap_name.assign(name->data, name->size);
        c_name = heap_name.c_str();
      }
    }
    JSString export_name_str(c_name);
    JSObjectRef wrapped = nullptr;

    switch (wasm_extern_kind(ext)) {
      case WASM_EXTERN_FUNC: {
        vec_guard.transferred = i + 1;
        wrapped = JSCWasmFunction::GetOrWrapOwnedFunc(
            ctx, env, wasm_extern_as_func(ext), nullptr, exception,
            export_name_str, &cached_func_proto);
        if (wrapped && !instance_keep.empty()) {
          auto* fn = static_cast<JSCWasmFunction*>(JSObjectGetPrivate(wrapped));
          if (fn && !fn->keep_set().MergeFrom(env, wrapped, instance_keep,
                                              exception)) {
            return false;
          }
        }
        break;
      }
      case WASM_EXTERN_MEMORY:
        vec_guard.transferred = i + 1;
        wrapped = JSCWasmMemory::GetOrWrapOwnedMemory(
            ctx, env, wasm_extern_as_memory(ext), exception);
        break;
      case WASM_EXTERN_TABLE:
        vec_guard.transferred = i + 1;
        wrapped = JSCWasmTable::GetOrWrapOwnedTable(
            ctx, env, wasm_extern_as_table(ext), exception);
        if (wrapped && !instance_keep.empty()) {
          auto* tbl = static_cast<JSCWasmTable*>(JSObjectGetPrivate(wrapped));
          if (tbl && !tbl->keep_set().MergeFrom(env, wrapped, instance_keep,
                                                exception)) {
            return false;
          }
        }
        break;
      case WASM_EXTERN_GLOBAL: {
        vec_guard.transferred = i + 1;
        wasm_global_t* g = wasm_extern_as_global(ext);
        wasm_val_t gv = WASM_INIT_VAL;
        wasm_global_get(g, &gv);
        wasm_global_delete(g);
        JSValueRef js_val = env->FromWasmValue(gv, exception);
        if (!js_val || (exception && *exception)) return false;
        wrapped = JSObjectMake(ctx, nullptr, nullptr);
        if (!wrapped) return false;
        JSObjectSetProperty(
            ctx, wrapped, JSString("value"), js_val,
            kJSPropertyAttributeReadOnly | kJSPropertyAttributeDontDelete,
            exception);
        if (exception && *exception) return false;
        break;
      }
    }

    if (!wrapped || (exception && *exception)) return false;
    JSObjectSetProperty(ctx, exports_obj, export_name_str, wrapped,
                        kJSPropertyAttributeNone, exception);
    if (exception && *exception) return false;
  }
  return true;
}
}  // namespace

JSClassRef JSCWasmInstance::class_ref() {
  static JSClassRef ref = InitClassRef();
  return ref;
}

JSClassRef JSCWasmInstance::prototype_class_ref() {
  static JSClassRef ref = InitProtoClassRef();
  return ref;
}

JSClassRef JSCWasmInstance::constructor_class_ref() {
  static JSClassRef ref = InitCtorClassRef();
  return ref;
}

JSClassRef JSCWasmInstance::InitClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Instance", Finalize);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmInstance::InitProtoClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Instance.Prototype", nullptr);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmInstance::InitCtorClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition(
      "WebAssembly.Instance", nullptr, CallAsConstructor);
  return JSClassCreate(&def);
}

void JSCWasmInstance::ReleaseClassRef() {
  JSClassRelease(class_ref());
  JSClassRelease(prototype_class_ref());
  JSClassRelease(constructor_class_ref());
}

JSCWasmInstance::JSCWasmInstance(JSCEnv* env, wasm_instance_t* instance)
    : store_owner_(env->store_owner()), instance_(instance) {
  wasm::WasmStoreOwner::Retain(store_owner_);
  store_owner_->LinkHandle(&tracked_, this, DetachOnExit);
}

JSCWasmInstance::~JSCWasmInstance() {
  if (store_owner_) {
    store_owner_->UnlinkHandle(&tracked_);
  }
  DetachWasmInstance();
}

void JSCWasmInstance::DetachWasmInstance() {
  if (instance_) {
    wasm_instance_delete(instance_);
    instance_ = nullptr;
  }
  wasm::WasmStoreOwner::Release(store_owner_);
}

void JSCWasmInstance::DetachOnExit(wasm::WasmTrackedHandle* handle,
                                   void* exit_ctx) {
  (void)exit_ctx;
  auto* self = static_cast<JSCWasmInstance*>(handle->owner_object);
  self->DetachWasmInstance();
}

void JSCWasmInstance::Finalize(JSObjectRef object) {
  auto* inst = static_cast<JSCWasmInstance*>(JSObjectGetPrivate(object));
  delete inst;
}

JSObjectRef JSCWasmInstance::CreatePrototype(JSContextRef ctx,
                                             JSValueRef* exception) {
  (void)exception;
  return JSObjectMake(ctx, prototype_class_ref(), nullptr);
}

JSObjectRef JSCWasmInstance::CreateConstructor(JSContextRef ctx, JSCEnv* env,
                                               JSValueRef* exception) {
  JSObjectRef ctor = JSObjectMake(ctx, constructor_class_ref(), env);
  JSObjectRef prototype = CreatePrototype(ctx, exception);
  InitConstructor(ctx, ctor, "Instance", prototype, exception);
  env->SetInstanceConstructor(ctor);
  return ctor;
}

JSObjectRef JSCWasmInstance::CallAsConstructor(JSContextRef ctx,
                                               JSObjectRef constructor,
                                               size_t argc,
                                               const JSValueRef argv[],
                                               JSValueRef* exception) {
  auto* env = static_cast<JSCEnv*>(JSObjectGetPrivate(constructor));
  if (!env || !env->wasm_store()) {
    return ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                            ErrorMessages::kModuleNeeded_1002, exception);
  }
  env->FlushDeferredUnprotects();

  if (argc == 0 || !JSCWasmModule::IsWasmModuleObject(ctx, argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                            ErrorMessages::kModuleNeeded_1001, exception);
  }

  JSObjectRef module_obj = JSValueToObject(ctx, argv[0], exception);
  if ((exception && *exception) || !module_obj) return nullptr;
  auto* mod = static_cast<JSCWasmModule*>(JSObjectGetPrivate(module_obj));
  if (!mod || !mod->module() || mod->store_owner() != env->store_owner()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                            ErrorMessages::kModuleNeeded_1003, exception);
  }

  if (argc > 1 && !JSValueIsUndefined(ctx, argv[1]) &&
      !JSValueIsObject(ctx, argv[1])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                            "import object must be an object", exception);
  }

  JSObjectRef import_obj = nullptr;
  if (argc > 1 && JSValueIsObject(ctx, argv[1])) {
    import_obj = JSValueToObject(ctx, argv[1], exception);
    if (exception && *exception) return nullptr;
  }

  const wasm_importtype_vec_t* import_types = mod->ImportTypes();
  const size_t import_count = import_types->size;
  std::vector<wasm_extern_t*> externs(import_count > 0 ? import_count : 1,
                                      nullptr);
  wasm_extern_vec_t imports_vec = {import_count, externs.data()};

  struct ImportHandleOwners {
    std::vector<wasm_func_t*> bridges;
    std::vector<wasm_global_t*> globals;
    ~ImportHandleOwners() {
      for (wasm_func_t* b : bridges) wasm_func_delete(b);
      for (wasm_global_t* g : globals) wasm_global_delete(g);
    }
  } import_owners;

  const uint64_t callback_tx =
      import_count > 0 ? env->BeginWasmImportCallbackTransaction() : 0;
  struct PendingCallbackRollback {
    JSCEnv* env;
    uint64_t tx;
    ~PendingCallbackRollback() {
      if (env && tx != 0) {
        env->RollbackWasmImportCallbackTransaction(tx);
      }
    }
    void Commit() { env = nullptr; }
  } pending_callbacks{import_count > 0 ? env : nullptr, callback_tx};

  std::vector<JSCWasmTable*> imported_tables;
  std::vector<const JSCKeepSet*> inherited_keeps;
  std::vector<JSValueRef> keep_items;
  JSObjectRef imports_keep = nullptr;
  struct ProtectedImportsKeep {
    JSContextRef ctx;
    JSObjectRef* obj;
    ~ProtectedImportsKeep() {
      if (*obj) JSValueUnprotect(ctx, *obj);
    }
  } imports_keep_guard{ctx, &imports_keep};

  if (import_count > 0) {
    if (!BindJSCImports(ctx, env, import_obj, import_types, externs.data(),
                        &import_owners.bridges, &import_owners.globals,
                        &imported_tables, &inherited_keeps, &keep_items,
                        callback_tx, exception)) {
      return nullptr;
    }
    if (!keep_items.empty()) {
      imports_keep = JSObjectMakeArray(ctx, keep_items.size(),
                                       keep_items.data(), exception);
      if ((exception && *exception) || !imports_keep) return nullptr;
      JSValueProtect(ctx, imports_keep);
    }
    for (JSCWasmTable* tbl : imported_tables) {
      if (!tbl->keep_set().AddToken(env, tbl->js_object(), imports_keep,
                                    exception)) {
        return nullptr;
      }
      for (const JSCKeepSet* src : inherited_keeps) {
        if (!tbl->keep_set().MergeFrom(env, tbl->js_object(), *src,
                                       exception)) {
          return nullptr;
        }
      }
    }
  }

  wasm::WasmStoreOwner* call_owner = env->store_owner();
  wasm::WasmStoreOwner::Retain(call_owner);
  struct OwnerCallGuard {
    wasm::WasmStoreOwner* owner;
    ~OwnerCallGuard() { wasm::WasmStoreOwner::Release(owner); }
  } call_guard{call_owner};

  wasm_trap_t* inst_trap = nullptr;
  wasm_instance_t* wasm_inst = wasm_instance_new(
      env->wasm_store(), mod->module(), &imports_vec, &inst_trap);
  if (wasm_unlikely(!call_owner || call_owner->active_jsc_env() != env ||
                    !mod->module())) {
    if (inst_trap) wasm_trap_delete(inst_trap);
    if (wasm_inst) wasm_instance_delete(wasm_inst);
    pending_callbacks.Commit();
    imports_keep = nullptr;
    return ThrowIfException(
        ctx, ErrorTypes::kTypeError, kInstanceCode,
        "WebAssembly context was released during instantiation", exception);
  }
  if (wasm_unlikely(!wasm_inst)) {
    if (!imported_tables.empty()) {
      pending_callbacks.Commit();
      env->FinishWasmImportCallbackTransaction(callback_tx);
    }
    if (inst_trap) {
      env->ThrowTrap(inst_trap, kInstanceCode, exception);
      return nullptr;
    }
    JSValueRef pending = env->TakeWasmException();
    if (pending) {
      if (exception) *exception = pending;
      JSValueUnprotect(ctx, pending);
      return nullptr;
    }
    return ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                            "start or initialization trapped", exception);
  }
  pending_callbacks.Commit();
  struct CommittedTxCleanup {
    JSCEnv* env;
    uint64_t tx;
    ~CommittedTxCleanup() {
      if (env && tx != 0) env->FinishWasmImportCallbackTransaction(tx);
    }
  } committed_tx_cleanup{env, callback_tx};

  auto inst_data = std::make_unique<JSCWasmInstance>(env, wasm_inst);
  JSValueRef proto_val = JSObjectGetProperty(
      ctx, constructor, JSCBuiltinObjects::PrototypeStr(), exception);
  if (exception && *exception) return nullptr;
  JSObjectRef prototype = JSValueToObject(ctx, proto_val, exception);
  if ((exception && *exception) || !prototype) return nullptr;

  JSObjectRef instance_obj = JSObjectMake(ctx, class_ref(), nullptr);
  if (!RetainWasmRootOnJSCObject(ctx, instance_obj, env->wasm_root(),
                                 exception) ||
      !inst_data->keep_set().AddToken(env, instance_obj, imports_keep,
                                      exception)) {
    return nullptr;
  }
  for (const JSCKeepSet* src : inherited_keeps) {
    if (!inst_data->keep_set().MergeFrom(env, instance_obj, *src, exception)) {
      return nullptr;
    }
  }
  JSObjectSetPrototype(ctx, instance_obj, prototype);

  JSObjectRef exports_obj = JSObjectMake(ctx, nullptr, nullptr);
  if (!PopulateJSCExports(ctx, env, exports_obj, mod->module(), wasm_inst,
                          inst_data->keep_set(), exception)) {
    if (!exception || !*exception) {
      ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                       ErrorMessages::kInstantiationFailed_1001, exception);
    }
    return nullptr;
  }

  JSObjectSetProperty(ctx, instance_obj, JSString("exports"), exports_obj,
                      JSClassCreator::DefaultAttr(), exception);
  if (exception && *exception) return nullptr;

  WASM_CHECK(JSObjectSetPrivate(instance_obj, inst_data.release()));
  return instance_obj;
}

}  // namespace primjs::jsc
