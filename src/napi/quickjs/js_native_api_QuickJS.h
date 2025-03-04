/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#ifndef SRC_NAPI_QUICKJS_JS_NATIVE_API_QUICKJS_H_
#define SRC_NAPI_QUICKJS_JS_NATIVE_API_QUICKJS_H_

#include <cassert>
#include <functional>
#include <list>
#include <memory>
#include <set>
#include <string>
#include <unordered_map>
#include <vector>

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif  // __cplusplus

#define NAPI_COMPILE_UNIT qjs

#include "gc/persistent-handle.h"
#include "gc/trace-gc.h"
#include "js_native_api.h"
#include "js_native_api_types.h"
#include "napi_state.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

inline napi_value ToNapi(LEPUSValueConst* v) {
  return reinterpret_cast<napi_value>(v);
}

inline LEPUSValueConst ToJSValue(napi_value v) {
  return *reinterpret_cast<LEPUSValueConst*>(v);
}

inline LEPUSValue JS_DupValue_Comp(LEPUSContext* ctx, LEPUSValueConst v) {
  if (!LEPUS_IsGCMode(ctx)) {
    return LEPUS_DupValue(ctx, v);
  }
  return v;
}

inline void JS_FreeValue_Comp(LEPUSContext* ctx, LEPUSValue v) {
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, v);
  }
}

inline void JS_FreeAtom_Comp(LEPUSContext* ctx, JSAtom v) {
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeAtom(ctx, v);
  }
}

inline void JS_FreeCString_Comp(LEPUSContext* ctx, const char* ptr) {
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeCString(ctx, ptr);
  }
}

inline void js_free_comp(LEPUSContext* ctx, void* ptr) {
  if (!LEPUS_IsGCMode(ctx)) {
    lepus_free(ctx, ptr);
  }
}

namespace qjsimpl {

class NAPIPersistent;
class NativeInfo;

struct WeakInfo {
  std::list<NAPIPersistent*>::const_iterator weak_iter;
  std::function<void(void*)> cb;
  void* cb_arg;
};

class NAPIPersistent : public PersistentBase {
 public:
  /**
   * A Persistent with no storage cell.
   */
  inline NAPIPersistent()
      : PersistentBase(nullptr),
        _env(nullptr),
        _empty(true),
        _native_info(nullptr),
        _ctx(nullptr) {}
  /**
   * Construct a NAPIPersistent from a Local.
   * When the Local is non-empty, a new storage cell is created
   * pointing to the same object, and no flags are set.
   */
  inline NAPIPersistent(napi_env env, LEPUSValueConst value,
                        NativeInfo* native_info, LEPUSContext* ctx,
                        bool is_weak = false);

  inline NAPIPersistent(napi_env env, JSAtom atom, NativeInfo* native_info,
                        LEPUSContext* ctx, bool is_weak = false);

  NAPIPersistent(const NAPIPersistent& that) = delete;
  NAPIPersistent& operator=(const NAPIPersistent& that) = delete;

  void Reset(bool for_gc = false);

  void Reset(napi_env env, LEPUSValueConst value, NativeInfo* native_info,
             LEPUSContext* ctx, bool for_gc = false);

  void Reset(napi_env env, LEPUSContext* ctx, JSAtom atom);

  void SetWeak(void* data, void (*cb)(void*));

  void ClearWeak();

  inline ~NAPIPersistent() { Reset(); }

  LEPUSValue Value() const;

  bool IsEmpty() {
    if (_ctx != nullptr && LEPUS_IsGCMode(_ctx)) {
      return val_ == nullptr;
    } else {
      return _empty;
    }
  }

  static void OnFinalize(NAPIPersistent* ref);

 private:
  inline LEPUSValue* operator*() const { return this->val_; }

  void ResetWeakInfo();

  NativeInfo* _get_native_info();

