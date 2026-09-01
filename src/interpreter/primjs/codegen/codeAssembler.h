// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_CODE_ASSEMBLER_H
#define PRIMJS_CODE_ASSEMBLER_H

#include "primjs/base/globals.h"
#include "primjs/base/zone.h"
#include "primjs/codegen/accessBuilder.h"
#include "primjs/codegen/bytecode.h"
#include "primjs/son/graphBuilder.h"

namespace primjs {

class CodeAssembler : public son::node::GraphBuilder {
 public:
  CodeAssembler(son::node::NodeGraph* graph, base::Zone* zone)
      : son::node::GraphBuilder(graph, zone) {}
  ~CodeAssembler() {}

  son::node::Node* MakeValue(int64_t tag, son::node::Node* val) {
    // (LEPUSValue){.as_int64 =
    //                        (int64_t)((tag) | (uint64_t)(uint32_t)(val))};
    return Int64Or(val, Int64Value(tag));
  }

  son::node::Node* AtomFromUInt32(son::node::Node* val) {
    return Int32Or(val, IntValue(JS_ATOM_TAG_INT));
  }

  son::node::Node* NewCatchOffset(son::node::Node* val) {
    // return (LEPUSValue){.as_int64 =
    //                     (int64_t)((tag) | (uint64_t)(uint32_t)(val) << 16)};
    val = Int64LSL(val, Int64Value(16));
    return MakeValue(LEPUS_TAG_CATCH_OFFSET, val);
  }

  son::node::Node* NewBoolean(son::node::Node* val) {
    vmassert(val->type() == son::node::NodeType::BooleanType(), "must be");
    return MakeValue(LEPUS_TAG_BOOL, ZExtToInt64(val));
  }

  son::node::Node* NewInt32(son::node::Node* val) {
    return MakeValue(LEPUS_TAG_INT, ZExtToInt64(val));
  }

  son::node::Node* NewFloat64(son::node::Node* val);

  son::node::Node* LepusUndefined() {
    return Int64Value(LEPUS_UNDEFINED.as_int64);
  }
  son::node::Node* Uninitialized() {
    return Int64Value(LEPUS_UNINITIALIZED.as_int64);
  }
  son::node::Node* LepusNull() { return Int64Value(LEPUS_NULL.as_int64); }
  son::node::Node* LepusFalse() { return Int64Value(LEPUS_FALSE.as_int64); }
  son::node::Node* LepusTrue() { return Int64Value(LEPUS_TRUE.as_int64); }
  son::node::Node* Exception() { return Int64Value(LEPUS_EXCEPTION.as_int64); }

  son::node::Node* IsLepusObject(son::node::Node* val) {
    auto res = Int64And(val, Int64Value(NOT_CELL_OTHER_PTR_MASK));
    return Equal(res, Int64Value(0));
  }

  son::node::Node* IsLepusRef(son::node::Node* val) {
    auto res = Int64And(val, Int64Value(NOT_LEPUS_PTR_MASK));
    return Equal(res, Int64Value(LEPUS_REF_TAG));
  }

  son::node::Node* GetLepusRefPoint(son::node::Node* val) {
    auto ref = CastToRaw(GetPtr(val));
    auto offset = AccessBuilder::lepus_ref_point_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, ref, offset);
  }

  son::node::Node* IsPtrTag(son::node::Node* val) {
    return GreaterThanOrEqual(val, Int64Value(LEPUS_PTR_TAG));
  }

  son::node::Node* IsCatchOffset(son::node::Node* val) {
    // #define LEPUS_VALUE_IS_CATCH_OFFSET(v)     \
    // (!((v).as_int64 & 0xffff000000000000) && \
    // ((v).as_int64 & 0xf7) == LEPUS_TAG_CATCH_OFFSET)
    auto and1 = Int64And(val, Int64Value(0xffff000000000000));
    auto and2 = Int64And(val, Int64Value(0xf7));
    auto cond1 = Equal(and1, Int64Value(0));
    auto cond2 = Equal(and2, Int64Value(LEPUS_TAG_CATCH_OFFSET));
    return BoolAnd(cond1, cond2);
  }

