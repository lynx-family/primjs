// Copyright 2024 the PrimTS project authors. All rights reserved.

#ifndef UTILS_BASE_H_
#define UTILS_BASE_H_
#include <stdio.h>

#ifdef DEBUG
#define PrintF(...) fprintf(stderr, __VA_ARGS__)
#else
#define PrintF(...)
#endif

#ifdef DEBUG
#ifndef vmassert
#define vmassert(p, ...)
#endif
#define dcheck(c) vmassert((c))
#define dcheck_not(c) vmassert(!(c))
#define dcheck_ne(l, r) vmassert((l) != (r))
#define dcheck_eq(l, r) vmassert((l) == (r))
#define dcheck_ge(l, r) vmassert((l) >= (r))
#define dcheck_gt(l, r) vmassert((l) > (r))
#define dcheck_le(l, r) vmassert((l) <= (r))
#define dcheck_implies(l, r) vmassert((l && r) || (!(l)))
#define dcheck_lt(l, r) vmassert((l) < (r))
#define dcheck_not_null(l) vmassert((void *)l != nullptr)
#else
#define dcheck(c)
#define dcheck_not(c)
#define dcheck_ne(l, r)
#define dcheck_eq(l, r)
#define dcheck_ge(l, r)
#define dcheck_gt(l, r)
#define dcheck_le(l, r)
#define dcheck_implies(l, r)
#define dcheck_lt(l, r)
#define dcheck_not_null(l)
#endif

#define ALWAYS_INLINE __attribute__((always_inline))
#define UNREACHABLE __builtin_unreachable

#endif  // UTILS_BASE_H_
