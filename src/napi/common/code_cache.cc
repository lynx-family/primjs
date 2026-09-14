/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "code_cache.h"

#include <algorithm>
#include <atomic>
#include <cstring>

#if defined(_WIN32)
#include <process.h>
#include <windows.h>
#else
#include <unistd.h>
#endif

#if OS_ANDROID
#include "basic/log/logging.h"
#else
#define VLOGD(...) void((__VA_ARGS__))
#endif  // OS_ANDROID

#ifdef PROFILE_CODECACHE
#define INCREASE(target) ++(target)
#else
#define INCREASE(target)
#endif  // PROFILE_CODECACHE

namespace {

// Cache file layout (integers in host order):
//
//   Header: | magic u32 | format version u32 |
//   Entry:  | name length u16 | name | source hash u64 |
//           | data length u32 | data | data checksum u64 |
//   ... entries until EOF
//
// Any error invalidates the whole file: the engines' bytecode loaders are not
// hardened against garbage.
constexpr uint32_t kMagic = 0x43434A50;  // "PJCC"
constexpr uint32_t kFormatVersion = 2;

uint64_t Fnv1a64(const void* bytes, size_t length) {
  const auto* p = static_cast<const uint8_t*>(bytes);
  uint64_t hash = 14695981039346656037ULL;
  for (size_t i = 0; i < length; ++i) {
    hash ^= p[i];
    hash *= 1099511628211ULL;
  }
  return hash;
}

template <typename T>
bool ReadValue(FILE* file, T* value) {
  return fread(value, sizeof(T), 1, file) == 1;
}

template <typename T>
void AppendValue(std::string* image, const T& value) {
  image->append(reinterpret_cast<const char*>(&value), sizeof(T));
}

// Per-process, per-call scratch names: several processes may publish the same
// cache file.
std::string NewTempPath(const std::string& path) {
  static std::atomic<unsigned> counter{0};
#if defined(_WIN32)
  const int pid = _getpid();
#else
  const int pid = static_cast<int>(getpid());
#endif
  return path + ".tmp." + std::to_string(pid) + "." +
         std::to_string(counter.fetch_add(1));
}

bool ReplaceFile(const std::string& from, const std::string& to) {
#if defined(_WIN32)
  return MoveFileExA(from.c_str(), to.c_str(), MOVEFILE_REPLACE_EXISTING) != 0;
#else
  return rename(from.c_str(), to.c_str()) == 0;
#endif
}

// A crash mid-write must never leave a torn cache behind.
bool WriteFileAtomically(const std::string& path, const std::string& image) {
  const std::string tmp_path = NewTempPath(path);
  FILE* file = fopen(tmp_path.c_str(), "wb");
  if (file == nullptr) return false;
  bool written = fwrite(image.data(), 1, image.size(), file) == image.size();
  written = (fclose(file) == 0) && written;
  if (!written || !ReplaceFile(tmp_path, path)) {
    ::remove(tmp_path.c_str());
    return false;
  }
  return true;
}

}  // namespace

uint64_t CacheBlob::HashSource(const char* script, size_t length) {
  return Fnv1a64(script, length);
}

std::shared_ptr<CacheBlob> CacheBlob::Open(const std::string& path,
                                           int max_capacity) {
  // Never destroyed: blobs may still be released while static objects are
  // torn down at process exit.
  static auto* registry_mutex = new std::mutex();
  static auto* registry =
      new std::unordered_map<std::string, std::weak_ptr<CacheBlob>>();

  std::lock_guard<std::mutex> lock(*registry_mutex);
  std::weak_ptr<CacheBlob>& slot = (*registry)[path];
  std::shared_ptr<CacheBlob> blob = slot.lock();
  if (!blob) {
    blob = std::make_shared<CacheBlob>(path, max_capacity);
    slot = blob;
  }
  return blob;
}

CacheBlob::CacheBlob(const std::string& path, int max_capacity)
    : path_(path), max_capacity_(max_capacity) {}

bool CacheBlob::insert(const std::string& filename, uint64_t source_hash,
                       const uint8_t* data, int length) {
  if (data == nullptr || length <= 0) return false;

  std::lock_guard<std::mutex> lock(mutex_);
  auto it = entries_.find(filename);
  if (it != entries_.end()) {
    current_size_ -= static_cast<int>(it->second.data.size());
    entries_.erase(it);
    dirty_ = true;
  }
  if (!make_room(length)) return false;

  entries_[filename] =
      Entry{source_hash, std::vector<uint8_t>(data, data + length), 1};
  current_size_ += length;
  dirty_ = true;
  return true;
}

bool CacheBlob::find(const std::string& filename, uint64_t source_hash,
                     std::vector<uint8_t>* out) {
  out->clear();
  std::lock_guard<std::mutex> lock(mutex_);
  INCREASE(total_query_);
  auto it = entries_.find(filename);
  if (it == entries_.end()) {
    INCREASE(missed_query_);
    return false;
  }
  if (it->second.source_hash != source_hash) {
    INCREASE(expired_query_);
    return false;
  }
  ++it->second.used_times;
  out->assign(it->second.data.begin(), it->second.data.end());
  return true;
}

void CacheBlob::remove(const std::string& filename) {
  std::lock_guard<std::mutex> lock(mutex_);
  auto it = entries_.find(filename);
  if (it == entries_.end()) return;
  current_size_ -= static_cast<int>(it->second.data.size());
  entries_.erase(it);
  dirty_ = true;
}

