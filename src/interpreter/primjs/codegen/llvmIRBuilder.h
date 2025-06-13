// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_INTERP_LLVM_IR_BUILER_H
#define PRIMJS_INTERP_LLVM_IR_BUILER_H

#include <llvm-c/Core.h>

#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"
#include "primjs/codegen/llvmCodeGen.h"
#include "primjs/son/graphVisitor.h"
#include "primjs/son/nodeGraph.h"
#include "primjs/son/scheduleResult.h"

namespace primjs {

struct NotMergedPhi {
  int pred_index;
  son::node::Node* value;
  LLVMValueRef phi;
};

struct BasicBlockImpl {
  BasicBlockImpl(base::Zone* zone, LLVMBasicBlockRef bb)
      : block(bb), unmerged_phis(zone), started(false), ended(false) {}
  BasicBlockImpl(base::Zone* zone) : BasicBlockImpl(zone, nullptr) {}
  LLVMBasicBlockRef block;
  base::ZoneVector<NotMergedPhi> unmerged_phis;
  bool started;
  bool ended;
};

class LLVMAssembler;
class LLVMIRBuilder {
 public:
  LLVMIRBuilder(LLVMAssembler* assembler, son::node::NodeGraph* graph,
                son::node::ScheduleResult* result)
      : _assembler(assembler),
        _graph(graph),
        _result(result),
        _blocks(graph->zone()),
        _unmerged_blocks(graph->zone()),
        _nodes(graph->zone()) {
    _input_buffer = graph->zone()->alloc_array<LLVMValueRef>(kMaxCallArgs);
  }
  ~LLVMIRBuilder() {}

  void Build(LLVMValueRef func, son::node::CallDescriptorData* desc);

 private:
  void BuildPrologue(LLVMValueRef func, son::node::CallDescriptorData* desc);
  void BuildEpilogue();
  void BuildBlock(son::node::BasicBlock* bb);
  void BuildNode(const son::node::Node* node);
  void BuildCallInternal(const son::node::Node* node, bool tail);

  LLVMMetadataRef GetRegisterMetadata(int reg);

  void set_current_block(son::node::BasicBlock* bb) { _current_block = bb; }
  son::node::BasicBlock* current_block() const { return _current_block; }
  LLVMBasicBlockRef EnsureLLVMBlock(son::node::BasicBlock* bb);
  LLVMTypeRef GetLLVMTypeFromNode(son::node::Node const* node);
  unsigned GetAddressSpace(LLVMValueRef value);

#define DEF_MIR(name, f, k) void Build##name(const son::node::Node* node);
#define DEF_COMMON_IR(name, f, k) void Build##name(const son::node::Node* node);
#include "primjs/son/node.def"

  void BindNode(const son::node::Node* node, LLVMValueRef value) {
    _nodes[node->index()] = value;
  }
  LLVMValueRef GetNodeValue(const son::node::Node* node) {
    vmassert(_nodes[node->index()] != nullptr, "node not found");
    return _nodes[node->index()];
  }
  LLVMTypeRef Int32Type() const { return _assembler->int32_type(); }
  LLVMTypeRef Int64Type() const { return _assembler->int64_type(); }
  LLVMTypeRef DoubleType() const { return _assembler->double_type(); }
  LLVMTypeRef IntPtrType() const { return _assembler->intptr_type(); }
  LLVMTypeRef Int8Type() const { return _assembler->int8_type(); }
  LLVMTypeRef Int16Type() const { return _assembler->int16_type(); }
  LLVMTypeRef BoolType() const { return _assembler->bool_type(); }
  LLVMTypeRef RawType() const { return _assembler->raw_type(); }
  son::node::NodeGraph* graph() const { return _graph; }
  LLVMAssembler* assembler() const { return _assembler; }
  LLVMValueRef* input_buffer() const { return _input_buffer; }
  LLVMModule* llvm_module() const { return _assembler->llvm_module(); }
  LLVMModuleRef module() const { return _assembler->module(); }
  void SetCurrentBlockStarted() {
    _blocks[_current_block->id()].started = true;
  }
  void SetCurrentBlockTerminator() {
    _blocks[_current_block->id()].ended = true;
  }
  bool IsCurrentBlockStarted() const {
    return _blocks[_current_block->id()].started;
  }
  bool IsBlockStarted(int index) const { return _blocks[index].started; }
  bool IsCurrentBlockTerminated() const {
    return _blocks[_current_block->id()].ended;
  }
  LLVMBasicBlockRef GetBlock(int index) const { return _blocks[index].block; }
  void SetBlock(int index, LLVMBasicBlockRef bb) { _blocks[index].block = bb; }
  void StartCurrentBlock();
  bool IsEmptyOpcode(son::node::Opcode opcode);
  LLVMValueRef CastToPtr(LLVMValueRef value, LLVMTypeRef ptrType);

  bool is_tail_call() const { return _desc->is_tail_call(); }

  static constexpr int kMaxCallArgs = 16;

  LLVMAssembler* _assembler;
  son::node::NodeGraph* _graph;
  son::node::CallDescriptorData* _desc;
  son::node::ScheduleResult* _result;
  LLVMBuilderRef _builder{nullptr};
  LLVMValueRef _function{nullptr};
  LLVMContextRef _context{nullptr};
  son::node::BasicBlock* _current_block{nullptr};
  LLVMValueRef* _input_buffer{nullptr};
  base::ZoneVector<BasicBlockImpl> _blocks;
  base::ZoneVector<BasicBlockImpl*> _unmerged_blocks;
  base::ZoneVector<LLVMValueRef> _nodes;
};

}  // namespace primjs
#endif  // PRIMJS_INTERP_LLVM_IR_BUILDER_H
