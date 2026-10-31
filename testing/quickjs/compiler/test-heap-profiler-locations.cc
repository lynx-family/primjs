// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>
#include <fstream>
#include <memory>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

#include "gc/collector.h"
#include "gc/trace-gc.h"
#include "gtest/gtest.h"
#include "inspector/heapprofiler/heapprofiler.h"
#include "inspector/interface.h"

namespace quickjs {
namespace heapprofiler {
namespace {

class LocationStream : public OutputStream {
 public:
  uint32_t GetChunkSize() override { return 7; }
  void WriteChunk(const std::string& chunk) override { json += chunk; }
  std::string json;
};

class FunctionLocations
    : public ::testing::TestWithParam<std::tuple<bool, bool>> {
 protected:
  void SetUp() override {
    const uint32_t mode = LEPUS_RUNTIME_ENABLE_ALLOCATION_TRACKING;
    if (std::get<0>(GetParam())) {
#ifdef ENABLE_COMPATIBLE_MM
      rt = JS_NewRuntime_GC(mode, &current);
#else
      GTEST_SKIP() << "Tracing GC is disabled";
#endif
    } else {
      rt = LEPUS_NewRuntimeWithModeMemoryTrackSlot(mode, &current);
    }
    ASSERT_NE(rt, nullptr);
    ctx = LEPUS_NewContext(rt);
    ASSERT_NE(ctx, nullptr);
    a = LEPUS_AllocateMemorySlot(rt);
    b = LEPUS_AllocateMemorySlot(rt);
  }
  void TearDown() override {
    if (ctx) LEPUS_FreeContext(ctx);
    if (rt) LEPUS_FreeRuntime(rt);
  }
  LEPUSValue Eval(const char* source, int extra_flags = 0, int start_line = 0) {
    return LEPUS_Eval2(
        ctx, source, strlen(source), "same-url.js",
        LEPUS_EVAL_TYPE_GLOBAL | extra_flags |
            (std::get<1>(GetParam()) ? LEPUS_EVAL_FLAG_STRIP : 0),
        start_line);
  }
  void Run(const char* source, int start_line = 0) {
    auto value = Eval(source, 0, start_line);
    ASSERT_FALSE(LEPUS_IsException(value));
    Free(value);
  }
  void Free(LEPUSValue value) {
    if (!rt->gc_enable) LEPUS_FreeValue(ctx, value);
  }
  HeapEntry* Entry(HeapSnapshot* snapshot, const void* ptr) {
    auto id = snapshot->profiler()->object_id_maps()->GetEntryObjectId(
        HeapObjPtr{const_cast<void*>(ptr), HeapObjPtr::kWithoutPtr});
    return snapshot->GetEntryById(id);
  }
  const HeapSnapshot::Location* Location(HeapSnapshot* snapshot,
                                         HeapEntry* entry) {
    if (!entry) return nullptr;
    for (const auto& location : snapshot->locations())
      if (location.entry_index == entry->index()) return &location;
    return nullptr;
  }
  HeapEntry* Child(HeapEntry* entry, const char* name) {
    if (!entry) return nullptr;
    for (uint32_t i = 0; i < entry->children_count(); ++i)
      if (entry->child(i)->name() == name) return entry->child(i)->to();
    return nullptr;
  }
  bool IsStripped() const { return std::get<1>(GetParam()); }
  void CheckLocationFlags() {
    current = a;
    const char* source = "globalThis.flagged = function flagged() {};";
    Run(source);
    auto value = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "flagged");
    HandleScope scope(ctx, &value, HANDLE_TYPE_LEPUS_VALUE);
    auto* object = LEPUS_VALUE_GET_OBJ(value);
    auto* bytecode = object->u.func.function_bytecode;
    const bool has_offsets = !IsStripped();
    ASSERT_EQ(bytecode->has_debug, has_offsets);
    const auto source_id = has_offsets ? bytecode->debug.source_id : 0u;
    const auto source_offset = has_offsets ? bytecode->debug.source_offset : -1;
    const auto filename = has_offsets ? bytecode->debug.filename : JS_ATOM_NULL;
    if (has_offsets) {
      ASSERT_NE(source_id, 0u);
      EXPECT_EQ(source_offset, strstr(source, "function flagged") - source);
    }

    auto check_json = [](const char* json, bool expected_locations) {
      ASSERT_NE(json, nullptr);
      EXPECT_NE(strstr(json, "\"locations\":["), nullptr);
      EXPECT_NE(strstr(json, "\"primjs_sources\":{\"version\":1"), nullptr);
      EXPECT_EQ(strstr(json, "\"locations\":[]") == nullptr,
                expected_locations);
      EXPECT_EQ(strstr(json, "\"scripts\":[]") == nullptr, expected_locations);
    };
    HeapProfiler profiler;
    for (int32_t slot : {-1, a}) {
      for (uint32_t summarize :
           {0u, uint32_t{LEPUS_HEAP_SNAPSHOT_SUMMARIZE_DIAGNOSTICS}}) {
        size_t entry_count = 0, edge_count = 0, charged_bytes = 0;
        // Reuse both profilers across off/on/off without changing VM metadata.
        for (uint32_t locations :
             {0u, uint32_t{LEPUS_HEAP_SNAPSHOT_INCLUDE_LOCATIONS}, 0u}) {
          const uint32_t flags = summarize | locations;
          SCOPED_TRACE(flags);
          SCOPED_TRACE(slot);
          const bool expected_locations = locations && has_offsets;
          auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, slot, flags);
          ASSERT_NE(snapshot, nullptr);
          auto* entry = Entry(snapshot, object);
          ASSERT_NE(entry, nullptr);
          EXPECT_GT(entry->self_size(), 0u);
          auto* location = Location(snapshot, entry);
          EXPECT_EQ(location != nullptr, expected_locations);
          EXPECT_EQ(snapshot->locations().empty(), !expected_locations);
          EXPECT_EQ(snapshot->sources().empty(), !expected_locations);
          if (location) {
            EXPECT_EQ(location->source_offset, source_offset);
            EXPECT_EQ(snapshot->sources()[location->script_id - 1],
                      "same-url.js");
          }
          auto* code = Entry(snapshot, bytecode);
          ASSERT_NE(code, nullptr);
          EXPECT_GT(code->self_size(), 0u);
          size_t bytes = 0;
          for (const auto& node : snapshot->entries())
            bytes += node.self_size();
          if (!entry_count) {
            entry_count = snapshot->entries().size();
            edge_count = snapshot->edges().size();
            charged_bytes = bytes;
          }
          EXPECT_EQ(snapshot->entries().size(), entry_count);
          EXPECT_EQ(snapshot->edges().size(), edge_count);
          EXPECT_EQ(bytes, charged_bytes);
          LocationStream stream;
          HeapSnapshotJSONSerializer(snapshot).Serialize(&stream);
          check_json(stream.json.c_str(), expected_locations);
          snapshot->Delete();

          const char* json =
              slot < 0
                  ? js_profile_take_heap_snapshot_flags(ctx, flags)
                  : js_profile_take_heap_snapshot_for_slot(ctx, slot, flags);
          check_json(json, expected_locations);
          js_profile_free_heap_snapshot(json);
          EXPECT_EQ(bytecode->has_debug, has_offsets);
          if (has_offsets) {
            EXPECT_EQ(bytecode->debug.source_id, source_id);
            EXPECT_EQ(bytecode->debug.source_offset, source_offset);
            EXPECT_EQ(bytecode->debug.filename, filename);
          }
          EXPECT_EQ(current, a);
        }
      }
    }
    // The internal profiler retains its existing location-export default.
    auto* full = profiler.TakeSnapshot(ctx, nullptr);
    ASSERT_NE(full, nullptr);
    EXPECT_EQ(Location(full, Entry(full, object)) != nullptr, has_offsets);
    const char* json = js_profile_take_heap_snapshot(ctx);
    check_json(json, false);
    js_profile_free_heap_snapshot(json);
    Free(value);
  }
  LEPUSRuntime* rt = nullptr;
  LEPUSContext* ctx = nullptr;
  int32_t current = 0, a = -1, b = -1;
};

TEST_P(FunctionLocations, FullAndSlotFlagsControlLocationExport) {
  CheckLocationFlags();
}

TEST_P(FunctionLocations, FullCoverageSummaryPreservesLiveAndArchivedCharges) {
  constexpr int32_t runtime_id = 345;
  const char* source =
      "globalThis.coveredFull = function coveredFull(n) { return n ? 1 : 2; };"
      "coveredFull(1);";
  auto result =
      LEPUS_Eval_WITH_COVERAGE(ctx, source, strlen(source), "full-coverage.js",
                               LEPUS_EVAL_TYPE_GLOBAL, 0, runtime_id);
  ASSERT_FALSE(LEPUS_IsException(result));
  Free(result);
  auto function = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "coveredFull");
  auto* code = LEPUS_VALUE_GET_OBJ(function)->u.func.function_bytecode;
  ASSERT_NE(code->coverage_info, nullptr);
  HeapProfiler profiler;
  auto id = [&](const void* ptr) {
    return profiler.object_id_maps()->GetEntryObjectId(
        HeapObjPtr{const_cast<void*>(ptr), HeapObjPtr::kWithoutPtr});
  };
  auto code_id = id(code);
  Free(function);
  std::vector<SnapshotObjectId> storage_ids;
  size_t expected = 0;
  list_head* el;
  list_for_each(el, &rt->coverage_list) {
    auto* info = list_entry(el, JSCoverageInfo, link);
    expected += sizeof(JSCoverageInfo) +
                info->slot_count * (sizeof(JSCoverageSlot) + sizeof(uint32_t));
    for (const void* ptr :
         {static_cast<void*>(info), static_cast<void*>(info->coverage_slots),
          static_cast<void*>(info->coverage_counters)})
      storage_ids.push_back(id(ptr));
  }
  ASSERT_GT(expected, 0u);
  size_t length = 0;
  const char* dump = JS_GetCoverageDumpString(ctx, runtime_id, &length);
  ASSERT_NE(dump, nullptr);
  const std::string expected_dump(dump, length);
  JS_FreeCoverageDumpString(dump);
  for (bool archived : {false, true}) {
    if (archived) Run("coveredFull = null;");
    size_t detailed_bytes = 0;
    for (uint32_t summarize :
         {0u, uint32_t{LEPUS_HEAP_SNAPSHOT_SUMMARIZE_DIAGNOSTICS}, 0u}) {
      auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, -1, summarize);
      ASSERT_NE(snapshot, nullptr);
      EXPECT_EQ(snapshot->GetEntryById(code_id) != nullptr, !archived);
      size_t bytes = 0, edges = 0;
      for (auto& node : snapshot->entries()) {
        bytes += node.self_size();
        edges += node.children_count();
        EXPECT_EQ(&node, &snapshot->entries()[node.index()]);
        EXPECT_EQ(node.name().find("[slot="), std::string::npos);
        for (uint32_t i = 0; i < node.children_count(); ++i) {
          EXPECT_EQ(node.child(i)->from(), &node);
          EXPECT_EQ(node.child(i)->to(),
                    &snapshot->entries()[node.child(i)->to()->index()]);
        }
      }
      EXPECT_EQ(edges, snapshot->edges().size());
      if (!detailed_bytes) detailed_bytes = bytes;
      EXPECT_EQ(bytes, detailed_bytes);
      for (auto storage_id : storage_ids)
        EXPECT_EQ(snapshot->GetEntryById(storage_id) != nullptr, !summarize);
      auto* summary = snapshot->GetEntryById(6);
      if (summarize) {
        ASSERT_NE(summary, nullptr);
        EXPECT_EQ(summary->name(), "[coverage]");
        EXPECT_EQ(summary->self_size(), expected);
        EXPECT_EQ(summary->children_count(), 0u);
      } else {
        EXPECT_EQ(summary, nullptr);
      }
      snapshot->Delete();
      dump = JS_GetCoverageDumpString(ctx, runtime_id, &length);
      ASSERT_NE(dump, nullptr);
      EXPECT_EQ(std::string(dump, length), expected_dump);
      JS_FreeCoverageDumpString(dump);
    }
  }
}

