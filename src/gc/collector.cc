// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "gc/collector.h"

#include "gc/sweeper.h"
#include "gc/trace-gc.h"
#ifdef ENABLE_GC_DEBUG_TOOLS
#define DCHECK(condition) \
  if (!(condition)) abort();
#else
#define DCHECK(condition) ((void)0)
#endif

#ifdef ENABLE_COMPATIBLE_MM
GarbageCollector::GarbageCollector(LEPUSRuntime *rt, mstate m) noexcept
    : rt_(rt), forbid_gc_(0), max_limit(0) {
  finalizer = new Finalizer(rt);
  sweeper = new Sweeper(m);
  visitor = nullptr;
#ifdef ENABLE_GC_DEBUG_TOOLS
  mem_order_cnt = 0;
  delete_order_cnt = 0;
#endif
#ifdef ENABLE_TRACING_GC_LOG
  gc_begin_time = get_daytime();
  last_gc_time = gc_begin_time;
#endif
  total_duration = 0;
  info_size = 0;
  js_ref_count = 0;
}

GarbageCollector::~GarbageCollector() {
  if (visitor) {
    delete visitor;
  }
  delete finalizer;
  delete sweeper;
}

void GarbageCollector::Init(LEPUSRuntime *rt) { visitor = new Visitor(rt); }

void Finalizer::DoFinalizer(void *ptr) noexcept {
  int tag = get_alloc_tag(ptr);
  switch (tag) {
    case ALLOC_TAG_LEPUSObject:
      JSObjectFinalizer(ptr);
      break;
#ifdef ENABLE_LEPUSNG
    case ALLOC_TAG_LEPUSLepusRef:
      JSLepusRefFinalizer(ptr);
      break;
#endif
#ifdef CONFIG_BIGNUM
    case ALLOC_TAG_JSBigFloat:
      JSBigFloatFinalizer(ptr);
      break;
#endif
    case ALLOC_TAG_JSString:
      JSStringFinalizer(ptr);
      break;
    case ALLOC_TAG_JSSeparableString:
      JSSeparableStringFinalizer(ptr);
      break;
    case ALLOC_TAG_JSSymbol:
      JSSymbolFinalizer(ptr);
      break;
    case ALLOC_TAG_JSShape:
      JSShapeFinalizer(ptr);
      break;
    case ALLOC_TAG_JSVarRef:
      JSVarRefFinalizer(ptr);
      break;
    case ALLOC_TAG_LEPUSFunctionBytecode:
      JSFunctionBytecodeFinalizer(ptr);
      break;
    case ALLOC_TAG_JSArrayBuffer:
      JSArrayBufferFinalizer(ptr);
      break;
    case ALLOC_TAG_JSTypedArray:
      JSTypedArrayFinalizer(ptr);
      break;
    case ALLOC_TAG_JSMapState:
      JSMapStateFinalizer(ptr);
      break;
    case ALLOC_TAG_JSMapIteratorData:
      JSMapIteratorDataFinalizer(ptr);
      break;
    case ALLOC_TAG_JSGeneratorData:
      JSGeneratorDataFinalizer(ptr);
      break;
    case ALLOC_TAG_JSAsyncFunctionData:
      JSAsyncFunctionDataFinalizer(ptr);
      break;
    case ALLOC_TAG_LEPUSModuleDef:
      JSModuleDefFinalizer(ptr);
      break;
    case ALLOC_TAG_JSFunctionDef:
      JSFunctionDefFinalizer(ptr);
      break;
    case ALLOC_TAG_FinalizationRegistryData:
      FinalizationRegistryDataFinalizer(ptr);
      break;
    case ALLOC_TAG_WeakRefData:
      WeakRefDataFinalizer(ptr);
      break;
    default:
      break;
  }
}