  napi_env _env;
  bool _empty;
  LEPUSValue _value;
  NativeInfo* _native_info;
  std::unique_ptr<WeakInfo> _weak_info;
  LEPUSContext* _ctx;
};

class Atom {
 public:
  Atom() : _env(nullptr), _ctx(nullptr), _atom(0) {}
  Atom(napi_env env, LEPUSContext* ctx, LEPUSValueConst value)
      : _env(env), _ctx(ctx), _atom(LEPUS_ValueToAtom(ctx, value)) {
    _atom_persist.Reset(_env, _ctx, _atom);
  }
  Atom(napi_env env, LEPUSContext* ctx, JSAtom atom)
      : _env(env), _ctx(ctx), _atom(atom) {
    _atom_persist.Reset(_env, _ctx, _atom);
  }
  Atom(napi_env env, LEPUSContext* ctx, const char* str,
       size_t length = NAPI_AUTO_LENGTH)
      : _env(env),
        _ctx(ctx),
        _atom(length == NAPI_AUTO_LENGTH ? LEPUS_NewAtom(ctx, str)
                                         : LEPUS_NewAtomLen(ctx, str, length)) {
    _atom_persist.Reset(_env, _ctx, _atom);
  }

  Atom(Atom& other)
      : _env(other._env),
        _ctx(other._ctx),
        _atom(LEPUS_DupAtom(_ctx, other._atom)) {
    _atom_persist.Reset(_env, _ctx, _atom);
  }

  Atom(Atom&& other) : _env(other._env), _ctx(other._ctx), _atom(other._atom) {
    other._env = nullptr;
    other._ctx = nullptr;
    other._atom = 0;
    other._atom_persist.Reset(true);
    _atom_persist.Reset(_env, _ctx, _atom);
  }

  ~Atom() {
    if (_atom) {
      JS_FreeAtom_Comp(_ctx, _atom);
    }
    _atom_persist.Reset(true);
  }

  bool IsValid() { return _atom > 0; }

  operator JSAtom() const { return _atom; }

 private:
  napi_env _env;
  LEPUSContext* _ctx;
  JSAtom _atom;
  NAPIPersistent _atom_persist;
};

class Value {
 public:
  Value() : _ctx(nullptr), _val(), pVal(), is_gc(false) {}
  Value(LEPUSContext* ctx, LEPUSValue val) : _ctx(ctx), _val(val), pVal() {
    if (ctx) {
      is_gc = LEPUS_IsGCMode(ctx);
    }
    if (is_gc) {
      pVal.Reset(nullptr, val, nullptr, ctx, true);
    }
  }

  ~Value() {
    if (is_gc) {
      pVal.Reset(true);
    } else if (_ctx) {
      JS_FreeValue_Comp(_ctx, _val);
    }
  }

  operator LEPUSValueConst() {
    if (is_gc) {
      return pVal.Value();
    } else {
      return _val;
    }
  }

  LEPUSValue dup() {
    if (is_gc) {
      return pVal.Value();
    } else {
      return JS_DupValue_Comp(_ctx, _val);
    }
  }

  LEPUSValue move() {
    if (!is_gc) {
      _ctx = nullptr;
      return _val;
    } else {
      return pVal.Value();
    }
  }

 private:
  LEPUSContext* _ctx;
  LEPUSValue _val;
  NAPIPersistent pVal;
  bool is_gc;
};

class RefTracker {
 public:
  RefTracker() {}
  virtual ~RefTracker() {}
  virtual void Finalize(bool isEnvTeardown) {}

  typedef RefTracker RefList;

  inline void Link(RefList* list) {
    prev_ = list;
    next_ = list->next_;
    if (next_ != nullptr) {
      next_->prev_ = this;
    }
    list->next_ = this;
  }

  inline void Unlink() {
    if (prev_ != nullptr) {
      prev_->next_ = next_;
    }
    if (next_ != nullptr) {
      next_->prev_ = prev_;
    }
    prev_ = nullptr;
    next_ = nullptr;
  }

  static void FinalizeAll(RefList* list) {
    while (list->next_ != nullptr) {
      list->next_->Finalize(true);
    }
  }

