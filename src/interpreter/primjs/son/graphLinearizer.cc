/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#include "primjs/son/graphLinearizer.h"

#include <iostream>

namespace son {
namespace node {

class CFGBuilder : public ZoneBase, public CFGVisitor {
 private:
  GraphLinearizer* _linearizer;
  ScheduleResult* _result;
  int _block_id;

 public:
  CFGBuilder(GraphLinearizer* linearizer)
      : ZoneBase(linearizer->zone()),
        CFGVisitor(linearizer->graph()),
        _linearizer(linearizer),
        _result(linearizer->schedule_result()),
        _block_id(0) {}

  VisitResult VisitNode(Node* node) override;
  void Run();
  void ConnectBlock(Node* node, BasicBlock* bb);
};

VisitResult CFGBuilder::VisitNode(Node* node) {
  if (!node->meta()->has_flag(MetaFlags::kControl)) {
    return VisitResult::Continue();
  }
  auto result_zone = _result->zone();
  auto bb = new (result_zone) BasicBlock(_block_id++, node, result_zone);
  _linearizer->AddBlock(bb);
  _linearizer->FixNode(bb, node);
  return VisitResult::Continue();
}

void CFGBuilder::ConnectBlock(Node* input, BasicBlock* bb) {
  auto from_bb = _linearizer->FindPredBB(input);
  from_bb->AddSuccessor(_result->zone(), bb);
  bb->AddPredecessor(_result->zone(), from_bb);
  if (input->opcode() == Opcode::OP_Return ||
      input->opcode() == Opcode::OP_ExceptionReturn) {
    _linearizer->FixNode(from_bb, input);
  }
}

void CFGBuilder::Run() {
  VisitGraph();
  for (auto bb : _result->block_list()) {
    auto node = bb->control();
    for (int i = node->control_start(); i < node->control_end(); i++) {
      auto input = node->control_at(i);
      ConnectBlock(input, bb);
    }
  }
  auto entry = _linearizer->block(graph()->start());
  auto end = _linearizer->block(graph()->end());
  _result->set_entry(entry);
  _result->set_end(end);
}

class SpecialRPOrderVisitor : public GraphZoneBase {
 private:
  struct VisitFrame {
    BasicBlock* block;
    BasicBlockBase::NextBlock* next;
    int outgoing_index;

    BasicBlock* Next() {
      vmassert(next != nullptr, "must be");
      auto value = BasicBlock::cast(next->to());
      next = next->_next;
      return value;
    }
    bool has_next() { return next != nullptr; }
    static VisitFrame Default() { return VisitFrame{nullptr, nullptr, 0}; }
  };

  struct BlockEdge {
    BasicBlock* from;
    BasicBlock* to;
  };
  GraphLinearizer* _linearizer;
  base::ZoneVector<BlockEdge> _back_edges;
  base::ZoneVector<VisitFrame> _stack;
  base::ZoneVector<BlockLoopInfo*> _loops;
  base::ZoneVector<BasicBlock*> _pending_list;
  BasicBlock* _rpo_order;
  int _num_loops;

 public:
  SpecialRPOrderVisitor(GraphLinearizer* linearizer)
      : GraphZoneBase(linearizer->graph(), linearizer->zone()),
        _linearizer(linearizer),
        _back_edges(zone()),
        _stack(zone()),
        _loops(zone()),
        _pending_list(zone()),
        _rpo_order(nullptr),
        _num_loops(0) {}

  int Push(int depth, BasicBlock* block, VisitState unvisited) {
    if (block->state() == unvisited) {
      _stack[depth].block = block;
      _stack[depth].next = block->first_out();
      _stack[depth].outgoing_index = 0;
      block->set_state(VisitState::kOnStck);
      return depth + 1;
    }
    return depth;
  }

  void LinkRpoFront(BasicBlock* block, BasicBlock* next) {
    block->set_rpo_next(_rpo_order);
    _rpo_order = next;
  }

  void Run() {
    auto entry = _linearizer->block(graph()->start());
    auto end = _linearizer->block(graph()->end());
    VisitRpo(entry, end);
    if (_num_loops != 0) {
      InitLoop();
      PrintLoopInfo();
      VisitLoop(entry, end);
    }
    ComputeRpoNumber();
    PropagateIDominators(entry);
  }

  void VisitRpo(BasicBlock* entry, BasicBlock* end) {
    _stack.resize(_linearizer->BasicBlockCount(), VisitFrame::Default());
    int stack_depth = Push(0, entry, VisitState::kUnvisit);
    while (stack_depth > 0) {
      VisitFrame& frame = _stack[stack_depth - 1];
      if (frame.block != end && frame.has_next()) {
        auto successor = frame.Next();
        if (successor->state() == VisitState::kUnvisit) {
          stack_depth = Push(stack_depth, successor, VisitState::kUnvisit);
        } else if (successor->state() == VisitState::kOnStck) {
          _back_edges.push_back(BlockEdge{frame.block, successor});
          if (!successor->has_loop_number()) {
            successor->set_loop_number(_num_loops++);
          }
        }
      } else {
        LinkRpoFront(frame.block, frame.block);
        frame.block->set_state(VisitState::kVisited);
        stack_depth--;
      }
    }
  }

