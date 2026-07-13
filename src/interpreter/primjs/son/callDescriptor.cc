/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#include "primjs/son/callDescriptor.h"

#include "primjs/codegen/bytecode.h"

#define REPEAT_6(V, T) \
  V(T) V(T, T) V(T, T, T) V(T, T, T, T) V(T, T, T, T, T) V(T, T, T, T, T, T)

namespace son {
namespace node {

#define INSTANTIATE(...)                                           \
  template CallDescriptorData* CallDescriptors::CreateP(           \
      const CallDescriptor& desc, const char* name, MachineType r, \
      __VA_ARGS__);
REPEAT_6(INSTANTIATE, MachineType)
#undef INSTANTIATE

template <class... Args>
CallDescriptorData* CallDescriptors::CreateP(const CallDescriptor& desc,
                                             const char* name, MachineType r,
                                             Args... args) {
  MachineType argv[] = {args...};
  int argc = sizeof...(args);
  vmassert(_call_desc_map.find(desc) == _call_desc_map.end(), "must be");
  auto res = new (zone()) CallDescriptorData(desc, MachineType::kNone, zone());
  int length = strlen(name);
  auto buffer = zone()->alloc_array<char>(length + 1);
  memcpy(buffer, name, length);
  buffer[length] = '\0';
  res->set_func_name(buffer);
  res->set_return_type(r);
  for (int i = 0; i < argc; i++) {
    res->add_param_type(argv[i]);
  }
  _call_desc_map[desc] = res;
  return res;
}

void CallDescriptors::SetVarArg(CallDescriptorData* data) {
  switch (data->call_index()) {
#define DEF_VAR_ARG_DESC(name, ...)       \
  case static_cast<int>(CallId::k##name): \
    data->set_var_arg();                  \
    break;
#include "primjs/son/vmTrampoline.def"
    default:
      break;
  }
}

void CallDescriptors::InitCallDescriptors() {
  CallDescriptorData* data = nullptr;
#define DEF_CALL_DESC(name, ...)                \
  data = Create##name(CallDescriptors::name()); \
  SetVarArg(data);
#include "primjs/son/vmTrampoline.def"

  InitCallBcHandler(CallKind::kBcHandler, "bc_handler_asm_h", -1);
}

CallDescriptorData* CallDescriptors::InitCallBcHandler(CallKind kind,
                                                       const char* name,
                                                       int call_index) {
  auto desc = CallDescriptors::CallBcHandler(kind, call_index);
  return CreateP(desc, name, MachineType::kNone, MachineType::kRawType,
                 MachineType::kRawType);
}

CallDescriptorData* CallDescriptors::Get(const CallDescriptor& desc) {
  auto it = _call_desc_map.find(desc);
  auto res = it->second;
  if ((it == _call_desc_map.end()) && (desc.is_bc_handler0())) {
    vmassert(desc.call_index() >= 0, "bc handler must have call index");
    vmassert(desc.call_index() <= 0xFF, "call index too large");
    bool is_handler1 = desc.kind() == CallKind::kBcHandler1;
    bool is_handler2 = desc.kind() == CallKind::kBcHandler2;
    std::string name;
    primjs::get_bc_handler_name(desc.call_index(), name);
    name += is_handler1 ? "_1_asm_h" : (is_handler2 ? "_2_asm_h" : "_0_asm_h");
    InitCallBcHandler(desc.kind(), name.c_str(), desc.call_index());
    res = _call_desc_map[desc];
  }
  return res;
}

#define DEF_CALL_DESC_0(name, k, f, r)               \
  CallDescriptorData* CallDescriptors::Create##name( \
      const CallDescriptor& desc) {                  \
    return CreateP(desc, #name, MachineType::r);     \
  }
#define DEF_CALL_DESC_1(name, k, f, r, p)                        \
  CallDescriptorData* CallDescriptors::Create##name(             \
      const CallDescriptor& desc) {                              \
    return CreateP(desc, #name, MachineType::r, MachineType::p); \
  }
#define DEF_CALL_DESC_2(name, k, f, r, p1, p2)                   \
  CallDescriptorData* CallDescriptors::Create##name(             \
      const CallDescriptor& desc) {                              \
    return CreateP(desc, #name, MachineType::r, MachineType::p1, \
                   MachineType::p2);                             \
  }
#define DEF_CALL_DESC_3(name, k, f, r, p1, p2, p3)               \
  CallDescriptorData* CallDescriptors::Create##name(             \
      const CallDescriptor& desc) {                              \
    return CreateP(desc, #name, MachineType::r, MachineType::p1, \
                   MachineType::p2, MachineType::p3);            \
  }
#define DEF_CALL_DESC_4(name, k, f, r, p1, p2, p3, p4)                 \
  CallDescriptorData* CallDescriptors::Create##name(                   \
      const CallDescriptor& desc) {                                    \
    return CreateP(desc, #name, MachineType::r, MachineType::p1,       \
                   MachineType::p2, MachineType::p3, MachineType::p4); \
  }
#define DEF_CALL_DESC_5(name, k, f, r, p1, p2, p3, p4, p5)            \
  CallDescriptorData* CallDescriptors::Create##name(                  \
      const CallDescriptor& desc) {                                   \
    return CreateP(desc, #name, MachineType::r, MachineType::p1,      \
                   MachineType::p2, MachineType::p3, MachineType::p4, \
                   MachineType::p5);                                  \
  }
#define DEF_CALL_DESC_6(name, k, f, r, p1, p2, p3, p4, p5, p6)        \
  CallDescriptorData* CallDescriptors::Create##name(                  \
      const CallDescriptor& desc) {                                   \
    return CreateP(desc, #name, MachineType::r, MachineType::p1,      \
                   MachineType::p2, MachineType::p3, MachineType::p4, \
                   MachineType::p5, MachineType::p6);                 \
  }
#define DEF_CALL_DESC_7(name, k, f, r, p1, p2, p3, p4, p5, p6, p7)     \
  CallDescriptorData* CallDescriptors::Create##name(                   \
      const CallDescriptor& desc) {                                    \
    return CreateP(desc, #name, MachineType::r, MachineType::p1,       \
                   MachineType::p2, MachineType::p3, MachineType::p4,  \
                   MachineType::p5, MachineType::p6, MachineType::p7); \
  }
#include "primjs/son/vmTrampoline.def"

}  // namespace node
}  // namespace son
