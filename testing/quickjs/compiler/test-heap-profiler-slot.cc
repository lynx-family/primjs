// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstdlib>
#include <cstring>
#include <fstream>
#include <limits>
#include <memory>
#include <string>
#include <unordered_set>
#include <vector>

#include "gc/collector.h"
#include "gc/collector_ms.h"
#include "gc/ros_allocator.h"
#include "gc/trace-gc.h"
#include "gtest/gtest.h"
#include "inspector/heapprofiler/gen.h"
#include "inspector/heapprofiler/heapprofiler.h"
#include "inspector/heapprofiler/serialize.h"
#include "inspector/interface.h"
#include "quickjs/include/quickjs-inner.h"

namespace quickjs {
namespace heapprofiler {
namespace {

size_t SnapshotBytes(const HeapSnapshot& snapshot) {
  size_t bytes = 0;
  for (const auto& entry : snapshot.entries()) bytes += entry.self_size();
  return bytes;
}

size_t UncoveredBytes(HeapSnapshot& snapshot) {
  auto* group = snapshot.GetEntryById(0);
  if (!group) return 0;
  EXPECT_EQ(group->name(), "[root path uncovered]");
  size_t bytes = 0;
  for (uint32_t i = 0; i < group->children_count(); ++i) {
    EXPECT_EQ(group->child(i)->type(), HeapGraphEdge::kWeak);
    bytes += group->child(i)->to()->self_size();
  }
  return bytes;
}

class RecordingSnapshotStream : public OutputStream {
 public:
  explicit RecordingSnapshotStream(uint32_t chunk_size)
      : chunk_size_(chunk_size) {}
  uint32_t GetChunkSize() override { return chunk_size_; }
  void WriteChunk(const std::string& chunk) override {
    chunks.push_back(chunk);
    content += chunk;
  }
  std::vector<std::string> chunks;
  std::string content;

