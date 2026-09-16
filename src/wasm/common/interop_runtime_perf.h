// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_INTEROP_RUNTIME_PERF_H_
#define SRC_WASM_COMMON_INTEROP_RUNTIME_PERF_H_

// Helpers for the wasm3 vs prism performance-comparison telemetry.
//
// Metric contract (compare engines only within the same SDK/JS-engine/workload
// cohort):
//   wasm_load_ms_*        successful engine-active work per instance journey:
//                         module + instance for the module's first successful
//                         instance, instance only when the module is reused;
//                         JS/application idle between APIs is excluded;
//   wasm_first_call_ms_*  the first owned-export call, including first-use
//                         compilation performed by the engine;
//   wasm_steady_call_ms_* per-export steady calls after first success and
//                         kCallWarmupSkip additional calls.
// These three axes deliberately replace the old module/instance/call metrics.
// The aggregate call distribution reflects the gray cohort's workload mix; it
// is not a peak-throughput benchmark. Peak claims still require a fixed module
// and input on a production-matching device/toolchain.

#include <cstdint>

#ifdef ENABLE_WASM_PERF_COMPARE
#include <atomic>
#include <chrono>
#ifdef ENABLE_WASM_PERF_TEST_CAPTURE
#include <cstring>
#endif

#include "quickjs/include/primjs_monitor.h"
#endif

namespace primjs {
namespace wasm_perf {

// Sampling strides. Both engines are downsampled at the same rate so the
// latency and failure ratios remain comparable. Success and failure events use
// the same gate for each operation, avoiding extra checks on the call hot path.
// Call events use the largest stride because they can occur in tight loops.
inline constexpr uint32_t kLoadSampleStride = 10;
inline constexpr uint32_t kCallSampleStride = 1000;
// The first steady sample uses a shorter phase window so medium-length
// exports are represented: 83% of exports that reach 100 calls are sampled.
// Later steady samples retain kCallSampleStride to bound hot-path volume.
inline constexpr uint32_t kInitialCallSampleWindow = 100;
// Number of leading calls per exported function to skip after its first
// successful call. This keeps lazy compilation and other first-use work out of
// wasm_steady_call_ms_* while retaining a single countdown on the steady hot
// path.
inline constexpr uint32_t kCallWarmupSkip = 16;

#ifdef ENABLE_WASM_PERF_COMPARE
enum class CallSampleKind : uint8_t { kNone, kFirstAttempt, kSteady };

template <typename Pointer, typename Ref>
Pointer TaggedPointerOrNull(const Ref& ref) {
  return ref.template is<Pointer>() ? ref.template get<Pointer>() : nullptr;
}

// Function-local state keeps the steady-call distribution independent across
// exports. A first attempt is timed only when its instance carries a selected
// module + instance journey. A failed first attempt does not consume that
// state.
struct CallSamplingState {
  // -1 means that this exported function has not returned successfully yet.
  // Non-negative values retain the original countdown fast path without a
  // second per-call flag load.
  int32_t countdown = -1;
};
static_assert(sizeof(CallSamplingState) == sizeof(int32_t));

struct LoadFinishResult {
  bool sampled = false;
  uint64_t load_ns = 0;
};

// Measures engine-active load work only. The module object uses this 8-byte
// state to remember the first-instance decision; a selected first success
// reports module + instance, while an unselected first success only consumes
// that decision. Every later instance independently uses the common load
// sampler and, when selected, reports instance-only work. Consequently every
// successful instance journey has the same 1/kLoadSampleStride inclusion
// probability; the first journey is not sampled twice (which would be 19%).
//
// A selected successful journey activates the instance object's token for its
// first owned-export call. All state is object-local: no map, allocation, lock,
// identifier, or address-lifetime dependency is introduced. Module and
// instance tokens use the same storage but distinct contextual states. Zero is
// consumed/inactive. The high bit is the pending-unselected module sentinel;
// selected module durations are stored plus one below it so a real zero-
// nanosecond observation remains representable.
struct LoadToken {
  static constexpr uint64_t kInFlightBit = uint64_t{1} << 63;
  static constexpr uint64_t kClaimedByOuterCall = UINT64_MAX;
  static constexpr uint64_t kFirstInstanceUnselected = kInFlightBit;
  static constexpr uint64_t kMaxModuleDurationNs = kInFlightBit - 2;

  uint64_t active_ns_plus_one = 0;

  bool active() const { return active_ns_plus_one != 0; }