#ifdef ENABLE_QUICKJS_DEBUGGER
TEST_P(FunctionLocations, FullConsoleSummaryUsesBusinessRootsAcrossContexts) {
  struct Debugger {
    explicit Debugger(LEPUSContext* context) : context(context) {
      QJSDebuggerInitialize(context);
    }
    ~Debugger() { QJSDebuggerFree(context); }
    LEPUSContext* context;
  } debugger(ctx);
  std::unique_ptr<LEPUSContext, decltype(&LEPUS_FreeContext)> other(
      LEPUS_NewContext(rt), LEPUS_FreeContext);
  Debugger other_debugger(other.get());
  // Heap edges require reference-valued properties; immediate numbers have
  // no target node and cannot identify the owning object in the graph.
  Run("globalThis.kept = {fullKeptMarker: 'kept'};"
      "console.log(kept, {fullExclusiveMarker: 'exclusive'});");
  const char* source = "console.log({fullOtherContextMarker: 'other'});";
  auto result = LEPUS_Eval(other.get(), source, strlen(source), "other.js",
                           LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!rt->gc_enable) LEPUS_FreeValue(other.get(), result);
  auto* info = ctx->debugger_info;
  auto* other_info = other->debugger_info;
  auto messages = LEPUS_VALUE_GET_PTR(info->console.messages);
  auto other_messages = LEPUS_VALUE_GET_PTR(other_info->console.messages);
  auto generation = info->console.generations[0];
  auto other_generation = other_info->console.generations[0];
  auto find_marker = [](HeapSnapshot* snapshot,
                        const char* marker) -> HeapEntry* {
    for (auto& entry : snapshot->entries())
      for (uint32_t i = 0; i < entry.children_count(); ++i)
        if (entry.child(i)->type() == HeapGraphEdge::kProperty &&
            entry.child(i)->name() == marker)
          return &entry;
    return nullptr;
  };
  HeapProfiler profiler;
  auto* detailed = profiler.TakeSnapshot(ctx, nullptr);
  auto* kept = find_marker(detailed, "fullKeptMarker");
  ASSERT_NE(kept, nullptr);
  size_t expected = 0;
  for (const auto& entry : detailed->entries()) expected += entry.self_size();
  for (uint32_t flags :
       {uint32_t{LEPUS_HEAP_SNAPSHOT_SUMMARIZE_DIAGNOSTICS}, 0u}) {
    auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, -1, flags);
    ASSERT_NE(snapshot, nullptr);
    auto* survivor = find_marker(snapshot, "fullKeptMarker");
    ASSERT_NE(survivor, nullptr);
    EXPECT_EQ(survivor->id(), kept->id());
    EXPECT_EQ(survivor->name(), kept->name());
    EXPECT_EQ(survivor->self_size(), kept->self_size());
    EXPECT_EQ(find_marker(snapshot, "fullExclusiveMarker") == nullptr,
              flags != 0);
    EXPECT_EQ(find_marker(snapshot, "fullOtherContextMarker") == nullptr,
              flags != 0);
    size_t bytes = 0;
    for (const auto& entry : snapshot->entries()) bytes += entry.self_size();
    EXPECT_EQ(bytes, expected);
    EXPECT_EQ(snapshot->GetEntryById(4) != nullptr, flags != 0);
    EXPECT_EQ(LEPUS_VALUE_GET_PTR(info->console.messages), messages);
    EXPECT_EQ(LEPUS_VALUE_GET_PTR(other_info->console.messages),
              other_messages);
    EXPECT_EQ(info->console.length, 1);
    EXPECT_EQ(other_info->console.length, 1);
    EXPECT_EQ(info->console.generations[0], generation);
    EXPECT_EQ(other_info->console.generations[0], other_generation);
    snapshot->Delete();
  }
}
#endif

