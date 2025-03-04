// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <iostream>
#include <list>
#include <unordered_set>

#include "gc/trace-gc.h"
#include "gtest/gtest.h"
#include "inspector/heapprofiler/heapprofiler.h"
#include "quickjs/include/quickjs-inner.h"

extern void take_heap_snapshot_test(LEPUSContext* ctx);
namespace {
class TestQjsContext {
 public:
  TestQjsContext() {
    rt = LEPUS_NewRuntime();
    ctx = LEPUS_NewContext(rt);
    RegisterGlobalFunction("print", Print, 1);
  }

  LEPUSValue CompileAndRun(const std::string& str) {
    LEPUSValue ret = LEPUS_Eval(ctx, str.c_str(), str.length(), "test.js",
                                LEPUS_EVAL_TYPE_GLOBAL);

    if (LEPUS_IsException(ret)) {
      LEPUSValue exception_val = LEPUS_GetException(ctx);
      HandleScope func_scope(ctx, &exception_val, HANDLE_TYPE_LEPUS_VALUE);

      const char* message = LEPUS_ToCString(ctx, exception_val);

      std::cout << "qjs exception: " << message << std::endl;

      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, message);
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, exception_val);
    }

    return ret;
  }

  void RegisterGlobalProperty(const char* name, LEPUSValue prop) {
    JSAtom prop_name = LEPUS_NewAtom(ctx, name);
    LEPUS_SetGlobalVar(ctx, prop_name, prop, 0);
    if (!ctx->rt->gc_enable) LEPUS_FreeAtom(ctx, prop_name);
  }

  void RegisterGlobalFunction(const char* name, LEPUSCFunction* f,
                              int32_t length) {
    LEPUSValue func = LEPUS_NewCFunction(ctx, f, name, length);

    JSAtom prop = LEPUS_NewAtom(ctx, name);
    LEPUS_SetGlobalVar(ctx, prop, func, 0);
    if (!ctx->rt->gc_enable) LEPUS_FreeAtom(ctx, prop);
  }

  LEPUSValue GetGlobalPropery(const char* name) {
    JSAtom prop_name = LEPUS_NewAtom(ctx, name);
    LEPUSValue ret = LEPUS_GetGlobalVar(ctx, prop_name, 0);
    if (!ctx->rt->gc_enable) LEPUS_FreeAtom(ctx, prop_name);
    return ret;
  }

  static LEPUSValue Print(LEPUSContext* ctx, LEPUSValue this_val, int32_t argc,
                          LEPUSValue* argv) {
    for (int32_t i = 0; i < argc; i++) {
      const char* msg = LEPUS_ToCString(ctx, argv[i]);
      std::cout << msg << std::endl;
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, msg);
    }
    return LEPUS_UNDEFINED;
  }

  ~TestQjsContext() {
    LEPUS_FreeContext(ctx);
    LEPUS_FreeRuntime(rt);
  }
  LEPUSContext* ctx = nullptr;
  LEPUSRuntime* rt = nullptr;
};
}  // namespace

namespace quickjs {
namespace heapprofiler {

class NameEntriesDetector {
 public:
  explicit NameEntriesDetector()
      : has_A2(false), has_B2(false), has_C2(false) {}

  void CheckEntry(const HeapEntry* node) {
    auto&& name = node->name();

    if (name == "A2") has_A2 = true;
    if (name == "B2") has_B2 = true;
    if (name == "C2") has_C2 = true;
  }

  // BFS
  void CheckAllReachables(HeapEntry* root) {
    std::unordered_set<HeapEntry*> visted;
    std::list<HeapEntry*> list;

    list.push_back(root);
    CheckEntry(root);

    while (!list.empty()) {
      auto* heap_entry = list.back();
      list.pop_back();

      for (size_t i = 0, count = heap_entry->children_count(); i < count; ++i) {
        auto* child = heap_entry->child(i)->to();
        if (visted.find(child) == visted.end()) {
          list.push_back(child);
          CheckEntry(child);
          visted.insert(child);
        }
      }
    }
  }

