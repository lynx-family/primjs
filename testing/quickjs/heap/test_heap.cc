#include <gtest/gtest.h>

#include <atomic>
#include <mutex>
#include <thread>
#include <vector>

#include "test_base.h"

namespace heap_test {

static LEPUSValue ReturnFortyTwo(LEPUSContext *ctx, LEPUSValueConst, int,
                                 LEPUSValueConst *) {
  return LEPUS_NewInt32(ctx, 42);
}

static LEPUSValue InitializeFortyThree(LEPUSContext *ctx, LEPUSObject *, JSAtom,
                                       void *) {
  return LEPUS_NewInt32(ctx, 43);
}

static LEPUSValue CountAutoInitCalls(LEPUSContext *ctx, LEPUSObject *, JSAtom,
                                     void *opaque) {
  ++*static_cast<int *>(opaque);
  return LEPUS_NewInt32(ctx, 45);
}

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

TEST_F(HeapTest, CompactPropertyAndObjectLayout) {
  if (!ctx->gc_enable) {
    GTEST_SKIP() << "compact property layout is specific to tracing GC";
  }

  static_assert(sizeof(JSPropertyGC) == sizeof(LEPUSValue));
  EXPECT_EQ(sizeof(JSPropertyGC), sizeof(LEPUSValue));

  if (sizeof(void *) == 8 && sizeof(LEPUSValue) == 8) {
    EXPECT_EQ(sizeof(JSProperty), 16u);
    EXPECT_EQ(GetLEPUSObjectAllocSize(JS_CLASS_OBJECT), 64u);
    EXPECT_EQ(GetLEPUSObjectAllocSize(JS_CLASS_ERROR), 72u);
    EXPECT_EQ(GetLEPUSObjectAllocSize(JS_CLASS_BOUND_FUNCTION), 72u);
    EXPECT_EQ(GetLEPUSObjectAllocSize(JS_CLASS_NUMBER), 72u);
    EXPECT_EQ(GetLEPUSObjectAllocSize(JS_CLASS_C_FUNCTION), 80u);
    EXPECT_EQ(GetLEPUSObjectAllocSize(JS_CLASS_REGEXP), 80u);
    EXPECT_EQ(GetLEPUSObjectAllocSize(JS_CLASS_ARRAY), 88u);
    EXPECT_EQ(GetLEPUSObjectAllocSize(JS_CLASS_BYTECODE_FUNCTION), 88u);

    size_t allocated_before = ctx->rt->ros_->GetAllocatedSize();
    void *ordinary_slot = lepus_malloc(
        ctx, GetLEPUSObjectAllocSize(JS_CLASS_OBJECT), ALLOC_TAG_WITHOUT_PTR);
    ASSERT_NE(ordinary_slot, nullptr);
    HandleScope ordinary_slot_scope(ctx, ordinary_slot,
                                    HANDLE_TYPE_DIR_HEAP_OBJ);
    EXPECT_EQ(ctx->rt->ros_->GetAllocatedSize() - allocated_before, 72u);
  }

  LEPUSValue obj = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(obj));
  HandleScope obj_scope(ctx, &obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(obj);

  if (CanInlineLEPUSObjectProperties(JS_CLASS_OBJECT)) {
    EXPECT_EQ(get_obj_size(p), GetLEPUSObjectAllocSize(JS_CLASS_OBJECT));
    EXPECT_TRUE(IS_IN_OBJECT_PROP(p, p->gc_prop));
    EXPECT_EQ(reinterpret_cast<uintptr_t>(p->gc_prop) -
                  reinterpret_cast<uintptr_t>(p),
              GetLEPUSObjectInlinePropOffset(JS_CLASS_OBJECT));
  } else {
    EXPECT_EQ(get_obj_size(p), LEPUS_OBJECT_SIZE);
    EXPECT_FALSE(IS_IN_OBJECT_PROP(p, p->gc_prop));
  }

  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, obj, "a", LEPUS_NewInt32(ctx, 1)), 1);
  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, obj, "b", LEPUS_NewInt32(ctx, 2)), 1);
  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, obj, "c", LEPUS_NewInt32(ctx, 3)), 1);
  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, obj, "d", LEPUS_NewInt32(ctx, 4)), 1);
  EXPECT_EQ(IS_IN_OBJECT_PROP(p, p->gc_prop),
            CanInlineLEPUSObjectProperties(JS_CLASS_OBJECT));

  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, obj, "e", LEPUS_NewInt32(ctx, 5)), 1);
  EXPECT_FALSE(IS_IN_OBJECT_PROP(p, p->gc_prop));
  EXPECT_GE(get_obj_size(p->gc_prop),
            p->shape->prop_size * sizeof(JSPropertyGC));

  LEPUS_RunGC(ctx->rt);
  LEPUSValue value = LEPUS_GetPropertyStr(ctx, obj, "e");
  EXPECT_TRUE(LEPUS_IsNumber(value));
  EXPECT_EQ(LEPUS_VALUE_GET_INT(value), 5);
}

