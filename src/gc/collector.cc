// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "gc/collector.h"

#include <algorithm>

#include "gc/trace-gc.h"

#ifdef ENABLE_COMPATIBLE_MM
void Finalizer::DoGlobalFinalizer() noexcept {
  rt_->global_handles_->GlobalRootsFinalizer();
}

void Finalizer::DoFinalizer2(void *ptr) noexcept {
  int tag = get_alloc_tag(ptr);
  switch (tag) {
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
    default:
      break;
  }
}

void Visitor::VisitLEPUSLepusRef(void *ptr, GCWorkStack &workStack) noexcept {
  LEPUSLepusRef *pref = reinterpret_cast<LEPUSLepusRef *>(ptr);
  PushObjLEPUSValue(pref->lepus_val, workStack);
#ifdef ENABLE_LEPUSNG
  auto rt = workStack.GetRuntime();
  if (rt->js_callbacks_.ref_counted_obj_visitor)
    rt->js_callbacks_.ref_counted_obj_visitor(
        rt, pref->p, reinterpret_cast<uint64_t>(&workStack), pref->tag,
        set_mark_func);
#endif
}

void Visitor::VisitJSVarRef(void *ptr, GCWorkStack &workStack) noexcept {
  JSVarRef *var_ref = static_cast<JSVarRef *>(ptr);
  PushObjLEPUSValue(var_ref->value, workStack);
}

void Visitor::VisitJSAsyncVarRef(void *ptr, GCWorkStack &workStack) noexcept {
  JSVarRef *var_ref = static_cast<JSVarRef *>(ptr);
  PushObjLEPUSValue(*var_ref->pvalue, workStack);
}

void Visitor::GetLEPUSTokenPtr(JSToken *token,
                               GCWorkStack &workStack) noexcept {
  DCHECK(token != nullptr);
  void *ret = nullptr;
  switch (token->val) {
    case TOK_NUMBER:
      PushObjLEPUSValue(token->u.num.val, workStack);
      break;
    case TOK_STRING:
    case TOK_TEMPLATE:
      PushObjLEPUSValue(token->u.str.str, workStack);
      break;
    case TOK_REGEXP:
      PushObjLEPUSValue(token->u.regexp.body, workStack);
      PushObjLEPUSValue(token->u.regexp.flags, workStack);
      break;
    case TOK_IDENT:
    case TOK_FIRST_KEYWORD ... TOK_LAST_KEYWORD:
    case TOK_PRIVATE_NAME:
      ret = GetAtomObj(token->u.ident.atom, workStack);
      workStack.push_back((address_t)ret);
      break;
    default:
      break;
  }
}

JSString *Visitor::GetCStringPtr(const char *cstr) noexcept {
  if (!cstr) return nullptr;
  /* purposely removing constness */
  JSString *p = (JSString *)(void *)(cstr - offsetof(JSString, u));
  return p;
}

void Finalizer::JSSymbolFinalizer(void *ptr) noexcept {
  JSAtomStruct *p = static_cast<JSAtomStruct *>(ptr);
  free_atom(rt_, p);
}

void Visitor::PushObjAtom(LEPUSAtom atom, GCWorkStack &workStack) noexcept {
  workStack.push_back((address_t)GetAtomObj(atom, workStack));
}

void Visitor::VisitJSShape(void *ptr, GCWorkStack &workStack) noexcept {
  int hash_size = get_hash_size(ptr);
  JSShape *sh = get_shape_from_alloc(ptr, hash_size);
  workStack.push_back((address_t)(sh->proto));
  JSShapeProperty *pr = get_shape_prop(sh);
  for (int i = 0; i < sh->prop_count; i++) {
    PushObjAtom(pr->atom, workStack);
    pr++;
  }
}

