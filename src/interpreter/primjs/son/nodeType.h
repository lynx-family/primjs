/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_SON_NODE_TYPE_H
#define PRIMJS_SON_NODE_TYPE_H

#include "primjs/base/bit_field.h"
#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"

namespace base {
class InstanceKlass;
}

namespace son {

namespace node {

enum class TypeKind {
  kRaw,
  kInternal,
};

enum class MachineType : uint8_t {
  kNone,
  kBool,
  kInt8,
  kInt16,
  kInt32,
  kInt64,
  kIntptr,
  kFloat64,
  kObject,
  kRawType,
  kMetaType,
  kAny
};

static bool is_pointer_type(MachineType type) {
  return type == MachineType::kObject || type == MachineType::kMetaType ||
         type == MachineType::kRawType;
}

static int machine_type_to_element_width(MachineType type, bool is_32bit) {
  switch (type) {
    case MachineType::kBool:
    case MachineType::kInt8:
      return 1;
    case MachineType::kInt16:
      return 2;
    case MachineType::kInt32:
      return 4;
    case MachineType::kIntptr:
    case MachineType::kObject:
    case MachineType::kMetaType:
    case MachineType::kRawType:
      return is_32bit ? 4 : 8;
    case MachineType::kInt64:
    case MachineType::kFloat64:
      return 8;
    default:
      unreachable();
  }
  return 0;
}

class NodeType : public base::ZoneObject {
 public:
  TypeKind _type_kind;
  MachineType _machine_type;
  union {
    int _type_idx;
    uint64_t _type_value;
  };

  NodeType(MachineType m_type)
      : _type_kind(TypeKind::kRaw), _machine_type(m_type), _type_idx(-1) {}

  MachineType machine_type() const { return _machine_type; }

  int type_index() const { return _type_idx; }
  bool is_int() const { return _machine_type == MachineType::kInt32; }
  bool is_long() const { return _machine_type == MachineType::kInt64; }
  bool is_boolean() const { return _machine_type == MachineType::kBool; }
  bool is_internal() const { return _type_kind == TypeKind::kInternal; }
  static NodeType* AnyType() {
    static NodeType any_type = {MachineType::kAny};
    return &any_type;
  }
  static NodeType* IntType() {
    static NodeType int_type = {MachineType::kInt32};
    return &int_type;
  }
  static NodeType* Int8Type() {
    static NodeType int_type = {MachineType::kInt8};
    return &int_type;
  }
  static NodeType* Int16Type() {
    static NodeType int_type = {MachineType::kInt16};
    return &int_type;
  }
  static NodeType* BooleanType() {
    static NodeType boolean_type = {MachineType::kBool};
    return &boolean_type;
  }
  static NodeType* DoubleType() {
    static NodeType double_type = {MachineType::kFloat64};
    return &double_type;
  }
  static NodeType* LongType() {
    static NodeType long_type = {MachineType::kInt64};
    return &long_type;
  }
  static NodeType* Int64Type() { return LongType(); }
  static NodeType* RptrType() { return IntptrType(); }

  static NodeType* IntptrType() {
    static NodeType ptr_type = {MachineType::kIntptr};
    return &ptr_type;
  }

  static NodeType* MetaType() {
    static NodeType ptr_type = {MachineType::kMetaType};
    return &ptr_type;
  }

  static NodeType* RawType() {
    static NodeType ptr_type = {MachineType::kRawType};
    return &ptr_type;
  }

  static NodeType* ObjectType() {
    static NodeType ptr_type = {MachineType::kObject};
    return &ptr_type;
  }

  static NodeType* StringType() {
    static NodeType string_type = {MachineType::kObject};
    return &string_type;
  }

  static NodeType* MirrorType() {
    static NodeType class_type = {MachineType::kObject};
    return &class_type;
  }

  static NodeType* NilType() {
    static NodeType nil_type = {MachineType::kObject};
    return &nil_type;
  }

  static NodeType* NoneType() {
    static NodeType none_type = {MachineType::kNone};
    return &none_type;
  }

  bool operator==(const NodeType& other) const {
    return _type_kind == other._type_kind && _type_value == other._type_value;
  }

  bool operator!=(const NodeType& other) const { return !(*this == other); }

  bool is_raw_object_type() const {
    return this == ObjectType() || this == AnyType();
  }

  bool is_raw() const { return _type_kind == TypeKind::kRaw; }

  static NodeType* GetNodeType(MachineType type) {
    switch (type) {
      case MachineType::kInt8:
        return Int8Type();
      case MachineType::kInt16:
        return Int16Type();
      case MachineType::kInt32:
        return IntType();
      case MachineType::kBool:
        return BooleanType();
      case MachineType::kInt64:
        return LongType();
      case MachineType::kFloat64:
        return DoubleType();
      case MachineType::kIntptr:
        return IntptrType();
      case MachineType::kMetaType:
        return MetaType();
      case MachineType::kRawType:
        return RawType();
      case MachineType::kObject:
        return ObjectType();
      case MachineType::kAny:
        return AnyType();
      case MachineType::kNone:
        return NoneType();
      default:
        unreachable();
    }
    return nullptr;
  }
};

class TypeKey {
 private:
  uint64_t _key;
  using TagBitField = base::BitField<int, 0, 1, uint64_t>;
  using BasicTypeField = TagBitField::Next<MachineType, 8>;
  using TypeIndexField = BasicTypeField::Next<int, 32>;

 public:
  TypeKey(base::InstanceKlass* klass)
      : _key(reinterpret_cast<uintptr_t>(klass)) {}

  TypeKey(MachineType type, int type_idx)
      : _key(TagBitField::encode(1) | BasicTypeField::encode(type) |
             TypeIndexField::encode(type_idx)) {}

  uint64_t key() const { return _key; }
};

}  // namespace node
}  // namespace son
#endif  // PRIMJS_SON_NODE_TYPE_H