  void BeginModuleJourney(bool sampled, uint64_t module_ns) {
    if (!sampled) {
      active_ns_plus_one = kFirstInstanceUnselected;
      return;
    }
    const uint64_t bounded_module_ns =
        module_ns > kMaxModuleDurationNs ? kMaxModuleDurationNs : module_ns;
    active_ns_plus_one = bounded_module_ns + 1;
  }

  bool first_instance_pending() const { return active(); }

  bool first_instance_sampled() const {
    return active() && active_ns_plus_one != kFirstInstanceUnselected;
  }

  LoadFinishResult FinishFirstInstance(LoadToken& first_call_token,
                                       bool succeeded, uint64_t instance_ns) {
    if (!succeeded || !first_instance_pending()) return {};
    if (!first_instance_sampled()) {
      active_ns_plus_one = 0;
      return {};
    }

    const uint64_t module_ns = active_ns_plus_one - 1;
    const uint64_t load_ns = instance_ns > UINT64_MAX - module_ns
                                 ? UINT64_MAX
                                 : module_ns + instance_ns;
    first_call_token.BeginFirstCall();
    active_ns_plus_one = 0;
    return {true, load_ns};
  }

  void BeginFirstCall() { active_ns_plus_one = 1; }

  uint64_t TryClaim() {
    if (!active()) return 0;
    if ((active_ns_plus_one & kInFlightBit) != 0) {
      return kClaimedByOuterCall;
    }
    const uint64_t claimed = active_ns_plus_one;
    active_ns_plus_one |= kInFlightBit;
    return claimed;
  }

  void Restore(uint64_t claimed) {
    if (OwnsClaim(claimed)) active_ns_plus_one = claimed;
  }

  void Complete() { active_ns_plus_one = 0; }

  static bool OwnsClaim(uint64_t claimed) {
    return claimed != 0 && claimed != kClaimedByOuterCall;
  }