  bool has_A2;
  bool has_B2;
  bool has_C2;
};

// Check that snapshot has no retained extries except root
static bool ValidateSnapshot(const HeapSnapshot* snapshot) {
  std::unordered_set<HeapEntry*> visited;

  auto& edges = snapshot->edges();

  for (auto& ele : edges) {
    auto itr = visited.find(ele.to());
    if (itr == visited.end()) {
      visited.insert(ele.to());
    }
  }

  size_t unretained_entries_count = 0;

  auto& entries = snapshot->entries();
  for (auto& entry : entries) {
    auto itr = visited.find((HeapEntry*)&entry);
    if (itr == visited.end() && entry.id() != 1) {
      std::cout << entry.name() << " " << entry.type() << std::endl;
      ++unretained_entries_count;
    }
  }
  return unretained_entries_count == 0;
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
[[maybe_unused]] static auto GetGlobalObject(const HeapSnapshot* snapshot) {
  const auto* global_obj = snapshot->root()->child(1)->to();

  assert(global_obj && global_obj->name() == "Object");
  return global_obj;
}

static auto GetGlobalVarObject(const HeapSnapshot* snapshot) {
  const auto* global_var_obj = snapshot->root()->child(2)->to();

  assert(global_var_obj != nullptr && global_var_obj->name() == "global / ");
  return global_var_obj;
}

static const char* GetName(const HeapEntry* node) {
  return node->name().c_str();
}

static const char* GetName(const HeapGraphEdge* edge) {
  return edge->name().c_str();
}

static size_t GetSize(const HeapEntry* node) { return node->self_size(); }

static const HeapEntry* GetChildByName(const HeapEntry* node,
                                       const char* name) {
  for (size_t i = 0; i < node->children_count(); ++i) {
    const auto* child = const_cast<HeapEntry*>(node)->child(i)->to();
    if (!strcmp(name, GetName(child))) {
      return child;
    }
  }
  return nullptr;
}

static const HeapGraphEdge* GetEdgeByChildName(const HeapEntry* node,
                                               const char* name) {
  for (size_t i = 0; i < node->children_count(); ++i) {
    const auto* edge = const_cast<HeapEntry*>(node)->child(i);

    const auto* child = edge->to();

    if (!strcmp(name, GetName(child))) {
      return edge;
    }
  }

  return nullptr;
}

static const HeapEntry* GetProperty(const HeapEntry* node,
                                    HeapGraphEdge::Type type,
                                    const char* name) {
  for (size_t i = 0, count = node->children_count(); i < count; ++i) {
    const auto* prop = const_cast<HeapEntry*>(node)->child(i);

    if (prop->type() == type && prop->name() == name) {
      return prop->to();
    }
  }

  return nullptr;
}

static const HeapEntry* GetGlobalProperty(const HeapSnapshot* snapshot,
                                          HeapGraphEdge::Type type,
                                          const char* name) {
  if (auto* result = GetProperty(GetGlobalObject(snapshot), type, name)) {
    return result;
  }
  return GetProperty(GetGlobalVarObject(snapshot), type, name);
}

#pragma clang diagnostic pop

TEST(QjsHeapProfiler, HeapSnapshot) {
  ::TestQjsContext env;

  std::string test_src = R"(
    function A2() {};
    function B2(x) {return  function() {return typeof x; }; }
    function C2(x) {this.x1 = x; this.x2 = x; this[1] = x; };
    var a2 = new A2();
    var b2_1 = new B2(a2), b2_2 = new B2(a2);
    var c2 = new C2(a2);
  )";
  LEPUSValue ret = env.CompileAndRun(test_src);

  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);

  auto& impl = GetQjsHeapProfilerImplInstance();

  auto* heapsnpshot = impl.TakeHeapSnapshot(env.ctx);

  ASSERT_TRUE(ValidateSnapshot(heapsnpshot));

  ASSERT_TRUE(GetGlobalProperty(heapsnpshot, HeapGraphEdge::kProperty, "a2"));

  ASSERT_TRUE(GetGlobalProperty(heapsnpshot, HeapGraphEdge::kProperty, "b2_1"));

  ASSERT_TRUE(GetGlobalProperty(heapsnpshot, HeapGraphEdge::kProperty, "b2_2"));

  ASSERT_TRUE(GetGlobalProperty(heapsnpshot, HeapGraphEdge::kProperty, "c2"));

  LEPUS_RunGC(env.rt);

  NameEntriesDetector det;

  det.CheckAllReachables(heapsnpshot->root());