 private:
  uint32_t chunk_size_;
};

TEST(HeapSnapshotWriter, PreservesBytesAcrossChunksAndReuse) {
  for (uint32_t chunk_size : {1u, 4u, 64u}) {
    SCOPED_TRACE(chunk_size);
    RecordingSnapshotStream stream(chunk_size);
    OutputStreamWriter writer(&stream);
    writer.AddString("ab");
    writer.AddString(std::string("c\0d", 3));
    writer.AddString('e');
    writer.AddString(static_cast<unsigned char>(0xff));
    writer.Finalize();
    std::string expected("abc\0de", 6);
    expected += static_cast<char>(0xff);
    EXPECT_EQ(stream.content, expected);
    if (chunk_size == 4) {
      ASSERT_EQ(stream.chunks.size(), 2u);
      EXPECT_EQ(stream.chunks[0], std::string("abc\0d", 5));
      EXPECT_EQ(stream.chunks[1], expected.substr(5));
    }
    writer.AddString("x");
    writer.Finalize();
    EXPECT_EQ(stream.content, expected + "x");
  }
  RecordingSnapshotStream stream(4);
  OutputStreamWriter writer(&stream);
  writer.AddString("ab");
  writer.Clear();
  writer.AddString("cd");
  writer.Finalize();
  EXPECT_EQ(stream.content, "cd");
  writer.Finalize();
  EXPECT_EQ(stream.content, "cd");
}

TEST(HeapSnapshotWriter, PreservesUnsignedNumbersAcrossChunks) {
  const uint64_t values[] = {0, std::numeric_limits<uint32_t>::max(),
                             uint64_t{1} << 32, uint64_t{1} << 63,
                             std::numeric_limits<uint64_t>::max()};
  const std::string expected =
      "0,4294967295,4294967296,9223372036854775808,"
      "18446744073709551615,";
  for (uint32_t chunk_size : {1u, 20u, 4096u}) {
    SCOPED_TRACE(chunk_size);
    RecordingSnapshotStream stream(chunk_size);
    OutputStreamWriter writer(&stream);
    for (auto value : values) {
      writer.AddNumber(value);
      writer.AddString(',');
    }
    writer.Finalize();
    EXPECT_EQ(stream.content, expected);
    writer.AddNumber(7);
    writer.Finalize();
    EXPECT_EQ(stream.content, expected + "7");
  }
}

TEST(HeapSnapshotSerializer, KeepsLayoutAndWideFieldsAcrossChunks) {
  HeapProfiler profiler;
  for (int32_t slot : {-1, 3}) {
    HeapSnapshot snapshot(&profiler, slot);
    auto* root = snapshot.AddEntry(HeapEntry::kSynthetic, "root", 1, 0);
    auto* target = snapshot.AddEntry(
        HeapEntry::kString, std::string(u8"中😀") + '\0' + "tail",
        uint64_t{1} << 40, std::numeric_limits<size_t>::max());
    root->SetIndexedReference(HeapGraphEdge::kElement, 17, target);
    root->SetNamedReference(HeapGraphEdge::kProperty,
                            std::string("key\0tail", 8), target);
    snapshot.FillChildren();
    const std::string expected =
        "9,1,1,0,2,0\n,2,2,1099511627776," +
        std::to_string(std::numeric_limits<size_t>::max()) + ",0,0\n";
    std::string reference;
    for (uint32_t chunk_size : {4096u, 7u, 1u}) {
      SCOPED_TRACE(::testing::Message() << slot << "/" << chunk_size);
      RecordingSnapshotStream stream(chunk_size);
      HeapSnapshotJSONSerializer(&snapshot).Serialize(&stream);
      EXPECT_NE(stream.content.find("\"node_count\":2,\"edge_count\":2"),
                std::string::npos);
      EXPECT_NE(stream.content.find("\"nodes\":[" + expected + "]"),
                std::string::npos);
      EXPECT_NE(stream.content.find("\"edges\":[1,17,6\n,2,3,6\n]"),
                std::string::npos);
      EXPECT_NE(stream.content.find("\\u4E2D\\uD83D\\uDE00\\u0000tail"),
                std::string::npos);
      EXPECT_NE(stream.content.find("key\\u0000tail"), std::string::npos);
      if (reference.empty())
        reference = stream.content;
      else
        EXPECT_EQ(stream.content, reference);
    }
  }
}

TEST(HeapSnapshotIds, ReusesIdsWithoutAdvancingAfterTableGrowth) {
  HeapObjectIdMaps ids;
  std::vector<uint64_t> objects(512);
  std::vector<SnapshotObjectId> assigned;
  const auto first = ids.LastAssignedId();
  for (size_t i = 0; i < objects.size(); ++i) {
    HeapObjPtr ptr(&objects[i], HeapObjPtr::kDefaultPtr);
    auto id = ids.GetEntryObjectId(ptr);
    EXPECT_EQ(id, first + (i + 1) * HeapObjectIdMaps::kObjectIdStep);
    EXPECT_EQ(ids.GetEntryObjectId(ptr), id);
    EXPECT_EQ(ids.LastAssignedId(), id);
    assigned.push_back(id);
  }
  const auto last = ids.LastAssignedId();
  for (size_t i = objects.size(); i-- > 0;) {
    EXPECT_EQ(
        ids.GetEntryObjectId(HeapObjPtr(&objects[i], HeapObjPtr::kDefaultPtr)),
        assigned[i]);
  }
  EXPECT_EQ(ids.LastAssignedId(), last);
}

TEST(HeapSnapshotSerializer, PreservesStringContentsInBothModes) {
  class StringStream : public OutputStream {
   public:
    void WriteChunk(const std::string& chunk) override { json += chunk; }
    std::string json;
  };
  const struct {
    std::string input;
    const char* escaped;
  } cases[] = {
      {"plain", "plain"},
      {"\b\f\n\r\t\"\\", "\\b\\f\\n\\r\\t\\\"\\\\"},
      {std::string("prefix\0suffix", 13), "prefix\\u0000suffix"},
      {u8"中文é", "\\u4E2D\\u6587\\u00E9"},
      {u8"😀", "\\uD83D\\uDE00"},
  };
  HeapProfiler profiler;
  for (int32_t slot : {-1, 3}) {
    for (const auto& test : cases) {
      SCOPED_TRACE(::testing::Message() << slot << "/" << test.escaped);
      HeapSnapshot snapshot(&profiler, slot);
      snapshot.AddEntry(HeapEntry::kString, test.input, 101, 0);
      StringStream stream;
      HeapSnapshotJSONSerializer(&snapshot).Serialize(&stream);
      EXPECT_NE(stream.json.find(std::string("\"") + test.escaped + "\""),
                std::string::npos);
      for (const char* field :
           {"memory_slot", "slot_accounted_bytes",
            "include_internal_allocations", "snapshot_accounted_bytes",
            "excluded_internal_bytes", "reference_uncovered_bytes",
            "allocation_census_complete", "summarize_diagnostics"}) {
        EXPECT_EQ(stream.json.find(std::string("\"") + field + "\":"),
                  std::string::npos);
      }
    }
  }
}

TEST(HeapSnapshotNaming, ConvertsStringsAndAtomsWithoutVMAllocations) {
  const struct {
    const char* source;
    std::string expected;
  } cases[] = {
      {"''", ""},
      {"'ascii'", "ascii"},
      {"'1234'", "1234"},
      {u8"'café'", u8"café"},
      {u8"'中文😀'", u8"中文😀"},
      {R"('prefix\u0000suffix')", std::string("prefix\0suffix", 13)},
      {R"('\uD800x\uDC00')", u8"\uFFFDx\uFFFD"},
  };
  int32_t current = LEPUS_MEMORY_CATEGORY_COMMON;
  std::unique_ptr<LEPUSRuntime, decltype(&LEPUS_FreeRuntime)> rt(
      LEPUS_NewRuntimeWithModeMemoryTrackSlot(0, &current), LEPUS_FreeRuntime);
  const bool gc_mode = rt->gc_enable;
  {
    std::unique_ptr<LEPUSContext, decltype(&LEPUS_FreeContext)> context(
        LEPUS_NewContext(rt.get()), LEPUS_FreeContext);
    auto* ctx = context.get();
    HeapProfiler profiler;
#ifdef ENABLE_COMPATIBLE_MM
    // Keep the test inputs alive without letting incidental collection hide
    // allocations made by name conversion.
    if (gc_mode) rt->collector_->SetForbidGC();
#endif
    auto symbol_ctor = LEPUS_GetPropertyStr(ctx, ctx->global_obj, "Symbol");
    for (const auto& test : cases) {
      auto value = LEPUS_Eval(ctx, test.source, strlen(test.source),
                              "snapshot-name", LEPUS_EVAL_TYPE_GLOBAL);
      ASSERT_TRUE(LEPUS_IsString(value));
      auto atom = LEPUS_ValueToAtom(ctx, value);
      auto symbol = LEPUS_Call(ctx, symbol_ctor, LEPUS_UNDEFINED, 1, &value);
      ASSERT_TRUE(LEPUS_IsSymbol(symbol));
      LEPUSFunctionBytecode bytecode{};
      bytecode.func_name = atom;
      LEPUSModuleDef module{};
      module.module_name = atom;
      for (int32_t slot : {-1, 3}) {
        SCOPED_TRACE(::testing::Message()
                     << gc_mode << "/" << slot << "/" << test.source);
        HeapSnapshot snapshot(&profiler, slot);
        QjsHeapExplorer explorer(&snapshot, ctx);
        size_t before[LEPUS_MEMORY_SIZE_SLOTS] = {};
        if (gc_mode) LEPUS_DumpMemorySlots(rt.get(), before);
        auto* string_entry = explorer.AllocateEntry(ctx, value);
        auto* symbol_entry = explorer.AllocateEntry(ctx, symbol);
        auto* function_entry =
            explorer.AllocateEntry(ctx, HeapObjPtr{&bytecode});
        auto* module_entry = explorer.AllocateEntry(ctx, HeapObjPtr{&module});
        ASSERT_NE(string_entry, nullptr);
        ASSERT_NE(symbol_entry, nullptr);
        ASSERT_NE(function_entry, nullptr);
        ASSERT_NE(module_entry, nullptr);
        EXPECT_EQ(string_entry->name(), test.expected);
        EXPECT_EQ(symbol_entry->name(),
                  slot < 0 ? "Symbol(" + test.expected + ")" : test.expected);
        EXPECT_EQ(function_entry->name(),
                  test.expected.empty() ? "anonymous" : test.expected);
        EXPECT_EQ(module_entry->name(), test.expected);
        EXPECT_EQ(string_entry->type(), HeapEntry::kString);
        EXPECT_EQ(symbol_entry->type(), HeapEntry::kSymbol);
        if (gc_mode) {
          size_t after[LEPUS_MEMORY_SIZE_SLOTS];
          LEPUS_DumpMemorySlots(rt.get(), after);
          for (size_t i = 0; i < LEPUS_MEMORY_SIZE_SLOTS; ++i)
            EXPECT_EQ(after[i], before[i]) << "slot " << i;
          EXPECT_EQ(current, LEPUS_MEMORY_CATEGORY_COMMON);
        }
      }
      if (!gc_mode) {
        LEPUS_FreeValue(ctx, symbol);
        LEPUS_FreeAtom(ctx, atom);
        LEPUS_FreeValue(ctx, value);
      }
    }
#ifdef ENABLE_COMPATIBLE_MM
    if (gc_mode) rt->collector_->ResetForbidGC();
#endif
    if (!gc_mode) LEPUS_FreeValue(ctx, symbol_ctor);
  }
}

// An absent Context and a Runtime without slot tracking must fail explicitly,
// rather than silently returning an unfiltered whole-VM snapshot.
TEST(SlotHeapProfilerAPI, RejectsNullAndUntrackedRuntime) {
  // Phase 1: no Context means there is no Runtime/slot to inspect.
  EXPECT_EQ(js_profile_take_heap_snapshot(nullptr), nullptr);
  EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(nullptr, 0, true, false),
            nullptr);
  // Phase 2: a valid Context alone is insufficient. This Runtime has no slot
  // tracking, so the same null result must represent an unsupported request.
  auto* rt = LEPUS_NewRuntime();
  auto* ctx = LEPUS_NewContext(rt);
  EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(ctx, 0, true, false),
            nullptr);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

// Both values of the required argument must retain the same explicit failure
// behavior in GC and RC builds.
TEST(SlotHeapProfilerAPI, OptionsRejectUnsupportedRequests) {
  auto* rt = LEPUS_NewRuntime();
  auto* ctx = LEPUS_NewContext(rt);
  HeapProfiler profiler;
  for (bool include_internal : {false, true}) {
    for (bool summarize : {false, true}) {
      EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(
                    nullptr, 0, include_internal, summarize),
                nullptr);
      EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(ctx, 0, include_internal,
                                                       summarize),
                nullptr);
      EXPECT_EQ(
          profiler.TakeSnapshot(ctx, nullptr, 0, include_internal, summarize),
          nullptr);
      EXPECT_EQ(profiler.GetSnapshotCount(), 0u);
      EXPECT_FALSE(profiler.IsTakingSnapshot());
      EXPECT_EQ(profiler.context(), nullptr);
    }
  }
  // A failed slot request must leave the shared lifecycle ready for a full
  // snapshot. Deleting the successful result removes its stored graph.
  auto* full = profiler.TakeSnapshot(ctx, nullptr);
  ASSERT_NE(full, nullptr);
  EXPECT_EQ(profiler.GetSnapshotCount(), 1u);
  EXPECT_FALSE(profiler.IsTakingSnapshot());
  EXPECT_EQ(profiler.context(), nullptr);
  full->Delete();
  EXPECT_EQ(profiler.GetSnapshotCount(), 0u);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

// Exercise filtering independently of the JS engine: two strong root paths
// share a target, the holders form a cycle, a third holder has only a weak
// edge, and a second target allocation has no root path. Membership and
// incoming-edge counts verify that filtering preserves both strong paths
// without inventing a strong root for the orphan; its 128 bytes must remain
// explicitly uncovered.
TEST(SlotHeapProfilerGraph, PreservesAllStrongPathsAndCyclesButNotWeakHolders) {
  // Phase 1: construct root -> left/right -> target, plus left <-> right.
  // weak is rooted too, but its edge to target does not establish ownership;
  // orphan has no root path at all.
  HeapProfiler profiler;
  HeapSnapshot snapshot(&profiler, 3);
  snapshot.AddSyntheticRootEntries();
  auto* left = snapshot.AddEntry(HeapEntry::kObject, "left", 20, 0);
  auto* right = snapshot.AddEntry(HeapEntry::kObject, "right", 22, 0);
  auto* weak = snapshot.AddEntry(HeapEntry::kObject, "weak", 24, 0);
  auto* target = snapshot.AddEntry(HeapEntry::kObject, "target", 26, 0);
  auto* orphan = snapshot.AddEntry(HeapEntry::kNative, "orphan", 28, 0);
  snapshot.root()->SetNamedReference(HeapGraphEdge::kInternal, "left", left);
  snapshot.root()->SetNamedReference(HeapGraphEdge::kInternal, "right", right);
  snapshot.root()->SetNamedReference(HeapGraphEdge::kInternal, "weak", weak);
  left->SetNamedReference(HeapGraphEdge::kProperty, "target", target);
  right->SetNamedReference(HeapGraphEdge::kProperty, "target", target);
  left->SetNamedReference(HeapGraphEdge::kProperty, "right", right);
  right->SetNamedReference(HeapGraphEdge::kProperty, "left", left);
  weak->SetNamedReference(HeapGraphEdge::kWeak, "target", target);
  // Phase 2: only target/orphan belong to slot 3, contributing 64 + 128 bytes.
  // All three possible holders belong to different slots and contribute zero.
  std::vector<int32_t> slots(snapshot.entries().size(), -1);
  std::vector<size_t> sizes(snapshot.entries().size(), 0);
  slots[left->index()] = 4;
  slots[right->index()] = 5;
  slots[weak->index()] = 6;
  slots[target->index()] = slots[orphan->index()] = 3;
  sizes[target->index()] = 64;
  sizes[orphan->index()] = 128;
  // Phase 3: filter the completed graph. left/right must survive as strong
  // ancestors; weak must disappear despite its own root. orphan remains in the
  // allocation inventory, and its full 128 bytes must be marked uncovered.
  snapshot.FillChildren();
  snapshot.FilterForSlot(slots, sizes);
  EXPECT_NE(snapshot.GetEntryById(20), nullptr);
  EXPECT_NE(snapshot.GetEntryById(22), nullptr);
  EXPECT_EQ(snapshot.GetEntryById(24), nullptr);
  EXPECT_NE(snapshot.GetEntryById(26), nullptr);
  EXPECT_NE(snapshot.GetEntryById(28), nullptr);
  EXPECT_EQ(UncoveredBytes(snapshot), 128u);
  // Phase 4: count actual rebuilt edges, not only node membership. target must
  // still have two strong incoming edges, while orphan must have none; a
  // diagnostic grouping edge must not turn into a fabricated strong root.
  size_t strong_orphan_edges = 0, strong_target_edges = 0;
  for (auto& edge : snapshot.edges()) {
    if (edge.type() != HeapGraphEdge::kWeak) {
      if (edge.to()->id() == 28) ++strong_orphan_edges;
      if (edge.to()->id() == 26) ++strong_target_edges;
    }
  }
  EXPECT_EQ(strong_orphan_edges, 0u);
  EXPECT_EQ(strong_target_edges, 2u);
  EXPECT_EQ(snapshot.GetEntryById(26)->name(), "target [slot=3]");
  EXPECT_EQ(snapshot.GetEntryById(28)->name(), "orphan [slot=3]");
  auto* uncovered = snapshot.GetEntryById(0);
  ASSERT_NE(uncovered, nullptr);
  EXPECT_EQ(uncovered->name(), "[root path uncovered]");
  ASSERT_EQ(uncovered->children_count(), 1u);
  EXPECT_EQ(uncovered->child(0)->type(), HeapGraphEdge::kWeak);
  EXPECT_EQ(uncovered->child(0)->to()->id(), 28u);
}

// Changing root coverage must change only the diagnostic membership. V8 groups
// objects by name before comparing their IDs, so keep both stable across views.
TEST(SlotHeapProfilerGraph, RootCoverageKeepsComparisonIdentity) {
  HeapProfiler profiler;
  for (bool rooted : {false, true, false}) {
    HeapSnapshot snapshot(&profiler, 3);
    snapshot.AddSyntheticRootEntries();
    auto* target = snapshot.AddEntry(HeapEntry::kObject, "Object", 101, 0);
    if (rooted)
      snapshot.root()->SetNamedReference(HeapGraphEdge::kInternal, "root",
                                         target);
    std::vector<int32_t> slots(snapshot.entries().size(), -1);
    std::vector<size_t> sizes(snapshot.entries().size(), 0);
    slots[target->index()] = 3;
    sizes[target->index()] = 64;
    snapshot.FillChildren();
    snapshot.FilterForSlot(slots, sizes);
    auto* result = snapshot.GetEntryById(101);
    ASSERT_NE(result, nullptr);
    EXPECT_EQ(result->name(), "Object [slot=3]");
    EXPECT_EQ(result->self_size(), 64u);
    EXPECT_EQ(UncoveredBytes(snapshot), rooted ? 0u : 64u);
    auto* diagnostic = snapshot.GetEntryById(0);
    if (rooted) {
      EXPECT_EQ(diagnostic, nullptr);
    } else {
      ASSERT_NE(diagnostic, nullptr);
      ASSERT_EQ(diagnostic->children_count(), 1u);
      EXPECT_EQ(diagnostic->child(0)->type(), HeapGraphEdge::kWeak);
      EXPECT_EQ(diagnostic->child(0)->to(), result);
    }
  }
}

#ifdef ENABLE_QUICKJS_DEBUGGER
TEST(SlotHeapProfilerGraph, SummariesPreserveSharedRootsAndPhysicalCharges) {
  HeapProfiler profiler;
  for (bool include_internal : {false, true}) {
    for (bool summarize : {false, true}) {
      SCOPED_TRACE(::testing::Message()
                   << include_internal << "/" << summarize);
      HeapSnapshot snapshot(&profiler, 3, include_internal, summarize);
      snapshot.AddSyntheticRootEntries();
      auto* info = snapshot.AddEntry(HeapEntry::kNative, "info", 101, 0);
      auto* exclusive =
          snapshot.AddEntry(HeapEntry::kObject, "console", 103, 0);
      auto* cycle = snapshot.AddEntry(HeapEntry::kObject, "cycle", 105, 0);
      auto* coverage =
          snapshot.AddEntry(HeapEntry::kNative, "coverage", 107, 0);
      auto* shared = snapshot.AddEntry(HeapEntry::kObject, "shared", 109, 0);
      auto* weak = snapshot.AddEntry(HeapEntry::kObject, "weak", 111, 0);
      auto* orphan = snapshot.AddEntry(HeapEntry::kNative, "orphan", 113, 0);
      auto* ordinary =
          snapshot.AddEntry(HeapEntry::kNative, "ordinary", 115, 0);
      auto* foreign = snapshot.AddEntry(HeapEntry::kNative, "foreign", 117, 0);
      constexpr auto debug = HeapSnapshot::Diagnostic::kDebugger;
      constexpr auto cover = HeapSnapshot::Diagnostic::kCoverage;
      snapshot.SetDiagnosticReference(snapshot.root(), "debugger_info", info,
                                      debug);
      snapshot.SetDiagnosticReference(snapshot.root(), "coverage", coverage,
                                      cover);
      info->SetNamedReference(HeapGraphEdge::kInternal, "console.messages",
                              exclusive);
      exclusive->SetNamedReference(HeapGraphEdge::kProperty, "cycle", cycle);
      cycle->SetNamedReference(HeapGraphEdge::kProperty, "cycle", exclusive);
      exclusive->SetNamedReference(HeapGraphEdge::kProperty, "shared", shared);
      exclusive->SetNamedReference(HeapGraphEdge::kProperty, "weak", weak);
      info->SetNamedReference(HeapGraphEdge::kInternal, "foreign", foreign);
      snapshot.SetDiagnosticReference(exclusive, "coverage", coverage, cover);
      // A business property with a diagnostic-looking name is still business.
      snapshot.root()->SetNamedReference(HeapGraphEdge::kProperty,
                                         "debug.source", shared);
      snapshot.root()->SetNamedReference(HeapGraphEdge::kWeak, "weak", weak);
      snapshot.root()->SetNamedReference(HeapGraphEdge::kInternal, "ordinary",
                                         ordinary);
      std::vector<int32_t> slots(snapshot.entries().size(), -1);
      std::vector<size_t> sizes(snapshot.entries().size(), 0);
      std::vector<bool> visible(snapshot.entries().size(), false);
      HeapEntry* targets[] = {info,   exclusive, cycle,  coverage,
                              shared, weak,      orphan, ordinary};
      const size_t charges[] = {64, 32, 16, 128, 48, 24, 40, 13};
      for (size_t i = 0; i < 8; ++i) {
        slots[targets[i]->index()] = 3;
        sizes[targets[i]->index()] = charges[i];
        visible[targets[i]->index()] = i != 0 && i != 3 && i != 7;
      }
      slots[foreign->index()] = 4;
      sizes[foreign->index()] = 11;
      snapshot.FillChildren();
      snapshot.FilterForSlot(slots, sizes, visible);
      auto* business = snapshot.GetEntryById(109);
      ASSERT_NE(business, nullptr);
      EXPECT_EQ(business->name(), "shared [slot=3]");
      EXPECT_EQ(business->self_size(), 48u);
      EXPECT_EQ(UncoveredBytes(snapshot), 40u);
      if (summarize) {
        for (auto id : {101, 103, 105, 107, 111, 117})
          EXPECT_EQ(snapshot.GetEntryById(id), nullptr);
        auto* debug_summary = snapshot.GetEntryById(4);
        auto* coverage_summary = snapshot.GetEntryById(6);
        ASSERT_NE(debug_summary, nullptr);
        ASSERT_NE(coverage_summary, nullptr);
        EXPECT_EQ(debug_summary->name(), "[debugger]");
        EXPECT_EQ(coverage_summary->name(), "[coverage]");
        EXPECT_EQ(debug_summary->self_size(), 136u);
        EXPECT_EQ(coverage_summary->self_size(), 128u);
        EXPECT_EQ(debug_summary->children_count(), 0u);
        EXPECT_EQ(coverage_summary->children_count(), 0u);
      } else {
        EXPECT_EQ(snapshot.GetEntryById(4), nullptr);
        EXPECT_EQ(snapshot.GetEntryById(6), nullptr);
        EXPECT_NE(snapshot.GetEntryById(103), nullptr);
      }
      size_t sum = 0;
      for (const auto& node : snapshot.entries()) sum += node.self_size();
      const size_t excluded = include_internal ? 0 : (summarize ? 13 : 205);
      EXPECT_EQ(sum, 365u - excluded);
    }
  }
  HeapSnapshot empty(&profiler, 3, true, true);
  empty.AddSyntheticRootEntries();
  empty.FillChildren();
  empty.FilterForSlot(std::vector<int32_t>(empty.entries().size(), -1),
                      std::vector<size_t>(empty.entries().size(), 0));
  EXPECT_EQ(empty.GetEntryById(4), nullptr);
  EXPECT_EQ(empty.GetEntryById(6), nullptr);
}
#endif

TEST(SlotHeapProfilerGraph, CoverageSummaryIncludesOnlyDedicatedBlocks) {
  HeapProfiler profiler;
  for (bool include_internal : {false, true}) {
    for (bool summarize : {false, true}) {
      HeapSnapshot snapshot(&profiler, 3, include_internal, summarize);
      snapshot.AddSyntheticRootEntries();
      auto* coverage =
          snapshot.AddEntry(HeapEntry::kNative, "coverage", 101, 0);
      auto* counters =
          snapshot.AddEntry(HeapEntry::kNative, "counters", 103, 0);
      auto* atom = snapshot.AddEntry(HeapEntry::kString, "name", 105, 0);
      auto* ordinary =
          snapshot.AddEntry(HeapEntry::kNative, "ordinary", 107, 0);
      constexpr auto group = HeapSnapshot::Diagnostic::kCoverage;
      snapshot.SetDiagnosticReference(snapshot.root(), "coverage_info",
                                      coverage, group);
      snapshot.SetDiagnosticReference(coverage, "coverage_counters", counters,
                                      group);
      coverage->SetNamedReference(HeapGraphEdge::kInternal, "filename", atom);
      snapshot.root()->SetNamedReference(HeapGraphEdge::kInternal, "atom",
                                         atom);
      snapshot.root()->SetNamedReference(HeapGraphEdge::kInternal, "ordinary",
                                         ordinary);
      std::vector<int32_t> slots(snapshot.entries().size(), -1);
      std::vector<size_t> sizes(snapshot.entries().size(), 0);
      std::vector<bool> visible(snapshot.entries().size(), false);
      for (auto* node : {coverage, counters, atom, ordinary})
        slots[node->index()] = 3;
      sizes[coverage->index()] = 64;
      sizes[counters->index()] = 128;
      sizes[atom->index()] = 48;
      sizes[ordinary->index()] = 16;
      visible[atom->index()] = true;
      snapshot.FillChildren();
      snapshot.FilterForSlot(slots, sizes, visible);
      auto* summary = snapshot.GetEntryById(6);
      if (summarize) {
        ASSERT_NE(summary, nullptr);
        EXPECT_EQ(summary->name(), "[coverage]");
        EXPECT_EQ(summary->self_size(), 192u);
        EXPECT_EQ(summary->children_count(), 0u);
        EXPECT_EQ(snapshot.GetEntryById(101), nullptr);
        EXPECT_EQ(snapshot.GetEntryById(103), nullptr);
      } else {
        EXPECT_EQ(summary, nullptr);
      }
      EXPECT_EQ(snapshot.GetEntryById(4), nullptr);
      ASSERT_NE(snapshot.GetEntryById(105), nullptr);
      EXPECT_EQ(snapshot.GetEntryById(105)->self_size(), 48u);
      size_t sum = 0;
      for (const auto& node : snapshot.entries()) sum += node.self_size();
      const size_t expected = include_internal ? 256 : (summarize ? 240 : 48);
      EXPECT_EQ(sum, expected);
      EXPECT_EQ(UncoveredBytes(snapshot), 0u);
    }
  }
}

#ifdef ENABLE_COMPATIBLE_MM
class SlotHeapProfiler : public ::testing::Test {
 protected:
  // Context/bootstrap allocations belong to common. A/B/C are fresh page slots
  // on one real GC Runtime; Eval selects the owner of new engine allocations.
  void SetUp() override {
    rt = JS_NewRuntime_GC(0, &current);
    ASSERT_NE(rt, nullptr);
    ctx = LEPUS_NewContext(rt);
    ASSERT_NE(ctx, nullptr);
    a = LEPUS_AllocateMemorySlot(rt);
    b = LEPUS_AllocateMemorySlot(rt);
    c = LEPUS_AllocateMemorySlot(rt);
  }
  void TearDown() override {
    if (ctx) LEPUS_FreeContext(ctx);
    if (rt) LEPUS_FreeRuntime(rt);
  }
  void Eval(int32_t slot, const char* source) {
    // Select the owner for new allocations made by this script. This does not
    // migrate existing allocations; in particular, realloc keeps the old slot.
    current = slot;
    auto result = LEPUS_Eval(ctx, source, strlen(source), "slot-test.js",
                             LEPUS_EVAL_TYPE_GLOBAL);
    ASSERT_FALSE(LEPUS_IsException(result));
  }
  LEPUSValue Global(const char* name) {
    return LEPUS_GetPropertyStr(ctx, ctx->global_obj, name);
  }
  // Keep this profiler's IDs instead of managed pointers/Handles in release
  // phases. Those phases allocate no new A objects, so target-slot address
  // reuse cannot impersonate the removed allocation. Never dereference freed
  // memory.
  SnapshotObjectId ObjectId(HeapProfiler& profiler, const void* ptr) {
    return profiler.object_id_maps()->GetEntryObjectId(
        HeapObjPtr{const_cast<void*>(ptr), HeapObjPtr::kDefaultPtr});
  }
  HeapEntry* Entry(HeapSnapshot* snapshot, const void* ptr) {
    return snapshot->GetEntryById(ObjectId(*snapshot->profiler(), ptr));
  }
  HeapEntry* Property(HeapEntry* node, const char* name) {
    // Read a named snapshot edge; this does not evaluate a JS property/getter.
    if (!node) return nullptr;
    for (uint32_t i = 0; i < node->children_count(); ++i) {
      auto* edge = node->child(i);
      if (edge->name() == name) return edge->to();
    }
    return nullptr;
  }
  bool StrongPath(HeapSnapshot* snapshot, SnapshotObjectId target,
                  SnapshotObjectId excluded = 0) {
    std::vector<bool> seen(snapshot->entries().size(), false);
    std::vector<HeapEntry*> pending{snapshot->root()};
    seen[snapshot->root()->index()] = true;
    for (size_t i = 0; i < pending.size(); ++i) {
      auto* node = pending[i];
      if (node->id() == target) return true;
      for (uint32_t j = 0; j < node->children_count(); ++j) {
        auto* edge = node->child(j);
        auto* child = edge->to();
        if (edge->type() == HeapGraphEdge::kWeak ||
            edge->type() == HeapGraphEdge::kShortcut ||
            child->id() == excluded || seen[child->index()]) {
          continue;
        }
        seen[child->index()] = true;
        pending.push_back(child);
      }
    }
    return false;
  }
  bool HasEdge(HeapEntry* from, HeapEntry* to, HeapGraphEdge::Type type) {
    if (!from || !to) return false;
    for (uint32_t i = 0; i < from->children_count(); ++i) {
      auto* edge = from->child(i);
      if (edge->to() == to && edge->type() == type) return true;
    }
    return false;
  }
  bool InDiagnosticGroup(HeapSnapshot* snapshot, HeapEntry* entry,
                         const char* name) {
    for (auto& group : snapshot->entries()) {
      if (group.type() != HeapEntry::kSynthetic || group.name() != name)
        continue;
      EXPECT_EQ(group.self_size(), 0u);
      for (uint32_t i = 0; i < group.children_count(); ++i)
        EXPECT_EQ(group.child(i)->type(), HeapGraphEdge::kWeak);
      return HasEdge(&group, entry, HeapGraphEdge::kWeak);
    }
    return false;
  }
  struct SerializedObject {
    SnapshotObjectId id = 0;
    std::string name;
    int64_t size = 0;
  };
  SerializedObject ReadSerializedObject(const std::string& json,
                                        const char* marker) {
    // Decode in a separate Runtime so consumer allocations cannot change the
    // heap whose identity/collection behavior the test observes.
    std::unique_ptr<LEPUSRuntime, decltype(&LEPUS_FreeRuntime)> reader_rt(
        JS_NewRuntime_GC(0), LEPUS_FreeRuntime);
    std::unique_ptr<LEPUSContext, decltype(&LEPUS_FreeContext)> reader_ctx(
        LEPUS_NewContext(reader_rt.get()), LEPUS_FreeContext);
    auto* reader = reader_ctx.get();
    auto parsed = LEPUS_ParseJSON(reader, json.data(), json.size(), "snapshot");
    EXPECT_TRUE(LEPUS_IsObject(parsed));
    HandleScope roots(reader, &parsed, HANDLE_TYPE_LEPUS_VALUE);
    LEPUS_SetPropertyStr(reader, reader->global_obj, "snapshot", parsed);
    LEPUS_SetPropertyStr(reader, reader->global_obj, "marker",
                         LEPUS_NewString(reader, marker));
    const char* source = R"(
      (function() {
        const {nodes:n, edges:e, strings:s} = snapshot;
        const m = snapshot.snapshot.meta;
        const nw = m.node_fields.length, ew = m.edge_fields.length;
        const ni = x => m.node_fields.indexOf(x);
        const ei = x => m.edge_fields.indexOf(x);
        const property = m.edge_types[ei("type")].indexOf("property");
        for (let i = 0, p = 0; i < n.length; i += nw) {
          const end = p + n[i + ni("edge_count")] * ew;
          for (; p < end; p += ew) {
            if (e[p + ei("type")] === property &&
                s[e[p + ei("name_or_index")]] === marker) {
              return {id:n[i + ni("id")], name:s[n[i + ni("name")]],
                      size:n[i + ni("self_size")]};
            }
          }
        }
        return {id:0, name:"", size:0};
      })()
    )";
    auto result = LEPUS_Eval(reader, source, strlen(source), "read-snapshot",
                             LEPUS_EVAL_TYPE_GLOBAL);
    roots.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
    EXPECT_TRUE(LEPUS_IsObject(result));
    SerializedObject object;
    int64_t id = 0;
    LEPUS_ToInt64(reader, &id, LEPUS_GetPropertyStr(reader, result, "id"));
    object.id = static_cast<SnapshotObjectId>(id);
    LEPUS_ToInt64(reader, &object.size,
                  LEPUS_GetPropertyStr(reader, result, "size"));
    auto name = LEPUS_GetPropertyStr(reader, result, "name");
    roots.PushHandle(&name, HANDLE_TYPE_LEPUS_VALUE);
    const char* text = LEPUS_ToCString(reader, name);
    if (text) object.name = text;
    return object;
  }
  std::string PublicSnapshot(bool include_internal, bool summarize = false) {
    const char* json = js_profile_take_heap_snapshot_for_slot(
        ctx, a, include_internal, summarize);
    EXPECT_NE(json, nullptr);
    std::string result = json ? json : "";
    js_profile_free_heap_snapshot(json);
    return result;
  }
  std::string PublicFullSnapshot() {
    const char* json = js_profile_take_heap_snapshot(ctx);
    EXPECT_NE(json, nullptr);
    std::string result = json ? json : "";
    js_profile_free_heap_snapshot(json);
    return result;
  }
  size_t SerializedBytes(const char* json) {
    std::unique_ptr<LEPUSRuntime, decltype(&LEPUS_FreeRuntime)> reader_rt(
        JS_NewRuntime_GC(0), LEPUS_FreeRuntime);
    std::unique_ptr<LEPUSContext, decltype(&LEPUS_FreeContext)> reader_ctx(
        LEPUS_NewContext(reader_rt.get()), LEPUS_FreeContext);
    auto* reader = reader_ctx.get();
    auto parsed = LEPUS_ParseJSON(reader, json, strlen(json), "snapshot");
    EXPECT_TRUE(LEPUS_IsObject(parsed));
    HandleScope roots(reader, &parsed, HANDLE_TYPE_LEPUS_VALUE);
    LEPUS_SetPropertyStr(reader, reader->global_obj, "snapshot", parsed);
    const char* source = R"(
      (function() {
        const {nodes, snapshot: {meta}} = snapshot;
        const stride = meta.node_fields.length;
        const offset = meta.node_fields.indexOf("self_size");
        let sum = 0;
        for (let i = offset; i < nodes.length; i += stride) sum += nodes[i];
        return sum;
      })()
    )";
    auto value = LEPUS_Eval(reader, source, strlen(source), "snapshot-size",
                            LEPUS_EVAL_TYPE_GLOBAL);
    EXPECT_FALSE(LEPUS_IsException(value));
    int64_t bytes = -1;
    EXPECT_EQ(LEPUS_ToInt64(reader, &bytes, value), 0);
    return static_cast<size_t>(bytes);
  }
  size_t Bytes(int32_t slot) {
    size_t counters[LEPUS_MEMORY_SIZE_SLOTS];
    LEPUS_DumpMemorySlots(rt, counters);
    return counters[slot];
  }
  // Independently reconcile every node's physical size with the Runtime's slot
  // counter. Foreign holders contribute zero bytes. Also check contiguous node
  // indices, edge endpoints and the total child count after graph rebuilding.
  void CheckSizeAndIndices(HeapSnapshot* snapshot) {
    // Phase 1: accumulate all self sizes/child counts and verify each node and
    // edge still resolves to the expected entry after filtering renumbers it.
    size_t sum = 0, edges = 0;
    for (auto& node : snapshot->entries()) {
      sum += node.self_size();
      EXPECT_EQ(&snapshot->entries()[node.index()], &node);
      edges += node.children_count();
      for (uint32_t i = 0; i < node.children_count(); ++i) {
        auto* edge = node.child(i);
        EXPECT_EQ(edge->from(), &node);
        EXPECT_EQ(edge->to(), &snapshot->entries()[edge->to()->index()]);
      }
    }
    // Detailed views reconcile directly with the independent allocator.
    // Compact views exclude storage; their exact charges are checked against
    // dedicated fixtures and the corresponding detailed view below.
    if (snapshot->include_internal_allocations()) {
      EXPECT_EQ(sum, Bytes(snapshot->slot()));
    } else {
      EXPECT_LE(sum, Bytes(snapshot->slot()));
    }
    EXPECT_EQ(edges, snapshot->edges().size());
  }

  struct SharedShapeNodes {
    SnapshotObjectId shape = 0;
    SnapshotObjectId object_b = 0;
    SnapshotObjectId object_c = 0;
    size_t shape_size = 0;
  };

  // Build B/C with exactly the same A-owned shape. Property deletion detaches
  // a hashed shape, cloning it only when shared; this avoids manually changing
  // GC roots to manufacture collectability. All construction Handles expire
  // before the first snapshot, leaving B/C as the actual strong owners. The
  // Runtime hash cache is weak during the full parallel GC used by slot
  // snapshots.
  void CreateSharedShapeSnapshot(HeapProfiler& profiler, bool cached,
                                 SharedShapeNodes& nodes) {
    {
      HandleScope roots(ctx);
      // Phase 1: create a normal hash-cached shape in A. cached is only the
      // requested test mode; the actual engine state is shape->is_hashed.
      Eval(a, R"(
        globalThis.originalA = {
          uniqueShapeProperty: 1, second: 2, temporary: 3
        };
      )");
      if (!cached) {
        // temporary exists and is configurable, so delete_property must update
        // the shape's property metadata. js_shape_prepare_update either unlinks
        // an exclusively owned shape or clones a shared one; both leave the
        // object's current shape with is_hashed == FALSE.
        // Execute in A so a clone, if needed, is also charged to A.
        Eval(a, "delete originalA.temporary;");
      }
      auto original = Global("originalA");
      roots.PushHandle(&original, HANDLE_TYPE_LEPUS_VALUE);
      // Re-read p->shape after delete: the update may have replaced its
      // address. Check both the requested hash state and the allocation owner.
      auto* shape = LEPUS_VALUE_GET_OBJ(original)->shape;
      ASSERT_EQ(get_memory_slot(shape), a);
      ASSERT_EQ(static_cast<bool>(shape->is_hashed), cached);
      roots.PushHandle(shape, HANDLE_TYPE_DIR_HEAP_OBJ);
      nodes.shape = ObjectId(profiler, shape);
      // Phase 2: construct one B object and one C object around the same shape.
      // js_dup_shape shares the pointer rather than allocating a new shape;
      // the objects/storage belong to B/C, while the shape remains owned by A.
      for (int32_t owner : {b, c}) {
        current = owner;
        auto object =
            JS_NewObjectFromShape_GC(ctx, js_dup_shape(shape), JS_CLASS_OBJECT);
        roots.PushHandle(&object, HANDLE_TYPE_LEPUS_VALUE);
        ASSERT_TRUE(LEPUS_IsObject(object));
        auto* ptr = LEPUS_VALUE_GET_OBJ(object);
        // This low-level constructor does not initialize ordinary property
        // values. Initialize every slot before publishing the object to GC.
        for (int i = 0; i < shape->prop_count; ++i) {
          HeapObjStore(ctx, &ptr->gc_prop[i].u.value, LEPUS_UNDEFINED);
        }
        auto id = ObjectId(profiler, ptr);
        if (owner == b) {
          nodes.object_b = id;
        } else {
          nodes.object_c = id;
        }
        LEPUS_SetPropertyStr(ctx, ctx->global_obj,
                             owner == b ? "objectB" : "objectC", object);
      }
      // Phase 3: remove originalA's business reference, then leave this scope
      // to remove every temporary Handle. Carry only IDs into the GC phase;
      // objectB/objectC globals must now provide the actual strong references.
      Eval(LEPUS_MEMORY_CATEGORY_COMMON, "delete globalThis.originalA;");
    }
    // Phase 4: full GC must preserve the shared shape through B and C. Locate
    // all three nodes by their saved IDs before checking the exact shape edges.
    auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true);
    ASSERT_NE(snapshot, nullptr);
    auto* shape = snapshot->GetEntryById(nodes.shape);
    auto* node_b = snapshot->GetEntryById(nodes.object_b);
    auto* node_c = snapshot->GetEntryById(nodes.object_c);
    ASSERT_NE(shape, nullptr);
    ASSERT_NE(node_b, nullptr);
    ASSERT_NE(node_c, nullptr);
    // A owns one shape allocation; both foreign objects point to that same
    // node, contribute no A bytes, and remain visible as retainer context.
    EXPECT_EQ(shape->type(), HeapEntry::kObjectShape);
    EXPECT_GT(shape->self_size(), 0u);
    EXPECT_TRUE(InDiagnosticGroup(snapshot, shape, "[cross-slot]"));
    EXPECT_EQ(Property(node_b, "shape"), shape);
    EXPECT_EQ(Property(node_c, "shape"), shape);
    EXPECT_EQ(node_b->self_size(), 0u);
    EXPECT_EQ(node_c->self_size(), 0u);
    // Save only the shape's physical charge for the later release comparison.
    // Other A allocations may survive, so total A bytes need not become zero.
    nodes.shape_size = shape->self_size();
    CheckSizeAndIndices(snapshot);
  }

  int32_t current = 0, a = 0, b = 0, c = 0;
  LEPUSRuntime* rt = nullptr;
  LEPUSContext* ctx = nullptr;
};