  son::node::Node* GetCatchOffset(son::node::Node* val) {
    // #define LEPUS_VALUE_GET_CATCH_OFFSET(v) ((int)(v.as_int64 >> 16))
    return TruncInt64ToInt32(Int64LSR(val, Int64Value(16)));
  }

  son::node::Node* GetObject(son::node::Node* val) { return val; }
  son::node::Node* GetPtr(son::node::Node* val) {
    // #define LEPUS_VALUE_GET_PTR(v) ((void *)(((int64_t)(v).ptr &
    // OTHER_PTR_MASK)))
    return Int64And(val, Int64Value(OTHER_PTR_MASK));
  }

  son::node::Node* IsUndefined(son::node::Node* val) {
    return Equal(val, LepusUndefined());
  }

  son::node::Node* IsNull(son::node::Node* val) {
    return Equal(val, LepusNull());
  }

  son::node::Node* IsException(son::node::Node* val) {
    return Equal(val, Exception());
  }
  son::node::Node* IsLepusInt(son::node::Node* val) {
    // (((v).as_int64 & NOT_NUMBER_MASK) == NUMBER_TAG)
    auto cond = Int64And(val, Int64Value(NOT_NUMBER_MASK));
    return Equal(cond, Int64Value(NUMBER_TAG));
  }

  son::node::Node* IsLepusFloat64(son::node::Node* val) {
    // (((v).as_int64 & NUMBER_TAG) && ((v).as_int64 & NUMBER_TAG) !=
    // NUMBER_TAG)
    auto and_val = Int64And(val, Int64Value(NUMBER_TAG));
    auto cond1 = NotEqual(and_val, Int64Value(0));
    auto cond2 = NotEqual(and_val, Int64Value(NUMBER_TAG));
    return BoolAnd(cond1, cond2);
  }

  son::node::Node* GetLepusFloat64(son::node::Node* val) {
    auto val1 = Int64Sub(val, Int64Value(DOUBLE_ENCODE_OFFSET));
    return BitCastInt64ToDouble(val1);
  }

  son::node::Node* GetLepusInt(son::node::Node* val) {
    return TruncInt64ToInt32(val);
  }

  son::node::Node* IsStringValue(son::node::Node* val) {
    // (((v).as_int64 & NOT_OTHER_PTR_MASK) == LEPUS_TAG_STRING)
    auto and_val = Int64And(val, Int64Value(NOT_OTHER_PTR_MASK));
    return Equal(and_val, Int64Value(LEPUS_TAG_STRING));
  }

  son::node::Node* IsSymbolValue(son::node::Node* val) {
    // (((v).as_int64 & NOT_OTHER_PTR_MASK) == LEPUS_TAG_SYMBOL)
    auto cond = Int64And(val, Int64Value(NOT_OTHER_PTR_MASK));
    return Equal(cond, Int64Value(LEPUS_TAG_SYMBOL));
  }

  son::node::Node* IsSeparableStringValue(son::node::Node* val) {
    // (((v).as_int64 & NOT_OTHER_PTR_MASK) == LEPUS_TAG_SEPARABLE_STRING)
    auto cond = Int64And(val, Int64Value(NOT_OTHER_PTR_MASK));
    return Equal(cond, Int64Value(LEPUS_TAG_SEPARABLE_STRING));
  }

  son::node::Node* IsLepusString(son::node::Node* val) {
    // (((v).as_int64 & NOT_OTHER_PTR_MASK) == LEPUS_TAG_SEPARABLE_STRING)
    auto and_val = Int64And(val, Int64Value(NOT_OTHER_PTR_MASK));
    auto cond1 = Equal(and_val, Int64Value(LEPUS_TAG_SEPARABLE_STRING));
    auto cond2 = Equal(and_val, Int64Value(LEPUS_TAG_STRING));
    return BoolOr(cond1, cond2);
  }

  son::node::Node* IsBigIntValue(son::node::Node* val) {
    //   (((v).as_int64 & NOT_LEPUS_PTR_MASK) == LEPUS_TAG_BIG_INT)
    auto and_val = Int64And(val, Int64Value((NOT_LEPUS_PTR_MASK)));
    return Equal(and_val, Int64Value((LEPUS_TAG_BIG_INT)));
  }

