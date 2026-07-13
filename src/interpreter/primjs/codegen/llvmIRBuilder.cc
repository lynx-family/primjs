// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/llvmIRBuilder.h"

#include "llvm/IR/CallingConv.h"
#include "primjs/codegen/bytecode.h"
#include "primjs/son/callDescriptor.h"
#include "primjs/son/nodeMatchers.h"

namespace primjs {

static const int kBCCallingConv = llvm::CallingConv::PRIMJS_TO_INTERPRETER;
static const int kStubCallingConv = llvm::CallingConv::PRIMJS_CODE_STUB;

void LLVMIRBuilder::BuildPrologue(LLVMValueRef func,
                                  son::node::CallDescriptorData* desc) {
  _function = func;
  _desc = desc;
  _context = _assembler->context();
  _builder = LLVMCreateBuilderInContext(_context);
  if (desc->is_call_handler()) {
    LLVMSetFunctionCallConv(_function, kBCCallingConv);
    LLVMAddTargetDependentFunctionAttr(_function, "frame-pointer", "all");
  } else if (desc->is_bc_handler()) {
    LLVMSetFunctionCallConv(_function, kBCCallingConv);
    llvm::Function* Func = llvm::unwrap<llvm::Function>(_function);
    Func->addFnAttr(llvm::Attribute::NoUnwind);
  } else {
    LLVMSetFunctionCallConv(_function, kStubCallingConv);
    LLVMAddTargetDependentFunctionAttr(_function, "frame-pointer", "all");
  }

  _blocks.resize(_result->block_list().size(), BasicBlockImpl(_graph->zone()));
  _nodes.resize(_graph->node_count());
}

void LLVMIRBuilder::BuildEpilogue() {
  for (auto bb : _unmerged_blocks) {
    for (auto desc : bb->unmerged_phis) {
      auto value_node = desc.value;
      auto llvm_bb = GetBlock(desc.pred_index);
      auto llvm_value = GetNodeValue(value_node);

      LLVMAddIncoming(desc.phi, &llvm_value, &llvm_bb, 1);
    }
    bb->unmerged_phis.clear();
  }
  _unmerged_blocks.clear();
  LLVMDisposeBuilder(_builder);
}

void LLVMIRBuilder::Build(LLVMValueRef func,
                          son::node::CallDescriptorData* desc) {
  BuildPrologue(func, desc);
  auto entry = _result->entry();
  son::node::BasicBlock* bb = entry;
  for (; bb != nullptr; bb = bb->rpo_next()) {
    BuildBlock(bb);
  }
  BuildEpilogue();
}

LLVMBasicBlockRef LLVMIRBuilder::EnsureLLVMBlock(son::node::BasicBlock* bb) {
  auto llvm_bb = GetBlock(bb->id());
  if (llvm_bb == nullptr) {
    std::string name = "B" + std::to_string(bb->id());
    llvm_bb = LLVMAppendBasicBlockInContext(_context, _function, name.c_str());
    SetBlock(bb->id(), llvm_bb);
  }
  return llvm_bb;
}

LLVMTypeRef LLVMIRBuilder::GetLLVMTypeFromNode(son::node::Node const* node) {
  auto type = node->type()->machine_type();
  auto llvm_type = _assembler->ConvertToLLVMType(type);
  return llvm_type;
}

unsigned LLVMIRBuilder::GetAddressSpace(LLVMValueRef value) {
  auto value_type = LLVMTypeOf(value);
  if (LLVMGetTypeKind(value_type) == LLVMPointerTypeKind) {
    return LLVMGetPointerAddressSpace(value_type);
  }
  return 0;
}

LLVMValueRef LLVMIRBuilder::CastToPtr(LLVMValueRef value, LLVMTypeRef ptrType) {
  auto value_type = LLVMTypeOf(value);
  if (LLVMGetTypeKind(value_type) == LLVMPointerTypeKind) {
    if (value_type == ptrType) {
      return value;
    }
    return LLVMBuildBitCast(_builder, value, ptrType, "");
  } else {
    vmassert(LLVMGetTypeKind(value_type) == LLVMIntegerTypeKind, "must be");
    value = LLVMBuildIntToPtr(_builder, value, ptrType, "");
  }
  return value;
}

void LLVMIRBuilder::StartCurrentBlock() {
  if (IsCurrentBlockStarted()) {
    return;
  }
  auto llvm_bb = EnsureLLVMBlock(current_block());
  LLVMPositionBuilderAtEnd(_builder, llvm_bb);
  SetCurrentBlockStarted();
}

bool LLVMIRBuilder::IsEmptyOpcode(son::node::Opcode opcode) {
  switch (opcode) {
    case son::node::Opcode::OP_Parameter:
    case son::node::Opcode::OP_Start:
    case son::node::Opcode::OP_End:
      return true;
    default:
      return false;
  }
  return false;
}

void LLVMIRBuilder::BuildBlock(son::node::BasicBlock* bb) {
  auto nodes = bb->nodes();
  int index = nodes.size() - 1;
  set_current_block(const_cast<son::node::BasicBlock*>(bb));
  for (; index >= 0; index--) {
    auto node = nodes[index];
    if (!IsEmptyOpcode(node->opcode())) {
      StartCurrentBlock();
    }
    BuildNode(node);
  }
  if (!IsCurrentBlockTerminated() && IsCurrentBlockStarted()) {
    vmassert(current_block()->successor_count() == 1, "must be");
    BuildGoto(nullptr);
  }
  set_current_block(nullptr);
}

void LLVMIRBuilder::BuildNode(const son::node::Node* node) {
  switch (node->opcode()) {
#define DEF_MIR(name, f, k)          \
  case son::node::Opcode::OP_##name: \
    Build##name(node);               \
    break;
#define DEF_COMMON_IR(name, f, k)    \
  case son::node::Opcode::OP_##name: \
    Build##name(node);               \
    break;
#include "primjs/son/node.def"
    default:
      break;
  }
}

void LLVMIRBuilder::BuildUnreachable(son::node::Node const* node) {
  auto currentBlock = LLVMGetInsertBlock(_builder);
  LLVMBasicBlockRef trapBlock = LLVMAppendBasicBlock(_function, "trap_block");

  LLVMPositionBuilderAtEnd(_builder, trapBlock);
  LLVMBuildUnreachable(_builder);

  LLVMPositionBuilderAtEnd(_builder, currentBlock);
  LLVMBuildBr(_builder, trapBlock);
  SetCurrentBlockTerminator();
}

void LLVMIRBuilder::BuildGoto(son::node::Node const* node) {
  if (IsCurrentBlockTerminated()) {
    return;
  }
  vmassert(current_block()->successor_count() == 1, "must be");
  auto bb = current_block()->successor_at<son::node::BasicBlock>(0);
  auto llvm_bb = EnsureLLVMBlock(bb);
  LLVMBuildBr(_builder, llvm_bb);
  SetCurrentBlockTerminator();
}

void LLVMIRBuilder::BuildNeg(son::node::Node const* node) {
  auto left = node->value_at(0);
  auto left_value = GetNodeValue(left);
  auto type = node->type()->machine_type();

  LLVMValueRef result = nullptr;
  if (type == son::node::MachineType::kFloat64) {
    result = LLVMBuildFNeg(_builder, left_value, "");
  } else {
    result = LLVMBuildNeg(_builder, left_value, "");
  }
  BindNode(node, result);
}

void LLVMIRBuilder::BuildConvert(son::node::Node const* node) {
  auto left = node->value_at(0);
  auto left_value = GetNodeValue(left);
  auto convert_type = node->meta_value<son::node::ConvertType>();

  LLVMValueRef result = nullptr;
  auto type = GetLLVMTypeFromNode(node);
  auto machine_type = node->type()->machine_type();
  if (convert_type == son::node::ConvertType::kZext) {
    result = LLVMBuildZExt(_builder, left_value, type, "");
  } else if (convert_type == son::node::ConvertType::kSext) {
    result = LLVMBuildSExt(_builder, left_value, type, "");
  } else if (convert_type == son::node::ConvertType::kTrunc) {
    result = LLVMBuildIntCast2(_builder, left_value, type, 1, "");
  } else if (convert_type == son::node::ConvertType::kCast) {
    if (son::node::is_pointer_type(machine_type)) {
      result = LLVMBuildIntToPtr(_builder, left_value, type, "");
    } else {
      result = LLVMBuildPtrToInt(_builder, left_value, type, "");
    }
  } else if (convert_type == son::node::ConvertType::kBitCast) {
    result = LLVMBuildBitCast(_builder, left_value, type, "");
  } else if (convert_type == son::node::ConvertType::kIntToDouble) {
    result = LLVMBuildSIToFP(_builder, left_value, type, "");
  } else if (convert_type == son::node::ConvertType::kDoubleToInt) {
    result = LLVMBuildFPToSI(_builder, left_value, type, "");
  } else if (convert_type == son::node::ConvertType::kUIntToDouble) {
    result = LLVMBuildUIToFP(_builder, left_value, type, "");
  } else if (convert_type == son::node::ConvertType::kDoubleToUInt) {
    result = LLVMBuildFPToUI(_builder, left_value, type, "");
  } else {
    vmassert(false, "must be");
  }
  BindNode(node, result);
}

void LLVMIRBuilder::BuildLShift(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  LLVMValueRef result = LLVMBuildShl(_builder, left_value, right_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildRShift(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  LLVMValueRef result = LLVMBuildAShr(_builder, left_value, right_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildURshift(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  LLVMValueRef result = LLVMBuildLShr(_builder, left_value, right_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildReturn(son::node::Node const* node) {
  if (node->value_in() == 0) {
    LLVMBuildRetVoid(_builder);
  } else {
    auto value = node->value_at(0);
    auto value_value = GetNodeValue(value);
    LLVMBuildRet(_builder, value_value);
  }
  SetCurrentBlockTerminator();
}

void LLVMIRBuilder::BuildExceptionReturn(son::node::Node const* node) {
  unreachable();
}

void LLVMIRBuilder::BuildOr(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  auto result = LLVMBuildOr(_builder, left_value, right_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildAdd(son::node::Node const* node) {
  auto left = node->value_at(0);
  auto right = node->value_at(1);
  auto left_value = GetNodeValue(left);
  auto right_value = GetNodeValue(right);
  auto type = node->type()->machine_type();

  LLVMValueRef result = nullptr;
  auto result_type = GetLLVMTypeFromNode(node);
  if (type == son::node::MachineType::kFloat64) {
    result = LLVMBuildFAdd(_builder, left_value, right_value, "");
  } else {
    auto type_kind = LLVMGetTypeKind(GetLLVMTypeFromNode(left));
    if (type_kind == LLVMPointerTypeKind) {
      auto ele_type = _assembler->int8_type();
      auto ref8 =
          LLVMBuildGEP2(_builder, ele_type, left_value, &right_value, 1, "");
      result = LLVMBuildPointerCast(_builder, ref8, result_type, "");
    } else {
      result = LLVMBuildAdd(_builder, left_value, right_value, "");
    }
  }
  BindNode(node, result);
}

void LLVMIRBuilder::BuildAnd(son::node::Node const* node) {
  auto left = node->value_at(0);
  auto right = node->value_at(1);
  auto left_value = GetNodeValue(left);
  auto right_value = GetNodeValue(right);
  LLVMValueRef result = LLVMBuildAnd(_builder, left_value, right_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildAddWithOverFlow(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  LLVMValueRef args[] = {left_value, right_value};
  auto fn = LLVMGetNamedFunction(module(), "llvm.sadd.with.overflow.i32");

  LLVMTypeRef param_type[] = {Int32Type(), Int32Type()};
  LLVMTypeRef return_struct_type[] = {Int32Type(), BoolType()};
  LLVMTypeRef return_type =
      LLVMStructTypeInContext(_context, return_struct_type, 2, 0);
  auto func_type = LLVMFunctionType(return_type, param_type, 2, 0);
  if (!fn) {
    fn = LLVMAddFunction(module(), "llvm.sadd.with.overflow.i32", func_type);
  }
  LLVMValueRef result = LLVMBuildCall2(_builder, func_type, fn, args, 2, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildSubWithOverFlow(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  LLVMValueRef args[] = {left_value, right_value};
  auto fn = LLVMGetNamedFunction(module(), "llvm.ssub.with.overflow.i32");

  LLVMTypeRef param_type[] = {Int32Type(), Int32Type()};
  LLVMTypeRef return_struct_type[] = {Int32Type(), BoolType()};
  LLVMTypeRef return_type =
      LLVMStructTypeInContext(_context, return_struct_type, 2, 0);
  auto func_type = LLVMFunctionType(return_type, param_type, 2, 0);
  if (!fn) {
    fn = LLVMAddFunction(module(), "llvm.ssub.with.overflow.i32", func_type);
  }
  LLVMValueRef result = LLVMBuildCall2(_builder, func_type, fn, args, 2, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildInt32Min(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  LLVMValueRef args[] = {left_value, right_value};
  auto fn = LLVMGetNamedFunction(module(), "llvm.smin.i32");

  LLVMTypeRef param_type[] = {Int32Type(), Int32Type()};
  LLVMTypeRef return_type = Int32Type();
  auto func_type = LLVMFunctionType(return_type, param_type, 2, 0);
  if (!fn) {
    fn = LLVMAddFunction(module(), "llvm.smin.i32", func_type);
  }
  LLVMValueRef result = LLVMBuildCall2(_builder, func_type, fn, args, 2, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildInt32Max(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  LLVMValueRef args[] = {left_value, right_value};
  auto fn = LLVMGetNamedFunction(module(), "llvm.smax.i32");

  LLVMTypeRef param_type[] = {Int32Type(), Int32Type()};
  LLVMTypeRef return_type = Int32Type();
  auto func_type = LLVMFunctionType(return_type, param_type, 2, 0);
  if (!fn) {
    fn = LLVMAddFunction(module(), "llvm.smax.i32", func_type);
  }
  LLVMValueRef result = LLVMBuildCall2(_builder, func_type, fn, args, 2, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildMulWithOverFlow(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  LLVMValueRef args[] = {left_value, right_value};
  auto fn = LLVMGetNamedFunction(module(), "llvm.smul.with.overflow.i32");

  LLVMTypeRef param_type[] = {Int32Type(), Int32Type()};
  LLVMTypeRef return_struct_type[] = {Int32Type(), BoolType()};
  LLVMTypeRef return_type =
      LLVMStructTypeInContext(_context, return_struct_type, 2, 0);
  auto func_type = LLVMFunctionType(return_type, param_type, 2, 0);
  if (!fn) {
    fn = LLVMAddFunction(module(), "llvm.smul.with.overflow.i32", func_type);
  }
  LLVMValueRef result = LLVMBuildCall2(_builder, func_type, fn, args, 2, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildExtractValue(son::node::Node const* node) {
  auto right = node->value_at(1);
  auto left_value = GetNodeValue(node->value_at(0));

  vmassert(right->is_constant(), "must be constant");
  vmassert(right->type()->machine_type() == son::node::MachineType::kInt32,
           "must be int32");
  auto index = right->constant_int_value();
  LLVMValueRef result = LLVMBuildExtractValue(_builder, left_value, index, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildAlloca(son::node::Node const* node) {
  auto left = node->value_at(0);
  auto left_value = GetNodeValue(left);

  vmassert(left->type()->machine_type() == son::node::MachineType::kInt32,
           "must be int32");

  auto type = Int8Type();
  LLVMValueRef result = LLVMBuildArrayAlloca(_builder, type, left_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildSaveStack(son::node::Node const* node) {
  auto fn = LLVMGetNamedFunction(module(), "llvm.stacksave.p0");
  LLVMTypeRef param_type[] = {};
  LLVMTypeRef return_type = LLVMPointerType(Int8Type(), 0);
  auto func_type = LLVMFunctionType(return_type, param_type, 0, 0);
  if (!fn) {
    fn = LLVMAddFunction(module(), "llvm.stacksave.p0", func_type);
  }
  auto result = LLVMBuildCall2(_builder, func_type, fn, nullptr, 0, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildRestoreStack(son::node::Node const* node) {
  auto left = node->value_at(0);
  auto left_value = GetNodeValue(left);

  auto fn = LLVMGetNamedFunction(module(), "llvm.stackrestore.p0");
  LLVMTypeRef return_type = LLVMVoidTypeInContext(_context);
  LLVMTypeRef param_type[] = {LLVMPointerType(Int8Type(), 0)};
  auto func_type = LLVMFunctionType(return_type, param_type, 1, 0);
  if (!fn) {
    fn = LLVMAddFunction(module(), "llvm.stackrestore.p0", func_type);
  }
  LLVMValueRef args[] = {left_value};
  auto result = LLVMBuildCall2(_builder, func_type, fn, args, 1, "");
  BindNode(node, result);
}

LLVMMetadataRef LLVMIRBuilder::GetRegisterMetadata(int reg) {
  LLVMMetadataRef meta = nullptr;
  switch (reg) {
#define DEF_REGISTER(name, r, n)                    \
  case n:                                           \
    meta = LLVMMDStringInContext2(_context, #r, 3); \
    break;
#include "primjs/interp/interp.def"
    default:
      unreachable();
      break;
  }
  return LLVMMDNodeInContext2(_context, &meta, 1);
}

void LLVMIRBuilder::BuildMessage(son::node::Node const* node) {
  auto info = node->meta_value<son::node::MessageInfo*>();

  LLVMValueRef const8 = LLVMConstStringInContext2(_context, info->buffer(),
                                                  info->buffer_len(), true);

  auto global_var = LLVMAddGlobal(module(), LLVMTypeOf(const8), "");
  LLVMSetAlignment(global_var, 8);
  LLVMSetUnnamedAddress(global_var, LLVMLocalUnnamedAddr);
  LLVMSetLinkage(global_var, LLVMPrivateLinkage);
  LLVMSetGlobalConstant(global_var, true);
  LLVMSetInitializer(global_var, const8);

  auto const8_type = Int8Type();
  LLVMValueRef indices[] = {LLVMConstInt(Int32Type(), 0, 0)};
  LLVMValueRef ref8 =
      LLVMBuildGEP2(_builder, const8_type, global_var, indices, 1, "");

  auto result = LLVMBuildPointerCast(_builder, ref8, RawType(), "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildReadRegister(son::node::Node const* node) {
  auto reg = node->meta_value<int>();

  LLVMMetadataRef meta = GetRegisterMetadata(reg);
  LLVMValueRef args[] = {LLVMMetadataAsValue(_context, meta)};
  auto fn = LLVMGetNamedFunction(module(), "llvm.read_register.i64");

  LLVMTypeRef return_type = Int64Type();
  LLVMTypeRef param_type[] = {LLVMMetadataTypeInContext(_context)};
  auto func_type = LLVMFunctionType(return_type, param_type, 1, 0);
  if (!fn) {
    fn = LLVMAddFunction(module(), "llvm.read_register.i64", func_type);
  }
  auto result = LLVMBuildCall2(_builder, func_type, fn, args, 1, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildWriteRegister(son::node::Node const* node) {
  auto left = node->value_at(0);
  auto left_value = GetNodeValue(left);
  auto reg = node->meta_value<int>();

  LLVMMetadataRef meta = GetRegisterMetadata(reg);
  LLVMValueRef args[] = {LLVMMetadataAsValue(_context, meta), left_value};
  auto fn = LLVMGetNamedFunction(module(), "llvm.write_register.i64");
  LLVMTypeRef return_type = LLVMVoidTypeInContext(_context);
  LLVMTypeRef param_type[] = {LLVMMetadataTypeInContext(_context), Int64Type()};
  auto func_type = LLVMFunctionType(return_type, param_type, 2, 0);
  if (!fn) {
    fn = LLVMAddFunction(module(), "llvm.write_register.i64", func_type);
  }
  auto result = LLVMBuildCall2(_builder, func_type, fn, args, 2, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildDiv(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  auto type = node->type()->machine_type();

  LLVMValueRef result = nullptr;
  if (type == son::node::MachineType::kFloat64) {
    result = LLVMBuildFDiv(_builder, left_value, right_value, "");
  } else {
    result = LLVMBuildSDiv(_builder, left_value, right_value, "");
  }
  BindNode(node, result);
}

void LLVMIRBuilder::BuildMod(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  auto type = node->type()->machine_type();

  LLVMValueRef result = nullptr;
  if (type == son::node::MachineType::kFloat64) {
    result = LLVMBuildFRem(_builder, left_value, right_value, "");
  } else {
    result = LLVMBuildSRem(_builder, left_value, right_value, "");
  }
  BindNode(node, result);
}

void LLVMIRBuilder::BuildMul(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  auto type = node->type()->machine_type();

  LLVMValueRef result = nullptr;
  if (type == son::node::MachineType::kFloat64) {
    result = LLVMBuildFMul(_builder, left_value, right_value, "");
  } else {
    result = LLVMBuildMul(_builder, left_value, right_value, "");
  }
  BindNode(node, result);
}

void LLVMIRBuilder::BuildNot(son::node::Node const* node) {
  auto left = node->value_at(0);
  auto left_value = GetNodeValue(left);

  LLVMValueRef result = LLVMBuildNot(_builder, left_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildSub(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  auto type = node->type()->machine_type();

  LLVMValueRef result = nullptr;
  if (type == son::node::MachineType::kFloat64) {
    result = LLVMBuildFSub(_builder, left_value, right_value, "");
  } else {
    result = LLVMBuildSub(_builder, left_value, right_value, "");
  }
  BindNode(node, result);
}

void LLVMIRBuilder::BuildXor(son::node::Node const* node) {
  auto left_value = GetNodeValue(node->value_at(0));
  auto right_value = GetNodeValue(node->value_at(1));
  auto result = LLVMBuildXor(_builder, left_value, right_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildCallInternal(const son::node::Node* node, bool tail) {
  auto desc = node->meta_value<son::node::CallDescriptor>();
  auto desc_data = graph()->GetCallDescriptor(desc);
  auto target = GetNodeValue(node->value_at(0));

  auto argc = node->value_in();
  // skip target
  for (int i = 1; i < argc; i++) {
    input_buffer()[i - 1] = GetNodeValue(node->value_at(i));
  }
  auto function_type = llvm_module()->GenerateFunctionType(desc_data);
  auto callee = LLVMBuildIntToPtr(_builder, target,
                                  LLVMPointerType(function_type, 0), "");
  auto result = LLVMBuildCall2(_builder, function_type, callee, input_buffer(),
                               argc - 1, "");
  if (desc.is_bc_handler()) {
    auto tail_call = tail && desc_data->is_tail_call() && is_tail_call();
    LLVMSetTailCall(result, tail_call);
    LLVMSetInstructionCallConv(result, kBCCallingConv);
  }
  BindNode(node, result);
}

void LLVMIRBuilder::BuildCall(son::node::Node const* node) {
  BuildCallInternal(node, false);
}

void LLVMIRBuilder::BuildTailCall(son::node::Node const* node) {
  BuildCallInternal(node, true);
}

void LLVMIRBuilder::BuildFunctionPointer(son::node::Node const* node) {
  auto desc = node->meta_value<son::node::CallDescriptor>();
  auto desc_data = graph()->GetCallDescriptor(desc);
  auto result = assembler()->llvm_module()->GetOrCreateFunction(desc_data);
  BindNode(node, result);
}

void LLVMIRBuilder::BuildFCmp(son::node::Node const* node) {
  auto left = node->value_at(0);
  auto right = node->value_at(1);
  auto left_value = GetNodeValue(left);
  auto right_value = GetNodeValue(right);
  auto cond = node->meta_value<son::node::FCmpCondition>();

  LLVMRealPredicate res = LLVMRealONE;
  switch (cond) {
    case son::node::FCmpCondition::kOeq:
      res = LLVMRealOEQ;
      break;
    case son::node::FCmpCondition::kOne:
      res = LLVMRealONE;
      break;
    case son::node::FCmpCondition::kOlt:
      res = LLVMRealOLT;
      break;
    case son::node::FCmpCondition::kOgt:
      res = LLVMRealOGT;
      break;
    case son::node::FCmpCondition::kOle:
      res = LLVMRealOLE;
      break;
    case son::node::FCmpCondition::kOge:
      res = LLVMRealOGE;
      break;
    default:
      unreachable();
      break;
  }
  auto result = LLVMBuildFCmp(_builder, res, left_value, right_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildICmp(son::node::Node const* node) {
  auto left = node->value_at(0);
  auto right = node->value_at(1);
  auto left_value = GetNodeValue(left);
  auto right_value = GetNodeValue(right);

  auto cond = node->meta_value<son::node::ICmpCondition>();
  LLVMIntPredicate res = LLVMIntEQ;
  switch (cond) {
    case son::node::ICmpCondition::kEq:
      res = LLVMIntEQ;
      break;
    case son::node::ICmpCondition::kNe:
      res = LLVMIntNE;
      break;
    case son::node::ICmpCondition::kSlt:
      res = LLVMIntSLT;
      break;
    case son::node::ICmpCondition::kSle:
      res = LLVMIntSLE;
      break;
    case son::node::ICmpCondition::kSgt:
      res = LLVMIntSGT;
      break;
    case son::node::ICmpCondition::kSge:
      res = LLVMIntSGE;
      break;
    case son::node::ICmpCondition::kUge:
      res = LLVMIntUGE;
      break;
    case son::node::ICmpCondition::kUlt:
      res = LLVMIntULT;
      break;
    case son::node::ICmpCondition::kUgt:
      res = LLVMIntUGT;
      break;
    case son::node::ICmpCondition::kUle:
      res = LLVMIntULE;
      break;
    default:
      unreachable();
      break;
  }
  auto result = LLVMBuildICmp(_builder, res, left_value, right_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildLoad(son::node::Node const* node) {
  auto object = node->value_at(0);
  auto offset_node = node->value_at(1);
  auto offset_value = GetNodeValue(offset_node);
  auto object_value = GetNodeValue(object);

  auto result_type = GetLLVMTypeFromNode(node);
  son::node::Int32Matcher matcher(offset_node);

  unsigned address_space = GetAddressSpace(object_value);
  LLVMTypeRef mem_type = LLVMPointerType(result_type, address_space);
  object_value = CastToPtr(object_value, mem_type);
  if (!matcher.Is(0)) {
    object_value = LLVMBuildGEP2(_builder, result_type, object_value,
                                 &offset_value, 1, "");
  }

  auto result = LLVMBuildLoad2(_builder, result_type, object_value, "");
  BindNode(node, result);
}

void LLVMIRBuilder::BuildStore(son::node::Node const* node) {
  auto object = node->value_at(0);
  auto offset_node = node->value_at(1);
  auto value = GetNodeValue(node->value_at(2));
  auto object_value = GetNodeValue(object);
  auto offset_value = GetNodeValue(offset_node);

  auto result_type = GetLLVMTypeFromNode(node);
  son::node::Int32Matcher matcher(offset_node);
  if (!matcher.Is(0)) {
    object_value = LLVMBuildGEP2(_builder, result_type, object_value,
                                 &offset_value, 1, "");
  }
  unsigned address_space = GetAddressSpace(object_value);
  LLVMTypeRef mem_type = LLVMPointerType(result_type, address_space);
  object_value = CastToPtr(object_value, mem_type);
  LLVMBuildStore(_builder, value, object_value);
}

void LLVMIRBuilder::BuildBranch(son::node::Node const* node) {
  auto cond = node->value_at(0);
  auto cond_value = GetNodeValue(cond);
  auto branch_hit = node->meta_value<son::node::BranchHint>();

  auto if_true = current_block()->successor_at<son::node::BasicBlock>(0);
  auto if_false = current_block()->successor_at<son::node::BasicBlock>(1);
  auto llvm_bb_true = EnsureLLVMBlock(if_true);
  auto llvm_bb_false = EnsureLLVMBlock(if_false);
  LLVMValueRef result =
      LLVMBuildCondBr(_builder, cond_value, llvm_bb_true, llvm_bb_false);
  if (branch_hit != son::node::BranchHint::kNone) {
    LLVMMetadataRef branch_weights =
        LLVMMDStringInContext2(_context, "branch_weights", 14);
    LLVMMetadataRef weight1 =
        LLVMValueAsMetadata(LLVMConstInt(LLVMIntType(32), 100, 0));
    LLVMMetadataRef weight2 =
        LLVMValueAsMetadata(LLVMConstInt(LLVMIntType(32), 0, 0));
    if (branch_hit == son::node::BranchHint::kFalse) {
      LLVMMetadataRef tmp = weight1;
      weight1 = weight2;
      weight2 = tmp;
    }
    LLVMMetadataRef mds[] = {branch_weights, weight1, weight2};
    LLVMMetadataRef metadata = LLVMMDNodeInContext2(_context, mds, 3);
    LLVMValueRef metadata_value = LLVMMetadataAsValue(_context, metadata);
    LLVMSetMetadata(result, LLVMGetMDKindID("prof", 4), metadata_value);
  }
  BindNode(node, result);
  SetCurrentBlockTerminator();
}

void LLVMIRBuilder::BuildSwitch(son::node::Node const* node) {
  auto cond = node->value_at(0);
  auto cond_value = GetNodeValue(cond);
  int case_num = current_block()->successor_count();

  LLVMBasicBlockRef default_block = nullptr;
  for (auto it : current_block()->succs()) {
    auto succ = son::node::BasicBlock::cast(it);
    if (succ->control()->opcode() == son::node::Opcode::OP_DefaultCase) {
      default_block = EnsureLLVMBlock(succ);
      break;
    }
  }
  vmassert(default_block != nullptr, "must be");
  LLVMValueRef result = LLVMBuildSwitch(_builder, cond_value, default_block,
                                        static_cast<uint32_t>(case_num - 1));
  for (auto it : current_block()->succs()) {
    auto succ = son::node::BasicBlock::cast(it);
    auto control = succ->control();
    if (control->opcode() == son::node::Opcode::OP_DefaultCase) {
      continue;
    }
    vmassert(succ->control()->opcode() == son::node::Opcode::OP_SwitchCase,
             "must be");
    int case_value_int = control->meta_value<int32_t>();
    auto llvm_bb = EnsureLLVMBlock(succ);
    auto case_value = LLVMConstInt(Int32Type(), case_value_int, 0);
    LLVMAddCase(result, case_value, llvm_bb);
  }
  BindNode(node, result);
  SetCurrentBlockTerminator();
}

void LLVMIRBuilder::BuildConstant(son::node::Node const* node) {
  auto type = node->type()->machine_type();

  auto value = node->meta_value<uint64_t>();
  LLVMValueRef result = nullptr;
  if (type == son::node::MachineType::kInt32) {
    result = LLVMConstInt(Int32Type(), value, 0);
  } else if (type == son::node::MachineType::kInt64) {
    result = LLVMConstInt(Int64Type(), value, 0);
  } else if (type == son::node::MachineType::kFloat64) {
    auto doubleValue = base::type_bit_cast<int64_t, double>(value);
    result = LLVMConstReal(DoubleType(), doubleValue);
  } else if (type == son::node::MachineType::kInt8) {
    result = LLVMConstInt(Int8Type(), value, 0);
  } else if (type == son::node::MachineType::kInt16) {
    result = LLVMConstInt(Int16Type(), value, 0);
  } else if (type == son::node::MachineType::kBool) {
    result = LLVMConstInt(BoolType(), value, 0);
  } else if (type == son::node::MachineType::kIntptr) {
    result = LLVMConstInt(IntPtrType(), value, 0);
  } else if (son::node::is_pointer_type(type)) {
    auto llvm_type = GetLLVMTypeFromNode(node);
    auto const_value = LLVMConstInt(Int64Type(), value, 0);
    result = LLVMBuildIntToPtr(_builder, const_value, llvm_type, "");
  }
  BindNode(node, result);
}

void LLVMIRBuilder::BuildParameter(son::node::Node const* node) {
  int argth = node->meta_value<int>();
  LLVMValueRef value = LLVMGetParam(_function, argth);
  BindNode(node, value);
}

void LLVMIRBuilder::BuildPhi(son::node::Node const* node) {
  auto phi = LLVMBuildPhi(_builder, GetLLVMTypeFromNode(node), "");

  auto value_count = node->value_in();
  bool has_unmerged = false;
  auto control = node->control_at();

  for (int i = 0; i < value_count; ++i) {
    auto value_node = node->value_at(i);
    auto control_at = control->control_at(i);
    auto result_block = _result->block(control_at);

    if (!IsBlockStarted(result_block->id())) {
      auto current_impl = &_blocks[_current_block->id()];
      // skip control
      auto desc = NotMergedPhi{result_block->id(), value_node, phi};
      current_impl->unmerged_phis.push_back(desc);
      has_unmerged = true;
      continue;
    }
    auto llvm_bb = EnsureLLVMBlock(result_block);
    auto llvm_value = GetNodeValue(value_node);
    LLVMAddIncoming(phi, &llvm_value, &llvm_bb, 1);
  }
  if (has_unmerged) {
    auto current_impl = &_blocks[_current_block->id()];
    _unmerged_blocks.push_back(current_impl);
  }
  BindNode(node, phi);
}

void LLVMIRBuilder::BuildDependPhi(son::node::Node const* node) {}

void LLVMIRBuilder::BuildIfTrue(son::node::Node const* node) {}

void LLVMIRBuilder::BuildSwitchCase(son::node::Node const* node) {}

void LLVMIRBuilder::BuildDefaultCase(son::node::Node const* node) {}

void LLVMIRBuilder::BuildIfFalse(son::node::Node const* node) {}

void LLVMIRBuilder::BuildIfSuccess(son::node::Node const* node) {
  unreachable();
}

void LLVMIRBuilder::BuildIfException(son::node::Node const* node) {
  unreachable();
}

void LLVMIRBuilder::BuildEnd(son::node::Node const* node) {}

void LLVMIRBuilder::BuildDead(son::node::Node const* node) {}

void LLVMIRBuilder::BuildLoop(son::node::Node const* node) {}

void LLVMIRBuilder::BuildMerge(son::node::Node const* node) {}

void LLVMIRBuilder::BuildStart(son::node::Node const* node) {}

}  // namespace primjs
