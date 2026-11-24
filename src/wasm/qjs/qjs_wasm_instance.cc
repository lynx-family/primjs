// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_instance.h"

#include <cstdlib>
#include <cstring>

#include "common/messages.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/js_env_qjs.h"
#include "qjs/qjs_wasm_function.h"
#include "qjs/qjs_wasm_memory.h"
#include "qjs/qjs_wasm_module.h"
#include "qjs/qjs_wasm_table.h"

namespace primjs::qjs {

namespace {
constexpr const char* kInstanceCode = "new WebAssembly.Instance()";

char* PrepareWasmCName(const wasm_name_t* name, char (&inline_buf)[128]) {
  const char* data = name ? name->data : "";
  const size_t size = name ? name->size : 0;
  char* ptr = (size < sizeof(inline_buf))
                  ? inline_buf
                  : static_cast<char*>(std::malloc(size + 1));
  if (ptr) {
    if (size) std::memcpy(ptr, data, size);
    ptr[size] = '\0';
  }
  return ptr;
}

LEPUSValue GetPropertyByWasmName(LEPUSContext* ctx, LEPUSValueConst obj,
                                 const wasm_name_t* name) {
  char inline_buf[128];
  char* cname = PrepareWasmCName(name, inline_buf);
  if (wasm_unlikely(!cname)) return LEPUS_ThrowOutOfMemory(ctx);
  LEPUSValue v = LEPUS_GetPropertyStr(ctx, obj, cname);
  if (cname != inline_buf) std::free(cname);
  return v;
}

int DefineExportProperty(LEPUSContext* ctx, LEPUSValue exports_obj,
                         const wasm_name_t* name, LEPUSValue val) {
  char inline_buf[128];
  char* cname = PrepareWasmCName(name, inline_buf);
  if (wasm_unlikely(!cname)) {
    FreeValueIfRC(ctx, val);
    LEPUS_ThrowOutOfMemory(ctx);
    return -1;
  }
  const int rc = LEPUS_DefinePropertyValueStr(ctx, exports_obj, cname, val,
                                              LEPUS_PROP_C_W_E);
  if (cname != inline_buf) std::free(cname);
  return rc;
}

struct ImportScratch {
  void** raw = nullptr;
  wasm_extern_t** externs = nullptr;
  wasm_func_t** bridges = nullptr;
  wasm_global_t** globals = nullptr;
  QJSWasmTable** imported_tables = nullptr;
  const QJSWasmWrapperBase** inherited_keeps = nullptr;
  size_t n_bridges = 0;
  size_t n_globals = 0;
  size_t n_tables = 0;
  size_t n_keeps = 0;
  bool committed = false;

  bool Init(size_t count) {
    const size_t cap = count > 0 ? count : 1;
    raw = static_cast<void**>(std::calloc(cap * 5, sizeof(void*)));
    if (!raw) return false;
    externs = reinterpret_cast<wasm_extern_t**>(raw);
    bridges = reinterpret_cast<wasm_func_t**>(raw + cap);
    globals = reinterpret_cast<wasm_global_t**>(raw + cap * 2);
    imported_tables = reinterpret_cast<QJSWasmTable**>(raw + cap * 3);
    inherited_keeps = static_cast<const QJSWasmWrapperBase**>(
        static_cast<void*>(raw + cap * 4));
    return true;
  }

