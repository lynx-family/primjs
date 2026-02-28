#ifndef SRC_GC_STRUCTS_H_
#define SRC_GC_STRUCTS_H_

#include <functional>
#include <vector>

#include "gc/sizes.h"

#if defined(FUTURE_OPTIMIZE) && defined(__ARM_NEON)
#include <arm_neon.h>
#endif  // FUTURE_OPTIMIZE && defined(__ARM_NEON)

namespace ROS_GC {
enum HeapObjType {
  kHeapObjTypeRun = 0,
  kHeapObjTypeLarge,
  kHeapObjTypeHuge,
  kInvalidType
};
using WorkStack = OriGCWorkStack;
using RootSet = OriGCWorkStack;
using HeapAliveObjsVisitor = const std::function<void(HeapObjType, address_t)>;
#if defined(FUTURE_OPTIMIZE) && defined(__ARM_NEON)
constexpr int kDeltaAlign = 16;
#else
constexpr int kDeltaAlign = 8;
#endif  // FUTURE_OPTIMIZE && defined(__ARM_NEON)
#ifdef FUTURE_OPTIMIZE
#if defined(__ARM_NEON)
using ContinuousPageTypes = uint8x16_t;
#else
using ContinuousPageTypes = uint64_t;
#endif  // defined(__ARM_NEON)
#endif  // FUTURE_OPTIMIZE
}  // namespace ROS_GC

#endif  // SRC_GC_STRUCTS_H_
