
/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#include "primjs/codegen/bytecode.h"

#include "primjs/base/globals.h"
#include "primjs/codegen/interpreterAssembler.h"

namespace primjs {

#define DUMP_BYTECODE 1

const JSOpCode opcode_info[OP_COUNT + (OP_TEMP_END - OP_TEMP_START)] = {
#define FMT(f)
#define DEF(id, size, n_pop, n_push, f) {#id, size, n_pop, n_push, OP_FMT_##f},
#include "quickjs/include/quickjs-opcode.h"
#undef DEF
#undef FMT
};

const char* get_opcode_string(PrimjsOpcode opCode) {
  vmassert(opCode <= PrimjsOpcode::kCount, "invalid PrimjsOpcode");
  return short_opcode_info((OPCodeEnum)opCode).name;
}

bool is_with_opcode(PrimjsOpcode opCode) {
  switch (opCode) {
    case PrimjsOpcode::OP_with_get_var:
    case PrimjsOpcode::OP_with_put_var:
    case PrimjsOpcode::OP_with_delete_var:
    case PrimjsOpcode::OP_with_make_ref:
    case PrimjsOpcode::OP_with_get_ref:
    case PrimjsOpcode::OP_with_get_ref_undef:
      return true;
    default:
      break;
  }
  return false;
}

int get_npush(PrimjsOpcode opCode) {
  if (opCode == PrimjsOpcode::OP_gosub) {
    return 1;
  }
  vmassert(opCode <= PrimjsOpcode::kCount, "invalid PrimjsOpcode");
  return short_opcode_info((OPCodeEnum)opCode).n_push;
}

int get_npop(PrimjsOpcode opCode) {
  vmassert(opCode <= PrimjsOpcode::kCount, "invalid PrimjsOpcode");
  return short_opcode_info((OPCodeEnum)opCode).n_pop;
}

int get_opcode_size(PrimjsOpcode opCode) {
  vmassert(opCode <= PrimjsOpcode::kCount, "invalid PrimjsOpcode");

  return short_opcode_info((OPCodeEnum)opCode).size;
}

void get_bc_handler_name(int call_index, std::string& name) {
  auto str = get_opcode_string(static_cast<PrimjsOpcode>(call_index));
  name += str;
}

bool is_call_bc_index(int call_index) {
  PrimjsOpcode opcode = static_cast<PrimjsOpcode>(call_index);
  switch (opcode) {
    case PrimjsOpcode::OP_call0:
    case PrimjsOpcode::OP_call1:
    case PrimjsOpcode::OP_call2:
    case PrimjsOpcode::OP_call3:
    case PrimjsOpcode::OP_call:
    case PrimjsOpcode::OP_tail_call:
    case PrimjsOpcode::OP_call_method:
    case PrimjsOpcode::OP_tail_call_method:
      return true;
    default:
      break;
  }
  return false;
}

bool is_handler1_bc_index(int index) {
  switch (index) {
#define DEF_INTERP_DISP(name, ...)             \
  case static_cast<int>(CallBcIndex::k##name): \
    return true;
#include "primjs/codegen/handler.def"
    default:
      break;
  }
  return false;
}

bool is_handler2_bc_index(int index) {
  switch (index) {
#define DEF_INTERP_DISP(name, ...)             \
  case static_cast<int>(CallBcIndex::k##name): \
    return true;
#include "primjs/codegen/handler.def"
    default:
      break;
  }
  return false;
}

}  // namespace primjs