  void Cleanup() {
    for (size_t i = 0; i < n_bridges; ++i) {
      wasm_func_delete(bridges[i]);
#if defined(QJS_UNITTEST)
      if (!committed) {
        ++wasm::WasmStoreOwner::rolled_back_import_functions_for_testing_;
      }
#endif
    }
    for (size_t i = 0; i < n_globals; ++i) {
      wasm_global_delete(globals[i]);
    }
    std::free(raw);
    raw = nullptr;
  }
};

bool AppendJSKeepItem(LEPUSContext* ctx, LEPUSValue* keep_arr,
                      uint32_t* keep_len, LEPUSValueConst item) {
  if (LEPUS_IsUndefined(item) || LEPUS_IsNull(item)) return true;
  if (LEPUS_IsUndefined(*keep_arr)) {
    *keep_arr = LEPUS_NewArray(ctx);
    if (LEPUS_IsException(*keep_arr)) return false;
  }
  return LEPUS_DefinePropertyValueUint32(ctx, *keep_arr, (*keep_len)++,
                                         DupValueIfRC(ctx, item),
                                         LEPUS_PROP_C_W_E) >= 0;
}

#if defined(__GNUC__) || defined(__clang__)
__attribute__((noinline))
#endif
bool
BindModuleImports(LEPUSContext* ctx, QJSEnv* env, LEPUSValueConst import_obj,
                  const wasm_importtype_vec_t* import_types,
                  ImportScratch* scratch, LEPUSValue* imports_keep,
                  uint32_t* imports_keep_len, uint64_t callback_tx) {
  if (!LEPUS_IsObject(import_obj)) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                     "Imports argument must be present and must be an object");
    return false;
  }

  for (size_t i = 0; i < import_types->size; ++i) {
    const wasm_importtype_t* imp = import_types->data[i];
    const wasm_externtype_t* ity = wasm_importtype_type(imp);
    if (wasm_unlikely(!ity)) return false;

    LEPUSValue mod_val =
        GetPropertyByWasmName(ctx, import_obj, wasm_importtype_module(imp));
    if (LEPUS_IsException(mod_val)) return false;
    HandleScope iter_scope(ctx, &mod_val, HANDLE_TYPE_LEPUS_VALUE);
    if (!LEPUS_IsObject(mod_val)) {
      FreeValueIfRC(ctx, mod_val);
      ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                       "import module must be an object");
      return false;
    }

    LEPUSValue target =
        GetPropertyByWasmName(ctx, mod_val, wasm_importtype_name(imp));
    FreeValueIfRC(ctx, mod_val);
    if (LEPUS_IsException(target)) return false;
    iter_scope.PushHandle(&target, HANDLE_TYPE_LEPUS_VALUE);

