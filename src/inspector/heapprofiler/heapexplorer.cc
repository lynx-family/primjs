
// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "inspector/heapprofiler/heapexplorer.h"

#include <vector>

#include "gc/collector.h"
#include "gc/global-handles.h"
#include "gc/qjsvaluevalue-space.h"
#include "gc/trace-gc.h"
#include "inspector/heapprofiler/gen.h"
#include "inspector/heapprofiler/heapprofiler.h"
#include "quickjs/include/bignum.h"

namespace quickjs {
namespace heapprofiler {

QjsHeapExplorer::QjsHeapExplorer(HeapSnapshot* snapshot, LEPUSContext* ctx)
    : snapshot_(snapshot),
      context_(ctx),
      object_id_maps_(snapshot->profiler()->object_id_maps()) {}

QjsHeapExplorer::~QjsHeapExplorer() {}

HeapEntry* QjsHeapExplorer::GetEntry(LEPUSContext* ctx,
                                     const LEPUSValue& value) {
  return HasEntry(value) ? generator_->FindOrAddEntry(ctx, value, this)
                         : nullptr;
}

HeapEntry* QjsHeapExplorer::GetEntry(LEPUSContext* ctx, const HeapObjPtr& ptr) {
  return generator_->FindOrAddEntry(ctx, ptr, this);
}

HeapEntry* QjsHeapExplorer::AddEntry(LEPUSContext* ctx,
                                     const LEPUSValue& value) {
  auto tag = LEPUS_VALUE_GET_NORM_TAG(value);
  if (unlikely(tag == LEPUS_TAG_SYMBOL)) {
    return AddEntry(
        ctx, HeapObjPtr{LEPUS_VALUE_GET_PTR(value), HeapObjPtr::kJSSymbol});
  }
  switch (tag) {
#define ADD_VALUE_ENTRY(tag, type) \
  case tag:                        \
    return AddEntry(               \
        ctx,                       \
        HeapObjPtr{static_cast<const type*>(LEPUS_VALUE_GET_PTR(value))});
    VALUE_TAG_TYPE(ADD_VALUE_ENTRY)
#undef ADD_VALUE_ENTRY
  }
  return nullptr;
}

HeapObjPtr QjsHeapExplorer::GetHandleObj(void* ptr) {
#ifdef ENABLE_COMPATIBLE_MM
  int32_t alloc_tag = get_alloc_tag(ptr);
  switch (alloc_tag) {
    case ALLOC_TAG_WITHOUT_PTR:
    case ALLOC_TAG_JSValueArray:
    case ALLOC_TAG_JSConstString:
    case ALLOC_TAG_JsonStrArray: {
      return HeapObjPtr{ptr, static_cast<HeapObjPtr::PtrType>(alloc_tag),
                        allocate_usable_size(ptr)};
    }
    default:
      break;
  }
#else
  int32_t alloc_tag = ALLOC_TAG_WITHOUT_PTR;
#endif
  return HeapObjPtr{ptr, static_cast<HeapObjPtr::PtrType>(alloc_tag)};
}

HeapEntry* QjsHeapExplorer::AddEntry(LEPUSContext* ctx, const HeapObjPtr& obj) {
  HeapEntry* entry = nullptr;
  auto obj_id = object_id_maps_->GetEntryObjectId(obj);
  switch (obj.type_) {
    case HeapObjPtr::kDefaultPtr: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / default",
                                  obj_id, obj.size_);
    } break;
    case HeapObjPtr::kWithoutPtr: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / withoutptr",
                                  obj_id, obj.size_);
    } break;
    case HeapObjPtr::kLEPUSLepusRef: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / lepusref",
                                  obj_id, sizeof(LEPUSLepusRef));
    } break;
    case HeapObjPtr::kJSSeparableString: {
      auto real_str = DEBUGGER_COMPATIBLE_CALL_RET(
          ctx, JS_GetSeparableStringContentNotDup, ctx,
          LEPUS_MKPTR(LEPUS_TAG_SEPARABLE_STRING, const_cast<void*>(obj.ptr_)));

      auto* str = LEPUS_VALUE_GET_STRING(real_str);
      auto* name = LEPUS_ToCString(ctx, real_str);
      entry = snapshot_->AddEntry(
          HeapEntry::kConsString, name ? name : "", obj_id,
          sizeof(JSSeparableString) + sizeof(JSString) +
              ((str->len << str->is_wide_char) + 1 - str->is_wide_char));
      if (name && !ctx->gc_enable) LEPUS_FreeCString(ctx, name);
    } break;
    case HeapObjPtr ::kJSBigInt: {
      entry = snapshot_->AddEntry(HeapEntry::kBigInt, "bigint", obj_id,
                                  sizeof(JSBigInt));
    } break;
    case HeapObjPtr::kJSSymbol: {
      auto* symbol = static_cast<const JSString*>(obj.ptr_);
      auto val = DEBUGGER_COMPATIBLE_CALL_RET(
          ctx, js_symbol_toString, ctx,
          LEPUS_MKPTR(LEPUS_TAG_SYMBOL, const_cast<void*>(obj.ptr_)), 0,
          nullptr);
      auto* name = LEPUS_ToCString(ctx, val);
      entry = snapshot_->AddEntry(
          HeapEntry::kSymbol, name ? name : "", obj_id,
          (symbol->len << symbol->is_wide_char) + 1 - symbol->is_wide_char);
      if (!ctx->gc_enable) {
        LEPUS_FreeValue(ctx, val);
        LEPUS_FreeCString(ctx, name);
      }
    } break;
    case HeapObjPtr::kJSString: {
      auto* str = static_cast<const JSString*>(obj.ptr_);
      auto* name = LEPUS_ToCString(
          ctx, LEPUS_MKPTR(LEPUS_TAG_STRING, const_cast<void*>(obj.ptr_)));
      entry = snapshot_->AddEntry(
          HeapEntry::kString, name ? name : "", obj_id,
          (str->len << str->is_wide_char) + 1 - str->is_wide_char);
      if (name && !ctx->gc_enable) {
        LEPUS_FreeCString(ctx, name);
      }
    } break;
    case HeapObjPtr::kJSAsyncFunctionData: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / async_function",
                                  obj_id, sizeof(JSAsyncFunctionData));
    } break;
    case HeapObjPtr::kJSVarRef: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / var_ref",
                                  obj_id, sizeof(JSVarRef));
    } break;
    case HeapObjPtr::kJSPropertyGetSet: {
      entry =
          snapshot_->AddEntry(HeapEntry::kNative, "system / property_getset",
                              obj_id, sizeof(JSPropertyGetSet));
    } break;
    case HeapObjPtr::kJSPropertyAutoInit: {
      entry =
          snapshot_->AddEntry(HeapEntry::kNative, "system / property_autoinit",
                              obj_id, sizeof(JSPropertyAutoInit));
    } break;
    case HeapObjPtr ::kLEPUSModuleDef: {
      auto* m = static_cast<const LEPUSModuleDef*>(obj.ptr_);
      std::string module_name = "system / module";
      if (m && m->module_name != JS_ATOM_NULL) {
        if (auto* str = LEPUS_AtomToCString(ctx, m->module_name)) {
          module_name = str;
          if (!ctx->gc_enable) LEPUS_FreeCString(ctx, str);
        }
      }
      entry = snapshot_->AddEntry(HeapEntry::kNative, module_name, obj_id,
                                  sizeof(LEPUSModuleDef));
    } break;
    case HeapObjPtr::kJSArrayBuffer: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / array_buffer",
                                  obj_id, sizeof(JSArrayBuffer));
    } break;
    case HeapObjPtr::kJSTypedArray: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / typed_array",
                                  obj_id, sizeof(JSTypedArray));
    } break;
    case HeapObjPtr::kJSMapState: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / map_state",
                                  obj_id, sizeof(JSMapState));
    } break;
    case HeapObjPtr::kJSMapRecord: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / map_record",
                                  obj_id, sizeof(JSMapRecord));
    } break;
    case HeapObjPtr::kJSPromiseFunctionData: {
      entry = snapshot_->AddEntry(HeapEntry::kNative,
                                  "system / promise_function_data", obj_id,
                                  sizeof(JSPromiseFunctionData));
    } break;
    case HeapObjPtr::kFinalizationRegistryData: {
      entry = snapshot_->AddEntry(HeapEntry::kNative,
                                  "system / finalization_registry_data", obj_id,
                                  sizeof(FinalizationRegistryData));
    } break;
    case HeapObjPtr::kFinalizationRegistryEntry: {
      entry = snapshot_->AddEntry(HeapEntry::kNative,
                                  "system / finalization_registry_entry",
                                  obj_id, sizeof(FinalizationRegistryEntry));
    } break;
    case HeapObjPtr::kWeakRefData: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / weak_ref_data",
                                  obj_id, sizeof(WeakRefData));
    } break;
    case HeapObjPtr::kWeakRefRecord: {
      entry =
          snapshot_->AddEntry(HeapEntry::kNative, "system / weak_ref_record",
                              obj_id, sizeof(WeakRefRecord));
    } break;
    case HeapObjPtr ::kLEPUSFunctionBytecode: {
      auto* b = static_cast<const LEPUSFunctionBytecode*>(obj.ptr_);
      std::string func_name;
      if (b->func_name != JS_ATOM_NULL) {
        if (auto* str = LEPUS_AtomToCString(ctx, b->func_name)) {
          func_name = str;
          if (!ctx->gc_enable) LEPUS_FreeCString(ctx, str);
        }
      }
      entry = snapshot_->AddEntry(HeapEntry::kClosure,
                                  func_name.size() ? func_name : "anonymous",
                                  obj_id, sizeof(LEPUSFunctionBytecode));
    } break;
    case HeapObjPtr ::kLEPUSObject: {
      auto* p = static_cast<const LEPUSObject*>(obj.ptr_);
      std::string name;
      if (p->class_id == JS_CLASS_ARRAY || p->class_id == JS_CLASS_ARGUMENTS ||
          (JS_CLASS_UINT8C_ARRAY <= p->class_id &&
           p->class_id <= JS_CLASS_BIG_UINT64_ARRAY)) {
        entry = snapshot_->AddEntry(HeapEntry::kArray, "[]", obj_id,
                                    sizeof(LEPUSObject));
      } else {
        auto value = LEPUS_MKPTR(LEPUS_TAG_OBJECT, const_cast<void*>(obj.ptr_));
        auto constructor = LEPUS_GetProperty(ctx, value, JS_ATOM_constructor);
        if (LEPUS_VALUE_IS_OBJECT(constructor)) {
          auto constructor_name =
              LEPUS_GetProperty(ctx, constructor, JS_ATOM_name);
          auto* str = LEPUS_ToCString(ctx, constructor_name);
          if (str) name = str;
          if (!ctx->gc_enable) {
            LEPUS_FreeCString(ctx, str);
            LEPUS_FreeValue(ctx, constructor_name);
            LEPUS_FreeValue(ctx, constructor);
          }
        }
        entry = snapshot_->AddEntry(HeapEntry::kObject,
                                    name.size() ? name : "Object", obj_id,
                                    sizeof(LEPUSObject));
      }
    } break;
    case HeapObjPtr ::kJSValueArray: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / value_array",
                                  obj_id, obj.size_);
    } break;
    case HeapObjPtr::kJSPropertyArray: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / property_array",
                                  obj_id, obj.size_);
    } break;
    case HeapObjPtr::kJSReqModuleEntryArray: {
      entry = snapshot_->AddEntry(
          HeapEntry::kNative, "system / req_module_entries", obj_id, obj.size_);
    } break;
    case HeapObjPtr::kJSExportEntryArray: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / export_entries",
                                  obj_id, obj.size_);
    } break;
    case HeapObjPtr::kJSImportEntryArray: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / import_entries",
                                  obj_id, obj.size_);
    } break;
    case HeapObjPtr::kJSResolveEntryArray: {
      entry = snapshot_->AddEntry(
          HeapEntry::kNative, "system / resolve_entries", obj_id, obj.size_);
    } break;
    case HeapObjPtr::kVarRef2Array: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / var_ref_array",
                                  obj_id, sizeof(JSVarRef*) * obj.size_);
    } break;
    case HeapObjPtr::kAtom2Array: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / atom_array",
                                  obj_id, sizeof(JSAtomStruct*) * obj.size_);
    } break;
    case HeapObjPtr::kShape2Array: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / shape_array",
                                  obj_id, sizeof(JSShape*) * obj.size_);
    } break;
    case HeapObjPtr ::kContext: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / jscontext",
                                  obj_id, sizeof(LEPUSContext));
    } break;
    case HeapObjPtr ::kRuntime: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / jsruntime",
                                  obj_id, sizeof(LEPUSRuntime));
    } break;

    case HeapObjPtr ::kCString: {
      entry = snapshot_->AddEntry(HeapEntry::kString,
                                  static_cast<const char*>(obj.ptr_), obj_id,
                                  obj.size_);
    } break;
    default:
      break;
  }
  return entry;
}

