// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <gtest/gtest.h>

#include <cstdint>
#include <set>
#include <vector>

#include "gc/pointer_set.h"

namespace heap_test {

static void *FakePointer(uintptr_t i) {
  return reinterpret_cast<void *>((i + 1) * 16);
}

static std::set<void *> Contents(const ROS_GC::PointerSet &set) {
  std::set<void *> contents;
  set.ForEach([&contents](void *ptr) { contents.insert(ptr); });
  return contents;
}

TEST(PointerSetTest, InsertIgnoresDuplicates) {
  ROS_GC::PointerSet set;
  EXPECT_TRUE(set.Insert(FakePointer(1)));
  EXPECT_FALSE(set.Insert(FakePointer(1)));
  EXPECT_EQ(set.Size(), 1u);
}

TEST(PointerSetTest, KeepsAllPointersAcrossGrowth) {
  ROS_GC::PointerSet set;
  std::set<void *> expected;
  for (uintptr_t i = 0; i < 10000; ++i) {
    set.Insert(FakePointer(i));
    expected.insert(FakePointer(i));
  }
  EXPECT_EQ(set.Size(), expected.size());
  EXPECT_EQ(Contents(set), expected);
}

TEST(PointerSetTest, RetainIfDropsRejectedPointers) {
  ROS_GC::PointerSet set;
  for (uintptr_t i = 0; i < 1000; ++i) set.Insert(FakePointer(i));

  std::set<void *> expected;
  for (uintptr_t i = 0; i < 1000; i += 2) expected.insert(FakePointer(i));
  set.RetainIf([&expected](void *ptr) { return expected.count(ptr) != 0; });

  EXPECT_EQ(set.Size(), expected.size());
  EXPECT_EQ(Contents(set), expected);
  // Dropped pointers can be inserted again.
  EXPECT_TRUE(set.Insert(FakePointer(1)));
}

// RetainIf() runs on every GC, so a past peak must not keep its table alive.
constexpr uintptr_t kPeakPointers = 65536;

TEST(PointerSetTest, RetainIfFreesTheTableOnceEmpty) {
  ROS_GC::PointerSet set;
  for (uintptr_t i = 0; i < kPeakPointers; ++i) set.Insert(FakePointer(i));
  set.RetainIf([](void *) { return false; });

  set.RetainIf([](void *) { return true; });

  EXPECT_EQ(set.MemoryUsage(), sizeof(ROS_GC::PointerSet));
}

TEST(PointerSetTest, RetainIfShrinksTheTableToTheSurvivors) {
  ROS_GC::PointerSet set;
  for (uintptr_t i = 0; i < kPeakPointers; ++i) set.Insert(FakePointer(i));
  std::set<void *> survivors;
  for (uintptr_t i = 0; i < 100; ++i) survivors.insert(FakePointer(i));
  set.RetainIf([&survivors](void *ptr) { return survivors.count(ptr) != 0; });

  set.RetainIf([](void *) { return true; });

  EXPECT_EQ(Contents(set), survivors);
  // 100 pointers at a load factor of at most 1/2 fit in 256 slots.
  EXPECT_LE(set.MemoryUsage(),
            sizeof(ROS_GC::PointerSet) + 256 * sizeof(void *));
}

TEST(PointerSetTest, ClearAllowsReuse) {
  ROS_GC::PointerSet set;
  for (uintptr_t i = 0; i < 100; ++i) set.Insert(FakePointer(i));
  set.Clear();
  EXPECT_EQ(set.Size(), 0u);
  EXPECT_TRUE(Contents(set).empty());

  EXPECT_TRUE(set.Insert(FakePointer(7)));
  EXPECT_EQ(Contents(set), std::set<void *>{FakePointer(7)});
}

// Finalizers run from RetainIf() and Drain() may register new objects. 32
// pointers are the maximum load of the initial capacity, so inserting from the
// callback grows the set while the old slots are still being walked.
constexpr uintptr_t kPointersAtMaxInitialLoad = 32;
constexpr uintptr_t kFirstInsertedFromCallback = 1000;

TEST(PointerSetTest, RetainIfKeepsPointersInsertedByThePredicate) {
  ROS_GC::PointerSet set;
  std::set<void *> expected;
  for (uintptr_t i = 0; i < kPointersAtMaxInitialLoad; ++i) {
    set.Insert(FakePointer(i));
    expected.insert(FakePointer(i));
  }

  uintptr_t next = kFirstInsertedFromCallback;
  set.RetainIf([&set, &expected, &next](void *) {
    for (int i = 0; i < 2; ++i, ++next) {
      set.Insert(FakePointer(next));
      expected.insert(FakePointer(next));
    }
    return true;
  });

  EXPECT_EQ(Contents(set), expected);
}

TEST(PointerSetTest, DrainPassesEveryPointerAndLeavesTheSetEmpty) {
  ROS_GC::PointerSet set;
  std::set<void *> expected;
  for (uintptr_t i = 0; i < kPointersAtMaxInitialLoad; ++i) {
    set.Insert(FakePointer(i));
    expected.insert(FakePointer(i));
  }

  std::set<void *> drained;
  uintptr_t next = kFirstInsertedFromCallback;
  set.Drain([&set, &drained, &next](void *ptr) {
    drained.insert(ptr);
    set.Insert(FakePointer(next++));
  });

  EXPECT_EQ(drained, expected);
  EXPECT_EQ(set.Size(), 0u);
}

}  // namespace heap_test