// Grow the real Runtime hash in A, then remove all page references. The hash
// remains a Runtime root and must have its own named node and physical charge.
TEST_F(SlotHeapProfiler, RuntimeAtomHashHasStrongOwner) {
  current = a;
  for (int i = 0; rt->atom_hash_size < 16384 && i < 30000; ++i) {
    auto name = "slot_hash_key_" + std::to_string(i);
    ASSERT_NE(LEPUS_NewAtom(ctx, name.c_str()), JS_ATOM_NULL);
  }
  ASSERT_EQ(rt->atom_hash_size, 16384);
  ASSERT_EQ(get_memory_slot(rt->atom_hash), a);
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(snapshot, nullptr);
  auto* hash = Entry(snapshot, rt->atom_hash);
  auto* runtime = Entry(snapshot, rt);
  ASSERT_NE(hash, nullptr);
  ASSERT_NE(runtime, nullptr);
  EXPECT_EQ(Property(runtime, "atom_hash"), hash);
  EXPECT_EQ(hash->name(),
            "system / atom_hash [slot=" + std::to_string(a) + "]");
  EXPECT_TRUE(StrongPath(snapshot, hash->id()));
  EXPECT_FALSE(InDiagnosticGroup(snapshot, hash, "[root path uncovered]"));
  EXPECT_EQ(hash->self_size(), rt->ros_->GetAllocatedObjectSize(
                                   reinterpret_cast<address_t>(rt->atom_hash) -
                                   ROS_GC::kHeaderSize));
  EXPECT_EQ(UncoveredBytes(*snapshot), 0u);
  CheckSizeAndIndices(snapshot);
  auto* summarized = profiler.TakeSnapshot(ctx, nullptr, a, true, true);
  ASSERT_NE(summarized, nullptr);
  auto* summarized_hash = Entry(summarized, rt->atom_hash);
  ASSERT_NE(summarized_hash, nullptr);
  EXPECT_EQ(summarized_hash->id(), hash->id());
  EXPECT_EQ(summarized_hash->name(), hash->name());
  EXPECT_EQ(summarized_hash->self_size(), hash->self_size());
  EXPECT_TRUE(StrongPath(summarized, summarized_hash->id()));
  CheckSizeAndIndices(summarized);
}