  son::node::Node* IsUndefinedOrNull(son::node::Node* val) {
    // (((v).as_int64 & NOT_OTHER_PTR_MASK) == LEPUS_TAG_SEPARABLE_STRING)
    auto cond1 = IsUndefined(val);
    auto cond2 = IsNull(val);
    return BoolOr(cond1, cond2);
  }

  son::node::Node* IsLepusBoolean(son::node::Node* val) {
    // (((v).as_int64 & NOT_OTHER_PTR_MASK) == LEPUS_TAG_SEPARABLE_STRING)
    auto cond1 = Equal(val, LepusTrue());
    auto cond2 = Equal(val, LepusFalse());
    return BoolOr(cond1, cond2);
  }

  son::node::Node* LoadClassId(son::node::Node* obj) {
    auto offset = AccessBuilder::class_id_offset();
    return LoadByteOffset(son::node::MachineType::kInt16, obj, offset);
  }
  son::node::Node* LoadArraySize(son::node::Node* obj) {
    auto offset = AccessBuilder::array_size_offset();
    return LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
  }
  son::node::Node* LoadArrayCount(son::node::Node* obj) {
    auto offset = AccessBuilder::array_count_offset();
    return LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
  }
  void StoreArrayCount(son::node::Node* obj, son::node::Node* val) {
    auto offset = AccessBuilder::array_count_offset();
    return StoreByteOffset(son::node::MachineType::kInt32, obj, offset, val);
  }
  son::node::Node* LoadArrayValues(son::node::Node* obj) {
    auto offset = AccessBuilder::array_values_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }
  son::node::Node* LoadForInIterator(son::node::Node* obj) {
    return LoadByteOffset(son::node::MachineType::kRawType, obj,
                          AccessBuilder::for_in_iterator_offset());
  }
  son::node::Node* LoadForInIteratorObject(son::node::Node* iterator) {
    return LoadByteOffset(son::node::MachineType::kInt64, iterator,
                          AccessBuilder::for_in_iterator_obj_offset());
  }
  son::node::Node* LoadForInIteratorIndex(son::node::Node* iterator) {
    return LoadByteOffset(son::node::MachineType::kInt32, iterator,
                          AccessBuilder::for_in_iterator_idx_offset());
  }
  void StoreForInIteratorIndex(son::node::Node* iterator,
                               son::node::Node* index) {
    StoreByteOffset(son::node::MachineType::kInt32, iterator,
                    AccessBuilder::for_in_iterator_idx_offset(), index);
  }
  son::node::Node* LoadForInIteratorAtomCount(son::node::Node* iterator) {
    return LoadByteOffset(son::node::MachineType::kInt32, iterator,
                          AccessBuilder::for_in_iterator_atom_count_offset());
  }
  son::node::Node* LoadForInIteratorInPrototypeChain(
      son::node::Node* iterator) {
    return LoadByteOffset(
        son::node::MachineType::kInt8, iterator,
        AccessBuilder::for_in_iterator_in_prototype_chain_offset());
  }
  son::node::Node* LoadForInIteratorIsArray(son::node::Node* iterator) {
    return LoadByteOffset(son::node::MachineType::kInt8, iterator,
                          AccessBuilder::for_in_iterator_is_array_offset());
  }
  son::node::Node* LoadForInIteratorTabAtom(son::node::Node* iterator) {
    return LoadByteOffset(son::node::MachineType::kRawType, iterator,
                          AccessBuilder::for_in_iterator_tab_atom_offset());
  }
  son::node::Node* GetPropertyEnum(son::node::Node* tab_atom,
                                   son::node::Node* index) {
    auto offset = Int32Mul(index, IntValue(sizeof(LEPUSPropertyEnum)));
    return CastToRaw(IntPtrAdd(tab_atom, ZExtInt32ToIntPtr(offset)));
  }
  son::node::Node* LoadPropertyEnumIsEnumerable(son::node::Node* entry) {
    return LoadByteOffset(son::node::MachineType::kInt32, entry,
                          AccessBuilder::property_enum_is_enumerable_offset());
  }
  son::node::Node* LoadPropertyEnumAtom(son::node::Node* entry) {
    return LoadByteOffset(son::node::MachineType::kInt32, entry,
                          AccessBuilder::property_enum_atom_offset());
  }
  void StoreArraySize(son::node::Node* obj, son::node::Node* value) {
    StoreByteOffset(son::node::MachineType::kInt32, obj,
                    AccessBuilder::array_size_offset(), value);
  }
  void StoreArrayValues_NoBarrier(son::node::Node* obj,
                                  son::node::Node* value) {
    StoreByteOffset(son::node::MachineType::kRawType, obj,
                    AccessBuilder::array_values_offset(), value);
  }
  son::node::Node* LoadTypedArrayData(son::node::Node* obj) {
    auto offset = AccessBuilder::typed_array_data_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }
  son::node::Node* LoadStringLength(son::node::Node* str) {
    auto offset = AccessBuilder::string_length_offset();
    auto length_and_wide_flag =
        LoadByteOffset(son::node::MachineType::kInt32, str, offset);
    return Int32And(length_and_wide_flag,
                    Int32Value(AccessBuilder::string_length_mask()));
  }
  son::node::Node* LoadStringLengthAndWideFlag(son::node::Node* str) {
    auto length_and_flags =
        LoadByteOffset(son::node::MachineType::kInt32, str,
                       AccessBuilder::string_length_offset());
    return Int32And(length_and_flags,
                    Int32Value(AccessBuilder::string_length_mask() |
                               AccessBuilder::string_wide_mask()));
  }
  son::node::Node* LoadStringHasAux(son::node::Node* str) {
    auto length_and_flags =
        LoadByteOffset(son::node::MachineType::kInt32, str,
                       AccessBuilder::string_length_offset());
    return NotEqual(Int32And(length_and_flags,
                             Int32Value(AccessBuilder::string_aux_mask())),
                    Int32Value(0));
  }
  son::node::Node* LoadAtomType(son::node::Node* atom) {
    son::node::Label inline_meta(this);
    son::node::Label aux_meta(this);
    son::node::Label done(this);
    son::node::Variable hash_and_atom_type(this, son::node::NodeType::IntType(),
                                           IntValue(0));
    Branch(LoadStringHasAux(atom), &aux_meta, &inline_meta,
           son::node::BranchHint::kFalse);
    Bind(&inline_meta);
    hash_and_atom_type = LoadByteOffset(son::node::MachineType::kInt32, atom,
                                        AccessBuilder::atom_type_offset());
    Jump(&done);
    Bind(&aux_meta);
    auto aux = LoadByteOffset(son::node::MachineType::kRawType, atom,
                              AccessBuilder::string_aux_offset());
    hash_and_atom_type =
        LoadByteOffset(son::node::MachineType::kInt32, aux,
                       AccessBuilder::string_aux_meta_offset());
    Jump(&done);
    Bind(&done);
    return Int32LSR(*hash_and_atom_type, Int32Value(30));
  }
  void StoreSeparableStringHeader(son::node::Node* str,
                                  son::node::Node* length_and_wide,
                                  son::node::Node* depth) {
    StoreByteOffset(son::node::MachineType::kInt32, str, 0, IntValue(1));
    StoreByteOffset(son::node::MachineType::kInt32, str,
                    AccessBuilder::string_length_offset(), length_and_wide);
    StoreByteOffset(son::node::MachineType::kInt32, str,
                    AccessBuilder::separable_string_depth_offset(), depth);
  }
  son::node::Node* LoadObjectShape(son::node::Node* obj) {
    auto offset = AccessBuilder::shape_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }

  uint32_t getMark(uint32_t shift, uint32_t size) {
    return ((uint32_t{1} << shift) << size) - (uint32_t{1} << shift);
  }

  son::node::Node* LoadObjectIsExotic(son::node::Node* obj) {
    auto offset = AccessBuilder::object_gc_header_offset();
    auto val = LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
    // gc_header : 8, extensible: 1, free_mark: 1, is_exotic : 1;
    uint32_t mask = getMark(10, 1);
    // (value & kMask) >> kShift
    auto and_val = Int32LSR(Int32And(val, Int32Value(mask)), Int32Value(10));
    return Equal(and_val, Int32Value(1));
  }

  son::node::Node* LoadObjectIsFastArray(son::node::Node* obj) {
    auto offset = AccessBuilder::object_gc_header_offset();
    auto val = LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
    // gc_header : 8, extensible: 1, free_mark: 1, is_exotic : 1, fast_array : 1
    auto kShift = 11;
    uint32_t mask = getMark(kShift, 1);
    // (value & kMask) >> kShift
    auto and_val =
        Int32LSR(Int32And(val, Int32Value(mask)), Int32Value(kShift));
    return Equal(and_val, Int32Value(1));
  }

  son::node::Node* LoadObjectIsExtensible(son::node::Node* obj) {
    auto offset = AccessBuilder::object_gc_header_offset();
    auto val = LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
    // gc_header : 8, extensible: 1, free_mark: 1, is_exotic : 1;
    auto kShift = 8;
    uint32_t mask = getMark(kShift, 1);
    // (value & kMask) >> kShift
    auto and_val =
        Int32LSR(Int32And(val, Int32Value(mask)), Int32Value(kShift));
    return Equal(and_val, Int32Value(1));
  }

