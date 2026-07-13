// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_SON_COMPILATION_OPTIONS_H
#define PRIMJS_SON_COMPILATION_OPTIONS_H

#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"

namespace son {

enum class TargetArch : uint32_t {
  kX86 = 0,
  kARM = 1,
  kMIPS = 2,
  kRISCV = 3,
  kX64 = 4,
  kAARCH64 = 5,
  kMIPS64 = 6,
  kRISCV64 = 7,
  k32Start = TargetArch::kX86,
  k32End = TargetArch::kRISCV,
};

class CompilationOptions {
 public:
  enum Flag {
    kTraceLog = 1 << 1,
    kDebugTrace = 1 << 2,
    kHost = 1 << 3,
    kSupportMutiTable = 1 << 4,
    kSupportDebugger = 1 << 5,
    kSupportVirtualSp = 1 << 6,
    kUseFastPath = 1 << 7,
  };

  CompilationOptions() : _flags(0), _target_arch(TargetArch::kAARCH64) {}

  void SetTargetArch(TargetArch arch) { _target_arch = arch; }

  TargetArch GetTargetArch() const { return _target_arch; }

  bool GetFlag(Flag flag) const { return (_flags & flag) != 0; }
  void SetFlag(Flag flag) { _flags |= flag; }
  void ClearFlag(Flag flag) { _flags &= ~flag; }
  bool TraceLog() const { return GetFlag(kTraceLog); }
  bool IsHost() const { return GetFlag(kHost); }
  bool IsDebugTrace() const { return GetFlag(kDebugTrace); }
  bool SupportMultiTable() const { return GetFlag(kSupportMutiTable); }
  bool SupportDebugger() const { return GetFlag(kSupportDebugger); }
  bool SupportVirtualSp() const { return GetFlag(kSupportVirtualSp); }
  bool UseFastPath() const { return GetFlag(kUseFastPath); }

  bool Is32Bit() const {
    auto value = static_cast<uint32_t>(_target_arch);
    return value >= static_cast<uint32_t>(TargetArch::k32Start) &&
           value <= static_cast<uint32_t>(TargetArch::k32End);
  }

 private:
  uint32_t _flags;
  TargetArch _target_arch;
};

}  // namespace son
#endif  // PRIMJS_SON_COMPILATION_OPTIONS_H
