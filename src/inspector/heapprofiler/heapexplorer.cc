
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
#include "gc/trace-gc.h"
#include "inspector/heapprofiler/gen.h"
#include "inspector/heapprofiler/heapprofiler.h"

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
    case 0:
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
  int32_t alloc_tag = 0;
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
#ifdef CONFIG_BIGNUM
    case HeapObjPtr ::kLEPUSBigFloat: {
      entry = snapshot_->AddEntry(HeapEntry::kBigInt, "bigint", obj_id,
                                  sizeof(JSBigFloat));
    } break;
#endif
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
    case HeapObjPtr::kJSShape: {
      auto* shape = static_cast<const JSShape*>(obj.ptr_);
      entry = snapshot_->AddEntry(
          HeapEntry::kObjectShape, "system / shape", obj_id,
          get_shape_size(shape->prop_hash_mask + 1, shape->prop_size));
    } break;
    case HeapObjPtr::kJSAsyncFunctionData: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / async_function",
                                  obj_id, sizeof(JSAsyncFunctionData));
    } break;
    case HeapObjPtr::kJSVarRef: {
      entry = snapshot_->AddEntry(HeapEntry::kNative, "system / var_ref",
                                  obj_id, sizeof(JSVarRef));
    } break;
    case HeapObjPtr ::kLEPUSModuleDef: {
      // TODO: @zhangyuping
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
           p->class_id <= JS_CLASS_FLOAT64_ARRAY)) {
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
    case HeapObjPtr::kLEPUSFunctionBytecode: {
      return ExtractFunctionBytecodeReference(
          ctx, entry, static_cast<const LEPUSFunctionBytecode*>(obj.ptr_));
    }
    case HeapObjPtr::kJSValueArray: {
      return ExtractValueArrayReference(
          ctx, entry, static_cast<const LEPUSValue*>(obj.ptr_),
          (size_t)get_heap_obj_len(const_cast<void*>(obj.ptr_)));
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
  if (HasBeExtracted(shape)) return;
  InsertExtractedObj(shape);
  if (shape->proto) {
    auto* proto_entry =
        GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_OBJECT, shape->proto));
    entry->SetNamedReference(HeapGraphEdge::kInternal, "proto", proto_entry);
    ExtractObjectReference(ctx, proto_entry, shape->proto);
  }

  if (shape->is_hashed && shape->shape_hash_next) {
    auto* hash_next = shape->shape_hash_next;
    auto* next_entry = GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_SHAPE, hash_next));
    entry->SetNamedReference(HeapGraphEdge::kInternal, "shape_hash_next",
                             next_entry);
    ExtractShapeReference(ctx, next_entry, hash_next);
  }
  return;
}