  ASSERT_TRUE(det.has_A2 && det.has_B2 && det.has_C2);
}

TEST(HeapProfiler, HeapObjectSize) {
  ::TestQjsContext env;
  std::string source = R"(
    function X(a, b) { this.a = a; this.b = b; }
    x = new X(new X(), new X());
    dummy = new X();
    (function() { x.a.a = x.b; })();
  )";
  LEPUSValue ret = env.CompileAndRun(source);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);

  auto& impl = GetQjsHeapProfilerImplInstance();

  auto* heapsnapshot = impl.TakeHeapSnapshot(env.ctx);

  ASSERT_TRUE(ValidateSnapshot(heapsnapshot));

  const HeapEntry *x = nullptr, *x1 = nullptr, *x2 = nullptr;

  x = GetGlobalProperty(heapsnapshot, HeapGraphEdge::kProperty, "x");

  ASSERT_TRUE(x);

  (x1 = GetProperty(x, HeapGraphEdge::kProperty, "a"));
  ASSERT_TRUE(x1);

  (x2 = GetProperty(x, HeapGraphEdge::kProperty, "b"));

  ASSERT_TRUE(x2);
  ASSERT_GT(x->self_size(), 0);

  ASSERT_GT(x1->self_size(), 0);

  ASSERT_GT(x2->self_size(), 0);
}

TEST(HeapProfiler, EntryChildren) {
  ::TestQjsContext env;

  auto& impl = GetQjsHeapProfilerImplInstance();

  std::string source = R"(
    function A() {};
    a = new A();
  )";

  auto ret = env.CompileAndRun(source);

  const auto* snapshot = impl.TakeHeapSnapshot(env.ctx);

  ASSERT_TRUE(ValidateSnapshot(snapshot));

  auto* global = GetGlobalObject(snapshot);

  for (size_t i = 0, count = global->children_count(); i < count; ++i) {
    const auto* prop = const_cast<HeapEntry*>(global)->child(i);
    ASSERT_EQ(prop->from(), global);
  }

  auto* global_var = GetGlobalVarObject(snapshot);

  for (size_t i = 0, count = global_var->children_count(); i < count; ++i) {
    const auto* prop = const_cast<HeapEntry*>(global_var)->child(i);
    ASSERT_EQ(prop->from(), global_var);
  }

  const HeapEntry* a = nullptr;

  (a = GetProperty(global, HeapGraphEdge::kProperty, "a")) ||
      (a = GetProperty(global_var, HeapGraphEdge::kProperty, "a"));

  ASSERT_TRUE(a);

  for (size_t i = 0, count = a->children_count(); i < count; ++i) {
    auto* prop = const_cast<HeapEntry*>(a)->child(i);

    ASSERT_EQ(a, prop->from());
  }
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);
}

TEST(HeapProfiler, CodeObjects) {
  ::TestQjsContext env;
  std::string source = R"(
      function lazy(x) { return x - 1; };
      function compiled(x) { ()=>x; return x + 1; };
      var anonymous = (function() { return function() { return 0; } })();
      compiled(1);
  )";
  LEPUSValue ret = env.CompileAndRun(source);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);

  auto& impl = GetQjsHeapProfilerImplInstance();

  auto* heapsnapshot = impl.TakeHeapSnapshot(env.ctx);

  ASSERT_TRUE(ValidateSnapshot(heapsnapshot));

  auto* compiled =
      GetGlobalProperty(heapsnapshot, HeapGraphEdge::kProperty, "compiled");

  ASSERT_TRUE(compiled);

  ASSERT_TRUE(compiled->name() == "Function");

  auto* compile_bytecode =
      GetProperty(compiled, HeapGraphEdge::kInternal, "function_bytecode");
  ASSERT_TRUE(compile_bytecode &&
              compile_bytecode->type() == HeapEntry::kClosure);

  auto* lazy =
      GetGlobalProperty(heapsnapshot, HeapGraphEdge::kProperty, "lazy");

  ASSERT_TRUE(lazy && lazy->name() == "Function");
  auto* lazy_bytecode =
      GetProperty(lazy, HeapGraphEdge::kInternal, "function_bytecode");

  ASSERT_TRUE(lazy_bytecode && lazy_bytecode->type() == HeapEntry::kClosure);

  auto* anonymous =
      GetGlobalProperty(heapsnapshot, HeapGraphEdge::kProperty, "anonymous");

  ASSERT_TRUE(anonymous && anonymous->name() == "Function");
  auto* anonymous_bytecode =
      GetProperty(anonymous, HeapGraphEdge::kInternal, "function_bytecode");

  ASSERT_TRUE(anonymous_bytecode &&
              anonymous_bytecode->type() == HeapEntry::kClosure);
}

