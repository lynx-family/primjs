// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_ONE_OF_
#define SRC_WASM_COMMON_ONE_OF_

#include <algorithm>
#include <cstdint>
#include <type_traits>

#include "wasm_utils.h"

namespace primjs {
template <typename T>
struct Decay_ {
  using Type = T;
};
template <typename T>
struct Decay_<T &> {
  using Type = typename Decay_<T>::Type;
};
template <typename T>
struct Decay_<T &&> {
  using Type = typename Decay_<T>::Type;
};
template <typename T>
struct Decay_<T[]> {
  using Type = typename Decay_<T *>::Type;
};
template <typename T>
struct Decay_<const T[]> {
  using Type = typename Decay_<const T *>::Type;
};
template <typename T, size_t s>
struct Decay_<T[s]> {
  using Type = typename Decay_<T *>::Type;
};
template <typename T, size_t s>
struct Decay_<const T[s]> {
  using Type = typename Decay_<const T *>::Type;
};
template <typename T>
struct Decay_<const T> {
  using Type = typename Decay_<T>::Type;
};
template <typename T>
struct Decay_<volatile T> {
  using Type = typename Decay_<T>::Type;
};
template <typename T>
using Decay = typename Decay_<T>::Type;

namespace _ {
struct PlacementNew {};
}  // namespace _
}  // namespace primjs

inline void *operator new(size_t, primjs::_::PlacementNew, void *_p) noexcept {
  return _p;
}

inline void operator delete(void *, primjs::_::PlacementNew,
                            void *_p) noexcept {}

namespace primjs {
// use placement new with stack allocated memory, so we do not need to malloc
// and free, thus we override new and delete operator
template <typename T, typename... Params>
inline void ctor(T &location, Params &&...params) {
  new (_::PlacementNew(), &location) T(std::forward<Params>(params)...);
}

template <typename T>
inline void dtor(T &location) {
  location.~T();
}

namespace _ {
template <uint32_t i, template <uint32_t> class Fail, typename Key,
          typename... Variants>
struct TypeIndex_;
template <uint32_t i, template <uint32_t> class Fail, typename Key,
          typename First, typename... Rest>
struct TypeIndex_<i, Fail, Key, First, Rest...> {
  static constexpr uint32_t value =
      TypeIndex_<i + 1, Fail, Key, Rest...>::value;
};
template <uint32_t i, template <uint32_t> class Fail, typename Key,
          typename... Rest>
struct TypeIndex_<i, Fail, Key, Key, Rest...> {
  static constexpr uint32_t value = i;
};
template <uint32_t i, template <uint32_t> class Fail, typename Key>
struct TypeIndex_<i, Fail, Key> : public Fail<i> {};

template <uint32_t i>
struct OneOfFailError_ {
  static_assert(i == -1, "type does not match any in OneOf");
};
template <uint32_t i>
struct OneOfFailZero_ {
  static constexpr int value = 0;
};

template <uint32_t i>
struct SuccessIfNotZero {
  typedef int Success;
};
template <>
struct SuccessIfNotZero<0> {};

enum class Variants0 {};
enum class Variants1 { _variant0 };
enum class Variants2 { _variant0, _variant1 };

template <uint32_t i>
struct Variants_;
template <>
struct Variants_<0> {
  typedef Variants0 Type;
};
template <>
struct Variants_<1> {
  typedef Variants1 Type;
};
template <>
struct Variants_<2> {
  typedef Variants2 Type;
};

template <uint32_t i>
using Variants = typename Variants_<i>::Type;
}  // namespace _

template <typename... Variants>
class OneOf {
  // Get the 1-based index of Key within the type list Types, or static_assert
  // with a nice error.
  template <typename Key>
  static inline constexpr uint32_t typeIndex() {
    return _::TypeIndex_<1, _::OneOfFailError_, Key, Variants...>::value;
  }

  template <typename Key>
  static inline constexpr uint32_t typeIndexOrZero() {
    return _::TypeIndex_<1, _::OneOfFailZero_, Key, Variants...>::value;
  }
  template <uint32_t i, typename... OtherVariants>
  struct HasAll;
  // Has a member type called "Success" if and only if all of `OtherVariants`
  // are types that appear in `Variants`. Used with SFINAE to enable subset
  // constructors.

 public:
  inline OneOf() : tag_(0) {}

  OneOf(const OneOf &other) { copyFrom(other); }
  OneOf(OneOf &other) { copyFrom(other); }
  OneOf(OneOf &&other) { moveFrom(other); }