 private:
  RefList* next_ = nullptr;
  RefList* prev_ = nullptr;
};

class Reference;

}  // namespace qjsimpl

inline void reset_napi_env(napi_env env, NAPIHandleScope* scope);

struct napi_context__qjs {
  napi_env env;
  LEPUSRuntime* rt{};
  LEPUSContext* ctx{};

  LEPUSValue V_NULL{LEPUS_NULL};
  LEPUSValue V_UNDEFINED{LEPUS_UNDEFINED};

  napi_context__qjs(napi_env env, LEPUSContext* ctx)
      : env(env),
        rt{LEPUS_GetRuntime(ctx)},
        ctx{ctx},
        PROP_NAME(env, ctx, "name"),
        PROP_LENGTH(env, ctx, "length"),
        PROP_PROTOTYPE(env, ctx, "prototype"),
        PROP_CONSTRUCTOR(env, ctx, "constructor"),
        PROP_FINALIZER(env, ctx, "@#fin@#"),
        PROP_MESSAGE(env, ctx, "message"),
        PROP_CODE(env, ctx, "code"),
        PROP_BUFFER(env, ctx, "buffer"),
        PROP_BYTELENGTH(env, ctx, "byteLength"),
        PROP_BYTEOFFSET(env, ctx, "byteOffset"),
        PROP_CTOR_MAGIC(env, ctx, "@#ctor@#"),
        gc_enable(LEPUS_IsGCModeRT(rt)) {
    env->ctx = this;
    handle_scope = new NAPIHandleScope(env, ctx, reset_napi_env);
    // TODO primjs doesn't expose DupContext
  }

  ~napi_context__qjs() {
    qjsimpl::RefTracker::FinalizeAll(&finalizing_reflist);
    qjsimpl::RefTracker::FinalizeAll(&reflist);

    // root handle scope may be used during FinalizeAll
    // must delete at last
    delete handle_scope;
  }

  inline void Ref() { refs++; }
  inline void Unref() {
    if (--refs == 0) delete this;
  }

  template <typename T, typename U = std::function<void(napi_env, LEPUSValue)>>
  inline void CallIntoModule(T&& call, U&& handle_exception) {
    int open_handle_scopes_before = open_handle_scopes;
    (void)open_handle_scopes_before;
    napi_clear_last_error(this->env);
    call(this->env);
    assert(open_handle_scopes == open_handle_scopes_before);
    if (last_exception) {
      handle_exception(this->env, *last_exception);
      last_exception.reset();
      last_exception_pVal.Reset(true);
    }
  }

  void CallFinalizer(napi_finalize cb, void* data, void* hint) {
    cb(this->env, data, hint);
  }

  qjsimpl::RefTracker::RefList reflist;
  qjsimpl::RefTracker::RefList finalizing_reflist;

  std::unique_ptr<LEPUSValue> last_exception;
  qjsimpl::NAPIPersistent last_exception_pVal;

  std::unordered_map<uint64_t, void*> instance_data_registry;

  int open_handle_scopes = 0;

  const qjsimpl::Atom PROP_NAME;
  const qjsimpl::Atom PROP_LENGTH;
  const qjsimpl::Atom PROP_PROTOTYPE;
  const qjsimpl::Atom PROP_CONSTRUCTOR;
  const qjsimpl::Atom PROP_FINALIZER;
  const qjsimpl::Atom PROP_MESSAGE;
  const qjsimpl::Atom PROP_CODE;
  const qjsimpl::Atom PROP_BUFFER;
  const qjsimpl::Atom PROP_BYTELENGTH;
  const qjsimpl::Atom PROP_BYTEOFFSET;
  const qjsimpl::Atom PROP_CTOR_MAGIC;

  napi_value CreateHandle(LEPUSValue v, bool only_gc = false) {
    if (LEPUS_IsGCMode(ctx)) {
      return static_cast<NAPIHandleScope*>(GetNapiScope(ctx))->CreateHandle(v);
    } else if (!only_gc) {
      return handle_scope->CreateHandle(v);
    }
    return {};
  }