// Native capacity retained after shrink still belongs to the real allocation.
TEST_F(SlotHeapProfiler, NativeAllocationChargesMatchCensus) {
  current = a;
  HandleScope roots(rt);
  std::vector<void*> blocks;
  const size_t lengths[] = {64, ROS_GC::RosAllocImpl::kLargeObjSize + 4096,
                            ROS_GC::RosAllocImpl::kHugeObjSize + 4096};
  for (size_t length : lengths) {
    auto* block = rt->js_malloc_rt(rt, length, ALLOC_TAG_WITHOUT_PTR);
    ASSERT_NE(block, nullptr);
    roots.PushHandle(block, HANDLE_TYPE_DIR_HEAP_OBJ);
    blocks.push_back(block);
    if (length != 64) {
      EXPECT_EQ(rt->js_realloc_rt(rt, block, 32, ALLOC_TAG_WITHOUT_PTR), block);
    }
  }
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true, true);
  ASSERT_NE(snapshot, nullptr);
  for (auto* block : blocks) {
    auto* entry = Entry(snapshot, block);
    ASSERT_NE(entry, nullptr);
    EXPECT_EQ(entry->self_size(),
              rt->ros_->GetAllocatedObjectSize(
                  reinterpret_cast<address_t>(block) - ROS_GC::kHeaderSize));
  }
  CheckSizeAndIndices(snapshot);
  auto json = PublicSnapshot(true, true);
  auto compact = PublicSnapshot(false, true);
  EXPECT_EQ(json.find("\"native_allocations\""), std::string::npos);
  EXPECT_EQ(compact.find("\"native_allocations\""), std::string::npos);
  EXPECT_EQ(current, a);
}

#ifdef ENABLE_QUICKJS_DEBUGGER
class ScopedSlotDebugger {
 public:
  explicit ScopedSlotDebugger(LEPUSContext* ctx) : ctx_(ctx) {
    QJSDebuggerInitialize(ctx_);
  }
  ~ScopedSlotDebugger() { QJSDebuggerFree(ctx_); }

 private:
  LEPUSContext* ctx_;
};

TEST_F(SlotHeapProfiler, DebuggerScriptStorageUsesAllocationMarkers) {
  ScopedSlotDebugger debugger(ctx);
  current = a;
  char source[] = "globalThis.scriptMarker = 1;";
  char url[] = "slot-diagnostic.js";
  auto* script = AddDebuggerScript(ctx, source, url, strlen(source), 0);
  ASSERT_NE(script, nullptr);
  LEPUS_HeapObjStore(ctx, &script->hash,
                     lepus_strdup(ctx, "script-hash", ALLOC_TAG_WITHOUT_PTR));
  LEPUS_HeapObjStore(
      ctx, &script->source_map_url,
      lepus_strdup(ctx, "slot-diagnostic.map", ALLOC_TAG_WITHOUT_PTR));
  // This descriptor is not in script_list: the allocation pass must classify
  // its dedicated storage even when rooted directly by a native Handle.
  auto* detached = static_cast<LEPUSScriptSource*>(lepus_mallocz(
      ctx, sizeof(LEPUSScriptSource), ALLOC_TAG_LEPUSScriptSource));
  ASSERT_NE(detached, nullptr);
  HandleScope roots(ctx, detached, HANDLE_TYPE_DIR_HEAP_OBJ);
  LEPUS_HeapObjStore(ctx, &detached->source,
                     lepus_strdup(ctx, source, ALLOC_TAG_WITHOUT_PTR));
  auto* debugger_info = ctx->debugger_info;
  SetDebuggerSourceCode(ctx, source);
  auto* bps = static_cast<LEPUSBreakpoint*>(lepus_mallocz(
      ctx, sizeof(LEPUSBreakpoint), ALLOC_TAG_LEPUSBreakpointArray));
  ASSERT_NE(bps, nullptr);
  LEPUS_HeapObjStore(ctx, &debugger_info->bps, bps);
  debugger_info->breakpoints_num = debugger_info->breakpoints_capacity = 1;
  LEPUS_HeapObjStore(ctx, &bps[0].script_url,
                     lepus_strdup(ctx, url, ALLOC_TAG_WITHOUT_PTR));
  LEPUS_HeapObjStore(ctx, &bps[0].condition,
                     LEPUS_NewString(ctx, "scriptMarker"));
  LEPUS_HeapObjStore(ctx, &bps[0].breakpoint_id,
                     LEPUS_NewString(ctx, "bp-marker"));
  LEPUS_HeapObjStore(ctx, &debugger_info->pause_on_next_statement_reason,
                     lepus_strdup(ctx, "summary-test", ALLOC_TAG_WITHOUT_PTR));
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(snapshot, nullptr);
  auto* descriptor = Entry(snapshot, script);
  auto* info = Entry(snapshot, ctx->debugger_info);
  ASSERT_NE(descriptor, nullptr);
  ASSERT_NE(info, nullptr);
  EXPECT_TRUE(HasEdge(info, descriptor, HeapGraphEdge::kInternal));
  EXPECT_TRUE(StrongPath(snapshot, descriptor->id()));
  EXPECT_FALSE(
      InDiagnosticGroup(snapshot, descriptor, "[root path uncovered]"));
  auto* storage = Entry(snapshot, script->source);
  EXPECT_EQ(Property(descriptor, "source"), nullptr);
  EXPECT_EQ(Property(descriptor, "url"), nullptr);
  EXPECT_EQ(Property(descriptor, "hash"), nullptr);
  EXPECT_EQ(Property(descriptor, "source_map_url"), nullptr);
  EXPECT_EQ(
      Property(info,
               ("script[" + std::to_string(script->id) + "]: " + url).c_str()),
      descriptor);
  ASSERT_NE(storage, nullptr);
  EXPECT_GT(storage->self_size(), 0u);
  EXPECT_FALSE(StrongPath(snapshot, storage->id()));
  auto* detached_node = Entry(snapshot, detached);
  ASSERT_NE(detached_node, nullptr);
  EXPECT_EQ(Property(detached_node, "source"), nullptr);
  EXPECT_FALSE(StrongPath(snapshot, Entry(snapshot, detached->source)->id()));
  EXPECT_EQ(Property(info, "bps"), Entry(snapshot, bps));
  EXPECT_EQ(Property(Entry(snapshot, bps), "script_url"),
            Entry(snapshot, bps[0].script_url));
  EXPECT_TRUE(
      StrongPath(snapshot, Entry(snapshot, debugger_info->source_code)->id()));
  CheckSizeAndIndices(snapshot);
  auto* summarized = profiler.TakeSnapshot(ctx, nullptr, a, true, true);
  ASSERT_NE(summarized, nullptr);
  EXPECT_EQ(Entry(summarized, script), nullptr);
  for (const void* ptr :
       {script->source, script->url, script->hash, script->source_map_url})
    EXPECT_EQ(Entry(summarized, ptr), nullptr);
  EXPECT_EQ(Entry(summarized, detached), nullptr);
  EXPECT_EQ(Entry(summarized, detached->source), nullptr);
  EXPECT_EQ(Entry(summarized, bps), nullptr);
  EXPECT_EQ(Entry(summarized, bps[0].script_url), nullptr);
  EXPECT_EQ(Entry(summarized, LEPUS_VALUE_GET_PTR(bps[0].condition)), nullptr);
  EXPECT_EQ(Entry(summarized, LEPUS_VALUE_GET_PTR(bps[0].breakpoint_id)),
            nullptr);
  EXPECT_EQ(Entry(summarized, debugger_info->source_code), nullptr);
  EXPECT_EQ(Entry(summarized, debugger_info->pause_on_next_statement_reason),
            nullptr);
  auto* summary = summarized->GetEntryById(4);
  ASSERT_NE(summary, nullptr);
  EXPECT_EQ(summary->children_count(), 0u);
  EXPECT_GT(summary->self_size(), storage->self_size());
  CheckSizeAndIndices(summarized);
}

TEST_F(SlotHeapProfiler, SummarizesConsoleAcrossContextsWithoutMutation) {
  std::unique_ptr<LEPUSContext, decltype(&LEPUS_FreeContext)> other(
      LEPUS_NewContext(rt), LEPUS_FreeContext);
  ScopedSlotDebugger debugger(ctx);
  ScopedSlotDebugger other_debugger(other.get());
  auto* info = ctx->debugger_info;
  auto* other_info = other->debugger_info;
  ASSERT_NE(info, other_info);
  Eval(a, R"(
    globalThis.keep = {keptConsoleMarker: "kept"};
    console.log(keep, {exclusiveConsoleMarker: "exclusive"});
    globalThis.shared = {otherContextConsoleMarker: "other"};
  )");
  LEPUS_SetPropertyStr(other.get(), other->global_obj, "shared",
                       Global("shared"));
  Eval(b, "shared = null;");
  const char* source = "console.log(shared); shared = null;";
  auto result = LEPUS_Eval(other.get(), source, strlen(source), "console-test",
                           LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(result));
  ASSERT_EQ(info->console.length, 1);
  ASSERT_EQ(other_info->console.length, 1);
  const auto generation = info->console.generations[0];
  const auto other_generation = other_info->console.generations[0];
  auto messages_ptr = LEPUS_VALUE_GET_PTR(info->console.messages);
  auto other_messages_ptr = LEPUS_VALUE_GET_PTR(other_info->console.messages);
  for (bool include_internal : {false, true}) {
    auto before = PublicSnapshot(include_internal, false);
    auto kept = ReadSerializedObject(before, "keptConsoleMarker");
    EXPECT_NE(kept.id, 0u);
    EXPECT_NE(ReadSerializedObject(before, "exclusiveConsoleMarker").id, 0u);
    EXPECT_NE(ReadSerializedObject(before, "otherContextConsoleMarker").id, 0u);
    auto after = PublicSnapshot(include_internal, true);
    EXPECT_EQ(ReadSerializedObject(after, "exclusiveConsoleMarker").id, 0u);
    EXPECT_EQ(ReadSerializedObject(after, "otherContextConsoleMarker").id, 0u);
    auto shared_kept = ReadSerializedObject(after, "keptConsoleMarker");
    EXPECT_EQ(shared_kept.id, kept.id);
    EXPECT_EQ(shared_kept.name, kept.name);
    EXPECT_EQ(shared_kept.size, kept.size);
    EXPECT_NE(after.find("[debugger]"), std::string::npos);
    EXPECT_EQ(after.find("console.messages"), std::string::npos);
    EXPECT_EQ(LEPUS_VALUE_GET_PTR(info->console.messages), messages_ptr);
    EXPECT_EQ(LEPUS_VALUE_GET_PTR(other_info->console.messages),
              other_messages_ptr);
    EXPECT_EQ(info->console.length, 1);
    EXPECT_EQ(other_info->console.length, 1);
    EXPECT_EQ(info->console.head, 0);
    EXPECT_EQ(other_info->console.head, 0);
    EXPECT_EQ(info->console.generations[0], generation);
    EXPECT_EQ(other_info->console.generations[0], other_generation);
  }
  // Expansion after projection still exposes the original cached objects.
  Eval(a, "console.log({nextConsoleMarker: 'afterSummaryUniqueValue'});");
  auto next = PublicSnapshot(false, false);
  EXPECT_EQ(info->console.length, 2);
  EXPECT_NE(ReadSerializedObject(next, "exclusiveConsoleMarker").id, 0u);
  EXPECT_NE(ReadSerializedObject(next, "nextConsoleMarker").id, 0u);
  HeapProfiler profiler;
  for (bool include_internal : {false, true}) {
    auto* snapshot =
        profiler.TakeSnapshot(ctx, nullptr, a, include_internal, true);
    ASSERT_NE(snapshot, nullptr);
    CheckSizeAndIndices(snapshot);
  }
}

TEST_F(SlotHeapProfiler, RejectedSnapshotsPreserveConsoleMessages) {
  ScopedSlotDebugger debugger(ctx);
  Eval(a, "console.log({rejectedSnapshotMarker: 'rejected'});");
  auto* info = ctx->debugger_info;
  auto messages_ptr = LEPUS_VALUE_GET_PTR(info->console.messages);
  const auto generation = info->console.generations[0];
  EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(ctx, -1, true, true),
            nullptr);
  rt->collector_->SetForbidGC();
  EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(ctx, a, true, true),
            nullptr);
  rt->collector_->ResetForbidGC();
  LEPUS_SetGCPauseSuppressionMode(rt, true);
  EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(ctx, a, true, true),
            nullptr);
  LEPUS_SetGCPauseSuppressionMode(rt, false);
  EXPECT_EQ(LEPUS_VALUE_GET_PTR(info->console.messages), messages_ptr);
  EXPECT_EQ(info->console.length, 1);
  EXPECT_EQ(info->console.generations[0], generation);
  EXPECT_NE(ReadSerializedObject(PublicSnapshot(true, false),
                                 "rejectedSnapshotMarker")
                .id,
            0u);
}
#endif