  // Copy/move from a value that matches one of the individual types in the
  // OneOf.
  template <typename T, typename = typename HasAll<0, Decay<T>>::Success>
  OneOf(T &&other) : tag_(typeIndex<Decay<T>>()) {
    ctor(*reinterpret_cast<Decay<T> *>(space), std::forward<T>(other));
  }

  ~OneOf() { destroy(); }

  OneOf &operator=(const OneOf &other) {
    if (tag_ != 0) destroy();
    copyFrom(other);
    return *this;
  }
  OneOf &operator=(OneOf &&other) noexcept {
    if (tag_ != 0) destroy();
    moveFrom(other);
    return *this;
  }

  inline bool operator==(decltype(nullptr)) const { return tag_ == 0; }

  template <typename T>
  [[nodiscard]] bool is() const {
    return tag_ == typeIndex<T>();
  }

  template <typename T>
  T &get() & {
    WASM_DCHECK(is<T>() && "Must check OneOf::is<T>() before calling get<T>()");
    return *reinterpret_cast<T *>(space);
  }
  template <typename T>
  T &&get() && {
    WASM_DCHECK(is<T>() && "Must check OneOf::is<T>() before calling get<T>()");
    return std::move(*reinterpret_cast<T *>(space));
  }
  template <typename T>
  const T &get() const & {
    WASM_DCHECK(is<T>() && "Must check OneOf::is<T>() before calling get<T>()");
    return *reinterpret_cast<const T *>(space);
  }
  template <typename T>
  const T &&get() const && {
    WASM_DCHECK(is<T>() && "Must check OneOf::is<T>() before calling get<T>()");
    return std::move(*reinterpret_cast<const T *>(space));
  }

  template <typename T, typename... Params>
  T &init(Params &&...params) {
    if (tag_ != 0) destroy();
    ctor(*reinterpret_cast<T *>(space), std::forward<Params>(params)...);
    tag_ = typeIndex<T>();
    return *reinterpret_cast<T *>(space);
  }

 private:
  uint32_t tag_;

  static inline constexpr size_t maxSize(size_t a) { return a; }
  template <typename... Rest>
  static inline constexpr size_t maxSize(size_t a, size_t b, Rest... rest) {
    return maxSize(std::max(a, b), rest...);
  }
  static constexpr auto spaceSize = maxSize(sizeof(Variants)...);

  alignas(Variants...) unsigned char space[spaceSize];

  template <typename... T>
  inline void doAll(T... t) {}

  template <typename T>
  inline bool destroyVariant() {
    if (tag_ == typeIndex<T>()) {
      tag_ = 0;
      dtor(*reinterpret_cast<T *>(space));
    }
    return false;
  }
  void destroy() { doAll(destroyVariant<Variants>()...); }

  template <typename T>
  inline bool copyVariantFrom(const OneOf &other) {
    if (other.is<T>()) {
      ctor(*reinterpret_cast<T *>(space), other.get<T>());
    }
    return false;
  }
  void copyFrom(const OneOf &other) {
    // Initialize as a copy of `other`.  Expects that `this` starts out
    // uninitialized, so the tag is invalid.
    tag_ = other.tag_;
    doAll(copyVariantFrom<Variants>(other)...);
  }

  template <typename T>
  inline bool copyVariantFrom(OneOf &other) {
    if (other.is<T>()) {
      ctor(*reinterpret_cast<T *>(space), other.get<T>());
    }
    return false;
  }
  void copyFrom(OneOf &other) {
    // Initialize as a copy of `other`.  Expects that `this` starts out
    // uninitialized, so the tag is invalid.
    tag_ = other.tag_;
    doAll(copyVariantFrom<Variants>(other)...);
  }

  template <typename T>
  inline bool moveVariantFrom(OneOf &other) {
    if (other.is<T>()) {
      ctor(*reinterpret_cast<T *>(space), std::move(other.get<T>()));
    }
    return false;
  }
  void moveFrom(OneOf &other) {
    // Initialize as a copy of `other`.  Expects that `this` starts out
    // uninitialized, so the tag is invalid.
    tag_ = other.tag_;
    doAll(moveVariantFrom<Variants>(other)...);
  }
};

template <typename... Variants>
template <uint32_t i, typename First, typename... Rest>
struct OneOf<Variants...>::HasAll<i, First, Rest...>
    : public HasAll<typeIndexOrZero<First>(), Rest...> {};

template <typename... Variants>
template <uint32_t i>
struct OneOf<Variants...>::HasAll<i> : public _::SuccessIfNotZero<i> {};
}  // namespace primjs

#endif  // SRC_WASM_COMMON_ONE_OF_