void Finalizer::DoFinalizer2(void *ptr) noexcept {
  int tag = get_alloc_tag(ptr);
  switch (tag) {
    case ALLOC_TAG_LEPUSObject:
      if (JS_OBJECT_IS_OUTER(static_cast<LEPUSObject *>(ptr))) {
        JSObjectOnlyFinalizer(ptr);
      }
      break;
    case ALLOC_TAG_JSArrayBuffer:
      JSArrayBufferFinalizer(ptr);
      break;
#ifdef ENABLE_LEPUSNG
    case ALLOC_TAG_LEPUSLepusRef:
      JSLepusRefFinalizer(ptr);
      break;
    case ALLOC_TAG_JSString:
      if (!(static_cast<JSString *>(ptr)->atom_type)) {
        JSStringOnlyFinalizer(ptr);
      }
      break;
#endif
    case ALLOC_TAG_LEPUSFunctionBytecode:
      JSFunctionBytecodeFinalizer(ptr);
      break;
    case ALLOC_TAG_JSFunctionDef:
      JSFunctionDefFinalizer(ptr);
      break;
    default:
      break;
  }
}

void Visitor::VisitLEPUSLepusRef(void *ptr, int local_idx) noexcept {
  LEPUSLepusRef *pref = reinterpret_cast<LEPUSLepusRef *>(ptr);
  PushObjLEPUSValue(pref->lepus_val, local_idx);
}

void Visitor::VisitJSVarRef(void *ptr, int local_idx) noexcept {
  /*
  free_var_ref
  */
  JSVarRef *var_ref = static_cast<JSVarRef *>(ptr);
  if (var_ref->is_detached) {
    PushObjLEPUSValue(var_ref->value, local_idx);
  }
}

void Visitor::VisitRootLEPUSValue(LEPUSValue *val, int local_idx) noexcept {
  DCHECK(val != nullptr);
  LEPUSValue value = *val;
  if (LEPUS_IsUndefined(value) || LEPUS_IsNull(value)) return;
  VisitRootLEPUSValue(value, local_idx);
}

void Visitor::VisitRootJSToken(JSToken *token, int local_idx) noexcept {
  DCHECK(token != nullptr);
  switch (token->val) {
#ifdef CONFIG_BIGNUM
    case TOK_NUMBER:
      VisitRootLEPUSValue(&token->u.num.val, local_idx);
      break;
#endif
    case TOK_STRING:
    case TOK_TEMPLATE:
      VisitRootLEPUSValue(token->u.str.str, local_idx);
      break;
    case TOK_REGEXP:
      VisitRootLEPUSValue(token->u.regexp.body, local_idx);
      VisitRootLEPUSValue(token->u.regexp.flags, local_idx);
      break;
    case TOK_IDENT:
    case TOK_FIRST_KEYWORD ... TOK_LAST_KEYWORD:
    case TOK_PRIVATE_NAME:
      VisitJSAtom(token->u.ident.atom, local_idx);
      break;
    default:
      break;
  }
}

void Visitor::VisitRootCString(char *cstr, int local_idx) noexcept {
  if (!cstr) return;
  /* purposely removing constness */
  JSString *p = reinterpret_cast<JSString *>(
      reinterpret_cast<void *>(cstr - offsetof(JSString, u)));
  VisitRootHeapObj(p, local_idx);
}

void Visitor::PushObjLEPUSValue(LEPUSValue *val, int local_idx) noexcept {
  PushObjLEPUSValue(*val, local_idx);
}