TEST_P(FunctionLocations, TextPositionsRespectStripAndGC) {
  current = a;
  const char* source =
      u8"\r\n/*中😀*/ function F() {}\rclass Base {}\n"
      "class Child extends Base {}\u2028globalThis.arrow = () => 1;"
      "\u2029function* gen(){}\n"
      "globalThis.items = [F, Base, Child, arrow, gen, new F(), [], gen()];";
  Run(source, 7);
  auto items = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "items");
  HandleScope scope(ctx, &items, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_RunGC(rt);
  HeapProfiler profiler;
  for (int32_t slot : {-1, a}) {
    auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, slot);
    ASSERT_NE(snapshot, nullptr);
    const char* anchors[] = {"function F", "class Base", "class Child", "() =>",
                             "function* gen"};
    for (uint32_t i = 0; i < 8; ++i) {
      auto value = LEPUS_GetPropertyUint32(ctx, items, i);
      auto* object = LEPUS_VALUE_GET_OBJ(value);
      auto* entry = Entry(snapshot, object);
      ASSERT_NE(entry, nullptr);
      auto* location = Location(snapshot, entry);
      if (i < 5 && !IsStripped()) {
        ASSERT_NE(location, nullptr) << i;
        // UTF-8 bytes, including CR/LF and non-BMP characters; no line base.
        EXPECT_EQ(location->source_offset, strstr(source, anchors[i]) - source)
            << i;
        EXPECT_EQ(object->u.func.function_bytecode->debug.source_offset,
                  location->source_offset);
        EXPECT_EQ(entry->type(), HeapEntry::kClosure);
        auto* bytecode = Child(entry, "function_bytecode");
        ASSERT_NE(bytecode, nullptr);
        EXPECT_EQ(bytecode->type(), HeapEntry::kCode);
        auto* filename = Child(bytecode, "filename");
        ASSERT_NE(filename, nullptr);
        auto filename_atom = object->u.func.function_bytecode->debug.filename;
        EXPECT_EQ(filename, Entry(snapshot, rt->atom_array[filename_atom]));
        auto* bc_location = Location(snapshot, bytecode);
        ASSERT_NE(bc_location, nullptr);
        EXPECT_EQ(bc_location->script_id, location->script_id);
        EXPECT_EQ(bc_location->source_offset, location->source_offset);
        EXPECT_EQ(snapshot->sources()[location->script_id - 1], "same-url.js");
      } else {
        EXPECT_EQ(location, nullptr) << i;
      }
      Free(value);
    }
    for (const auto& location : snapshot->locations()) {
      auto type = snapshot->entries()[location.entry_index].type();
      EXPECT_TRUE(type == HeapEntry::kCode || type == HeapEntry::kClosure);
    }
    if (IsStripped()) {
      EXPECT_TRUE(snapshot->locations().empty());
      EXPECT_TRUE(snapshot->sources().empty());
    }
  }
  Free(items);
}