TEST_F(HeapTest, ShapeStoreMarksTargetDuringConcurrentMark) {
  if (!ctx->gc_enable) {
    GTEST_SKIP() << "shape barriers are specific to tracing GC";
  }

  constexpr char first_setter_source[] =
      "(function(object, value) { object.first = value; })";
  LEPUSValue first_setter =
      LEPUS_Eval(ctx, first_setter_source, sizeof(first_setter_source) - 1,
                 "shape_first_setter.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(first_setter));
  HandleScope scope(ctx, &first_setter, HANDLE_TYPE_LEPUS_VALUE);

  constexpr char second_setter_source[] =
      "(function(object, value) { object.second = value; })";
  LEPUSValue second_setter =
      LEPUS_Eval(ctx, second_setter_source, sizeof(second_setter_source) - 1,
                 "shape_second_setter.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(second_setter));
  scope.PushHandle(&second_setter, HANDLE_TYPE_LEPUS_VALUE);

  LEPUSValue objects[] = {LEPUS_NewObject(ctx), LEPUS_NewObject(ctx),
                          LEPUS_NewObject(ctx)};
  for (LEPUSValue &object : objects) {
    ASSERT_FALSE(LEPUS_IsException(object));
    scope.PushHandle(&object, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValueConst argv[] = {object, LEPUS_NewInt32(ctx, 1)};
    LEPUSValue result = LEPUS_Call(ctx, first_setter, LEPUS_UNDEFINED, 2, argv);
    ASSERT_FALSE(LEPUS_IsException(result));
  }

  for (int index = 0; index < 2; index++) {
    LEPUSValueConst argv[] = {objects[index], LEPUS_NewInt32(ctx, 2)};
    LEPUSValue result =
        LEPUS_Call(ctx, second_setter, LEPUS_UNDEFINED, 2, argv);
    ASSERT_FALSE(LEPUS_IsException(result));
  }

  LEPUSObject *pending_object = LEPUS_VALUE_GET_OBJ(objects[2]);
  JSShape *shape = LEPUS_VALUE_GET_OBJ(objects[1])->shape;
  ASSERT_EQ(shape->parent, pending_object->shape);
  ASSERT_EQ(pending_object->shape->transition.target, shape);
  address_t shape_addr =
      reinterpret_cast<address_t>(shape) - ROS_GC::kHeaderSize;

  ctx->rt->ros_->UnMarkObject(shape_addr);
  EXPECT_FALSE(ctx->rt->ros_->IsObjectMarked(shape_addr));

  ctx->con_mark_state = true;
  ctx->rt->con_mark_state = true;
  LEPUSValueConst argv[] = {objects[2], LEPUS_NewInt32(ctx, 3)};
  LEPUSValue result = LEPUS_Call(ctx, second_setter, LEPUS_UNDEFINED, 2, argv);
  ctx->rt->con_mark_state = false;
  ctx->con_mark_state = false;

  ASSERT_FALSE(LEPUS_IsException(result));
  EXPECT_TRUE(ctx->rt->ros_->IsObjectMarked(shape_addr));
  EXPECT_EQ(pending_object->shape, shape);
}

TEST_F(HeapTest, CompactAccessorAndAutoInitSurviveGC) {
  if (!ctx->gc_enable) {
    GTEST_SKIP() << "compact property layout is specific to tracing GC";
  }

#ifdef ENABLE_COMPATIBLE_MM
  LEPUSValue native_accessor = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(native_accessor));
  HandleScope native_accessor_scope(ctx, &native_accessor,
                                    HANDLE_TYPE_LEPUS_VALUE);
  JSAtom accessor_atom = LEPUS_NewAtom(ctx, "nativeAccessor");
  native_accessor_scope.PushLEPUSAtom(accessor_atom);
  LEPUSObject *getter_object = nullptr;
  {
    LEPUSValue getter =
        LEPUS_NewCFunction(ctx, ReturnFortyTwo, "returnFortyTwo", 0);
    ASSERT_FALSE(LEPUS_IsException(getter));
    HandleScope getter_scope(ctx, &getter, HANDLE_TYPE_LEPUS_VALUE);
    getter_object = LEPUS_VALUE_GET_OBJ(getter);
    ASSERT_EQ(
        LEPUS_DefinePropertyGetSet(ctx, native_accessor, accessor_atom, getter,
                                   LEPUS_UNDEFINED, LEPUS_PROP_CONFIGURABLE),
        1);
  }

  JSAtom autoinit_atom = LEPUS_NewAtom(ctx, "nativeAutoInit");
  native_accessor_scope.PushLEPUSAtom(autoinit_atom);
  ASSERT_EQ(JS_DefineAutoInitProperty_GC(ctx, native_accessor, autoinit_atom,
                                         InitializeFortyThree, nullptr,
                                         LEPUS_PROP_CONFIGURABLE),
            1);

  JSAtom var_ref_atom = LEPUS_NewAtom(ctx, "nativeVarRef");
  native_accessor_scope.PushLEPUSAtom(var_ref_atom);
  JSVarRef *expected_var_ref = nullptr;
  {
    auto *gc_var_ref = static_cast<JSVarRefGC *>(
        lepus_malloc(ctx, sizeof(JSVarRefGC), ALLOC_TAG_JSVarRef));
    expected_var_ref = reinterpret_cast<JSVarRef *>(gc_var_ref);
    ASSERT_NE(expected_var_ref, nullptr);
    HandleScope var_ref_scope(ctx, expected_var_ref, HANDLE_TYPE_DIR_HEAP_OBJ);
    gc_var_ref->value = LEPUS_NewInt32(ctx, 44);
    gc_var_ref->pvalue = &gc_var_ref->value;
    JSPropertyGC *var_ref_property =
        add_property_gc(ctx, LEPUS_VALUE_GET_OBJ(native_accessor), var_ref_atom,
                        LEPUS_PROP_C_W_E | LEPUS_PROP_VARREF);
    ASSERT_NE(var_ref_property, nullptr);
    LEPUS_HeapObjStore(ctx, &var_ref_property->u.value,
                       js_property_gc_make_var_ref(expected_var_ref));
  }

  LEPUS_RunGC(ctx->rt);
  LEPUSObject *native_object = LEPUS_VALUE_GET_OBJ(native_accessor);
  JSShapeProperty *accessor_shape_property =
      find_own_property1(native_object, accessor_atom);
  ASSERT_NE(accessor_shape_property, nullptr);
  size_t accessor_index =
      accessor_shape_property - get_shape_prop(native_object->shape);
  JSPropertyGetSet *getset =
      js_property_gc_get_getset(&native_object->gc_prop[accessor_index]);
  ASSERT_NE(getset, nullptr);
  EXPECT_EQ(js_property_gc_get_accessor(getset->getter), getter_object);

  JSShapeProperty *var_ref_shape_property =
      find_own_property1(native_object, var_ref_atom);
  ASSERT_NE(var_ref_shape_property, nullptr);
  size_t var_ref_index =
      var_ref_shape_property - get_shape_prop(native_object->shape);
  EXPECT_EQ(js_property_gc_get_var_ref(&native_object->gc_prop[var_ref_index]),
            expected_var_ref);
  LEPUSValue var_ref_value =
      LEPUS_GetProperty(ctx, native_accessor, var_ref_atom);
  ASSERT_TRUE(LEPUS_IsNumber(var_ref_value));
  EXPECT_EQ(LEPUS_VALUE_GET_INT(var_ref_value), 44);

  if (sizeof(LEPUSValue) == 8) {
    LEPUSValue native_value =
        LEPUS_GetProperty(ctx, native_accessor, accessor_atom);
    ASSERT_TRUE(LEPUS_IsNumber(native_value));
    EXPECT_EQ(LEPUS_VALUE_GET_INT(native_value), 42);
  }

  LEPUSValue native_value =
      LEPUS_GetProperty(ctx, native_accessor, autoinit_atom);
  ASSERT_TRUE(LEPUS_IsNumber(native_value));
  EXPECT_EQ(LEPUS_VALUE_GET_INT(native_value), 43);

  if (sizeof(LEPUSValue) != 8) {
    return;
  }
#endif

  const char mapped_arguments_source[] =
      "(function(value) { return arguments; })(7)";
  LEPUSValue mapped_arguments = LEPUS_Eval(
      ctx, mapped_arguments_source, sizeof(mapped_arguments_source) - 1,
      "mapped_arguments.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(mapped_arguments));
  HandleScope mapped_arguments_scope(ctx, &mapped_arguments,
                                     HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_RunGC(ctx->rt);
  LEPUSValue mapped_value = LEPUS_GetPropertyUint32(ctx, mapped_arguments, 0);
  ASSERT_TRUE(LEPUS_IsNumber(mapped_value));
  EXPECT_EQ(LEPUS_VALUE_GET_INT(mapped_value), 7);

  const char accessor_source[] =
      "(() => {"
      "  let value = 41;"
      "  const object = {};"
      "  Object.defineProperty(object, 'x', {"
      "    get() { return value + 1; },"
      "    set(next) { value = next; },"
      "    configurable: true"
      "  });"
      "  return object;"
      "})()";
  LEPUSValue accessor =
      LEPUS_Eval(ctx, accessor_source, sizeof(accessor_source) - 1,
                 "compact_accessor.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(accessor));
  HandleScope accessor_scope(ctx, &accessor, HANDLE_TYPE_LEPUS_VALUE);

  LEPUSValue value = LEPUS_GetPropertyStr(ctx, accessor, "x");
  ASSERT_TRUE(LEPUS_IsNumber(value));
  EXPECT_EQ(LEPUS_VALUE_GET_INT(value), 42);

  LEPUS_RunGC(ctx->rt);
  value = LEPUS_GetPropertyStr(ctx, accessor, "x");
  ASSERT_TRUE(LEPUS_IsNumber(value));
  EXPECT_EQ(LEPUS_VALUE_GET_INT(value), 42);
  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, accessor, "x", LEPUS_NewInt32(ctx, 9)),
            1);
  value = LEPUS_GetPropertyStr(ctx, accessor, "x");
  ASSERT_TRUE(LEPUS_IsNumber(value));
  EXPECT_EQ(LEPUS_VALUE_GET_INT(value), 10);

  const char error_source[] =
      "(() => { try { throw new Error('compact'); } catch (error) {"
      "  return error;"
      "} })()";
  LEPUSValue error = LEPUS_Eval(ctx, error_source, sizeof(error_source) - 1,
                                "compact_autoinit.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(error));
  HandleScope error_scope(ctx, &error, HANDLE_TYPE_LEPUS_VALUE);

  LEPUS_RunGC(ctx->rt);
  LEPUSValue stack = LEPUS_GetPropertyStr(ctx, error, "stack");
  EXPECT_FALSE(LEPUS_IsUndefined(stack));
  EXPECT_FALSE(LEPUS_IsException(stack));
}

TEST_F(HeapTest, DeepEqualRejectsNonValueProperties) {
  LEPUSValue accessor_left = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(accessor_left));
  HandleScope scope(ctx, &accessor_left, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue accessor_right = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(accessor_right));
  scope.PushHandle(&accessor_right, HANDLE_TYPE_LEPUS_VALUE);
  JSAtom accessor_atom = LEPUS_NewAtom(ctx, "accessor");
  scope.PushLEPUSAtom(accessor_atom);

  LEPUSValue left_getter =
      LEPUS_NewCFunction(ctx, ReturnFortyTwo, "leftGetter", 0);
  ASSERT_FALSE(LEPUS_IsException(left_getter));
  ASSERT_EQ(LEPUS_DefinePropertyGetSet(
                ctx, accessor_left, accessor_atom, left_getter, LEPUS_UNDEFINED,
                LEPUS_PROP_CONFIGURABLE | LEPUS_PROP_ENUMERABLE),
            1);
  LEPUSValue right_getter =
      LEPUS_NewCFunction(ctx, ReturnFortyTwo, "rightGetter", 0);
  ASSERT_FALSE(LEPUS_IsException(right_getter));
  ASSERT_EQ(
      LEPUS_DefinePropertyGetSet(
          ctx, accessor_right, accessor_atom, right_getter, LEPUS_UNDEFINED,
          LEPUS_PROP_CONFIGURABLE | LEPUS_PROP_ENUMERABLE),
      1);

  LEPUSValue result = LEPUS_DeepEqual(ctx, accessor_left, accessor_right);
  ASSERT_TRUE(LEPUS_IsBool(result));
  EXPECT_FALSE(LEPUS_VALUE_GET_BOOL(result));

  if (!ctx->gc_enable) {
    return;
  }

#ifdef ENABLE_COMPATIBLE_MM
  LEPUSValue var_ref_left = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(var_ref_left));
  scope.PushHandle(&var_ref_left, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue var_ref_right = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(var_ref_right));
  scope.PushHandle(&var_ref_right, HANDLE_TYPE_LEPUS_VALUE);
  JSAtom var_ref_atom = LEPUS_NewAtom(ctx, "varRef");
  scope.PushLEPUSAtom(var_ref_atom);

  auto define_var_ref = [&](LEPUSValue owner) {
    JSVarRef *var_ref = static_cast<JSVarRef *>(
        lepus_mallocz(ctx, sizeof(JSVarRef), ALLOC_TAG_JSVarRef));
    ASSERT_NE(var_ref, nullptr);
    HandleScope var_ref_scope(ctx, var_ref, HANDLE_TYPE_DIR_HEAP_OBJ);
    var_ref->is_detached = 1;
    var_ref->value = LEPUS_NewInt32(ctx, 44);
    var_ref->pvalue = &var_ref->value;
    JSPropertyGC *property =
        add_property_gc(ctx, LEPUS_VALUE_GET_OBJ(owner), var_ref_atom,
                        LEPUS_PROP_C_W_E | LEPUS_PROP_VARREF);
    ASSERT_NE(property, nullptr);
    LEPUS_HeapObjStore(ctx, &property->u.value,
                       js_property_gc_make_var_ref(var_ref));
  };
  define_var_ref(var_ref_left);
  define_var_ref(var_ref_right);

  result = LEPUS_DeepEqual(ctx, var_ref_left, var_ref_right);
  ASSERT_TRUE(LEPUS_IsBool(result));
  EXPECT_FALSE(LEPUS_VALUE_GET_BOOL(result));

  LEPUSValue autoinit_left = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(autoinit_left));
  scope.PushHandle(&autoinit_left, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue autoinit_right = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(autoinit_right));
  scope.PushHandle(&autoinit_right, HANDLE_TYPE_LEPUS_VALUE);
  JSAtom autoinit_atom = LEPUS_NewAtom(ctx, "autoInit");
  scope.PushLEPUSAtom(autoinit_atom);
  int left_init_calls = 0;
  int right_init_calls = 0;
  ASSERT_EQ(
      JS_DefineAutoInitProperty_GC(
          ctx, autoinit_left, autoinit_atom, CountAutoInitCalls,
          &left_init_calls, LEPUS_PROP_CONFIGURABLE | LEPUS_PROP_ENUMERABLE),
      1);
  ASSERT_EQ(
      JS_DefineAutoInitProperty_GC(
          ctx, autoinit_right, autoinit_atom, CountAutoInitCalls,
          &right_init_calls, LEPUS_PROP_CONFIGURABLE | LEPUS_PROP_ENUMERABLE),
      1);

  result = LEPUS_DeepEqual(ctx, autoinit_left, autoinit_right);
  ASSERT_TRUE(LEPUS_IsBool(result));
  EXPECT_FALSE(LEPUS_VALUE_GET_BOOL(result));
  EXPECT_EQ(left_init_calls, 0);
  EXPECT_EQ(right_init_calls, 0);
#endif
}

TEST_F(HeapTest, DeepEqualResolvesCounterpartThroughAccessors) {
  // Regression for the compact-gc property-layout refactor: the counterpart
  // value on obj2 must be resolved through the normal property path, not read
  // from a raw own slot. A plain data property therefore stays equal to an
  // accessor that yields the same value, identically in RC and GC modes, so
  // DeepEqual results do not depend on how obj2 stores the property.
  LEPUSValue data_obj = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(data_obj));
  HandleScope scope(ctx, &data_obj, HANDLE_TYPE_LEPUS_VALUE);
  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, data_obj, "x", LEPUS_NewInt32(ctx, 42)),
            1);

  const char accessor_source[] =
      "(() => {"
      "  const o = {};"
      "  Object.defineProperty(o, 'x', {"
      "    get() { return 42; }, enumerable: true, configurable: true"
      "  });"
      "  return o;"
      "})()";
  LEPUSValue accessor_obj =
      LEPUS_Eval(ctx, accessor_source, sizeof(accessor_source) - 1,
                 "deepequal_accessor.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(accessor_obj));
  scope.PushHandle(&accessor_obj, HANDLE_TYPE_LEPUS_VALUE);

  // obj2's accessor yields the same value -> equal.
  LEPUSValue result = LEPUS_DeepEqual(ctx, data_obj, accessor_obj);
  ASSERT_TRUE(LEPUS_IsBool(result));
  EXPECT_TRUE(LEPUS_VALUE_GET_BOOL(result));

  // A different value returned by obj2's accessor -> not equal.
  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, data_obj, "x", LEPUS_NewInt32(ctx, 7)),
            1);
  result = LEPUS_DeepEqual(ctx, data_obj, accessor_obj);
  ASSERT_TRUE(LEPUS_IsBool(result));
  EXPECT_FALSE(LEPUS_VALUE_GET_BOOL(result));
}

