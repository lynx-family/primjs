/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_SON_CALL_DESCRIPTOR_H
#define PRIMJS_SON_CALL_DESCRIPTOR_H

#include <memory>

#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"
#include "primjs/son/node.h"

namespace son {
namespace node {

enum class CallKind {
  kNone,
  kRuntime,
  kStub,
  kBcHandler,
  kBcHandler1,
  kBcHandler2,
  kCallHandler,
  kRTS,
};

enum class RTSCallArgIndex : int32_t {
  kThread = -1,
  kCalleeMethod = -2,
  kCallerEnv = -3,
  kNumArgs = 3,
};

enum class CallId : uint8_t {
// runtime
#define DEF_CALL_DESC(name, ...) k##name,
#include "primjs/son/vmTrampoline.def"
  kCount,
};

class CallDescriptor {
 public:
  CallKind _kind;
  MetaFlags _meta_flags;
  bool _tail_call;
  bool _is_var_arg;
  int _call_index;

  CallDescriptor()
      : _kind(CallKind::kNone),
        _meta_flags(MetaFlags::kNone),
        _tail_call(false),
        _is_var_arg(false),
        _call_index(-1) {}
  CallDescriptor(CallKind kind, MetaFlags meta_flags, int call_index)
      : _kind(kind),
        _meta_flags(meta_flags),
        _tail_call(false),
        _is_var_arg(false),
        _call_index(call_index) {}

  CallDescriptor(CallKind kind, MetaFlags meta_flags, bool tail_call,
                 bool is_var_arg, int call_index)
      : _kind(kind),
        _meta_flags(meta_flags),
        _tail_call(tail_call),
        _is_var_arg(is_var_arg),
        _call_index(call_index) {}

  CallDescriptor(const CallDescriptor& other)
      : _kind(other._kind),
        _meta_flags(other._meta_flags),
        _tail_call(other._tail_call),
        _is_var_arg(other._is_var_arg),
        _call_index(other._call_index) {}

  void operator=(const CallDescriptor& other) {
    _kind = other._kind;
    _meta_flags = other._meta_flags;
    _tail_call = other._tail_call;
    _is_var_arg = other._is_var_arg;
    _call_index = other._call_index;
  }
  bool operator==(const CallDescriptor& other) const {
    return _kind == other._kind && _call_index == other._call_index;
  }
  bool operator!=(const CallDescriptor& other) const {
    return !(*this == other);
  }
  bool operator<(const CallDescriptor& other) const {
    return _kind < other._kind ||
           (_kind == other._kind && _call_index < other._call_index);
  }
  bool operator>(const CallDescriptor& other) const { return other < *this; }
  int call_index() const { return _call_index; }
  CallKind kind() const { return _kind; }
  MetaFlags meta_flags() const { return _meta_flags; }
  bool is_bc_handler0() const {
    return (_kind == CallKind::kBcHandler) ||
           (_kind == CallKind::kBcHandler1) || (_kind == CallKind::kBcHandler2);
  }
  bool is_bc_handler() const { return is_bc_handler0() || is_call_handler(); }
  bool is_call_handler() const { return _kind == CallKind::kCallHandler; }
};

class CallDescriptorData : public base::ZoneObject {
 private:
  CallDescriptor _desc;
  MachineType _return_type;
  base::ZoneVector<MachineType> _machine_types;
  const char* _func_name;

 public:
  explicit CallDescriptorData(const CallDescriptor& desc,
                              MachineType return_type, base::Zone* zone)
      : _desc(desc), _return_type(return_type), _machine_types(zone) {}

  MachineType param_type(int index) const { return _machine_types.at(index); }

  MachineType return_type() const { return _return_type; }

  void set_return_type(MachineType type) { _return_type = type; }
  CallDescriptor descriptor() const { return _desc; }

  void add_param_type(MachineType type) { _machine_types.push_back(type); }

  CallKind kind() const { return _desc.kind(); }
  bool is_bc_handler() const { return _desc.is_bc_handler(); }
  bool is_call_handler() const { return _desc.is_call_handler(); }
  bool is_bc_handler0() const { return _desc.is_bc_handler0(); }

  int param_count() const { return static_cast<int>(_machine_types.size()); }

  int call_index() const { return _desc.call_index(); }

  void set_var_arg() { _desc._is_var_arg = true; }

  bool is_is_var_arg() const { return _desc._is_var_arg; }

  void set_tail_call() { _desc._tail_call = true; }

  bool is_tail_call() const { return _desc._tail_call; }

  void set_func_name(const char* name) { _func_name = name; }
  const char* func_name() const { return _func_name; }
};

class CallDescriptors {
 private:
  base::Zone* _zone;
  base::ZoneMap<CallDescriptor, CallDescriptorData*> _call_desc_map;

 public:
  CallDescriptors(base::Zone* zone) : _zone(zone), _call_desc_map(zone) {}

  CallDescriptorData* InitCallBcHandler(CallKind kind, const char* name,
                                        int call_index);
  void InitCallDescriptors();
  CallDescriptorData* Get(const CallDescriptor& desc);
  static const CallDescriptor CallBcHandler(CallKind kind, int index = -1) {
    return CallDescriptor{kind, MetaFlags::kThrow, true, false, index};
  }
  static const CallDescriptor DefaultCallBcHandler() {
    return CallDescriptor{CallKind::kBcHandler, MetaFlags::kThrow, true, false,
                          -1};
  }
  static const CallDescriptor CallHandlerBcHandler(int index = -1) {
    return CallDescriptor{CallKind::kCallHandler, MetaFlags::kThrow, true,
                          false, index};
  }
  static const CallDescriptor ExtCallBcHandler(int index = -1) {
    return CallDescriptor{CallKind::kBcHandler, MetaFlags::kThrow, true, false,
                          index};
  }
#define DEF_CALL_DESC(name, kind, flags, ...)                   \
  CallDescriptorData* Create##name(const CallDescriptor& desc); \
  static const CallDescriptor name() {                          \
    return CallDescriptor(CallKind::kind, MetaFlags::k##flags,  \
                          static_cast<int>(CallId::k##name));   \
  }
#include "primjs/son/vmTrampoline.def"

  template <class... Args>
  CallDescriptorData* CreateP(const CallDescriptor& desc, const char* name,
                              MachineType r, Args... args);

  base::Zone* zone() { return _zone; }

  static void SetVarArg(CallDescriptorData* data);
};

std::ostream& operator<<(std::ostream& os, const CallKind& kind);
std::ostream& operator<<(std::ostream& os, const CallDescriptor& info);

}  // namespace node
}  // namespace son
#endif  // PRIMJS_SON_CALL_DESCRIPTOR_H