TEST_P(FunctionLocations, SharedClosuresAndDistinctCompilations) {
  Run("function make(){return function shared(){};} "
      "globalThis.one=make(); globalThis.two=make();");
  Run("globalThis.three = function shared(){};");
  auto one = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "one");
  auto two = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "two");
  auto three = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "three");
  auto* b1 = LEPUS_VALUE_GET_OBJ(one)->u.func.function_bytecode;
  auto* b2 = LEPUS_VALUE_GET_OBJ(two)->u.func.function_bytecode;
  auto* b3 = LEPUS_VALUE_GET_OBJ(three)->u.func.function_bytecode;
  EXPECT_EQ(b1, b2);
  EXPECT_NE(b1, b3);
  ASSERT_EQ(b1->has_debug, !IsStripped());
  ASSERT_EQ(b3->has_debug, !IsStripped());
  if (!IsStripped()) {
    EXPECT_EQ(b1->debug.filename, b3->debug.filename);
    ASSERT_NE(b1->debug.source_id, 0u);
    ASSERT_NE(b3->debug.source_id, 0u);
    EXPECT_NE(b1->debug.source_id, b3->debug.source_id);
  }
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr);
  auto* l1 = Location(snapshot, Entry(snapshot, LEPUS_VALUE_GET_PTR(one)));
  auto* l2 = Location(snapshot, Entry(snapshot, LEPUS_VALUE_GET_PTR(two)));
  auto* l3 = Location(snapshot, Entry(snapshot, LEPUS_VALUE_GET_PTR(three)));
  if (IsStripped()) {
    EXPECT_EQ(l1, nullptr);
    EXPECT_EQ(l2, nullptr);
    EXPECT_EQ(l3, nullptr);
    EXPECT_TRUE(snapshot->sources().empty());
    Free(one);
    Free(two);
    Free(three);
    return;
  }
  ASSERT_NE(l1, nullptr);
  ASSERT_NE(l2, nullptr);
  ASSERT_NE(l3, nullptr);
  EXPECT_EQ(l1->script_id, l2->script_id);
  EXPECT_NE(l1->script_id, l3->script_id);
  EXPECT_EQ(l1->source_offset, l2->source_offset);
  EXPECT_NE(l1->source_offset, l3->source_offset);
  ASSERT_EQ(snapshot->sources().size(), 2u);
  EXPECT_EQ(snapshot->sources()[l1->script_id - 1], "same-url.js");
  EXPECT_EQ(snapshot->sources()[l3->script_id - 1], "same-url.js");
  Free(one);
  Free(two);
  Free(three);
  // Snapshot metadata owns its bytes, including after the VM is destroyed.
  LEPUS_FreeContext(ctx);
  ctx = nullptr;
  LEPUS_FreeRuntime(rt);
  rt = nullptr;
  LocationStream stream;
  HeapSnapshotJSONSerializer(snapshot).Serialize(&stream);
  EXPECT_NE(stream.json.find("\"primjs_sources\":{\"version\":1"),
            std::string::npos);
  EXPECT_NE(stream.json.find("same-url.js"), std::string::npos);
  EXPECT_NE(
      stream.json.find("\"location_fields\":[\"object_index\",\"script_id\","
                       "\"source_offset\"]"),
      std::string::npos);
  for (const auto& location : snapshot->locations()) {
    auto serialized = std::to_string(location.entry_index * 6) + "," +
                      std::to_string(location.script_id) + "," +
                      std::to_string(location.source_offset);
    EXPECT_NE(stream.json.find(serialized), std::string::npos);
  }
}

TEST_P(FunctionLocations, LoadedBytecodeHasNoInventedLocation) {
  current = a;
  auto compiled =
      Eval("function cached(){}; cached;", LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(compiled));
  HandleScope scope(ctx, &compiled, HANDLE_TYPE_LEPUS_VALUE);
  auto* original =
      static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(compiled));
  ASSERT_EQ(original->has_debug, !IsStripped());
  if (original->has_debug) {
    ASSERT_NE(original->debug.filename, JS_ATOM_NULL);
    ASSERT_NE(original->debug.source_id, 0u);
    EXPECT_EQ(original->debug.source_offset, 0);
  }
  size_t size = 0;
  auto* buffer =
      LEPUS_WriteObject(ctx, &size, compiled, LEPUS_WRITE_OBJ_BYTECODE);
  ASSERT_NE(buffer, nullptr);
  scope.PushHandle(buffer, HANDLE_TYPE_DIR_HEAP_OBJ);
  auto loaded = LEPUS_ReadObject(ctx, buffer, size, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(loaded));
  auto* bytecode =
      static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(loaded));
  scope.PushHandle(&loaded, HANDLE_TYPE_LEPUS_VALUE);
  EXPECT_EQ(bytecode->has_debug, original->has_debug);
  if (bytecode->has_debug) {
    EXPECT_EQ(bytecode->debug.source_id, 0u);
    EXPECT_EQ(bytecode->debug.source_offset, -1);
    EXPECT_EQ(bytecode->debug.filename, original->debug.filename);
  }
  for (int i = 0; i < bytecode->cpool_count; ++i) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(bytecode->cpool[i])) {
      auto* child = static_cast<LEPUSFunctionBytecode*>(
          LEPUS_VALUE_GET_PTR(bytecode->cpool[i]));
      if (child->has_debug) {
        EXPECT_EQ(child->debug.source_id, 0u);
        EXPECT_EQ(child->debug.source_offset, -1);
      }
    }
  }
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a,
                                         LEPUS_HEAP_SNAPSHOT_INCLUDE_LOCATIONS);
  ASSERT_NE(snapshot, nullptr);
  auto* entry = Entry(snapshot, bytecode);
  ASSERT_NE(entry, nullptr);
  EXPECT_EQ(Location(snapshot, entry), nullptr);
  Free(loaded);
  Free(compiled);
  if (!rt->gc_enable) lepus_free(ctx, buffer);
}

TEST_P(FunctionLocations, MethodsAndModuleDefinitions) {
  const char* source =
      "globalThis.methods = {\n"
      "  method() {},\n"
      "  async work() {},\n"
      "  *iter() {},\n"
      "  get value() { return 1; }\n"
      "};\n"
      "class Explicit {\n"
      "  constructor() {}\n"
      "}\n"
      "globalThis.definitions = [methods.method, methods.work, methods.iter,\n"
      "  Object.getOwnPropertyDescriptor(methods, 'value').get, Explicit];";
  auto module =
      LEPUS_Eval2(ctx, source, strlen(source), "module.js",
                  LEPUS_EVAL_TYPE_MODULE | LEPUS_EVAL_FLAG_COMPILE_ONLY |
                      (std::get<1>(GetParam()) ? LEPUS_EVAL_FLAG_STRIP : 0),
                  0);
  ASSERT_FALSE(LEPUS_IsException(module));
  auto result = LEPUS_EvalFunction(ctx, module, ctx->global_obj);
  ASSERT_FALSE(LEPUS_IsException(result));
  Free(result);
  auto definitions = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "definitions");
  HandleScope scope(ctx, &definitions, HANDLE_TYPE_LEPUS_VALUE);
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr);
  const char* anchors[] = {"method()", "async work()", "*iter()", "get value()",
                           "class Explicit"};
  for (uint32_t i = 0; i < 5; ++i) {
    auto value = LEPUS_GetPropertyUint32(ctx, definitions, i);
    ASSERT_TRUE(LEPUS_IsObject(value));
    auto* location =
        Location(snapshot, Entry(snapshot, LEPUS_VALUE_GET_PTR(value)));
    if (IsStripped()) {
      EXPECT_EQ(location, nullptr);
    } else {
      ASSERT_NE(location, nullptr) << i;
      EXPECT_EQ(location->source_offset, strstr(source, anchors[i]) - source)
          << i;
      EXPECT_EQ(snapshot->sources()[location->script_id - 1], "module.js");
    }
    Free(value);
  }
  Free(definitions);
}