  void PropagateLoopBody(BlockLoopInfo* info, BasicBlock* from_block) {
    _pending_list.push_back(from_block);
    info->_members->Add(from_block->id());

    while (!_pending_list.empty()) {
      auto block = _pending_list.back();
      _pending_list.pop_back();
      for (auto pred : block->preds()) {
        if ((pred != info->_header) && !info->_members->Contains(pred->id())) {
          info->_members->Add(pred->id());
          _pending_list.push_back(BasicBlock::cast(pred));
        }
      }
    }
  }

  void InitLoop() {
    _loops.resize(_num_loops, nullptr);
    auto block_count = _linearizer->BasicBlockCount();
    for (auto edge : _back_edges) {
      auto from_block = edge.from;
      auto to_block = edge.to;
      int loop_number = to_block->loop_number();
      auto info = _loops[loop_number];
      if (info == nullptr) {
        auto info = new (zone()) BlockLoopInfo(to_block, zone());
        info->_members = new (zone()) base::BitVector(block_count, zone());
        PropagateLoopBody(info, from_block);
        _loops[loop_number] = info;
      }
    }
  }

  void PrintLoopInfo() {
    if (!_linearizer->options().TraceLog()) return;
    auto block_count = _linearizer->BasicBlockCount();
    for (auto info : _loops) {
      std::cout << "loop " << info->_header->id() << " members: ";
      for (int i = 0; i < block_count; i++) {
        if (info->_members->Contains(i)) {
          std::cout << i << ", ";
        }
      }
      std::cout << std::endl;
    }
    std::cout << "rpo :";
    BasicBlock* current = _rpo_order;
    while (current != nullptr) {
      std::cout << current->id() << ", ";
      current = current->rpo_next();
    }
    std::cout << std::endl;
  }

  BlockLoopInfo* EnterInnerLoop(BlockLoopInfo* loop_info, BasicBlock* block) {
    auto inner = _loops[block->loop_number()];
    inner->_parent = loop_info;
    inner->_insert_point = _rpo_order;
    return inner;
  }

  BasicBlock* PushOutgoing(VisitFrame& frame) {
    auto block = frame.block;
    auto loop_info = _loops[block->loop_number()];
    BasicBlock* succ = nullptr;
    if (frame.outgoing_index < loop_info->outgoing_count()) {
      succ = loop_info->outgoing_at(frame.outgoing_index++);
    }
    return succ;
  }

  void VisitLoop(BasicBlock* entry, BasicBlock* end) {
    _rpo_order = nullptr;
    BlockLoopInfo* loop_info = nullptr;
    int stack_depth = Push(0, entry, VisitState::kUnvisit1);
    while (stack_depth > 0) {
      VisitFrame& frame = _stack[stack_depth - 1];
      auto block = frame.block;
      BasicBlock* succ = nullptr;
      if (block != end && frame.has_next()) {
        succ = frame.Next();
      } else if (block->has_loop_number()) {
        // back edge for loop header
        if (block->state() == VisitState::kOnStck) {
          vmassert(loop_info != nullptr, "must be");
          vmassert(loop_info->_header == block, "must be");
          block->set_rpo_next(_rpo_order);
          _rpo_order = loop_info->_insert_point;

          loop_info = loop_info->_parent;
          block->set_state(VisitState::kVisited1);
        }
        succ = PushOutgoing(frame);
      }

      if (succ != nullptr) {
        if (succ->state() != VisitState::kUnvisit1) continue;
        // loop exit
        if (loop_info != nullptr &&
            !loop_info->_members->Contains(succ->id())) {
          loop_info->AddOutgoing(succ);
        } else {
          stack_depth = Push(stack_depth, succ, VisitState::kUnvisit1);
          if (succ->has_loop_number()) {
            loop_info = EnterInnerLoop(loop_info, succ);
          }
        }
      } else {
        // pop loop header
        if (block->has_loop_number()) {
          auto info = _loops[block->loop_number()];

          auto bb = info->_header;
          for (; bb != nullptr; bb = bb->rpo_next()) {
            if (bb->rpo_next() == info->_insert_point) {
              bb->set_rpo_next(_rpo_order);
              info->_insert_point = _rpo_order;
              break;
            }
          }
          _rpo_order = info->_header;
        } else {
          LinkRpoFront(block, block);
          block->set_state(VisitState::kVisited1);
        }
        stack_depth--;
      }
    }
  }