void QjsHeapExplorer::SetElementReference(HeapEntry* parent_entry,
                                          uint32_t index,
                                          HeapEntry* child_entry) {
  if (!child_entry) return;
  parent_entry->SetIndexedReference(HeapGraphEdge::kElement, index,
                                    child_entry);
}

void QjsHeapExplorer::SetPropertyReference(HeapEntry* entry,
                                           const std::string& name,
                                           HeapEntry* child,
                                           HeapGraphEdge::Type type) {
  if (!child) return;
  entry->SetNamedReference(type, name, child);
  return;
}

void QjsHeapExplorer::SetPropertyReference(LEPUSContext* ctx, HeapEntry* entry,
                                           JSAtom prop_name,
                                           HeapEntry* child_entry,
                                           HeapGraphEdge::Type type) {
  if (!child_entry) return;
  if (__JS_AtomIsTaggedInt(prop_name)) {
    // name is number
    entry->SetIndexedReference(HeapGraphEdge::kElement,
                               __JS_AtomToUInt32(prop_name), child_entry);
    return;
  }
  const char* names = LEPUS_AtomToCString(context_, prop_name);
  entry->SetNamedReference(type, names ? names : "", child_entry);
  if (!context_->gc_enable) LEPUS_FreeCString(context_, names);
  return;
}

void QjsHeapExplorer::SetAndExtractValue(LEPUSContext* ctx, HeapEntry* parent,
                                         const std::string& name,
                                         const LEPUSValue& value,
                                         HeapGraphEdge::Type type) {
  auto* child = GetEntry(ctx, value);
  if (!child) return;
  parent->SetNamedReference(type, name, child);
  ExtractValueReference(ctx, child, value);
}

void QjsHeapExplorer::ExtractHandleObjReference(LEPUSContext* ctx,
                                                HeapEntry* entry,
                                                const HeapObjPtr& obj) {
  switch (obj.type_) {
    case 0:
    case HeapObjPtr::kWithoutPtr:
      break;
    case HeapObjPtr::kLEPUSObject: {
      return ExtractObjectReference(ctx, entry,
                                    static_cast<const LEPUSObject*>(obj.ptr_));
    } break;
    case HeapObjPtr::kLEPUSLepusRef: {
      return ExtractLepusRefReference(
          ctx, entry, static_cast<const LEPUSLepusRef*>(obj.ptr_));
    }
    case HeapObjPtr::kJSShape: {
      return ExtractShapeReference(ctx, entry,
                                   static_cast<const JSShape*>(obj.ptr_));
    } break;
    case HeapObjPtr::kJSVarRef: {
      return ExtractVarrefReference(ctx, entry,
                                    static_cast<const JSVarRef*>(obj.ptr_));
    }
    case HeapObjPtr::kJSPropertyGetSet: {
      return ExtractPropertyGetSetReference(
          ctx, entry, static_cast<const JSPropertyGetSet*>(obj.ptr_));
    }
    case HeapObjPtr::kLEPUSFunctionBytecode: {
      return ExtractFunctionBytecodeReference(
          ctx, entry, static_cast<const LEPUSFunctionBytecode*>(obj.ptr_));
    }
    case HeapObjPtr::kLEPUSModuleDef: {
      return ExtractModuleReference(
          ctx, entry, static_cast<const LEPUSModuleDef*>(obj.ptr_));
    }
    case HeapObjPtr::kJSValueArray: {
      return ExtractValueArrayReference(
          ctx, entry, static_cast<const LEPUSValue*>(obj.ptr_),
          obj.size_ / sizeof(LEPUSValue));
    }
    default:
      break;
  }
  return;
}

void QjsHeapExplorer::ExtractValueReference(LEPUSContext* ctx, HeapEntry* entry,
                                            const LEPUSValue& value) {
  switch (LEPUS_VALUE_GET_NORM_TAG(value)) {
    case LEPUS_TAG_SHAPE:
      return ExtractShapeReference(
          ctx, entry, static_cast<const JSShape*>(LEPUS_VALUE_GET_PTR(value)));
    case LEPUS_TAG_VAR_REF:
      return ExtractVarrefReference(
          ctx, entry, static_cast<const JSVarRef*>(LEPUS_VALUE_GET_PTR(value)));
    case LEPUS_TAG_FUNCTION_BYTECODE:
      return ExtractFunctionBytecodeReference(
          ctx, entry,
          static_cast<const LEPUSFunctionBytecode*>(
              LEPUS_VALUE_GET_PTR(value)));
    case LEPUS_TAG_MODULE:
      return ExtractModuleReference(
          ctx, entry,
          static_cast<const LEPUSModuleDef*>(LEPUS_VALUE_GET_PTR(value)));
    case LEPUS_TAG_ASYNC_FUNCTION: {
      auto* async_data =
          static_cast<const JSAsyncFunctionData*>(LEPUS_VALUE_GET_PTR(value));
      if (async_data->is_active) {
        ExtractAsyncFunctionStateReference(ctx, entry, &async_data->func_state);
      }
      SetAndExtractValue(ctx, entry, "resolving_func",
                         async_data->resolving_funcs[0]);
      SetAndExtractValue(ctx, entry, "resolving_func",
                         async_data->resolving_funcs[1]);
      return;
    }
    case LEPUS_TAG_OBJECT:
      return ExtractObjectReference(
          ctx, entry,
          static_cast<const LEPUSObject*>(LEPUS_VALUE_GET_PTR(value)));
    case LEPUS_TAG_LEPUS_REF:
      return ExtractLepusRefReference(
          ctx, entry,
          static_cast<const LEPUSLepusRef*>(LEPUS_VALUE_GET_PTR(value)));
  }
  return;
}