TEST_P(FunctionLocations, FailedCompilationReleasesFilenameAtoms) {
  if (rt->gc_enable) GTEST_SKIP() << "RC allocator fault injection";
  const char* source = "function outer(){return function inner(){};} outer;";
  auto warmup = Eval(source, LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(warmup));
  Free(warmup);
  struct Probe {
    decltype(LEPUSMallocFunctions::lepus_malloc) original;
    int remaining;
    bool failed = false;
  } probe{rt->mf.lepus_malloc, 0};
  // malloc_state.opaque belongs to the RC allocation tracker.
  static thread_local Probe* active_probe;
  for (int fail_at : {1, 2, 3}) {
    size_t stable_size = 0, stable_count = 0;
    for (int i = 0; i < 5; ++i) {
      probe.failed = false;
      probe.remaining = fail_at;
      active_probe = &probe;
      rt->mf.lepus_malloc = [](JSMallocState* state, size_t size,
                               int tag) -> void* {
        // Exercise both parser ownership and partially transferred bytecodes.
        if (tag == ALLOC_TAG_LEPUSFunctionBytecode &&
            --active_probe->remaining == 0) {
          active_probe->failed = true;
          return nullptr;
        }
        return active_probe->original(state, size, tag);
      };
      auto value = Eval(source, LEPUS_EVAL_FLAG_COMPILE_ONLY);
      rt->mf.lepus_malloc = probe.original;
      active_probe = nullptr;
      ASSERT_TRUE(probe.failed);
      ASSERT_TRUE(LEPUS_IsException(value));
      Free(LEPUS_GetException(ctx));
      LEPUS_RunGC(rt);
      if (i == 0) {
        stable_size = rt->malloc_state.malloc_size;
        stable_count = rt->malloc_state.malloc_count;
      } else {
        EXPECT_EQ(rt->malloc_state.malloc_size, stable_size);
        EXPECT_EQ(rt->malloc_state.malloc_count, stable_count);
      }
    }
  }
  auto success = Eval(source, LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(success));
  Free(success);
}

TEST_P(FunctionLocations, FieldInitializerChildrenKeepInputOffsets) {
  const char* source =
      "class Fields { field = () => 1; "
      "static value = function nested() {}; }\n"
      "globalThis.fieldFunctions = [new Fields().field, Fields.value];";
  // Input offsets are independent of the optional line-number base.
  Run(source, -1);
  auto values = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "fieldFunctions");
  HandleScope scope(ctx, &values, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_RunGC(rt);
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr);
  const char* anchors[] = {"() =>", "function nested"};
  uint32_t script_id = 0;
  for (uint32_t i = 0; i < 2; ++i) {
    auto value = LEPUS_GetPropertyUint32(ctx, values, i);
    ASSERT_TRUE(LEPUS_IsObject(value));
    auto* location =
        Location(snapshot, Entry(snapshot, LEPUS_VALUE_GET_PTR(value)));
    if (IsStripped()) {
      EXPECT_EQ(location, nullptr);
    } else {
      ASSERT_NE(location, nullptr);
      EXPECT_EQ(location->source_offset, strstr(source, anchors[i]) - source);
      if (i == 0) script_id = location->script_id;
      EXPECT_EQ(location->script_id, script_id);
    }
    Free(value);
  }
  Free(values);
}

TEST_P(FunctionLocations, BytecodeLayoutUsesOptionalDebugTail) {
  const char* source = "function outer(){ return () => 1; } outer;";
  auto compiled = Eval(source, LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(compiled));
  HandleScope scope(ctx, &compiled, HANDLE_TYPE_LEPUS_VALUE);
  auto* root =
      static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(compiled));
  auto check = [&](auto&& visit, LEPUSFunctionBytecode* bytecode) -> void {
    EXPECT_EQ(bytecode->has_debug, !IsStripped());
    if (bytecode->has_debug) {
      EXPECT_GE(bytecode->debug.source_offset, 0);
      EXPECT_NE(bytecode->debug.source_id, 0u);
      EXPECT_NE(bytecode->debug.filename, JS_ATOM_NULL);
    }
    if (bytecode->cpool_count) {
      size_t header_size = bytecode->has_debug
                               ? sizeof(*bytecode)
                               : offsetof(LEPUSFunctionBytecode, debug);
      EXPECT_EQ(reinterpret_cast<uint8_t*>(bytecode->cpool),
                reinterpret_cast<uint8_t*>(bytecode) + header_size);
    }
    for (int i = 0; i < bytecode->cpool_count; ++i) {
      if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(bytecode->cpool[i]))
        visit(visit, static_cast<LEPUSFunctionBytecode*>(
                         LEPUS_VALUE_GET_PTR(bytecode->cpool[i])));
    }
  };
  check(check, root);
  Free(compiled);
}

