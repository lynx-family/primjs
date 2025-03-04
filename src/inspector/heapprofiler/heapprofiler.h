
// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INSPECTOR_HEAPPROFILER_HEAPPROFILER_H_
#define SRC_INSPECTOR_HEAPPROFILER_HEAPPROFILER_H_

#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

#include "inspector/debugger/debugger.h"
#include "inspector/heapprofiler/gen.h"
#include "inspector/heapprofiler/serialize.h"
#include "quickjs/include/quickjs-inner.h"

namespace quickjs {
namespace heapprofiler {

class HeapSnapshot;
class HeapObjectIdMaps;

class HeapProfiler {
 public:
  HeapProfiler();
  ~HeapProfiler() = default;
  HeapProfiler(const HeapProfiler&) = delete;
  HeapProfiler& operator=(const HeapProfiler&) = delete;

  HeapSnapshot* TakeSnapshot(LEPUSContext* ctx,
                             ProgressReportInterface* reporter);

  std::size_t GetSnapshotCount() const { return snapshots_.size(); }
  HeapSnapshot* GetSnapshot(uint32_t idx) const {
    return snapshots_[idx].get();
  }

  void DeleteAllSnapShots();
  void RemoveSnapshot(HeapSnapshot*);

  bool IsTakingSnapshot() const { return is_takingsnapshot; }
  LEPUSContext* context() const { return context_; }
  HeapObjectIdMaps* object_id_maps() const { return objectids_.get(); }

  std::ostream& DumpObjectIdMaps(std::ostream& output);

 private:
  LEPUSContext* context_ = nullptr;
  std::vector<std::unique_ptr<HeapSnapshot>> snapshots_;
  std::unique_ptr<HeapObjectIdMaps> objectids_;
  bool is_takingsnapshot = false;
};

class Fronted {
 public:
  virtual void AddHeapSnapshotChunk(const std::string& chunk) = 0;
  virtual void ReportHeapSnapshotProgress(uint32_t done, uint32_t total,
                                          bool finished) = 0;

  // send reponse
  virtual void SendReponse(LEPUSValue message) = 0;
};

// Fronted interface
class DevtoolFronted : public quickjs::heapprofiler::Fronted {
 public:
  explicit DevtoolFronted(LEPUSContext* ctx) : context_(ctx) {}
  virtual ~DevtoolFronted() = default;

  // send notification
  void AddHeapSnapshotChunk(const std::string& chunk) override;
  void ReportHeapSnapshotProgress(uint32_t done, uint32_t total,
                                  bool finished) override;

  // send reponse

  void SendReponse(LEPUSValue message) override;

 private:
  LEPUSContext* context_;
};

class HeapSnapshotOutputStream : public quickjs::heapprofiler::OutputStream {
 public:
  explicit HeapSnapshotOutputStream(const std::shared_ptr<Fronted>& fronted)
      : mfronted_(fronted) {}

  uint32_t GetChunkSize() override {
    return 10240;  // 10K
  }

  void WriteChunk(const std::string& output) override {
    mfronted_->AddHeapSnapshotChunk(output);
  }

 private:
  std::shared_ptr<Fronted> mfronted_;
};

class HeapSnapshotGeneratorProgressReport
    : public quickjs::heapprofiler::ProgressReportInterface {
 public:
  explicit HeapSnapshotGeneratorProgressReport(
      const std::shared_ptr<Fronted>& front)
      : mfronted_(front) {}
  void ProgressResult(uint32_t done, uint32_t total, bool finished) {
    mfronted_->ReportHeapSnapshotProgress(done, total, finished);
  }

 private:
  std::shared_ptr<Fronted> mfronted_;
};

class QjsHeapProfilerImpl {
 public:
  QjsHeapProfilerImpl() = default;
  QjsHeapProfilerImpl(const QjsHeapProfilerImpl&) = delete;
  QjsHeapProfilerImpl& operator=(const QjsHeapProfilerImpl&) = delete;

  void TakeHeapSnapshot(LEPUSContext* ctx, LEPUSValue message,
                        const std::shared_ptr<Fronted>& fronted);
  // for android
  void TakeHeapSnapshot(LEPUSContext* ctx,
                        const std::shared_ptr<Fronted>& fronted);

  HeapSnapshot* TakeHeapSnapshot(LEPUSContext*);

 private:
  auto* FindOrNewHeapProfiler(LEPUSContext* ctx);
  std::unordered_map<LEPUSRuntime*, std::unique_ptr<HeapProfiler>> profilers_;
};
// qjs heapprofiler instance
QjsHeapProfilerImpl& GetQjsHeapProfilerImplInstance();
}  // namespace heapprofiler
}  // namespace quickjs

void HandleHeapProfilerProtocols(DebuggerParams*);
void js_profile_take_heap_snapshot(LEPUSContext*);
#endif  // SRC_INSPECTOR_HEAPPROFILER_HEAPPROFILER_H_