void Visitor::VisitEntry(void *ptr, int local_idx) noexcept {
  int alloc_tag = get_alloc_tag(ptr);
  switch (alloc_tag) {
    case 0:  // default
      break;
    case ALLOC_TAG_WITHOUT_PTR:
    case ALLOC_TAG_WeakRefData:
#ifdef CONFIG_BIGNUM
    case ALLOC_TAG_JSBigFloat:
#endif
      break;
    // LEPUSValue with tag
    case ALLOC_TAG_LEPUSLepusRef:
      VisitLEPUSLepusRef(ptr, local_idx);  // visit_nothing
      break;
    case ALLOC_TAG_JSString:
    case ALLOC_TAG_JSSymbol:
      break;
    case ALLOC_TAG_JSSeparableString: {
      VisitSeparableString(ptr, local_idx);
    } break;
    case ALLOC_TAG_JSShape:
      VisitJShape(ptr, local_idx);
      break;
    case ALLOC_TAG_JSVarRef:
      VisitJSVarRef(ptr, local_idx);
      break;
    case ALLOC_TAG_LEPUSFunctionBytecode:
      VisitJSFunctionBytecode(ptr, local_idx);
      break;
    case ALLOC_TAG_LEPUSObject:
      VisitJSObject(ptr, local_idx);
      break;
    // LEPUSObject with class_id
    case ALLOC_TAG_JSBoundFunction:
      VisitJSBoundFunction(ptr, local_idx);
      break;
    case ALLOC_TAG_JSCFunctionDataRecord:
      VisitJSCFunctionDataRecord(ptr, local_idx);
      break;
    case ALLOC_TAG_JSForInIterator:
      VisitJSForInIterator(ptr, local_idx);
      break;
    case ALLOC_TAG_JSArrayBuffer:
      VisitJSArrayBuffer(ptr, local_idx);
      break;
    case ALLOC_TAG_JSTypedArray:
      VisitJSTypedArray(ptr, local_idx);
      break;
    case ALLOC_TAG_JSMapState:
      VisitJSMapState(ptr, local_idx);
      break;
    case ALLOC_TAG_JSMapIteratorData:
      VisitJSMapIteratorData(ptr, local_idx);
      break;
    case ALLOC_TAG_JSArrayIteratorData:
      VisitJSArrayIteratorData(ptr, local_idx);
      break;
    case ALLOC_TAG_JSRegExpStringIteratorData:
      VisitJSRegExpStringIteratorData(ptr, local_idx);
      break;
    case ALLOC_TAG_JSGeneratorData:
      VisitJSGeneratorData(ptr, local_idx);
      break;
    case ALLOC_TAG_JSProxyData:
      VisitJSProxyData(ptr, local_idx);
      break;
    case ALLOC_TAG_JSPromiseData:
      VisitJSPromiseData(ptr, local_idx);
      break;
    case ALLOC_TAG_JSPromiseReactionData:
      VisitJSPromiseReactionData(ptr, local_idx);
      break;
    case ALLOC_TAG_JSPromiseFunctionData:
      VisitJSPromiseFunctionData(ptr, local_idx);
      break;
    case ALLOC_TAG_JSAsyncFunctionData:
      VisitJSAsyncFunctionData(ptr, local_idx);
      break;
    case ALLOC_TAG_JSAsyncFromSyncIteratorData:
      VisitJSAsyncFromSyncIteratorData(ptr, local_idx);
      break;
    case ALLOC_TAG_JSAsyncGeneratorData:
      VisitJSAsyncGeneratorData(ptr, local_idx);
      break;
      // for scan context
#ifdef ENABLE_QUICKJS_DEBUGGER
    case ALLOC_TAG_LEPUSScriptSource:
      VisitJSScriptSource(ptr, local_idx);
      break;
#endif
    // other
    case ALLOC_TAG_LEPUSPropertyEnum:
      VisitJSPropertyEnum(ptr, local_idx);
      break;
    case ALLOC_TAG_LEPUSModuleDef:
      VisitJSModuleDef(ptr, local_idx);
      break;
    case ALLOC_TAG_JSFunctionDef:
      VisitJSFunctionDef(ptr, local_idx);
      break;
    case ALLOC_TAG_JSValueArray:
      VisitJSValueArray(ptr, local_idx);
      break;
    case ALLOC_TAG_ValueSlot:
      VisitValueSlot(ptr, local_idx);
      break;
    case ALLOC_TAG_JsonStrArray:
      VisitJsonStrArray(ptr, local_idx);
      break;
    case ALLOC_TAG_LEPUSDebuggerInfo:
      VisitDebuggerInfo(ptr, local_idx);
      break;
    case ALLOC_TAG_FinalizationRegistryData:
      VisitFinalizationRegistryData(ptr, local_idx);
      break;
    default:
      break;
  }
}