    bool ok = true;
    switch (wasm_externtype_kind(ity)) {
      case WASM_EXTERN_FUNC: {
        const wasm_functype_t* expected_ft =
            wasm_externtype_as_functype_const(ity);
        if (wasm_unlikely(!expected_ft)) {
          ok = false;
        } else if (!LEPUS_IsFunction(ctx, target)) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "function import requires a callable");
          ok = false;
        } else if (LEPUS_GetClassID(ctx, target) ==
                   QJSWasmFunction::class_id()) {
          auto* exported = static_cast<QJSWasmFunction*>(
              LEPUS_GetOpaque(target, QJSWasmFunction::class_id()));
          if (!exported || exported->store_owner() != env->store_owner()) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "function import uses a different runtime");
            ok = false;
          } else if (!exported->EnsureSignature() ||
                     !exported->signature().Matches(expected_ft)) {
            ThrowIfException(
                ctx, ErrorTypes::kError, kInstanceCode,
                "imported function does not match the expected type");
            ok = false;
          } else {
            if (exported->HasKeepTokens()) {
              scratch->inherited_keeps[scratch->n_keeps++] = exported;
            }
            scratch->externs[i] = wasm_func_as_extern(exported->function());
          }
        } else if (!AppendJSKeepItem(ctx, imports_keep, imports_keep_len,
                                     target)) {
          ok = false;
        } else {
          wasm_func_t* bridge = QJSWasmFunction::CreateImportBridge(
              env, target, expected_ft, callback_tx);
          if (wasm_unlikely(!bridge)) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "Unable to create host function import");
            ok = false;
          } else {
            scratch->bridges[scratch->n_bridges++] = bridge;
            scratch->externs[i] = wasm_func_as_extern(bridge);
          }
        }
        break;
      }
      case WASM_EXTERN_TABLE: {
        const wasm_tabletype_t* expected_tt =
            wasm_externtype_as_tabletype_const(ity);
        if (!LEPUS_IsObject(target) ||
            LEPUS_GetClassID(ctx, target) != QJSWasmTable::class_id()) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "table import requires a WebAssembly.Table");
          ok = false;
        } else {
          auto* tbl = static_cast<QJSWasmTable*>(
              LEPUS_GetOpaque(target, QJSWasmTable::class_id()));
          if (!tbl || tbl->store_owner() != env->store_owner()) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "table import uses a different runtime");
            ok = false;
          } else if (!LimitsMatch(wasm_tabletype_limits(expected_tt),
                                  tbl->size(), tbl->maximum())) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "table import limits do not match");
            ok = false;
          } else if (!AppendJSKeepItem(ctx, imports_keep, imports_keep_len,
                                       target)) {
            ok = false;
          } else {
            scratch->imported_tables[scratch->n_tables++] = tbl;
            scratch->externs[i] = wasm_table_as_extern(tbl->table());
          }
        }
        break;
      }
      case WASM_EXTERN_MEMORY: {
        const wasm_memorytype_t* expected_mt =
            wasm_externtype_as_memorytype_const(ity);
        if (!LEPUS_IsObject(target) ||
            LEPUS_GetClassID(ctx, target) != QJSWasmMemory::class_id()) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "memory import requires a WebAssembly.Memory");
          ok = false;
        } else {
          auto* mem = static_cast<QJSWasmMemory*>(
              LEPUS_GetOpaque(target, QJSWasmMemory::class_id()));
          if (!mem || mem->store_owner() != env->store_owner()) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "memory import uses a different runtime");
            ok = false;
          } else if (!LimitsMatch(wasm_memorytype_limits(expected_mt),
                                  static_cast<uint32_t>(mem->pages()),
                                  mem->maximum())) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "memory import limits do not match");
            ok = false;
          } else {
            scratch->externs[i] = wasm_memory_as_extern(mem->memory());
          }
        }
        break;
      }
      case WASM_EXTERN_GLOBAL: {
        const wasm_globaltype_t* expected_gt =
            wasm_externtype_as_globaltype_const(ity);
        if (wasm_unlikely(!expected_gt)) {
          ok = false;
          break;
        }
        if (wasm_globaltype_mutability(expected_gt) != WASM_CONST) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "mutable global import is unsupported");
          ok = false;
          break;
        }
        wasm_val_t val = WASM_INIT_VAL;
        val.kind = wasm_valtype_kind(wasm_globaltype_content(expected_gt));
        if (val.kind == WASM_I64) {
          if (!LEPUS_IsBigInt(target)) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "i64 global import requires a BigInt");
            ok = false;
            break;
          }
        } else if (val.kind == WASM_I32 || val.kind == WASM_F32 ||
                   val.kind == WASM_F64) {
          if (!LEPUS_IsNumber(target)) {
            ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                             "numeric global import requires a Number");
            ok = false;
            break;
          }
        } else {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "global import value type is unsupported");
          ok = false;
          break;
        }
        if (!QJSEnv::ToWasmValueSlow(ctx, target, val.kind, &val)) {
          ok = false;
          break;
        }
        wasm_global_t* g =
            wasm_global_new(env->wasm_store(), expected_gt, &val);
        if (wasm_unlikely(!g)) {
          ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                           "Unable to allocate global import");
          ok = false;
          break;
        }
        scratch->globals[scratch->n_globals++] = g;
        scratch->externs[i] = wasm_global_as_extern(g);
        break;
      }
    }
    FreeValueIfRC(ctx, target);
    if (!ok) return false;
  }
  return true;
}