  void set_handle_scope(NAPIHandleScope* scope) { handle_scope = scope; }

 private:
  int refs = 1;
  NAPIHandleScope* handle_scope{};
  bool gc_enable;

  friend class NAPIHandleScope;
};

inline void reset_napi_env(napi_env env, NAPIHandleScope* scope) {
  env->ctx->set_handle_scope(scope);
}

struct napi_class__qjs {
  napi_class__qjs(LEPUSContext* ctx, LEPUSValue proto, LEPUSValue constructor)
      : ctx(ctx), proto(proto), constructor(constructor) {
    if (LEPUS_IsGCMode(ctx)) {
      proto_persist.Reset(nullptr, proto, nullptr, ctx, true);
      constructor_persist.Reset(nullptr, constructor, nullptr, ctx, true);
    }
  }

  ~napi_class__qjs() {
    if (LEPUS_IsGCMode(ctx)) {
      proto_persist.Reset(true);
      constructor_persist.Reset(true);
    } else {
      LEPUS_FreeValue(ctx, proto);
      LEPUS_FreeValue(ctx, constructor);
    }
  }

  LEPUSValue GetFunction() { return JS_DupValue_Comp(ctx, constructor); }

  LEPUSContext* ctx;

  LEPUSValue proto;
  qjsimpl::NAPIPersistent proto_persist;
  LEPUSValue constructor;
  qjsimpl::NAPIPersistent constructor_persist;
};

#define RETURN_STATUS_IF_FALSE(env, condition, status) \
  do {                                                 \
    if (!(condition)) {                                \
      return napi_set_last_error((env), (status));     \
    }                                                  \
  } while (0)

#define CHECK_ARG(env, arg) \
  RETURN_STATUS_IF_FALSE((env), ((arg) != nullptr), napi_invalid_arg)

#define CHECK_QJS(env, condition)                                        \
  do {                                                                   \
    if (!(condition)) {                                                  \
      return napi_set_exception(env, LEPUS_GetException(env->ctx->ctx)); \
    }                                                                    \
  } while (0)

// This does not call napi_set_last_error because the expression
// is assumed to be a NAPI function call that already did.
#define CHECK_NAPI(expr)                  \
  do {                                    \
    napi_status status = (expr);          \
    if (status != napi_ok) return status; \
  } while (0)

namespace qjsimpl {
// Adapter for napi_finalize callbacks.
class Finalizer {
 public:
  // Some Finalizers are run during shutdown when the napi_env is destroyed,
  // and some need to keep an explicit reference to the napi_env because they
  // are run independently.
  enum EnvReferenceMode { kNoEnvReference, kKeepEnvReference };

 protected:
  Finalizer(napi_env env, napi_finalize finalize_callback, void* finalize_data,
            void* finalize_hint, EnvReferenceMode refmode = kNoEnvReference)
      : _env(env),
        _finalize_callback(finalize_callback),
        _finalize_data(finalize_data),
        _finalize_hint(finalize_hint),
        _has_env_reference(refmode == kKeepEnvReference) {
    if (_has_env_reference) _env->ctx->Ref();
  }

  ~Finalizer() {
    if (_has_env_reference) _env->ctx->Unref();
  }

 public:
  static Finalizer* New(napi_env env, napi_finalize finalize_callback = nullptr,
                        void* finalize_data = nullptr,
                        void* finalize_hint = nullptr,
                        EnvReferenceMode refmode = kNoEnvReference) {
    return new Finalizer(env, finalize_callback, finalize_data, finalize_hint,
                         refmode);
  }

  static void Delete(Finalizer* finalizer) { delete finalizer; }

 protected:
  napi_env _env;
  napi_finalize _finalize_callback;
  void* _finalize_data;
  void* _finalize_hint;
  bool _finalize_ran = false;
  bool _has_env_reference = false;
};
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif
}  // namespace qjsimpl

#endif  // SRC_NAPI_QUICKJS_JS_NATIVE_API_QUICKJS_H_
