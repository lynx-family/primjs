// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_SON_ACCESS_BUILDER_H
#define PRIMJS_SON_ACCESS_BUILDER_H

#include "primjs/interp/call_stub.h"
#include "primjs/son/nodeType.h"
#include "quickjs/include/quickjs-inner.h"
#include "quickjs/include/quickjs.h"

#undef MB

namespace primjs {

// vm_codegen uses the same frame ABI as the runtime configuration it is built
// for, so all generated offsets come directly from the active structure.
#ifdef ENABLE_QUICKJS_DEBUGGER
using CodegenQuickStackFrame = DebuggerQuickStackFrame;
#else
using CodegenQuickStackFrame = QuickStackFrame;
#endif

struct FieldAccess {
  son::node::MachineType _type;
  int _offset;
  bool _is_32bit;

  FieldAccess(son::node::MachineType type, int offset, bool is_32bit)
      : _type(type), _offset(offset), _is_32bit(is_32bit) {}

  son::node::MachineType type() const { return _type; }

  void set_type(son::node::MachineType type) { _type = type; }

  int offset() const {
    auto width = machine_type_to_element_width(_type, _is_32bit);
    vmassert(width > 0, "invalid type");
    vmassert((_offset % width) == 0, "invalid offset");
    return _offset / width;
  }

  int offset_in_bytes() const { return _offset; }
};

class AccessBuilder {
 public:
  static constexpr int align_sp(int n) { return ((n + 15) / 16) * 16; }
  static constexpr int js_stack_frame_size() {
    return align_sp(size_of_stack_frame() + sizeof(QuickCFrameStruct));
  }

  static constexpr int size_of_stack_frame() {
    return sizeof(CodegenQuickStackFrame);
  }

  static constexpr int js_stack_frame_js_mode_offset() {
    return offsetof(CodegenQuickStackFrame, js_mode);
  }

  static constexpr int js_stack_frame_arg_count_offset() {
    return offsetof(CodegenQuickStackFrame, arg_count);
  }

  static constexpr int js_stack_frame_var_ref_list_offset() {
    return offsetof(CodegenQuickStackFrame, var_ref_list);
  }

  static int js_stack_frame_var_refs_offset() {
    return offsetof(CodegenQuickStackFrame, var_refs);
  }

  static constexpr int js_stack_frame_ref_size_offset() {
    return offsetof(CodegenQuickStackFrame, ref_size);
  }

  static constexpr int js_stack_frame_var_buf_offset() {
    return offsetof(CodegenQuickStackFrame, var_buf);
  }

  static constexpr int js_stack_frame_arg_buf_offset() {
    return offsetof(CodegenQuickStackFrame, arg_buf);
  }

  static constexpr int js_stack_frame_prev_frame_offset() {
    return offsetof(CodegenQuickStackFrame, prev_frame);
  }

  static constexpr int js_stack_frame_cur_func_offset() {
    return offsetof(CodegenQuickStackFrame, cur_func);
  }

  static constexpr int js_stack_frame_cur_pc_offset() {
    return offsetof(CodegenQuickStackFrame, cur_pc);
  }

  static constexpr int js_stack_frame_cur_sp_offset() {
    return offsetof(CodegenQuickStackFrame, cur_sp);
  }

  static constexpr int js_stack_frame_sp_offset() {
    return offsetof(CodegenQuickStackFrame, sp);
  }

  static constexpr int interpreter_frame_this_obj_offset() {
    return size_of_stack_frame() + offsetof(QuickCFrameStruct, this_obj);
  }

  static constexpr int interpreter_frame_new_target_offset() {
    return size_of_stack_frame() + offsetof(QuickCFrameStruct, new_target);
  }

  static constexpr int interpreter_frame_var_refs_cache_offset() {
    return size_of_stack_frame() + offsetof(QuickCFrameStruct, var_refs_cache);
  }

  static constexpr int interpreter_frame_cpool_offset() {
    return size_of_stack_frame() + offsetof(QuickCFrameStruct, cpool);
  }

  static constexpr int interpreter_frame_argc_offset() {
    return size_of_stack_frame() + offsetof(QuickCFrameStruct, argc);
  }

  static constexpr int interpreter_frame_last_frame_offset() {
    return size_of_stack_frame() + offsetof(QuickCFrameStruct, last_frame);
  }
  static constexpr int interpreter_frame_last_lr_offset() {
    return size_of_stack_frame() + offsetof(QuickCFrameStruct, last_lr);
  }

#ifdef ENABLE_QUICKJS_DEBUGGER
  static constexpr int js_stack_frame_pthis_offset() {
    return offsetof(DebuggerQuickStackFrame, pthis);
  }

  static constexpr int debugger_mode_offset() {
    return offsetof(LEPUSContext, debugger_mode);
  }
#endif

  static constexpr int async_stack_frame_offset() {
    return offsetof(JSAsyncFunctionState, frame);
  }
  static constexpr int async_stack_throw_flag_offset() {
    return offsetof(JSAsyncFunctionState, throw_flag);
  }

  static constexpr int global_obj_offset() {
    return offsetof(LEPUSContext, global_obj);
  }
  static constexpr int global_var_obj_offset() {
    return offsetof(LEPUSContext, global_var_obj);
  }