TEST_F(SlotHeapProfiler, SummarizesBytecodeDiagnosticsAndArchivedCoverage) {
  constexpr int32_t runtime_id = 301;
  constexpr char source[] =
      "globalThis.covered = function covered(n) { return n ? 1 : 2; }; "
      "covered(1);";
  current = a;
  auto result =
      LEPUS_Eval_WITH_COVERAGE(ctx, source, strlen(source), "slot-coverage.js",
                               LEPUS_EVAL_TYPE_GLOBAL, 0, runtime_id);
  ASSERT_FALSE(LEPUS_IsException(result));
  auto function = Global("covered");
  auto* bytecode = LEPUS_VALUE_GET_OBJ(function)->u.func.function_bytecode;
  ASSERT_NE(bytecode->coverage_info, nullptr);
  ASSERT_GT(bytecode->coverage_slot_count, 0u);
#ifdef ENABLE_QUICKJS_DEBUGGER
  // Include caller storage even when a build does not emit call-site strings.
  auto* callers = static_cast<CallerStrSlot*>(
      lepus_mallocz(ctx, sizeof(CallerStrSlot), ALLOC_TAG_CallerStrSlotArray));
  ASSERT_NE(callers, nullptr);
  callers[0].is_str = 1;
  LEPUS_HeapObjStore(ctx, &callers[0].str,
                     lepus_strdup(ctx, "covered(n)", ALLOC_TAG_WITHOUT_PTR));
  LEPUS_HeapObjStore(ctx, &bytecode->debug.caller_slots, callers);
#endif
  HeapProfiler profiler;
  auto bytecode_id = ObjectId(profiler, bytecode);
  std::vector<const void*> debug_storage = {bytecode->debug.source,
                                            bytecode->debug.pc2line_buf,
                                            bytecode->debug.caller_slots};
#ifdef ENABLE_QUICKJS_DEBUGGER
  debug_storage.push_back(callers[0].str);
#endif
  std::vector<SnapshotObjectId> debug_ids;
  for (auto* ptr : debug_storage)
    if (ptr) debug_ids.push_back(ObjectId(profiler, ptr));
  size_t dump_size = 0;
  const char* dump = JS_GetCoverageDumpString(ctx, runtime_id, &dump_size);
  ASSERT_NE(dump, nullptr);
  std::string expected_dump(dump, dump_size);
  JS_FreeCoverageDumpString(dump);
  size_t coverage_bytes = 0;
  std::vector<SnapshotObjectId> coverage_ids;
  list_head* el;
  list_for_each(el, &rt->coverage_list) {
    auto* info = list_entry(el, JSCoverageInfo, link);
    for (const void* ptr :
         {static_cast<const void*>(info),
          static_cast<const void*>(info->coverage_slots),
          static_cast<const void*>(info->coverage_counters)}) {
      ASSERT_NE(ptr, nullptr);
      ASSERT_EQ(get_memory_slot(const_cast<void*>(ptr)), a);
      coverage_ids.push_back(ObjectId(profiler, ptr));
      coverage_bytes += rt->ros_->GetAllocatedObjectSize(
          reinterpret_cast<address_t>(ptr) - ROS_GC::kHeaderSize);
    }
  }
  for (bool archived : {false, true}) {
    if (archived) Eval(b, "covered = null;");
    auto* detailed = profiler.TakeSnapshot(ctx, nullptr, a, true);
    ASSERT_NE(detailed, nullptr);
    EXPECT_EQ(detailed->GetEntryById(bytecode_id) != nullptr, !archived);
    for (auto id : coverage_ids) {
      auto* entry = detailed->GetEntryById(id);
      ASSERT_NE(entry, nullptr);
      EXPECT_TRUE(StrongPath(detailed, id));
      EXPECT_FALSE(InDiagnosticGroup(detailed, entry, "[root path uncovered]"));
    }
    if (!archived) {
      for (auto id : debug_ids) EXPECT_NE(detailed->GetEntryById(id), nullptr);
    }
    CheckSizeAndIndices(detailed);
    for (bool include_internal : {false, true}) {
      auto* snapshot =
          profiler.TakeSnapshot(ctx, nullptr, a, include_internal, true);
      ASSERT_NE(snapshot, nullptr);
      for (auto id : coverage_ids)
        EXPECT_EQ(snapshot->GetEntryById(id), nullptr);
#ifdef ENABLE_QUICKJS_DEBUGGER
      for (auto id : debug_ids) EXPECT_EQ(snapshot->GetEntryById(id), nullptr);
#else
      // Source and pc2line are engine storage even without an inspector.
      // They stay ordinary allocations instead of forming a debugger group.
      if (!archived && include_internal) {
        for (auto id : debug_ids) {
          auto* entry = snapshot->GetEntryById(id);
          ASSERT_NE(entry, nullptr);
          EXPECT_TRUE(StrongPath(snapshot, id));
        }
      }
      EXPECT_EQ(snapshot->GetEntryById(4), nullptr);
#endif
      auto* coverage = snapshot->GetEntryById(6);
      ASSERT_NE(coverage, nullptr);
      EXPECT_EQ(coverage->name(), "[coverage]");
      EXPECT_EQ(coverage->self_size(), coverage_bytes);
      EXPECT_EQ(coverage->children_count(), 0u);
#ifdef ENABLE_QUICKJS_DEBUGGER
      if (!archived) {
        auto* debug = snapshot->GetEntryById(4);
        ASSERT_NE(debug, nullptr);
        EXPECT_GT(debug->self_size(), 0u);
        EXPECT_EQ(debug->children_count(), 0u);
      }
#endif
      CheckSizeAndIndices(snapshot);
      dump = JS_GetCoverageDumpString(ctx, runtime_id, &dump_size);
      ASSERT_NE(dump, nullptr);
      EXPECT_EQ(std::string(dump, dump_size), expected_dump);
      JS_FreeCoverageDumpString(dump);
    }
  }
}

// The shape table is a weak cache in the full parallel GC used for snapshots.
// It must not invent a second root that bypasses the only business owner.
TEST_F(SlotHeapProfiler, ShapeCacheDoesNotBypassPrototypeHolder) {
  HeapProfiler profiler;
  Eval(a, "globalThis.protoA = {uniquePrototypeMarker: 23};");
  auto target = ObjectId(profiler, LEPUS_VALUE_GET_PTR(Global("protoA")));
  Eval(b, "globalThis.holderB = Object.create(protoA); protoA = null;");
  auto holder = ObjectId(profiler, LEPUS_VALUE_GET_PTR(Global("holderB")));
  // Phase 1: both modes must reach A through B, with no independent cache
  // route. A cache edge may be absent after filtering; if present it is weak.
  for (bool include_internal : {true, false}) {
    auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, include_internal);
    ASSERT_NE(snapshot, nullptr);
    EXPECT_TRUE(StrongPath(snapshot, target));
    EXPECT_FALSE(StrongPath(snapshot, target, holder));
    for (const auto& edge : snapshot->edges()) {
      if (edge.from()->name().find("system / shape_array") == 0 &&
          edge.to()->type() == HeapEntry::kObjectShape) {
        EXPECT_EQ(edge.type(), HeapGraphEdge::kWeak);
      }
    }
  }
  // Phase 2: no managed Handle keeps the prototype alive. Removing B really
  // releases A, which independently checks the expected cache strength.
  Eval(b, "holderB = null;");
  auto* released = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(released, nullptr);
  EXPECT_EQ(released->GetEntryById(target), nullptr);
}

// Unlike shape_hash, this collector strongly scans every live atom_array
// entry. Keep the Runtime path even after the last business object is gone.
TEST_F(SlotHeapProfiler, AtomTableRetainsDynamicNameAfterObjectRelease) {
  HeapProfiler profiler;
  Eval(a, "globalThis.atomOwner = {uniqueSlotAtomRetainer: 1};");
  auto* object = LEPUS_VALUE_GET_OBJ(Global("atomOwner"));
  auto owner = ObjectId(profiler, object);
  auto atom = get_shape_prop(object->shape)[0].atom;
  auto atom_id = ObjectId(profiler, rt->atom_array[atom]);
  // Phase 1: table and object/shape paths coexist. Removing the object from
  // graph traversal must leave the explicitly typed table -> atom edge.
  for (bool release_owner : {false, true}) {
    if (release_owner) Eval(b, "atomOwner = null;");
    for (bool include_internal : {true, false}) {
      auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, include_internal);
      ASSERT_NE(snapshot, nullptr);
      auto* table = Entry(snapshot, rt->atom_array);
      auto* name = snapshot->GetEntryById(atom_id);
      ASSERT_NE(table, nullptr);
      ASSERT_NE(name, nullptr);
      EXPECT_TRUE(HasEdge(table, name, HeapGraphEdge::kElement));
      EXPECT_TRUE(StrongPath(snapshot, atom_id, owner));
      EXPECT_GT(name->self_size(), 0u);
      if (release_owner) {
        // Phase 2: the object disappears, but the same atom allocation remains
        // explained by Runtime ownership, not a diagnostic orphan edge.
        EXPECT_EQ(snapshot->GetEntryById(owner), nullptr);
        EXPECT_FALSE(
            InDiagnosticGroup(snapshot, name, "[root path uncovered]"));
      }
    }
  }
}

// A native Handle to a JS array's backing allocation is a second real root.
// Traversing the JS Array first must not suppress buffer -> element edges.
TEST_F(SlotHeapProfiler, BackingArrayKeepsIndependentHandlePath) {
  HeapProfiler profiler;
  Eval(a, "globalThis.childA = {uniqueBufferChild: 11};");
  auto child = ObjectId(profiler, LEPUS_VALUE_GET_PTR(Global("childA")));
  Eval(b, "globalThis.arrayB = [childA]; childA = null;");
  auto* array = LEPUS_VALUE_GET_OBJ(Global("arrayB"));
  auto array_id = ObjectId(profiler, array);
  auto* buffer = array->u.array.u.values;
  auto buffer_id = ObjectId(profiler, buffer);
  {
    HandleScope roots(rt);
    roots.PushHandle(buffer, HANDLE_TYPE_DIR_HEAP_OBJ);
    // Phase 1: both roots are live. The buffer has exactly one element edge,
    // including when semantic traversal has already visited its contents.
    for (bool release_array : {false, true}) {
      if (release_array) Eval(b, "arrayB = null;");
      for (bool include_internal : {true, false}) {
        auto* snapshot =
            profiler.TakeSnapshot(ctx, nullptr, a, include_internal);
        ASSERT_NE(snapshot, nullptr);
        auto* storage = snapshot->GetEntryById(buffer_id);
        auto* target = snapshot->GetEntryById(child);
        ASSERT_NE(storage, nullptr);
        ASSERT_NE(target, nullptr);
        EXPECT_EQ(storage->self_size(), 0u);
        size_t element_edges = 0;
        for (uint32_t i = 0; i < storage->children_count(); ++i) {
          auto* edge = storage->child(i);
          if (edge->type() == HeapGraphEdge::kElement && edge->to() == target)
            ++element_edges;
        }
        EXPECT_EQ(element_edges, 1u);
        EXPECT_TRUE(StrongPath(snapshot, child, array_id));
        if (release_array) EXPECT_EQ(snapshot->GetEntryById(array_id), nullptr);
      }
    }
  }
  // Phase 2: removing the independent buffer Handle removes the final root,
  // so the A object must disappear from the next full-GC inventory.
  auto* released = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(released, nullptr);
  EXPECT_EQ(released->GetEntryById(child), nullptr);
}

// Public calls, not a reused test-only HeapProfiler, must share object
// identity. Resolve nodes by their actual property edges in the serialized
// snapshots.
TEST_F(SlotHeapProfiler, PublicSnapshotsKeepSurvivorIdentity) {
  for (bool include_internal : {true, false}) {
    Eval(a, R"(
      globalThis.firstA = {firstSnapshotMarker: "first"};
      globalThis.survivorA = {survivorSnapshotMarker: "survivor"};
    )");
    auto before = PublicSnapshot(include_internal);
    auto first = ReadSerializedObject(before, "firstSnapshotMarker");
    auto survivor = ReadSerializedObject(before, "survivorSnapshotMarker");
    ASSERT_NE(first.id, 0u);
    ASSERT_NE(survivor.id, 0u);
    ASSERT_NE(first.id, survivor.id);
    // Only firstA is removed. Parsing the first snapshot ran in another VM,
    // so it cannot perturb this Runtime's traversal or allocation order.
    Eval(b, "firstA = null;");
    auto after = PublicSnapshot(include_internal);
    auto remaining = ReadSerializedObject(after, "survivorSnapshotMarker");
    EXPECT_EQ(ReadSerializedObject(after, "firstSnapshotMarker").id, 0u);
    EXPECT_EQ(remaining.id, survivor.id);
    EXPECT_EQ(remaining.name, survivor.name);
    EXPECT_EQ(remaining.size, survivor.size);
    Eval(b, "survivorA = null;");
  }
}

// Alternate the public APIs around a collection. Both must use the Runtime's
// existing address-to-ID map, and neither may retain its serialized graph.
TEST_F(SlotHeapProfiler, PublicSlotAndFullSnapshotsShareSurvivorIdentity) {
  for (bool include_internal : {true, false}) {
    Eval(a, R"(
      globalThis.firstA = {firstSharedMarker: "first"};
      globalThis.survivorA = {sharedSurvivorMarker: "survivor"};
    )");
    auto slot_before = ReadSerializedObject(PublicSnapshot(include_internal),
                                            "sharedSurvivorMarker");
    ASSERT_NE(slot_before.id, 0u);
    auto* profiler = GetQjsHeapProfilerImplInstance().FindHeapProfiler(rt);
    ASSERT_NE(profiler, nullptr);
    EXPECT_EQ(profiler->GetSnapshotCount(), 0u);
    auto full_before =
        ReadSerializedObject(PublicFullSnapshot(), "sharedSurvivorMarker");
    EXPECT_EQ(full_before.id, slot_before.id);
    EXPECT_EQ(profiler->GetSnapshotCount(), 0u);

    Eval(b, "firstA = null;");
    auto full_after = PublicFullSnapshot();
    EXPECT_EQ(ReadSerializedObject(full_after, "firstSharedMarker").id, 0u);
    auto survivor = ReadSerializedObject(full_after, "sharedSurvivorMarker");
    EXPECT_EQ(survivor.id, full_before.id);
    // Names and sizes have different semantics across full and slot views.
    EXPECT_EQ(survivor.name, full_before.name);
    EXPECT_EQ(survivor.size, full_before.size);
    auto slot_after = ReadSerializedObject(PublicSnapshot(include_internal),
                                           "sharedSurvivorMarker");
    EXPECT_EQ(slot_after.id, survivor.id);
    EXPECT_EQ(slot_after.name, slot_before.name);
    EXPECT_EQ(slot_after.size, slot_before.size);
    EXPECT_EQ(profiler->GetSnapshotCount(), 0u);
    Eval(b, "survivorA = null;");
  }
}

// A Context's destruction must preserve the Runtime profiler. Runtime teardown
// releases the whole registry entry without retaining serialized snapshots.
TEST_F(SlotHeapProfiler, PublicProfilerFollowsRuntimeLifetime) {
  auto& manager = GetQjsHeapProfilerImplInstance();
  EXPECT_EQ(manager.FindHeapProfiler(rt), nullptr);
  auto* page = LEPUS_NewContext(rt);
  PublicSnapshot(true);
  auto* profiler = manager.FindHeapProfiler(rt);
  ASSERT_NE(profiler, nullptr);
  auto survivor_id = ObjectId(*profiler, ctx);
  LEPUS_FreeContext(page);
  // Phase 1: another live Context continues using the same profiler and IDs.
  PublicSnapshot(false);
  EXPECT_EQ(manager.FindHeapProfiler(rt), profiler);
  EXPECT_EQ(ObjectId(*profiler, ctx), survivor_id);
  EXPECT_EQ(profiler->GetSnapshotCount(), 0u);
  // Phase 2: actual destruction must erase the Runtime entry, so a future
  // Runtime at that address cannot inherit its IDs or graph storage.
  LEPUS_FreeContext(ctx);
  ctx = nullptr;
  auto runtime_address = reinterpret_cast<uintptr_t>(rt);
  LEPUS_FreeRuntime(rt);
  rt = nullptr;
  EXPECT_EQ(manager.FindHeapProfiler(
                reinterpret_cast<LEPUSRuntime*>(runtime_address)),
            nullptr);
}