  void ComputeRpoNumber() {
    int32_t index = 0;
    BasicBlock* current = _rpo_order;
    while (current != nullptr) {
      current->set_rpo_number(index++);
      current = current->rpo_next();
    }
  }

  void PropagateIDominators(BasicBlock* entry) {
    entry->set_dominator_depth(0);
    auto block = entry->rpo_next();
    while (block != nullptr) {
      BasicBlock* dominator = nullptr;
      for (auto pred : block->preds()) {
        auto pred_block = BasicBlock::cast(pred);
        if (pred_block->dominator_depth() == -1) {
          continue;
        }
        if (dominator == nullptr) {
          dominator = pred_block;
        } else {
          dominator = BasicBlock::GetCommonDominator(dominator, pred_block);
        }
      }
      block->set_dominator(dominator);
      block->set_dominator_depth(dominator->dominator_depth() + 1);
      block = block->rpo_next();
    }
  }
};

class PrepareUsesVisitor : public GraphZoneBase {
 private:
  GraphLinearizer* _linearizer;

 public:
  PrepareUsesVisitor(GraphLinearizer* linearizer)
      : GraphZoneBase(linearizer->graph(), linearizer->zone()),
        _linearizer(linearizer) {}

  void VisitNodePre(Node* node) {
    if (_linearizer->InitializeScheduleState(node) == ScheduleState::kFixed) {
      _linearizer->AddScheduleRoot(node);
      if (_linearizer->block(node) != nullptr) {
        return;
      }
      Node* control = nullptr;
      if (node->opcode() == Opcode::OP_Parameter) {
        control = graph()->start();
      } else {
        control = node->control_at();
      }
      auto block = _linearizer->block(control);
      vmassert(block != nullptr, "must be");
      if (node->opcode() == Opcode::OP_Phi ||
          node->opcode() == Opcode::OP_DependPhi ||
          node->opcode() == Opcode::OP_Parameter) {
        _linearizer->FixNodeToBlock(block, node);
      } else {
        _linearizer->AddNodeToBlock(block, node);
      }
    }
  }
  void VisitNodePost(NodeEdge edge) {
    auto node = edge.node();
    if (!_linearizer->IsScheduled(node)) {
      vmassert(_linearizer->GetScheduleState(node) != ScheduleState::kFixed,
               "must be");
      auto state = _linearizer->GetScheduleState(edge.from());
      if (state == ScheduleState::kFixed) {
        return;
      }
      vmassert(state == ScheduleState::kSchedulable, "must be");
      _linearizer->IncrementUnscheduledUseCount(edge.from());
    }
  }

  void Run() {
    base::ZoneVector<NodeEdge> stack(zone());
    graph()->AdvanceMarker();
    auto end = graph()->end();
    stack.push_back(NodeEdge{end, 0});
    VisitNodePre(end);

    while (!stack.empty()) {
      NodeEdge& edge = stack.back();
      auto node = edge.from();
      if (graph()->GetState(node) == NodeState::kUnvisited) {
        VisitNodePre(node);
        graph()->SetState(node, NodeState::kVisited);
        if (node->input_count() != 0) {
          stack.push_back(NodeEdge{node, 0});
        }
      } else {
        VisitNodePost(edge);
        edge.inc_index();
        if (edge.index() == edge.to()->input_count()) {
          stack.pop_back();
        }
      }
    }
  }
};

class Scheduler : public GraphZoneBase {
 private:
  GraphLinearizer* _linearizer;
  base::ZoneVector<Node*> _work_list;

 public:
  Scheduler(GraphLinearizer* linearizer)
      : GraphZoneBase(linearizer->graph(), linearizer->zone()),
        _linearizer(linearizer),
        _work_list(zone()) {}

  void ScheduleNode(BasicBlock* block, Node* node) {
    for (auto input : node->const_input_list()) {
      auto input_data = _linearizer->GetNodeData(input);
      if (!input_data->IsSchedulable()) {
        continue;
      }
      input_data->_unscheduled_count--;
      if (input_data->_unscheduled_count == 0) {
        _work_list.emplace_back(input);
      }
    }
    vmassert(!_linearizer->IsScheduled(node), "must be");
    _linearizer->AddNodeToBlock(block, node);
    _linearizer->GetNodeData(node)->_state = ScheduleState::kScheduled;
  }