  son::node::Node* LoadObjectIsStdArrayPrototype(son::node::Node* obj) {
    auto offset = AccessBuilder::object_gc_header_offset();
    auto val = LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
    auto kShift = 13;
    uint32_t mask = getMark(kShift, 1);
    auto and_val =
        Int32LSR(Int32And(val, Int32Value(mask)), Int32Value(kShift));
    return Equal(and_val, Int32Value(1));
  }

  son::node::Node* LoadObjectProp(son::node::Node* obj) {
    auto offset = AccessBuilder::object_prop_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }

  son::node::Node* LoadShapeProto(son::node::Node* obj) {
    auto offset = AccessBuilder::shape_proto_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }

  son::node::Node* LoadHasSmallArrayIndex(son::node::Node* obj) {
    auto offset = AccessBuilder::shape_has_small_array_index_offset();
    return LoadByteOffset(son::node::MachineType::kInt8, obj, offset);
  }

  son::node::Node* LoadShapePropHashMask(son::node::Node* obj) {
    auto offset = AccessBuilder::shape_prop_hash_mask_offset();
    return LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
  }

  void StoreJsPropertyVarRef(son::node::Node* ctx, son::node::Node* obj,
                             son::node::Node* val) {
    auto offset = AccessBuilder::js_property_var_ref_offset();
    StoreHeapObject(ctx, obj, offset,
                    MakeValue(LEPUS_TAG_VAR_REF, CastRawToInt64(val)));
  }

  son::node::Node* LoadJsShapePropertyAtom(son::node::Node* obj) {
    auto offset = AccessBuilder::js_shape_property_atom_offset();
    return LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
  }

  son::node::Node* LoadJsShapePropertyHashNext(son::node::Node* obj) {
    auto offset = AccessBuilder::js_property_hash_next_offset();
    // hash_next : 26
    auto val = LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
    uint32_t mask = getMark(0, 26);
    return Int32And(val, Int32Value(mask));
  }

  son::node::Node* LoadJsShapePropertyHashFlags(son::node::Node* obj) {
    auto offset = AccessBuilder::js_property_hash_next_offset();
    auto val = LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
    // flags : 6;
    uint32_t mask = getMark(26, 6);
    // (value & kMask) >> kShift
    return Int32LSR(Int32And(val, Int32Value(mask)), Int32Value(26));
  }

  son::node::Node* LoadCFunctionProto(son::node::Node* obj) {
    auto offset = AccessBuilder::cfunction_proto_offset();
    return LoadByteOffset(son::node::MachineType::kInt8, obj, offset);
  }

  son::node::Node* LoadCFunctionLength(son::node::Node* obj) {
    auto offset = AccessBuilder::cfunction_length_offset();
    return LoadByteOffset(son::node::MachineType::kInt8, obj, offset);
  }

  son::node::Node* LoadCFunctionFunction(son::node::Node* obj) {
    auto offset = AccessBuilder::cfunction_function_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }
  son::node::Node* LoadCFunctionMagic(son::node::Node* obj) {
    auto offset = AccessBuilder::cfunction_magic_offset();
    return LoadByteOffset(son::node::MachineType::kInt16, obj, offset);
  }

  son::node::Node* LoadOpaque(son::node::Node* obj) {
    auto offset = AccessBuilder::opaque_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }

  son::node::Node* LoadCFunctionDataMagic(son::node::Node* obj) {
    auto offset = AccessBuilder::cfunctiondata_magic_offset();
    return LoadByteOffset(son::node::MachineType::kInt16, obj, offset);
  }
  son::node::Node* LeapCFunctionDataData(son::node::Node* obj) {
    auto offset = AccessBuilder::cfunctiondata_data_offset();
    return CastToRaw(IntPtrAdd(obj, IntPtrValue(offset)));
  }
  son::node::Node* LoadCFunctionDataFunc(son::node::Node* obj) {
    auto offset = AccessBuilder::cfunctiondata_func_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }
  son::node::Node* LoadCFunctionDataLength(son::node::Node* obj) {
    auto offset = AccessBuilder::cfunctiondata_length_offset();
    return LoadByteOffset(son::node::MachineType::kInt8, obj, offset);
  }

  son::node::Node* LoadVarRefs(son::node::Node* obj) {
    auto offset = AccessBuilder::var_refs_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }

  son::node::Node* LoadRt(son::node::Node* obj) {
    auto offset = AccessBuilder::rt_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }
  son::node::Node* LoadArrayShape(son::node::Node* ctx) {
    return LoadByteOffset(son::node::MachineType::kRawType, ctx,
                          AccessBuilder::array_shape_offset());
  }
  son::node::Node* LoadArgumentsShape(son::node::Node* ctx) {
    return LoadByteOffset(son::node::MachineType::kRawType, ctx,
                          AccessBuilder::arguments_shape_offset());
  }
  son::node::Node* LoadFunctionShape(son::node::Node* ctx, int index) {
    return LoadByteOffset(son::node::MachineType::kRawType, ctx,
                          AccessBuilder::function_shape_offset(index));
  }
  son::node::Node* LoadArrayProtoValues(son::node::Node* ctx) {
    return LoadByteOffset(son::node::MachineType::kInt64, ctx,
                          AccessBuilder::array_proto_values_offset());
  }
  son::node::Node* LoadThrowTypeError(son::node::Node* ctx) {
    return LoadByteOffset(son::node::MachineType::kInt64, ctx,
                          AccessBuilder::throw_type_error_offset());
  }
  son::node::Node* LoadInitialObjectShape(son::node::Node* ctx) {
    return LoadByteOffset(son::node::MachineType::kRawType, ctx,
                          AccessBuilder::object_shape_offset());
  }
  son::node::Node* LoadObjectCtxCheck(son::node::Node* ctx) {
    return LoadByteOffset(son::node::MachineType::kInt8, ctx,
                          AccessBuilder::object_ctx_check_offset());
  }
  son::node::Node* LoadRtClassArray(son::node::Node* obj) {
    auto offset = AccessBuilder::rt_class_array_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }
  son::node::Node* LoadRtAtomArray(son::node::Node* rt) {
    return LoadByteOffset(son::node::MachineType::kRawType, rt,
                          AccessBuilder::rt_atom_array_offset());
  }
  son::node::Node* LoadDispatchTable(son::node::Node* obj) {
    auto offset = AccessBuilder::dispatch_table_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }
  son::node::Node* LoadCurrentStackFrame(son::node::Node* obj) {
    auto offset = AccessBuilder::current_stack_frame_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }

  son::node::Node* LoadCurrentException(son::node::Node* obj) {
    auto offset = AccessBuilder::current_exception_offset();
    return LoadByteOffset(son::node::MachineType::kInt64, obj, offset);
  }

  void StoreCurrentException(son::node::Node* obj, son::node::Node* val) {
    auto offset = AccessBuilder::current_exception_offset();
    return StoreByteOffset(son::node::MachineType::kInt64, obj, offset, val);
  }

  son::node::Node* LoadConMarkState(son::node::Node* ctx) {
    auto offset = AccessBuilder::con_mark_state_offset();
    return LoadByteOffset(son::node::MachineType::kInt8, ctx, offset);
  }

  son::node::Node* LoadExceptionNeedsBacktrace(son::node::Node* obj) {
    auto offset = AccessBuilder::exception_needs_backtrace_offset();
    return LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
  }

  son::node::Node* LoadAsyncStackThrowFlag(son::node::Node* obj) {
    auto offset = AccessBuilder::async_stack_throw_flag_offset();
    return LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
  }

