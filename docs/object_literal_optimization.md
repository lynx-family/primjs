# Object Literal Optimization

## Background

In QuickJS / PrimJS, an object literal like `{a: 1, b: 2, c: 3}` was originally
compiled into a sequence of bytecodes:

```
OP_object              ; allocate an empty object (shape with prop_count = 0)
<push value 1>
OP_define_field "a"    ; triggers a shape transition 0 -> 1
<push value 2>
OP_define_field "b"    ; triggers a shape transition 1 -> 2
<push value 3>
OP_define_field "c"    ; triggers a shape transition 2 -> 3
```

For each property, the interpreter dispatches an `OP_define_field` and calls
`add_property`, which in turn looks up / installs a shape transition and
re-allocates the property storage if the inline capacity is exceeded.

Even though the literal's "shape" is fully known at parse time, every execution
of the same literal pays for shape transitions, dispatch and capacity growth.
This optimization moves all of that work into the parser, so that runtime only
needs to **clone a pre-built shape** and **move N values into the new object**.

This is the same idea V8 calls *Object Literal Boilerplate* and SpiderMonkey
calls *NewObject template*.

## High-level Design

A new opcode `OP_object_literal` is introduced:

| field | value |
| --- | --- |
| size | 5 bytes (1 opcode + 4-byte cpool index) |
| stack pop | dynamic — equals `template->shape->prop_count` |
| stack push | 1 (the new object) |
| operand | constant pool index pointing at the template object |

At parse time, the compiler accumulates a list of "plain" property names while
their value expressions are emitted as usual (the values stay on the operand
stack). When the literal is closed, the compiler:

1. Allocates a template object whose shape already contains every collected
   property in the right order, with all slot values initialized to
   `LEPUS_UNDEFINED`.
2. Stores the template into the function's constant pool.
3. Emits a single `OP_object_literal cpool_idx` instruction.

At runtime, `OP_object_literal` clones the template shape, allocates a new
object, and moves the N values from the stack into the object's property slots
in order. No `add_property`, no shape transition, no per-field dispatch.

## Eligible vs. Ineligible Properties

A property is **eligible** for the template path if and only if it is one of:

* `key: value` (plain named property with a non-computed key)
* shorthand `key` (which is sugar for `key: key`)

Anything else triggers a one-way **flush**: the compiler immediately emits the
`OP_object_literal` (or `OP_object` if nothing has been collected yet), the new
object is now on the stack, and every subsequent property falls back to the
classic `OP_define_field` / `OP_define_method` / `OP_set_proto` / spread path.

Ineligible cases that force a flush:

| Case | Reason |
| --- | --- |
| `...spread` | Needs `OP_apply_spread` over an existing object. |
| `[expr]: v` (computed key) | Key not known at parse time. |
| `method() {}`, `*gen() {}`, `async f() {}` | Need `OP_define_method`. |
| `get x() {}`, `set x(v) {}` | Need accessor descriptors. |
| Duplicate key | The latter assignment must overwrite, which requires a real `add_property` (the template only has unique slots). |
| `__proto__: v` | Must call `OP_set_proto` to set the prototype rather than create an own property. |
| Computed key producing `JS_ATOM_NULL` | Same as above. |

The flush is **monotonic** — once the slow path is taken, the parser does not
return to template mode for the same literal.

## Compiler-side Implementation

### Data structures

```c
typedef struct JSObjectLiteralAtomList {
  JSAtom *atoms;
  int count;
  int size;
} JSObjectLiteralAtomList;
```

Helpers:

* `js_object_literal_atom_list_add` — append an atom (with `LEPUS_DupAtom`),
  growing the array geometrically.
* `js_object_literal_atom_list_has` — linear scan for duplicate detection.
* `js_object_literal_atom_list_free` — release atom refs and the buffer.

### Emit / flush

`js_emit_object_literal` materializes the collected list into the template:

```c
tmpl = JS_NewObjectProtoClassAlloc(ctx, Object.prototype, JS_CLASS_OBJECT,
                                   ol->count);
for (i = 0; i < ol->count; i++) {
  pr = add_property(ctx, p, ol->atoms[i], LEPUS_PROP_C_W_E);
  pr->u.value = LEPUS_UNDEFINED;
}
idx = cpool_add(s, tmpl);
emit_op(s, OP_object_literal);
emit_u32(s, idx);
```

`js_flush_object_literal` wraps `js_emit_object_literal` and always frees the
atom list afterwards. If the list is empty (e.g. `{}`), it degenerates to a
plain `OP_object`.

### Driver in `js_parse_object_literal`

A boolean `obj_emitted` tracks whether the object is already on the operand
stack:

* `obj_emitted = FALSE` — still in template-collection mode; values produced by
  eligible properties stay on the stack and their atoms are appended to
  `atom_list`.
* `obj_emitted = TRUE` — the template has been flushed; subsequent properties
  emit `OP_define_field` / `OP_define_method` / `OP_set_proto` exactly like
  before.

Lookahead (`peek_token`) is used to decide whether an identifier introduces a
shorthand (eligible) or a method / getter / setter (forces flush).

## Runtime Implementation

### `JS_NewObjectFromTemplate`