void Visitor::VisitJSFunctionDef(void *ptr, GCWorkStack &workStack) noexcept {
  // lepus_free_function_def
  JSFunctionDef *fd = static_cast<JSFunctionDef *>(ptr);
  auto head = &fd->child_list;
  struct list_head *el = head->prev;
  if (el && (el != head)) {
    JSFunctionDef *fd1 = list_entry(el, JSFunctionDef, link);
    workStack.push_back((address_t)fd1);
  }

  el = fd->link.prev;
  if (el != nullptr) {
    JSFunctionDef *fd1 = list_entry(el, JSFunctionDef, link);
    workStack.push_back((address_t)fd1);
  }

  DynBuf *dbuf;
  if (fd->byte_code.buf) {
    dbuf = &fd->byte_code;
    workStack.push_back((address_t)dbuf->buf);
  }
  workStack.push_back((address_t)fd->caller_slots);

  workStack.push_back((address_t)fd->jump_slots);

  // must load 'label_slots' before scan to keep consistent(may change during
  // con-mark)
  workStack.push_back((address_t)fd->label_slots);

  workStack.push_back((address_t)fd->line_number_slots);

  // must load 'cpool' before scan to keep consistent(may change during
  // con-mark)
  workStack.push_back((address_t)fd->cpool);

  workStack.push_back((address_t)(fd->vars));
  workStack.push_back((address_t)(fd->vars_htab));
  workStack.push_back((address_t)fd->args);

  if (fd->hoisted_def) {
    workStack.push_back((address_t)fd->hoisted_def);
  }

  if (fd->closure_var) {
    workStack.push_back((address_t)fd->closure_var);
  }

  if (fd->scopes != fd->def_scope_array) {
    workStack.push_back((address_t)fd->scopes);
  }

  workStack.push_back((address_t)fd->pc2line.buf);
  workStack.push_back((address_t)fd->source);
  workStack.push_back((address_t)fd->coverage_slots);
}

void Visitor::VisitLEPUSFunctionBytecode(void *ptr,
                                         GCWorkStack &workStack) noexcept {
  LEPUSFunctionBytecode *b = static_cast<LEPUSFunctionBytecode *>(ptr);
  if (b->vardefs && b->vardefs_ext) {
    workStack.push_back((address_t)b->vardefs);
  }
  if (b->cpool) {
    for (int i = 0; i < b->cpool_count; i++) {
      PushObjLEPUSValue(b->cpool[i], workStack);
    }
  }
  // debug
  if (b->has_debug) {
    workStack.push_back((address_t)b->debug.pc2line_buf);
    workStack.push_back((address_t)b->debug.source);
    workStack.push_back((address_t)b->debug.caller_slots);
  }
  workStack.push_back((address_t)b->coverage_info);
  workStack.push_back((address_t)b->coverage_slots);
  workStack.push_back((address_t)b->coverage_counters);
  return;
}

void Visitor::VisitJSSeparableString(void *ptr,
                                     GCWorkStack &workStack) noexcept {
  auto *separable_string = reinterpret_cast<JSSeparableString *>(ptr);
  if (!LEPUS_IsUndefined(separable_string->flat_content)) {
    PushObjLEPUSValue(separable_string->flat_content, workStack);
    return;
  }
  PushObjLEPUSValue(separable_string->left_op, workStack);
  PushObjLEPUSValue(separable_string->right_op, workStack);
}

