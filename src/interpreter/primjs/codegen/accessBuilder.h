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
  static constexpr int object_flags_offset() {
    return class_id_offset() - sizeof(uint8_t);
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
  static constexpr int for_in_iterator_offset() {
    return offsetof(LEPUSObject, u.for_in_iterator);
  }
  static constexpr int for_in_iterator_obj_offset() {
    return offsetof(JSForInIteratorGC, obj);
  }
  static constexpr int for_in_iterator_idx_offset() {
    return offsetof(JSForInIteratorGC, idx);
  }
  static constexpr int for_in_iterator_atom_count_offset() {
    return offsetof(JSForInIteratorGC, atom_count);
  }
  static constexpr int for_in_iterator_in_prototype_chain_offset() {
    return offsetof(JSForInIteratorGC, in_prototype_chain);
  }
  static constexpr int for_in_iterator_is_array_offset() {
    return offsetof(JSForInIteratorGC, is_array);
  }
  static constexpr int for_in_iterator_tab_atom_offset() {
    return offsetof(JSForInIteratorGC, tab_atom);
  }
  static constexpr int property_enum_is_enumerable_offset() {
    return offsetof(LEPUSPropertyEnum, is_enumerable);
  }
  static constexpr int property_enum_atom_offset() {
    return offsetof(LEPUSPropertyEnum, atom);
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
  static constexpr int typed_array_data_offset() {
    return offsetof(LEPUSObject, u.array.u.ptr);
  }
  static constexpr int string_length_offset() {
    static_assert(sizeof(LEPUSRefCountHeader) == sizeof(uint32_t));
    return sizeof(LEPUSRefCountHeader);
  }
  static constexpr uint32_t string_length_mask() { return 0x3fffffff; }
  static constexpr uint32_t string_aux_mask() { return 0x40000000; }
  static constexpr uint32_t string_wide_mask() { return 0x80000000; }
  static constexpr int atom_type_offset() {
    // hash and atom_type share the 32-bit word following the length word.
    return string_length_offset() + sizeof(uint32_t);
  }
  static constexpr int string_aux_offset() { return offsetof(JSString, aux); }
  static constexpr int string_aux_meta_offset() {
    return offsetof(JSStringAux, meta);
  }
  static constexpr int string_data_offset() { return offsetof(JSString, u); }
  static constexpr int separable_string_depth_offset() {
    return offsetof(JSSeparableString, depth);
  }
  static constexpr int separable_string_left_offset() {
    return offsetof(JSSeparableString, left_op);
  }
  static constexpr int separable_string_right_offset() {
    return offsetof(JSSeparableString, right_op);
  }

  static constexpr int shape_offset() { return offsetof(LEPUSObject, shape); }
  static constexpr int object_prop_offset() {
    return offsetof(LEPUSObject, prop);
  }
  static constexpr int object_first_weak_ref_offset() {
    return offsetof(LEPUSObject, first_weak_ref);
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
  static constexpr int shape_prop_size_offset() {
    return offsetof(JSShape, prop_size);
  }
  static constexpr int shape_prop_count_offset() {
    return offsetof(JSShape, prop_count);
  }
  static constexpr int shape_ref_count_offset() {
    return offsetof(JSShape, header.ref_count);
  }
  static constexpr int shape_transition_target_offset() {
    return offsetof(JSShape, transition.target);
  }
  static constexpr int shape_transition_atom_offset() {
    return offsetof(JSShape, transition.atom);
  }
  static constexpr int shape_transition_prop_flags_offset() {
    return offsetof(JSShape, transition.prop_flags);
  }
  static constexpr int js_property_var_ref_offset() {
    return offsetof(JSPropertyGC, u.value);
  }

  static constexpr int js_shape_property_atom_offset() {
    return offsetof(JSShapeProperty, atom);
  }

  static constexpr int js_property_hash_next_offset() {
    // offset of JSShapeProperty.hash_next
    return 0;
  }

  static constexpr int var_ref_pvalue_off() {
    return offsetof(JSVarRefGC, pvalue);
  }
  static constexpr int var_ref_value_offset() {
    return offsetof(JSVarRefGC, value);
  }
  static constexpr int function_bytecode_offset() {
    return offsetof(LEPUSObject, u.func.function_bytecode);
  }
  static constexpr int function_bytecode_flags_offset() {
    return offsetof(LEPUSFunctionBytecode, js_mode) + sizeof(uint8_t);
  }
  static constexpr int function_bytecode_func_name_offset() {
    return offsetof(LEPUSFunctionBytecode, func_name);
  }
  static constexpr int function_bytecode_closure_var_offset() {
    return offsetof(LEPUSFunctionBytecode, closure_var);
  }
  static constexpr int function_bytecode_defined_arg_count_offset() {
    return offsetof(LEPUSFunctionBytecode, defined_arg_count);
  }
  static constexpr int function_bytecode_closure_var_count_offset() {
    return offsetof(LEPUSFunctionBytecode, closure_var_count);
  }
  static constexpr int closure_var_flags_offset() { return 0; }
  static constexpr int closure_var_index_offset() {
    return offsetof(LEPUSClosureVar, var_idx);
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
  static constexpr int function_flags_offset() {
    return js_mode_offset() + sizeof(uint8_t);
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
  static constexpr int js_stack_limit_offset() {
    return offsetof(LEPUSContext, stack_limit);
  }

  static constexpr int js_stack_offset() {
    return offsetof(LEPUSContext, stack_pos);
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
  static constexpr int rt_atom_array_offset() {
    return offsetof(LEPUSRuntime, atom_array);
  }
  static constexpr int rt_offset() { return offsetof(LEPUSContext, rt); }
  static constexpr int object_shape_offset() {
    return offsetof(LEPUSContext, object_shape);
  }
  static constexpr int array_shape_offset() {
    return offsetof(LEPUSContext, array_shape);
  }
  static constexpr int arguments_shape_offset() {
    return offsetof(LEPUSContext, arguments_shape);
  }
  static constexpr int function_shape_offset(int index) {
    return offsetof(LEPUSContext, function_shape) + index * sizeof(JSShape *);
  }
  static constexpr int array_proto_values_offset() {
    return offsetof(LEPUSContext, array_proto_values);
  }
  static constexpr int throw_type_error_offset() {
    return offsetof(LEPUSContext, throw_type_error);
  }
  static constexpr int object_ctx_check_offset() {
    return offsetof(LEPUSContext, object_ctx_check);
  }
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