void QjsHeapExplorer::ExtractShapeReference(LEPUSContext* ctx, HeapEntry* entry,
                                            const JSShape* shape) {
  if (!entry || !shape) return;
  if (shape->proto) {
    auto* proto_entry =
        GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_OBJECT, shape->proto));
    if (proto_entry) {
      SetInternalReference(entry, "proto", proto_entry);
      ExtractObjectReference(ctx, proto_entry, shape->proto);
    }
  }
  return;
}

void QjsHeapExplorer::ExtractModuleReference(LEPUSContext* ctx,
                                             HeapEntry* entry,
                                             const LEPUSModuleDef* m) {
  if (HasBeExtracted(m)) return;
  InsertExtractedObj(m);

  if (m->req_module_entries) {
    for (int i = 0; i < m->req_module_entries_count; ++i) {
      const auto* req = &m->req_module_entries[i];
      if (req->module) {
        auto* module_entry = GetEntry(ctx, HeapObjPtr{req->module});
        SetInternalReference(entry, "req_module.module", module_entry);
        if (module_entry) {
          ExtractModuleReference(ctx, module_entry, req->module);
        }
      }
    }
  }

  if (m->export_entries) {
    for (int i = 0; i < m->export_entries_count; ++i) {
      const auto* export_entry = &m->export_entries[i];
      if (export_entry->export_type == JS_EXPORT_TYPE_LOCAL &&
          export_entry->u.local.var_ref) {
        auto* var_ref_entry = GetEntry(
            ctx, LEPUS_MKPTR(LEPUS_TAG_VAR_REF, export_entry->u.local.var_ref));
        SetInternalReference(entry, "export.var_ref", var_ref_entry);
        if (var_ref_entry) {
          ExtractVarrefReference(ctx, var_ref_entry,
                                 export_entry->u.local.var_ref);
        }
      }
    }
  }

  SetAndExtractValue(ctx, entry, "module_ns", m->module_ns);
  SetAndExtractValue(ctx, entry, "func_obj", m->func_obj);
  SetAndExtractValue(ctx, entry, "eval_exception", m->eval_exception);
}

void QjsHeapExplorer::ExtractNapiHandleScopeReference(LEPUSContext* ctx,
                                                      HeapEntry* entry) {
  auto* cur_scope = ctx->napi_scope;
  while (cur_scope) {
    auto* cur_handle = cur_scope->GetHandle();
    while (cur_handle) {
      SetAndExtractValue(ctx, entry, "napi_handle", cur_handle->value);
      cur_handle = cur_handle->prev;
    }
    cur_scope = cur_scope->GetPrevScope();
  }
}

void QjsHeapExplorer::ExtractObjectReference(LEPUSContext* ctx,
                                             HeapEntry* entry,
                                             const LEPUSObject* p) {
  if (HasBeExtracted(p)) return;
  InsertExtractedObj(p);
  auto* sh = p->shape;
  ExtractShapeReference(ctx, entry, sh);
  auto* prs = get_shape_prop(sh);
  for (size_t i = 0, size = sh->prop_count; i < size; ++i, ++prs) {
    if (prs->atom != JS_ATOM_NULL) {
      auto* name = LEPUS_AtomToCString(ctx, prs->atom);
      std::string prop_name = name ? name : "";
      if (!ctx->gc_enable) LEPUS_FreeCString(ctx, name);
      if (prs->flags & LEPUS_PROP_TMASK) {
        if ((prs->flags & LEPUS_PROP_TMASK) == LEPUS_PROP_GETSET) {
          if (ctx->gc_enable) {
            const JSPropertyGetSet* getset = p->gc_prop[i].u.getset;
            if (getset) {
              auto* getset_entry = GetEntry(ctx, HeapObjPtr{getset});
              SetInternalReference(entry, "(getset) " + prop_name,
                                   getset_entry);
              ExtractPropertyGetSetReference(ctx, getset_entry, getset);
            }
          } else {
            LEPUSObject* getter = p->prop[i].u.getset.getter;
            LEPUSObject* setter = p->prop[i].u.getset.setter;
            if (getter) {
              auto* getter_entry =
                  GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_OBJECT, getter));
              SetPropertyReference(entry, "(getter) " + prop_name,
                                   getter_entry);
              ExtractObjectReference(ctx, getter_entry, getter);
            }
            if (setter) {
              auto* setter_entry =
                  GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_OBJECT, setter));
              SetPropertyReference(entry, "(setter) " + prop_name,
                                   setter_entry);
              ExtractObjectReference(ctx, setter_entry, setter);
            }
          }
        } else if ((prs->flags & LEPUS_PROP_TMASK) == LEPUS_PROP_VARREF) {
          JSVarRef* var_ref =
              ctx->gc_enable ? p->gc_prop[i].u.var_ref : p->prop[i].u.var_ref;
          if (var_ref) {
            auto* var_ref_entry =
                GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_VAR_REF, var_ref));
            SetPropertyReference(entry, prop_name, var_ref_entry);
            ExtractVarrefReference(ctx, var_ref_entry, var_ref);
          }
        } else if ((prs->flags & LEPUS_PROP_TMASK) == LEPUS_PROP_AUTOINIT &&
                   ctx->gc_enable) {
          const JSPropertyAutoInit* autoinit = p->gc_prop[i].u.autoinit;
          if (autoinit) {
            SetInternalReference(entry, "(autoinit) " + prop_name,
                                 GetEntry(ctx, HeapObjPtr{autoinit}));
          }
        }
      } else {
        // normal value
        LEPUSValue value =
            ctx->gc_enable ? p->gc_prop[i].u.value : p->prop[i].u.value;
        auto* pr_entry = GetEntry(ctx, value);
        SetPropertyReference(ctx, entry, prs->atom, pr_entry);
        ExtractValueReference(ctx, pr_entry, value);
      }
    }
  }
  if (p->first_weak_ref) {
    auto* weak_ref_entry = GetEntry(ctx, HeapObjPtr{p->first_weak_ref});
    SetInternalReference(entry, "first_weak_ref", weak_ref_entry);
    ExtractWeakRefRecordReference(ctx, weak_ref_entry, p->first_weak_ref);
  }

  switch (p->class_id) {
    case JS_CLASS_ARRAY:
    case JS_CLASS_ARGUMENTS: {
      ExtractValueArrayReference(ctx, entry, p->u.array.u.values,
                                 p->u.array.count);
    } break;
    case JS_CLASS_NUMBER:
    case JS_CLASS_STRING:
    case JS_CLASS_BOOLEAN:
    case JS_CLASS_SYMBOL:
    case JS_CLASS_DATE: {
      auto* value_entry = GetEntry(ctx, p->u.object_data);
      if (value_entry) {
        SetInternalReference(entry, "value", value_entry);
        ExtractValueReference(ctx, value_entry, p->u.object_data);
      }
    } break;
    case JS_CLASS_BYTECODE_FUNCTION:
    case JS_CLASS_GENERATOR_FUNCTION:
    case JS_CLASS_ASYNC_FUNCTION:
    case JS_CLASS_ASYNC_GENERATOR_FUNCTION: {
      // u.func
      auto* function_bytecode = p->u.func.function_bytecode;
      if (function_bytecode) {
        auto* function_bytecode_entry = GetEntry(
            ctx, LEPUS_MKPTR(LEPUS_TAG_FUNCTION_BYTECODE, function_bytecode));
        SetInternalReference(entry, "function_bytecode",
                             function_bytecode_entry);
        ExtractFunctionBytecodeReference(ctx, function_bytecode_entry,
                                         function_bytecode);
        auto** var_refs = p->u.func.var_refs;
        if (var_refs) {
          for (size_t i = 0,
                      size = p->u.func.function_bytecode->closure_var_count;
               i < size; ++i) {
            if (!var_refs[i]) continue;
            auto* var_entry =
                GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_VAR_REF, var_refs[i]));
            auto* var_name = LEPUS_AtomToCString(
                ctx, p->u.func.function_bytecode->closure_var[i].var_name);
            // Match V8's heap snapshot semantics: closure variables are
            // represented with "context" edges named by the captured variable.
            SetPropertyReference(entry, var_name ? var_name : "", var_entry,
                                 HeapGraphEdge::kContextVariable);
            ExtractVarrefReference(ctx, var_entry, var_refs[i]);
            if (!ctx->gc_enable) LEPUS_FreeCString(ctx, var_name);
          }
        }
      }

      auto* home_object = p->u.func.home_object;
      if (home_object) {
        auto* home_object_entry =
            GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_OBJECT, home_object));
        SetInternalReference(entry, "home_object", home_object_entry);
        ExtractObjectReference(ctx, home_object_entry, home_object);
      }
    } break;
    default:
      ExtractClassSpecificReference(ctx, entry, p);
      break;
  }
  return;
}

