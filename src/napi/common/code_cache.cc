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

#include <stdio.h>

#include <algorithm>
#include <utility>

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

constexpr double CacheBlob::MAGIC;

bool CacheBlob::insert(const std::string& filename, const uint8_t* data,
                       int length) {
  // too large (more than half of MAX) cached data must be discarded
  if (length == 0 || data == nullptr) {
    INCREASE(expired_query_);
    return false;
  }
  CachedData* target = nullptr;
  const uint8_t* old_data = nullptr;
  {
    std::unique_lock<std::mutex> lock(write_mutex_);
    auto it = cache_map_.find(filename);
    if (it != cache_map_.end()) {
      target = it->second;
      current_size_ -= target->length_;
      remove_from_ranking_list(target);

      if (get_enough_space(length)) {
        if (mode_ == kAppending) mode_ = kWriting;
        target->length_ = length;
      } else {
        cache_map_.erase(it);
        return false;
      }

    } else if (get_enough_space(length)) {
      target = new CachedData(length, nullptr, filename);
      cache_map_[filename] = target;
      if (mode_ == kAppending) {
        if (append_vec_ == nullptr) {
          append_vec_ = new CacheVector();
        }
        append_vec_->push_back(target);
      }
    } else {
      return false;
    }

    old_data = target->data_;
    target->data_ = data;
  }

  heat_ranking_.push_back(target);
  current_size_ += length;
  if (old_data) {
    delete[] old_data;
  }
  INCREASE(target->used_times_);

  return true;
}

// That len will be not nullptr is ensured by the context.
const CachedData* CacheBlob::find(const std::string& filename, int* len) const {
  if (!write_mutex_.try_lock()) {
    INCREASE(missed_query_);
    INCREASE(total_query_);
    return empty_cache_.get();
  }
  auto it = cache_map_.find(filename);
  write_mutex_.unlock();
  CachedData* result = nullptr;
  if (it != cache_map_.end()) {
    // every time a cache is searched, its heat-ranking
    // rises and thus the ranking list changes
    result = it->second;
    *len = result->length_;
    INCREASE(result->used_times_);
  } else {
    *len = 0;
    INCREASE(missed_query_);
  }
  INCREASE(total_query_);

  // NOTE:
  // The result cached data is safe beyond this scope,
  // because JS engines got this data and then use it
  // consecutively in one thread. Tasks that insert new
  // data for the same filename will only be posted after
  // that cached data has been already used up.
  return result;
}

void CacheBlob::remove(const std::string& filename) {
  auto it = cache_map_.find(filename);
  if (it != cache_map_.end()) {
    current_size_ -= it->second->length_;
    delete it->second;
    cache_map_.erase(it);
    if (mode_ == kAppending) mode_ = kWriting;
  }
}

// cache file structure:
// Header:
// | magic number      | --> 8 bytes
// Body  :
// | file name size    | --> 2 bytes
// | file name         | --> x bytes
// | cache data length | --> 4 bytes
// | cache data        | --> y bytes
// ...
void CacheBlob::output() {
  if (mode_ == kAppending && append_vec_ == nullptr) return;
  bool appending = mode_ == kAppending && append_vec_ != nullptr;

  FILE* file_out = appending ? fopen(target_path_.c_str(), "ab")
                             : fopen(target_path_.c_str(), "wb");
  if (file_out) {
    if (appending) {
      for (auto it : *append_vec_) write_cache_unit(file_out, it);
    } else {
      fwrite(&MAGIC, DOUBLE_SIZE, 1, file_out);
      for (auto& it : cache_map_) write_cache_unit(file_out, it.second);
    }
    fclose(file_out);
    VLOGD("codecache: output cache file %s succeed.\n", target_path_.c_str());
  }
}

