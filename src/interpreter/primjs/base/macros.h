/*
 * Copyright (c) 2024 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_MACROS_H
#define PRIMJS_MACROS_H

namespace base {
struct Use {
  template <typename T>
  constexpr Use(T &&) {}  // NOLINT(runtime/explicit)
};
}  // namespace base

#define THREAD_LOCAL __thread

#ifdef ASSERT
#define DEBUG_ONLY(code) code
#define NOT_DEBUG(code)
#define NOT_DEBUG_RETURN /*next token must be ;*/
// Historical.
#define debug_only(code) code
#else  // ASSERT
#define DEBUG_ONLY(code)
#define NOT_DEBUG(code) code
#define NOT_DEBUG_RETURN \
  {}
#define debug_only(code)
#endif  // ASSERT

#ifdef _LP64
#define LP64_ONLY(code) code
#define NOT_LP64(code)
#else
#define LP64_ONLY(code)
#define NOT_LP64(code) code
#endif  // _LP64

#define NOINLINE __attribute__((noinline))
#define NORETURN __attribute__((noreturn))
#define ALWAYSINLINE inline __attribute__((always_inline))

#define PUA_EXPORT __attribute__((visibility("default")))
#define PUA_EXPORT_FOR_DEVTOOL __attribute__((visibility("default")))
#if defined(__linux__)
#define PUA_HIDE __attribute__((visibility("hidden")))
#elif defined(__APPLE__)
#define PUA_HIDE __attribute__((visibility("default")))
#endif

#define PUA_USED __attribute__((visibility("default"), used))

#ifndef LIKELY
#define LIKELY(exp) (__builtin_expect((exp) != 0, true))
#endif

#ifndef UNLIKELY
#define UNLIKELY(exp) (__builtin_expect((exp) != 0, false))
#endif
#define WARN_UNUSED __attribute__((warn_unused_result))

#define PRIMJS_PACKED(d) d __attribute__((packed))

#define NONCOPYABLE(C)   \
  C(C const &) = delete; \
  C &operator=(C const &) = delete

#ifndef NDEBUG
#define ASSERT 1
#endif

#ifndef ASSERT
#define vmassert(p, ...)
#else
#define vmassert(p, ...)                                       \
  do {                                                         \
    if (!(p)) {                                                \
      base::report_error(__FILE__, __LINE__, "assert failed"); \
    }                                                          \
  } while (0)
#endif

#define unreachable()                                           \
  do {                                                          \
    base::report_error(__FILE__, __LINE__, "unreachable here"); \
  } while (0)

#define UNIMPLEMENTED()                                            \
  do {                                                             \
    base::report_error(__FILE__, __LINE__, "not implemented yet"); \
  } while (0)

#define ShouldNotReachHere unreachable

#define USE(...)                                             \
  do {                                                       \
    base::Use unused_tmp_array_for_use_macro[]{__VA_ARGS__}; \
    (void)unused_tmp_array_for_use_macro;                    \
  } while (false)

#endif  // PRIMJS_VM_MACROS_H