void Visitor::VisitLEPUSDebuggerInfo(void *ptr,
                                     GCWorkStack &workStack) noexcept {
#ifdef ENABLE_QUICKJS_DEBUGGER
  auto *info = reinterpret_cast<LEPUSDebuggerInfo *>(ptr);
  if (!info) return;
  PushObjLEPUSValue(info->debugger_name, workStack);
  struct list_head *el;
  list_for_each(el, &info->script_list) {
    LEPUSScriptSource *script = list_entry(el, LEPUSScriptSource, link);
    workStack.push_back((address_t)script);
  }
  PushObjLEPUSValue(info->pause_state.get_properties_array, workStack);
  PushObjLEPUSValue(info->running_state.get_properties_array, workStack);
  PushObjLEPUSValue(info->object_group_registry, workStack);
  workStack.push_back((address_t)info->source_code);
  PushObjLEPUSValue(info->console.messages, workStack);
  workStack.push_back((address_t)info->bps);

#define DebuggerVisitStringPool(name, str) \
  PushObjLEPUSValue(info->literal_pool.name, workStack);
  QJSDebuggerStringPool(DebuggerVisitStringPool)
#undef DebuggerVisitStringPool
  {
    PushObjLEPUSValue(info->debugger_obj.response, workStack);
    PushObjLEPUSValue(info->debugger_obj.notification, workStack);
    PushObjLEPUSValue(info->debugger_obj.breakpoint, workStack);
    PushObjLEPUSValue(info->debugger_obj.bp_location, workStack);
    PushObjLEPUSValue(info->debugger_obj.result, workStack);
    PushObjLEPUSValue(info->debugger_obj.preview_prop, workStack);
  }

  for (auto &[pc, value] : info->break_bytecode_map) {
    PushObjLEPUSValue(value, workStack);
  }
  workStack.push_back((address_t)info->pause_on_next_statement_reason);
#endif

  return;
}

void no_inline JSPropertyStore(LEPUSContext *ctx, LEPUSObject *obj,
                               JSPropertyGC *new_prop) {
  JSPropertyGC *prop = obj->gc_prop;
  JSShape *sh = obj->shape;
  int prop_count = sh->prop_count;
  for (int i = 0; i < prop_count; i++) {
    HeapObjStore(ctx, &new_prop[i].u.value, prop[i].u.value);
  }
}
#else
// Stub implementations when ENABLE_COMPATIBLE_MM is not defined
void Visitor::ScanStack(GCWorkStack &workStack) noexcept {}
void Visitor::ScanAsyncStack(GCWorkStack &workStack) noexcept {}
void Visitor::ScanRuntime(GCWorkStack &workStack, bool isFinalRemark,
                          bool markWeak) noexcept {}
void Visitor::ScanShapeArray(GCWorkStack &workStack) noexcept {}
void Visitor::ScanHandles(GCWorkStack &workStack) noexcept {}
void Visitor::ScanContext(GCWorkStack &workStack, bool isFinalRemark) noexcept {
}
void Visitor::DoFinalizer(void *ptr) {}
void Visitor::VisitLEPUSLepusRef(void *ptr, GCWorkStack &workStack) noexcept {}

void Finalizer::DoGlobalFinalizer() noexcept {}
void Finalizer::DoFinalizer2(void *ptr) noexcept {}
void Finalizer::JSObjectFinalizer(void *ptr) noexcept {}
void Finalizer::JSObjectOnlyFinalizer(void *ptr) noexcept {}
void Finalizer::JSShapeArrayFinalizer() noexcept {}
void Finalizer::BytecodeListFinalizer() noexcept {}
void Finalizer::FinalizationRegistryDataFinalizer(void *ptr) noexcept {}
#endif  // ENABLE_COMPATIBLE_MM

void LEPUS_HeapObjStore(LEPUSContext *ctx, void *fieldAddr, void *value) {
  HeapObjStore(ctx, fieldAddr, value);
}
void LEPUS_HeapObjStore(LEPUSContext *ctx, void *fieldAddr, LEPUSValue value) {
  HeapObjStore(ctx, fieldAddr, value);
}
void LEPUS_WriteBarrierNoStore(LEPUSRuntime *rt, void *value) {
  WriteBarrierNoStore(rt, value);
}
void LEPUS_WriteBarrierNoStore(LEPUSContext *ctx, LEPUSValue value) {
  WriteBarrierNoStore(ctx, value);
}
void LEPUS_WriteBarrierNoStore(LEPUSContext *ctx, void *value) {
  WriteBarrierNoStore(ctx, value);
}
void LEPUS_HeapObjStoreNoCtx(void *fieldAddr, void *value) {
  HeapObjStoreNoCtx(fieldAddr, value);
}
void LEPUS_HeapObjStoreNoCtx(void *fieldAddr, LEPUSValue value) {
  HeapObjStoreNoCtx(fieldAddr, value);
}
