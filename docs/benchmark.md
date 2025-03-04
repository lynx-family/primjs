# Results of performance comparison between Primjs and QuickJS

This document documents the performance of PrimJS and QuickJS on [Octane Benchmark](https://chromium.github.io/octane/).

## Testing environment
- CPU: Apple M1 Max  
- Memory: 64GB  
- OS: Sonoma 14.0

## Testing build args
  ```
  gn gen out/Default --args='
     enable_quickjs_debugger=false
     enable_tracing_gc = true
     enable_compatbile_mm = true
     enable_primjs_snapshot = true
     target_cpu = "arm64"
     target_os = "mac" 
     is_debug=false
     enable_optimize_with_O2=true
  '
  ```
  
## Testing result

| BenchMark        | QuickJS <br>(6e2e68)  | PrimJS               |   
|------------------|-----------------------|----------------------|
| Richards         | 1163                  | 1247                 |
| DeltaBlue        | 1093                  | 1353                 |
| Crypto           | 1349                  | 1844                 |
| RayTrace         | 1273                  | 2751                 |
| NavierStokes     | 2640                  | 4166                 |
| Mandreel         | 1350                  | 1372                 |
| MandreelLatency  | 9680                  | 9587                 |
| Gameboy          | 9265                  | 10463                |
| CodeLoad         | 18137                 | 16992                |
| Box2D            | 4544                  | 5670                 |
| zlib             | 3097                  | 3864                 |
| Typescript       | 18158                 | 22855                |
| EarleyBoyer      | 2284                  | 4270                 |
| RegExp           | 282                   | 324                  |
| PdfJS            | 4236                  | 6642                 |
| **Score (version 9)** | **2904**         | **3735**             |