TEST_P(FunctionLocations, FilenameUpdatesRespectOptionalDebugTail) {
  current = a;
  auto compiled = Eval(
      "function retained(){return 73;}"
      "function stripped(){'use strip';return (()=>91)();}"
      "globalThis.renamed = [retained,stripped];",
      LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(compiled));
  HandleScope scope(ctx, &compiled, HANDLE_TYPE_LEPUS_VALUE);
  auto* root =
      static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(compiled));
  struct Saved {
    LEPUSFunctionBytecode* bytecode;
    std::string code;
    std::vector<LEPUSValue> constants;
    uint32_t source_id;
    int source_offset;
  };
  std::vector<Saved> saved;
  auto save = [&](auto&& visit, LEPUSFunctionBytecode* bytecode) -> void {
    Saved item{bytecode,
               std::string(reinterpret_cast<char*>(bytecode->byte_code_buf),
                           bytecode->byte_code_len),
               {},
               bytecode->has_debug ? bytecode->debug.source_id : 0u,
               bytecode->has_debug ? bytecode->debug.source_offset : -1};
    for (int i = 0; i < bytecode->cpool_count; ++i)
      item.constants.push_back(bytecode->cpool[i]);
    saved.push_back(std::move(item));
    for (int i = 0; i < bytecode->cpool_count; ++i)
      if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(bytecode->cpool[i]))
        visit(visit, static_cast<LEPUSFunctionBytecode*>(
                         LEPUS_VALUE_GET_PTR(bytecode->cpool[i])));
  };
  save(save, root);
  LEPUS_SetFuncFileName(ctx, compiled, "renamed.js");
  size_t stripped_count = 0;
  for (const auto& item : saved) {
    auto* bytecode = item.bytecode;
    EXPECT_EQ(std::string(reinterpret_cast<char*>(bytecode->byte_code_buf),
                          bytecode->byte_code_len),
              item.code);
    if (!item.constants.empty())
      EXPECT_EQ(memcmp(bytecode->cpool, item.constants.data(),
                       item.constants.size() * sizeof(LEPUSValue)),
                0);
    if (bytecode->has_debug) {
      EXPECT_EQ(bytecode->debug.source_id, item.source_id);
      EXPECT_EQ(bytecode->debug.source_offset, item.source_offset);
      EXPECT_EQ(QjsHeapExplorer::AtomName(ctx, bytecode->debug.filename),
                "renamed.js");
    } else {
      ++stripped_count;
    }
  }
  EXPECT_GT(stripped_count, 0u);
  auto result = LEPUS_EvalFunction(ctx, compiled, ctx->global_obj);
  compiled = LEPUS_UNDEFINED;
  ASSERT_FALSE(LEPUS_IsException(result));
  Free(result);
  Run("if(renamed[0]() !== 73 || renamed[1]() !== 91)"
      "throw new Error('filename update changed bytecode');");
  auto values = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "renamed");
  scope.PushHandle(&values, HANDLE_TYPE_LEPUS_VALUE);
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr);
  ASSERT_NE(snapshot, nullptr);
  for (uint32_t i = 0; i < 2; ++i) {
    auto value = LEPUS_GetPropertyUint32(ctx, values, i);
    auto* entry = Entry(snapshot, LEPUS_VALUE_GET_PTR(value));
    ASSERT_NE(entry, nullptr);
    auto* location = Location(snapshot, entry);
    if (i == 0 && !IsStripped()) {
      ASSERT_NE(location, nullptr);
      EXPECT_EQ(snapshot->sources()[location->script_id - 1], "renamed.js");
    } else {
      EXPECT_EQ(location, nullptr);
    }
    Free(value);
  }
  Free(values);
}

TEST_P(FunctionLocations, OnlyNonStrippedFunctionsHaveOffsets) {
  const char* source =
      "function normal() {}"
      "function stripped() {'use strip'; return () => 1;}"
      "class Plain {}"
      "class Explicit { constructor() {'use strip';} }"
      "globalThis.definitions = [normal, stripped, stripped(), Plain, "
      "Explicit];";
  Run(source);
  auto values = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "definitions");
  HandleScope scope(ctx, &values, HANDLE_TYPE_LEPUS_VALUE);
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr);
  for (uint32_t i = 0; i < 5; ++i) {
    auto value = LEPUS_GetPropertyUint32(ctx, values, i);
    ASSERT_TRUE(LEPUS_IsObject(value));
    auto* object = LEPUS_VALUE_GET_OBJ(value);
    auto* bytecode = object->u.func.function_bytecode;
    auto* location = Location(snapshot, Entry(snapshot, object));
    if (!std::get<1>(GetParam()) && (i == 0 || i == 3)) {
      const char* anchor = i == 0 ? "function normal" : "class Plain";
      ASSERT_TRUE(bytecode->has_debug);
      EXPECT_EQ(bytecode->debug.source_offset, strstr(source, anchor) - source);
      ASSERT_NE(location, nullptr);
      EXPECT_EQ(location->source_offset, bytecode->debug.source_offset);
    } else {
      EXPECT_FALSE(bytecode->has_debug);
      EXPECT_EQ(location, nullptr);
    }
    Free(value);
  }
  if (std::get<1>(GetParam())) {
    EXPECT_TRUE(snapshot->locations().empty());
    EXPECT_TRUE(snapshot->sources().empty());
  }
  Free(values);
}

TEST_P(FunctionLocations, ScriptStripDirectiveSkipsSourceMetadata) {
  auto compiled = Eval("'use strip'; function outer(){return () => 1;}",
                       LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(compiled));
  HandleScope scope(ctx, &compiled, HANDLE_TYPE_LEPUS_VALUE);
  auto check = [&](auto&& visit, LEPUSFunctionBytecode* bytecode) -> void {
    EXPECT_FALSE(bytecode->has_debug);
    for (int i = 0; i < bytecode->cpool_count; ++i) {
      if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(bytecode->cpool[i]))
        visit(visit, static_cast<LEPUSFunctionBytecode*>(
                         LEPUS_VALUE_GET_PTR(bytecode->cpool[i])));
    }
  };
  check(check,
        static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(compiled)));
  Free(compiled);
}