  static constexpr int class_id_offset() {
    return offsetof(LEPUSObject, class_id);
  }
  static constexpr int var_refs_offset() {
    return offsetof(LEPUSObject, u.func.var_refs);
  }
  static constexpr int cfunction_proto_offset() {
    return offsetof(LEPUSObject, u.cfunc.cproto);
  }
  static constexpr int cfunction_length_offset() {
    return offsetof(LEPUSObject, u.cfunc.length);
  }
  static constexpr int cfunction_magic_offset() {
    return offsetof(LEPUSObject, u.cfunc.magic);
  }
  static constexpr int cfunction_function_offset() {
    return offsetof(LEPUSObject, u.cfunc.c_function);
  }
  static constexpr int opaque_offset() {
    return offsetof(LEPUSObject, u.opaque);
  }
  static constexpr int cfunctiondata_length_offset() {
    return offsetof(JSCFunctionDataRecord, length);
  }
  static constexpr int cfunctiondata_magic_offset() {
    return offsetof(JSCFunctionDataRecord, magic);
  }
  static constexpr int cfunctiondata_data_offset() {
    return offsetof(JSCFunctionDataRecord, data);
  }
  static constexpr int cfunctiondata_func_offset() {
    return offsetof(JSCFunctionDataRecord, func);
  }
  static constexpr int array_count_offset() {
    return offsetof(LEPUSObject, u.array.count);
  }
  static constexpr int array_size_offset() {
    return offsetof(LEPUSObject, u.array.u1.size);
  }
  static constexpr int array_values_offset() {
    return offsetof(LEPUSObject, u.array.u.values);
  }

  static constexpr int shape_offset() { return offsetof(LEPUSObject, shape); }
  static constexpr int object_prop_offset() {
    return offsetof(LEPUSObject, prop);
  }
  static constexpr int object_home_object_offset() {
    return offsetof(LEPUSObject, u.func.home_object);
  }
  static constexpr int object_gc_header_offset() {
    return offsetof(LEPUSObject, gc_header);
  }
  static constexpr int shape_hash_table_offset() {
    return offsetof(JSShape, hash_table);
  }
  static constexpr int shape_proto_offset() { return offsetof(JSShape, proto); }
  static constexpr int shape_has_small_array_index_offset() {
    return offsetof(JSShape, has_small_array_index);
  }
  static constexpr int shape_prop_hash_mask_offset() {
    return offsetof(JSShape, prop_hash_mask);
  }
  static constexpr int js_property_var_ref_offset() {
    return offsetof(JSPropertyGC, u.var_ref);
  }

  static constexpr int js_shape_property_atom_offset() {
    return offsetof(JSShapeProperty, atom);
  }

  static constexpr int js_property_hash_next_offset() {
    // offset of JSShapeProperty.hash_next
    return 0;
  }

  static constexpr int var_ref_pvalue_off() {
    return offsetof(JSVarRef, pvalue);
  }
  static constexpr int function_bytecode_offset() {
    return offsetof(LEPUSObject, u.func.function_bytecode);
  }
  static constexpr int bytecode_len_offset() {
    return offsetof(LEPUSFunctionBytecode, byte_code_len);
  }
  static constexpr int codes_offset() {
    return offsetof(LEPUSFunctionBytecode, byte_code_buf);
  }
  static constexpr int constants_offset() {
    return offsetof(LEPUSFunctionBytecode, cpool);
  }
  static constexpr int js_mode_offset() {
    return offsetof(LEPUSFunctionBytecode, js_mode);
  }
  static constexpr int arg_count_offset() {
    return offsetof(LEPUSFunctionBytecode, arg_count);
  }
  static constexpr int var_count_offset() {
    return offsetof(LEPUSFunctionBytecode, var_count);
  }
  static constexpr int stack_size_offset() {
    return offsetof(LEPUSFunctionBytecode, stack_size);
  }
  static constexpr int coverage_slot_count_offset() {
    return offsetof(LEPUSFunctionBytecode, coverage_slot_count);
  }
  static constexpr int coverage_counters_offset() {
    return offsetof(LEPUSFunctionBytecode, coverage_counters);
  }

  static constexpr int list_prev_offset() {
    return offsetof(struct list_head, prev);
  }

  static constexpr int list_next_offset() {
    return offsetof(struct list_head, next);
  }
  static constexpr int js_stack_state_offset() {
    return offsetof(LEPUSContext, stack_state);
  }

  static constexpr int stack_state_limit_offset() {
    return offsetof(LEPUSStackState, stack_limit);
  }

  static constexpr int stack_state_pos_offset() {
    return offsetof(LEPUSStackState, stack_pos);
  }
  static constexpr int con_mark_state_offset() {
    return offsetof(LEPUSContext, con_mark_state);
  }
  static constexpr int current_stack_frame_offset() {
    return offsetof(LEPUSRuntime, current_stack_frame);
  }
  static constexpr int current_exception_offset() {
    return offsetof(LEPUSRuntime, current_exception);
  }
  static constexpr int exception_needs_backtrace_offset() {
    return offsetof(LEPUSRuntime, exception_needs_backtrace);
  }
  static constexpr int rt_class_array_offset() {
    return offsetof(LEPUSRuntime, class_array);
  }
  static constexpr int rt_offset() { return offsetof(LEPUSContext, rt); }
  static constexpr int dispatch_table_offset() {
    return offsetof(LEPUSContext, dispatch_table);
  }

  static constexpr int class_call_offset() {
    return offsetof(LEPUSClass, call);
  }

  static constexpr int lepus_ref_point_offset() {
    return offsetof(LEPUSLepusRef, p);
  }

  static uint64_t JS_NewInt32(int num) {
    return LEPUS_TAG_INT | (uint64_t)(uint32_t)(num);
  }
};

}  // namespace primjs
#endif  // PRIMJS_SON_ACCESS_BUILDER_H