bool CacheBlob::input() {
  std::lock_guard<std::mutex> lock(mutex_);
  if (loaded_) return load_result_;
  loaded_ = true;

  FILE* file = fopen(path_.c_str(), "rb");
  if (file == nullptr) return false;

  EntryMap loaded;
  int loaded_size = 0;
  bool valid = read_entries(file, &loaded, &loaded_size);
  fclose(file);
  if (!valid) {
    VLOGD("codecache: cache file %s is invalid and will be rewritten.\n",
          path_.c_str());
    dirty_ = true;
    return false;
  }

  // Entries inserted before the file was read are newer than the file.
  for (auto& it : entries_) {
    auto stale = loaded.find(it.first);
    if (stale != loaded.end()) {
      loaded_size -= static_cast<int>(stale->second.data.size());
      loaded.erase(stale);
    }
    loaded_size += static_cast<int>(it.second.data.size());
    loaded[it.first] = std::move(it.second);
  }
  entries_ = std::move(loaded);
  current_size_ = loaded_size;
  load_result_ = true;
  return true;
}

bool CacheBlob::output() {
  // Publishes are serialized so an older snapshot never overwrites a newer
  // one, while find() and insert() keep running during the disk write.
  std::lock_guard<std::mutex> publish_lock(publish_mutex_);
  std::string image;
  {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!dirty_) return true;
    image = serialize();
    dirty_ = false;
  }

  if (WriteFileAtomically(path_, image)) {
    VLOGD("codecache: output cache file %s succeed.\n", path_.c_str());
    return true;
  }
  std::lock_guard<std::mutex> lock(mutex_);
  dirty_ = true;
  VLOGD("codecache: output cache file %s failed.\n", path_.c_str());
  return false;
}

int CacheBlob::size() const {
  std::lock_guard<std::mutex> lock(mutex_);
  return current_size_;
}

bool CacheBlob::make_room(int length) {
  if (length > max_capacity_) return false;
  while (current_size_ + length > max_capacity_) {
    if (entries_.empty()) {
      current_size_ = 0;
      break;
    }
    // Evict the least used entry; among equals the largest one frees the most.
    auto victim = entries_.begin();
    for (auto it = entries_.begin(); it != entries_.end(); ++it) {
      if (it->second.used_times < victim->second.used_times ||
          (it->second.used_times == victim->second.used_times &&
           it->second.data.size() > victim->second.data.size())) {
        victim = it;
      }
    }
    current_size_ -= static_cast<int>(victim->second.data.size());
    entries_.erase(victim);
    dirty_ = true;
  }
  return true;
}

bool CacheBlob::read_entries(FILE* file, EntryMap* entries, int* total_size) {
  uint32_t magic = 0;
  uint32_t version = 0;
  if (!ReadValue(file, &magic) || !ReadValue(file, &version) ||
      magic != kMagic || version != kFormatVersion) {
    return false;
  }

  while (true) {
    int next = fgetc(file);
    if (next == EOF) return true;
    ungetc(next, file);

    uint16_t name_length = 0;
    if (!ReadValue(file, &name_length) || name_length == 0) return false;
    std::string name(name_length, '\0');
    if (fread(&name[0], 1, name_length, file) != name_length ||
        entries->count(name) != 0) {
      return false;
    }

    uint64_t source_hash = 0;
    uint32_t data_length = 0;
    if (!ReadValue(file, &source_hash) || !ReadValue(file, &data_length) ||
        data_length == 0 ||
        data_length > static_cast<uint32_t>(max_capacity_)) {
      return false;
    }
    std::vector<uint8_t> data(data_length);
    uint64_t checksum = 0;
    if (fread(data.data(), 1, data_length, file) != data_length ||
        !ReadValue(file, &checksum) ||
        checksum != Fnv1a64(data.data(), data.size())) {
      return false;
    }

    // Dropped entries are compacted away by the next output().
    if (*total_size + static_cast<int>(data_length) > max_capacity_) {
      dirty_ = true;
      continue;
    }
    *total_size += static_cast<int>(data_length);
    (*entries)[name] = Entry{source_hash, std::move(data), 0};
  }
}

std::string CacheBlob::serialize() const {
  std::string image;
  AppendValue(&image, kMagic);
  AppendValue(&image, kFormatVersion);
  for (const auto& it : entries_) {
    const std::string& name = it.first;
    const Entry& entry = it.second;
    if (name.empty() || name.size() > UINT16_MAX) continue;
    AppendValue(&image, static_cast<uint16_t>(name.size()));
    image.append(name);
    AppendValue(&image, entry.source_hash);
    AppendValue(&image, static_cast<uint32_t>(entry.data.size()));
    image.append(reinterpret_cast<const char*>(entry.data.data()),
                 entry.data.size());
    AppendValue(&image, Fnv1a64(entry.data.data(), entry.data.size()));
  }
  return image;
}

#ifdef PROFILE_CODECACHE
void CacheBlob::dump_status(std::vector<std::pair<std::string, int>>* status) {
  std::lock_guard<std::mutex> lock(mutex_);
  status->emplace_back("Total", total_query_);
  status->emplace_back("Missed", missed_query_);
  status->emplace_back("Expired", expired_query_);
  status->emplace_back("Updated", dirty_ ? 1 : 0);
  status->emplace_back("Size", current_size_);
  status->emplace_back("Heat Ranking, total ",
                       static_cast<int>(entries_.size()));

  std::vector<std::pair<std::string, int>> ranking;
  for (const auto& it : entries_) {
    ranking.emplace_back(it.first, it.second.used_times);
  }
  std::sort(ranking.begin(), ranking.end(),
            [](const std::pair<std::string, int>& left,
               const std::pair<std::string, int>& right) {
              return left.second > right.second;
            });
  status->insert(status->end(), ranking.begin(), ranking.end());
}
#endif  // PROFILE_CODECACHE