#if defined(__GNUC__) || defined(__clang__)
__attribute__((noinline))
#endif
bool
PopulateInstanceExports(LEPUSContext* ctx, QJSEnv* env, LEPUSValue exports_obj,
                        wasm_module_t* module, wasm_instance_t* instance,
                        const QJSWasmWrapperBase& instance_keep) {
  wasm_exporttype_vec_t export_types = {0, nullptr};
  wasm_extern_vec_t externs = {0, nullptr};
  wasm_module_exports(module, &export_types);
  wasm_instance_exports(instance, &externs);

  size_t transferred = 0;
  bool ok = (export_types.size == externs.size);
  if (!ok) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                     "wasm instance exporting failed.");
  }

  LEPUSValue wrapped = LEPUS_UNDEFINED;
  HandleScope wrap_scope(ctx, &wrapped, HANDLE_TYPE_LEPUS_VALUE);
  const bool has_instance_keep = instance_keep.HasKeepTokens();
  for (size_t i = 0; ok && i < externs.size; ++i) {
#if defined(QJS_UNITTEST)
    const int limit = wasm::WasmStoreOwner::fail_export_after_for_testing_;
    if (limit >= 0 && static_cast<int>(i) >= limit) {
      ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                       "wasm instance exporting failed.");
      ok = false;
      break;
    }
#endif
    wasm_extern_t* ext = externs.data[i];
    const wasm_name_t* name = wasm_exporttype_name(export_types.data[i]);
    wrapped = LEPUS_EXCEPTION;
    transferred = i + 1;

    switch (wasm_extern_kind(ext)) {
      case WASM_EXTERN_FUNC:
        wrapped = QJSWasmFunction::GetOrWrapOwnedFunc(ctx, env,
                                                      wasm_extern_as_func(ext));
        if (!LEPUS_IsException(wrapped) && LEPUS_IsObject(wrapped) &&
            has_instance_keep) {
          if (auto* fn = static_cast<QJSWasmFunction*>(
                  LEPUS_GetOpaque(wrapped, QJSWasmFunction::class_id()))) {
            fn->MergeKeepSet(ctx, instance_keep);
          }
        }
        break;
      case WASM_EXTERN_MEMORY:
        wrapped = QJSWasmMemory::GetOrWrapOwnedMemory(
            ctx, env, wasm_extern_as_memory(ext));
        break;
      case WASM_EXTERN_TABLE:
        wrapped = QJSWasmTable::GetOrWrapOwnedTable(ctx, env,
                                                    wasm_extern_as_table(ext));
        if (!LEPUS_IsException(wrapped) && LEPUS_IsObject(wrapped) &&
            has_instance_keep) {
          if (auto* tbl = static_cast<QJSWasmTable*>(
                  LEPUS_GetOpaque(wrapped, QJSWasmTable::class_id()))) {
            tbl->MergeKeepSet(ctx, instance_keep);
          }
        }
        break;
      case WASM_EXTERN_GLOBAL: {
        wasm_global_t* g = wasm_extern_as_global(ext);
        wasm_val_t gv = WASM_INIT_VAL;
        wasm_global_get(g, &gv);
        wasm_global_delete(g);
        LEPUSValue js_val = QJSEnv::FromWasmValueSlow(ctx, gv);
        if (!LEPUS_IsException(js_val)) {
          HandleScope gv_scope(ctx, &js_val, HANDLE_TYPE_LEPUS_VALUE);
          wrapped = LEPUS_NewObject(ctx);
          if (LEPUS_IsException(wrapped)) {
            FreeValueIfRC(ctx, js_val);
          } else if (LEPUS_DefinePropertyValueStr(ctx, wrapped, "value", js_val,
                                                  LEPUS_PROP_ENUMERABLE) < 0) {
            FreeValueIfRC(ctx, wrapped);
            wrapped = LEPUS_EXCEPTION;
          }
        }
        break;
      }
    }

    if (LEPUS_IsException(wrapped) ||
        DefineExportProperty(ctx, exports_obj, name, wrapped) < 0) {
      ok = false;
      break;
    }
    wrapped = LEPUS_UNDEFINED;
  }
#if defined(QJS_UNITTEST)
  const int final_limit = wasm::WasmStoreOwner::fail_export_after_for_testing_;
  if (ok && final_limit >= 0 &&
      static_cast<size_t>(final_limit) <= externs.size) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                     "wasm instance exporting failed.");
    ok = false;
  }