void QjsHeapExplorer::ExtractObjectReference(LEPUSContext* ctx,
                                             HeapEntry* entry,
                                             const LEPUSObject* p) {
  if (HasBeExtracted(p)) return;
  InsertExtractedObj(p);
  auto* sh = p->shape;
  auto* sh_entry = GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_SHAPE, sh));
  entry->SetNamedReference(HeapGraphEdge::kInternal, "shape", sh_entry);
  ExtractShapeReference(ctx, sh_entry, sh);
  auto* prs = get_shape_prop(sh);
  for (size_t i = 0, size = sh->prop_count; i < size; ++i, ++prs) {
    auto& pr = p->prop[i];
    if (prs->atom != JS_ATOM_NULL) {
      auto* name = LEPUS_AtomToCString(ctx, prs->atom);
      std::string prop_name = name ? name : "";
      if (!ctx->gc_enable) LEPUS_FreeCString(ctx, name);
      if (prs->flags & LEPUS_PROP_TMASK) {
        if ((prs->flags & LEPUS_PROP_TMASK) == LEPUS_PROP_GETSET) {
          if (pr.u.getset.getter) {
            auto* getter_entry = GetEntry(
                ctx, LEPUS_MKPTR(LEPUS_TAG_OBJECT, pr.u.getset.getter));
            SetPropertyReference(entry, "(getter) " + prop_name, getter_entry);
            ExtractObjectReference(ctx, getter_entry, pr.u.getset.getter);
          }
          if (pr.u.getset.setter) {
            auto* setter_entry = GetEntry(
                ctx, LEPUS_MKPTR(LEPUS_TAG_OBJECT, pr.u.getset.setter));
            SetPropertyReference(entry, "(setter) " + prop_name, setter_entry);
            ExtractObjectReference(ctx, setter_entry, pr.u.getset.setter);
          }
        } else if ((prs->flags & LEPUS_PROP_TMASK) == LEPUS_PROP_VARREF) {
          if (pr.u.var_ref) {
            auto* var_ref_entry =
                GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_VAR_REF, pr.u.var_ref));
            SetPropertyReference(entry, prop_name, var_ref_entry);
            ExtractVarrefReference(ctx, var_ref_entry, pr.u.var_ref);
          }
        }
      } else {
        // normal value
        auto* pr_entry = GetEntry(ctx, pr.u.value);
        SetPropertyReference(ctx, entry, prs->atom, pr_entry);
        ExtractValueReference(ctx, pr_entry, pr.u.value);
      }
    }
  }

  switch (p->class_id) {
    case JS_CLASS_ARRAY:
    case JS_CLASS_ARGUMENTS: {
      auto* value_array_entry =
          GetEntry(ctx, HeapObjPtr{p->u.array.u.values,
                                   p->u.array.u1.size * sizeof(LEPUSValue)});
      SetInternalReference(entry, "value_array", value_array_entry);
      ExtractValueArrayReference(ctx, value_array_entry, p->u.array.u.values,
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
          auto* var_refs_entry = GetEntry(
              ctx, HeapObjPtr{var_refs,
                              (size_t)function_bytecode->closure_var_count});
          SetInternalReference(entry, "var_refs", var_refs_entry);
          for (size_t i = 0,
                      size = p->u.func.function_bytecode->closure_var_count;
               i < size; ++i) {
            auto* var_entry =
                GetEntry(ctx, LEPUS_MKPTR(LEPUS_TAG_VAR_REF, var_refs[i]));
            auto* var_name = LEPUS_AtomToCString(
                ctx, p->u.func.function_bytecode->closure_var[i].var_name);
            SetPropertyReference(var_refs_entry, var_name ? var_name : "",
                                 var_entry);
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
      // @zhangyuping: TODO.
      break;
  }
  return;
}

void QjsHeapExplorer::ExtractVarrefReference(LEPUSContext* ctx,
                                             HeapEntry* entry,
                                             const JSVarRef* ref) {
  if (HasBeExtracted(entry)) return;
  InsertExtractedObj(entry);
  if (!LEPUS_IsUndefined(ref->value)) {
    auto* value_entry = GetEntry(ctx, ref->value);
    if (value_entry) {
      SetInternalReference(entry, "value", value_entry);
      ExtractValueReference(ctx, entry, ref->value);
    }
  } else {
    auto* prvalue_entry = GetEntry(ctx, *ref->pvalue);
    if (prvalue_entry) {
      SetInternalReference(entry, "pvalue", prvalue_entry);
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
    auto* cpool_entry = GetEntry(
        ctx, HeapObjPtr{b->cpool, sizeof(LEPUSValue) * b->cpool_count});
    SetInternalReference(entry, "cpool", cpool_entry);
    ExtractValueArrayReference(ctx, cpool_entry, b->cpool, b->cpool_count);
  }

  if (b->has_debug && b->debug.source) {
    auto* source_entry = GetEntry(ctx, HeapObjPtr{b->debug.source});
    SetInternalReference(entry, "debug.source", source_entry);
  }
  return;
}

void QjsHeapExplorer::ExtractValueArrayReference(LEPUSContext* ctx,
                                                 HeapEntry* entry,
                                                 const LEPUSValue* values,
                                                 size_t size) {
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
    auto* class_proto_entry =
        GetEntry(ctx, HeapObjPtr{ctx->class_proto,
                                 sizeof(LEPUSValue) * (ctx->rt->class_count)});
    ctx_entry->SetNamedReference(HeapGraphEdge::kInternal, "array_shape",
                                 class_proto_entry);
    ExtractValueArrayReference(ctx, class_proto_entry, ctx->class_proto,
                               ctx->rt->class_count);
  }
  {
    if (auto* array_shape = ctx->array_shape) {
      auto* arr_shape_entry = GetEntry(ctx, HeapObjPtr{array_shape});
      SetInternalReference(ctx_entry, "array_shape", arr_shape_entry);
      ExtractShapeReference(ctx, arr_shape_entry, array_shape);
    }
  }
  {
    // lynx_target_sdk_version
    if (ctx->lynx_target_sdk_version) {
      auto* version_entry =
          GetEntry(ctx, HeapObjPtr{ctx->lynx_target_sdk_version});
      ctx_entry->SetNamedReference(HeapGraphEdge::kInternal,
                                   "lynx_target_sdk_version", version_entry);
    }
  }
  return;
}

void QjsHeapExplorer::ExtractRuntimeReference(LEPUSContext* ctx,
                                              HeapEntry* entry,
                                              LEPUSRuntime* rt) {
  if (HasBeExtracted(rt)) return;
  InsertExtractedObj(rt);
  if (rt->rt_info) {
    auto* info_entry = GetEntry(ctx, HeapObjPtr{rt->rt_info});
    SetInternalReference(entry, "rt_info", info_entry);
  }
  if (rt->atom_array) {
    auto* atom_array_entry =
        GetEntry(ctx, HeapObjPtr{rt->atom_array, (size_t)rt->atom_size});
    SetInternalReference(entry, "atom_array", atom_array_entry);
    for (size_t i = 1; i < rt->atom_size; ++i) {
      auto* p = rt->atom_array[i];
      if (!atom_is_free(p)) {
        auto* atom_entry = GetEntry(ctx, HeapObjPtr{p});
        SetElementReference(atom_array_entry, i, atom_entry);
      }
    }
  }
  {
    auto* except_entry = GetEntry(ctx, rt->current_exception);
    if (except_entry) {
      SetInternalReference(entry, "current_exception", except_entry);
    }
  }

  if (rt->shape_hash) {
    auto* shape_hash_entry =
        GetEntry(ctx, HeapObjPtr{rt->shape_hash, (size_t)rt->shape_hash_size});
    SetInternalReference(entry, "shape_hash", shape_hash_entry);
    for (size_t i = 0; i < rt->shape_hash_size; ++i) {
      if (rt->shape_hash[i]) {
        auto* sh_entry = GetEntry(ctx, HeapObjPtr{rt->shape_hash[i]});
        SetElementReference(shape_hash_entry, i, sh_entry);
        ExtractShapeReference(ctx, sh_entry, rt->shape_hash[i]);
      }
    }
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
        if (value_buffer.arr != value_buffer.def) {
          auto* buffer_entry =
              GetEntry(ctx, HeapObjPtr{value_buffer.arr,
                                       sizeof(LEPUSValue) * value_buffer.size});
          entry->SetNamedAutoIndexReference(HeapGraphEdge::kInternal,
                                            buffer_entry);
          entry = buffer_entry;
        }
        for (size_t i = 0; i < value_buffer.len; ++i) {
          auto* value_entry = GetEntry(ctx, value_buffer.arr[i]);
          SetElementReference(entry, i, value_entry);
          ExtractValueReference(ctx, value_entry, value_buffer.arr[i]);
        }
      } break;
      case HANDLE_TYPE_CSTRING: {
        const auto* str = *reinterpret_cast<const char**>(heap_obj.ptr);
        auto* str_entry = GetEntry(ctx, HeapObjPtr{str});
        entry->SetNamedAutoIndexReference(HeapGraphEdge::kInternal, str_entry);
      } break;
      case HANDLE_TYPE_UNDEFINED:
      default:
        break;
    }
  }
  return;
}

void QjsHeapExplorer::ExtractGcRootGlobalHandleReference() { return; }

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
    context_->rt->gc->SetForbidGC();
  }
#endif
  SetRootToGcRootReference();
  SetRootToGlobalReference();
  SetUserGlobalReference();
  for (size_t i = 0; i < static_cast<size_t>(Root::kNumberOfRoots); ++i) {
    SetGcRootReference(static_cast<Root>(i));
  }

  ExtractGcRootContextReference();
  ExtractGcRootStackReference();
  ExtractGcRootHandleReference();
  ExtractGcRootRuntimeReference();
#ifdef ENABLE_COMPATIBLE_MM
  if (context_->gc_enable) {
    context_->rt->gc->ResetForbidGC();
  }
#endif
  return;
}
}  // namespace heapprofiler
}  // namespace quickjs
