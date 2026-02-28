#include <gtest/gtest.h>

#include <atomic>
#include <mutex>
#include <thread>
#include <vector>

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/cutils.h"
#include "quickjs/include/quickjs-libc.h"
#ifdef __cplusplus
}
#endif
#include "gc/allocator.h"
#include "gc/collector_ms.h"
#include "gc/mrt_bitmap.h"
#include "gc/page_group.h"
#include "gc/thread_pool.h"
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

namespace heap_test {

class Heap {
 public:
  static constexpr int kMaxThreadNum = 10;
  static constexpr int kHeaderSize = 8;
  void SetUp();
  void TearDown();

  inline ROS_GC::MplThreadPool *getThreadPool() {
    return rt->ros_->GetWorkerThreadPool();
  }
  void *allocate(size_t size, int alloc_tag = 0);

  LEPUSRuntime *rt;
  LEPUSContext *ctx;
};

class TestBase : public ::testing::Test {
 public:
  Heap _heap;

  void SetUp() override { _heap.SetUp(); }
  Heap *heap() { return &_heap; }
  LEPUSContext *get_ctx() { return _heap.ctx; }
  LEPUSRuntime *get_rt() { return _heap.rt; }

  LEPUSValue AllocMap() {
    LEPUSValue obj, map_set;
    LEPUSValue map_func = GetGlobalMap();
    obj = JS_CallConstructorInternal(get_ctx(), map_func, map_func, 0, nullptr,
                                     0);
    return obj;
  }

  LEPUSValue MapSetValue(LEPUSValue obj, LEPUSValue key, LEPUSValue val) {
    auto map_set = GetGlobalMapSet(obj);
    LEPUSValueConst call_argv[] = {key, val};
    LEPUS_Call(get_ctx(), map_set, obj, 2, call_argv);
    return obj;
  }

  LEPUSValue GetGlobalMap() {
    LEPUSValue global_obj = LEPUS_GetGlobalObject(get_ctx());
    auto atom = JS_ATOM_Map;
    auto map_func =
        JS_GetPropertyInternal_GC(get_ctx(), global_obj, atom, global_obj, 0);
    return map_func;
  }

  LEPUSValue GetGlobalMapSet(LEPUSValue obj) {
    auto atom = JS_ATOM_set;
    auto res = JS_GetPropertyInternal_GC(get_ctx(), obj, atom, obj, 0);
    return res;
  }

  void TearDown() override { _heap.TearDown(); }
  ROS_GC::MplThreadPool *getThreadPool() { return _heap.getThreadPool(); }
};

}  // namespace heap_test