TEST(HeapProfiler, HeapNumber) {
  ::TestQjsContext env;
  std::string source = R"(
    a = 1;
    b = 2.5;
  )";
  LEPUSValue ret = env.CompileAndRun(source);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);

  auto& impl = GetQjsHeapProfilerImplInstance();

  auto* heapsnapshot = impl.TakeHeapSnapshot(env.ctx);

  ASSERT_TRUE(ValidateSnapshot(heapsnapshot));

  auto* a = GetGlobalProperty(heapsnapshot, HeapGraphEdge::kProperty, "a");
  auto* b = GetGlobalProperty(heapsnapshot, HeapGraphEdge::kProperty, "b");

  ASSERT_TRUE(a == nullptr);
  ASSERT_TRUE(b == nullptr);
}

TEST(HeapProfiler, TakeSnapshotTest) {
  ::TestQjsContext env;
  take_heap_snapshot_test(env.ctx);
}

TEST(HeapProfiler, Shape) {
  ::TestQjsContext env;
  std::string src =
      "function Z() { this.foo = {} ; this.bar = 0;}\n"
      "z = new Z();\n";
  LEPUSValue ret = env.CompileAndRun(src);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);

  auto* heapsnapshot =
      GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(env.ctx);

  auto* z = GetGlobalProperty(heapsnapshot, HeapGraphEdge::kProperty, "z");

  ASSERT_TRUE(z);

  auto* z_shape = GetProperty(z, HeapGraphEdge::kInternal, "shape");

  ASSERT_TRUE(z_shape);
  auto* z_prototype = GetProperty(z_shape, HeapGraphEdge::kInternal, "proto");

  ASSERT_TRUE(z_prototype);

  auto* Function =
      GetGlobalProperty(heapsnapshot, HeapGraphEdge::kProperty, "Function");
  ASSERT_TRUE(Function);

  ASSERT_EQ(
      GetProperty(Function, HeapGraphEdge::kProperty, "prototype"),
      GetProperty(GetProperty(GetProperty(z_prototype, HeapGraphEdge::kProperty,
                                          "constructor"),
                              HeapGraphEdge::kInternal, "shape"),
                  HeapGraphEdge::kInternal, "proto"));
}

TEST(HeapProfiler, HeapSnapshotIdReuse) {
  ::TestQjsContext env;

  auto ret = env.CompileAndRun(R"(       
      function A() {this.a = 10; }
      function B() {this.b = 20; this.c = 30;} 
      var a = [];
      for (let i = 0; i < 5; ++i) {
        a[i] = new A();
      };
      JSON.stringify(a);
  )");

  const auto* snapshot1 =
      GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(env.ctx);
  ASSERT_TRUE(ValidateSnapshot(snapshot1));

  SnapshotObjectId maxID1 = snapshot1->max_snapshot_js_object_id();

  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);
  ret = env.CompileAndRun(R"(
      for (let i = 0; i < 5; ++i) {
        a[i] = new B();
      }
      JSON.stringify(a);
    )");
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);
  LEPUS_RunGC(env.rt);

  const auto* snapshot2 =
      GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(env.ctx);

  ASSERT_EQ(snapshot1->profiler(), snapshot2->profiler());

  ASSERT_TRUE(ValidateSnapshot(snapshot2));

  const auto* a = GetGlobalProperty(snapshot2, HeapGraphEdge::kProperty, "a");

  ASSERT_TRUE(a);
  size_t wrong_count = 0;

  for (size_t i = 0, count = a->children_count(); i < count; ++i) {
    const auto* prop = const_cast<HeapEntry*>(a)->child(i);

    if (prop->type() != HeapGraphEdge::kElement) continue;

    SnapshotObjectId id = prop->to()->id();

    if (id <= maxID1) {
      wrong_count++;
    }
  }

  ASSERT_EQ(wrong_count, 0);
}

TEST(HeapProfiler, HeapEntryId) {
  ::TestQjsContext env;

  std::string src = R"(
    function AnObject() {
        this.first = 'first';
        this.second = 'second';
    }

    var a = new Array();
    for (let i = 0; i < 10; ++i) {
      a.push(new AnObject());
    }
  )";

  auto ret = env.CompileAndRun(src);

  const auto* snapshot1 =
      GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(env.ctx);

  ASSERT_TRUE(ValidateSnapshot(snapshot1));

  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);
  ret = env.CompileAndRun(R"(
    for (let i = 0; i < 1; ++i) {
      a.shift();
    }
  )");

  const auto* snapshot2 =
      GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(env.ctx);

  ASSERT_TRUE(ValidateSnapshot(snapshot2));

  const auto* global1 = GetGlobalObject(snapshot1);
  const auto* global2 = GetGlobalObject(snapshot2);

  ASSERT_NE(0, global1->id());

  ASSERT_EQ(global1->id(), global2->id());

  const auto* a1 = GetGlobalProperty(snapshot1, HeapGraphEdge::kProperty, "a");

  ASSERT_TRUE(a1);

  const auto* a2 = GetGlobalProperty(snapshot2, HeapGraphEdge::kProperty, "a");

  ASSERT_TRUE(a2);

  ASSERT_EQ(a2->id(), a1->id());
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);
}

