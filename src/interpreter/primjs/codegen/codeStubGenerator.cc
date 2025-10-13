// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/codeStubGenerator.h"

#include "primjs/codegen/bytecode.h"
#include "primjs/codegen/interpreterAssembler.h"
#include "primjs/son/callDescriptor.h"

namespace primjs {

CodeStubAssembler::CodeStubAssembler(son::node::NodeGraph* graph)
    : CodeAssembler(graph, graph->zone()) {
  auto desc = graph->call_descriptor();
  son::node::CallDescriptorData* desc_data = graph->GetCallDescriptor(desc);
  int arg_count = desc_data->param_count();
  for (int i = 0; i < arg_count; i++) {
    auto machine_type = desc_data->param_type(i);
    graph->NewParameter(i, son::node::NodeType::GetNodeType(machine_type));
  }
}

void CodeStubGenerator::Generate(son::node::NodeGraph* graph) {
  auto desc = graph->call_descriptor();
  vmassert(desc.kind() == son::node::CallKind::kStub, "invalid call kind");
  auto index = desc.call_index();
  CodeStubAssembler assembler(graph);
  son::node::GraphEnvironment env(&assembler);
  if (index == static_cast<int>(son::node::CallId::kInstallBcHandler)) {
    assembler.GenerateInstanallBcHandler(graph);
  } else if (index == static_cast<int>(son::node::CallId::k_call_stub_entry)) {
    assembler.GenerateCallEntry(graph);
  } else {
    unreachable();
  }
  assembler.End();
}

void CodeStubAssembler::GenerateInstanallBcHandler(
    son::node::NodeGraph* graph) {
  auto dispatch_table = graph->GetParameter(0);

  int length = static_cast<int>(PrimjsOpcode::kCount);
  for (int i = 0; i < length; i++) {
    auto opcode = static_cast<PrimjsOpcode>(i);
    int call_index = static_cast<int>(opcode);
    auto kind = son::node::CallKind::kBcHandler;
    auto desc = son::node::CallDescriptors::CallBcHandler(kind, call_index);
    auto node = FunctionPointer(desc);
    Store(son::node::MachineType::kIntptr, dispatch_table, IntPtrValue(i),
          node);
  }
  if (!graph->options().SupportMultiTable()) {
    Return();
    return;
  }
  dispatch_table = CastRawToIntPtr(dispatch_table);
  auto offset = IntPtrValue(length * intptr_size());
  auto new_table1 = CastToRaw(IntPtrAdd(dispatch_table, offset));
  for (int i = 0; i < length; i++) {
    auto opcode = static_cast<PrimjsOpcode>(i);
    int call_index = static_cast<int>(opcode);
    auto kind = son::node::CallKind::kBcHandler1;
    auto desc = son::node::CallDescriptors::CallBcHandler(kind, call_index);
    auto node = FunctionPointer(desc);
    Store(son::node::MachineType::kIntptr, new_table1, IntPtrValue(i), node);
  }
  dispatch_table = CastRawToIntPtr(new_table1);
  auto new_table2 = CastToRaw(IntPtrAdd(dispatch_table, offset));
  for (int i = 0; i < length; i++) {
    auto opcode = static_cast<PrimjsOpcode>(i);
    int call_index = static_cast<int>(opcode);
    auto kind = son::node::CallKind::kBcHandler2;
    auto desc = son::node::CallDescriptors::CallBcHandler(kind, call_index);
    auto node = FunctionPointer(desc);
    Store(son::node::MachineType::kIntptr, new_table2, IntPtrValue(i), node);
  }
  Return();
}

void CodeStubAssembler::GenerateCallEntry(son::node::NodeGraph* graph) {
  auto arg_index = 0;
  auto this_arg =
      graph->NewParameter(arg_index++, son::node::NodeType::Int64Type());
  auto new_target =
      graph->NewParameter(arg_index++, son::node::NodeType::Int64Type());
  auto func_obj =
      graph->NewParameter(arg_index++, son::node::NodeType::Int64Type());
  auto ctx = graph->NewParameter(arg_index++, son::node::NodeType::RawType());
  auto argc = graph->NewParameter(arg_index++, son::node::NodeType::IntType());
  auto argv = graph->NewParameter(arg_index++, son::node::NodeType::RawType());
  auto flags = graph->NewParameter(arg_index++, son::node::NodeType::IntType());

  // auto dispatch_table = ctx->dispatch_table;
  auto dispatch_table = LoadDispatchTable(ctx);
  auto rt = LoadRt(ctx);
  auto prev_frame = LoadCurrentStackFrame(rt);
  auto argc_64 = ZExtInt32ToInt64(argc);
  WriteRegister((int)HandlerVarIndex::kCtx, CastRawToInt64(ctx));
  WriteRegister((int)HandlerVarIndex::kDispatchTable,
                CastRawToInt64(dispatch_table));
  WriteRegister((int)HandlerVarIndex::kFrame, CastRawToInt64(prev_frame));
  WriteRegister((int)HandlerVarIndex::kFuncObj, func_obj);
  WriteRegister((int)HandlerVarIndex::kThisObject, this_arg);
  WriteRegister((int)HandlerVarIndex::kNewTarget, new_target);
  WriteRegister((int)HandlerVarIndex::kArgc, argc_64);

  ctx = CastToRaw(ReadRegister((int)HandlerVarIndex::kCtx));

  son::node::Node* old_stack = nullptr;
  bool use_virtual_sp = graph->options().SupportVirtualSp();
  if (!use_virtual_sp) {
    auto old_top = LoadJSTopSp(ctx);
    SaveValue(old_top);
    auto rsp = SaveStack();
    StoreJSTopSp(ctx, rsp);
  } else {
    old_stack = LoadJSStack(ctx);
  }

  // use flag as pc. pc is unused
  auto pc = ZExtToInt64(flags);
  int index = static_cast<int>(CallBcIndex::kcommon_call_from_entry);
  auto desc = son::node::CallDescriptors::ExtCallBcHandler(index);
  auto target = FunctionPointer(desc);
  Call(desc, target, CastToRaw(pc), argv);
  ctx = CastToRaw(ReadRegister((int)HandlerVarIndex::kCtx));

  if (!use_virtual_sp) {
    auto rfp = LoadJSTopSp(ctx);
    RestoreStack(rfp);
    auto old_top1 = RestoreValue();
    StoreJSTopSp(ctx, old_top1);
  } else {
    StoreJSStack(ctx, old_stack);
  }
  auto ret_val = ReadRegister((int)HandlerVarIndex::kRetVal);
  Return(ret_val);
}

}  // namespace primjs