// Isolate name/class stability from the public ID bug with one profiler.
// A foreign retainer changes diagnostic status, not allocation class identity.
TEST_F(SlotHeapProfiler, RetainerChangesKeepComparisonName) {
  HeapProfiler profiler;
  Eval(a, "globalThis.labelRoot = {child: {labelMarker: 123}};");
  auto child_value = LEPUS_GetPropertyStr(ctx, Global("labelRoot"), "child");
  auto child = ObjectId(profiler, LEPUS_VALUE_GET_PTR(child_value));
  for (bool include_internal : {true, false}) {
    auto* before = profiler.TakeSnapshot(ctx, nullptr, a, include_internal);
    ASSERT_NE(before, nullptr);
    auto* original = before->GetEntryById(child);
    ASSERT_NE(original, nullptr);
    std::string class_name = original->name();
    size_t size = original->self_size();
    EXPECT_FALSE(InDiagnosticGroup(before, original, "[cross-slot]"));
    // Phase 1: add then remove a foreign edge while the original A root stays.
    Eval(b, "globalThis.foreignHolder = labelRoot.child;");
    auto* during = profiler.TakeSnapshot(ctx, nullptr, a, include_internal);
    ASSERT_NE(during, nullptr);
    auto* retained = during->GetEntryById(child);
    ASSERT_NE(retained, nullptr);
    EXPECT_EQ(retained->name(), class_name);
    EXPECT_EQ(retained->self_size(), size);
    EXPECT_TRUE(InDiagnosticGroup(during, retained, "[cross-slot]"));
    Eval(b, "foreignHolder = null;");
    auto* after = profiler.TakeSnapshot(ctx, nullptr, a, include_internal);
    ASSERT_NE(after, nullptr);
    auto* remaining = after->GetEntryById(child);
    ASSERT_NE(remaining, nullptr);
    EXPECT_EQ(remaining->name(), class_name);
    EXPECT_EQ(remaining->self_size(), size);
    EXPECT_FALSE(InDiagnosticGroup(after, remaining, "[cross-slot]"));
  }
}

// Model page A's exit while a common cache still retains B's closure capturing
// A. Verify the complete cache -> closure -> var_ref -> A chain, foreign
// zero-size context and exclusion of an unrelated B branch. Then remove the
// final business edge and require A's node to disappear and its bytes to fall.
TEST_F(SlotHeapProfiler, CrossSlotClosureRetainerChain) {
  HeapProfiler profiler;
  SnapshotObjectId target_id = 0, holder_id = 0, unrelated_id = 0, cache_id = 0;
  {
    HandleScope roots(ctx);
    // Phase 1: A's object starts with a direct global reference. Save its ID,
    // so release checks do not retain its managed pointer after setup.
    Eval(a, "globalThis.targetA = {onlyA: 42};");
    target_id = ObjectId(profiler, LEPUS_VALUE_GET_OBJ(Global("targetA")));
    // Phase 2: B's closure captures targetA in x; an unrelated B branch must
    // not appear merely because it shares the same Runtime.
    Eval(b, R"(
      globalThis.holderB = (function(x) {
        return function BHolder() { return x; };
      })(targetA);
      globalThis.unrelatedB = {unrelated: {}};
    )");
    holder_id = ObjectId(profiler, LEPUS_VALUE_GET_OBJ(Global("holderB")));
    unrelated_id =
        ObjectId(profiler, LEPUS_VALUE_GET_OBJ(Global("unrelatedB")));
    // Phase 3: move business reachability to publicCache.keepB and remove both
    // direct globals. This leaves common cache -> B closure -> x -> A.
    Eval(LEPUS_MEMORY_CATEGORY_COMMON, R"(
      globalThis.publicCache = {keepB: holderB};
      delete globalThis.targetA;
      delete globalThis.holderB;
    )");
    cache_id = ObjectId(profiler, LEPUS_VALUE_GET_OBJ(Global("publicCache")));
  }
  // Phase 4: setup Handles have expired. Full GC must preserve the real cache
  // path. object/holder must exist, unrelated_id must be absent, and only the
  // A-owned object contributes bytes to this slot view.
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(snapshot, nullptr);
  auto* object = snapshot->GetEntryById(target_id);
  auto* holder = snapshot->GetEntryById(holder_id);
  ASSERT_NE(object, nullptr);
  ASSERT_NE(holder, nullptr);
  EXPECT_EQ(snapshot->GetEntryById(unrelated_id), nullptr);
  EXPECT_GT(object->self_size(), 0u);
  EXPECT_TRUE(InDiagnosticGroup(snapshot, object, "[cross-slot]"));
  EXPECT_EQ(holder->self_size(), 0u);
  EXPECT_NE(holder->name().find("[holder slot=" + std::to_string(b) + "]"),
            std::string::npos);
  // Check each link by destination identity: holder.x names the var_ref;
  // referenced_value must point to object, and cache.keepB must point to
  // holder.
  auto* captured = Property(holder, "x");
  ASSERT_NE(captured, nullptr);
  EXPECT_EQ(Property(captured, "referenced_value"), object);
  auto* cache = snapshot->GetEntryById(cache_id);
  ASSERT_NE(cache, nullptr);
  EXPECT_EQ(Property(cache, "keepB"), holder);
  CheckSizeAndIndices(snapshot);
  const size_t object_size = object->self_size();

  // Phase 5: the public C entry must produce parseable JSON and a
  // malloc-owned output buffer that can be released independently of the VM.
  const char* json =
      js_profile_take_heap_snapshot_for_slot(ctx, a, true, false);
  ASSERT_NE(json, nullptr);
  EXPECT_EQ(SerializedBytes(json), Bytes(a));
  // Optional exported fixture for checking with an independent V8 consumer.
  if (const char* output = std::getenv("PRIMJS_SLOT_SNAPSHOT_OUTPUT")) {
    std::ofstream file(output);
    file << json;
  }
  auto parsed = LEPUS_ParseJSON(ctx, json, strlen(json), "slot-snapshot");
  EXPECT_TRUE(LEPUS_IsObject(parsed));
  js_profile_free_heap_snapshot(json);

  // Phase 6: record A's still-live byte count, then remove the last business
  // edge. released includes full GC: target_id must vanish, holder_id must no
  // longer participate in an A retainer path, and A must lose object_size
  // bytes.
  const size_t before_release = Bytes(a);
  Eval(LEPUS_MEMORY_CATEGORY_COMMON, "delete publicCache.keepB;");
  auto* released =
      profiler.TakeSnapshot(ctx, nullptr, a, true);  // Includes full GC.
  ASSERT_NE(released, nullptr);
  EXPECT_EQ(released->GetEntryById(target_id), nullptr);
  EXPECT_EQ(released->GetEntryById(holder_id), nullptr);
  EXPECT_LE(Bytes(a), before_release - object_size);
  // A's cached shapes/atoms may remain, so only the released object's physical
  // charge is a mandatory decrease; requiring the entire page slot to be zero
  // would confuse shared engine metadata with the removed business retainer.
  CheckSizeAndIndices(released);
}