TEST(HeapProfiler, HeapObjectIds) {
  ::TestQjsContext env;

  auto ret = env.CompileAndRun(R"(
    function A() {}
    function B(x) { this.x = x; }
    var a = new A();
    var b = new B(a);
  )");

  const auto* snapshot1 =
      GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(env.ctx);

  ASSERT_TRUE(ValidateSnapshot(snapshot1));

  LEPUS_RunGC(env.rt);

  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);
  const auto* snapshot2 =
      GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(env.ctx);

  ASSERT_TRUE(ValidateSnapshot(snapshot2));

  const auto* global1 = GetGlobalObject(snapshot1);
  const auto* global2 = GetGlobalObject(snapshot2);

  ASSERT_NE(global1->id(), 0);

  ASSERT_NE(global2->id(), 0);

  ASSERT_EQ(global1->id(), global2->id());

  const auto* A1 = GetGlobalProperty(snapshot1, HeapGraphEdge::kProperty, "A");
  const auto* A2 = GetGlobalProperty(snapshot2, HeapGraphEdge::kProperty, "A");

  ASSERT_TRUE(A1 && A2);

  ASSERT_NE(A1->id(), 0);
  ASSERT_NE(A2->id(), 0);

  ASSERT_EQ(A1->id(), A2->id());

  const auto* B1 = GetGlobalProperty(snapshot1, HeapGraphEdge::kProperty, "B");
  const auto* B2 = GetGlobalProperty(snapshot2, HeapGraphEdge::kProperty, "B");

  ASSERT_TRUE(B1 && B2);

  ASSERT_EQ(B1->id(), B2->id());

  const auto* a1 = GetGlobalProperty(snapshot1, HeapGraphEdge::kProperty, "a");
  const auto* a2 = GetGlobalProperty(snapshot2, HeapGraphEdge::kProperty, "a");

  ASSERT_EQ(a1->id(), a2->id());

  const auto* b1 = GetGlobalProperty(snapshot1, HeapGraphEdge::kProperty, "b");
  const auto* b2 = GetGlobalProperty(snapshot2, HeapGraphEdge::kProperty, "b");

  ASSERT_EQ(b1->id(), b2->id());
}

namespace {
class TestJsonOutStream : public quickjs::heapprofiler::OutputStream {
 public:
  virtual ~TestJsonOutStream() = default;

  virtual void WriteChunk(const std::string& chunk) { ss << chunk; }

  std::stringstream ss;
};
}  // namespace