TEST_P(FunctionLocations, ContextCompilationsHaveDistinctSourceIds) {
  std::unique_ptr<LEPUSContext, decltype(&LEPUS_FreeContext)> other(
      LEPUS_NewContext(rt), LEPUS_FreeContext);
  ASSERT_NE(other, nullptr);
  const char* source = "function same(){}; same;";
  auto first = Eval(source);
  ASSERT_FALSE(LEPUS_IsException(first));
  HandleScope scope(ctx, &first, HANDLE_TYPE_LEPUS_VALUE);
  auto second =
      LEPUS_Eval(other.get(), source, strlen(source), "same-url.js",
                 LEPUS_EVAL_TYPE_GLOBAL |
                     (std::get<1>(GetParam()) ? LEPUS_EVAL_FLAG_STRIP : 0));
  ASSERT_FALSE(LEPUS_IsException(second));
  scope.PushHandle(&second, HANDLE_TYPE_LEPUS_VALUE);
  auto* b1 = LEPUS_VALUE_GET_OBJ(first)->u.func.function_bytecode;
  auto* b2 = LEPUS_VALUE_GET_OBJ(second)->u.func.function_bytecode;
  EXPECT_NE(b1, b2);
  ASSERT_EQ(b1->has_debug, !IsStripped());
  ASSERT_EQ(b2->has_debug, !IsStripped());
  if (!IsStripped()) {
    ASSERT_NE(b1->debug.source_id, 0u);
    ASSERT_NE(b2->debug.source_id, 0u);
    EXPECT_NE(b1->debug.source_id, b2->debug.source_id);
    EXPECT_EQ(b1->debug.filename, b2->debug.filename);
  }
  LEPUS_RunGC(rt);
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr);
  auto* l1 = Location(snapshot, Entry(snapshot, b1));
  auto* l2 = Location(snapshot, Entry(snapshot, b2));
  if (IsStripped()) {
    EXPECT_EQ(l1, nullptr);
    EXPECT_EQ(l2, nullptr);
    EXPECT_TRUE(snapshot->sources().empty());
  } else {
    ASSERT_NE(l1, nullptr);
    ASSERT_NE(l2, nullptr);
    EXPECT_NE(l1->script_id, l2->script_id);
    EXPECT_EQ(snapshot->sources()[l1->script_id - 1], "same-url.js");
    EXPECT_EQ(snapshot->sources()[l2->script_id - 1], "same-url.js");
  }
  Free(first);
  Free(second);
}

TEST_P(FunctionLocations, CompilationsReceiveIdsInSnapshotEncounterOrder) {
  const char* sources[] = {"globalThis.first = function first(){};",
                           "globalThis.second = function second(){};",
                           "globalThis.third = function third(){};"};
  const char* filenames[] = {"z.js", "a.js", "z.js"};
  for (int i = 0; i < 3; ++i) {
    auto value =
        LEPUS_Eval(ctx, sources[i], strlen(sources[i]), filenames[i],
                   LEPUS_EVAL_TYPE_GLOBAL |
                       (std::get<1>(GetParam()) ? LEPUS_EVAL_FLAG_STRIP : 0));
    ASSERT_FALSE(LEPUS_IsException(value));
    Free(value);
  }
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr);
  if (IsStripped()) {
    EXPECT_TRUE(snapshot->locations().empty());
    EXPECT_TRUE(snapshot->sources().empty());
    return;
  }
  ASSERT_EQ(snapshot->sources().size(), 3u);
  uint32_t seen = 0;
  for (const auto& location : snapshot->locations()) {
    if (location.script_id > seen) EXPECT_EQ(location.script_id, ++seen);
  }
  EXPECT_EQ(seen, 3u);
  uint32_t ids[3];
  int i = 0;
  for (const char* name : {"first", "second", "third"}) {
    auto value = LEPUS_GetPropertyStr(ctx, ctx->global_obj, name);
    auto* location =
        Location(snapshot, Entry(snapshot, LEPUS_VALUE_GET_PTR(value)));
    ASSERT_NE(location, nullptr);
    ids[i] = location->script_id;
    EXPECT_EQ(snapshot->sources()[ids[i] - 1], filenames[i]);
    ++i;
    Free(value);
  }
  EXPECT_NE(ids[0], ids[2]);
  EXPECT_NE(ids[0], ids[1]);
  EXPECT_NE(ids[1], ids[2]);
}

TEST_P(FunctionLocations, ExhaustedSourceIdsDoNotAliasEarlierCompilations) {
  Run("globalThis.before = function before(){};");
  rt->last_source_id = UINT32_MAX - 1;
  Run("globalThis.last = function last(){return () => 1;};");
  Run("globalThis.exhausted = function exhausted(){};");
  Run("globalThis.stillExhausted = function stillExhausted(){};");
  EXPECT_EQ(rt->last_source_id, IsStripped() ? UINT32_MAX - 1 : UINT32_MAX);
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr);
  for (const char* name : {"before", "last", "exhausted", "stillExhausted"}) {
    auto value = LEPUS_GetPropertyStr(ctx, ctx->global_obj, name);
    auto* bytecode = LEPUS_VALUE_GET_OBJ(value)->u.func.function_bytecode;
    auto* location =
        Location(snapshot, Entry(snapshot, LEPUS_VALUE_GET_PTR(value)));
    if (IsStripped()) {
      EXPECT_FALSE(bytecode->has_debug);
      EXPECT_EQ(location, nullptr);
    } else if (!strcmp(name, "before") || !strcmp(name, "last")) {
      ASSERT_NE(location, nullptr);
      EXPECT_EQ(bytecode->debug.source_id,
                !strcmp(name, "last") ? UINT32_MAX : 1u);
    } else {
      EXPECT_EQ(bytecode->debug.source_id, 0u);
      EXPECT_EQ(location, nullptr);
    }
    Free(value);
  }
}

TEST_P(FunctionLocations, FilenameAtomsRespectStripAndPreserveTheirText) {
  const char* source = "globalThis.fileFunction = function named(){};";
  for (const char* filename : {"", "123", u8"路径😀.js"}) {
    auto result = LEPUS_Eval(
        ctx, source, strlen(source), filename,
        LEPUS_EVAL_TYPE_GLOBAL | (IsStripped() ? LEPUS_EVAL_FLAG_STRIP : 0));
    ASSERT_FALSE(LEPUS_IsException(result));
    Free(result);
    auto value = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "fileFunction");
    HandleScope scope(ctx, &value, HANDLE_TYPE_LEPUS_VALUE);
    LEPUS_RunGC(rt);
    HeapProfiler profiler;
    auto* snapshot = profiler.TakeSnapshot(ctx, nullptr);
    auto* location =
        Location(snapshot, Entry(snapshot, LEPUS_VALUE_GET_PTR(value)));
    if (IsStripped()) {
      EXPECT_EQ(location, nullptr);
      EXPECT_TRUE(snapshot->sources().empty());
    } else {
      ASSERT_NE(location, nullptr);
      EXPECT_EQ(snapshot->sources()[location->script_id - 1], filename);
#ifdef ENABLE_QUICKJS_DEBUGGER
      auto* bytecode = LEPUS_VALUE_GET_OBJ(value)->u.func.function_bytecode;
      EXPECT_EQ(bytecode->debug.file_name == nullptr,
                __JS_AtomIsTaggedInt(bytecode->debug.filename));
#endif
    }
    Free(value);
  }
}