// Mirrors GC's PushObjLEPUSStackFrame (quickjs_gc.cc:28566).
void QjsHeapExplorer::ExtractStackFrameReference(LEPUSContext* ctx,
                                                 HeapEntry* entry,
                                                 const LEPUSStackFrame* sf) {
  if (sf->arg_buf) {
    for (int i = 0; i < sf->arg_count; ++i) {
      SetAndExtractValue(ctx, entry, "arg", sf->arg_buf[i]);
    }
  }
  if (sf->var_buf) {
    LEPUSValue* cur_sp = sf->cur_sp ? sf->cur_sp : sf->sp;
    if (cur_sp) {
      for (LEPUSValue* sp = sf->var_buf; sp < cur_sp; ++sp) {
        SetAndExtractValue(ctx, entry, "var", *sp);
      }
    }
  }
  SetAndExtractValue(ctx, entry, "cur_func", sf->cur_func);
  if (sf->var_refs) {
    int array_size = get_obj_size(sf->var_refs) / sizeof(JSVarRef*);
    for (int i = 0; i < array_size; ++i) {
      if (sf->var_refs[i]) {
        auto* var_entry =
            GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_VAR_REF, sf->var_refs[i]));
        SetInternalReference(entry, "var_ref", var_entry);
        ExtractVarrefReference(ctx, var_entry, sf->var_refs[i]);
      }
    }
  }
  ExtractStackFrameDebuggerThis(ctx, entry, sf);
}

// Mirrors GC's PushObjLEPUSAsyncFunctionState (quickjs_gc.cc:28552).
void QjsHeapExplorer::ExtractAsyncFunctionStateReference(
    LEPUSContext* ctx, HeapEntry* entry, const JSAsyncFunctionState* s) {
  if (!s->on_stack) {
    ExtractStackFrameReference(ctx, entry, &s->frame);
  }
  SetAndExtractValue(ctx, entry, "this_val", s->this_val);
}

// Mirrors GC's VisitJSMapState / VisitJSMapRecord (quickjs_gc.cc:28847/28861).
void QjsHeapExplorer::ExtractMapReference(LEPUSContext* ctx, HeapEntry* entry,
                                          const JSMapState* s) {
  auto* head = &s->records;
  struct list_head* el;
  for (el = head->next; el && el != head; el = el->next) {
    auto* mr = list_entry(el, JSMapRecord, link);
    auto* record_entry = GetEntry(ctx, HeapObjPtr{mr});
    SetInternalReference(entry, "record", record_entry);
    ExtractMapRecordReference(ctx, record_entry, mr, s->is_weak);
  }
}

void QjsHeapExplorer::ExtractMapRecordReference(LEPUSContext* ctx,
                                                HeapEntry* entry,
                                                const JSMapRecord* mr,
                                                bool weak_key) {
  if (!mr || mr->empty || HasBeExtracted(mr)) return;
  InsertExtractedObj(mr);
  if (!weak_key) {
    SetAndExtractValue(ctx, entry, "key", mr->key);
  } else {
    auto* key_entry = GetEntry(ctx, mr->key);
    if (key_entry) {
      entry->SetNamedReference(HeapGraphEdge::kWeak, "key", key_entry);
    }
  }
  SetAndExtractValue(ctx, entry, "value", mr->value);
}

// Mirrors GC's VisitJSPromiseData / VisitJSPromiseReactionData
// (quickjs_gc.cc:28924/28940).
void QjsHeapExplorer::ExtractPromiseReference(LEPUSContext* ctx,
                                              HeapEntry* entry,
                                              const JSPromiseData* s) {
  for (int i = 0; i < 2; ++i) {
    auto* head = &s->promise_reactions[i];
    struct list_head* el;
    for (el = head->next; el && el != head; el = el->next) {
      auto* rd = list_entry(el, JSPromiseReactionData, link);
      SetAndExtractValue(ctx, entry, "resolving_func", rd->resolving_funcs[0]);
      SetAndExtractValue(ctx, entry, "resolving_func", rd->resolving_funcs[1]);
      SetAndExtractValue(ctx, entry, "handler", rd->handler);
    }
  }
  SetAndExtractValue(ctx, entry, "promise_result", s->promise_result);
}

void QjsHeapExplorer::ExtractFinalizationRegistryEntryReference(
    LEPUSContext* ctx, HeapEntry* entry, const FinalizationRegistryEntry* fin) {
  if (!fin || HasBeExtracted(fin)) return;
  InsertExtractedObj(fin);
  if (fin->data) {
    auto* data_entry = GetEntry(ctx, HeapObjPtr{fin->data});
    SetInternalReference(entry, "data", data_entry);
  }
  auto* target_entry = GetEntry(ctx, fin->target);
  if (target_entry) {
    entry->SetNamedReference(HeapGraphEdge::kWeak, "target", target_entry);
  }
  SetAndExtractValue(ctx, entry, "held_value", fin->held_value);
  auto* token_entry = GetEntry(ctx, fin->token);
  if (token_entry) {
    entry->SetNamedReference(HeapGraphEdge::kWeak, "token", token_entry);
  }
}

void QjsHeapExplorer::ExtractFinalizationRegistryReference(
    LEPUSContext* ctx, HeapEntry* entry, const FinalizationRegistryData* frd) {
  if (!frd || HasBeExtracted(frd)) return;
  InsertExtractedObj(frd);
  SetAndExtractValue(ctx, entry, "cleanup_callback", frd->cbs);
  auto* head = &frd->entries;
  struct list_head* el;
  for (el = head->next; el && el != head; el = el->next) {
    auto* fin = list_entry(el, FinalizationRegistryEntry, link);
    auto* fin_entry = GetEntry(ctx, HeapObjPtr{fin});
    SetInternalReference(entry, "entry", fin_entry);
    ExtractFinalizationRegistryEntryReference(ctx, fin_entry, fin);
  }
}

void QjsHeapExplorer::ExtractWeakRefRecordReference(LEPUSContext* ctx,
                                                    HeapEntry* entry,
                                                    const WeakRefRecord* wr) {
  if (!wr || HasBeExtracted(wr)) return;
  InsertExtractedObj(wr);
  switch (wr->kind) {
    case WEAK_REF_KIND_WEAK_MAP: {
      auto* record = wr->u.map_record;
      if (record) {
        auto* record_entry = GetEntry(ctx, HeapObjPtr{record});
        SetInternalReference(entry, "map_record", record_entry);
        ExtractMapRecordReference(ctx, record_entry, record, true);
      }
    } break;
    case WEAK_REF_KIND_FINALIZATION_REGISTRY: {
      auto* fin = wr->u.fin_node;
      if (fin) {
        auto* fin_entry = GetEntry(ctx, HeapObjPtr{fin});
        SetInternalReference(entry, "finalization_entry", fin_entry);
        ExtractFinalizationRegistryEntryReference(ctx, fin_entry, fin);
      }
    } break;
    case WEAK_REF_KIND_WEAK_REF: {
      auto* weak_ref = wr->u.weak_ref;
      if (weak_ref) {
        auto* weak_ref_entry = GetEntry(ctx, HeapObjPtr{weak_ref});
        SetInternalReference(entry, "weak_ref_data", weak_ref_entry);
        auto* target_entry = GetEntry(ctx, weak_ref->target);
        if (target_entry) {
          weak_ref_entry->SetNamedReference(HeapGraphEdge::kWeak, "target",
                                            target_entry);
        }
      }
    } break;
  }
  if (wr->next_weak_ref) {
    auto* next_entry = GetEntry(ctx, HeapObjPtr{wr->next_weak_ref});
    SetInternalReference(entry, "next_weak_ref", next_entry);
    ExtractWeakRefRecordReference(ctx, next_entry, wr->next_weak_ref);
  }
}