// Compare both views of the same live A allocations. Compact mode must omit
// an opaque A allocation, stop charging shape/buffers/bytecode, and preserve
// the B closure -> var_ref -> A chain. Omitted bytes must not be folded into
// the JS object's size.
TEST_F(SlotHeapProfiler, CompactViewKeepsRetainersWithoutInternalOwnership) {
  HeapProfiler profiler;
  HandleScope roots(ctx);
  // Phase 1: A owns a JS object, string, array and function, plus an opaque
  // block which has only a Handle root. B retains A through a captured x.
  Eval(a, R"(
    globalThis.compactA = {
      text: "compact survivor", array: [1, 2, 3],
      fn: function CompactFunction() { return 7; }
    };
  )");
  auto* object = LEPUS_VALUE_GET_OBJ(Global("compactA"));
  auto text = LEPUS_GetPropertyStr(ctx, Global("compactA"), "text");
  auto array = LEPUS_GetPropertyStr(ctx, Global("compactA"), "array");
  auto function = LEPUS_GetPropertyStr(ctx, Global("compactA"), "fn");
  auto* bytecode = LEPUS_VALUE_GET_OBJ(function)->u.func.function_bytecode;
  auto object_id = ObjectId(profiler, object);
  auto string_id = ObjectId(profiler, LEPUS_VALUE_GET_PTR(text));
  auto array_id = ObjectId(profiler, LEPUS_VALUE_GET_PTR(array));
  auto function_id = ObjectId(profiler, LEPUS_VALUE_GET_PTR(function));
  auto shape_id = ObjectId(profiler, object->shape);
  auto bytecode_id = ObjectId(profiler, bytecode);
  current = a;
  void* opaque = lepus_malloc_gc(ctx, 4096, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(opaque, nullptr);
  roots.PushHandle(opaque, HANDLE_TYPE_DIR_HEAP_OBJ);
  auto opaque_id = ObjectId(profiler, opaque);
  Eval(b, R"(
    globalThis.compactHolder = (function(x) {
      return function CompactHolder() { return x; };
    })(compactA);
  )");
  auto holder_id =
      ObjectId(profiler, LEPUS_VALUE_GET_OBJ(Global("compactHolder")));
  Eval(LEPUS_MEMORY_CATEGORY_COMMON, "delete globalThis.compactA;");

  // Phase 2: true selects the detailed allocation view. The opaque block,
  // shape and bytecode each have their own nonzero physical charge.
  auto* detailed = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(detailed, nullptr);
  CheckSizeAndIndices(detailed);
  auto* opaque_node = detailed->GetEntryById(opaque_id);
  auto* shape_node = detailed->GetEntryById(shape_id);
  auto* bytecode_node = detailed->GetEntryById(bytecode_id);
  ASSERT_NE(opaque_node, nullptr);
  ASSERT_NE(shape_node, nullptr);
  ASSERT_NE(bytecode_node, nullptr);
  const size_t minimum_excluded = opaque_node->self_size() +
                                  shape_node->self_size() +
                                  bytecode_node->self_size();
  EXPECT_TRUE(detailed->include_internal_allocations());
  const size_t detailed_bytes = SnapshotBytes(*detailed);

  // Phase 3: compact excludes opaque because it cannot lead to a JS target.
  // Every explicit JS allocation keeps the same physical charge. Any shape
  // or bytecode still needed as an ancestor must have neither charge nor owner
  // labels; its identity may stay to avoid truncating a real reference path.
  auto* compact = profiler.TakeSnapshot(ctx, nullptr, a, false);
  ASSERT_NE(compact, nullptr);
  EXPECT_FALSE(compact->include_internal_allocations());
  EXPECT_EQ(compact->GetEntryById(opaque_id), nullptr);
  EXPECT_EQ(Bytes(a), detailed_bytes);
  EXPECT_GE(detailed_bytes - SnapshotBytes(*compact), minimum_excluded);
  EXPECT_LT(compact->entries().size(), detailed->entries().size());
  for (auto id : {object_id, string_id, array_id, function_id}) {
    auto* shown = compact->GetEntryById(id);
    auto* original = detailed->GetEntryById(id);
    ASSERT_NE(shown, nullptr);
    ASSERT_NE(original, nullptr);
    EXPECT_EQ(shown->self_size(), original->self_size());
    EXPECT_GT(shown->self_size(), 0u);
  }
  for (auto id : {shape_id, bytecode_id}) {
    if (auto* internal = compact->GetEntryById(id)) {
      EXPECT_EQ(internal->self_size(), 0u);
      EXPECT_EQ(internal->name().find("[slot="), std::string::npos);
      EXPECT_EQ(internal->name().find("[holder slot="), std::string::npos);
    }
  }
  auto* holder = compact->GetEntryById(holder_id);
  ASSERT_NE(holder, nullptr);
  auto* captured = Property(holder, "x");
  ASSERT_NE(captured, nullptr);
  EXPECT_EQ(captured->self_size(), 0u);
  EXPECT_EQ(captured->name().find("[holder slot="), std::string::npos);
  EXPECT_EQ(Property(captured, "referenced_value"),
            compact->GetEntryById(object_id));

  // Phase 4: independently sum the serialized graph's charges and inspect all
  // rebuilt indices/edges. Match each compact charge to the detailed view,
  // which has already been reconciled with the independent allocator.
  size_t displayed = 0, edges = 0;
  std::unordered_set<SnapshotObjectId> visible_ids = {object_id, string_id,
                                                      array_id, function_id};
  // The fixture also creates atom names. Select them from the actual atom
  // table: raw native buffers can have string-typed snapshot nodes too.
  for (uint32_t i = 1; i < rt->atom_size; ++i) {
    auto* atom = rt->atom_array[i];
    if (atom && !atom_is_free(atom) && get_memory_slot(atom) == a) {
      visible_ids.insert(ObjectId(profiler, atom));
    }
  }
  size_t expected = 0;
  for (auto id : visible_ids) {
    auto* entry = detailed->GetEntryById(id);
    ASSERT_NE(entry, nullptr);
    expected += entry->self_size();
  }
  for (auto& entry : compact->entries()) {
    displayed += entry.self_size();
    EXPECT_EQ(&entry, &compact->entries()[entry.index()]);
    edges += entry.children_count();
    for (uint32_t i = 0; i < entry.children_count(); ++i) {
      auto* edge = entry.child(i);
      EXPECT_EQ(edge->from(), &entry);
      EXPECT_EQ(edge->to(), &compact->entries()[edge->to()->index()]);
    }
  }
  EXPECT_EQ(edges, compact->edges().size());
  EXPECT_EQ(displayed, expected);
}

// Exercise both required option values through the single public entry. A slot
// containing only opaque storage is nonempty in detailed mode and has a valid
// empty compact view; both modes must produce parseable JSON with the expected
// sum of node sizes.
TEST_F(SlotHeapProfiler, CompactPublicOptionAndInternalOnlySlot) {
  // Phase 1: keep a raw A allocation alive with a real Handle. No JS-visible
  // allocation is created in A, so the compact displayed total must be zero.
  current = a;
  void* opaque = lepus_malloc_gc(ctx, 128, ALLOC_TAG_WITHOUT_PTR);
  ASSERT_NE(opaque, nullptr);
  HandleScope roots(ctx);
  roots.PushHandle(opaque, HANDLE_TYPE_DIR_HEAP_OBJ);
  current = LEPUS_MEMORY_CATEGORY_COMMON;
  const char* detailed =
      js_profile_take_heap_snapshot_for_slot(ctx, a, true, false);
  const char* compact =
      js_profile_take_heap_snapshot_for_slot(ctx, a, false, false);
  ASSERT_NE(detailed, nullptr);
  ASSERT_NE(compact, nullptr);
  std::unique_ptr<const char, decltype(&js_profile_free_heap_snapshot)>
      detailed_buffer(detailed, js_profile_free_heap_snapshot),
      compact_buffer(compact, js_profile_free_heap_snapshot);

  // Phase 2: true includes internals; compact excludes the entire A charge.
  EXPECT_EQ(SerializedBytes(detailed), Bytes(a));
  EXPECT_EQ(SerializedBytes(compact), 0u);
  EXPECT_LT(strlen(compact), strlen(detailed));
  // Phase 3: parse both views with the real engine after restoring common.
  // Parsing is a consumer check and must not allocate new JS objects in A.
  for (const char* json : {detailed, compact}) {
    auto parsed = LEPUS_ParseJSON(ctx, json, strlen(json), "slot-options");
    EXPECT_TRUE(LEPUS_IsObject(parsed));
  }
}

// A hash-cached A-owned shape must survive while C still owns it after B exits.
// Full parallel GC treats the hash cache weakly and unlinks unmarked shapes, so
// removing C must also release this cached shape. Concurrent mark
// conservatively scans the cache, but that does not make it a permanent full-GC
// strong root.
TEST_F(SlotHeapProfiler, SharedShapeHasIndependentOwnerAndMultipleRetainers) {
  HeapProfiler profiler;
  SharedShapeNodes nodes;
  // Phase 1: the helper verifies one A-owned hash-cached shape shared by B/C,
  // then saves its IDs and shape_size with no construction Handle left alive.
  CreateSharedShapeSnapshot(profiler, true, nodes);
  ASSERT_GT(nodes.shape_size, 0u);
  // Phase 2: remove B's only global reference and collect. In one_holder,
  // nodes.object_b must disappear, while shape_node and node_c remain and
  // node_c.shape still names the same shape with unchanged physical size.
  Eval(LEPUS_MEMORY_CATEGORY_COMMON, "delete globalThis.objectB;");
  auto* one_holder = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(one_holder, nullptr);
  auto* shape_node = one_holder->GetEntryById(nodes.shape);
  auto* node_c = one_holder->GetEntryById(nodes.object_c);
  ASSERT_NE(shape_node, nullptr);
  ASSERT_NE(node_c, nullptr);
  EXPECT_EQ(shape_node->self_size(), nodes.shape_size);
  EXPECT_EQ(one_holder->GetEntryById(nodes.object_b), nullptr);
  EXPECT_EQ(Property(node_c, "shape"), shape_node);
  // Phase 3: the cache remains weak and is filtered out unless another target
  // needs it. Verify actual cache membership separately from snapshot paths.
  auto* live_shape = LEPUS_VALUE_GET_OBJ(Global("objectC"))->shape;
  EXPECT_TRUE(live_shape->is_hashed);
  auto* shape_cache = Property(Entry(one_holder, rt), "shape_array");
  if (shape_cache)
    EXPECT_TRUE(HasEdge(shape_cache, shape_node, HeapGraphEdge::kWeak));
  EXPECT_FALSE(StrongPath(one_holder, nodes.shape, nodes.object_c));
  CheckSizeAndIndices(one_holder);

  // Phase 4: save before_release while C still owns the shape, then remove C.
  // Full GC must unlink/release the shape: its ID is absent from released and
  // accounted bytes fall by at least shape_size. Other A roots can remain.
  const size_t before_release = Bytes(a);
  Eval(LEPUS_MEMORY_CATEGORY_COMMON, "delete globalThis.objectC;");
  auto* released = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(released, nullptr);
  EXPECT_EQ(released->GetEntryById(nodes.shape), nullptr);
  EXPECT_LE(Bytes(a), before_release - nodes.shape_size);
  CheckSizeAndIndices(released);
}

// An uncached shape has only the two business owners B/C. Removing B must leave
// C's shape edge and the same A-owned allocation intact. Removing C then must
// remove that allocation from the census and release at least its physical
// charge, even though unrelated A-owned cached metadata can legitimately stay.
TEST_F(SlotHeapProfiler, SharedShapeReleasedAfterLastBusinessRetainer) {
  HeapProfiler profiler;
  SharedShapeNodes nodes;
  // Phase 1: delete an ordinary property in the helper to select is_hashed ==
  // FALSE, then verify the same two-owner arrangement and save shape_size.
  CreateSharedShapeSnapshot(profiler, false, nodes);
  ASSERT_GT(nodes.shape_size, 0u);
  // Phase 2: removing B must not release a shape still owned by C. one_holder
  // loses nodes.object_b, retains shape/node_c, preserves node_c.shape, and
  // reports the original shape_size rather than a newly allocated replacement.
  Eval(LEPUS_MEMORY_CATEGORY_COMMON, "delete globalThis.objectB;");
  auto* one_holder = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(one_holder, nullptr);
  auto* shape = one_holder->GetEntryById(nodes.shape);
  auto* node_c = one_holder->GetEntryById(nodes.object_c);
  ASSERT_NE(shape, nullptr);
  ASSERT_NE(node_c, nullptr);
  EXPECT_EQ(shape->self_size(), nodes.shape_size);
  EXPECT_EQ(one_holder->GetEntryById(nodes.object_b), nullptr);
  EXPECT_EQ(Property(node_c, "shape"), shape);
  CheckSizeAndIndices(one_holder);

  // Phase 3: remove C's final strong reference. After full GC, released must
  // omit nodes.shape and lose at least nodes.shape_size from before_release.
  // This verifies reclamation independently of whether other A bytes survive.
  const size_t before_release = Bytes(a);
  Eval(LEPUS_MEMORY_CATEGORY_COMMON, "delete globalThis.objectC;");
  auto* released = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(released, nullptr);
  EXPECT_EQ(released->GetEntryById(nodes.shape), nullptr);
  EXPECT_LE(Bytes(a), before_release - nodes.shape_size);
  CheckSizeAndIndices(released);
}

// Cover all allocator kinds using opaque blocks with no engine cache owners.
// Shrinking updates the logical payload to 32 bytes while retaining each
// physical Run/Large/Huge allocation and its original A owner. After the final
// Handles expire, all three allocations and all A-accounted bytes must vanish.
TEST_F(SlotHeapProfiler, PhysicalChargesIncludeRunLargeHugeAndShrink) {
  HeapProfiler profiler;
  SnapshotObjectId block_ids[3] = {};
  {
    void* blocks[3] = {};
    HandleScope scope(rt);
    const size_t lengths[] = {64, 7000,
                              ROS_GC::RosAllocImpl::kHugeObjSize + 4096};
    // Phase 1: root Run/Large/Huge blocks in A. before is the allocator's
    // independent aggregate charge; IDs will identify each block after a dump.
    current = a;
    for (int i = 0; i < 3; ++i) {
      scope.PushHandle(&blocks[i], HANDLE_TYPE_HEAP_OBJ);
      blocks[i] = rt->js_malloc_rt(rt, lengths[i], ALLOC_TAG_WITHOUT_PTR);
      ASSERT_NE(blocks[i], nullptr);
      block_ids[i] = ObjectId(profiler, blocks[i]);
    }
    const auto before = Bytes(a);
    // Phase 2: execute realloc as B, but shrink each existing A allocation.
    // The same pointer and owner must remain; only get_obj_size becomes 32.
    // Bytes(a) must still equal before because no physical storage was freed.
    current = b;
    for (auto& block : blocks) {
      auto* resized = rt->js_realloc_rt(rt, block, 32, ALLOC_TAG_WITHOUT_PTR);
      ASSERT_EQ(resized, block);
      EXPECT_EQ(get_obj_size(block), 32u);
      EXPECT_EQ(get_memory_slot(block), a);
    }
    EXPECT_EQ(Bytes(a), before);
    // Phase 3: dump while the Handles keep all blocks alive. Each self_size
    // must cover its original payload/header, and the total must equal before.
    auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true);
    ASSERT_NE(snapshot, nullptr);
    EXPECT_EQ(SnapshotBytes(*snapshot), before);
    for (int i = 0; i < 3; ++i) {
      auto* node = snapshot->GetEntryById(block_ids[i]);
      ASSERT_NE(node, nullptr);
      EXPECT_GE(node->self_size(), lengths[i] + ROS_GC::kHeaderSize);
    }
    EXPECT_EQ(current, b);
    CheckSizeAndIndices(snapshot);
  }
  // Phase 4: leaving the scope removes the final roots. Full GC must remove all
  // block_ids and reduce A to zero, since this case created no shared A
  // metadata.
  auto* released = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(released, nullptr);
  for (auto id : block_ids) EXPECT_EQ(released->GetEntryById(id), nullptr);
  EXPECT_EQ(Bytes(a), 0u);
  EXPECT_EQ(current, b);
  CheckSizeAndIndices(released);
}

// Snapshot naming must not execute constructor getters. Start after a full GC
// so collection of old garbage cannot mask diagnostic allocations. Dump both A
// and common: unchanged counters detect pollution of either slot, the saved
// selector must be restored, and a zero call count proves the getter was
// unused. These endpoint counters detect retained diagnostic bytes; they do not
// prove that no temporary allocation was created and freed before snapshot
// returned.
TEST_F(SlotHeapProfiler, DumpDoesNotExecuteGettersOrPolluteCommonSlot) {
  // Phase 1: create a getter that increments getterCalls and throws if snapshot
  // naming executes JS. payload keeps the object and backing buffer reachable.
  Eval(a, R"(
    globalThis.getterCalls = 0;
    globalThis.withGetter = {
      get constructor() { ++getterCalls; throw new Error("must not execute"); }
    };
    globalThis.payload = [withGetter, new ArrayBuffer(8192)];
  )");
  // Phase 2: first clear pre-existing garbage, then record the A/common
  // counters so unrelated collection cannot hide retained diagnostic
  // allocations.
  LEPUS_RunGC(rt);
  const auto common_before = Bytes(LEPUS_MEMORY_CATEGORY_COMMON);
  const auto a_before = Bytes(a);
  // Phase 3: dump each target with the caller selector deliberately set to A.
  // Every iteration must restore current == a and preserve both baselines.
  for (int32_t target : {a, int32_t(LEPUS_MEMORY_CATEGORY_COMMON)}) {
    current = a;
    auto* json =
        js_profile_take_heap_snapshot_for_slot(ctx, target, true, false);
    ASSERT_NE(json, nullptr);
    js_profile_free_heap_snapshot(json);
    EXPECT_EQ(current, a);
    EXPECT_EQ(Bytes(LEPUS_MEMORY_CATEGORY_COMMON), common_before);
    EXPECT_EQ(Bytes(a), a_before);
  }
  // Phase 4: getterCalls == 0 proves neither dump invoked the constructor
  // getter; the counter checks above prove no extra accounted bytes remained.
  int32_t calls = -1;
  LEPUS_ToInt32(ctx, &calls, Global("getterCalls"));
  EXPECT_EQ(calls, 0);
}

// Invalid ownership indices and a collector that cannot safely finish GC must
// fail. A valid but unused page slot must instead return a zero-byte snapshot.
// Each collector restriction is removed immediately so later checks are valid.
TEST_F(SlotHeapProfiler, InvalidEmptyAndForbiddenSlots) {
  // Phase 1: reject a negative index, an unallocated page index, and an index
  // outside the 8-bit slot range. These must not fall back to a whole-VM dump.
  EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(ctx, -1, true, false),
            nullptr);
  EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(ctx, c + 1, true, false),
            nullptr);
  EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(ctx, 256, true, false),
            nullptr);
  // Phase 2: c exists but owns no allocations. A non-null result with zero
  // accounted bytes distinguishes a valid empty snapshot from failure.
  auto* empty = js_profile_take_heap_snapshot_for_slot(ctx, c, true, false);
  ASSERT_NE(empty, nullptr);
  EXPECT_EQ(SerializedBytes(empty), 0u);
  js_profile_free_heap_snapshot(empty);
  // Phase 3: forbid GC and verify rejection, then restore the collector before
  // testing pause suppression as a separate condition with the same outcome.
  rt->collector_->SetForbidGC();
  EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(ctx, a, true, false),
            nullptr);
  rt->collector_->ResetForbidGC();
  LEPUS_SetGCPauseSuppressionMode(rt, true);
  EXPECT_EQ(js_profile_take_heap_snapshot_for_slot(ctx, a, true, false),
            nullptr);
  LEPUS_SetGCPauseSuppressionMode(rt, false);
}

// Force out-of-object properties and an element backing store in A, then grow
// them while executing B. The final storage nodes must still contribute A
// bytes, demonstrating realloc ownership preservation independently of the
// new B-owned elements. This case does not test a buffer first allocated in B.
TEST_F(SlotHeapProfiler, PropertyAndArrayBuffersKeepAllocationOwnership) {
  // Phase 1: enough named properties force storage outside the object, while
  // arrayA owns a separate elements buffer. Both are initially allocated in A.
  Eval(a, R"(
    globalThis.growing = {p0:{},p1:{},p2:{},p3:{},p4:{},p5:{},p6:{}};
    globalThis.arrayA = [{}, {}, {}];
  )");
  auto* object = LEPUS_VALUE_GET_OBJ(Global("growing"));
  auto* array = LEPUS_VALUE_GET_OBJ(Global("arrayA"));
  ASSERT_FALSE(IS_IN_OBJECT_PROP(object, object->gc_prop));
  auto* properties = object->gc_prop;
  auto* elements = array->u.array.u.values;
  ASSERT_EQ(get_memory_slot(properties), a);
  ASSERT_EQ(get_memory_slot(elements), a);
  // Phase 2: grow the existing stores while B creates the new values. realloc
  // may move a backing store, so inspect the final object's storage edges below
  // rather than looking up the possibly obsolete properties/elements pointers.
  Eval(b, R"(
    growing.more = {};
    for (var i = 0; i < 100; ++i) arrayA.push({});
  )");
  // Phase 3: property_node/element_node must exist with nonzero A self_size.
  // This validates the final stores' original owner and independent accounting.
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(snapshot, nullptr);
  auto* object_node = Entry(snapshot, object);
  auto* array_node = Entry(snapshot, array);
  ASSERT_NE(object_node, nullptr);
  ASSERT_NE(array_node, nullptr);
  auto* property_node = Property(object_node, "properties");
  auto* element_node = Property(array_node, "elements");
  ASSERT_NE(property_node, nullptr);
  ASSERT_NE(element_node, nullptr);
  EXPECT_GT(property_node->self_size(), 0u);
  EXPECT_GT(element_node->self_size(), 0u);
  CheckSizeAndIndices(snapshot);
}

