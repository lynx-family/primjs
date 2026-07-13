// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/codeAssembler.h"

namespace primjs {

void CodeAssembler::WriteBarrier(son::node::Node* ctx, son::node::Node* obj,
                                 son::node::Node* offset,
                                 son::node::Node* value) {
  son::node::Label done(this);

  auto con_mark_state = LoadConMarkState(ctx);
  auto cond = Equal(con_mark_state, Int8Value(0));
  BranchIf(cond, &done, son::node::BranchHint::kTrue);
  {
    auto desc = son::node::CallDescriptors::prim_WriteBarrierNoStore();
    auto target = FunctionPointer(desc);
    Call(desc, target, value, ctx);
    Jump(&done);
  }
  Bind(&done);
}

void CodeAssembler::StoreHeapObject(son::node::Node* ctx,
                                    son::node::Node* object,
                                    son::node::Node* offset,
                                    son::node::Node* value) {
  StoreImpl(son::node::MachineType::kObject, object, offset, value);
  WriteBarrier(ctx, object, offset, value);
}

void CodeAssembler::Store(son::node::MachineType type, son::node::Node* object,
                          son::node::Node* offset, son::node::Node* value) {
  StoreImpl(type, object, offset, value);
}

son::node::Node* CodeAssembler::NewFloat64(son::node::Node* value) {
  son::node::Label done(this);

  auto pure_nan = Int64Value(LEPUS_FLOAT64_NAN_BITS + DOUBLE_ENCODE_OFFSET);
  son::node::Variable res_var(this, son::node::NodeType::Int64Type(), pure_nan);
  BranchIf(DoubleIsNaN(value), &done);
  {
    value = BitCastDoubleToInt64(value);
    res_var = Int64Add(value, Int64Value(DOUBLE_ENCODE_OFFSET));
    Jump(&done);
  }
  Bind(&done);
  return *res_var;
}

void CodeAssembler::CopyArgs(son::node::Node* local_buf,
                             son::node::Node* buf_end, son::node::Node* argv) {
  son::node::Label done(this);
  son::node::Label next(this);
  son::node::Label loop(this, true);
  son::node::Variable var_buf(this, son::node::NodeType::RawType(), local_buf);
  son::node::Variable src_buf(this, son::node::NodeType::RawType(), argv);

  BindLoop(&loop, 2);
  {
    auto condition = LessThan(*var_buf, buf_end);
    Branch(condition, &next, &done, son::node::BranchHint::kTrue);

    Bind(&next);
    {
      auto val = LoadLepusVal(*src_buf, IntValue(0));
      StoreLepusVal(*var_buf, IntValue(0), val);
      var_buf = CastToRaw(IntPtrAdd(*var_buf, IntPtrValue(sizeof(LEPUSValue))));
      src_buf = CastToRaw(IntPtrAdd(*src_buf, IntPtrValue(sizeof(LEPUSValue))));
      Jump(&loop);
    }
  }
  Bind(&done);
}

void CodeAssembler::CopyArgsUndefined(son::node::Node* local_buf,
                                      son::node::Node* buf_end) {
  son::node::Label done(this);
  son::node::Label next(this);
  son::node::Label loop(this, true);
  son::node::Variable var_buf(this, son::node::NodeType::RawType(), local_buf);

  BindLoop(&loop, 2);
  {
    auto condition = LessThan(*var_buf, buf_end);
    Branch(condition, &next, &done, son::node::BranchHint::kTrue);

    Bind(&next);
    {
      StoreLepusVal(*var_buf, IntValue(0), LepusUndefined());
      var_buf = CastToRaw(IntPtrAdd(*var_buf, IntPtrValue(sizeof(LEPUSValue))));
      Jump(&loop);
    }
  }
  Bind(&done);
}

}  // namespace primjs