// Mirrors GC's VisitLEPUSObject class switch (quickjs_gc.cc:28680) plus the
// dedicated VisitXxx finalizer visitors, covering the object kinds not handled
// inline in ExtractObjectReference.
void QjsHeapExplorer::ExtractClassSpecificReference(LEPUSContext* ctx,
                                                    HeapEntry* entry,
                                                    const LEPUSObject* p) {
  switch (p->class_id) {
    case JS_CLASS_BOUND_FUNCTION: {
      auto* bf = p->u.bound_function;
      if (!bf) break;
      SetAndExtractValue(ctx, entry, "func_obj", bf->func_obj);
      SetAndExtractValue(ctx, entry, "this_val", bf->this_val);
      for (int i = 0; i < bf->argc; ++i) {
        SetAndExtractValue(ctx, entry, "bound_arg", bf->argv[i]);
      }
    } break;
    case JS_CLASS_C_FUNCTION_DATA: {
      auto* s = p->u.c_function_data_record;
      if (!s) break;
      for (int i = 0; i < s->data_len; ++i) {
        SetAndExtractValue(ctx, entry, "data", s->data[i]);
      }
    } break;
    case JS_CLASS_FOR_IN_ITERATOR: {
      auto* it = p->u.for_in_iterator;
      if (it) SetAndExtractValue(ctx, entry, "obj", it->obj);
    } break;
    case JS_CLASS_ARRAY_BUFFER:
    case JS_CLASS_SHARED_ARRAY_BUFFER: {
      auto* abuf = p->u.array_buffer;
      if (abuf && abuf->from_js_heap && abuf->data) {
        auto* data_entry =
            GetEntry(ctx, HeapObjPtr{abuf->data, HeapObjPtr::kWithoutPtr,
                                     static_cast<size_t>(abuf->byte_length)});
        SetInternalReference(entry, "data", data_entry);
      }
    } break;
    case JS_CLASS_UINT8C_ARRAY:
    case JS_CLASS_INT8_ARRAY:
    case JS_CLASS_UINT8_ARRAY:
    case JS_CLASS_INT16_ARRAY:
    case JS_CLASS_UINT16_ARRAY:
    case JS_CLASS_INT32_ARRAY:
    case JS_CLASS_UINT32_ARRAY:
    case JS_CLASS_BIG_INT64_ARRAY:
    case JS_CLASS_BIG_UINT64_ARRAY:
    case JS_CLASS_FLOAT32_ARRAY:
    case JS_CLASS_FLOAT64_ARRAY:
    case JS_CLASS_DATAVIEW: {
      auto* ta = p->u.typed_array;
      if (ta && ta->buffer) {
        SetAndExtractValue(ctx, entry, "buffer",
                           LEPUS_MKPTR(LEPUS_TAG_OBJECT, ta->buffer));
      }
    } break;
    case JS_CLASS_MAP:
    case JS_CLASS_SET:
    case JS_CLASS_WEAKMAP:
    case JS_CLASS_WEAKSET: {
      if (p->u.map_state) ExtractMapReference(ctx, entry, p->u.map_state);
    } break;
    case JS_CLASS_MAP_ITERATOR:
    case JS_CLASS_SET_ITERATOR: {
      auto* it = static_cast<const JSMapIteratorData*>(
          static_cast<const void*>(p->u.map_iterator_data));
      if (!it) break;
      SetAndExtractValue(ctx, entry, "obj", it->obj);
      if (it->cur_record) {
        auto* record_entry = GetEntry(ctx, HeapObjPtr{it->cur_record});
        SetInternalReference(entry, "cur_record", record_entry);
        ExtractMapRecordReference(
            ctx, record_entry, it->cur_record,
            it->cur_record->map && it->cur_record->map->is_weak);
      }
    } break;
    case JS_CLASS_ARRAY_ITERATOR:
    case JS_CLASS_STRING_ITERATOR: {
      auto* it = static_cast<const JSArrayIteratorData*>(
          static_cast<const void*>(p->u.array_iterator_data));
      if (it) SetAndExtractValue(ctx, entry, "obj", it->obj);
    } break;
    case JS_CLASS_REGEXP_STRING_ITERATOR: {
      auto* it = static_cast<const JSRegExpStringIteratorData*>(
          static_cast<const void*>(p->u.regexp_string_iterator_data));
      if (!it) break;
      SetAndExtractValue(ctx, entry, "iterating_regexp", it->iterating_regexp);
      SetAndExtractValue(ctx, entry, "iterated_string", it->iterated_string);
    } break;
    case JS_CLASS_GENERATOR: {
      auto* s = p->u.generator_data;
      if (s && s->state != JS_GENERATOR_STATE_COMPLETED) {
        ExtractAsyncFunctionStateReference(ctx, entry, &s->func_state);
      }
    } break;
    case JS_CLASS_PROXY: {
      auto* s = p->u.proxy_data;
      if (!s) break;
      SetAndExtractValue(ctx, entry, "target", s->target);
      SetAndExtractValue(ctx, entry, "handler", s->handler);
      SetAndExtractValue(ctx, entry, "proto", s->proto);
    } break;
    case JS_CLASS_PROMISE: {
      if (p->u.promise_data) {
        ExtractPromiseReference(ctx, entry, p->u.promise_data);
      }
    } break;
    case JS_CLASS_PROMISE_RESOLVE_FUNCTION:
    case JS_CLASS_PROMISE_REJECT_FUNCTION: {
      auto* s = p->u.promise_function_data;
      if (!s) break;
      SetAndExtractValue(ctx, entry, "promise", s->promise);
    } break;
    case JS_CLASS_ASYNC_FUNCTION_RESOLVE:
    case JS_CLASS_ASYNC_FUNCTION_REJECT: {
      auto* s = p->u.async_function_data;
      if (!s) break;
      if (s->is_active) {
        ExtractAsyncFunctionStateReference(ctx, entry, &s->func_state);
      }
      SetAndExtractValue(ctx, entry, "resolving_func", s->resolving_funcs[0]);
      SetAndExtractValue(ctx, entry, "resolving_func", s->resolving_funcs[1]);
    } break;
    case JS_CLASS_ASYNC_FROM_SYNC_ITERATOR: {
      auto* s = static_cast<const JSAsyncFromSyncIteratorData*>(
          static_cast<const void*>(p->u.async_from_sync_iterator_data));
      if (!s) break;
      SetAndExtractValue(ctx, entry, "sync_iter", s->sync_iter);
      SetAndExtractValue(ctx, entry, "next_method", s->next_method);
    } break;
    case JS_CLASS_ASYNC_GENERATOR: {
      auto* s = static_cast<const JSAsyncGeneratorData*>(
          static_cast<const void*>(p->u.async_generator_data));
      if (!s) break;
      auto* head = &s->queue;
      struct list_head* el;
      for (el = head->next; el && el != head; el = el->next) {
        auto* req = list_entry(el, JSAsyncGeneratorRequest, link);
        SetAndExtractValue(ctx, entry, "result", req->result);
        SetAndExtractValue(ctx, entry, "promise", req->promise);
        SetAndExtractValue(ctx, entry, "resolving_func",
                           req->resolving_funcs[0]);
        SetAndExtractValue(ctx, entry, "resolving_func",
                           req->resolving_funcs[1]);
      }
      if (s->state != JS_ASYNC_GENERATOR_STATE_COMPLETED) {
        ExtractAsyncFunctionStateReference(ctx, entry, &s->func_state);
      }
    } break;
    case JS_CLASS_NUMBER:
    case JS_CLASS_STRING:
    case JS_CLASS_BOOLEAN:
    case JS_CLASS_SYMBOL:
    case JS_CLASS_DATE:
    case JS_CLASS_BIG_INT: {
      SetAndExtractValue(ctx, entry, "value", p->u.object_data);
    } break;
    case JS_CLASS_REGEXP: {
      const auto* re = &p->u.regexp;
      auto* pattern_entry = GetEntry(ctx, HeapObjPtr{re->pattern});
      SetInternalReference(entry, "pattern", pattern_entry);
      auto* bytecode_entry = GetEntry(ctx, HeapObjPtr{re->bytecode});
      SetInternalReference(entry, "bytecode", bytecode_entry);
    } break;
    case JS_CLASS_WeakRef: {
      auto* weak_ref = p->u.weak_ref_data;
      if (!weak_ref) break;
      auto* weak_ref_entry = GetEntry(ctx, HeapObjPtr{weak_ref});
      SetInternalReference(entry, "weak_ref_data", weak_ref_entry);
      auto* target_entry = GetEntry(ctx, weak_ref->target);
      if (target_entry) {
        weak_ref_entry->SetNamedReference(HeapGraphEdge::kWeak, "target",
                                          target_entry);
      }
    } break;
    case JS_CLASS_FinalizationRegistry: {
      auto* frd = p->u.fin_reg_data;
      if (!frd) break;
      auto* frd_entry = GetEntry(ctx, HeapObjPtr{frd});
      SetInternalReference(entry, "registry_data", frd_entry);
      ExtractFinalizationRegistryReference(ctx, frd_entry, frd);
    } break;
    default:
      break;
  }
  return;
}

void QjsHeapExplorer::ExtractVarrefReference(LEPUSContext* ctx,
                                             HeapEntry* entry,
                                             const JSVarRef* ref) {
  if (!ref) return;
  if (HasBeExtracted(ref)) return;
  InsertExtractedObj(ref);
  if (!LEPUS_IsUndefined(ref->value)) {
    auto* value_entry = GetEntry(ctx, ref->value);
    if (value_entry) {
      SetInternalReference(entry, "referenced_value", value_entry);
      ExtractValueReference(ctx, value_entry, ref->value);
    }
  } else {
    auto* prvalue_entry = GetEntry(ctx, *ref->pvalue);
    if (prvalue_entry) {
      SetInternalReference(entry, "referenced_value", prvalue_entry);
      ExtractValueReference(ctx, prvalue_entry, *ref->pvalue);
    }
  }
  return;
}