```c
QJS_STATIC LEPUSValue JS_NewObjectFromTemplate(LEPUSContext *ctx,
                                               LEPUSValueConst tmpl,
                                               LEPUSValue *values) {
  LEPUSObject *tp = LEPUS_VALUE_GET_OBJ(tmpl);
  int prop_count = tp->shape->prop_count;
  JSShape *sh = js_clone_shape(ctx, tp->shape);
  if (unlikely(!sh)) return LEPUS_EXCEPTION;
  LEPUSValue obj = JS_NewObjectFromShape(ctx, sh, JS_CLASS_OBJECT);
  if (unlikely(LEPUS_IsException(obj))) return obj;
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(obj);
  for (int i = 0; i < prop_count; i++) {
    p->prop[i].u.value = values[i];
    values[i] = LEPUS_UNDEFINED;       // ownership transferred
  }
  return obj;
}
```

Ownership contract:

* On success, every value in `values[0..prop_count)` is moved into the new
  object; the corresponding stack slot is set to `LEPUS_UNDEFINED` so the
  caller does not double-free.
* On failure, `values` is left untouched; the caller is responsible for
  releasing the values still on the stack.

### Interpreter dispatch

```c
CASE(OP_object_literal): {
  int idx = get_u32(pc); pc += 4;
  LEPUSValueConst tmpl = b->cpool[idx];
  int prop_count = LEPUS_VALUE_GET_OBJ(tmpl)->shape->prop_count;
  sp -= prop_count;
  LEPUSValue obj = JS_NewObjectFromTemplate(ctx, tmpl, sp);
  if (unlikely(LEPUS_IsException(obj))) {
    for (int i = 0; i < prop_count; i++) LEPUS_FreeValue(ctx, sp[i]);
    goto exception;
  }
  sp[0] = obj;
  sp++;
}
BREAK;
```

### Stack-size analysis

The `OP_FMT_const` format encodes a constant pool index, but the number of
values popped from the operand stack is *not* a fixed constant — it depends on
the template stored at that cpool index. `compute_stack_size_rec` is therefore
extended:

```c
if (op == OP_object_literal) {
  int idx = get_u32(bc_buf + pos + 1);
  LEPUSObject *tmpl = LEPUS_VALUE_GET_OBJ(fd->cpool[idx]);
  n_pop = tmpl->shape->prop_count;
}
```

`n_push` stays at 1 (the new object).

## Performance

Per literal evaluation, the new path saves:

| Metric | Before | After |
| --- | --- | --- |
| Interpreter dispatches | `1 + N` | `1` |
| Shape transitions / lookups | `N` per execution | `0` per execution (paid once at parse time) |
| `add_property` calls | `N` per execution | `0` per execution |
| Bytecode size | `1 + 5N` | `5` |

Hot-path workloads where the same literal is constructed repeatedly (data
records inside loops, configuration objects in factory functions, JSON-style
DTOs returned from helpers) benefit most.

## Worked Example

Source:

```js
function make(id, name) {
  return { id: id, name: name, type: 'user', score: 0 };
}
```

Before:

```
OP_object
OP_get_loc id        OP_define_field "id"
OP_get_loc name      OP_define_field "name"
OP_push_atom "user"  OP_define_field "type"
OP_push_i32 0        OP_define_field "score"
```

After (template `{id, name, type, score}` lives in cpool[k]):

```
OP_get_loc id
OP_get_loc name
OP_push_atom "user"
OP_push_i32 0
OP_object_literal k     ; pops 4, pushes 1
```

## Edge Cases & Correctness Notes

* **Empty literal `{}`** — `obj_emitted` is `FALSE` at the closing `}`; the
  final flush turns into `OP_object` (the atom list is empty).
* **Duplicate key `{a: 1, a: 2}`** — the second `a` triggers a flush before
  emitting; the first `a` is realized via the template, the second via
  `OP_define_field`, preserving the "last write wins" semantics.
* **`__proto__: v`** — forces a flush so that `OP_set_proto` runs against a
  real object.
* **Shorthand `{__proto__}`** — *not* the prototype-setter form; this is a
  plain own property, so it stays on the template path.
* **Exception during evaluation** — values already pushed for the literal sit
  on the operand stack; the standard exception unwinder frees them. Inside the
  `OP_object_literal` failure branch we explicitly release the N values that
  were going to be moved into the (failed) clone.
* **Atom lifetime** — atoms in `atom_list` are dup'd on insert and freed on
  flush / fail, matching the lifetime of atoms baked into the template's
  shape.
* **GC reachability** — the template object is reachable through the function's
  cpool, which is itself owned by the bytecode function value; the cloned
  shape is independent of the template's shape.

## File Map

| File | Change |
| --- | --- |
| `oss/src/interpreter/quickjs/include/quickjs-opcode.h` | Add `OP_object_literal` definition. |
| `oss/src/interpreter/quickjs/source/quickjs.cc` | Add `JS_NewObjectFromTemplate`, the atom-list helpers, the parser flush logic, the interpreter dispatch, and the stack-size analysis branch. |

## Future Work

* **Constant-value boilerplate.** When all property values are compile-time
  constants, the template can carry the values themselves; runtime then
  becomes a pure object clone with no per-slot copy. Matches V8's
  `CloneObjectIC` fast path.
* **Threshold-based fallback.** For very large literals, the O(N²) duplicate
  check during parsing and the long-lived cpool entry may not be worth it; a
  size threshold (e.g. 32) can fall back to plain `OP_object` to keep parser
  time and memory predictable.
* **Inline-cache friendliness.** The cloned shape is suitable as a transition
  root for property loads in monomorphic call sites; downstream IC work can
  exploit this.