  BasicBlock* GetCommonDominatorOfUses(Node* node) {
    BasicBlock* block = nullptr;
    auto use_it = node->use_list().begin();
    auto end = node->use_list().end();
    for (; use_it != end; ++use_it) {
      auto use_node = *use_it;
      BasicBlock* use_block = _linearizer->block(use_node);
      auto use_data = _linearizer->GetNodeData(use_node);
      if (use_data->IsNone()) continue;
      if (use_data->IsFixed()) {
        if (use_node->opcode() == Opcode::OP_Phi ||
            use_node->opcode() == Opcode::OP_DependPhi) {
          auto control = use_node->control_at();
          auto use_control = control->input_at(use_it.index() - 1);
          use_block = _linearizer->FindPredBB(use_control);
        } else if (use_node->opcode() == Opcode::OP_Merge ||
                   use_node->opcode() == Opcode::OP_Loop) {
          vmassert(use_node->input_at(use_it.index()) == use_it.input_node(),
                   "must be");
          use_block = _linearizer->FindPredBB(use_it.input_node());
        }
      }
      if (block == nullptr) {
        block = use_block;
      } else {
        block = BasicBlock::GetCommonDominator(block, use_block);
      }
    }
    return block;
  }

  void VisitNode(Node* node) {
    auto data = _linearizer->GetNodeData(node);
    vmassert(data->_unscheduled_count == 0, "must be");
    vmassert(!data->IsNone(), "must be");
    if (!data->IsSchedulable()) return;
    vmassert(_linearizer->block(node) == nullptr, "must be");
    auto block = GetCommonDominatorOfUses(node);
    ScheduleNode(block, node);
  }

  void ProcessWorkList() {
    while (!_work_list.empty()) {
      auto node = _work_list.back();
      _work_list.pop_back();
      VisitNode(node);
    }
  }

  void BindFixedNode() {
    for (auto node : _linearizer->fixed_nodes()) {
      auto block = _linearizer->block(node);
      block->AddNode(node);
    }
  }

  void Run() {
    for (auto node : _linearizer->schedule_root_nodes()) {
      for (auto input : node->const_input_list()) {
        if (_linearizer->GetNodeData(input)->_unscheduled_count != 0) {
          continue;
        }
        _work_list.push_back(input);
        ProcessWorkList();
      }
    }
    BindFixedNode();
  }
};

void GraphLinearizer::Run(ScheduleResult* result) {
  if (options().TraceLog()) {
    graph()->print();
  }
  _result = result;
  _node_data.resize(graph()->node_count(), SchedulerData::Default());
  _result->init_id_to_block(graph()->node_count());
  CFGBuilder builder(this);
  builder.Run();
  SpecialRPOrderVisitor visitor1(this);
  visitor1.Run();
  PrepareUsesVisitor visitor2(this);
  visitor2.Run();
  Scheduler scheduler(this);
  scheduler.Run();
  if (options().TraceLog()) {
    PrintGraph();
  }
}

void GraphLinearizer::PrintGraph() {
  std::cout << "===================== Print BasicBlock ======================="
            << std::endl;
  for (auto bb : _result->block_list()) {
    auto opcode = bb->control()->opcode();
    auto idom_id = bb->dominator() == nullptr ? -1 : bb->dominator()->id();
    std::cout << "B" << bb->id() << ": depth: [" << bb->dominator_depth()
              << "] ";
    std::cout << opcode << " IDom B" << idom_id
              << " Rpo id: " << bb->rpo_number() << std::endl;
    std::cout << "\t Preds: ";
    for (auto pred : bb->preds()) {
      std::cout << pred->id() << ", ";
    }
    std::cout << std::endl << "\t Succs: ";
    for (auto succ : bb->succs()) {
      std::cout << succ->id() << ", ";
    }
    std::cout << std::endl << "\t Nodes: ";
    for (int i = bb->nodes().size() - 1; i >= 0; i--) {
      auto node = bb->nodes()[i];
      node->print();
      std::cout << "\t        ";
    }
    std::cout << std::endl;
  }
}

ScheduleState GraphLinearizer::InitializeScheduleState(Node* node) {
  auto data = GetNodeData(node);
  if (data->_state == ScheduleState::kFixed) {
    return ScheduleState::kFixed;
  }
  switch (node->opcode()) {
    case Opcode::OP_Phi:
    case Opcode::OP_DependPhi:
    case Opcode::OP_Parameter:
    case Opcode::OP_Return:
    case Opcode::OP_ExceptionReturn:
      data->_state = ScheduleState::kFixed;
      return ScheduleState::kFixed;
    default:
      break;
  }
  data->_state = ScheduleState::kSchedulable;
  return ScheduleState::kSchedulable;
}

BasicBlock* GraphLinearizer::FindPredBB(Node* node) {
  auto current_bb = block(node);
  auto current_node = node;
  while (current_bb == nullptr) {
    vmassert(current_node->control_in() == 1, "must be");
    current_node = current_node->control_at();
    current_bb = block(current_node);
  }
  vmassert(current_bb != nullptr, "must be");
  return current_bb;
}

}  // namespace node
}  // namespace son