void QjsHeapExplorer::ExtractFunctionBytecodeReference(
    LEPUSContext* ctx, HeapEntry* entry, const LEPUSFunctionBytecode* b) {
  if (HasBeExtracted(b)) return;
  InsertExtractedObj(b);
  if (b->cpool) {
    // V8 exposes compiled-code owned constants as named internal edges rather
    // than as a user-visible array node. Keep the constant-pool origin visible.
    for (size_t i = 0; i < b->cpool_count; ++i) {
      auto* value_entry = GetEntry(ctx, b->cpool[i]);
      if (value_entry) {
        SetPropertyReference(entry, "constant_pool[" + std::to_string(i) + "]",
                             value_entry, HeapGraphEdge::kInternal);
        ExtractValueReference(ctx, value_entry, b->cpool[i]);
      }
    }
  }

  if (b->has_debug && b->debug.source) {
    auto* source_entry = GetEntry(ctx, HeapObjPtr{b->debug.source});
    SetInternalReference(entry, "debug.source", source_entry);
  }
  return;
}

void QjsHeapExplorer::ExtractPropertyGetSetReference(
    LEPUSContext* ctx, HeapEntry* entry, const JSPropertyGetSet* getset) {
  if (!entry || !getset || HasBeExtracted(getset)) return;
  InsertExtractedObj(getset);
  if (getset->getter) {
    SetAndExtractValue(ctx, entry, "getter",
                       LEPUS_MKPTR(LEPUS_TAG_OBJECT, getset->getter));
  }
  if (getset->setter) {
    SetAndExtractValue(ctx, entry, "setter",
                       LEPUS_MKPTR(LEPUS_TAG_OBJECT, getset->setter));
  }
}

void QjsHeapExplorer::ExtractValueArrayReference(LEPUSContext* ctx,
                                                 HeapEntry* entry,
                                                 const LEPUSValue* values,
                                                 size_t size) {
  if (!entry || !values) return;
  if (HasBeExtracted(values)) return;
  InsertExtractedObj(values);

  for (size_t i = 0; i < size; ++i) {
    auto* ele_entry = GetEntry(ctx, values[i]);
    if (ele_entry) {
      SetElementReference(entry, i, ele_entry);
      ExtractValueReference(ctx, ele_entry, values[i]);
    }
  }
  return;
}

void QjsHeapExplorer::ExtractLepusRefReference(LEPUSContext* ctx,
                                               HeapEntry* entry,
                                               const LEPUSLepusRef* lepus_ref) {
  if (HasBeExtracted(lepus_ref)) return;
  InsertExtractedObj(lepus_ref);
  if (LEPUS_VALUE_IS_OBJECT(lepus_ref->lepus_val)) {
    auto* val_entry = GetEntry(ctx, lepus_ref->lepus_val);
    if (val_entry) {
      SetInternalReference(entry, "lepus_val", val_entry);
      ExtractValueReference(ctx, val_entry, lepus_ref->lepus_val);
    }
  }
  return;
}

