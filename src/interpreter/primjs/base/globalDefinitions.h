/*
 * Copyright (c) 2024 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_GLOBALDEFINITIONS_H
#define PRIMJS_GLOBALDEFINITIONS_H

#include <inttypes.h>
#include <stdlib.h>

#include "primjs/base/debug.h"
#include "primjs/base/globalDefinitions.h"
#include "primjs/base/macros.h"

// Platform-specific definitions.
#ifdef _LP64
const int LogHeapWordSize = 3;
const int LogBytesPerWord = 3;
#define INTPTR_FORMAT "0x%016" PRIxPTR
#define PTR_FORMAT "0x%016" PRIxPTR
#else
const int LogHeapWordSize = 2;
const int LogBytesPerWord = 2;
#define INTPTR_FORMAT "0x%08" PRIxPTR
#define PTR_FORMAT "0x%08" PRIxPTR
#endif  // _LP64

struct AllStatic {
  AllStatic() = delete;
  ~AllStatic() = delete;
};

const int HeapWordSize = sizeof(uintptr_t);
const int metaSize = sizeof(uintptr_t);

typedef uint32_t PRIMJS_uint;
const int LogBitsPerByte = 3;
const int LogBitsPerWord = LogBitsPerByte + LogBytesPerWord;
const int BitsPerByte = 1 << LogBitsPerByte;
const int BitsPerWord = 1 << LogBitsPerWord;

enum ClassSignatureType : uint8_t {
  kTupleClass,
  kClass,
  kObjectLiteralClass,
  kArrayClass,
  kClosureClass,
  kClosureEnvClass,
  kPrimitive,
};

inline intptr_t p2i(const void *p) { return (intptr_t)p; }

constexpr uint64_t kQuietNaNMask = static_cast<uint64_t>(0xfff) << 51;
constexpr uint64_t kDoubleSignMask = 0x8000'0000'0000'0000;

const int kMaxInt = 0x7FFFFFFF;
const int kMinInt = -kMaxInt - 1;

const int MILLIUNITS = 1000;       // milli units per base unit
const int MICROUNITS = 1000000;    // micro units per base unit
const int NANOUNITS = 1000000000;  // nano units per base unit
const int NANOUNITS_PER_MILLIUNIT = NANOUNITS / MILLIUNITS;

const size_t K = 1024;
const size_t M = K * K;
const size_t G = M * K;
const size_t HWperKB = K / sizeof(intptr_t);

const intptr_t OneBit = 1;
#define nth_bit(n) (((n) >= BitsPerWord) ? 0 : (OneBit << (n)))
#define right_n_bits(n) (nth_bit(n) - 1)
// ES6 section 20.1.2.6 Number.MAX_SAFE_INTEGER
constexpr uint64_t kMaxSafeIntegerUint64 = 9007199254740991;  // 2^53-1
static_assert(kMaxSafeIntegerUint64 == (uint64_t{1} << 53) - 1);
constexpr double kMaxSafeInteger = static_cast<double>(kMaxSafeIntegerUint64);
// ES6 section 21.1.2.8 Number.MIN_SAFE_INTEGER
constexpr double kMinSafeInteger = -kMaxSafeInteger;

const int rintAsStringSize = 12;

#define DEFAULT_STACK_SIZE 960 * K
// maximum stack size 1GB
#define MAX_STACK_SIZE 1 * G

#endif  // PRIMJS_GLOBALDEFINITIONS_H
