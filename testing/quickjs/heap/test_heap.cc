#include <gtest/gtest.h>

#include <atomic>
#include <mutex>
#include <string>
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

constexpr size_t kLargeStringLength = ROS_GC::RosAllocImpl::kLargeObjSize * 2;
constexpr size_t kHugeArrayBufferLength =
    ROS_GC::RosAllocImpl::kHugeObjSize + 4096;
constexpr size_t kMinimumMemorySlotGrowths[] = {0, kLargeStringLength,
                                                kHugeArrayBufferLength};
constexpr size_t kExpectedMemorySlotCount = 1u << 8;
constexpr uint32_t kExpectedMaxGCPayloadSize =
    (static_cast<uint32_t>(1) << 31) - 1;
constexpr size_t kLargeArrayBufferLength = 128u * 1024 * 1024;

struct MemorySlotCheckState {
  LEPUSRuntime *rt;
  int32_t slot;
  size_t previous;
  size_t checkpoint_count;
};

static size_t LoadCommittedMemorySlot(LEPUSRuntime *rt, int32_t slot) {
  EXPECT_GE(slot, LEPUS_MEMORY_CATEGORY_UNKNOWN);
  EXPECT_LT(slot, LEPUS_MEMORY_SIZE_SLOTS);
  return __atomic_load_n(&rt->malloc_state.memory_size_slots[slot],
                         __ATOMIC_RELAXED);
}

static size_t LoadMemorySlot(LEPUSRuntime *rt, int32_t slot) {
#ifdef ENABLE_COMPATIBLE_MM
  if (rt->gc_enable && rt->ros_->HasMemoryTracking()) {
    rt->ros_->FlushPendingMemorySlotAllocations();
  }
#endif
  return LoadCommittedMemorySlot(rt, slot);
}

static void ExpectNoUnknownAllocations(LEPUSRuntime *rt) {
  EXPECT_EQ(LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_UNKNOWN), 0u);
}

static void FreeRuntimeAndExpectMemorySlotsCleared(LEPUSRuntime *rt) {
  size_t memory_size_slots[LEPUS_MEMORY_SIZE_SLOTS];
  memset(memory_size_slots, 0xff, sizeof(memory_size_slots));
  LEPUS_FreeRuntimeAndDumpMemorySlots(rt, memory_size_slots);
  for (size_t slot = 0; slot < LEPUS_MEMORY_SIZE_SLOTS; ++slot) {
    EXPECT_EQ(memory_size_slots[slot], 0u) << "memory slot " << slot;
  }
}

static LEPUSValue CheckMemorySlotGrowth(LEPUSContext *ctx,
                                        LEPUSValueConst this_val, int argc,
                                        LEPUSValueConst *argv) {
  auto *state =
      static_cast<MemorySlotCheckState *>(LEPUS_GetContextOpaque(ctx));
  if (!state) {
    ADD_FAILURE() << "missing memory slot check state";
    return LEPUS_UNDEFINED;
  }
  if (state->checkpoint_count >= sizeof(kMinimumMemorySlotGrowths) /
                                     sizeof(kMinimumMemorySlotGrowths[0])) {
    ADD_FAILURE() << "unexpected memory slot checkpoint";
    return LEPUS_UNDEFINED;
  }

  size_t current = LoadMemorySlot(state->rt, state->slot);
  if (current <= state->previous) {
    ADD_FAILURE() << "memory slot did not increase";
  } else {
    EXPECT_GT(current - state->previous,
              kMinimumMemorySlotGrowths[state->checkpoint_count]);
  }
  state->previous = current;
  state->checkpoint_count++;
  return LEPUS_UNDEFINED;
}

#ifdef ENABLE_COMPATIBLE_MM
static void ExpectGCAllocationKinds(LEPUSContext *ctx, LEPUSRuntime *rt) {
  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  LEPUSValue root = LEPUS_GetPropertyStr(ctx, global, "memorySlotTestRoot");
  ASSERT_TRUE(LEPUS_IsObject(root));
  LEPUSValue large_string = LEPUS_GetPropertyStr(ctx, root, "largeString");
  ASSERT_TRUE(LEPUS_IsString(large_string));
  LEPUSValue huge_buffer = LEPUS_GetPropertyStr(ctx, root, "hugeBuffer");
  ASSERT_TRUE(LEPUS_IsArrayBuffer(huge_buffer));

  auto &page_groups = rt->ros_->GetPageGroups();
  address_t root_address =
      reinterpret_cast<address_t>(LEPUS_VALUE_GET_OBJ(root)) -
      ROS_GC::kHeaderSize;
  uint32_t root_group_index = page_groups.GetGroupIdx(root_address);
  EXPECT_EQ(page_groups.GetTypeForAddr(root_address, root_group_index),
            ROS_GC::kPRun);

  address_t string_address =
      reinterpret_cast<address_t>(LEPUS_VALUE_GET_STRING(large_string)) -
      ROS_GC::kHeaderSize;
  uint32_t string_group_index = page_groups.GetGroupIdx(string_address);
  EXPECT_EQ(page_groups.GetTypeForAddr(string_address, string_group_index),
            ROS_GC::kPLargeObj);

  size_t buffer_size = 0;
  uint8_t *buffer_data = LEPUS_GetArrayBuffer(ctx, &buffer_size, huge_buffer);
  ASSERT_NE(buffer_data, nullptr);
  EXPECT_EQ(buffer_size, kHugeArrayBufferLength);
  uint32_t buffer_group_index =
      page_groups.GetGroupIdx(reinterpret_cast<address_t>(buffer_data));
  EXPECT_TRUE(page_groups.GetGroupByIdx(buffer_group_index).IsHugeObj());
}