void QjsHeapExplorer::ExtractContextReference(LEPUSContext* ctx,
                                              HeapEntry* ctx_entry) {
  if (HasBeExtracted(ctx)) return;
  InsertExtractedObj(ctx);
  {
    auto* runtime_entry = GetEntry(ctx, HeapObjPtr{ctx->rt});
    ctx_entry->SetNamedReference(HeapGraphEdge::kInternal, "runtime",
                                 runtime_entry);
  }
  {
    HeapEntry* member_entry = nullptr;
#define SetInternalAndExtractReference(ctx_member)              \
  member_entry = GetEntry(ctx, ctx->ctx_member);                \
  if (member_entry) {                                           \
    SetInternalReference(ctx_entry, #ctx_member, member_entry); \
    ExtractValueReference(ctx, member_entry, ctx->ctx_member);  \
  }
    OPERATOR_CONTEXT_MEMBER(SetInternalAndExtractReference)
#undef SetInternalAndExtractReference
  }
  if (ctx->loaded_modules.next && ctx->loaded_modules.prev) {
    struct list_head *el, *el1;
    list_for_each_safe(el, el1, &ctx->loaded_modules) {
      auto* module = list_entry(el, LEPUSModuleDef, link);
      auto* module_entry = GetEntry(ctx, HeapObjPtr{module});
      SetInternalReference(ctx_entry, "loaded_module", module_entry);
      ExtractModuleReference(ctx, module_entry, module);
    }
  }
  {
    constexpr const char* native_error_name[] = {
        "eval_error_proto",      "range_error_proto",
        "reference_error_proto", "syntax_error_proto",
        "type_error_proto",      "uri_error_proto",
        "internal_error_proto",  "aggregate_error_proto",
    };
    for (size_t i = 0; i < JS_NATIVE_ERROR_COUNT; ++i) {
      auto* error_entry = GetEntry(ctx, ctx->native_error_proto[i]);
      if (error_entry) {
        SetInternalReference(ctx_entry, native_error_name[i], error_entry);
        ExtractValueReference(ctx, error_entry, ctx->native_error_proto[i]);
      }
    }
  }
  {
    for (int i = 0; i < ctx->rt->class_count; ++i) {
      auto* proto_entry = GetEntry(ctx, ctx->class_proto[i]);
      if (!proto_entry) continue;

      std::string edge_name = "class_proto";
      if (ctx->rt->class_array && ctx->rt->class_array[i].class_name) {
        if (auto* class_name =
                LEPUS_AtomToCString(ctx, ctx->rt->class_array[i].class_name)) {
          edge_name += ":";
          edge_name += class_name;
          if (!ctx->gc_enable) LEPUS_FreeCString(ctx, class_name);
        } else {
          edge_name += "[" + std::to_string(i) + "]";
        }
      } else {
        edge_name += "[" + std::to_string(i) + "]";
      }
      SetInternalReference(ctx_entry, edge_name, proto_entry);
      ExtractValueReference(ctx, proto_entry, ctx->class_proto[i]);
    }
  }
  {
    if (auto* array_shape = ctx->array_shape) {
      auto* arr_shape_entry = GetEntry(ctx, HeapObjPtr{array_shape});
      SetInternalReference(ctx_entry, "array_shape", arr_shape_entry);
      ExtractShapeReference(ctx, arr_shape_entry, array_shape);
    }
  }
  for (size_t i = 0; i < kFunctionShapeSize; ++i) {
    if (auto* function_shape = ctx->function_shape[i]) {
      auto* function_shape_entry = GetEntry(ctx, HeapObjPtr{function_shape});
      SetInternalReference(ctx_entry,
                           "function_shape[" + std::to_string(i) + "]",
                           function_shape_entry);
      if (function_shape_entry) {
        ExtractShapeReference(ctx, function_shape_entry, function_shape);
      }
    }
  }
  ExtractNapiHandleScopeReference(ctx, ctx_entry);
  ExtractDebuggerInfoFromContext(ctx, ctx_entry);
  {
    // lynx_target_sdk_version
    if (ctx->lynx_target_sdk_version) {
      auto* version_entry =
          GetEntry(ctx, HeapObjPtr{ctx->lynx_target_sdk_version});
      ctx_entry->SetNamedReference(HeapGraphEdge::kInternal,
                                   "lynx_target_sdk_version", version_entry);
    }
  }
  if (ctx->fg_ctx) {
    auto* fg_ctx_entry =
        GetEntry(ctx, HeapObjPtr{ctx->fg_ctx, HeapObjPtr::kWithoutPtr,
                                 sizeof(FinalizationRegistryContext)});
    SetInternalReference(ctx_entry, "fg_ctx", fg_ctx_entry);
  }
  return;
}

void QjsHeapExplorer::ExtractRuntimeReference(LEPUSContext* ctx,
                                              HeapEntry* entry,
                                              LEPUSRuntime* rt) {
  if (HasBeExtracted(rt)) return;
  InsertExtractedObj(rt);
  ExtractRuntimeRootReference(ctx, entry, rt);
  if (rt->rt_info) {
    auto* info_entry = GetEntry(ctx, HeapObjPtr{rt->rt_info});
    SetInternalReference(entry, "rt_info", info_entry);
  }
  if (rt->atom_array) {
    auto* atom_array_entry =
        GetEntry(ctx, HeapObjPtr{rt->atom_array, (size_t)rt->atom_size});
    SetInternalReference(entry, "atom_array", atom_array_entry);
    if (atom_array_entry) {
      for (size_t i = 1; i < rt->atom_size; ++i) {
        auto* p = rt->atom_array[i];
        if (p && !atom_is_free(p)) {
          auto* atom_entry = GetEntry(ctx, HeapObjPtr{p});
          SetElementReference(atom_array_entry, i, atom_entry);
        }
      }
    }
  }
  {
    auto* except_entry = GetEntry(ctx, rt->current_exception);
    if (except_entry) {
      SetInternalReference(entry, "current_exception", except_entry);
      ExtractValueReference(ctx, except_entry, rt->current_exception);
    }
  }

  if (rt->shape_hash) {
    auto* shape_array_entry =
        GetEntry(ctx, HeapObjPtr{rt->shape_hash, (size_t)rt->shape_hash_size});
    if (shape_array_entry) {
      SetInternalReference(entry, "shape_array", shape_array_entry);
      for (size_t i = 0; i < rt->shape_hash_size; ++i) {
        if (rt->shape_hash[i]) {
          auto* sh_entry = GetEntry(ctx, HeapObjPtr{rt->shape_hash[i]});
          SetElementReference(shape_array_entry, i, sh_entry);
          ExtractShapeReference(ctx, sh_entry, rt->shape_hash[i]);
        }
      }
    }
  }

  if (rt->boilerplateArg0) {
    SetAndExtractValue(ctx, entry, "boilerplateArg0",
                       LEPUS_MKPTR(LEPUS_TAG_OBJECT, rt->boilerplateArg0));
  }
  if (rt->boilerplateArg1) {
    SetAndExtractValue(ctx, entry, "boilerplateArg1",
                       LEPUS_MKPTR(LEPUS_TAG_OBJECT, rt->boilerplateArg1));
  }
  if (rt->boilerplateArg2) {
    SetAndExtractValue(ctx, entry, "boilerplateArg2",
                       LEPUS_MKPTR(LEPUS_TAG_OBJECT, rt->boilerplateArg2));
  }
  if (rt->boilerplateArg3) {
    SetAndExtractValue(ctx, entry, "boilerplateArg3",
                       LEPUS_MKPTR(LEPUS_TAG_OBJECT, rt->boilerplateArg3));
  }

  if (rt->obj_list.next && rt->obj_list.prev && !list_empty(&rt->obj_list)) {
    // rc mode
    auto* obj_list_entry =
        snapshot_->AddEntry(HeapEntry::kSynthetic, "object_list",
                            HeapObjectIdMaps::kObjListObjectId, 0);
    SetInternalReference(entry, "obj_list", obj_list_entry);
    list_head *el, *el1;
    list_for_each_safe(el, el1, &rt->obj_list) {
      auto* obj = list_entry(el, LEPUSObject, link);
      auto* obj_entry = GetEntry(ctx, HeapObjPtr{obj});
      obj_list_entry->SetNamedAutoIndexReference(HeapGraphEdge::kInternal,
                                                 obj_entry);
      ExtractObjectReference(ctx, obj_entry, obj);
    }
  }

  return;
}

void QjsHeapExplorer::ExtractJobListReference(LEPUSContext* ctx,
                                              HeapEntry* entry,
                                              LEPUSRuntime* rt) {
  if (!rt->job_list.next || !rt->job_list.prev) return;
  list_head *el, *el1;
  list_for_each_safe(el, el1, &rt->job_list) {
    auto* job = list_entry(el, JSJobEntry, link);
    if (job->ctx) {
      auto* job_ctx_entry = GetEntry(job->ctx, HeapObjPtr{job->ctx});
      SetInternalReference(entry, "job.context", job_ctx_entry);
    }
    for (int i = 0; i < job->argc; ++i) {
      SetAndExtractValue(ctx, entry, "job.argv", job->argv[i]);
    }
  }
}

void QjsHeapExplorer::ExtractUnhandledRejectionReference(LEPUSContext* ctx,
                                                         HeapEntry* entry,
                                                         LEPUSRuntime* rt) {
  if (!rt->unhandled_rejections.next || !rt->unhandled_rejections.prev) return;
  list_head *el, *el1;
  list_for_each_safe(el, el1, &rt->unhandled_rejections) {
    auto* rejection = list_entry(el, JSUnhandledRejectionEntry, link);
    SetAndExtractValue(ctx, entry, "unhandled_rejection.error",
                       rejection->error);
    SetAndExtractValue(ctx, entry, "unhandled_rejection.promise",
                       rejection->promise);
  }
}

void QjsHeapExplorer::ExtractRuntimeRootReference(LEPUSContext* ctx,
                                                  HeapEntry* entry,
                                                  LEPUSRuntime* rt) {
  ExtractJobListReference(ctx, entry, rt);
  ExtractUnhandledRejectionReference(ctx, entry, rt);
}

void QjsHeapExplorer::SetRootToGcRootReference() {
  snapshot_->root()->SetIndexedAutoIndexReference(HeapGraphEdge::kElement,
                                                  snapshot_->gc_root());
  return;
}

void QjsHeapExplorer::SetGcRootReference(Root id) {
  snapshot_->gc_root()->SetIndexedAutoIndexReference(HeapGraphEdge::kElement,
                                                     snapshot_->gc_subroot(id));
  return;
}

void QjsHeapExplorer::ExtractGcRootContextReference() {
  auto* gc_context_root = snapshot_->gc_subroot(Root::kContextList);
  struct list_head *el, *el1;
  list_for_each_safe(el, el1, &context_->rt->context_list) {
    auto* ctx = list_entry(el, LEPUSContext, link);
    auto* context_entry = GetEntry(ctx, HeapObjPtr{ctx});
    gc_context_root->SetIndexedAutoIndexReference(HeapGraphEdge::kElement,
                                                  context_entry);
    ExtractContextReference(ctx, context_entry);
  }
  return;
}

void QjsHeapExplorer::ExtractGcRootStackReference() {
  auto* ctx = context_;
  // scan stack
  auto* stack_gc_root = snapshot_->gc_subroot(Root ::kStackRoots);
  auto* sf = ctx->rt->current_stack_frame;
  while (sf) {
    if (sf->arg_buf) {
      for (size_t i = 0, size = sf->arg_count; i < size; ++i) {
        auto* child_entry = GetEntry(ctx, sf->arg_buf[i]);
        if (child_entry) {
          stack_gc_root->SetNamedAutoIndexReference(HeapGraphEdge::kInternal,
                                                    child_entry);
          ExtractValueReference(ctx, child_entry, sf->arg_buf[i]);
        }
      }
    }

    if (sf->var_buf) {
      if (ctx->gc_enable) {
        auto* cur_sp = sf->cur_sp ? sf->cur_sp : sf->sp;
        for (auto* sp = sf->var_buf; sp < cur_sp; ++sp) {
          auto* var_entry = GetEntry(ctx, *sp);
          if (var_entry) {
            stack_gc_root->SetNamedAutoIndexReference(HeapGraphEdge::kInternal,
                                                      var_entry);
            ExtractValueReference(ctx, var_entry, *sp);
          }
        }
      } else if (LEPUS_VALUE_IS_OBJECT(sf->cur_func)) {
        auto* p = LEPUS_VALUE_GET_OBJ(sf->cur_func);
        if (p->class_id == JS_CLASS_BYTECODE_FUNCTION) {
          // bytecode function has vars.
          auto* b = p->u.func.function_bytecode;
          for (size_t i = 0, size = b->var_count; i < size; ++i) {
            auto* var_entry = GetEntry(ctx, sf->var_buf[i]);
            if (var_entry) {
              stack_gc_root->SetNamedAutoIndexReference(
                  HeapGraphEdge::kInternal, var_entry);
            }
          }
        }
      }
    }

    auto* cur_func_entry = GetEntry(ctx, sf->cur_func);
    stack_gc_root->SetNamedAutoIndexReference(HeapGraphEdge::kInternal,
                                              cur_func_entry);
    ExtractValueReference(ctx, cur_func_entry, sf->cur_func);
    sf = sf->prev_frame;
  }
  return;
}

void QjsHeapExplorer::ExtractGcRootHandleReference() {
  auto* ctx = context_;
  if (!ctx->gc_enable) return;
  auto* handles = ctx->rt->ptr_handles;
  if (!handles) return;
  auto* entry = snapshot_->gc_subroot(Root::kHandleScope);
  size_t size = handles->GetHeapObjIdx();
  HeapStruct* heap_struct_handles = handles->GetHandles();
  for (size_t i = 0; i < size; ++i) {
    auto& heap_obj = heap_struct_handles[i];
    switch (heap_obj.type) {
      case HANDLE_TYPE_HEAP_OBJ: {
        auto heap_obj_ptr =
            GetHandleObj(*(reinterpret_cast<void**>(heap_obj.ptr)));
        auto* child_entry = GetEntry(ctx, heap_obj_ptr);
        if (!child_entry) break;
        entry->SetNamedAutoIndexReference(HeapGraphEdge::kInternal,
                                          child_entry);
        ExtractHandleObjReference(ctx, child_entry, heap_obj_ptr);
      } break;
      case HANDLE_TYPE_DIR_HEAP_OBJ: {
        auto heap_obj_ptr = GetHandleObj(heap_obj.ptr);
        auto* child_entry = GetEntry(ctx, heap_obj_ptr);
        if (!child_entry) break;
        entry->SetNamedAutoIndexReference(HeapGraphEdge::kInternal,
                                          child_entry);
        ExtractHandleObjReference(ctx, child_entry, heap_obj_ptr);
      } break;
      case HANDLE_TYPE_LEPUS_VALUE: {
        auto& value = *reinterpret_cast<LEPUSValue*>(heap_obj.ptr);
        auto* value_entry = GetEntry(ctx, value);
        if (value_entry) {
          entry->SetNamedAutoIndexReference(HeapGraphEdge::kInternal,
                                            value_entry);
          ExtractValueReference(ctx, value_entry, value);
        }
      } break;
      case HANDLE_TYPE_LEPUS_TOKEN:
        break;
      case HANDLE_TYPE_BC_READER_STATE:
        break;
      case HANDLE_TYPE_VALUE_BUFFER: {
        auto& value_buffer = *reinterpret_cast<ValueBuffer*>(heap_obj.ptr);
        for (size_t i = 0; i < value_buffer.len; ++i) {
          auto* value_entry = GetEntry(ctx, value_buffer.arr[i]);
          if (!value_entry) continue;
          entry->SetNamedAutoIndexReference(HeapGraphEdge::kInternal,
                                            value_entry);
          ExtractValueReference(ctx, value_entry, value_buffer.arr[i]);
        }
      } break;
      case HANDLE_TYPE_CSTRING:
        break;
      case HANDLE_TYPE_UNDEFINED:
      default:
        break;
    }
  }
  return;
}

void QjsHeapExplorer::VisitGlobalHandleRoot(LEPUSValue value, void* data) {
  auto* visitor_data = static_cast<RootVisitorData*>(data);
  auto* explorer = visitor_data->explorer;
  auto* value_entry = explorer->GetEntry(visitor_data->ctx, value);
  if (!value_entry) return;
  visitor_data->entry->SetNamedAutoIndexReference(HeapGraphEdge::kInternal,
                                                  value_entry);
  explorer->ExtractValueReference(visitor_data->ctx, value_entry, value);
}

void QjsHeapExplorer::ExtractGcRootGlobalHandleReference() {
  auto* ctx = context_;
  if (!ctx->gc_enable) return;
  auto* entry = snapshot_->gc_subroot(Root::kGlobalHandles);
  if (ctx->rt->global_handles_) {
    RootVisitorData visitor_data{this, ctx, entry};
    ctx->rt->global_handles_->VisitRoots(VisitGlobalHandleRoot, &visitor_data);
  }
  auto* allocator = ctx->rt->qjsvaluevalue_allocator;
  if (!allocator) return;
  allocator->IterateStrongRoots([this, ctx, entry](LEPUSValue* val) {
    auto* value_entry = GetEntry(ctx, *val);
    if (value_entry) {
      entry->SetNamedAutoIndexReference(HeapGraphEdge::kInternal, value_entry);
      ExtractValueReference(ctx, value_entry, *val);
    }
  });
  return;
}

void QjsHeapExplorer::ExtractGcRootRuntimeReference() {
  auto* ctx = context_;
  auto* gc_root = snapshot_->gc_root();
  auto* rt_entry = GetEntry(ctx, HeapObjPtr{ctx->rt});
  gc_root->SetIndexedAutoIndexReference(HeapGraphEdge::kElement, rt_entry);
  ExtractRuntimeReference(ctx, rt_entry, ctx->rt);
  return;
}

void QjsHeapExplorer::SetUserGlobalReference() {
  auto* entry = snapshot_->root();
  auto* user_global_entry = GetEntry(context_, context_->global_var_obj);
  user_global_entry->set_name("global / ");
  entry->SetIndexedAutoIndexReference(HeapGraphEdge::kElement,
                                      user_global_entry);
  ExtractValueReference(context_, user_global_entry, context_->global_var_obj);
  return;
}

void QjsHeapExplorer::SetRootToGlobalReference() {
  auto* entry = snapshot_->root();
  auto* global_entry = GetEntry(context_, context_->global_obj);
  entry->SetIndexedAutoIndexReference(HeapGraphEdge::kElement, global_entry);
  ExtractValueReference(context_, global_entry, context_->global_obj);
  return;
}

void QjsHeapExplorer::IterateAndExtractReference(
    HeapSnapshotGenerator* generator) {
  generator_ = generator;
#ifdef ENABLE_COMPATIBLE_MM
  if (context_->gc_enable) {
    context_->rt->collector_->SetForbidGC();
  }
#endif
  SetRootToGcRootReference();
  SetRootToGlobalReference();
  SetUserGlobalReference();
  for (size_t i = 0; i < static_cast<size_t>(Root::kNumberOfRoots); ++i) {
    SetGcRootReference(static_cast<Root>(i));
  }
  ExtractGcRootRuntimeReference();
  ExtractGcRootContextReference();
  ExtractGcRootStackReference();
  ExtractGcRootHandleReference();
  ExtractGcRootGlobalHandleReference();
#ifdef ENABLE_COMPATIBLE_MM
  if (context_->gc_enable) {
    context_->rt->collector_->ResetForbidGC();
  }
#endif
  return;
}
}  // namespace heapprofiler
}  // namespace quickjs