#endif
  wasm_exporttype_vec_delete(&export_types);
  for (size_t i = 0; i < transferred && i < externs.size; ++i) {
    externs.data[i] = nullptr;
  }
  wasm_extern_vec_delete(&externs);
  return ok;
}
}  // namespace

QJSWasmInstance::QJSWasmInstance(LEPUSRuntime* rt, LEPUSValue wasm_root,
                                 wasm::WasmStoreOwner* store_owner,
                                 wasm_instance_t* instance)
    : QJSWasmWrapperBase(rt, wasm_root, store_owner, DetachInstance),
      instance_(instance) {
#if defined(QJS_UNITTEST)
  wasm::WasmStoreOwner::live_instances_for_testing_.fetch_add(1);
#endif
}

QJSWasmInstance::~QJSWasmInstance() { UnlinkAndDetach(); }

void QJSWasmInstance::DetachInstance(QJSWasmWrapperBase* base, LEPUSRuntime*) {
  auto* self = static_cast<QJSWasmInstance*>(base);
  if (self->instance_) {
    wasm_instance_delete(self->instance_);
    self->instance_ = nullptr;
#if defined(QJS_UNITTEST)
    wasm::WasmStoreOwner::live_instances_for_testing_.fetch_sub(1);
#endif
  }
}

bool QJSWasmInstance::Register(LEPUSContext* ctx, LEPUSValue wasm_root) {
  return RegisterWasmClass(ctx, wasm_root, WasmQJSClass::kInstance,
                           "WebAssembly.Instance", "Instance",
                           CallAsConstructor);
}

