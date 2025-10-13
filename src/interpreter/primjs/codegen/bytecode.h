// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_BYTECODE_H
#define PRIMJS_BYTECODE_H

#include <cstdint>
#include <string>

#include "quickjs/include/quickjs-inner.h"

namespace primjs {

enum class PrimjsOpcode : uint8_t {
#define FMT(f)
#define DEF(id, size, n_pop, n_push, f) OP_##id,
#define def(id, size, n_pop, n_push, f)
#include "quickjs/include/quickjs-opcode.h"
#undef def
#undef DEF
#undef FMT
  kCount,
};

const char* get_opcode_string(PrimjsOpcode opCode);
int get_opcode_size(PrimjsOpcode opCode);

bool is_with_opcode(PrimjsOpcode opCode);

void get_bc_handler_name(int call_index, std::string& name);
int get_npush(PrimjsOpcode opCode);
int get_npop(PrimjsOpcode opCode);

bool is_handler1_bc_index(int call_index);
bool is_handler2_bc_index(int call_index);

}  // namespace primjs

#endif  // PRIMJS_BYTECODE_H
