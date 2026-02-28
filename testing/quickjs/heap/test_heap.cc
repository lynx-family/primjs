#include <gtest/gtest.h>

#include <atomic>
#include <mutex>
#include <thread>
#include <vector>

#include "test_base.h"

namespace heap_test {

class HeapTest : public TestBase {
 public:
  HeapTest() : TestBase() {}
  void SetUp() override {
    TestBase::SetUp();
    ctx = get_ctx();
  }

  LEPUSContext *ctx;
};

TEST_F(HeapTest, TestEmpty) {}

}  // namespace heap_test
