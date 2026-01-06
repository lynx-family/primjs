// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_memory.h"

#include <utility>

#include "common/interop_runtime.h"
#include "common/js_type.h"
#include "common/messages.h"
#include "common/wasm_type.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/qjs_ext_api.h"

namespace primjs::qjs {
QJSWasmMemory::QJSWasmMemory(WasmMemoryRef memory, size_t pages,
                             InteropRuntime* interop)
    : pages_(pages), memory_(std::move(memory)) {
  WLOGD("Running QJSWasmMemory::%s...", __func__);
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
}

QJSWasmMemory::~QJSWasmMemory() {
  WLOGD("Running QJSWasmMemory::%s...", __func__);
  if (memory_.is<Wasm3Memory*>()) {
    delete memory_.get<Wasm3Memory*>();
  } else {
    delete memory_.get<PrismMemory*>();
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

void QJSWasmMemory::Finalize(LEPUSRuntime* rt, LEPUSValue obj) {
  WLOGD("Running QJSWasmMemory::%s...", __func__);

  auto memory = static_cast<QJSWasmMemory*>(LEPUS_GetOpaque(obj, class_id()));
  if (memory && !LEPUS_IsGCModeRT(rt)) LEPUS_FreeValueRT(rt, memory->buffer_);
  delete memory;
  LEPUS_SetOpaque(obj, nullptr);
}

LEPUSValue QJSWasmMemory::CreateJSObject(LEPUSContext* ctx,
                                         InteropRuntime* interop,
                                         WasmMemoryRef memory, size_t pages) {
  LEPUSValue obj = LEPUS_NewObjectClass(ctx, class_id());
  if (LEPUS_IsException(obj)) {
    return LEPUS_EXCEPTION;
  }
  auto memory_data = new QJSWasmMemory(memory, pages, interop);
  LEPUS_SetOpaque(obj, memory_data);

  return obj;
}

// static
LEPUSValue QJSWasmMemory::CallAsConstructor(LEPUSContext* ctx,
                                            LEPUSValueConst constructor,
                                            int argc, LEPUSValueConst* argv) {
  constexpr const char* code = "WebAssembly.Memory()";

  WLOGD("Running QJSWasmMemory::%s...", __func__);

  if (argc != 1 || !LEPUS_IsObject(argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "new Memory without MemoryDescriptor!");
  }

  LEPUSValue memory_desc = argv[0];

  // 1. Let initial be descriptor["initial"].
  LEPUSValue initial_value = JSGetPropertyStrFree(ctx, memory_desc, "initial");
  uint32_t init_pages = 0;
  if (LEPUS_IsUndefined(initial_value)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Property initial is required.");
  }

  if (LEPUS_ToUint32(ctx, &init_pages, initial_value) < 0) {
    return ThrowIfException(
        ctx, ErrorTypes::kTypeError, code,
        "Property initial must be convertible to a valid number");
  }

  // 2. If descriptor["maximum"] exists, let maximum be descriptor["maximum"];
  //    otherwise, let maximum be empty.
  uint32_t max_pages = kMaxPagesNum;
  LEPUSValue max_value = JSGetPropertyStrFree(ctx, memory_desc, "maximum");

  if (!LEPUS_IsUndefined(max_value) &&
      LEPUS_ToUint32(ctx, &max_pages, max_value) < 0) {
    return ThrowIfException(
        ctx, ErrorTypes::kTypeError, code,
        "Property maximum must be convertible to a valid number.");
  }

  // 3. If maximum is not empty and maximum < initial, throw a RangeError
  //    exception.
  if (max_pages < init_pages) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            "maximum must not be smaller than initial");
  }

  // 4. Let memtype be { min initial, max maximum }. skip...
  // 5. Let store be the surrounding agent's associated store.
  auto interop =
      static_cast<InteropRuntime*>(JSGetPrivateData(ctx, constructor));

  // 6. Let (store, memaddr) be mem_alloc(store, memtype). If allocation fails,
  //    throw a RangeError exception.
  WasmResult result = WasmSucceed;
  WasmMemoryRef memory =
      interop->CreateWasmMemory(init_pages, max_pages, result);
  if (result) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code, result);
  }

  // 7. Set the surrounding agent's associated store to store. skip...
  // 8. Initialize this from memaddr.
  LEPUSValue mem_obj = CreateJSObject(ctx, interop, memory, init_pages);
  HandleScope func_scope(ctx, &mem_obj, HANDLE_TYPE_LEPUS_VALUE);
  uintptr_t ptr = interop->GetMemoryPtr(memory);
  if (LEPUS_IsException(InitializeMemory(ctx, ptr, mem_obj, memory, interop))) {
    if (!LEPUS_IsGCMode(ctx)) {
      LEPUS_FreeValue(ctx, mem_obj);
    }
    return LEPUS_EXCEPTION;
  }

  LEPUSRefCountHeader* p = (LEPUSRefCountHeader*)LEPUS_VALUE_GET_PTR(mem_obj);

  return mem_obj;
}

