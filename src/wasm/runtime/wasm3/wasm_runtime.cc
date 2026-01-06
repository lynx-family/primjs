// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/wasm3/wasm_runtime.h"

#include <cmath>
#include <memory>

#include "common/wasm_type.h"
#include "common/wasm_utils.h"
#include "quickjs/include/primjs_monitor.h"
#include "runtime/wasm3/wasm_function.h"
#include "runtime/wasm3/wasm_global.h"
#include "runtime/wasm3/wasm_memory.h"
#include "runtime/wasm3/wasm_module.h"
#include "runtime/wasm3/wasm_table.h"
#include "wasm3/m3_api_libc.h"

namespace primjs {
namespace wasm {

static constexpr const int WASM_STACK_SIZE = 8192 * 32;

Wasm3Runtime::Wasm3Runtime() : m3_env_(nullptr), m3_runtime_(nullptr) {
  WLOGD("Running Wasm3Runtime::%s...", __func__);
  // Init Wasm Runtime here
  InitRuntime();
  // Maybe Init Wasm failed, Abort in Debug mode
  WASM_DCHECK(m3_env_ && m3_runtime_);
}

Wasm3Runtime::~Wasm3Runtime() {
  WLOGD("Running Wasm3Runtime::%s...", __func__);
  m3_FreeRuntime(m3_runtime_);
  m3_FreeEnvironment(m3_env_);
}

void Wasm3Runtime::ParseWasmModule(IM3Module* module, const uint8_t* const data,
                                   size_t len, M3Result& result) {
  result = m3_ParseModule(m3_env_, module, data, len);
}

void Wasm3Runtime::WasmFunctionFinalizer(void* env) {
  WLOGD("Running Wasm3Runtime::%s...", __func__);
  auto pack = static_cast<Wasm3Function*>(env);
  delete pack;
}

std::string Wasm3Runtime::CreateSignature(IM3Function target) {
  u32 argc = m3_GetArgCount(target);
  u32 retc = m3_GetRetCount(target);
  std::string res;
  for (u32 i = 0; i < retc; ++i)
    res.push_back(ConvertTypeIdToTypeChar(m3_GetRetType(target, i)));

  res.push_back('(');
  for (u32 i = 0; i < argc; ++i)
    res.push_back(ConvertTypeIdToTypeChar(m3_GetArgType(target, i)));

  res.push_back(')');

  return res;
}

char Wasm3Runtime::ConvertTypeIdToTypeChar(M3ValueType ty) {
  switch (ty) {
    case c_m3Type_none:
      return 'v';
    case c_m3Type_i32:
      return 'i';
    case c_m3Type_i64:
      return 'I';
    case c_m3Type_f32:
      return 'f';
    case c_m3Type_f64:
      return 'F';
    // This branch is actually unreachable.
    default:
      return 0;
  }
}

int Wasm3Runtime::InitRuntime() {
  MonitorEvent(MODULE_WASM, DEFAULT_BIZ_NAME, "Wasm3Runtime", "true");
  m3_env_ = m3_NewEnvironment();
  if (!m3_env_) {
    WLOGE("Wasm3Runtime m3_NewEnvironment failed");
    return 1;
  }
  m3_runtime_ = m3_NewRuntime(m3_env_, WASM_STACK_SIZE, NULL);
  if (!m3_runtime_) {
    WLOGE("Wasm3Runtime m3_NewRuntime failed");
    return 1;
  }
  m3_runtime_->memoryLimit = 0;
  return 0;
}

}  // namespace wasm
}  // namespace primjs