TEST_P(FunctionLocations, SlotKeepsCrossSlotConstructorWithoutChargingIt) {
  current = a;
  Run("globalThis.Ctor = class Ctor {};");
  current = b;
  Run("globalThis.instance = new Ctor();"
      "globalThis.pageFunction = function pageFunction() {};");
  auto instance = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "instance");
  auto ctor = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "Ctor");
  auto page_function =
      LEPUS_GetPropertyStr(ctx, ctx->global_obj, "pageFunction");
  HeapProfiler profiler;
  for (uint32_t summarize :
       {0u, uint32_t{LEPUS_HEAP_SNAPSHOT_SUMMARIZE_DIAGNOSTICS}}) {
    uint32_t flags = summarize | LEPUS_HEAP_SNAPSHOT_INCLUDE_LOCATIONS;
    auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, b, flags);
    ASSERT_NE(snapshot, nullptr);
    auto* object = Entry(snapshot, LEPUS_VALUE_GET_PTR(instance));
    auto* constructor = Entry(snapshot, LEPUS_VALUE_GET_PTR(ctor));
    ASSERT_NE(object, nullptr);
    ASSERT_NE(constructor, nullptr);
    EXPECT_GT(object->self_size(), 0u);
    EXPECT_EQ(constructor->self_size(), 0u);
    EXPECT_EQ(Location(snapshot, object), nullptr);
    auto* ctor_location = Location(snapshot, constructor);
    auto* page_location =
        Location(snapshot, Entry(snapshot, LEPUS_VALUE_GET_PTR(page_function)));
    if (IsStripped()) {
      EXPECT_EQ(ctor_location, nullptr);
      EXPECT_EQ(page_location, nullptr);
      EXPECT_TRUE(snapshot->sources().empty());
      continue;
    }
    ASSERT_NE(ctor_location, nullptr);
    ASSERT_NE(page_location, nullptr);
    // The slot graph retains a constructor from another same-name input.
    // Its offset belongs to that input, not the target page's source.
    EXPECT_NE(ctor_location->script_id, page_location->script_id);
    EXPECT_EQ(snapshot->sources()[ctor_location->script_id - 1], "same-url.js");
    EXPECT_EQ(snapshot->sources()[page_location->script_id - 1], "same-url.js");
    EXPECT_EQ(ctor_location->source_offset, strlen("globalThis.Ctor = "));
    EXPECT_EQ(page_location->source_offset,
              strlen("globalThis.instance = new Ctor();"
                     "globalThis.pageFunction = "));
    auto* shape = Child(object, "shape");
    ASSERT_NE(shape, nullptr);
    auto* prototype = Child(shape, "proto");
    ASSERT_NE(prototype, nullptr);
    EXPECT_EQ(Child(prototype, "constructor"), constructor);
    // Optionally export real fixtures for analyzer integration checks.
    if (const char* output =
            summarize ? getenv("PRIMJS_LOCATION_FIXTURES") : nullptr) {
      LocationStream stream;
      HeapSnapshotJSONSerializer(snapshot).Serialize(&stream);
      std::string path =
          std::string(output) + "/" + (rt->gc_enable ? "gc" : "rc") +
          (std::get<1>(GetParam()) ? "-strip" : "") + "-detailed.heapsnapshot";
      std::ofstream(path) << stream.json;
    }
  }
  Free(instance);
  Free(ctor);
  Free(page_function);
}

TEST_P(FunctionLocations, SlotSourceBindingCandidatesHaveIndependentLocations) {
  current = a;
  Run("/* another page */ function otherOne(){} function otherTwo(){}"
      "function otherThree(){} function otherFour(){} function otherFive(){}");
  current = b;
  const char* source =
      u8"/*😀*/function pageOne(){}\r\n"
      "async function pageTwo(){}\n"
      "function* pageThree(){}\n"
      "function pageFour(){}\n"
      "function pageFive(){}\n"
      "globalThis.arrow = () => 1;\n"
      "globalThis.methods = {method(){}, async work(){}, *iter(){}};\n"
      "globalThis.retained = [new otherOne(),new otherTwo(),new otherThree(),"
      "new otherFour(),new otherFive()];";
  Run(source);
  auto local = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "pageOne");
  auto foreign = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "otherOne");
  HeapProfiler profiler;
  for (uint32_t summarize :
       {0u, uint32_t{LEPUS_HEAP_SNAPSHOT_SUMMARIZE_DIAGNOSTICS}}) {
    uint32_t flags = summarize | LEPUS_HEAP_SNAPSHOT_INCLUDE_LOCATIONS;
    auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, b, flags);
    auto* local_entry = Entry(snapshot, LEPUS_VALUE_GET_PTR(local));
    auto* foreign_entry = Entry(snapshot, LEPUS_VALUE_GET_PTR(foreign));
    ASSERT_NE(local_entry, nullptr);
    ASSERT_NE(foreign_entry, nullptr);
    EXPECT_GT(local_entry->self_size(), 0u);
    EXPECT_EQ(foreign_entry->self_size(), 0u);
    auto* local_location = Location(snapshot, local_entry);
    auto* foreign_location = Location(snapshot, foreign_entry);
    if (IsStripped()) {
      EXPECT_EQ(local_location, nullptr);
      EXPECT_EQ(foreign_location, nullptr);
      EXPECT_TRUE(snapshot->sources().empty());
      continue;
    }
    ASSERT_NE(local_location, nullptr);
    ASSERT_NE(foreign_location, nullptr);
    EXPECT_NE(local_location->script_id, foreign_location->script_id);
    EXPECT_EQ(snapshot->sources()[local_location->script_id - 1],
              "same-url.js");
    EXPECT_EQ(snapshot->sources()[foreign_location->script_id - 1],
              "same-url.js");
    if (const char* output =
            summarize ? getenv("PRIMJS_PREFLIGHT_FIXTURES") : nullptr) {
      LocationStream stream;
      HeapSnapshotJSONSerializer(snapshot).Serialize(&stream);
      std::string path =
          std::string(output) + "/" + (rt->gc_enable ? "gc" : "rc") +
          (std::get<1>(GetParam()) ? "-strip" : "") + "-detailed.heapsnapshot";
      std::ofstream(path) << stream.json;
      std::ofstream(std::string(output) + "/page.js") << source;
    }
  }
  Free(local);
  Free(foreign);
}

INSTANTIATE_TEST_SUITE_P(MemoryModes, FunctionLocations,
                         ::testing::Combine(::testing::Bool(),
                                            ::testing::Bool()));
}  // namespace
}  // namespace heapprofiler
}  // namespace quickjs
