// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_ZONE_CONTAINERS_H
#define PRIMJS_ZONE_CONTAINERS_H

#include <stdlib.h>

#include <algorithm>
#include <map>
#include <unordered_map>
#include <vector>

#include "primjs/base/globals.h"
#include "primjs/base/zone.h"

namespace base {

template <typename T>
class ZoneVector : public std::vector<T, ZoneAllocator<T>> {
 public:
  explicit ZoneVector(Zone *zone)
      : std::vector<T, ZoneAllocator<T>>(ZoneAllocator<T>(zone)) {}

  ZoneVector(size_t size, Zone *zone)
      : std::vector<T, ZoneAllocator<T>>(size, T(), ZoneAllocator<T>(zone)) {}

  ZoneVector(size_t size, T value, Zone *zone)
      : std::vector<T, ZoneAllocator<T>>(size, value, ZoneAllocator<T>(zone)) {}
  ~ZoneVector() = default;

  // NONCOPYABLE(ZoneVector);
};

template <typename K, typename V, typename Hash = std::hash<K>,
          typename KeyEqual = std::equal_to<K>>
class ZoneUnorderedMap
    : public std::unordered_map<K, V, Hash, KeyEqual,
                                ZoneAllocator<std::pair<const K, V>>> {
 public:
  explicit ZoneUnorderedMap(Zone *zone, size_t bucket_count = 0)
      : std::unordered_map<K, V, Hash, KeyEqual,
                           ZoneAllocator<std::pair<const K, V>>>(
            bucket_count, Hash(), KeyEqual(),
            ZoneAllocator<std::pair<const K, V>>(zone)) {}

  NONCOPYABLE(ZoneUnorderedMap);
};

template <typename K, typename V, typename CF = std::less<K>>
class ZoneMap
    : public std::map<K, V, CF, ZoneAllocator<std::pair<const K, V>>> {
 public:
  // Constructs an empty map.
  explicit ZoneMap(Zone *zone)
      : std::map<K, V, CF, ZoneAllocator<std::pair<const K, V>>>(
            CF(), ZoneAllocator<std::pair<const K, V>>(zone)) {}
};

}  // namespace base
#endif  // PRIMJS_ZONE_CONTAINERS_H