namespace quickjs {
namespace heapprofiler {

#ifdef ENABLE_QUICKJS_DEBUGGER
void QjsHeapExplorer::ExtractDebuggerInfoFromContext(LEPUSContext* ctx,
                                                     HeapEntry* entry) {
  ExtractDebuggerInfoReference(ctx, entry, ctx->debugger_info);
}

void QjsHeapExplorer::ExtractStackFrameDebuggerThis(LEPUSContext* ctx,
                                                    HeapEntry* entry,
                                                    const LEPUSStackFrame* sf) {
  SetAndExtractValue(ctx, entry, "this", sf->pthis);
}

void QjsHeapExplorer::ExtractDebuggerInfoReference(LEPUSContext* ctx,
                                                   HeapEntry* entry,
                                                   LEPUSDebuggerInfo* info) {
  if (!info) return;
  auto* info_entry = GetEntry(ctx, HeapObjPtr{info, HeapObjPtr::kWithoutPtr,
                                              sizeof(LEPUSDebuggerInfo)});
  SetInternalReference(entry, "debugger_info", info_entry);
  if (!info_entry) return;

  SetAndExtractValue(ctx, info_entry, "debugger_name", info->debugger_name);
  if (info->source_code) {
    SetInternalReference(info_entry, "source_code",
                         GetEntry(ctx, HeapObjPtr{info->source_code}));
  }
  struct list_head* el;
  list_for_each(el, &info->script_list) {
    auto* script = list_entry(el, LEPUSScriptSource, link);
    if (script->url) {
      SetInternalReference(info_entry, "script.url",
                           GetEntry(ctx, HeapObjPtr{script->url}));
    }
    if (script->source) {
      SetInternalReference(info_entry, "script.source",
                           GetEntry(ctx, HeapObjPtr{script->source}));
    }
    if (script->hash) {
      SetInternalReference(info_entry, "script.hash",
                           GetEntry(ctx, HeapObjPtr{script->hash}));
    }
    if (script->source_map_url) {
      SetInternalReference(info_entry, "script.source_map_url",
                           GetEntry(ctx, HeapObjPtr{script->source_map_url}));
    }
  }

  SetAndExtractValue(ctx, info_entry, "pause_state.get_properties_array",
                     info->pause_state.get_properties_array);
  SetAndExtractValue(ctx, info_entry, "running_state.get_properties_array",
                     info->running_state.get_properties_array);
  SetAndExtractValue(ctx, info_entry, "object_group_registry",
                     info->object_group_registry);
  SetAndExtractValue(ctx, info_entry, "console.messages",
                     info->console.messages);
#define DebuggerExtractStringPool(name, str)                 \
  SetAndExtractValue(ctx, info_entry, "literal_pool." #name, \
                     info->literal_pool.name);
  QJSDebuggerStringPool(DebuggerExtractStringPool)
#undef DebuggerExtractStringPool

      SetAndExtractValue(ctx, info_entry, "debugger_obj.response",
                         info->debugger_obj.response);
  SetAndExtractValue(ctx, info_entry, "debugger_obj.notification",
                     info->debugger_obj.notification);
  SetAndExtractValue(ctx, info_entry, "debugger_obj.breakpoint",
                     info->debugger_obj.breakpoint);
  SetAndExtractValue(ctx, info_entry, "debugger_obj.bp_location",
                     info->debugger_obj.bp_location);
  SetAndExtractValue(ctx, info_entry, "debugger_obj.result",
                     info->debugger_obj.result);
  SetAndExtractValue(ctx, info_entry, "debugger_obj.preview_prop",
                     info->debugger_obj.preview_prop);
  for (auto& [pc, value] : info->break_bytecode_map) {
    SetAndExtractValue(ctx, info_entry, "break_bytecode", value);
  }
  if (info->pause_on_next_statement_reason) {
    SetInternalReference(
        info_entry, "pause_on_next_statement_reason",
        GetEntry(ctx, HeapObjPtr{info->pause_on_next_statement_reason}));
  }
}
#else
void QjsHeapExplorer::ExtractDebuggerInfoFromContext(LEPUSContext* /*ctx*/,
                                                     HeapEntry* /*entry*/) {}
void QjsHeapExplorer::ExtractStackFrameDebuggerThis(
    LEPUSContext* /*ctx*/, HeapEntry* /*entry*/,
    const LEPUSStackFrame* /*sf*/) {}
#endif  // ENABLE_QUICKJS_DEBUGGER

}  // namespace heapprofiler
}  // namespace quickjs
