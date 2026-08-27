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
  if (index == static_cast<int>(son::node::CallId::k_call_stub_entry)) {
    assembler.GenerateCallEntry(graph);
  } else {
    unreachable();
  }
  assembler.End();
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

  // use flag as pc. pc is unused
  auto pc = ZExtToInt64(flags);
  int index = static_cast<int>(CallBcIndex::kcommon_call_from_entry);
  auto desc = son::node::CallDescriptors::ExtCallBcHandler(index);
  auto target = FunctionPointer(desc);
  Call(desc, target, CastToRaw(pc), argv);

  auto ret_val = ReadRegister((int)HandlerVarIndex::kRetVal);
  Return(ret_val);
}

}  // namespace primjs