void Finalizer::JSSymbolFinalizer(void *ptr) noexcept {
  JSAtomStruct *p = static_cast<JSAtomStruct *>(ptr);
  free_atom(rt_, p);
}
void Finalizer::JSVarRefFinalizer(void *ptr) noexcept {
  JSVarRef *var_ref = static_cast<JSVarRef *>(ptr);
  if (!var_ref->is_detached) {
    list_del(&var_ref->link);
  }
  return;
}

void Finalizer::JSFunctionBytecodeFinalizer(void *ptr) noexcept {
  LEPUSFunctionBytecode *b = static_cast<LEPUSFunctionBytecode *>(ptr);
#ifdef ENABLE_QUICKJS_DEBUGGER
  if (b->func_level_state != NO_DEBUGGER && b->link.next && b->link.prev) {
    list_del(&b->link);
  }
#endif
  if (b->has_debug) {
#ifdef ENABLE_QUICKJS_DEBUGGER
    if (b->func_level_state != DEBUGGER_TOP_LEVEL_FUNCTION) {
      system_free(b->debug.source);
    }
#else
    system_free(b->debug.source);
#endif
  }
}

void Visitor::VisitSeparableString(void *ptr, int local_idx) noexcept {
  auto *separable_string = reinterpret_cast<JSSeparableString *>(ptr);
  if (!LEPUS_IsUndefined(separable_string->flat_content)) {
    PushObjLEPUSValue(separable_string->flat_content, local_idx);
    return;
  }
  PushObjLEPUSValue(separable_string->left_op, local_idx);
  PushObjLEPUSValue(separable_string->right_op, local_idx);
}

void Visitor::VisitDebuggerInfo(void *ptr, int32_t local_idx) noexcept {
#ifdef ENABLE_QUICKJS_DEBUGGER
  auto *info = reinterpret_cast<LEPUSDebuggerInfo *>(ptr);
  if (!info) return;
  PushObjLEPUSValue(info->debugger_name, local_idx);
  struct list_head *el;
  list_for_each(el, &info->script_list) {
    LEPUSScriptSource *script = list_entry(el, LEPUSScriptSource, link);
    VisitRootHeapObj(script, local_idx);
  }
  PushObjLEPUSValue(info->pause_state.get_properties_array, local_idx);
  PushObjLEPUSValue(info->running_state.get_properties_array, local_idx);
  queue[local_idx]->EnQueue(info->source_code);
  PushObjLEPUSValue(info->console.messages, local_idx);
  queue[local_idx]->EnQueue(info->bps);
  for (uint32_t i = 0; i < info->breakpoints_num; ++i) {
    auto *bp = info->bps + i;
    queue[local_idx]->EnQueue(bp->script_url);
    PushObjLEPUSValue(bp->breakpoint_id, local_idx);
    PushObjLEPUSValue(bp->condition, local_idx);
  }

#define DebuggerVisitStringPool(name, str) \
  PushObjLEPUSValue(info->literal_pool.name, local_idx);
  QJSDebuggerStringPool(DebuggerVisitStringPool)
#undef DebuggerVisitStringPool
  {
    PushObjLEPUSValue(info->debugger_obj.response, local_idx);
    PushObjLEPUSValue(info->debugger_obj.notification, local_idx);
    PushObjLEPUSValue(info->debugger_obj.breakpoint, local_idx);
    PushObjLEPUSValue(info->debugger_obj.bp_location, local_idx);
    PushObjLEPUSValue(info->debugger_obj.result, local_idx);
    PushObjLEPUSValue(info->debugger_obj.preview_prop, local_idx);
  }

  for (auto &[pc, value] : info->break_bytecode_map) {
    PushObjLEPUSValue(value, local_idx);
  }
  VisitRootHeapObj(info->pause_on_next_statement_reason, local_idx);
#endif

  return;
}

#endif  // ENABLE_COMPATIBLE_MM
