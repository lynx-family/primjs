# Background
The current quickjs uses RC(Reference Count) to manage memory, compared with the mainstream virtual machine using the tracing-gc algorithm (hereinafter referred to as GC ):
- In terms of performance, according to previous experience, GC can improve the performance of virtual machines by about 10% -20% compared to RC . The performance improvement comes from removing inc/dec from RC, while GC can use a better performance bump-pointer algorithm. RC can only use freelist algorithm
- From the perspective of memory usage, RC release will be more timely. The RC memory management mode is basically in the best memory state of the virtual machine
- From the perspective of pause time, RC has less pause time. While GC pauses for a longer time during tracing & sweeping. Especially in the early implementation stage, the GC algorithm tends to use simple and easy-to-implement algorithms. More advanced concurrent algorithms, such as the concurrent-copy algorithm similar to zgc, although have short pause time, are more complex to implement
- From a development point of view, based on GC memory management, developers no longer need to maintain the inc/dec of objects, and can ignore more details.

# Parallel mark-sweep GC algorithm
Memory management pursues not a single goal, but to balance the performance, memory, pause time and other indicators of virtual machines. The first goal is to achieve:
1. Memory usage does not exceed the memory usage of v8 , including minimum memory, peak memory, and average memory.
2. Performance is better than RC in most scenarios. However, due to the use of parallel recycling strategy in the first phase, a small number of scenarios will have some degradation when encountering GC , but overall, performance is still better than RC by 10% -20%
3. Pause time, expected on mid-range machines, 50 MB heap, pause time does not exceed 3 0ms
4. RC/GC can be dynamically switched, which may bring some performance impact. It will be switched to pure GC later.

# Detailed design
## Roots set
- Interpreter Execution Stack
- Objects recorded in HandleScope
- Objects recorded in GlobalHandle
- Some data on JSRuntime, such as atom , class_array, etc
- global_var_obj, global_obj, current_exception, class_proto in JSContext
## Allocator
In order to verify as soon as possible, the bump-pointer allocation algorithm with better performance was not used in the first phase. Because the allocator using the bump-pointer algorithm requires objects to be able to move, the original code of quickjs needs to do more adaptation, such as a temporary variable holding a certain field (pointer) of the object. After GC , this variable holds an illegal pointer. This situation requires GC to update the pointer , or to retrieve the content of the field after GC, which will make debugging more difficult.
The current memory allocator is based on dlmalloc implementation, that is, the variant algorithm of Freelist . Small objects are managed in a linked list manner (different sizes are indexed to different linked lists), and large objects are managed in a tree structure (size is allocated to a tree in the same range). Large objects directly go through the system allocation interface
The data structure managed by Freelist is not a global data structure. Because it needs to provide concurrency for collectors, it is based on the number of GC working threads and sets the corresponding number of freelist management structures .
Since the JS language does not support multi- threading , there is no lock contention during allocation .

## Collector
Mark (multi-thread, supports task stealing)
Do tracing from roots and mark live objects. Divide subtasks and mark concurrently based on roots.
DoFinalizer(single Thread)
Traverse the heap once. According to different types, execute the finalizer method corresponding to the dead object. Currently does not support multi- threading
Sweep (multi-thread, supports task stealing)
Split the segment list into multiple tasks to execute concurrently .
Main work:
  1. Merge dead objects, if you can merge them into a complete empty segment, then directly release them to the os  
  2. Generate thread_local freelist
  3. Handle large objects, which occupy independent memory blocks, and dead objects are also released to the os

## HandleScope
HandleScope is used to record the heap objects held by temporary variables in the internal code of quickjs  , that is, it will be automatically destructed when the function ends or the code segment ends . These recorded objects belong to part of the roots
For example, LEPUSValue tmp = LEPUS_NewArray. If GC is triggered after this statement, there will be no reference relationship pointing to tmp during tracing, so tmp will be recycled as a dead object.
So you need a structure like HandleScope to record these temporary variables. All code in quickjs needs to do this adaptation .
HandleScope uses an expandable array to store object addresses, usually within a function scope. It is fast to create/destruct and is used to record/restore current index information.
Conventions currently observed:
  1. Objects in the parameters, whose lifecycle is managed by the caller
  2. Only when the GC is triggered within the current scope (all allocation interfaces have the possibility of triggering GC, including the case where callee walks to the allocation interface), the object held by the temporary variable needs to be managed by HandleScope
Heap object management instructions
Heap object
The objects managed by GC mainly refer to heap objects, including:
1. LEPUSValue (Numeric/non-numeric types are not distinguished here, GC can distinguish them by itself)
2. LEPUSAtom (atom itself is of type int, but it represents an object recorded in the atom_array)
3. lepus_malloc_rt/lepus_realloc_rt and other memory allocation interfaces
Note: Adding logic involving bare pointers, try not to store it in the C ++ standard library, and consider using data structures in JavaScript as a substitute

## GCPersistent
The most essential difference between GCPersistent and Handlescope is the scope and lifecycle. GCPersistent needs to actively destroy to remove recorded heap objects
GlobalHandle
GlobalHandle data structure is used to record the naked pointer outside quickjs , such as the QuickjsHostObjectProxy data structure on the lynx side holds LEPUSValue, and this propagates to the object outside the vm , GC is also unaware of this, if not recorded, it will also cause the object to be erroneously collected.
Therefore, the functions of HandleScope and GlobalHandle are the same. However, due to different usage scenarios, they provide different interfaces. HandleScope is used in a certain function scope, so when cleaning, it cleans multiple record data at once during destruction. while GlobalHandle provides an independent Reset interface for each record and can set the weak attribute (if only globalhandle holds the object, the object can be recycled).

## GC task thread pool
Configurable options, different platforms can set different number of threads , js threads can also be configured to join the thread pool.

## Visit interface
Currently, there are many data structures in QuickJS , and tags and corresponding visit interfaces need to be added to all data structures allocated from heap memory. The tracing logic depends on this visit interface.

Adjust GC trigger timing in combination with business
For example, rendering and other key scenes, can suppress GC

## Performance data
| CASE              | base   | gc    | res      |
|--------------------|--------|-------|----------|
| Richards          | 682    | 890   | 30.50%   |
| DeltaBlue         | 786    | 1062  | 35.11%   |
| Crypto            | 669    | 792   | 18.39%   |
| RayTrace          | 937    | 1742  | 85.91%   |
| EarleyBoyer       | 1589   | 3129  | 96.92%   |
| RegExp            | 266    | 291   | 9.40%    |
| Splay             | 2100   | 4478  | 113.24%  |
| NavierStokes      | 1174   | 1356  | 15.50%   |
| PdfJS             | 3123   | 4053  | 29.78%   |
| Mandreel          | 588    | 656   | 11.56%   |
| MandreelLatency   | 4416   | 4897  | 10.89%   |
| Gameboy           | 4616   | 5705  | 23.59%   |
| CodeLoad          | 14209  | 16013 | 12.70%   |
| Box2D             | 2581   | 3492  | 35.30%   |
| zlib              | 1320   | 1446  | 9.55%    |
| Typescript        | 11400  | 16334 | 43.28%   |


## GC Algorithm Evolution
Concurrent Mark - Sweep expected to be available in Q1 next year