// steps to rebuild blob:
// 1. read and check magic number;
// 2. read 2 bytes to get the size (x) of file name;
// 3. read x bytes to get the file name;
// 4. read 4 bytes to get the size (y) of cache data;
// 5. read y bytes to get the actual content of cache data;
// 6. go back to step 2 until EOF
bool CacheBlob::input() {
  FILE* file_in = fopen(target_path_.c_str(), "rb");

  bool succeeded = false;
  if (file_in) {
    double maybe_magic;
    fread(reinterpret_cast<char*>(&maybe_magic), DOUBLE_SIZE, 1, file_in);
    // check whether file is valid.
    if (maybe_magic == MAGIC) {
      int c;
      while ((c = fgetc(file_in)) != EOF) {
        ungetc(c, file_in);
        read_cache_unit(file_in);
      }
      mode_ = kAppending;
      succeeded = true;
    }
    fclose(file_in);
  }
  return succeeded;
}

#ifdef PROFILE_CODECACHE
void CacheBlob::dump_status(void* p) {
  std::vector<std::pair<std::string, int> >* status_vec =
      reinterpret_cast<std::vector<std::pair<std::string, int> >*>(p);
  std::sort(heat_ranking_.begin(), heat_ranking_.end(), CachedData::compare);
  status_vec->push_back(std::pair<std::string, int>("Total", total_query_));
  status_vec->push_back(std::pair<std::string, int>("Missed", missed_query_));
  status_vec->push_back(std::pair<std::string, int>("Expired", expired_query_));
  status_vec->push_back(std::pair<std::string, int>(
      "Updated", mode_ == kAppending && append_vec_ == nullptr ? 0 : 1));
  status_vec->push_back(std::pair<std::string, int>("Size", current_size_));
  status_vec->push_back(std::pair<std::string, int>("Heat Ranking, total ",
                                                    heat_ranking_.size()));
  for (size_t i = 0; i < heat_ranking_.size(); ++i) {
    CachedData* dt = heat_ranking_[i];
    status_vec->push_back(
        std::pair<std::string, int>(dt->file_name_, dt->used_times_));
  }
}
#endif  // PROFILE_CODECACHE

void CacheBlob::write_cache_unit(FILE* file_out, const CachedData* unit) {
  // write file name
  uint16_t size = static_cast<uint16_t>(unit->file_name_.size());
  fwrite(static_cast<void*>(&size), SHORT_SIZE, 1, file_out);
  fwrite(unit->file_name_.c_str(), 1, unit->file_name_.size(), file_out);

  uint32_t length = unit->length_;
  fwrite(static_cast<void*>(&length), INT_SIZE, 1, file_out);
  fwrite(unit->data_, 1, unit->length_, file_out);
}

void CacheBlob::read_cache_unit(FILE* file_in) {
  uint16_t filename_length;
  fread(&filename_length, SHORT_SIZE, 1, file_in);
  std::string name(filename_length, '\0');
  fread(&name[0], 1, filename_length, file_in);

  uint32_t data_length;
  fread(&data_length, INT_SIZE, 1, file_in);
  uint8_t* data = new uint8_t[data_length];
  fread(data, 1, data_length, file_in);

  CachedData* cd = new CachedData(static_cast<int>(data_length), data, name);

  current_size_ += data_length;
  heat_ranking_.push_back(cd);
  cache_map_[name] = cd;
}

void CacheBlob::remove_from_ranking_list(CachedData* target) {
  for (size_t i = 0; i < heat_ranking_.size(); ++i) {
    if (target == heat_ranking_[i]) {
      heat_ranking_.erase(heat_ranking_.begin() + i);
      break;
    }
  }
}

// This is a vast-time-costing function
bool CacheBlob::get_enough_space(int data_size) {
  // 0. check whether available space is enough
  if (current_size_ + data_size <= max_capacity_) return true;
  int size_needed = data_size + current_size_ - max_capacity_;
  // 1. sort the heat_ranking_
  std::sort(heat_ranking_.begin(), heat_ranking_.end(), CachedData::compare);
  // 2. pick CachedDatas
  for (int i = heat_ranking_.size() - 1; i >= 0; --i) {
    size_needed -= heat_ranking_[i]->length_;
    if (size_needed <= 0) {
      for (size_t j = i; j < heat_ranking_.size(); ++j) {
        CachedData* it = heat_ranking_[j];
        remove(it->file_name_);
      }
      heat_ranking_.erase(heat_ranking_.begin() + i, heat_ranking_.end());
      return true;
    }
  }
  return false;
}