  son::node::Node* LeapAsyncStackFrame(son::node::Node* obj) {
    auto offset = AccessBuilder::async_stack_frame_offset();
    return CastToRaw(IntPtrAdd(obj, IntPtrValue(offset)));
  }

  son::node::Node* LoadHomeObject(son::node::Node* obj) {
    auto offset = AccessBuilder::object_home_object_offset();
    return LoadByteOffset(son::node::MachineType::kInt64, obj, offset);
  }

  void StoreCurrentStackFrame(son::node::Node* obj, son::node::Node* val) {
    auto offset = AccessBuilder::current_stack_frame_offset();
    StoreByteOffset(son::node::MachineType::kRawType, obj, offset, val);
  }

  void StoreListPrev(son::node::Node* obj, son::node::Node* val) {
    auto offset = AccessBuilder::list_prev_offset();
    StoreByteOffset(son::node::MachineType::kRawType, obj, offset, val);
  }

  void StoreListNext(son::node::Node* obj, son::node::Node* val) {
    auto offset = AccessBuilder::list_next_offset();
    StoreByteOffset(son::node::MachineType::kRawType, obj, offset, val);
  }

  son::node::Node* LoadBytecodeLen(son::node::Node* obj) {
    auto offset = AccessBuilder::bytecode_len_offset();
    return LoadByteOffset(son::node::MachineType::kInt32, obj, offset);
  }
  son::node::Node* LoadFunctionBytecode(son::node::Node* obj) {
    auto offset = AccessBuilder::function_bytecode_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }
  son::node::Node* LoadArgCount(son::node::Node* obj) {
    auto offset = AccessBuilder::arg_count_offset();
    return LoadByteOffset(son::node::MachineType::kInt16, obj, offset);
  }
  son::node::Node* LoadVarCount(son::node::Node* obj) {
    auto offset = AccessBuilder::var_count_offset();
    return LoadByteOffset(son::node::MachineType::kInt16, obj, offset);
  }
  son::node::Node* LoadStackSize(son::node::Node* obj) {
    auto offset = AccessBuilder::stack_size_offset();
    return LoadByteOffset(son::node::MachineType::kInt16, obj, offset);
  }
  son::node::Node* LoadJsMode(son::node::Node* obj) {
    auto offset = AccessBuilder::js_mode_offset();
    return LoadByteOffset(son::node::MachineType::kInt8, obj, offset);
  }
  son::node::Node* LoadFunctionFlags(son::node::Node* obj) {
    auto offset = AccessBuilder::function_flags_offset();
    return LoadByteOffset(son::node::MachineType::kInt8, obj, offset);
  }
  son::node::Node* LoadBytecodeBuf(son::node::Node* obj) {
    auto offset = AccessBuilder::codes_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }
  son::node::Node* LoadBytecodeConstantPool(son::node::Node* obj) {
    auto offset = AccessBuilder::constants_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }
  son::node::Node* LoadCpool(son::node::Node* func_bytecode) {
    auto cpool = LoadBytecodeConstantPool(func_bytecode);
    return cpool;
  }
  son::node::Node* LoadListPrev(son::node::Node* val) {
    auto offset = AccessBuilder::list_prev_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, val, offset);
  }
  son::node::Node* LoadListNext(son::node::Node* val) {
    auto offset = AccessBuilder::list_next_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, val, offset);
  }
  son::node::Node* LoadJSStackLimit(son::node::Node* obj) {
    auto offset = AccessBuilder::js_stack_limit_offset();
    return LoadByteOffset(son::node::MachineType::kIntptr, obj, offset);
  }

  son::node::Node* LoadJSStack(son::node::Node* obj) {
    auto offset = AccessBuilder::js_stack_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, obj, offset);
  }

  void StoreJSStack(son::node::Node* obj, son::node::Node* new_stack) {
    auto offset = AccessBuilder::js_stack_offset();
    StoreByteOffset(son::node::MachineType::kRawType, obj, offset, new_stack);
  }

  son::node::Node* LoadLepusVal(son::node::Node* sp, son::node::Node* index) {
    return LoadImpl(son::node::MachineType::kInt64, sp, index);
  }

  void StoreLepusVal(son::node::Node* sp, son::node::Node* index,
                     son::node::Node* value) {
    StoreImpl(son::node::MachineType::kInt64, sp, index, value);
  }
  void StoreHeapVal(son::node::Node* ctx, son::node::Node* sp,
                    son::node::Node* index, son::node::Node* value) {
    StoreHeapObject(ctx, sp, index, value);
  }

  int IntPtrSizeInt() { return Is32Bit() ? sizeof(int) : sizeof(int64_t); }

  son::node::Node* LoadRawValPOffset(son::node::Node* sp,
                                     son::node::Node* offset) {
    return LoadImpl(son::node::MachineType::kRawType, sp, offset);
  }

  son::node::Node* LoadRawVal(son::node::Node* sp, son::node::Node* index) {
    return LoadImpl(son::node::MachineType::kRawType, sp, index);
  }
  son::node::Node* LoadIntVal(son::node::Node* sp, son::node::Node* index) {
    return LoadImpl(son::node::MachineType::kInt32, sp, index);
  }

  son::node::Node* LoadRawVal(son::node::Node* sp, int offset) {
    return LoadByteOffset(son::node::MachineType::kRawType, sp, offset);
  }

  void CopyArgs(son::node::Node* local_buf, son::node::Node* buf_end,
                son::node::Node* argv);
  void CopyHeapArgs(son::node::Node* ctx, son::node::Node* local_buf,
                    son::node::Node* buf_end, son::node::Node* argv);
  void CopyArgsUndefined(son::node::Node* local_buf, son::node::Node* buf_end);

  son::node::Node* LoadByteOffset(son::node::MachineType type,
                                  son::node::Node* object, int byte_offset) {
    vmassert(object->type()->machine_type() == son::node::MachineType::kRawType,
             "must be");
    FieldAccess access(type, byte_offset, Is32Bit());
    return LoadImpl(type, object, IntValue(access.offset()));
  }

  void StoreByteOffset(son::node::MachineType type, son::node::Node* object,
                       int byte_offset, son::node::Node* value) {
    FieldAccess access(type, byte_offset, Is32Bit());
    return Store(type, object, IntValue(access.offset()), value);
  }

  void StoreIntPtrValue(son::node::Node* object, int offset,
                        son::node::Node* value) {
    StoreImpl(son::node::MachineType::kIntptr, object, IntValue(offset), value);
  }

  son::node::Node* LoadIntPtrValue(son::node::Node* object, int offset) {
    return LoadImpl(son::node::MachineType::kIntptr, object, IntValue(offset));
  }

  void SaveValue(son::node::Node* v1) {
    auto rsp = SaveStack();
    auto rsp_int = CastRawToIntPtr(rsp);
    StoreIntPtrValue(rsp, -2, v1);
    auto new_sp = CastToRaw(IntPtrSub(rsp_int, IntPtrValue(2 * intptr_size())));
    RestoreStack(new_sp);
  }

  son::node::Node* RestoreValue() {
    auto rsp = SaveStack();
    auto rsp_int = CastRawToIntPtr(rsp);
    son::node::MachineType type = Is32Bit() ? son::node::MachineType::kInt32
                                            : son::node::MachineType::kInt64;
    auto v1 = LoadImpl(type, rsp, IntValue(0));
    auto new_sp = CastToRaw(IntPtrAdd(rsp_int, IntPtrValue(2 * intptr_size())));
    RestoreStack(new_sp);
    return v1;
  }

  void Store(son::node::MachineType type, son::node::Node* object,
             son::node::Node* offset, son::node::Node* value);
  void StoreHeapObject(son::node::Node* ctx, son::node::Node* object,
                       son::node::Node* offset, son::node::Node* value);
  void StoreShapeRef(son::node::Node* ctx, son::node::Node* object,
                     son::node::Node* shape);
  void StoreHeapObject(son::node::Node* ctx, son::node::Node* object,
                       int byte_offset, son::node::Node* value) {
    FieldAccess access(son::node::MachineType::kObject, byte_offset, Is32Bit());
    StoreHeapObject(ctx, object, IntValue(access.offset()), value);
  }
  void WriteBarrier(son::node::Node* ctx, son::node::Node* obj,
                    son::node::Node* offset, son::node::Node* value);
};

}  // namespace primjs
#endif  // PRIMJS_CODE_ASSEMBLER_H
