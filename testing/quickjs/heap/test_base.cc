
#include "test_base.h"

namespace heap_test {

void Heap::SetUp() {
  rt = LEPUS_NewRuntime();
  ctx = LEPUS_NewContext(rt);
}

void Heap::TearDown() {
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

void* Heap::allocate(size_t size, int alloc_tag) {
  auto js_malloc_rt_gc = rt->js_malloc_rt;
  return js_malloc_rt_gc(rt, size, alloc_tag);
}

}  // namespace heap_test