TEST(HeapProfiler, HeapSnapshotJSONSerialization) {
  ::TestQjsContext env;
  std::string src = R"(
    function A(s) {
      this.s = s;
    }

    function B(x) {
      this.x = x;
    }

    let a = new A("String \n\r\u0008\u0081\u0101\u0801\u8001中文测试虚拟机english test");
    let b = new B(a);
  )";

  LEPUSValue ret1 = env.CompileAndRun(src);

  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret1);

  auto* snapshot1 = GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(env.ctx);

  HeapSnapshotJSONSerializer serializer(snapshot1);

  TestJsonOutStream stream;

  serializer.Serialize(&stream);

  ASSERT_GT(stream.ss.str().size(), 0);

  LEPUSValue ret = LEPUS_ParseJSON(env.ctx, stream.ss.str().c_str(),
                                   stream.ss.str().size(), "test");
  HandleScope func_scope{env.ctx, &ret, HANDLE_TYPE_LEPUS_VALUE};

  ASSERT_TRUE(LEPUS_IsObject(ret));
  env.RegisterGlobalProperty("parsed", ret);
  auto ret2 = env.CompileAndRun(R"(
    let str = JSON.stringify(parsed);
  )");
  func_scope.PushHandle(&ret2, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue str = env.GetGlobalPropery("str");
  func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
  const char* c_str = LEPUS_ToCString(env.ctx, str);
  ASSERT_TRUE(c_str);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeCString(env.ctx, c_str);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, str);

  JSAtom snapshot_prop = LEPUS_NewAtom(env.ctx, "snapshot");
  ASSERT_TRUE(LEPUS_HasProperty(env.ctx, ret, snapshot_prop));
  if (!env.ctx->rt->gc_enable) LEPUS_FreeAtom(env.ctx, snapshot_prop);

  JSAtom edges_prop = LEPUS_NewAtom(env.ctx, "edges");
  ASSERT_TRUE(LEPUS_HasProperty(env.ctx, ret, edges_prop));
  if (!env.ctx->rt->gc_enable) LEPUS_FreeAtom(env.ctx, edges_prop);

  JSAtom nodes_prop = LEPUS_NewAtom(env.ctx, "nodes");
  ASSERT_TRUE(LEPUS_HasProperty(env.ctx, ret, nodes_prop));
  if (!env.ctx->rt->gc_enable) LEPUS_FreeAtom(env.ctx, nodes_prop);

  JSAtom string_prop = LEPUS_NewAtom(env.ctx, "strings");

  ASSERT_TRUE(LEPUS_HasProperty(env.ctx, ret, string_prop));
  if (!env.ctx->rt->gc_enable) LEPUS_FreeAtom(env.ctx, string_prop);

  src = R"(
    var meta = parsed.snapshot.meta;
    var edge_count_offset = meta.node_fields.indexOf('edge_count');
    var node_fields_count = meta.node_fields.length;
    var edge_fields_count = meta.edge_fields.length;
    var edge_type_offset = meta.edge_fields.indexOf('type');
    var edge_name_offset = meta.edge_fields.indexOf('name_or_index');
    var edge_to_node_offset = meta.edge_fields.indexOf('to_node');
    var property_type = meta.edge_types[edge_type_offset].indexOf('property');
    var element_type = meta.edge_types[edge_type_offset].indexOf("element");
    var node_count = parsed.nodes.length / node_fields_count;
    var first_edge_indexes = parsed.first_edge_indexes = [];
    var node_name_offset = meta.node_fields.indexOf('name');

    for (var i = 0, first_edge_index = 0; i < node_count; ++i) {
      first_edge_indexes[i] = first_edge_index;
      first_edge_index += edge_fields_count * parsed.nodes[i * node_fields_count + edge_count_offset];
    }

    first_edge_indexes[node_count] = first_edge_index;
  )";

  ret = env.CompileAndRun(src);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);

  src = R"(
    function GetChildPosByeProperty(pos, prop_name, prop_type) {
      var nodes = parsed.nodes;
      var edges = parsed.edges;
      var strings = parsed.strings;
      var node_ordinal = pos / node_fields_count;

      for (
        var i = parsed.first_edge_indexes[node_ordinal],
          count = parsed.first_edge_indexes[node_ordinal + 1];
        i < count;
        i += edge_fields_count
      ) {
        if (edges[i + edge_type_offset] === prop_type) {
          if (
            (prop_type == element_type &&
              prop_name == edges[i + edge_name_offset]) ||
            (prop_type == property_type &&
              prop_name == strings[edges[i + edge_name_offset]])
          ) {
            return edges[i + edge_to_node_offset];
          }
        }
      }
      return null;
    }
  )";
  ret = env.CompileAndRun(src);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);

  src = R"(
    let string_obj_pos_val = GetChildPosByeProperty(
      GetChildPosByeProperty(
        GetChildPosByeProperty(
          GetChildPosByeProperty(first_edge_indexes[0], 3, element_type),
          "b",
          property_type
        ),
        "x",
        property_type
      ),
      "s",
      property_type
    );

    let actual_string =
      parsed.strings[parsed.nodes[string_obj_pos_val + node_name_offset]];
    print(actual_string);
  )";

  ret = env.CompileAndRun(src);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret);

  LEPUSValue actual = env.GetGlobalPropery("actual_string");
  const char* actual_str = LEPUS_ToCString(env.ctx, actual);

  ASSERT_EQ(
      std::string(actual_str),
      "String \n\r\u0008\u0081\u0101\u0801\u8001中文测试虚拟机english test");
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, actual);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeCString(env.ctx, actual_str);
  if (!env.ctx->rt->gc_enable) LEPUS_FreeValue(env.ctx, ret2);
}

}  // namespace heapprofiler
}  // namespace quickjs