// Both the object and its backing properties retain live values. Accessors
// must remain references, and deleted shape slots must not become edges.
TEST_F(SlotHeapProfiler, PropertyStoragePreservesLivePropertyKinds) {
  Eval(a, R"(
    globalThis.propertyTarget = {};
    globalThis.propertyGetter = function() { ++getterCalls; };
    globalThis.propertySetter = function(value) {};
    globalThis.getterCalls = 0;
  )");
  Eval(b, R"(
    globalThis.propertyOwner = {
      p0: 0, p1: 1, p2: 2, p3: 3, p4: 4, p5: 5, p6: 6,
      named: propertyTarget, 17: propertyTarget,
      [Symbol("symbolKey")]: propertyTarget, deleted: propertyTarget
    };
    Object.defineProperty(propertyOwner, "accessor", {
      get: propertyGetter, set: propertySetter
    });
    delete propertyOwner.deleted;
  )");
  auto* owner = LEPUS_VALUE_GET_OBJ(Global("propertyOwner"));
  ASSERT_FALSE(IS_IN_OBJECT_PROP(owner, owner->gc_prop));
  auto* target = LEPUS_VALUE_GET_PTR(Global("propertyTarget"));
  auto* getter = LEPUS_VALUE_GET_PTR(Global("propertyGetter"));
  auto* setter = LEPUS_VALUE_GET_PTR(Global("propertySetter"));
  HeapProfiler profiler;
  for (int view : {0, 1, 2}) {
    SCOPED_TRACE(view);
    auto* snapshot = view == 0
                         ? profiler.TakeSnapshot(ctx, nullptr)
                         : profiler.TakeSnapshot(ctx, nullptr, a, view == 1);
    ASSERT_NE(snapshot, nullptr);
    auto* object = Entry(snapshot, owner);
    ASSERT_NE(object, nullptr);
    std::vector<HeapEntry*> parents{object};
    if (view != 0) {
      auto* storage = Property(object, "properties");
      ASSERT_NE(storage, nullptr);
      EXPECT_EQ(storage, Entry(snapshot, owner->gc_prop));
      EXPECT_EQ(storage->self_size(), 0u);
      parents.push_back(storage);
      CheckSizeAndIndices(snapshot);
    }
    for (auto* parent : parents) {
      EXPECT_EQ(Property(parent, "named"), Entry(snapshot, target));
      EXPECT_EQ(Property(parent, "symbolKey"), Entry(snapshot, target));
      EXPECT_EQ(Property(parent, "deleted"), nullptr);
      size_t numeric_edges = 0;
      for (uint32_t i = 0; i < parent->children_count(); ++i) {
        auto* edge = parent->child(i);
        if (edge->type() == HeapGraphEdge::kElement && edge->index() == 17) {
          EXPECT_EQ(edge->to(), Entry(snapshot, target));
          ++numeric_edges;
        }
      }
      EXPECT_EQ(numeric_edges, 1u);
      auto* accessor = Property(parent, "(getset) accessor");
      ASSERT_NE(accessor, nullptr);
      EXPECT_EQ(accessor, Property(object, "(getset) accessor"));
      EXPECT_EQ(Property(accessor, "getter"), Entry(snapshot, getter));
      EXPECT_EQ(Property(accessor, "setter"), Entry(snapshot, setter));
    }
    EXPECT_EQ(LEPUS_VALUE_GET_INT(Global("getterCalls")), 0);
  }
}

// Native states and JS wrappers expose the same semantic fields. A state
// Handle must retain its own path even after the wrapper has been traversed.
TEST_F(SlotHeapProfiler, BoundAndProxyStatesPreserveSemanticReferences) {
  Eval(a, R"(
    globalThis.boundTarget = function() {};
    globalThis.boundThis = {};
    globalThis.boundArg = {};
    globalThis.proxyTarget = {};
    globalThis.proxyHandler = {};
  )");
  Eval(b, R"(
    globalThis.boundOwner = boundTarget.bind(boundThis, boundArg, boundArg);
    globalThis.proxyOwner = new Proxy(proxyTarget, proxyHandler);
    boundThis.owner = boundOwner;
    proxyTarget.owner = proxyOwner;
    boundTarget = boundThis = boundArg = proxyTarget = proxyHandler = null;
  )");
  auto* bound = LEPUS_VALUE_GET_OBJ(Global("boundOwner"));
  auto* proxy = LEPUS_VALUE_GET_OBJ(Global("proxyOwner"));
  auto* bound_state = bound->u.bound_function;
  auto* proxy_state = proxy->u.proxy_data;
  HandleScope roots(rt);
  roots.PushHandle(bound_state, HANDLE_TYPE_DIR_HEAP_OBJ);
  roots.PushHandle(proxy_state, HANDLE_TYPE_DIR_HEAP_OBJ);
  HeapProfiler profiler;
  for (int view : {0, 1, 2}) {
    SCOPED_TRACE(view);
    auto* snapshot = view == 0
                         ? profiler.TakeSnapshot(ctx, nullptr)
                         : profiler.TakeSnapshot(ctx, nullptr, a, view == 1);
    ASSERT_NE(snapshot, nullptr);
    auto* bound_node = Entry(snapshot, bound);
    auto* proxy_node = Entry(snapshot, proxy);
    ASSERT_NE(bound_node, nullptr);
    ASSERT_NE(proxy_node, nullptr);
    std::vector<HeapEntry*> bound_parents{bound_node};
    std::vector<HeapEntry*> proxy_parents{proxy_node};
    if (view != 0) {
      auto* bound_storage = Property(bound_node, "bound_function");
      auto* proxy_storage = Property(proxy_node, "proxy_data");
      ASSERT_NE(bound_storage, nullptr);
      ASSERT_NE(proxy_storage, nullptr);
      EXPECT_EQ(bound_storage, Entry(snapshot, bound_state));
      EXPECT_EQ(proxy_storage, Entry(snapshot, proxy_state));
      EXPECT_EQ(bound_storage->self_size(), 0u);
      EXPECT_EQ(proxy_storage->self_size(), 0u);
      bound_parents.push_back(bound_storage);
      proxy_parents.push_back(proxy_storage);
      EXPECT_TRUE(StrongPath(
          snapshot,
          Entry(snapshot, LEPUS_VALUE_GET_PTR(bound_state->argv[0]))->id(),
          bound_node->id()));
      EXPECT_TRUE(StrongPath(
          snapshot,
          Entry(snapshot, LEPUS_VALUE_GET_PTR(proxy_state->handler))->id(),
          proxy_node->id()));
      CheckSizeAndIndices(snapshot);
    }
    for (auto* parent : bound_parents) {
      EXPECT_EQ(Property(parent, "func_obj"),
                Entry(snapshot, LEPUS_VALUE_GET_PTR(bound_state->func_obj)));
      auto* receiver =
          Entry(snapshot, LEPUS_VALUE_GET_PTR(bound_state->this_val));
      EXPECT_EQ(Property(parent, "this_val"), receiver);
      EXPECT_EQ(Property(receiver, "owner"), bound_node);
      size_t bound_args = 0;
      for (uint32_t i = 0; i < parent->children_count(); ++i) {
        auto* edge = parent->child(i);
        if (edge->name() == "bound_arg") {
          EXPECT_EQ(edge->type(), HeapGraphEdge::kInternal);
          EXPECT_EQ(edge->to(),
                    Entry(snapshot, LEPUS_VALUE_GET_PTR(bound_state->argv[0])));
          ++bound_args;
        }
      }
      EXPECT_EQ(bound_args, 2u);
    }
    for (auto* parent : proxy_parents) {
      auto* target = Entry(snapshot, LEPUS_VALUE_GET_PTR(proxy_state->target));
      EXPECT_EQ(Property(parent, "target"), target);
      EXPECT_EQ(Property(target, "owner"), proxy_node);
      EXPECT_EQ(Property(parent, "handler"),
                Entry(snapshot, LEPUS_VALUE_GET_PTR(proxy_state->handler)));
      EXPECT_EQ(Property(parent, "proto"), nullptr);
    }
  }
}

TEST_F(SlotHeapProfiler, FullSnapshotPreservesUnicodeAndEmbeddedNulNames) {
  Eval(a, R"(
    globalThis.stringA = "中文\u{1f600}\u0000tail";
    globalThis.objectA = {"key\u0000tail": stringA};
  )");
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr);
  auto* string = Entry(snapshot, LEPUS_VALUE_GET_PTR(Global("stringA")));
  auto* object = Entry(snapshot, LEPUS_VALUE_GET_PTR(Global("objectA")));
  ASSERT_NE(string, nullptr);
  ASSERT_NE(object, nullptr);
  EXPECT_EQ(string->name(), std::string(u8"中文😀") + '\0' + "tail");
  bool found_property = false;
  for (uint32_t i = 0; i < object->children_count(); ++i) {
    auto* edge = object->child(i);
    if (edge->name() == std::string("key\0tail", 8)) {
      EXPECT_EQ(edge->to(), string);
      found_property = true;
    }
  }
  EXPECT_TRUE(found_property);
  const auto json = PublicFullSnapshot();
  EXPECT_NE(json.find("\\u4E2D\\u6587\\uD83D\\uDE00\\u0000tail\""),
            std::string::npos);
}

// Engine names may contain UTF-16 surrogate pairs and embedded NULs. Parsing
// verifies valid JSON; exact escapes and the trailing slot label verify that
// serialization neither corrupts the emoji nor truncates a name at the NUL.
TEST_F(SlotHeapProfiler, UnicodeAndEmbeddedNulNamesKeepSlotLabels) {
  // Phase 1: create both a value name and a property name with an embedded NUL;
  // the value also exercises a Chinese prefix and a non-BMP Unicode character.
  Eval(a, R"(
    globalThis.stringA = "中文\u{1f600}\u0000tail";
    globalThis.objectA = {"key\u0000tail": stringA};
  )");
  // Phase 2: serialize through the public C entry, then parse the complete
  // buffer. Optional export is for an external consumer, not a test dependency.
  const char* json =
      js_profile_take_heap_snapshot_for_slot(ctx, a, true, false);
  ASSERT_NE(json, nullptr);
  if (const char* output = std::getenv("PRIMJS_SLOT_SNAPSHOT_OUTPUT")) {
    std::ofstream file(output);
    file << json;
  }
  auto parsed = LEPUS_ParseJSON(ctx, json, strlen(json), "slot-unicode");
  HandleScope scope(ctx, &parsed, HANDLE_TYPE_LEPUS_VALUE);
  ASSERT_TRUE(LEPUS_IsObject(parsed));
  // Phase 3: check the encoded surrogate pair/NUL plus the text after the NUL.
  // The slot suffix must survive in both names, rather than being truncated.
  const std::string serialized(json);
  EXPECT_NE(serialized.find("\\u4E2D\\u6587\\uD83D\\uDE00\\u0000tail [slot="),
            std::string::npos);
  EXPECT_NE(serialized.find("key\\u0000tail [slot="), std::string::npos);
  js_profile_free_heap_snapshot(json);
}

// Only the wrapper/state of an externally backed ArrayBuffer belongs to A.
// The stack-owned data address must not become a GC allocation node or have
// an allocation header read; aggregate reconciliation checks the byte scope.
TEST_F(SlotHeapProfiler, ExternalArrayBufferDoesNotAcquireAllocationHeader) {
  // Phase 1: allocate the wrapper/state in A around stack-owned external data.
  // The explicit Handle/global make wrapper reachability independent of GC.
  uint8_t data[16] = {};
  current = a;
  auto buffer =
      LEPUS_NewArrayBuffer(ctx, data, sizeof(data), nullptr, nullptr, false);
  HandleScope scope(ctx, &buffer, HANDLE_TYPE_LEPUS_VALUE);
  ASSERT_TRUE(LEPUS_IsObject(buffer));
  LEPUS_SetPropertyStr(ctx, ctx->global_obj, "externalBuffer", buffer);
  // Phase 2: the census must omit data itself. Entry(snapshot, data) must be
  // null, while the graph's remaining sizes still equal A's allocator counter.
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(snapshot, nullptr);
  EXPECT_EQ(Entry(snapshot, data), nullptr);
  CheckSizeAndIndices(snapshot);
}

// A CString Handle points inside a JSString, not at a GC allocation header.
// Verify restoration of the actual string base, its A ownership and nonzero
// charge, and the Handle -> string edge rather than a second interior node.
TEST_F(SlotHeapProfiler, CStringHandleUsesStringAllocationBase) {
  // Phase 1: cstr is an interior pointer. Root it as a CString Handle and
  // derive base only through GetCStringPtr, never by reading a header before
  // cstr.
  current = a;
  auto string = LEPUS_NewString(ctx, "CString-only survivor");
  const char* cstr = LEPUS_ToCString(ctx, string);
  ASSERT_NE(cstr, nullptr);
  HandleScope scope(ctx, &cstr, HANDLE_TYPE_CSTRING);
  auto* base = Visitor::GetCStringPtr(cstr);
  ASSERT_EQ(get_memory_slot(base), a);
  // Phase 2: node must be the A-owned allocation at base with nonzero size;
  // the Handle root's named CString edge must point to that exact node.
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(snapshot, nullptr);
  auto* node = Entry(snapshot, base);
  ASSERT_NE(node, nullptr);
  EXPECT_GT(node->self_size(), 0u);
  EXPECT_EQ(Property(snapshot->gc_subroot(Root::kHandleScope), "CString"),
            node);
  CheckSizeAndIndices(snapshot);
}

// Begin with a real concurrent mark phase. Taking a slot snapshot must drain
// that phase and finish sweep before the census; phase flags and independent
// counter reconciliation verify the stable sampling point. This starts in mark,
// rather than separately testing an already-running concurrent sweep.
TEST_F(SlotHeapProfiler, CompletesConcurrentMarkBeforeAllocationCensus) {
  // Phase 1: create live A allocations and initialize the pool/visitor before
  // directly triggering the collector's concurrent-mark entry.
  Eval(a, "globalThis.liveA = [new ArrayBuffer(8192), {}];");
  ASSERT_TRUE(rt->ros_->GetEnableConcurrent());
  LEPUS_RunGC(rt);  // Initialize the collector's worker pool and visitor.
  int eager = ROS_GC::kEagerLevelMin;
  // Phase 2: prove that mark is active before taking the snapshot. Worker
  // completion alone does not end the owner-thread mark phase.
  ASSERT_TRUE(rt->collector_->TriggerConcurrentMarking(0, eager));
  ASSERT_TRUE(rt->ros_->GetConcurrentMarkState());
  // Phase 3: the snapshot must drain mark and sweep. Both flags must now be
  // false, and the graph/counter equality checks a stable post-GC census.
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(snapshot, nullptr);
  EXPECT_FALSE(rt->ros_->GetConcurrentMarkState());
  EXPECT_FALSE(rt->ros_->GetConcurrentSweepState());
  CheckSizeAndIndices(snapshot);
}

// Free A's page Context while another live Context on the same Runtime retains
// its object. Dumping through the live Context must still include the A-owned
// allocation. The explicit Handle is intentional here: this is a Context
// lifetime/Runtime-wide census case, not a last-retainer release case.
TEST_F(SlotHeapProfiler, UsesAnotherContextAfterPageContextIsDestroyed) {
  // Phase 1: create a separate page Context and its object while A is selected.
  // The fixture's original ctx stays alive as the eventual dump entry point.
  current = a;
  auto* page = LEPUS_NewContext(rt);
  auto* source = "globalThis.pageObject = {pageOnly: 1};";
  auto result = LEPUS_Eval(page, source, strlen(source), "page.js",
                           LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(result));
  auto object = LEPUS_GetPropertyStr(page, page->global_obj, "pageObject");
  HandleScope scope(ctx, &object, HANDLE_TYPE_LEPUS_VALUE);
  // Phase 2: publish the object in the surviving Context, then free page.
  // Executing this publication as B does not migrate the object's A ownership.
  current = b;
  LEPUS_SetPropertyStr(ctx, ctx->global_obj, "retainedPageObject", object);
  LEPUS_FreeContext(page);
  // Phase 3: dump via ctx, not the destroyed page Context. node must still
  // identify the retained A allocation with nonzero size and correct totals.
  HeapProfiler profiler;
  auto* snapshot = profiler.TakeSnapshot(ctx, nullptr, a, true);
  ASSERT_NE(snapshot, nullptr);
  auto* node = Entry(snapshot, LEPUS_VALUE_GET_OBJ(object));
  ASSERT_NE(node, nullptr);
  EXPECT_GT(node->self_size(), 0u);
  CheckSizeAndIndices(snapshot);
}
#endif  // ENABLE_COMPATIBLE_MM

}  // namespace
}  // namespace heapprofiler
}  // namespace quickjs