struct ConcurrentGCCheckState {
  size_t observed_count;
  size_t check_count;
};

constexpr size_t kConcurrentGCObservationTarget = 3;

static LEPUSValue ObserveConcurrentGC(LEPUSContext *ctx,
                                      LEPUSValueConst this_val, int argc,
                                      LEPUSValueConst *argv) {
  auto *state =
      static_cast<ConcurrentGCCheckState *>(LEPUS_GetContextOpaque(ctx));
  if (!state) {
    ADD_FAILURE() << "missing concurrent GC check state";
    return LEPUS_FALSE;
  }

  auto *ros = ctx->rt->ros_;
  size_t parallel_gc_count = ros->GetGCTracer()->GetGCCount();
  size_t total_gc_count = static_cast<size_t>(ros->gc_cnt);
  size_t concurrent_gc_count = total_gc_count > parallel_gc_count
                                   ? total_gc_count - parallel_gc_count
                                   : 0;
  if (concurrent_gc_count > state->observed_count) {
    state->observed_count = concurrent_gc_count;
  }
  state->check_count++;
  return LEPUS_NewInt64(ctx, state->observed_count);
}
#endif

static LEPUSRuntime *NewMemorySlotRuntime(bool expect_gc,
                                          int32_t *current_slot) {
#ifdef ENABLE_COMPATIBLE_MM
  if (expect_gc) {
    return JS_NewRuntime_GC(0, current_slot);
  }
#endif
  return LEPUS_NewRuntimeWithModeMemoryTrackSlot(0, current_slot);
}

