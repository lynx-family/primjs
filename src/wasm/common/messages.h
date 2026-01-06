// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_MESSAGES_H_
#define SRC_WASM_COMMON_MESSAGES_H_

namespace primjs {

class ErrorMessages {
 public:
#define MESSAGE_TEMPLATE(T)                                               \
  T(DescriptorNeeded, "Argument 0 must be a descriptor")                  \
  T(InternalError, "An internal webassembly error occurred.")             \
  T(ArrayBufferNeeded, "Argument 0 must be a buffer source")              \
  T(CreatingModuleFailed, "Creating Wasm Module failed.")                 \
  T(ModuleNeeded, "Argument 0 must be a WebAssembly.Module")              \
  T(InstantiationFailed, "WebAssembly Instantiation failed.")             \
  T(NoConvertibleNum, "Argument 0 must be convertible to a valid number") \
  T(NoNegative, "Argument 0 must be non-negative")                        \
  T(GrowFailed, "Grow failed.")                                           \
  T(InvalidArgs, "invalid argv.")                                         \
  T(ModifyImmutable, "Can't set the value of an immutable global.")       \
  T(InvalidTableLimits, "invalid table limits, max is 100000.")           \
  T(InvalidTableIndex, "invalid index into function table")               \
  T(OutOfBoundOperation, "operation out of boundary.")                    \
  T(MemoryAllocFailed, "Memory allocation failed.")                       \
  T(InvalidInitialSize, "Invalid initial size in Descriptor.")            \
  T(UnsupportedElemType,                                                  \
    "Descriptor property 'element' must be a WebAssembly reference type") \
  T(InvalidTableElem, "Argument 1's type is invalid for table")           \
  T(OSVersionUnsupported,                                                 \
    "Such operation is not supported on this version yet.")

#define DEF_MESSAGES(NAME, STRING)                               \
  static constexpr const char* k##NAME##_1001 = "[1001]" STRING; \
  static constexpr const char* k##NAME##_1002 = "[1002]" STRING; \
  static constexpr const char* k##NAME##_1003 = "[1003]" STRING; \
  static constexpr const char* k##NAME##_1004 = "[1004]" STRING; \
  static constexpr const char* k##NAME##_1005 = "[1005]" STRING; \
  static constexpr const char* k##NAME##_1006 = "[1006]" STRING; \
  static constexpr const char* k##NAME##_1007 = "[1007]" STRING; \
  static constexpr const char* k##NAME##_1008 = "[1008]" STRING; \
  static constexpr const char* k##NAME##_1009 = "[1009]" STRING; \
  static constexpr const char* k##NAME##_1010 = "[1010]" STRING;

  MESSAGE_TEMPLATE(DEF_MESSAGES)
#undef DEF_MESSAGES

#undef MESSAGE_TEMPLATE
};

}  // namespace primjs

#endif  // SRC_WASM_COMMON_MESSAGES_H_