// static
LEPUSValue QJSWasmMemory::InitializeMemory(LEPUSContext* ctx, uintptr_t memaddr,
                                           LEPUSValue memory_obj,
                                           WasmMemoryRef& memory,
                                           InteropRuntime* interop_runtime) {
  constexpr const char* code = "WebAssembly.Memory()";

  // 1. Let map be the surrounding agent's associated Memory object cache.
  auto js_env = interop_runtime->js_env<QJSEnv*>();
  auto& mem_cache = js_env->wasm_memory_cache();

  // 2. Assert: map[memaddr] doesn’t exist.
  WASM_DCHECK(mem_cache.count(memaddr) == 0);
  if (mem_cache.count(memaddr)) {
    return ThrowIfException(ctx, ErrorTypes::kError, code,
                            "map[memaddr] doesn't exist.");
  }

  // 3. Let buffer be the result of creating a memory buffer from memaddr.
  size_t pages = 0;
  uint8_t* buffer = interop_runtime->GetMemoryBuffer(memory, pages);
  size_t buffer_size = pages * kWasmPageSize;
  LEPUSValue buffer_obj =
      LEPUS_NewArrayBuffer(ctx, buffer, buffer_size, nullptr, nullptr, FALSE);
  HandleScope func_scope(ctx, &buffer_obj, HANDLE_TYPE_LEPUS_VALUE);

  // 4. Set memory.[[Memory]] to memaddr. skip...
  // 5. Set memory.[[BufferObject]] to buffer.
  auto opaque =
      static_cast<QJSWasmMemory*>(LEPUS_GetOpaque(memory_obj, class_id()));
  opaque->set_buffer(ctx, buffer_obj);

  // 6. Set map[memaddr] to memory.
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_DupValue(ctx, memory_obj);
  }
  mem_cache[memaddr] = memory_obj;

  return LEPUS_UNDEFINED;
}

LEPUSValue QJSWasmMemory::CreatePrototype(LEPUSContext* ctx) {
  LEPUSClassDef def = {.class_name = "WebAssembly.Memory",
                       .finalizer = Finalize,
                       .gc_mark = QJSWasmMemory::GCMark};

  if (JSSafeNewClass(ctx, class_id(), &def) != 0) {
    WLOGE("New Class failed in WebAssembly.Memory.");
    return LEPUS_EXCEPTION;
  }
  // function list should be static to keep alive
  // All methods on an instance are declared here.
  static const LEPUSCFunctionListEntry memory_func_list[] = {
      LEPUS_CFUNC_DEF("grow", 1, GrowCallback),
      LEPUS_CGETSET_DEF("buffer", GetBufferCallback, NULL),
  };

  LEPUSValue prototype = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &prototype, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyFunctionList(ctx, prototype, memory_func_list,
                                countof(memory_func_list));

  LEPUS_SetClassProto(ctx, class_id(), prototype);
  return prototype;
}

