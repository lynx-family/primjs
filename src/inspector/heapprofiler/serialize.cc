// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "inspector/heapprofiler/serialize.h"

#include <algorithm>
#include <cstring>
#include <string>
#include <vector>

#include "inspector/heapprofiler/entry.h"

namespace quickjs {

namespace heapprofiler {
OutputStreamWriter::OutputStreamWriter(OutputStream* stream)
    : front_stream_(stream), chunk_size_(stream->GetChunkSize()) {}

// Keep buffer growth and flushing shared by all serialization call sites.
no_inline void OutputStreamWriter::AddBytes(const char* input, size_t size) {
  buffer_.append(input, size);
  if (buffer_.size() >= chunk_size_) Finalize();
}

void OutputStreamWriter::AddString(const char* input) {
  AddBytes(input, std::strlen(input));
}

void OutputStreamWriter::AddString(const std::string& input) {
  AddBytes(input.data(), input.size());
}

void OutputStreamWriter::AddString(char input) { AddBytes(&input, 1); }

no_inline void OutputStreamWriter::AddNumber(uint64_t input) {
  char digits[20];  // UINT64_MAX has 20 decimal digits.
  char* const end = digits + sizeof(digits);
  char* current = end;
  do {
    *--current = static_cast<char>('0' + input % 10);
    input /= 10;
  } while (input);
  AddBytes(current, static_cast<size_t>(end - current));
}

no_inline void OutputStreamWriter::Finalize() {
  front_stream_->WriteChunk(buffer_);
  buffer_.clear();
}

uint32_t HeapSnapshotJSONSerializer::to_node_index(uint32_t entry_index) {
  return entry_index * kNodeFieldsCount;
}

uint32_t HeapSnapshotJSONSerializer::to_node_index(const HeapEntry& entry) {
  return to_node_index(entry.index());
}

uint32_t HeapSnapshotJSONSerializer::to_node_index(const HeapEntry* entry) {
  return to_node_index(entry->index());
}

void HeapSnapshotJSONSerializer::Serialize(OutputStream* stream) {
  writer_ = new OutputStreamWriter(stream);
  SerializeImpl();
  delete writer_;
  writer_ = nullptr;
}

void HeapSnapshotJSONSerializer::SerializeImpl() {
  writer_->AddString('{');
  writer_->AddString("\"snapshot\":{");
  SerializeSnapshot();
  writer_->AddString("},\n");
  writer_->AddString("\"nodes\":[");
  SerializeNodes();
  writer_->AddString("],\n");
  writer_->AddString("\"edges\":[");
  SerializeEdges();
  writer_->AddString("],\n");
  writer_->AddString("\"trace_function_infos\":[");
  writer_->AddString("],\n");
  writer_->AddString("\"trace_tree\":[");
  writer_->AddString("],\n");
  writer_->AddString("\"samples\":[");
  writer_->AddString("],\n");
  writer_->AddString("\"locations\":[");
  writer_->AddString("],\n");

  writer_->AddString("\"strings\":[");
  SerializeStrings();
  writer_->AddString(']');
  writer_->AddString('}');
  writer_->Finalize();
}

uint32_t HeapSnapshotJSONSerializer::GetStringId(const std::string& str) {
  auto itr = strings_map_.find(str);
  if (itr == strings_map_.end()) {
    strings_map_[str] = next_string_id_++;
    return next_string_id_ - 1;
  } else {
    return itr->second;
  }
}

void HeapSnapshotJSONSerializer::SerializeEdges() {
  auto& edges = snapshot_->childrens();
  for (size_t i = 0; i < edges.size(); i++) {
    SerializeEdge(*edges[i], i == 0);
  }
}

void HeapSnapshotJSONSerializer::SerializeEdge(const HeapGraphEdge& edge,
                                               bool first_edge) {
  int32_t edge_name_or_index =
      edge.IsIndex() ? edge.index() : GetStringId(edge.name());
  std::string buffer;
  if (!first_edge) {
    buffer += ',';
  }
  buffer += std::to_string(edge.type());
  buffer += ',';
  buffer += std::to_string(edge_name_or_index);
  buffer += ',';
  buffer += std::to_string(to_node_index(edge.to()));
  buffer += "\n\0";
  writer_->AddString(buffer.c_str());
}

void HeapSnapshotJSONSerializer::SerializeNodes() {
  for (const auto& entry : snapshot_->entries()) {
    SerializeNode(entry);
  }
}

void HeapSnapshotJSONSerializer::SerializeNode(const HeapEntry& entry) {
  std::string buffer;
  if (to_node_index(entry) != 0) {
    buffer += ',';
  }
  buffer += std::to_string(entry.type());
  buffer += ",";
  buffer += std::to_string(GetStringId(entry.name()));
  buffer += ",";
  buffer += std::to_string(entry.id());
  buffer += ",";
  buffer += std::to_string(entry.self_size());
  buffer += ",";
  buffer += std::to_string(entry.children_count());
  buffer += ",";
  buffer += std::to_string(0);  // trace node id
  buffer += "\n\0";
  writer_->AddString(buffer);
}

void HeapSnapshotJSONSerializer::SerializeSnapshot() {
  writer_->AddString("\"meta\":");
  // The object describing node serialization layout.
  // We use a set of macros to improve readability.

  // clang-format off
#define JSON_A(s) "[" s "]"
#define JSON_O(s) "{" s "}"
#define JSON_S(s) "\"" s "\""
  writer_->AddString(JSON_O(
    JSON_S("node_fields") ":" JSON_A(
        JSON_S("type") ","
        JSON_S("name") ","
        JSON_S("id") ","
        JSON_S("self_size") ","
        JSON_S("edge_count") ","
        JSON_S("trace_node_id")) ","
    JSON_S("node_types") ":" JSON_A(
        JSON_A(
            JSON_S("hidden") ","
            JSON_S("array") ","
            JSON_S("string") ","
            JSON_S("object") ","
            JSON_S("code") ","
            JSON_S("closure") ","
            JSON_S("regexp") ","
            JSON_S("number") ","
            JSON_S("native") ","
            JSON_S("synthetic") ","
            JSON_S("concatenated string") ","
            JSON_S("sliced string") ","
            JSON_S("symbol") ","
            JSON_S("bigint") ","
            JSON_S("object shape")) ","
        JSON_S("string") ","
        JSON_S("number") ","
        JSON_S("number") ","
        JSON_S("number") ","
        JSON_S("number")) ","
    JSON_S("edge_fields") ":" JSON_A(
        JSON_S("type") ","
        JSON_S("name_or_index") ","
        JSON_S("to_node")) ","
    JSON_S("edge_types") ":" JSON_A(
        JSON_A(
            JSON_S("context") ","
            JSON_S("element") ","
            JSON_S("property") ","
            JSON_S("internal") ","
            JSON_S("hidden") ","
            JSON_S("shortcut") ","
            JSON_S("weak")) ","
        JSON_S("string_or_number") ","
        JSON_S("node")) ","
    JSON_S("trace_function_info_fields") ":" JSON_A(
        JSON_S("function_id") ","
        JSON_S("name") ","
        JSON_S("script_name") ","
        JSON_S("script_id") ","
        JSON_S("line") ","
        JSON_S("column")) ","
    JSON_S("trace_node_fields") ":" JSON_A(
        JSON_S("id") ","
        JSON_S("function_info_index") ","
        JSON_S("count") ","
        JSON_S("size") ","
        JSON_S("children")) ","
    JSON_S("sample_fields") ":" JSON_A(
        JSON_S("timestamp_us") ","
        JSON_S("last_assigned_id")) ","
    JSON_S("location_fields") ":" JSON_A(
        JSON_S("object_index") ","
        JSON_S("script_id") ","
        JSON_S("line") ","
        JSON_S("column"))));
// clang-format on
#undef JSON_S
#undef JSON_O
#undef JSON_A
  writer_->AddString(",\"node_count\":");
  writer_->AddNumber(snapshot_->entries().size());
  writer_->AddString(",\"edge_count\":");
  writer_->AddNumber(snapshot_->edges().size());
  writer_->AddString(",\"trace_function_count\":");
  writer_->AddNumber(0);
}

void HeapSnapshotJSONSerializer::SerializeStrings() const {
  std::vector<Strings::const_iterator> sorted_strings(strings_map_.size() + 1);
  for (auto itr = strings_map_.begin(); itr != strings_map_.end(); ++itr) {
    uint32_t index = itr->second;
    sorted_strings[index] = itr;
  }
  writer_->AddString("\"<dummy>\"");
  for (uint32_t i = 1; i < sorted_strings.size(); ++i) {
    writer_->AddString(',');
    SerializeString(sorted_strings[i]->first);
  }
}

static void WriteUchar(OutputStreamWriter* w, uint32_t u) {
  static const char hex_chars[] = "0123456789ABCDEF";
  w->AddString("\\u");
  w->AddString(hex_chars[(u >> 12) & 0xF]);
  w->AddString(hex_chars[(u >> 8) & 0xF]);
  w->AddString(hex_chars[(u >> 4) & 0xF]);
  w->AddString(hex_chars[u & 0xF]);
}

void HeapSnapshotJSONSerializer::SerializeString(const std::string& s) const {
  writer_->AddString('\n');
  writer_->AddString('\"');
  const char* utf8_str = s.c_str();
  const char* end = utf8_str + s.size();
  for (; utf8_str < end; ++utf8_str) {
    switch (*utf8_str) {
      case '\b': {
        writer_->AddString("\\b");
      } break;
      case '\f': {
        writer_->AddString("\\f");
      } break;
      case '\n': {
        writer_->AddString("\\n");
      } break;
      case '\r': {
        writer_->AddString("\\r");
      } break;
      case '\t': {
        writer_->AddString("\\t");
      } break;
      case '\"':
      case '\\': {
        writer_->AddString("\\");
        writer_->AddString(*utf8_str);
      } break;
      default: {
        const unsigned char uc = *utf8_str;
        if (31 < uc && uc < 128) {
          writer_->AddString(uc);
        } else if (uc <= 31) {
          WriteUchar(writer_, uc);
        } else {
          const uint8_t* next = nullptr;
          int current_char =
              unicode_from_utf8(reinterpret_cast<const uint8_t*>(utf8_str),
                                static_cast<int>(std::min<size_t>(
                                    end - utf8_str, UTF8_CHAR_LEN_MAX)),
                                &next);
          if (current_char < 0 || current_char > 0x10ffff) {
            WriteUchar(writer_, 0xfffd);
            break;
          }
          utf8_str = reinterpret_cast<const char*>(next) - 1;
          if (current_char > 0xffff) {
            uint32_t supplementary = current_char - 0x10000;
            WriteUchar(writer_, 0xd800 + (supplementary >> 10));
            WriteUchar(writer_, 0xdc00 + (supplementary & 0x3ff));
          } else {
            WriteUchar(writer_, current_char);
          }
        }
      } break;
    }
  }
  writer_->AddString('\"');
}

void js_heap_dump_file(const std::string& str, const std::string& file_suffix) {
#if defined(OS_ANDROID) || defined(OS_IOS)
  time_t nowtime = time(nullptr);
  tm t;
  localtime_r(&nowtime, &t);
  char filename[128] = {'\0'};
  std::string filename_str;
  std::ofstream out_file;
#ifdef OS_IOS
  char ios_homename[256] = {'\0'};
  strcpy(ios_homename, getenv("HOME"));
  strftime(filename, sizeof(filename), "/Documents/Heap-%Y%m%dT%H%M%S.", &t);
  strcat(ios_homename, filename);
  filename_str = ios_homename;
#elif defined(OS_ANDROID)
  strftime(filename, sizeof(filename), "/sdcard/Download/Heap-%Y%m%dT%H%M%S.",
           &t);
  filename_str = filename;
#else
  strftime(filename, sizeof(filename), "./Heap-%Y%m%dT%H%M%S.", &t);
  filename_str = filename;
#endif
  filename_str += file_suffix;
  out_file.open(filename_str, std::ios::out);
  out_file << str;
  out_file.close();
#endif
}

}  // namespace heapprofiler
}  // namespace quickjs