static void RunJavaScriptMemorySlotTest(bool expect_gc) {
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = NewMemorySlotRuntime(expect_gc, &current_slot);
  ASSERT_NE(rt, nullptr);
  EXPECT_EQ(rt->gc_enable, expect_gc);
  EXPECT_EQ(current_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  int32_t page_slot = LEPUS_AllocateMemorySlot(rt);
  ASSERT_GT(page_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  current_slot = page_slot;

  LEPUSContext *ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);
  if (expect_gc) {
    LEPUS_SetGCPauseSuppressionMode(rt, true);
  }

  MemorySlotCheckState state = {rt, page_slot, 0, 0};
  LEPUS_SetContextOpaque(ctx, &state);

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  LEPUSValue check_function = LEPUS_NewCFunction(ctx, CheckMemorySlotGrowth,
                                                 "checkMemorySlotGrowth", 0);
  ASSERT_FALSE(LEPUS_IsException(check_function));
  ASSERT_GE(LEPUS_SetPropertyStr(ctx, global, "checkMemorySlotGrowth",
                                 check_function),
            0);
  if (!rt->gc_enable) {
    LEPUS_FreeValue(ctx, global);
  }

  state.previous = LoadMemorySlot(rt, page_slot);
  std::string source =
      "globalThis.memorySlotTestRoot = {"
      "  object: { value: 1 },"
      "  values: [1, 2, 3]"
      "};"
      "checkMemorySlotGrowth();"
      "globalThis.memorySlotTestRoot.largeString = 'x'.repeat(" +
      std::to_string(kLargeStringLength) +
      ");"
      "checkMemorySlotGrowth();"
      "globalThis.memorySlotTestRoot.hugeBuffer = new ArrayBuffer(" +
      std::to_string(kHugeArrayBufferLength) +
      ");"
      "checkMemorySlotGrowth();";

  LEPUSValue result = LEPUS_Eval(ctx, source.c_str(), source.size(),
                                 "memory_slot_test.js", LEPUS_EVAL_TYPE_GLOBAL);
  EXPECT_FALSE(LEPUS_IsException(result));
  if (!rt->gc_enable) {
    LEPUS_FreeValue(ctx, result);
  }
  EXPECT_EQ(state.checkpoint_count, 3u);
  EXPECT_GT(LoadMemorySlot(rt, page_slot),
            kLargeStringLength + kHugeArrayBufferLength);

#ifdef ENABLE_COMPATIBLE_MM
  if (expect_gc && !LEPUS_IsException(result)) {
    ExpectGCAllocationKinds(ctx, rt);
  }
#endif

  ExpectNoUnknownAllocations(rt);
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

static void RunJavaScriptMemorySlotReallocationTest(bool expect_gc) {
  constexpr int32_t kArrayLength = 1024;
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = NewMemorySlotRuntime(expect_gc, &current_slot);
  ASSERT_NE(rt, nullptr);
  EXPECT_EQ(rt->gc_enable, expect_gc);
  int32_t page_slot = LEPUS_AllocateMemorySlot(rt);
  ASSERT_GT(page_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  current_slot = page_slot;

  LEPUSContext *ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);
  if (expect_gc) {
    LEPUS_SetGCPauseSuppressionMode(rt, true);
  }

  size_t baseline = LoadMemorySlot(rt, page_slot);
  constexpr char source[] = R"(
    const values = [];
    for (let i = 0; i < 1024; i++) {
      values.push(i);
    }
    globalThis.reallocatedArray = values;
    values.length;
  )";
  LEPUSValue result =
      LEPUS_Eval(ctx, source, sizeof(source) - 1, "reallocation_test.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(result));

  int32_t result_length = 0;
  EXPECT_EQ(LEPUS_ToInt32(ctx, &result_length, result), 0);
  EXPECT_EQ(result_length, kArrayLength);

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  LEPUSValue array = LEPUS_GetPropertyStr(ctx, global, "reallocatedArray");
  ASSERT_TRUE(LEPUS_IsArray(ctx, array));
  LEPUSObject *array_object = LEPUS_VALUE_GET_OBJ(array);
  ASSERT_NE(array_object, nullptr);
  EXPECT_TRUE(array_object->fast_array);
  EXPECT_EQ(array_object->u.array.count, kArrayLength);
  EXPECT_GE(array_object->u.array.u1.size, kArrayLength);
  ASSERT_NE(array_object->u.array.u.values, nullptr);
  EXPECT_GT(LoadMemorySlot(rt, page_slot), baseline);

#ifdef ENABLE_COMPATIBLE_MM
  if (expect_gc) {
    EXPECT_EQ(get_memory_slot(array_object->u.array.u.values), page_slot);
    EXPECT_EQ(rt->ros_->gc_cnt, 0);
  }
#endif

  if (!rt->gc_enable) {
    LEPUS_FreeValue(ctx, array);
    LEPUS_FreeValue(ctx, global);
    LEPUS_FreeValue(ctx, result);
  }
  ExpectNoUnknownAllocations(rt);
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

static bool EvalMemorySlotSource(LEPUSContext *ctx, const char *source,
                                 size_t source_size, const char *filename) {
  LEPUSValue result =
      LEPUS_Eval(ctx, source, source_size, filename, LEPUS_EVAL_TYPE_GLOBAL);
  bool succeeded = !LEPUS_IsException(result);
  EXPECT_TRUE(succeeded);
  if (!ctx->gc_enable) {
    LEPUS_FreeValue(ctx, result);
  }
  return succeeded;
}

static bool CompileAndRetainMemorySlotSource(LEPUSContext *ctx,
                                             const char *source,
                                             size_t source_size,
                                             const char *filename) {
  LEPUSValue compiled =
      LEPUS_Eval(ctx, source, source_size, filename,
                 LEPUS_EVAL_TYPE_GLOBAL | LEPUS_EVAL_FLAG_COMPILE_ONLY);
  HandleScope scope(ctx, &compiled, HANDLE_TYPE_LEPUS_VALUE);
  bool succeeded = !LEPUS_IsException(compiled);
  EXPECT_TRUE(succeeded);
  if (!succeeded) {
    return false;
  }

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  scope.PushHandle(&global, HANDLE_TYPE_LEPUS_VALUE);
  succeeded =
      LEPUS_SetPropertyStr(ctx, global, "__appBytecodeWarmup", compiled) >= 0;
  EXPECT_TRUE(succeeded);
  if (!ctx->gc_enable) {
    LEPUS_FreeValue(ctx, global);
  }
  compiled = global = LEPUS_UNDEFINED;
  return succeeded;
}

static int32_t CallAppDoSomething(LEPUSContext *ctx, uint32_t app_index) {
  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  HandleScope scope(ctx, &global, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue apps = LEPUS_GetPropertyStr(ctx, global, "apps_array");
  scope.PushHandle(&apps, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue app = LEPUS_GetPropertyUint32(ctx, apps, app_index);
  scope.PushHandle(&app, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue method = LEPUS_GetPropertyStr(ctx, app, "doSomething");
  scope.PushHandle(&method, HANDLE_TYPE_LEPUS_VALUE);
  EXPECT_TRUE(LEPUS_IsFunction(ctx, method));

  LEPUSValue result = LEPUS_Call(ctx, method, app, 0, nullptr);
  scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
  EXPECT_FALSE(LEPUS_IsException(result));
  int32_t call_count = -1;
  if (!LEPUS_IsException(result)) {
    EXPECT_EQ(LEPUS_ToInt32(ctx, &call_count, result), 0);
  }

  if (!ctx->gc_enable) {
    LEPUS_FreeValue(ctx, result);
    LEPUS_FreeValue(ctx, method);
    LEPUS_FreeValue(ctx, app);
    LEPUS_FreeValue(ctx, apps);
    LEPUS_FreeValue(ctx, global);
  }
  result = method = app = apps = global = LEPUS_UNDEFINED;
  return call_count;
}

static bool CallDeleteApp(LEPUSContext *ctx, uint32_t app_index) {
  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  HandleScope scope(ctx, &global, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue method = LEPUS_GetPropertyStr(ctx, global, "deleteApp");
  scope.PushHandle(&method, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue argument = LEPUS_NewInt32(ctx, app_index);
  LEPUSValue result = LEPUS_Call(ctx, method, global, 1, &argument);
  scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
  bool succeeded = !LEPUS_IsException(result);
  EXPECT_TRUE(succeeded);

  if (!ctx->gc_enable) {
    LEPUS_FreeValue(ctx, result);
    LEPUS_FreeValue(ctx, method);
    LEPUS_FreeValue(ctx, global);
  }
  result = method = global = LEPUS_UNDEFINED;
  return succeeded;
}

static bool CallClearSharedData(LEPUSContext *ctx) {
  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  HandleScope scope(ctx, &global, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue method = LEPUS_GetPropertyStr(ctx, global, "clearSharedData");
  scope.PushHandle(&method, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue result = LEPUS_Call(ctx, method, global, 0, nullptr);
  scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
  bool succeeded = !LEPUS_IsException(result);
  EXPECT_TRUE(succeeded);

  if (!ctx->gc_enable) {
    LEPUS_FreeValue(ctx, result);
    LEPUS_FreeValue(ctx, method);
    LEPUS_FreeValue(ctx, global);
  }
  result = method = global = LEPUS_UNDEFINED;
  return succeeded;
}

static void RunMultipleAppMemorySlotTest(bool expect_gc) {
  constexpr char common_source[] = R"(
    globalThis.apps_array = [];
    globalThis.sharedData = {};
    globalThis.deleteApp = function(index) {
      globalThis.apps_array[index] = null;
    };
    globalThis.clearSharedData = function() {
      delete globalThis.sharedData.app0;
    };
    globalThis.__shapeHashWarmup = [];
    for (let i = 0; i < 128; i++) {
      const object = {};
      object["shapeHashWarmup" + i] = i;
      globalThis.__shapeHashWarmup.push(object);
    }
  )";
  constexpr char app_source[] = R"(
    (function() {
      const appIndex = globalThis.apps_array.length;
      const retainedObjects = [];
      globalThis.apps_array[appIndex] = {
        doSomething: function() {
          if (appIndex === 0) {
            globalThis.sharedData.app0 = this;
          }
          let lastTemporary = null;
          for (let i = 0; i < 64; i++) {
            lastTemporary = { index: i, value: i };
          }
          retainedObjects.push({
            sequence: retainedObjects.length,
            value: lastTemporary.value,
            lastTemporary: lastTemporary
          });
          return retainedObjects.length;
        }
      };
    })();
  )";
  constexpr char retain_warmup_source[] = R"(
    globalThis.__appWarmup = globalThis.apps_array[0];
    globalThis.apps_array.length = 0;
  )";

  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = NewMemorySlotRuntime(expect_gc, &current_slot);
  ASSERT_NE(rt, nullptr);
  EXPECT_EQ(rt->gc_enable, expect_gc);
  EXPECT_EQ(current_slot, LEPUS_MEMORY_CATEGORY_COMMON);

  LEPUSContext *ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);
  ASSERT_TRUE(EvalMemorySlotSource(ctx, common_source,
                                   sizeof(common_source) - 1, "common.js"));
  ASSERT_TRUE(CompileAndRetainMemorySlotSource(
      ctx, app_source, sizeof(app_source) - 1, "app.js"));
  ASSERT_TRUE(
      EvalMemorySlotSource(ctx, app_source, sizeof(app_source) - 1, "app.js"));
  ASSERT_EQ(CallAppDoSomething(ctx, 0), 1);
  ASSERT_TRUE(EvalMemorySlotSource(ctx, retain_warmup_source,
                                   sizeof(retain_warmup_source) - 1,
                                   "common.js"));
  ASSERT_GT(LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_COMMON), 0u);

  int32_t app0_slot = LEPUS_AllocateMemorySlot(rt);
  int32_t app1_slot = LEPUS_AllocateMemorySlot(rt);
  ASSERT_GT(app0_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  ASSERT_GT(app1_slot, app0_slot);

  current_slot = app0_slot;
  ASSERT_TRUE(
      EvalMemorySlotSource(ctx, app_source, sizeof(app_source) - 1, "app.js"));
  ASSERT_GT(LoadMemorySlot(rt, app0_slot), 0u);

  current_slot = app1_slot;
  ASSERT_TRUE(
      EvalMemorySlotSource(ctx, app_source, sizeof(app_source) - 1, "app.js"));
  ASSERT_GT(LoadMemorySlot(rt, app1_slot), 0u);

  size_t app0_registered_size = LoadMemorySlot(rt, app0_slot);
  size_t app1_registered_size = LoadMemorySlot(rt, app1_slot);
  for (int32_t i = 1; i <= 6; i++) {
    current_slot = app0_slot;
    EXPECT_EQ(CallAppDoSomething(ctx, 0), i);
    current_slot = app1_slot;
    EXPECT_EQ(CallAppDoSomething(ctx, 1), i);
  }
  EXPECT_GT(LoadMemorySlot(rt, app0_slot), app0_registered_size);
  EXPECT_GT(LoadMemorySlot(rt, app1_slot), app1_registered_size);

  current_slot = LEPUS_MEMORY_CATEGORY_COMMON;
  ASSERT_TRUE(CallDeleteApp(ctx, 0));
  LEPUS_RunGC(rt);
  EXPECT_GT(LoadMemorySlot(rt, app0_slot), 0u);
  EXPECT_GT(LoadMemorySlot(rt, app1_slot), 0u);

  ASSERT_TRUE(CallClearSharedData(ctx));
  LEPUS_RunGC(rt);
  EXPECT_EQ(LoadMemorySlot(rt, app0_slot), 0u);
  EXPECT_GT(LoadMemorySlot(rt, app1_slot), 0u);

  ASSERT_TRUE(CallDeleteApp(ctx, 1));
  LEPUS_RunGC(rt);
  EXPECT_EQ(LoadMemorySlot(rt, app1_slot), 0u);
  EXPECT_GT(LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_COMMON), 0u);

  ExpectNoUnknownAllocations(rt);
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

TEST(HeapMemorySlotTest, CommonScopeRestoresCurrentSlot) {
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = LEPUS_NewRuntimeWithModeMemoryTrackSlot(0, &current_slot);
  ASSERT_NE(rt, nullptr);
  ASSERT_EQ(current_slot, LEPUS_MEMORY_CATEGORY_COMMON);

  int32_t app_slot = LEPUS_AllocateMemorySlot(rt);
  ASSERT_GT(app_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  current_slot = app_slot;
  const size_t common_size = LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_COMMON);
  void *ptr = nullptr;
  {
    ScopedCommonMemorySlot common_scope(rt);
    EXPECT_EQ(current_slot, LEPUS_MEMORY_CATEGORY_COMMON);
    {
      ScopedCommonMemorySlot nested_common_scope(rt);
      EXPECT_EQ(current_slot, LEPUS_MEMORY_CATEGORY_COMMON);
    }
    EXPECT_EQ(current_slot, LEPUS_MEMORY_CATEGORY_COMMON);

    ptr = rt->js_malloc_rt(rt, 128, ALLOC_TAG_WITHOUT_PTR);
    ASSERT_NE(ptr, nullptr);
    EXPECT_GT(LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_COMMON), common_size);
    EXPECT_EQ(LoadMemorySlot(rt, app_slot), 0u);
  }
  EXPECT_EQ(current_slot, app_slot);
  if (!rt->gc_enable) {
    lepus_free_rt(rt, ptr);
    EXPECT_EQ(LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_COMMON), common_size);
  }

  ExpectNoUnknownAllocations(rt);
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

TEST(HeapMemorySlotTest, DumpsCurrentSlotsWithoutFreeingRuntime) {
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = LEPUS_NewRuntimeWithModeMemoryTrackSlot(0, &current_slot);
  ASSERT_NE(rt, nullptr);
  int32_t page_slot = LEPUS_AllocateMemorySlot(rt);
  ASSERT_GT(page_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  current_slot = page_slot;

  void *first_ptr = rt->js_malloc_rt(rt, 64, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(first_ptr, nullptr);
  size_t first_dump[LEPUS_MEMORY_SIZE_SLOTS];
  memset(first_dump, 0xff, sizeof(first_dump));
  LEPUS_DumpMemorySlots(rt, first_dump);
  EXPECT_EQ(first_dump[LEPUS_MEMORY_CATEGORY_UNKNOWN], 0u);
  EXPECT_EQ(first_dump[LEPUS_MEMORY_CATEGORY_COMMON],
            LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_COMMON));
  EXPECT_EQ(first_dump[page_slot], LoadMemorySlot(rt, page_slot));
  EXPECT_GT(first_dump[page_slot], 0u);

  void *second_ptr = rt->js_malloc_rt(rt, 128, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(second_ptr, nullptr);
  size_t second_dump[LEPUS_MEMORY_SIZE_SLOTS];
  memset(second_dump, 0xff, sizeof(second_dump));
  LEPUS_DumpMemorySlots(rt, second_dump);
  EXPECT_EQ(second_dump[page_slot], LoadMemorySlot(rt, page_slot));
  EXPECT_GT(second_dump[page_slot], first_dump[page_slot]);

  if (!rt->gc_enable) {
    lepus_free_rt(rt, first_ptr);
    lepus_free_rt(rt, second_ptr);
  }
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

TEST(HeapMemorySlotTest, AllocatesAllPageSlotsSequentially) {
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = LEPUS_NewRuntimeWithModeMemoryTrackSlot(0, &current_slot);
  ASSERT_NE(rt, nullptr);

  for (int32_t expected = LEPUS_MEMORY_CATEGORY_COMMON + 1;
       expected < LEPUS_MEMORY_SIZE_SLOTS; ++expected) {
    EXPECT_EQ(LEPUS_AllocateMemorySlot(rt), expected);
  }
  EXPECT_EQ(LEPUS_AllocateMemorySlot(rt), -1);
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

TEST(HeapMemorySlotTest, UnknownCategoryReceivesAllocations) {
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = LEPUS_NewRuntimeWithModeMemoryTrackSlot(0, &current_slot);
  ASSERT_NE(rt, nullptr);

  current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  void *ptr = rt->js_malloc_rt(rt, 128, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(ptr, nullptr);
  EXPECT_GT(LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_UNKNOWN), 0u);
  if (rt->gc_enable) {
    EXPECT_EQ(get_memory_slot(ptr), LEPUS_MEMORY_CATEGORY_UNKNOWN);
  } else {
    lepus_free_rt(rt, ptr);
    EXPECT_EQ(LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_UNKNOWN), 0u);
  }
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

#ifndef ENABLE_COMPATIBLE_MM
TEST(HeapMemorySlotTest, RCAllocationsUseCurrentSlot) {
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = LEPUS_NewRuntimeWithModeMemoryTrackSlot(0, &current_slot);
  ASSERT_NE(rt, nullptr);
  EXPECT_FALSE(rt->gc_enable);
  ASSERT_GT(LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_COMMON), 0u);

  int32_t first_slot = LEPUS_AllocateMemorySlot(rt);
  int32_t second_slot = LEPUS_AllocateMemorySlot(rt);
  ASSERT_GT(first_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  ASSERT_GT(second_slot, first_slot);
  current_slot = first_slot;
  void *first_ptr = rt->js_malloc_rt(rt, 64, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(first_ptr, nullptr);
  EXPECT_GT(LoadMemorySlot(rt, first_slot), 0u);
  EXPECT_EQ(LoadMemorySlot(rt, second_slot), 0u);

  const size_t first_size = LoadMemorySlot(rt, first_slot);
  current_slot = second_slot;
  void *second_ptr = rt->js_malloc_rt(rt, 128, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(second_ptr, nullptr);
  EXPECT_EQ(LoadMemorySlot(rt, first_slot), first_size);
  EXPECT_GT(LoadMemorySlot(rt, second_slot), 0u);

  const size_t second_size = LoadMemorySlot(rt, second_slot);
  void *resized_ptr =
      rt->js_realloc_rt(rt, first_ptr, 4096, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(resized_ptr, nullptr);
  first_ptr = resized_ptr;
  EXPECT_GT(LoadMemorySlot(rt, first_slot), first_size);
  EXPECT_EQ(LoadMemorySlot(rt, second_slot), second_size);

  second_ptr = rt->js_realloc_rt(rt, second_ptr, 0, ALLOC_TAG_WITHOUT_PTR);
  EXPECT_EQ(second_ptr, nullptr);
  EXPECT_EQ(LoadMemorySlot(rt, second_slot), 0u);
  lepus_free_rt(rt, first_ptr);
  EXPECT_EQ(LoadMemorySlot(rt, first_slot), 0u);

  ExpectNoUnknownAllocations(rt);
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

TEST(HeapMemorySlotTest, RCJavaScriptAllocations) {
  RunJavaScriptMemorySlotTest(false);
}

TEST(HeapMemorySlotTest, RCJavaScriptReallocation) {
  RunJavaScriptMemorySlotReallocationTest(false);
}

TEST(HeapMemorySlotTest, RCMultipleAppSlotsReleasedIndependently) {
  RunMultipleAppMemorySlotTest(false);
}
#endif

#ifdef ENABLE_COMPATIBLE_MM
TEST(HeapMemorySlotTest, GCBatchesAllocationsUntilSlotChangeOrDump) {
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = JS_NewRuntime_GC(0, &current_slot);
  ASSERT_NE(rt, nullptr);

  int32_t first_slot = LEPUS_AllocateMemorySlot(rt);
  int32_t second_slot = LEPUS_AllocateMemorySlot(rt);
  ASSERT_GT(first_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  ASSERT_GT(second_slot, first_slot);

  rt->ros_->FlushPendingMemorySlotAllocations();
  current_slot = first_slot;
  const size_t first_committed = LoadCommittedMemorySlot(rt, first_slot);
  void *first_ptr = rt->js_malloc_rt(rt, 64, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(first_ptr, nullptr);
  EXPECT_EQ(LoadCommittedMemorySlot(rt, first_slot), first_committed);

  current_slot = second_slot;
  void *second_ptr = rt->js_malloc_rt(rt, 128, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(second_ptr, nullptr);
  EXPECT_GT(LoadCommittedMemorySlot(rt, first_slot), first_committed);
  EXPECT_EQ(LoadCommittedMemorySlot(rt, second_slot), 0u);

  size_t memory_size_slots[LEPUS_MEMORY_SIZE_SLOTS] = {};
  LEPUS_DumpMemorySlots(rt, memory_size_slots);
  EXPECT_GT(memory_size_slots[second_slot], 0u);
  EXPECT_EQ(memory_size_slots[first_slot],
            LoadCommittedMemorySlot(rt, first_slot));
  EXPECT_EQ(memory_size_slots[second_slot],
            LoadCommittedMemorySlot(rt, second_slot));

  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

TEST(HeapMemorySlotTest, GCHeaderSupports31BitPayloadAndEightBitSlot) {
  EXPECT_EQ(LEPUS_MEMORY_SIZE_SLOTS, kExpectedMemorySlotCount);
  EXPECT_EQ(ROS_GC::kMemorySlotBits, 8u);
  EXPECT_EQ(ROS_GC::kPayloadSizeBits, 31u);
  EXPECT_EQ(ROS_GC::kPayloadSizeMask, kExpectedMaxGCPayloadSize);

  alignas(uint64_t) uint8_t object[ROS_GC::kHeaderSize + 1] = {};
  void *payload = object + ROS_GC::kHeaderSize;
  init_obj_header(payload, static_cast<int>(kExpectedMaxGCPayloadSize),
                  ALLOC_TAG_WITHOUT_PTR, UINT8_MAX);
  EXPECT_EQ(get_obj_size(payload), kExpectedMaxGCPayloadSize);
  EXPECT_EQ(get_memory_slot(payload), UINT8_MAX);
  EXPECT_EQ(get_alloc_tag(payload), ALLOC_TAG_WITHOUT_PTR);

  set_alloc_tag(payload, ALLOC_TAG_JSShape);
  EXPECT_EQ(get_alloc_tag(payload), ALLOC_TAG_JSShape);
  EXPECT_EQ(get_obj_size(payload), kExpectedMaxGCPayloadSize);
  EXPECT_EQ(get_memory_slot(payload), UINT8_MAX);

  address_t header = reinterpret_cast<address_t>(payload) - ROS_GC::kHeaderSize;
  ROS_GC::SetColor(header);
  EXPECT_TRUE(ROS_GC::IsColored(header));
  EXPECT_EQ(get_obj_size(payload), kExpectedMaxGCPayloadSize);
  EXPECT_EQ(get_memory_slot(payload), UINT8_MAX);
  ROS_GC::ClearColorBit(header);
  EXPECT_FALSE(ROS_GC::IsColored(header));
  EXPECT_EQ(get_obj_size(payload), kExpectedMaxGCPayloadSize);
  EXPECT_EQ(get_memory_slot(payload), UINT8_MAX);
}

TEST(HeapMemorySlotTest, GCArrayBufferExceedsPreviousPayloadLimit) {
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = JS_NewRuntime_GC(0, &current_slot);
  ASSERT_NE(rt, nullptr);
  int32_t buffer_slot = LEPUS_MEMORY_CATEGORY_COMMON;
  while (buffer_slot < LEPUS_MEMORY_SIZE_SLOTS - 1) {
    buffer_slot = LEPUS_AllocateMemorySlot(rt);
    ASSERT_GT(buffer_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  }
  ASSERT_EQ(buffer_slot, UINT8_MAX);
  current_slot = buffer_slot;

  LEPUSContext *ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);
  LEPUS_SetGCPauseSuppressionMode(rt, true);

  std::string source = "globalThis.largeArrayBuffer = new ArrayBuffer(" +
                       std::to_string(kLargeArrayBufferLength) +
                       "); largeArrayBuffer.byteLength;";
  LEPUSValue result =
      LEPUS_Eval(ctx, source.c_str(), source.size(),
                 "large_array_buffer_test.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(result));
  int64_t byte_length = 0;
  ASSERT_EQ(LEPUS_ToInt64(ctx, &byte_length, result), 0);
  EXPECT_EQ(byte_length, kLargeArrayBufferLength);

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  LEPUSValue buffer = LEPUS_GetPropertyStr(ctx, global, "largeArrayBuffer");
  ASSERT_TRUE(LEPUS_IsArrayBuffer(buffer));
  size_t buffer_size = 0;
  uint8_t *buffer_data = LEPUS_GetArrayBuffer(ctx, &buffer_size, buffer);
  ASSERT_NE(buffer_data, nullptr);
  EXPECT_EQ(buffer_size, kLargeArrayBufferLength);
  EXPECT_EQ(get_obj_size(buffer_data), kLargeArrayBufferLength);
  EXPECT_EQ(get_memory_slot(buffer_data), buffer_slot);

  ExpectNoUnknownAllocations(rt);
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

TEST(HeapMemorySlotTest, GCHeaderStaysEightBytesWithMemoryTracking) {
  EXPECT_EQ(ROS_GC::kHeaderSize, sizeof(uint64_t));
  LEPUSRuntime *plain_rt = JS_NewRuntime_GC(0, nullptr);
  ASSERT_NE(plain_rt, nullptr);
  EXPECT_FALSE(plain_rt->ros_->HasMemoryTracking());

  void *plain_ptr = plain_rt->js_malloc_rt(plain_rt, 32, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(plain_ptr, nullptr);
  EXPECT_TRUE(ROS_GC::IsAllocatedByAllocator(
      reinterpret_cast<address_t>(plain_ptr) - ROS_GC::kHeaderSize));
  plain_ptr =
      plain_rt->js_realloc_rt(plain_rt, plain_ptr, 64, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(plain_ptr, nullptr);
  EXPECT_TRUE(ROS_GC::IsAllocatedByAllocator(
      reinterpret_cast<address_t>(plain_ptr) - ROS_GC::kHeaderSize));
  FreeRuntimeAndExpectMemorySlotsCleared(plain_rt);

  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *tracked_rt = JS_NewRuntime_GC(0, &current_slot);
  ASSERT_NE(tracked_rt, nullptr);
  EXPECT_TRUE(tracked_rt->ros_->HasMemoryTracking());
  EXPECT_EQ(current_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  ASSERT_GT(LoadMemorySlot(tracked_rt, LEPUS_MEMORY_CATEGORY_COMMON), 0u);

  int32_t first_slot = LEPUS_AllocateMemorySlot(tracked_rt);
  int32_t second_slot = LEPUS_AllocateMemorySlot(tracked_rt);
  ASSERT_GT(first_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  ASSERT_GT(second_slot, first_slot);
  current_slot = first_slot;
  void *tracked_ptr =
      tracked_rt->js_malloc_rt(tracked_rt, 128, ALLOC_TAG_JSShape);
  ASSERT_NE(tracked_ptr, nullptr);
  EXPECT_GT(LoadMemorySlot(tracked_rt, first_slot), 0u);
  EXPECT_EQ(LoadMemorySlot(tracked_rt, second_slot), 0u);
  EXPECT_EQ(get_memory_slot(tracked_ptr), first_slot);
  EXPECT_TRUE(ROS_GC::IsAllocatedByAllocator(
      reinterpret_cast<address_t>(tracked_ptr) - ROS_GC::kHeaderSize));
  static_cast<uint8_t *>(tracked_ptr)[0] = 0x5a;

  const size_t first_size = LoadMemorySlot(tracked_rt, first_slot);
  current_slot = second_slot;
  void *second_ptr =
      tracked_rt->js_malloc_rt(tracked_rt, 64, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(second_ptr, nullptr);
  EXPECT_EQ(LoadMemorySlot(tracked_rt, first_slot), first_size);
  EXPECT_GT(LoadMemorySlot(tracked_rt, second_slot), 0u);

  const size_t second_size = LoadMemorySlot(tracked_rt, second_slot);
  tracked_ptr = tracked_rt->js_realloc_rt(tracked_rt, tracked_ptr, 4096,
                                          ALLOC_TAG_JSShape);
  ASSERT_NE(tracked_ptr, nullptr);
  EXPECT_GT(LoadMemorySlot(tracked_rt, first_slot), first_size);
  EXPECT_EQ(LoadMemorySlot(tracked_rt, second_slot), second_size);
  EXPECT_EQ(get_memory_slot(tracked_ptr), first_slot);
  EXPECT_EQ(static_cast<uint8_t *>(tracked_ptr)[0], 0x5a);

  ExpectNoUnknownAllocations(tracked_rt);
  FreeRuntimeAndExpectMemorySlotsCleared(tracked_rt);
}

TEST(HeapMemorySlotTest, GCToRCResetDisablesMemoryTracking) {
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = JS_NewRuntime_GC(0, &current_slot);
  ASSERT_NE(rt, nullptr);
  ASSERT_GT(LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_COMMON), 0u);

  LEPUS_SetRuntimeInfo(rt, "effect");
  EXPECT_FALSE(rt->gc_enable);
  EXPECT_EQ(rt->malloc_state.ptr_to_current_slot, nullptr);
  for (size_t slot = 0; slot < LEPUS_MEMORY_SIZE_SLOTS; ++slot) {
    EXPECT_EQ(LoadMemorySlot(rt, slot), 0u);
  }

  void *ptr = rt->js_malloc_rt(rt, 64, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(ptr, nullptr);
  EXPECT_EQ(LoadMemorySlot(rt, LEPUS_MEMORY_CATEGORY_COMMON), 0u);
  rt->mf.lepus_free(&rt->malloc_state, ptr);
  ExpectNoUnknownAllocations(rt);
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}

TEST(HeapMemorySlotTest, GCJavaScriptAllocations) {
  RunJavaScriptMemorySlotTest(true);
}

TEST(HeapMemorySlotTest, GCJavaScriptReallocation) {
  RunJavaScriptMemorySlotReallocationTest(true);
}

TEST(HeapMemorySlotTest, GCMultipleAppSlotsReleasedIndependently) {
  RunMultipleAppMemorySlotTest(true);
}

TEST(HeapMemorySlotTest, GCConcurrentCollectionTracksCurrentSlot) {
  int32_t current_slot = LEPUS_MEMORY_CATEGORY_UNKNOWN;
  LEPUSRuntime *rt = JS_NewRuntime_GC(0, &current_slot);
  ASSERT_NE(rt, nullptr);
  ASSERT_TRUE(rt->gc_enable);
  ASSERT_TRUE(rt->ros_->GetEnableConcurrent());
  int32_t page_slot = LEPUS_AllocateMemorySlot(rt);
  ASSERT_GT(page_slot, LEPUS_MEMORY_CATEGORY_COMMON);
  current_slot = page_slot;

  LEPUSContext *ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);
  ConcurrentGCCheckState state = {0, 0};
  LEPUS_SetContextOpaque(ctx, &state);

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  LEPUSValue observe_function =
      LEPUS_NewCFunction(ctx, ObserveConcurrentGC, "observeConcurrentGC", 0);
  ASSERT_FALSE(LEPUS_IsException(observe_function));
  ASSERT_GE(LEPUS_SetPropertyStr(ctx, global, "observeConcurrentGC",
                                 observe_function),
            0);

  constexpr char source[] = R"(
    globalThis.concurrentGCSink = null;
    let concurrentGCCount = 0;
    for (let batch = 0; batch < 256 && concurrentGCCount < 3; batch++) {
      let lastObject = null;
      for (let i = 0; i < 4096; i++) {
        lastObject = {
          index: batch * 4096 + i,
          value: i,
          nested: { value: i, next: null }
        };
      }
      globalThis.concurrentGCSink = lastObject;
      concurrentGCCount = observeConcurrentGC();
    }
    globalThis.concurrentGCCount = concurrentGCCount;
  )";
  LEPUSValue result =
      LEPUS_Eval(ctx, source, sizeof(source) - 1, "concurrent_gc_test.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  EXPECT_FALSE(LEPUS_IsException(result));
  EXPECT_GE(state.observed_count, kConcurrentGCObservationTarget);
  EXPECT_GT(state.check_count, 0u);
  EXPECT_GE(rt->ros_->gc_cnt, static_cast<int>(kConcurrentGCObservationTarget));
  EXPECT_GT(LoadMemorySlot(rt, page_slot), 0u);

  ExpectNoUnknownAllocations(rt);
  FreeRuntimeAndExpectMemorySlotsCleared(rt);
}
#endif

}  // namespace heap_test