LEPUSValue QJSWasmMemory::CreateConstructor(LEPUSContext* ctx,
                                            LEPUSValue wasm_root) {
  LEPUSValue proto = CreatePrototype(ctx);
  HandleScope func_scope(ctx, &proto, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue ctor =
      InitConstructor(ctx, wasm_root, "Memory", CallAsConstructor, 2, proto);
  return ctor;
}

LEPUSValue QJSWasmMemory::GetBufferCallback(LEPUSContext* ctx,
                                            LEPUSValueConst this_val) {
  WLOGD("Running QJSWasmMemory::%s...", __func__);

  auto memory =
      static_cast<QJSWasmMemory*>(LEPUS_GetOpaque(this_val, class_id()));

  // NOTE:
  // When pages_ != memory->memory_->pages(), it backing wasm memory
  // is updated actually, we must provide a new buffer and detach the
  // old one.
  if (memory->memory_.is<Wasm3Memory*>()) {
    auto wasm3_memory = memory->memory_.get<Wasm3Memory*>();
    if (LEPUS_IsUndefined(memory->buffer_) ||
        memory->pages_ != wasm3_memory->pages()) {
      LEPUS_DetachArrayBuffer(ctx, memory->buffer_);
      if (!LEPUS_IsGCMode(ctx)) {
        LEPUS_FreeValue(ctx, memory->buffer_);
      }

      auto buffer = static_cast<uint8_t*>(wasm3_memory->buffer());
      memory->pages_ = wasm3_memory->pages();
      size_t buffer_size = memory->pages_ * kWasmPageSize;
      memory->buffer_ = LEPUS_NewArrayBuffer(ctx, buffer, buffer_size, nullptr,
                                             nullptr, FALSE);
    }
  } else {
    auto prism_memory = memory->memory_.get<PrismMemory*>();
    if (LEPUS_IsUndefined(memory->buffer_) ||
        memory->pages_ != prism_memory->pages()) {
      LEPUS_DetachArrayBuffer(ctx, memory->buffer_);
      if (!LEPUS_IsGCMode(ctx)) {
        LEPUS_FreeValue(ctx, memory->buffer_);
      }

      auto* buffer = static_cast<uint8_t*>(prism_memory->buffer());
      memory->pages_ = prism_memory->pages();
      size_t buffer_size = memory->pages_ * kWasmPageSize;

      memory->buffer_ = LEPUS_NewArrayBuffer(ctx, buffer, buffer_size, nullptr,
                                             nullptr, FALSE);
    }
  }

  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_DupValue(ctx, memory->buffer_);
  }
  return memory->buffer_;
}

LEPUSValue QJSWasmMemory::GrowCallback(LEPUSContext* ctx,
                                       LEPUSValueConst this_val, int argc,
                                       LEPUSValueConst* argv) {
  WLOGD("Running QJSWasmMemory::%s...", __func__);
  constexpr const char* code = "WebAssembly.Memory::grow()";

  auto memory =
      static_cast<QJSWasmMemory*>(LEPUS_GetOpaque(this_val, class_id()));
  if (!memory || argc != 1) {
    WLOGE("Memory %s", ErrorMessages::kNoConvertibleNum_1007);
    return LEPUS_ThrowTypeError(ctx, ErrorMessages::kNoConvertibleNum_1007);
  }

  int grow_pages = 0;
  LEPUSValue num_value = argv[0];
  if (LEPUS_IsNumber(num_value)) {
    LEPUS_ToInt32(ctx, &grow_pages, num_value);
  } else {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1008);
  }

  size_t pages = 0;
  if (memory->memory_.is<Wasm3Memory*>()) {
    auto wasm3_memory = memory->memory_.get<Wasm3Memory*>();
    pages = wasm3_memory->pages();
    if (grow_pages && !wasm3_memory->grow(grow_pages)) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kGrowFailed_1003);
    }
  } else {
    auto prism_memory = memory->memory_.get<PrismMemory*>();
    pages = prism_memory->pages();
    if (grow_pages && !prism_memory->grow(grow_pages)) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kGrowFailed_1004);
    }
  }

  return LEPUS_NewInt32(ctx, pages);
}

// static
void QJSWasmMemory::GCMark(LEPUSRuntime* rt, LEPUSValueConst obj,
                           LEPUS_MarkFunc* mark_func, uint64_t trace_tool) {
  auto opaque = static_cast<QJSWasmMemory*>(LEPUS_GetOpaque(obj, class_id()));
  if (opaque) {
    LEPUS_MarkValue(rt, opaque->buffer_, mark_func, trace_tool);
  }
}

}  // namespace primjs::qjs