  static bool ClaimedByOuterCall(uint64_t claimed) {
    return claimed == kClaimedByOuterCall;
  }
};
static_assert(sizeof(LoadToken) == sizeof(uint64_t));

inline LoadFinishResult FinishReusedInstanceJourney(LoadToken& first_call_token,
                                                    bool sampled,
                                                    bool succeeded,
                                                    uint64_t instance_ns) {
  if (!sampled || !succeeded) return {};
  first_call_token.BeginFirstCall();
  return {true, instance_ns};
}

#ifdef ENABLE_WASM_PERF_TEST_CAPTURE
// Test-tool-only capture of the exact durations emitted by the production
// telemetry seam. It is compiled only into explicit device/CLI performance
// builds; normal gray and production builds have no state, branch or symbol.
struct TestEngineMetricSummary {
  double load_ms = 0.0;
  double first_call_ms = 0.0;
  double steady_call_total_ms = 0.0;
  uint32_t load_samples = 0;
  uint32_t first_call_samples = 0;
  uint32_t steady_call_samples = 0;
};

struct TestMetricSummary {
  TestEngineMetricSummary prism;
  TestEngineMetricSummary wasm3;
};

namespace test_capture_detail {

inline thread_local TestMetricSummary g_summary;

inline bool Equals(const char* value, size_t length, const char* literal) {
  return length == std::strlen(literal) &&
         std::strncmp(value, literal, length) == 0;
}

inline void AddMetric(TestEngineMetricSummary* summary, const char* phase,
                      size_t phase_length, double value_ms) {
  if (Equals(phase, phase_length, "load_ms")) {
    summary->load_ms += value_ms;
    ++summary->load_samples;
  } else if (Equals(phase, phase_length, "first_call_ms")) {
    summary->first_call_ms += value_ms;
    ++summary->first_call_samples;
  } else if (Equals(phase, phase_length, "steady_call_ms")) {
    summary->steady_call_total_ms += value_ms;
    ++summary->steady_call_samples;
  }
}

}  // namespace test_capture_detail

inline void ResetTestMetricCapture() { test_capture_detail::g_summary = {}; }

inline void CaptureTestDuration(const char* metric_key, double value_ms) {
  if (metric_key == nullptr || value_ms < 0.0) return;
  constexpr char kPrefix[] = "wasm_";
  if (std::strncmp(metric_key, kPrefix, sizeof(kPrefix) - 1) != 0) return;

  const char* phase = metric_key + sizeof(kPrefix) - 1;
  constexpr char kPrismSuffix[] = "_prism";
  constexpr char kWasm3Suffix[] = "_wasm3";
  const size_t length = std::strlen(phase);
  if (length > sizeof(kPrismSuffix) - 1 &&
      std::strcmp(phase + length - (sizeof(kPrismSuffix) - 1), kPrismSuffix) ==
          0) {
    test_capture_detail::AddMetric(&test_capture_detail::g_summary.prism, phase,
                                   length - (sizeof(kPrismSuffix) - 1),
                                   value_ms);
  } else if (length > sizeof(kWasm3Suffix) - 1 &&
             std::strcmp(phase + length - (sizeof(kWasm3Suffix) - 1),
                         kWasm3Suffix) == 0) {
    test_capture_detail::AddMetric(&test_capture_detail::g_summary.wasm3, phase,
                                   length - (sizeof(kWasm3Suffix) - 1),
                                   value_ms);
  }
}

inline TestMetricSummary TakeTestMetricCapture() {
  const TestMetricSummary result = test_capture_detail::g_summary;
  test_capture_detail::g_summary = {};
  return result;
}
#endif

inline uint64_t NowNs() {
  using namespace std::chrono;
  return static_cast<uint64_t>(
      duration_cast<nanoseconds>(steady_clock::now().time_since_epoch())
          .count());
}

inline uint64_t ElapsedNs(uint64_t start_ns) {
  const uint64_t now_ns = NowNs();
  return now_ns > start_ns ? now_ns - start_ns : 0;
}

inline double NsToMs(uint64_t duration_ns) {
  return static_cast<double>(duration_ns) / 1'000'000.0;
}

inline void ReportDuration(const char* module_name, const char* biz_name,
                           const char* metric_key, double value_ms) {
#ifdef ENABLE_WASM_PERF_TEST_CAPTURE
  (void)module_name;
  (void)biz_name;
  CaptureTestDuration(metric_key, value_ms);
#else
  MonitorDuration(module_name, biz_name, metric_key, value_ms);
#endif
}

inline void ReportFailure(const char* module_name, const char* biz_name,
                          const char* metric_key) {
#ifdef ENABLE_WASM_PERF_TEST_CAPTURE
  (void)module_name;
  (void)biz_name;
  (void)metric_key;
#else
  MonitorEvent(module_name, biz_name, metric_key, "1");
#endif
}

inline uint64_t NowUs() { return NowNs() / 1000; }

// Returns elapsed time in milliseconds (fractional, e.g. 0.123 for 123 µs).
// All durations are reported in ms so that Slardar dashboards show a
// consistent unit regardless of the operation granularity.
inline double ElapsedMs(uint64_t start_us) {
  uint64_t now_us = NowUs();
  if (now_us <= start_us) return 0.0;
  return static_cast<double>(now_us - start_us) / 1000.0;
}

// Pure sampling seams. A per-process seed avoids a deterministic reset across
// short-lived processes; the ordinal then disperses engines and threads
// without giving either engine a fixed phase advantage.
inline constexpr uint32_t SamplingPhase(uint32_t process_seed, uint32_t ordinal,
                                        uint32_t stride) {
  return ((process_seed % stride) + (ordinal % stride)) % stride;
}

inline constexpr uint32_t InitialLoadSampleCountdown(uint32_t process_seed,
                                                     uint32_t thread_ordinal) {
  return SamplingPhase(process_seed, thread_ordinal, kLoadSampleStride);
}

inline constexpr uint32_t InitialCallSamplePhase(uint32_t process_seed,
                                                 uint32_t function_ordinal) {
  return SamplingPhase(process_seed, function_ordinal,
                       kInitialCallSampleWindow);
}

inline bool AdvanceLoadSample(uint32_t& countdown) {
  if (countdown == 0) {
    countdown = kLoadSampleStride - 1;
    return true;
  }
  --countdown;
  return false;
}

inline constexpr uint32_t MixSamplingEntropy(uint64_t value) {
  value ^= value >> 33;
  value *= uint64_t{0xff51afd7ed558ccd};
  value ^= value >> 33;
  value *= uint64_t{0xc4ceb9fe1a85ec53};
  value ^= value >> 33;
  return static_cast<uint32_t>(value ^ (value >> 32));
}

#ifndef ENABLE_WASM_PERF_TEST_CAPTURE
namespace load_sampling_detail {

// Both atomics are used only while initializing a process/thread sampling
// phase. They are shared by Prism and wasm3, allocation-free, and lock-free on
// every supported target. Subsequent journeys touch TLS only.
inline std::atomic<uint32_t> g_process_seed_plus_one{0};
inline std::atomic<uint32_t> g_next_thread_ordinal{0};
static_assert(std::atomic<uint32_t>::is_always_lock_free,
              "wasm load sampling requires a lock-free 32-bit atomic counter");
// Zero is the uninitialized sentinel; a real countdown is stored plus one.
// Keeping TLS constant-initialized avoids a second TLS guard lookup on every
// module journey.
inline thread_local uint32_t g_countdown_plus_one = 0;
inline thread_local uint32_t g_cached_process_seed_plus_one = 0;

}  // namespace load_sampling_detail

inline uint32_t ProcessSamplingSeed() {
  uint32_t encoded = load_sampling_detail::g_process_seed_plus_one.load(
      std::memory_order_relaxed);
  if (encoded != 0) return encoded - 1;

  const uint64_t entropy =
      NowNs() ^ static_cast<uint64_t>(reinterpret_cast<uintptr_t>(
                    &load_sampling_detail::g_process_seed_plus_one));
  const uint32_t candidate =
      MixSamplingEntropy(entropy) % kCallSampleStride + 1;
  if (load_sampling_detail::g_process_seed_plus_one.compare_exchange_strong(
          encoded, candidate, std::memory_order_relaxed,
          std::memory_order_relaxed)) {
    return candidate - 1;
  }
  return encoded - 1;
}

inline uint32_t ThreadSamplingSeed() {
  uint32_t& encoded = load_sampling_detail::g_cached_process_seed_plus_one;
  if (encoded == 0) {
    encoded =
        SamplingPhase(ProcessSamplingSeed(),
                      load_sampling_detail::g_next_thread_ordinal.fetch_add(
                          1, std::memory_order_relaxed),
                      kCallSampleStride) +
        1;
  }
  return encoded - 1;
}
#else
inline constexpr uint32_t ProcessSamplingSeed() { return 0; }
inline constexpr uint32_t ThreadSamplingSeed() { return 0; }
#endif

inline bool ShouldSampleLoad() {
#ifdef ENABLE_WASM_PERF_TEST_CAPTURE
  // A gate point runs one real workload in a fresh runtime and needs the
  // workload's actual load phase every time. This override exists only in the
  // test-tool build and does not alter gray sampling.
  return true;
#else
  uint32_t& encoded = load_sampling_detail::g_countdown_plus_one;
  if (encoded == 0) {
    encoded = InitialLoadSampleCountdown(ThreadSamplingSeed(), 0) + 1;
  }
  uint32_t countdown = encoded - 1;
  const bool sample = AdvanceLoadSample(countdown);
  encoded = countdown + 1;
  return sample;
#endif
}

inline CallSampleKind BeginCall(CallSamplingState& state) {
  if (state.countdown > 0) {
    --state.countdown;
    return CallSampleKind::kNone;
  }
  if (state.countdown < 0) return CallSampleKind::kFirstAttempt;
  state.countdown = static_cast<int32_t>(kCallSampleStride - 1);
  return CallSampleKind::kSteady;
}

inline void FinishCall(CallSamplingState& state, CallSampleKind kind,
                       bool succeeded) {
  if (kind != CallSampleKind::kFirstAttempt) return;
  if (!succeeded) {
    // Retry the first-call observation. Failures must not make a later lazy
    // compile look like steady execution.
    return;
  }
  // Distribute the first steady sample across a bounded initial window. This
  // covers most medium-length exports without making every short-lived export
  // report its 17th call. Later samples still use the 1/1000 stride.
  thread_local uint32_t first_function_ordinal = 0;
  state.countdown = static_cast<int32_t>(
      kCallWarmupSkip +
      InitialCallSamplePhase(ThreadSamplingSeed(), first_function_ordinal++));
}

struct FirstCallResult {
  bool completed_first_call = false;
  bool sampled_failure = false;
  uint64_t first_call_ns = 0;
};

inline FirstCallResult FinishFirstAttempt(CallSamplingState& call_state,
                                          LoadToken* token, uint64_t claim,
                                          bool succeeded, uint64_t call_ns) {
  // A nested export entered while an outer first-result call owns the token.
  // Keep it first-pending so an outer failure can restore the journey and any
  // export can retry it.
  if (LoadToken::ClaimedByOuterCall(claim)) return {};

  if (!succeeded) {
    if (LoadToken::OwnsClaim(claim) && token) token->Restore(claim);
    const int32_t failure_stride = static_cast<int32_t>(kCallSampleStride);
    const bool sampled_failure = call_state.countdown <= -failure_stride;
    call_state.countdown = sampled_failure ? -1 : call_state.countdown - 1;
    return {false, sampled_failure, 0};
  }

  FinishCall(call_state, CallSampleKind::kFirstAttempt, true);
  if (!LoadToken::OwnsClaim(claim) || !token) return {};
  token->Complete();
  return {true, false, call_ns};
}
#endif

}  // namespace wasm_perf
}  // namespace primjs

#endif  // SRC_WASM_COMMON_INTEROP_RUNTIME_PERF_H_
