// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INSPECTOR_HEAPPROFILER_SERIALIZE_H_
#define SRC_INSPECTOR_HEAPPROFILER_SERIALIZE_H_
#include <time.h>

#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>

#include "inspector/heapprofiler/snapshot.h"

namespace quickjs {
namespace heapprofiler {

// outputstream
class OutputStream {
 public:
  virtual ~OutputStream() = default;
  virtual uint32_t GetChunkSize() { return 1024; }  // default value
  virtual void WriteChunk(const std::string& chunk) = 0;
};

// write to devtool helper
class OutputStreamWriter {
 public:
  explicit OutputStreamWriter(OutputStream* stream)
      : front_stream_(stream), chunk_size(stream->GetChunkSize()) {}

  ~OutputStreamWriter() {}

  void AddString(const char* input) {
    ss_ << input;
    WriteChunkToOutStream();
  }

  void AddString(const std::string& input) {
    ss_ << input;
    WriteChunkToOutStream();
  }

  template <typename T>
  void AddString(T input) {
    ss_ << input;
  }

  void Finalize() {
    front_stream_->WriteChunk(ss_.str());
    Clear();
  }

  void Clear() {
    ss_.clear();
    ss_.str("");
  }

 private:
  void WriteChunkToOutStream() {
    if (ss_.str().length() >= chunk_size) {
      front_stream_->WriteChunk(ss_.str());
      Clear();
    }
  }
  std::stringstream ss_;
  OutputStream* front_stream_;
  uint32_t chunk_size = 0;
};

class HeapSnapshotJSONSerializer {
 public:
  explicit HeapSnapshotJSONSerializer(HeapSnapshot* snapshot)
      : writer_(nullptr), snapshot_(snapshot), next_string_id_(1) {}

  HeapSnapshotJSONSerializer(const HeapSnapshotJSONSerializer&) = delete;

  HeapSnapshotJSONSerializer& operator=(const HeapSnapshotJSONSerializer&) =
      delete;

  // dump heapsnapshot to outputstreamwriter
  void Serialize(OutputStream*);
  using Strings = std::unordered_map<std::string, uint32_t>;

 private:
  uint32_t GetStringId(const std::string& str);
  force_inline uint32_t to_node_index(uint32_t entry_index);
  force_inline uint32_t to_node_index(const HeapEntry& entry);
  force_inline uint32_t to_node_index(const HeapEntry* entry);

  void SerializeImpl();
  void SerializeSnapshot();

  void SerializeNodes();
  void SerializeNode(const HeapEntry& entry);

  void SerializeEdges();
  void SerializeEdge(const HeapGraphEdge& edge, bool first_edge);

  void SerializeString(const std::string&) const;
  void SerializeStrings() const;

  static constexpr uint32_t kNodeFieldsCount = 6;
  static constexpr uint32_t kEdgeFiledsCount = 3;
  OutputStreamWriter* writer_;
  HeapSnapshot* snapshot_;
  Strings strings_map_;
  uint32_t next_string_id_;
};

// dump str to file ,filename is time + file_suffix
void js_heap_dump_file(const std::string& str, const std::string& file_suffix);
}  // namespace heapprofiler
}  // namespace quickjs
#endif  // SRC_INSPECTOR_HEAPPROFILER_SERIALIZE_H_