LEPUSValue QJSWasmInstance::CallAsConstructor(LEPUSContext* ctx,
                                              LEPUSValueConst new_target,
                                              int argc, LEPUSValueConst* argv) {
  QJSEnv* env = RequireConstructorEnv(ctx, new_target, kInstanceCode);
  if (!env) return LEPUS_EXCEPTION;

  if (argc == 0 || !LEPUS_IsObject(argv[0]) ||
      LEPUS_GetClassID(ctx, argv[0]) != QJSWasmModule::class_id()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                            ErrorMessages::kModuleNeeded_1006);
  }

  auto* mod = static_cast<QJSWasmModule*>(
      LEPUS_GetOpaque(argv[0], QJSWasmModule::class_id()));
  if (!mod || !mod->module() || mod->store_owner() != env->store_owner()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                            ErrorMessages::kModuleNeeded_1006);
  }

  LEPUSValue import_obj = argc > 1 ? argv[1] : LEPUS_UNDEFINED;
  if (argc > 1 && !LEPUS_IsUndefined(import_obj) &&
      !LEPUS_IsObject(import_obj)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, kInstanceCode,
                            "import object must be an object");
  }

  const wasm_importtype_vec_t* import_types = mod->ImportTypes();
  const size_t import_count = import_types->size;
  ImportScratch scratch;
  if (wasm_unlikely(!scratch.Init(import_count))) {
    return LEPUS_ThrowOutOfMemory(ctx);
  }

  const uint64_t callback_tx =
      import_count > 0 ? env->BeginImportTransaction() : 0;
  bool rollback_tx = (callback_tx != 0);
  bool finish_tx = false;

  LEPUSValue imports_keep = LEPUS_UNDEFINED;
  uint32_t imports_keep_len = 0;
  LEPUSValue instance_obj = LEPUS_UNDEFINED;
  LEPUSValue exported_obj = LEPUS_UNDEFINED;
  LEPUSValue ret_val = LEPUS_EXCEPTION;
  HandleScope scope(ctx, &imports_keep, HANDLE_TYPE_LEPUS_VALUE);

  if (import_count > 0) {
    if (!BindModuleImports(ctx, env, import_obj, import_types, &scratch,
                           &imports_keep, &imports_keep_len, callback_tx)) {
      goto cleanup;
    }
    for (size_t i = 0; i < scratch.n_tables; ++i) {
      QJSWasmTable* tbl = scratch.imported_tables[i];
      tbl->AddKeepToken(ctx, imports_keep);
      for (size_t k = 0; k < scratch.n_keeps; ++k) {
        tbl->MergeKeepSet(ctx, *scratch.inherited_keeps[k]);
      }
    }
  }

  {
    wasm_extern_vec_t imports_vec = {import_count, scratch.externs};
    wasm_trap_t* inst_trap = nullptr;
    wasm_instance_t* wasm_inst = wasm_instance_new(
        env->wasm_store(), mod->module(), &imports_vec, &inst_trap);
    if (wasm_unlikely(!wasm_inst)) {
      if (scratch.n_tables != 0) {
        rollback_tx = false;
        finish_tx = (callback_tx != 0);
      }
      if (inst_trap) {
        ret_val = env->ThrowTrap(inst_trap, kInstanceCode);
      } else {
        LEPUSValue pending;
        ret_val = env->TakeWasmException(&pending)
                      ? LEPUS_Throw(ctx, pending)
                      : ThrowIfException(ctx, ErrorTypes::kError, kInstanceCode,
                                         "start or initialization trapped");
      }
      goto cleanup;
    }

    scratch.committed = true;
    rollback_tx = false;
    finish_tx = (callback_tx != 0);

    instance_obj =
        NewWasmWrapperObject(ctx, env, WasmQJSClass::kInstance, kInstanceCode);
    if (LEPUS_IsException(instance_obj)) {
      wasm_instance_delete(wasm_inst);
      goto cleanup;
    }
    scope.PushHandle(&instance_obj, HANDLE_TYPE_LEPUS_VALUE);

    auto* opaque = new QJSWasmInstance(LEPUS_GetRuntime(ctx), env->wasm_root(),
                                       env->store_owner(), wasm_inst);
    opaque->AddKeepToken(ctx, imports_keep);
    for (size_t k = 0; k < scratch.n_keeps; ++k) {
      opaque->MergeKeepSet(ctx, *scratch.inherited_keeps[k]);
    }

    exported_obj = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(exported_obj)) {
      opaque->ReleaseRoot(LEPUS_GetRuntime(ctx));
      delete opaque;
      FreeValueIfRC(ctx, instance_obj);
      goto cleanup;
    }
    scope.PushHandle(&exported_obj, HANDLE_TYPE_LEPUS_VALUE);

    if (!PopulateInstanceExports(ctx, env, exported_obj, mod->module(),
                                 wasm_inst, *opaque)) {
      opaque->ReleaseRoot(LEPUS_GetRuntime(ctx));
      delete opaque;
      FreeValueIfRC(ctx, exported_obj);
      FreeValueIfRC(ctx, instance_obj);
      goto cleanup;
    }

    if (LEPUS_SetPropertyStr(ctx, instance_obj, "exports", exported_obj) < 0) {
      opaque->ReleaseRoot(LEPUS_GetRuntime(ctx));
      delete opaque;
      FreeValueIfRC(ctx, instance_obj);
      goto cleanup;
    }
    LEPUS_SetOpaque(instance_obj, opaque);
    ret_val = instance_obj;
  }

cleanup:
  if (!LEPUS_IsUndefined(imports_keep) && !LEPUS_IsException(imports_keep)) {
    FreeValueIfRC(ctx, imports_keep);
  }
  if (rollback_tx) {
    const size_t rolled = env->RollbackImportTransaction(callback_tx);
#if defined(QJS_UNITTEST)
    wasm::WasmStoreOwner::rolled_back_import_callbacks_for_testing_ += rolled;
#else
    (void)rolled;
#endif
  } else if (finish_tx) {
    env->FinishImportTransaction(callback_tx);
  }
  scratch.Cleanup();
  return ret_val;
}

}  // namespace primjs::qjs
