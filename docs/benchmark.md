# Results of performance comparison between PrimJS, QuickJS, and V8 (JIT-less)

This document documents the performance of PrimJS, QuickJS, and V8 (`--jitless`) on [Octane Benchmark](https://chromium.github.io/octane/).

## Testing environment
- CPU: Apple M5 Max
- Memory: 128GB
- OS: macOS 27.2

## Testing build args
```bash
gn gen out/Default --args='
  enable_quickjs_debugger=false
  target_cpu = "arm64"
  target_os = "mac"
  is_debug=false
  enable_optimize_with_O2=true
'
```

This benchmark used the default value `true` for `enable_primjs_snapshot`, `enable_compatible_mm`, and `enable_tracing_gc`. Upstream QuickJS (`04be246`) was built with its default `Makefile` (`clang -O2` on arm64 macOS), and V8 (`16.0.119`, release `d8` on arm64 macOS) was run with `--jitless`. Scores below are averages across four measured runs after one full warmup run per engine.

## Testing result

| Benchmark             | QuickJS <br>(04be246) | V8 `--jitless` <br>(16.0.119) | PrimJS    |
|-----------------------|-----------------------|-------------------------------|-----------|
| Richards              | 1909                  | 2577                          | 3622      |
| DeltaBlue             | 2002                  | 2772                          | 3340      |
| Crypto                | 2020                  | 2754                          | 5100      |
| RayTrace              | 4483                  | 8670                          | 7486      |
| EarleyBoyer           | 5516                  | 12823                         | 12656     |
| RegExp                | 1092                  | 6898                          | 1514      |
| Splay                 | 9918                  | 16798                         | 15948     |
| SplayLatency          | 29319                 | 41430                         | 17826     |
| NavierStokes          | 4775                  | 4197                          | 6622      |
| PdfJS                 | 11282                 | 20911                         | 21005     |
| Mandreel              | 2246                  | 2456                          | 3445      |
| MandreelLatency       | 19710                 | 16108                         | 25344     |
| Gameboy               | 17124                 | 17349                         | 28324     |
| CodeLoad              | 38383                 | 122995                        | 39054     |
| Box2D                 | 7798                  | 9974                          | 13912     |
| zlib                  | 4038                  | 4682                          | 7328      |
| Typescript            | 31018                 | 45265                         | 50404     |
| **Score (version 9)** | **6630**              | **10296**                     | **10326** |