TEST_F(HeapTest, ObjectContextCheckHonorsEachObjectLayout) {
  if (!ctx->gc_enable) {
    GTEST_SKIP() << "compact object allocation is specific to tracing GC";
  }

  LEPUSValue compact_obj = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(compact_obj));
  HandleScope compact_obj_scope(ctx, &compact_obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSObject *compact_p = LEPUS_VALUE_GET_OBJ(compact_obj);
  EXPECT_EQ(LEPUSObjectHasContextFields(ctx->rt, compact_p),
            !CanInlineLEPUSObjectProperties(JS_CLASS_OBJECT));
  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, compact_obj, "a", LEPUS_NewInt32(ctx, 1)),
            1);
  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, compact_obj, "b", LEPUS_NewInt32(ctx, 2)),
            1);
  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, compact_obj, "c", LEPUS_NewInt32(ctx, 3)),
            1);
  ASSERT_EQ(LEPUS_SetPropertyStr(ctx, compact_obj, "d", LEPUS_NewInt32(ctx, 4)),
            1);

  SetObjectCtxCheckStatus(ctx, true);
  /* Must not interpret the fourth inline property as ctx/tid. */
  CheckObjectCtx(ctx, compact_obj);
  LEPUSValue old_value = LEPUS_GetPropertyStr(ctx, compact_obj, "d");
  ASSERT_TRUE(LEPUS_IsNumber(old_value));
  EXPECT_EQ(LEPUS_VALUE_GET_INT(old_value), 4);

  LEPUSValue obj = LEPUS_NewObject(ctx);
  ASSERT_FALSE(LEPUS_IsException(obj));
  HandleScope obj_scope(ctx, &obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(obj);
  EXPECT_EQ(get_obj_size(p), LEPUS_OBJECT_SIZE);
  EXPECT_FALSE(IS_IN_OBJECT_PROP(p, p->gc_prop));
  EXPECT_TRUE(LEPUSObjectHasContextFields(ctx->rt, p));
  EXPECT_EQ(p->ctx, ctx);
  SetObjectCtxCheckStatus(ctx, false);
}

}  // namespace heap_test
