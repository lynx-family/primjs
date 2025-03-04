/*
  This is a version of malloc/free/realloc written by
  Doug Lea and released to the public domain, as explained at
  http://creativecommons.org/publicdomain/zero/1.0/ Send questions,
  comments, complaints, performance data, etc to dl@cs.oswego.edu
* Version 2.8.6 Wed Aug 29 06:57:58 2012  Doug Lea
   Note: There may be an updated version of this malloc obtainable at
           ftp://gee.cs.oswego.edu/pub/misc/malloc.c
         Check before installing!
 */
/*
 * PackageLicenseDeclared: CC0-1.0
 */

// Copyright 2023 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef _WIN32
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnull-pointer-arithmetic"

#include "gc/allocator.h"

#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <unistd.h>

#include "gc/sweeper.h"

#if defined(ANDROID) || defined(__ANDROID__)
#include <android/log.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#endif
#define LACKS_UNISTD_H
#define LACKS_FCNTL_H
#define LACKS_SYS_PARAM_H
#define stderrout 0

#define USE_DL_PREFIX
#define LACKS_TIME_H

#if defined(__ARMCC_VERSION)
#define LACKS_SYS_TYPES_H
#endif

#define HAVE_MMAP 1
#define HAVE_MREMAP 0

#define NO_MALLINFO 1
#define NO_MALLOC_STATS 1

#define DEFAULT_GRANULARITY 16 * 1024

#define is_aligned(A) (((size_t)((A)) & (CHUNK_ALIGN_MASK)) == 0)

#ifndef ALLOCATE_VERSION
#define ALLOCATE_VERSION 20806
#endif /* ALLOCATE_VERSION */

#ifndef ALLOCATE_EXPORT
#define ALLOCATE_EXPORT extern
#endif

#ifndef WIN32
#ifdef _WIN32
#define WIN32 1
#endif /* _WIN32 */
#ifdef _WIN32_WCE
#define LACKS_FCNTL_H
#define WIN32 1
#endif /* _WIN32_WCE */
#endif /* WIN32 */
#ifdef WIN32
#define WIN32_LEAN_AND_MEAN
#include <tchar.h>
#include <windows.h>
#define HAVE_MMAP 1
#define LACKS_UNISTD_H
#define LACKS_SYS_PARAM_H
#define LACKS_SYS_MMAN_H
#define LACKS_STRING_H
#define LACKS_STRINGS_H
#define LACKS_SYS_TYPES_H
#define LACKS_ERRNO_H
#define LACKS_SCHED_H
#ifndef MALLOC_FAILURE_ACTION
#define MALLOC_FAILURE_ACTION
#endif /* MALLOC_FAILURE_ACTION */
#ifndef MMAP_CLEARS
#ifdef _WIN32_WCE /* WINCE reportedly does not clear */
#define MMAP_CLEARS 0
#else
#define MMAP_CLEARS 1
#endif /* _WIN32_WCE */
#endif /*MMAP_CLEARS */
#endif /* WIN32 */

#ifndef LACKS_SYS_TYPES_H
#include <sys/types.h>
#endif

#define MAX_SIZE_T (~(size_t)0)

#if USE_LOCKS
#if ((defined(__GNUC__) &&                                         \
      ((__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 1)) || \
       defined(__i386__) || defined(__x86_64__))) ||               \
     (defined(_MSC_VER) && _MSC_VER >= 1310))
#ifndef USE_SPIN_LOCKS
#define USE_SPIN_LOCKS 0
#endif /* USE_SPIN_LOCKS */
#elif USE_SPIN_LOCKS
#error "USE_SPIN_LOCKS defined without implementation"
#endif /* ... locks available... */
#elif !defined(USE_SPIN_LOCKS)
#define USE_SPIN_LOCKS 0
#endif /* USE_LOCKS */

#ifndef ONLY_MSPACES
#define ONLY_MSPACES 0
#endif /* ONLY_MSPACES */
#ifndef MSPACES
#if ONLY_MSPACES
#define MSPACES 1
#else /* ONLY_MSPACES */
#define MSPACES 0
#endif /* ONLY_MSPACES */
#endif /* MSPACES */

#ifndef ABORT
#define ABORT abort()
#endif /* ABORT */
#ifndef ABORT_ON_ASSERT_FAILURE
#define ABORT_ON_ASSERT_FAILURE 1
#endif /* ABORT_ON_ASSERT_FAILURE */
#ifndef PROCEED_ON_ERROR
#define PROCEED_ON_ERROR 0
#endif /* PROCEED_ON_ERROR */

#ifndef INSECURE
#define INSECURE 0
#endif /* INSECURE */
#ifndef MALLOC_INSPECT_ALL
#define MALLOC_INSPECT_ALL 0
#endif /* MALLOC_INSPECT_ALL */
#ifndef HAVE_MMAP
#define HAVE_MMAP 1
#endif /* HAVE_MMAP */
#ifndef MMAP_CLEARS
#define MMAP_CLEARS 1
#endif /* MMAP_CLEARS */
#ifndef HAVE_MREMAP
#ifdef linux
#define HAVE_MREMAP 1
#define _GNU_SOURCE /* Turns on mremap() definition */
#else               /* linux */
#define HAVE_MREMAP 0
#endif /* linux */
#endif /* HAVE_MREMAP */
#ifndef MALLOC_FAILURE_ACTION
#define MALLOC_FAILURE_ACTION errno = ENOMEM;
#endif /* MALLOC_FAILURE_ACTION */

#ifndef DEFAULT_TRIM_THRESHOLD
#ifndef MORECORE_CANNOT_TRIM
#define DEFAULT_TRIM_THRESHOLD ((size_t)512U * (size_t)1024U)
#else /* MORECORE_CANNOT_TRIM */
#define DEFAULT_TRIM_THRESHOLD ((size_t)2U * (size_t)1024U * (size_t)1024U)
#endif /* MORECORE_CANNOT_TRIM */
#endif /* DEFAULT_TRIM_THRESHOLD */
#ifndef DEFAULT_MMAP_THRESHOLD
#if HAVE_MMAP
#define DEFAULT_MMAP_THRESHOLD ((size_t)256U * (size_t)1024U)
#else /* HAVE_MMAP */
#define DEFAULT_MMAP_THRESHOLD MAX_SIZE_T
#endif /* HAVE_MMAP */
#endif /* DEFAULT_MMAP_THRESHOLD */
#ifndef MAX_RELEASE_CHECK_RATE
#if HAVE_MMAP
#define MAX_RELEASE_CHECK_RATE 1024
#else
#define MAX_RELEASE_CHECK_RATE MAX_SIZE_T
#endif /* HAVE_MMAP */
#endif /* MAX_RELEASE_CHECK_RATE */
#ifndef USE_BUILTIN_FFS
#define USE_BUILTIN_FFS 0
#endif /* USE_BUILTIN_FFS */
#ifndef USE_DEV_RANDOM
#define USE_DEV_RANDOM 0
#endif /* USE_DEV_RANDOM */
#ifndef NO_MALLINFO
#define NO_MALLINFO 0
#endif /* NO_MALLINFO */
#ifndef MALLINFO_FIELD_TYPE
#define MALLINFO_FIELD_TYPE size_t
#endif /* MALLINFO_FIELD_TYPE */
#ifndef NO_MALLOC_STATS
#define NO_MALLOC_STATS 0
#endif /* NO_MALLOC_STATS */
#ifndef NO_SEGMENT_TRAVERSAL
#define NO_SEGMENT_TRAVERSAL 0
#endif /* NO_SEGMENT_TRAVERSAL */

/*
  mallopt tuning options.  SVID/XPG defines four standard parameter
  numbers for mallopt, normally defined in malloc.h.  None of these
  are used in this malloc, so setting them has no effect. But this
  malloc does support the following options.
*/

#define M_TRIM_THRESHOLD (-1)
#define M_GRANULARITY (-2)
#define M_MMAP_THRESHOLD (-3)

#if defined(DEBUGINFOFILE)
#define PRINT(...) fprintf(getfile(), __VA_ARGS__);
void* getfile() {
  static FILE* fp = NULL;
  if (fp == NULL) {
    fp = fopen("mnt/sdcard/Download/quickjs", "a+");
  }
  return fp;
}
#elif defined(DEBUGINFOSTD)
#define PRINT(...) printf(__VA_ARGS__);
#elif defined(DEBUGINFOANDROID)
#define PRINT(...) __android_log_print(ANDROID_LOG_ERROR, "LYNX", __VA_ARGS__);
#else
#define PRINT(...)
#endif

#if !NO_MALLINFO
/* #define HAVE_USR_INCLUDE_MALLOC_H */

#ifdef HAVE_USR_INCLUDE_MALLOC_H
#include "/usr/include/malloc.h"
#else
#ifndef STRUCT_MALLINFO_DECLARED
#define _STRUCT_MALLINFO
#define STRUCT_MALLINFO_DECLARED 1
struct mallinfo {
  MALLINFO_FIELD_TYPE arena;    /* non-mmapped space allocated from system */
  MALLINFO_FIELD_TYPE ordblks;  /* number of free chunks */
  MALLINFO_FIELD_TYPE smblks;   /* always 0 */
  MALLINFO_FIELD_TYPE hblks;    /* always 0 */
  MALLINFO_FIELD_TYPE hblkhd;   /* space in mmapped regions */
  MALLINFO_FIELD_TYPE usmblks;  /* maximum total allocated space */
  MALLINFO_FIELD_TYPE fsmblks;  /* always 0 */
  MALLINFO_FIELD_TYPE uordblks; /* total allocated space */
  MALLINFO_FIELD_TYPE fordblks; /* total free space */
  MALLINFO_FIELD_TYPE keepcost; /* releasable (via malloc_trim) space */
};
#endif /* STRUCT_MALLINFO_DECLARED */
#endif /* HAVE_USR_INCLUDE_MALLOC_H */
#endif /* NO_MALLINFO */

#ifndef FORCEINLINE
#if defined(__GNUC__)
#define FORCEINLINE __inline __attribute__((always_inline))
#elif defined(_MSC_VER)
#define FORCEINLINE __forceinline
#endif
#endif
#ifndef NOINLINE
#if defined(__GNUC__)
#define NOINLINE __attribute__((noinline))
#elif defined(_MSC_VER)
#define NOINLINE __declspec(noinline)
#else
#define NOINLINE
#endif
#endif

#ifdef __cplusplus
extern "C" {
#ifndef FORCEINLINE
#define FORCEINLINE inline
#endif
#endif /* __cplusplus */
#ifndef FORCEINLINE
#define FORCEINLINE
#endif

#if !ONLY_MSPACES

#ifndef USE_DL_PREFIX
#define dlcalloc calloc
#define gcfree free
#define allocate malloc
#define dlmemalign memalign
#define dlposix_memalign posix_memalign
#define reallocate realloc
#define reallocate_in_place realloc_in_place
#define dlvalloc valloc
#define dlpvalloc pvalloc
#define allocinfo mallinfo
#define allocopt mallopt
#define allocate_trim malloc_trim
#define allocate_stats malloc_stats
// #define allocate_usable_size malloc_usable_size
#define allocate_footprint malloc_footprint
#define allocate_max_footprint malloc_max_footprint
#define allocate_footprint_limit malloc_footprint_limit
#define allocate_set_footprint_limit malloc_set_footprint_limit
#define allocate_inspect_all malloc_inspect_all
#define dlindependent_calloc independent_calloc
#define dlindependent_comalloc independent_comalloc
#define dlbulk_free bulk_free
#endif /* USE_DL_PREFIX */

// ALLOCATE_EXPORT size_t allocate_footprint(void);

// ALLOCATE_EXPORT size_t allocate_max_footprint(void);

// ALLOCATE_EXPORT size_t allocate_footprint_limit(void);

// ALLOCATE_EXPORT size_t allocate_set_footprint_limit(size_t bytes);

#if MALLOC_INSPECT_ALL

ALLOCATE_EXPORT void allocate_inspect_all(void (*handler)(void*, void*, size_t,
                                                          void*),
                                          void* arg);

#endif /* MALLOC_INSPECT_ALL */

#if !NO_MALLINFO

ALLOCATE_EXPORT struct mallinfo allocinfo(mstate m);
#endif /* NO_MALLINFO */

// ALLOCATE_EXPORT void** dlindependent_calloc(size_t, size_t, void**);

// ALLOCATE_EXPORT void** dlindependent_comalloc(size_t, size_t*, void**);

// ALLOCATE_EXPORT size_t  dlbulk_free(void**, size_t n_elements);

// ALLOCATE_EXPORT int  allocate_trim(size_t);

ALLOCATE_EXPORT void allocate_stats(mstate m);

// size_t allocate_usable_size(void*);

#endif /* ONLY_MSPACES */

#if MSPACES

typedef void* mspace;

ALLOCATE_EXPORT mspace create_mspace(size_t capacity, int locked);

ALLOCATE_EXPORT size_t destroy_mspace(mspace msp);

ALLOCATE_EXPORT mspace create_mspace_with_base(void* base, size_t capacity,
                                               int locked);

ALLOCATE_EXPORT int mspace_track_large_chunks(mspace msp, int enable);

ALLOCATE_EXPORT void* mspace_malloc(mspace msp, size_t bytes);

ALLOCATE_EXPORT void mspace_free(mspace msp, void* mem);

ALLOCATE_EXPORT void* mspace_realloc(mspace msp, void* mem, size_t newsize);

ALLOCATE_EXPORT void* mspace_calloc(mspace msp, size_t n_elements,
                                    size_t elem_size);

ALLOCATE_EXPORT void* mspace_memalign(mspace msp, size_t alignment,
                                      size_t bytes);

ALLOCATE_EXPORT void** mspace_independent_calloc(mspace msp, size_t n_elements,
                                                 size_t elem_size,
                                                 void* chunks[]);

ALLOCATE_EXPORT void** mspace_independent_comalloc(mspace msp,
                                                   size_t n_elements,
                                                   size_t sizes[],
                                                   void* chunks[]);

ALLOCATE_EXPORT size_t mspace_footprint(mspace msp);

ALLOCATE_EXPORT size_t mspace_max_footprint(mspace msp);

#if !NO_MALLINFO

ALLOCATE_EXPORT struct mallinfo mspace_mallinfo(mspace msp);
#endif /* NO_MALLINFO */

ALLOCATE_EXPORT size_t mspace_usable_size(const void* mem);

ALLOCATE_EXPORT void mspace_malloc_stats(mspace msp);

ALLOCATE_EXPORT int mspace_trim(mspace msp, size_t pad);

ALLOCATE_EXPORT int mspace_mallopt(int, int);

#endif /* MSPACES */

#ifdef __cplusplus
}      /* end of extern "C" */
#endif /* __cplusplus */

/* #include "malloc.h" */

#ifdef _MSC_VER
#pragma warning(disable : 4146)
#endif  // _MSC_VER
#ifndef LACKS_ERRNO_H
#include <errno.h>
#endif  // LACKS_ERRNO_H
#ifdef DEBUG
#if ABORT_ON_ASSERT_FAILURE
#undef assert
#define assert(x) \
  if (!(x)) ABORT
#else /* ABORT_ON_ASSERT_FAILURE */
#include <assert.h>
#endif /* ABORT_ON_ASSERT_FAILURE */
#else  /* DEBUG */
#ifndef assert
#define assert(x)
#endif
#define DEBUG 0
#endif /* DEBUG */
#if !defined(WIN32) && !defined(LACKS_TIME_H)
#include <time.h>
#endif  // WIN32
#ifndef LACKS_STDLIB_H
#include <stdlib.h>
#endif  // LACKS_STDLIB_H
#if USE_BUILTIN_FFS
#ifndef LACKS_STRINGS_H
#include <strings.h>
#endif  // LACKS_STRINGS_H
#endif  // USE_BUILTIN_FFS
#if HAVE_MMAP
#ifndef LACKS_SYS_MMAN_H
/* On some versions of linux, mremap decl in mman.h needs __USE_GNU set */
#if (defined(linux) && !defined(__USE_GNU))
#define __USE_GNU 1
#undef __USE_GNU
#else
#endif  // linux
#endif  // LACKS_SYS_MMAN_H
#ifndef LACKS_FCNTL_H
#include <fcntl.h>
#endif /* LACKS_FCNTL_H */
#endif /* HAVE_MMAP */
#ifdef LACKS_UNISTD_H
#if !defined(__FreeBSD__) && !defined(__OpenBSD__) && !defined(__NetBSD__)
#endif /* FreeBSD etc */
#endif /* LACKS_UNISTD_H */

/* Declarations for locking */
#if USE_LOCKS
#ifndef WIN32
#if defined(__SVR4) && defined(__sun) /* solaris */
#include <thread.h>
#elif !defined(LACKS_SCHED_H)
#include <sched.h>
#endif /* solaris or LACKS_SCHED_H */
#if (defined(USE_RECURSIVE_LOCKS) && USE_RECURSIVE_LOCKS != 0) || \
    !USE_SPIN_LOCKS
#include <pthread.h>
#endif /* USE_RECURSIVE_LOCKS ... */
#elif defined(_MSC_VER)
#ifndef _M_AMD64
/* These are already defined on AMD64 builds */
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
LONG __cdecl _InterlockedCompareExchange(LONG volatile* Dest, LONG Exchange,
                                         LONG Comp);
LONG __cdecl _InterlockedExchange(LONG volatile* Target, LONG Value);
#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif /* _M_AMD64 */
#pragma intrinsic(_InterlockedCompareExchange)
#pragma intrinsic(_InterlockedExchange)
#define interlockedcompareexchange _InterlockedCompareExchange
#define interlockedexchange _InterlockedExchange
#elif defined(WIN32) && defined(__GNUC__)
#define interlockedcompareexchange(a, b, c) __sync_val_compare_and_swap(a, c, b)
#define interlockedexchange __sync_lock_test_and_set
#endif /* Win32 */
#else  /* USE_LOCKS */
#endif /* USE_LOCKS */

#ifndef LOCK_AT_FORK
#define LOCK_AT_FORK 0
#endif

/* Declarations for bit scanning on win32 */
#if defined(_MSC_VER) && _MSC_VER >= 1300
#ifndef BitScanForward /* Try to avoid pulling in WinNT.h */
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
unsigned char _BitScanForward(unsigned long* index, unsigned long mask);
unsigned char _BitScanReverse(unsigned long* index, unsigned long mask);
#ifdef __cplusplus
}
#endif /* __cplusplus */

#define BitScanForward _BitScanForward
#define BitScanReverse _BitScanReverse
#pragma intrinsic(_BitScanForward)
#pragma intrinsic(_BitScanReverse)
#endif /* BitScanForward */
#endif /* defined(_MSC_VER) && _MSC_VER>=1300 */

#ifndef WIN32
#ifndef malloc_getpagesize
#ifdef _SC_PAGESIZE /* some SVR4 systems omit an underscore */
#ifndef _SC_PAGE_SIZE
#define _SC_PAGE_SIZE _SC_PAGESIZE
#endif
#endif
#ifdef _SC_PAGE_SIZE
#define malloc_getpagesize sysconf(_SC_PAGE_SIZE)
#else
#if defined(BSD) || defined(DGUX) || defined(HAVE_GETPAGESIZE)
// extern size_t getpagesize();
// #define malloc_getpagesize getpagesize()
#define malloc_getpagesize ((size_t)4096U)
#else
#ifdef WIN32 /* use supplied emulation of getpagesize */
#define malloc_getpagesize getpagesize()
#else
#ifndef LACKS_SYS_PARAM_H
#include <sys/param.h>
#endif
#ifdef EXEC_PAGESIZE
#define malloc_getpagesize EXEC_PAGESIZE
#else
#ifdef NBPG
#ifndef CLSIZE
#define malloc_getpagesize NBPG
#else
#define malloc_getpagesize (NBPG * CLSIZE)
#endif
#else
#ifdef NBPC
#define malloc_getpagesize NBPC
#else
#ifdef PAGESIZE
#define malloc_getpagesize PAGESIZE
#else /* just guess */
#define malloc_getpagesize ((size_t)4096U)
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

#define MFAIL ((void*)(MAX_SIZE_T))
#define CMFAIL ((char*)(MFAIL))

#if HAVE_MMAP

#ifndef WIN32
#define MUNMAP_DEFAULT(a, s) munmap((a), (s))
#define MMAP_PROT (PROT_READ | PROT_WRITE)
#if !defined(MAP_ANONYMOUS) && defined(MAP_ANON)
#define MAP_ANONYMOUS MAP_ANON
#endif /* MAP_ANON */
#ifdef MAP_ANONYMOUS
#define MMAP_FLAGS (MAP_PRIVATE | MAP_ANONYMOUS)
#define MMAP_DEFAULT(s) mmap(0, (s), MMAP_PROT, MMAP_FLAGS, -1, 0)
#else /* MAP_ANONYMOUS */

#define MMAP_FLAGS (MAP_PRIVATE)
static int dev_zero_fd = -1; /* Cached file descriptor for /dev/zero. */
#define MMAP_DEFAULT(s)                                                      \
  ((dev_zero_fd < 0) ? (dev_zero_fd = open("/dev/zero", O_RDWR),             \
                        mmap(0, (s), MMAP_PROT, MMAP_FLAGS, dev_zero_fd, 0)) \
                     : mmap(0, (s), MMAP_PROT, MMAP_FLAGS, dev_zero_fd, 0))
#endif /* MAP_ANONYMOUS */

#define DIRECT_MMAP_DEFAULT(s) MMAP_DEFAULT(s)

#else /* WIN32 */

static FORCEINLINE void* win32mmap(size_t size) {
  void* ptr = VirtualAlloc(0, size, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);
  return (ptr != 0) ? ptr : MFAIL;
}

static FORCEINLINE void* win32direct_mmap(size_t size) {
  void* ptr = VirtualAlloc(0, size, MEM_RESERVE | MEM_COMMIT | MEM_TOP_DOWN,
                           PAGE_READWRITE);
  return (ptr != 0) ? ptr : MFAIL;
}

static FORCEINLINE int win32munmap(void* ptr, size_t size) {
  MEMORY_BASIC_INFORMATION minfo;
  char* cptr = reinterpret_cast<char*>(ptr);
  while (size) {
    if (VirtualQuery(cptr, &minfo, sizeof(minfo)) == 0) return -1;
    if (minfo.BaseAddress != cptr || minfo.AllocationBase != cptr ||
        minfo.State != MEM_COMMIT || minfo.RegionSize > size)
      return -1;
    if (VirtualFree(cptr, 0, MEM_RELEASE) == 0) return -1;
    cptr += minfo.RegionSize;
    size -= minfo.RegionSize;
  }
  return 0;
}

#define MMAP_DEFAULT(s) win32mmap(s)
#define MUNMAP_DEFAULT(a, s) win32munmap((a), (s))
#define DIRECT_MMAP_DEFAULT(s) win32direct_mmap(s)
#endif /* WIN32 */
#endif /* HAVE_MMAP */

#if HAVE_MREMAP
#ifndef WIN32
#define MREMAP_DEFAULT(addr, osz, nsz, mv) mremap((addr), (osz), (nsz), (mv))
#endif /* WIN32 */
#endif /* HAVE_MREMAP */

#define USE_MMAP_BIT (SIZE_T_ONE)

#define CALL_MMAP(s) MMAP_DEFAULT(s)
#define CALL_MUNMAP(a, s) MUNMAP_DEFAULT((a), (s))

#if HAVE_MMAP && HAVE_MREMAP
#ifdef MREMAP
#define CALL_MREMAP(addr, osz, nsz, mv) MREMAP((addr), (osz), (nsz), (mv))
#else /* MREMAP */
#define CALL_MREMAP(addr, osz, nsz, mv) \
  MREMAP_DEFAULT((addr), (osz), (nsz), (mv))
#endif /* MREMAP */
#else  /* HAVE_MMAP && HAVE_MREMAP */
#define CALL_MREMAP(addr, osz, nsz, mv) MFAIL
#endif /* HAVE_MMAP && HAVE_MREMAP */

#define EXTERN_BIT (8U)

#if !USE_LOCKS
#define USE_LOCK_BIT (0U)
#define INITIAL_LOCK(l) (0)
#define DESTROY_LOCK(l) (0)
#define ACQUIRE_MALLOC_GLOBAL_LOCK()
#define RELEASE_MALLOC_GLOBAL_LOCK()

#else
#if USE_LOCKS > 1

#elif USE_SPIN_LOCKS

#if defined(__GNUC__) && \
    (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 1))
#define CAS_LOCK(sl) __sync_lock_test_and_set(sl, 1)
#define CLEAR_LOCK(sl) __sync_lock_release(sl)

#elif (defined(__GNUC__) && (defined(__i386__) || defined(__x86_64__)))
static FORCEINLINE int x86_cas_lock(int* sl) {
  int ret;
  int val = 1;
  int cmp = 0;
  __asm__ __volatile__("lock; cmpxchgl %1, %2"
                       : "=a"(ret)
                       : "r"(val), "m"(*(sl)), "0"(cmp)
                       : "memory", "cc");
  return ret;
}

static FORCEINLINE void x86_clear_lock(int* sl) {
  assert(*sl != 0);
  int prev = 0;
  int ret;
  __asm__ __volatile__("lock; xchgl %0, %1"
                       : "=r"(ret)
                       : "m"(*(sl)), "0"(prev)
                       : "memory");
}

#define CAS_LOCK(sl) x86_cas_lock(sl)
#define CLEAR_LOCK(sl) x86_clear_lock(sl)

#else /* Win32 MSC */
#define CAS_LOCK(sl) interlockedexchange(sl, (LONG)1)
#define CLEAR_LOCK(sl) interlockedexchange(sl, (LONG)0)

#endif /* ... gcc spins locks ... */

#define SPINS_PER_YIELD 63
#if defined(_MSC_VER)
#define SLEEP_EX_DURATION 50 /* delay for yield/sleep */
#define SPIN_LOCK_YIELD SleepEx(SLEEP_EX_DURATION, FALSE)
#elif defined(__SVR4) && defined(__sun) /* solaris */
#define SPIN_LOCK_YIELD thr_yield();
#elif !defined(LACKS_SCHED_H)
#define SPIN_LOCK_YIELD sched_yield();
#else
#define SPIN_LOCK_YIELD
#endif /* ... yield ... */

#if !defined(USE_RECURSIVE_LOCKS) || USE_RECURSIVE_LOCKS == 0
static int spin_acquire_lock(int* sl) {
  int spins = 0;
  while (*(volatile int*)sl != 0 || CAS_LOCK(sl)) {
    if ((++spins & SPINS_PER_YIELD) == 0) {
      SPIN_LOCK_YIELD;
    }
  }
  return 0;
}

#define MLOCK_T int
#define TRY_LOCK(sl) !CAS_LOCK(sl)
#define RELEASE_LOCK(sl) CLEAR_LOCK(sl)
#define ACQUIRE_LOCK(sl) (CAS_LOCK(sl) ? spin_acquire_lock(sl) : 0)
#define INITIAL_LOCK(sl) (*sl = 0)
#define DESTROY_LOCK(sl) (0)
static MLOCK_T malloc_global_mutex = 0;

#else /* USE_RECURSIVE_LOCKS */
/* types for lock owners */
#ifdef WIN32
#define THREAD_ID_T DWORD
#define CURRENT_THREAD GetCurrentThreadId()
#define EQ_OWNER(X, Y) ((X) == (Y))
#else
#define THREAD_ID_T pthread_t
#define CURRENT_THREAD pthread_self()
#define EQ_OWNER(X, Y) pthread_equal(X, Y)
#endif

struct malloc_recursive_lock {
  int sl;
  unsigned int c;
  THREAD_ID_T threadid;
};

#define MLOCK_T struct malloc_recursive_lock
static MLOCK_T malloc_global_mutex = {0, 0, (THREAD_ID_T)0};

static FORCEINLINE void recursive_release_lock(MLOCK_T* lk) {
  assert(lk->sl != 0);
  if (--lk->c == 0) {
    CLEAR_LOCK(&lk->sl);
  }
}

static FORCEINLINE int recursive_acquire_lock(MLOCK_T* lk) {
  THREAD_ID_T mythreadid = CURRENT_THREAD;
  int spins = 0;
  for (;;) {
    if (*((volatile int*)(&lk->sl)) == 0) {
      if (!CAS_LOCK(&lk->sl)) {
        lk->threadid = mythreadid;
        lk->c = 1;
        return 0;
      }
    } else if (EQ_OWNER(lk->threadid, mythreadid)) {
      ++lk->c;
      return 0;
    }
    if ((++spins & SPINS_PER_YIELD) == 0) {
      SPIN_LOCK_YIELD;
    }
  }
}

static FORCEINLINE int recursive_try_lock(MLOCK_T* lk) {
  THREAD_ID_T mythreadid = CURRENT_THREAD;
  if (*((volatile int*)(&lk->sl)) == 0) {
    if (!CAS_LOCK(&lk->sl)) {
      lk->threadid = mythreadid;
      lk->c = 1;
      return 1;
    }
  } else if (EQ_OWNER(lk->threadid, mythreadid)) {
    ++lk->c;
    return 1;
  }
  return 0;
}

#define RELEASE_LOCK(lk) recursive_release_lock(lk)
#define TRY_LOCK(lk) recursive_try_lock(lk)
#define ACQUIRE_LOCK(lk) recursive_acquire_lock(lk)
#define INITIAL_LOCK(lk) \
  ((lk)->threadid = (THREAD_ID_T)0, (lk)->sl = 0, (lk)->c = 0)
#define DESTROY_LOCK(lk) (0)
#endif /* USE_RECURSIVE_LOCKS */

#elif defined(WIN32) /* Win32 critical sections */
#define MLOCK_T CRITICAL_SECTION
#define ACQUIRE_LOCK(lk) (EnterCriticalSection(lk), 0)
#define RELEASE_LOCK(lk) LeaveCriticalSection(lk)
#define TRY_LOCK(lk) TryEnterCriticalSection(lk)
#define INITIAL_LOCK(lk) \
  (!InitializeCriticalSectionAndSpinCount((lk), 0x80000000 | 4000))
#define DESTROY_LOCK(lk) (DeleteCriticalSection(lk), 0)
#define NEED_GLOBAL_LOCK_INIT

static MLOCK_T malloc_global_mutex;
static volatile LONG malloc_global_mutex_status;

/* Use spin loop to initialize global lock */
static void init_malloc_global_mutex() {
  for (;;) {
    long stat = malloc_global_mutex_status;
    if (stat > 0) return;
    /* transition to < 0 while initializing, then to > 0) */
    if (stat == 0 && interlockedcompareexchange(&malloc_global_mutex_status,
                                                (LONG)-1, (LONG)0) == 0) {
      InitializeCriticalSection(&malloc_global_mutex);
      interlockedexchange(&malloc_global_mutex_status, (LONG)1);
      return;
    }
    SleepEx(0, FALSE);
  }
}

#else /* pthreads-based locks */
#define MLOCK_T pthread_mutex_t
#define ACQUIRE_LOCK(lk) pthread_mutex_lock(lk)
#define RELEASE_LOCK(lk) pthread_mutex_unlock(lk)
#define TRY_LOCK(lk) (!pthread_mutex_trylock(lk))
#define INITIAL_LOCK(lk) pthread_init_lock(lk)
#define DESTROY_LOCK(lk) pthread_mutex_destroy(lk)

#if defined(USE_RECURSIVE_LOCKS) && USE_RECURSIVE_LOCKS != 0 && \
    defined(linux) && !defined(PTHREAD_MUTEX_RECURSIVE)
extern int pthread_mutexattr_setkind_np __P((pthread_mutexattr_t * __attr,
                                             int __kind));
#define PTHREAD_MUTEX_RECURSIVE PTHREAD_MUTEX_RECURSIVE_NP
#define pthread_mutexattr_settype(x, y) pthread_mutexattr_setkind_np(x, y)
#endif /* USE_RECURSIVE_LOCKS ... */

static MLOCK_T malloc_global_mutex = PTHREAD_MUTEX_INITIALIZER;

static int pthread_init_lock(MLOCK_T* lk) {
  pthread_mutexattr_t attr;
  if (pthread_mutexattr_init(&attr)) return 1;
#if defined(USE_RECURSIVE_LOCKS) && USE_RECURSIVE_LOCKS != 0
  if (pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)) return 1;
#endif
  if (pthread_mutex_init(lk, &attr)) return 1;
  if (pthread_mutexattr_destroy(&attr)) return 1;
  return 0;
}

#endif /* ... lock types ... */

#define USE_LOCK_BIT (2U)

#ifndef ACQUIRE_MALLOC_GLOBAL_LOCK
#define ACQUIRE_MALLOC_GLOBAL_LOCK() ACQUIRE_LOCK(&malloc_global_mutex);
#endif

#ifndef RELEASE_MALLOC_GLOBAL_LOCK
#define RELEASE_MALLOC_GLOBAL_LOCK() RELEASE_LOCK(&malloc_global_mutex);
#endif

#endif /* USE_LOCKS */

typedef struct malloc_chunk* sbinptr; /* The type of bins of chunks */

#define MCHUNK_SIZE (sizeof(mchunk))

#define MMAP_CHUNK_OVERHEAD (TWO_SIZE_T_SIZES + 2 * INT_SIZE)
#define MMAP_FOOT_PAD (FOUR_SIZE_T_SIZES)

#define MIN_CHUNK_SIZE ((MCHUNK_SIZE + CHUNK_ALIGN_MASK) & ~CHUNK_ALIGN_MASK)

#define MAX_REQUEST ((-MIN_CHUNK_SIZE) << 2)
#define MIN_REQUEST (MIN_CHUNK_SIZE - CHUNK_OVERHEAD - SIZE_T_ONE)

#define request2size(req) \
  (((req) < MIN_REQUEST) ? MIN_CHUNK_SIZE : pad_request(req))

#if MMAP_CLEARS
#define calloc_must_clear(p) (!is_mmapped(p))
#else /* MMAP_CLEARS */
#define calloc_must_clear(p) (1)
#endif /* MMAP_CLEARS */

typedef struct malloc_tree_chunk tchunk;
typedef struct malloc_tree_chunk* tchunkptr;

#define leftmost_child(t) ((t)->child[0] != 0 ? (t)->child[0] : (t)->child[1])

#define is_mmapped_segment(S) ((S)->sflags & USE_MMAP_BIT)
#define is_extern_segment(S) ((S)->sflags & EXTERN_BIT)
#define is_unused(S) ((S)->sflags & IS_UNUSED_BIT)

#define SMALLBIN_SHIFT (3U)
#define SMALLBIN_WIDTH (SIZE_T_ONE << SMALLBIN_SHIFT)
#define TREEBIN_SHIFT (8U)
#define MIN_LARGE_SIZE (SIZE_T_ONE << TREEBIN_SHIFT)
#define MAX_SMALL_SIZE (MIN_LARGE_SIZE - SIZE_T_ONE)
#define MAX_SMALL_REQUEST (MAX_SMALL_SIZE - CHUNK_ALIGN_MASK - CHUNK_OVERHEAD)

struct malloc_params {
  size_t magic;
  size_t page_size;
  size_t granularity;
  size_t mmap_threshold;
  size_t trim_threshold;
  flag_t default_mflags;
};

static struct malloc_params mparams;

#define ensure_initialization(m) (void)(mparams.magic != 0 || init_mparams(m))

#if !ONLY_MSPACES

/*static struct malloc_state _gm_;
#define gm                 (&_gm_)
#define is_global(M)       ((M) == &_gm_)*/

#endif /* !ONLY_MSPACES */

#define is_initialized(M) ((M)->top != 0)

#define use_lock(M) ((M)->mflags & USE_LOCK_BIT)
#define enable_lock(M) ((M)->mflags |= USE_LOCK_BIT)
#if USE_LOCKS
#define disable_lock(M) ((M)->mflags &= ~USE_LOCK_BIT)
#else
#define disable_lock(M)
#endif

#define use_mmap(M) ((M)->mflags & USE_MMAP_BIT)
#define enable_mmap(M) ((M)->mflags |= USE_MMAP_BIT)
#if HAVE_MMAP
#define disable_mmap(M) ((M)->mflags &= ~USE_MMAP_BIT)
#else
#define disable_mmap(M)
#endif

#define disable_contiguous(M) ((M)->mflags |= USE_NONCONTIGUOUS_BIT)

#define set_lock(M, L) \
  ((M)->mflags =       \
       (L) ? ((M)->mflags | USE_LOCK_BIT) : ((M)->mflags & ~USE_LOCK_BIT))

#define page_align(S) \
  (((S) + (mparams.page_size - SIZE_T_ONE)) & ~(mparams.page_size - SIZE_T_ONE))

#define granularity_align(S)                    \
  (((S) + (mparams.granularity - SIZE_T_ONE)) & \
   ~(mparams.granularity - SIZE_T_ONE))

#ifdef WIN32
#define mmap_align(S) granularity_align(S)
#else
#define mmap_align(S) page_align(S)
#endif

#define SYS_ALLOC_PADDING (TOP_FOOT_SIZE + MALLOC_ALIGNMENT)

#define is_page_aligned(S) \
  (((size_t)(S) & (mparams.page_size - SIZE_T_ONE)) == 0)
#define is_granularity_aligned(S) \
  (((size_t)(S) & (mparams.granularity - SIZE_T_ONE)) == 0)

static msegmentptr segment_holding(mstate m, char* addr) {
  msegmentptr sp = &m->seg;
  for (;;) {
    if (addr >= sp->base && addr < sp->base + sp->size) return sp;
    if ((sp = sp->next) == 0) return 0;
  }
}

static int has_segment_link(mstate m, msegmentptr ss) {
  msegmentptr sp = &m->seg;
  for (;;) {
    if (reinterpret_cast<char*>(sp) >= ss->base &&
        reinterpret_cast<char*>(sp) < ss->base + ss->size)
      return 1;
    if ((sp = sp->next) == 0) return 0;
  }
}

#ifndef MORECORE_CANNOT_TRIM
#define should_trim(M, s) ((s) > (M)->trim_check)
#else /* MORECORE_CANNOT_TRIM */
#define should_trim(M, s) (0)
#endif /* MORECORE_CANNOT_TRIM */

#define TOP_FOOT_SIZE                                                        \
  (align_offset(chunk2mem(0)) + pad_request(sizeof(struct malloc_segment)) + \
   MIN_CHUNK_SIZE)

#if USE_LOCKS
#define PREACTION(M) ((use_lock(M)) ? ACQUIRE_LOCK(&(M)->mutex) : 0)
#define POSTACTION(M)                           \
  {                                             \
    if (use_lock(M)) RELEASE_LOCK(&(M)->mutex); \
  }
#else /* USE_LOCKS */

#ifndef PREACTION
#endif /* PREACTION */

#ifndef POSTACTION
#define POSTACTION(M)
#endif /* POSTACTION */

#endif /* USE_LOCKS */

#if PROCEED_ON_ERROR

int malloc_corruption_error_count;

static void reset_on_error(mstate m);

#define CORRUPTION_ERROR_ACTION(m) reset_on_error(m)
#define USAGE_ERROR_ACTION(m, p)

#else /* PROCEED_ON_ERROR */

__attribute__((always_inline)) void js_allocate_abort(mstate m, mchunkptr p) {
#if defined(ANDROID) || defined(__ANDROID__)
  if (p != NULL) {
    __android_log_print(ANDROID_LOG_FATAL, "PRIMJS_ALLOCATE",
                        "usage error!p:%p, top:%zu, topsize:%zu,dv:%zu, "
                        "dvsize:%zu, footprint:%zu, max_footprint:%zu "
                        "\n",
                        p, (uintptr_t)m->top, m->topsize, (uintptr_t)m->dv,
                        m->dvsize, m->footprint, m->max_footprint);
  } else {
    __android_log_print(ANDROID_LOG_FATAL, "PRIMJS_ALLOCATE",
                        "corruption error!");
    __android_log_print(ANDROID_LOG_FATAL, "PRIMJS_ALLOCATE",
                        "corruption error!top:%zu, topsize:%zu,dv:%zu, "
                        "dvsize:%zu, footprint:%zu, max_footprint:%zu "
                        "\n",
                        (uintptr_t)m->top, m->topsize, (uintptr_t)m->dv,
                        m->dvsize, m->footprint, m->max_footprint);
  }
#else
  abort();
#endif
}

#ifndef CORRUPTION_ERROR_ACTION
#define CORRUPTION_ERROR_ACTION(m) js_allocate_abort(m, NULL)
#endif /* CORRUPTION_ERROR_ACTION */

#ifndef USAGE_ERROR_ACTION
#define USAGE_ERROR_ACTION(m, p) js_allocate_abort(m, p)
#endif /* USAGE_ERROR_ACTION */

#endif /* PROCEED_ON_ERROR */

#if !DEBUG

#define check_free_chunk(M, P)
#define check_inuse_chunk(M, P)
#define check_malloced_chunk(M, P, N)
#define check_mmapped_chunk(M, P)
#define check_malloc_state(M)
#define check_top_chunk(M, P)

#else /* DEBUG */
#define check_free_chunk(M, P) do_check_free_chunk(M, P)
#define check_inuse_chunk(M, P) do_check_inuse_chunk(M, P)
#define check_top_chunk(M, P) do_check_top_chunk(M, P)
#define check_malloced_chunk(M, P, N) do_check_malloced_chunk(M, P, N)
#define check_mmapped_chunk(M, P) do_check_mmapped_chunk(M, P)
#define check_malloc_state(M) do_check_malloc_state(M)

static void do_check_any_chunk(mstate m, mchunkptr p);
static void do_check_top_chunk(mstate m, mchunkptr p);
static void do_check_mmapped_chunk(mstate m, mchunkptr p);
static void do_check_inuse_chunk(mstate m, mchunkptr p);
static void do_check_free_chunk(mstate m, mchunkptr p);
static void do_check_malloced_chunk(mstate m, void* mem, size_t s);
static void do_check_tree(mstate m, tchunkptr t);
static void do_check_treebin(mstate m, bindex_t i);
static void do_check_smallbin(mstate m, bindex_t i);
static void do_check_malloc_state(mstate m);
static int bin_find(mstate m, mchunkptr x);
static size_t traverse_and_check(mstate m);
#endif /* DEBUG */

#define is_small(s) (((s) >> SMALLBIN_SHIFT) < NSMALLBINS)
#define small_index(s) (bindex_t)((s) >> SMALLBIN_SHIFT)
#define small_index2size(i) ((i) << SMALLBIN_SHIFT)
#define MIN_SMALL_INDEX (small_index(MIN_CHUNK_SIZE))

/* addressing by index. See above about smallbin repositioning */
#define smallbin_at(M, i) ((sbinptr)((char*)&((M)->smallbins[(i) << 1])))
#define local_smallbin_at(M, i, local_i) \
  ((sbinptr)((char*)&((M)->local_smallbins[local_i][(i) << 1])))
#define treebin_at(M, i) (&((M)->treebins[i]))
#define local_treebin_at(M, i, idx) (&((M)->local_treebins[idx][i]))

/* assign tree index for size S to variable I. Use x86 asm if possible  */
#if defined(__GNUC__) && (defined(__i386__) || defined(__x86_64__))
#define compute_tree_index(S, I)                                               \
  {                                                                            \
    unsigned int X = S >> TREEBIN_SHIFT;                                       \
    if (X == 0) {                                                              \
      I = 0;                                                                   \
    } else if (X > 0xFFFF) {                                                   \
      I = NTREEBINS - 1;                                                       \
    } else {                                                                   \
      unsigned int K =                                                         \
          (unsigned)sizeof(X) * __CHAR_BIT__ - 1 - (unsigned)__builtin_clz(X); \
      I = (bindex_t)((K << 1) + ((S >> (K + (TREEBIN_SHIFT - 1)) & 1)));       \
    }                                                                          \
  }

#elif defined(__INTEL_COMPILER)
#define compute_tree_index(S, I)                                         \
  {                                                                      \
    size_t X = S >> TREEBIN_SHIFT;                                       \
    if (X == 0) {                                                        \
      I = 0;                                                             \
    } else if (X > 0xFFFF) {                                             \
      I = NTREEBINS - 1;                                                 \
    } else {                                                             \
      unsigned int K = _bit_scan_reverse(X);                             \
      I = (bindex_t)((K << 1) + ((S >> (K + (TREEBIN_SHIFT - 1)) & 1))); \
    }                                                                    \
  }

#elif defined(_MSC_VER) && _MSC_VER >= 1300
#define compute_tree_index(S, I)                                         \
  {                                                                      \
    size_t X = S >> TREEBIN_SHIFT;                                       \
    if (X == 0) {                                                        \
      I = 0;                                                             \
    } else if (X > 0xFFFF) {                                             \
      I = NTREEBINS - 1;                                                 \
    } else {                                                             \
      unsigned int K;                                                    \
      _BitScanReverse((DWORD*)&K, (DWORD)X);                             \
      I = (bindex_t)((K << 1) + ((S >> (K + (TREEBIN_SHIFT - 1)) & 1))); \
    }                                                                    \
  }

#else /* GNUC */
#define compute_tree_index(S, I)                             \
  {                                                          \
    size_t X = S >> TREEBIN_SHIFT;                           \
    if (X == 0) {                                            \
      I = 0;                                                 \
    } else if (X > 0xFFFF) {                                 \
      I = NTREEBINS - 1;                                     \
    } else {                                                 \
      unsigned int Y = (unsigned int)X;                      \
      unsigned int N = ((Y - 0x100) >> 16) & 8;              \
      unsigned int K = (((Y <<= N) - 0x1000) >> 16) & 4;     \
      N += K;                                                \
      N += K = (((Y <<= K) - 0x4000) >> 16) & 2;             \
      K = 14 - N + ((Y <<= K) >> 15);                        \
      I = (K << 1) + ((S >> (K + (TREEBIN_SHIFT - 1)) & 1)); \
    }                                                        \
  }
#endif /* GNUC */

#define bit_for_tree_index(i) \
  (i == NTREEBINS - 1) ? (SIZE_T_BITSIZE - 1) : (((i) >> 1) + TREEBIN_SHIFT - 2)

#define leftshift_for_tree_index(i) \
  ((i == NTREEBINS - 1)             \
       ? 0                          \
       : ((SIZE_T_BITSIZE - SIZE_T_ONE) - (((i) >> 1) + TREEBIN_SHIFT - 2)))

#define minsize_for_tree_index(i)                 \
  ((SIZE_T_ONE << (((i) >> 1) + TREEBIN_SHIFT)) | \
   (((size_t)((i) & SIZE_T_ONE)) << (((i) >> 1) + TREEBIN_SHIFT - 1)))

#define idx2bit(i) ((binmap_t)(1) << (i))

#define mark_smallmap(M, i) ((M)->smallmap |= idx2bit(i))
#define local_mark_smallmap(M, i, local_i) \
  ((M)->local_smallmap[local_i] |= idx2bit(i))
#define clear_smallmap(M, i) ((M)->smallmap &= ~idx2bit(i))
#define local_clear_smallmap(M, i, local_i) \
  ((M)->smallmap[local_i] &= ~idx2bit(i))
#define smallmap_is_marked(M, i) ((M)->smallmap & idx2bit(i))
#define local_smallmap_is_marked(M, i, local_i) \
  ((M)->local_smallmap[local_i] & idx2bit(i))

#define mark_treemap(M, i) ((M)->treemap |= idx2bit(i))
#define local_mark_treemap(M, i, local_i) \
  ((M)->local_treemap[local_i] |= idx2bit(i))
#define clear_treemap(M, i) ((M)->treemap &= ~idx2bit(i))
#define local_clear_treemap(M, i, local_i) \
  ((M)->local_treemap[local_i] &= ~idx2bit(i))
#define treemap_is_marked(M, i) ((M)->treemap & idx2bit(i))
#define local_treemap_is_marked(M, i, local_i) \
  ((M)->local_treemap[local_i] & idx2bit(i))

#define least_bit(x) ((x) & -(x))

#define left_bits(x) ((x << 1) | -(x << 1))

#define same_or_left_bits(x) ((x) | -(x))

#if defined(__GNUC__) && (defined(__i386__) || defined(__x86_64__))
#define compute_bit2idx(X, I) \
  {                           \
    unsigned int J;           \
    J = __builtin_ctz(X);     \
    I = (bindex_t)J;          \
  }

#elif defined(__INTEL_COMPILER)
#define compute_bit2idx(X, I) \
  {                           \
    unsigned int J;           \
    J = _bit_scan_forward(X); \
    I = (bindex_t)J;          \
  }

#elif defined(_MSC_VER) && _MSC_VER >= 1300
#define compute_bit2idx(X, I)       \
  {                                 \
    unsigned int J;                 \
    _BitScanForward((DWORD*)&J, X); \
    I = (bindex_t)J;                \
  }

#elif USE_BUILTIN_FFS
#define compute_bit2idx(X, I) I = ffs(X) - 1

#else
#define compute_bit2idx(X, I)            \
  {                                      \
    unsigned int Y = X - 1;              \
    unsigned int K = Y >> (16 - 4) & 16; \
    unsigned int N = K;                  \
    Y >>= K;                             \
    N += K = Y >> (8 - 3) & 8;           \
    Y >>= K;                             \
    N += K = Y >> (4 - 2) & 4;           \
    Y >>= K;                             \
    N += K = Y >> (2 - 1) & 2;           \
    Y >>= K;                             \
    N += K = Y >> (1 - 0) & 1;           \
    Y >>= K;                             \
    I = (bindex_t)(N + Y);               \
  }
#endif /* GNUC */

#if !INSECURE
#define ok_address(M, a) ((char*)(a) >= (M)->least_addr)
#define ok_next(p, n) ((char*)(p) < (char*)(n))
#define ok_inuse(p) is_inuse(p)
#define ok_pinuse(p) pinuse(p)

#else /* !INSECURE */
#define ok_address(M, a) (1)
#define ok_next(b, n) (1)
#define ok_inuse(p) (1)
#define ok_pinuse(p) (1)
#endif /* !INSECURE */

#if (FOOTERS && !INSECURE)
/* Check if (alleged) mstate m has expected magic field */
#define ok_magic(M) ((M)->magic == mparams.magic)
#else /* (FOOTERS && !INSECURE) */
#define ok_magic(M) (1)
#endif /* (FOOTERS && !INSECURE) */

#if !INSECURE
#if defined(__GNUC__) && __GNUC__ >= 3
#define RTCHECK(e) __builtin_expect(e, 1)
#else /* GNUC */
#define RTCHECK(e) (e)
#endif /* GNUC */
#else  /* !INSECURE */
#define RTCHECK(e) (1)
#endif /* !INSECURE */

#if !FOOTERS

#define mark_inuse_foot(M, p, s)

#define set_inuse(M, p, s)                                  \
  ((p)->head = (((p)->head & PINUSE_BIT) | s | CINUSE_BIT), \
   ((mchunkptr)(((char*)(p)) + (s)))->head |= PINUSE_BIT)

#define set_inuse_and_pinuse(M, p, s)         \
  ((p)->head = (s | PINUSE_BIT | CINUSE_BIT), \
   ((mchunkptr)(((char*)(p)) + (s)))->head |= PINUSE_BIT)

#define set_size_and_pinuse_of_inuse_chunk(M, p, s) \
  ((p)->head = (s | PINUSE_BIT | CINUSE_BIT))

#else /* FOOTERS */

#define mark_inuse_foot(M, p, s) \
  (((mchunkptr)((char*)(p) + (s)))->prev_foot = ((size_t)(M) ^ mparams.magic))

#define get_mstate_for(p)                                           \
  ((mstate)(((mchunkptr)((char*)(p) + (chunksize(p))))->prev_foot ^ \
            mparams.magic))

#define set_inuse(M, p, s)                                  \
  ((p)->head = (((p)->head & PINUSE_BIT) | s | CINUSE_BIT), \
   (((mchunkptr)(((char*)(p)) + (s)))->head |= PINUSE_BIT), \
   mark_inuse_foot(M, p, s))

#define set_inuse_and_pinuse(M, p, s)                       \
  ((p)->head = (s | PINUSE_BIT | CINUSE_BIT),               \
   (((mchunkptr)(((char*)(p)) + (s)))->head |= PINUSE_BIT), \
   mark_inuse_foot(M, p, s))

#define set_size_and_pinuse_of_inuse_chunk(M, p, s) \
  ((p)->head = (s | PINUSE_BIT | CINUSE_BIT), mark_inuse_foot(M, p, s))

#endif /* !FOOTERS */

#if LOCK_AT_FORK
static void pre_fork(void) { ACQUIRE_LOCK(&(gm)->mutex); }
static void post_fork_parent(void) { RELEASE_LOCK(&(gm)->mutex); }
static void post_fork_child(void) { INITIAL_LOCK(&(gm)->mutex); }
#endif /* LOCK_AT_FORK */

static int init_mparams(mstate m) {
#ifdef NEED_GLOBAL_LOCK_INIT
  if (malloc_global_mutex_status <= 0) init_malloc_global_mutex();
#endif

  if (mparams.magic == 0) {
    size_t magic;
    size_t psize;
    size_t gsize;

#ifndef WIN32
    psize = malloc_getpagesize;
    gsize = DEFAULT_GRANULARITY;
#else  /* WIN32 */
    {
      SYSTEM_INFO system_info;
      GetSystemInfo(&system_info);
      psize = system_info.dwPageSize;
      gsize =
          ((DEFAULT_GRANULARITY != 0) ? DEFAULT_GRANULARITY
                                      : system_info.dwAllocationGranularity);
    }
#endif /* WIN32 */

    if ((sizeof(size_t) != sizeof(char*)) || (MAX_SIZE_T < MIN_CHUNK_SIZE) ||
        (sizeof(int) < 4) || (MALLOC_ALIGNMENT < (size_t)8U) ||
        ((MALLOC_ALIGNMENT & (MALLOC_ALIGNMENT - SIZE_T_ONE)) != 0) ||
        ((MCHUNK_SIZE & (MCHUNK_SIZE - SIZE_T_ONE)) != 0) ||
        ((gsize & (gsize - SIZE_T_ONE)) != 0) ||
        ((psize & (psize - SIZE_T_ONE)) != 0)) {
#if defined(ANDROID) || defined(__ANDROID__)
      __android_log_print(ANDROID_LOG_FATAL, "PRIMJS_ALLOCATE",
                          "Sanity-check failed");
#else
      ABORT;
#endif
    }
    mparams.granularity = gsize;
    mparams.page_size = psize;
    mparams.mmap_threshold = DEFAULT_MMAP_THRESHOLD;
    mparams.trim_threshold = DEFAULT_TRIM_THRESHOLD;
    mparams.default_mflags = USE_LOCK_BIT | USE_MMAP_BIT;

#if !ONLY_MSPACES
    m->mflags = mparams.default_mflags;
    (void)INITIAL_LOCK(&m->mutex);
#endif
#if LOCK_AT_FORK
    pthread_atfork(&pre_fork, &post_fork_parent, &post_fork_child);
#endif

    {
#if USE_DEV_RANDOM
      int fd;
      unsigned char buf[sizeof(size_t)];
      /* Try to use /dev/urandom, else fall back on using time */
      if ((fd = open("/dev/urandom", O_RDONLY)) >= 0 &&
          read(fd, buf, sizeof(buf)) == sizeof(buf)) {
        magic = *((size_t*)buf);
        close(fd);
      } else
#endif /* USE_DEV_RANDOM */
#ifdef WIN32
        magic = (size_t)(GetTickCount() ^ (size_t)0x55555555U);
#elif defined(LACKS_TIME_H)
      magic = (size_t)&magic ^ (size_t)0x55555555U;
#else
      magic = (size_t)(time(0) ^ (size_t)0x55555555U);
#endif
      magic |= (size_t)8U;  /* ensure nonzero */
      magic &= ~(size_t)7U; /* improve chances of fault for bad values */
      (*(volatile size_t*)(&(mparams.magic))) = magic;
    }
  }

  RELEASE_MALLOC_GLOBAL_LOCK();
  return 1;
}

#if DEBUG

static void do_check_any_chunk(mstate m, mchunkptr p) {
  assert((is_aligned(chunk2mem(p))) || (p->head == FENCEPOST_HEAD));
  assert(ok_address(m, p));
}

static void do_check_top_chunk(mstate m, mchunkptr p) {
  msegmentptr sp = segment_holding(m, reinterpret_cast<char*>(p));
  size_t sz = p->head & ~INUSE_BITS; /* third-lowest bit can be set! */
  assert(sp != 0);
  assert((is_aligned(chunk2mem(p))) || (p->head == FENCEPOST_HEAD));
  assert(ok_address(m, p));
  assert(sz == m->topsize);
  assert(sz > 0);
  assert(sz ==
         ((sp->base + sp->size) - reinterpret_cast<char*>(p)) - TOP_FOOT_SIZE);
  assert(pinuse(p));
  assert(!pinuse(chunk_plus_offset(p, sz)));
}

static void do_check_mmapped_chunk(mstate m, mchunkptr p) {
  size_t sz = chunksize(p);
  size_t len = (sz + (p->prev_foot) + MMAP_FOOT_PAD);
  assert(is_mmapped(p));
  assert(use_mmap(m));
  assert((is_aligned(chunk2mem(p))) || (p->head == FENCEPOST_HEAD));
  assert(ok_address(m, p));
  assert(!is_small(sz));
  assert((len & (mparams.page_size - SIZE_T_ONE)) == 0);
  assert(chunk_plus_offset(p, sz)->head == FENCEPOST_HEAD);
  assert(chunk_plus_offset(p, sz + SIZE_T_SIZE)->head == 0);
}

static void do_check_inuse_chunk(mstate m, mchunkptr p) {
  do_check_any_chunk(m, p);
  assert(is_inuse(p));
  assert(next_pinuse(p));
  /* If not pinuse and not mmapped, previous chunk has OK offset */
  assert(is_mmapped(p) || pinuse(p) || next_chunk(prev_chunk(p)) == p);
  if (is_mmapped(p)) do_check_mmapped_chunk(m, p);
}

static void do_check_free_chunk(mstate m, mchunkptr p) {
  size_t sz = chunksize(p);
  mchunkptr next = chunk_plus_offset(p, sz);
  do_check_any_chunk(m, p);
  assert(!is_inuse(p));
  assert(!next_pinuse(p));
  assert(!is_mmapped(p));
  if (p != m->dv && p != m->top) {
    if (sz >= MIN_CHUNK_SIZE) {
      assert((sz & CHUNK_ALIGN_MASK) == 0);
      assert(is_aligned(chunk2mem(p)));
      assert(next->prev_foot == sz);
      assert(pinuse(p));
      assert(next == m->top || is_inuse(next));
      assert(p->fd->bk == p);
      assert(p->bk->fd == p);
    } else { /* markers are always of size SIZE_T_SIZE */
      assert(sz == SIZE_T_SIZE);
    }
  }
}

static void do_check_malloced_chunk(mstate m, void* mem, size_t s) {
  if (mem != 0) {
    mchunkptr p = mem2chunk(mem);
    size_t sz = p->head & ~INUSE_BITS;
    do_check_inuse_chunk(m, p);
    assert((sz & CHUNK_ALIGN_MASK) == 0);
    assert(sz >= MIN_CHUNK_SIZE);
    assert(sz >= s);
    /* unless mmapped, size is less than MIN_CHUNK_SIZE more than request */
    assert(is_mmapped(p) || sz < (s + MIN_CHUNK_SIZE));
  }
}

static void do_check_tree(mstate m, tchunkptr t) {
  tchunkptr head = 0;
  tchunkptr u = t;
  bindex_t tindex = t->index;
  size_t tsize = chunksize(t);
  bindex_t idx;
  compute_tree_index(tsize, idx);
  assert(tindex == idx);
  assert(tsize >= MIN_LARGE_SIZE);
  assert(tsize >= minsize_for_tree_index(idx));
  assert((idx == NTREEBINS - 1) || (tsize < minsize_for_tree_index((idx + 1))));

  do { /* traverse through chain of same-sized nodes */
    do_check_any_chunk(m, ((mchunkptr)u));
    assert(u->index == tindex);
    assert(chunksize(u) == tsize);
    assert(!is_inuse(u));
    assert(!next_pinuse(u));
    assert(u->fd->bk == u);
    assert(u->bk->fd == u);
    if (u->parent == 0) {
      assert(u->child[0] == 0);
      assert(u->child[1] == 0);
    } else {
      assert(head == 0); /* only one node on chain has parent */
      head = u;
      assert(u->parent != u);
      assert(u->parent->child[0] == u || u->parent->child[1] == u ||
             *(reinterpret_cast<tbinptr*>(u->parent)) == u);
      if (u->child[0] != 0) {
        assert(u->child[0]->parent == u);
        assert(u->child[0] != u);
        do_check_tree(m, u->child[0]);
      }
      if (u->child[1] != 0) {
        assert(u->child[1]->parent == u);
        assert(u->child[1] != u);
        do_check_tree(m, u->child[1]);
      }
      if (u->child[0] != 0 && u->child[1] != 0) {
        assert(chunksize(u->child[0]) < chunksize(u->child[1]));
      }
    }
    u = u->fd;
  } while (u != t);
  assert(head != 0);
}

static void do_check_treebin(mstate m, bindex_t i) {
  tbinptr* tb = treebin_at(m, i);
  tchunkptr t = *tb;
  int empty = (m->treemap & (1U << i)) == 0;
  if (t == 0) assert(empty);
  if (!empty) do_check_tree(m, t);
}

static void do_check_smallbin(mstate m, bindex_t i) {
  sbinptr b = smallbin_at(m, i);
  mchunkptr p = b->bk;
  unsigned int empty = (m->smallmap & (1U << i)) == 0;
  if (p == b) assert(empty);
  if (!empty) {
    for (; p != b; p = p->bk) {
      size_t size = chunksize(p);
      mchunkptr q;
      /* each chunk claims to be free */
      do_check_free_chunk(m, p);
      /* chunk belongs in bin */
      assert(small_index(size) == i);
      assert(p->bk == b || chunksize(p->bk) == chunksize(p));
      /* chunk is followed by an inuse chunk */
      q = next_chunk(p);
      if (q->head != FENCEPOST_HEAD) do_check_inuse_chunk(m, q);
    }
  }
}

static int bin_find(mstate m, mchunkptr x) {
  size_t size = chunksize(x);
  if (is_small(size)) {
    bindex_t sidx = small_index(size);
    sbinptr b = smallbin_at(m, sidx);
    if (smallmap_is_marked(m, sidx)) {
      mchunkptr p = b;
      do {
        if (p == x) return 1;
      } while ((p = p->fd) != b);
    }
  } else {
    bindex_t tidx;
    compute_tree_index(size, tidx);
    if (treemap_is_marked(m, tidx)) {
      tchunkptr t = *treebin_at(m, tidx);
      size_t sizebits = size << leftshift_for_tree_index(tidx);
      while (t != 0 && chunksize(t) != size) {
        t = t->child[(sizebits >> (SIZE_T_BITSIZE - SIZE_T_ONE)) & 1];
        sizebits <<= 1;
      }
      if (t != 0) {
        tchunkptr u = t;
        do {
          if (u == (tchunkptr)x) return 1;
        } while ((u = u->fd) != t);
      }
    }
  }
  return 0;
}

static size_t traverse_and_check(mstate m) {
  size_t sum = 0;
  if (is_initialized(m)) {
    msegmentptr s = &m->seg;
    sum += m->topsize + TOP_FOOT_SIZE;
    while (s != 0) {
      mchunkptr q = align_as_chunk(s->base);
      mchunkptr lastq = 0;
      assert(pinuse(q));
      while (segment_holds(s, q) && q != m->top && q->head != FENCEPOST_HEAD) {
        sum += chunksize(q);
        if (is_inuse(q)) {
          assert(!bin_find(m, q));
          do_check_inuse_chunk(m, q);
        } else {
          assert(q == m->dv || bin_find(m, q));
          assert(lastq == 0 || is_inuse(lastq)); /* Not 2 consecutive free */
          do_check_free_chunk(m, q);
        }
        lastq = q;
        q = next_chunk(q);
      }
      s = s->next;
    }
  }
  return sum;
}

static void do_check_malloc_state(mstate m) {
  bindex_t i;
  size_t total;
  /* check bins */
  for (i = 0; i < NSMALLBINS; ++i) do_check_smallbin(m, i);
  for (i = 0; i < NTREEBINS; ++i) do_check_treebin(m, i);

  if (m->dvsize != 0) { /* check dv chunk */
    do_check_any_chunk(m, m->dv);
    assert(m->dvsize == chunksize(m->dv));
    assert(m->dvsize >= MIN_CHUNK_SIZE);
    assert(bin_find(m, m->dv) == 0);
  }

  if (m->top != 0) { /* check top chunk */
    do_check_top_chunk(m, m->top);
    /*assert(m->topsize == chunksize(m->top)); redundant */
    assert(m->topsize > 0);
    assert(bin_find(m, m->top) == 0);
  }

  total = traverse_and_check(m);
  assert(total <= m->footprint);
  assert(m->footprint <= m->max_footprint);
}
#endif /* DEBUG */

#if !NO_MALLINFO
static struct mallinfo internal_mallinfo(mstate m) {
  struct mallinfo nm = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  ensure_initialization(m);

  check_malloc_state(m);
  if (is_initialized(m)) {
    size_t nfree = SIZE_T_ONE; /* top always free */
    size_t mfree = m->topsize + TOP_FOOT_SIZE;
    size_t sum = mfree;
    msegmentptr s = &m->seg;
    while (s != 0) {
      mchunkptr q = align_as_chunk(s->base);
      while (segment_holds(s, q) && q != m->top && q->head != FENCEPOST_HEAD) {
        size_t sz = chunksize(q);
        sum += sz;
        if (!is_inuse(q)) {
          mfree += sz;
          ++nfree;
        }
        q = next_chunk(q);
      }
      s = s->next;
    }

    nm.arena = sum;
    nm.ordblks = nfree;
    nm.hblkhd = m->footprint - sum;
    nm.usmblks = m->max_footprint;
    nm.uordblks = m->footprint - mfree;
    nm.fordblks = mfree;
    nm.keepcost = m->topsize;
  }

  POSTACTION(m);

  return nm;
}
#endif /* !NO_MALLINFO */

#if !NO_MALLOC_STATS
static void internal_malloc_stats(mstate m) {
  ensure_initialization(m);
  size_t maxfp = 0;
  size_t fp = 0;
  size_t used = 0;
  check_malloc_state(m);
  if (is_initialized(m)) {
    msegmentptr s = &m->seg;
    maxfp = m->max_footprint;
    fp = m->footprint;
    used = fp - (m->topsize + TOP_FOOT_SIZE);

    while (s != 0) {
      mchunkptr q = align_as_chunk(s->base);
      while (segment_holds(s, q) && q != m->top && q->head != FENCEPOST_HEAD) {
        if (!is_inuse(q)) used -= chunksize(q);
        q = next_chunk(q);
      }
      s = s->next;
    }
  }
  POSTACTION(m); /* drop lock */
  fprintf(stderrout, "max system bytes = %10lu\n", (unsigned long)(maxfp));
  fprintf(stderrout, "system bytes     = %10lu\n", (unsigned long)(fp));
  fprintf(stderrout, "in use bytes     = %10lu\n", (unsigned long)(used));
}
#endif /* NO_MALLOC_STATS */

__attribute__((always_inline)) void insert_small_chunk(mstate m,
                                                       mchunkptr mchunk,
                                                       size_t size) {
  bindex_t idx = small_index(size);
  mchunkptr next = smallbin_at(m, idx);
  mchunkptr prev = next;
  assert(size >= MIN_CHUNK_SIZE);
  if (!smallmap_is_marked(m, idx))
    mark_smallmap(m, idx);
  else if (RTCHECK(ok_address(m, next->fd))) {
    prev = next->fd;
  } else {
    CORRUPTION_ERROR_ACTION(m);
  }
  next->fd = mchunk;
  prev->bk = mchunk;
  mchunk->fd = prev;
  mchunk->bk = next;
}

__attribute__((always_inline)) void local_insert_small_chunk(mstate m,
                                                             mchunkptr mchunk,
                                                             size_t size,
                                                             int local_idx) {
  bindex_t idx = small_index(size);
  mchunkptr next = local_smallbin_at(m, idx, local_idx);
  mchunkptr prev = next;
  assert(size >= MIN_CHUNK_SIZE);
  if (!local_smallmap_is_marked(m, idx, local_idx)) {
    local_mark_smallmap(m, idx, local_idx);
  } else if (RTCHECK(ok_address(m, next->fd))) {
    prev = next->fd;
  } else {
    CORRUPTION_ERROR_ACTION(m);
  }
  next->fd = mchunk;
  prev->bk = mchunk;
  mchunk->fd = prev;
  mchunk->bk = next;
}

/* Unlink a chunk from a smallbin  */
__attribute__((always_inline)) void unlink_small_chunk(mstate m,
                                                       mchunkptr mchunk,
                                                       size_t size) {
  mchunkptr prev = mchunk->fd;
  mchunkptr next = mchunk->bk;
  bindex_t idx = small_index(size);
  assert(mchunk != next);
  assert(mchunk != prev);
  assert(chunksize(mchunk) == small_index2size(idx));
  if (RTCHECK(prev == smallbin_at(m, idx) ||
              (ok_address(m, prev) && prev->bk == mchunk))) {
    if (next == prev) {
      clear_smallmap(m, idx);
    } else if (RTCHECK(next == smallbin_at(m, idx) ||
                       (ok_address(m, next) && next->fd == mchunk))) {
      prev->bk = next;
      next->fd = prev;
    } else {
#if defined(ANDROID) || defined(__ANDROID__)
      __android_log_print(ANDROID_LOG_ERROR, "PRIMJS_ALLOCATE",
                          "====unlink_small_chunk  next:%p, prev:%p"
                          "ok_address(m, next):%d, next->fd == mchunk:%d\n",
                          next, prev, ok_address(m, next), next->fd == mchunk);
#endif
      CORRUPTION_ERROR_ACTION(m);
    }
  } else {
#if defined(ANDROID) || defined(__ANDROID__)
    __android_log_print(
        ANDROID_LOG_ERROR, "PRIMJS_ALLOCATE",
        "====unlink_small_chunk  ok_address(m, prev):%d, prev->bk == "
        "mchunk:%d\n",
        ok_address(m, prev), prev->bk == mchunk);
#endif
    CORRUPTION_ERROR_ACTION(m);
  }
}

__attribute__((always_inline)) void unlink_first_small_chunk(mstate m,
                                                             mchunkptr next,
                                                             mchunkptr mchunk,
                                                             bindex_t idx) {
  mchunkptr prev = mchunk->fd;
  assert(mchunk != next);
  assert(mchunk != prev);
  assert(chunksize(mchunk) == small_index2size(idx));
  if (next == prev) {
    clear_smallmap(m, idx);
  } else if (RTCHECK(ok_address(m, prev) && prev->bk == mchunk)) {
    prev->bk = next;
    next->fd = prev;
  } else {
#if defined(ANDROID) || defined(__ANDROID__)
    __android_log_print(ANDROID_LOG_ERROR, "PRIMJS_ALLOCATE",
                        "====unlink_first_small_chunk  next:%p, prev:%p"
                        "ok_address(m, prev):%d, prev->bk == mchunk:%d\n",
                        next, prev, ok_address(m, prev), prev->bk == mchunk);
#endif
    CORRUPTION_ERROR_ACTION(m);
  }
}

__attribute__((always_inline)) void replace_dv(mstate m, mchunkptr mchunk,
                                               size_t size) {
  size_t DVS = m->dvsize;
  assert(is_small(DVS));
  if (DVS != 0) {
    mchunkptr DV = m->dv;
    insert_small_chunk(m, DV, DVS);
  }
  m->dvsize = size;
  m->dv = mchunk;
}

__attribute__((always_inline)) void insert_large_chunk(mstate m,
                                                       tchunkptr tchunkx,
                                                       size_t size) {
  tbinptr* tbin;
  bindex_t idx;
  compute_tree_index(size, idx);
  tbin = treebin_at(m, idx);

  tchunkx->index = idx;
  tchunkx->child[0] = tchunkx->child[1] = 0;
  if (!treemap_is_marked(m, idx)) {
    mark_treemap(m, idx);
    *tbin = tchunkx;
    tchunkx->parent = (tchunkptr)tbin;
    tchunkx->fd = tchunkx->bk = tchunkx;
  } else {
    tchunkptr tchunkt = *tbin;
    size_t K = size << leftshift_for_tree_index(idx);
    for (;;) {
      if (chunksize(tchunkt) != size) {
        tchunkptr* C =
            &(tchunkt->child[(K >> (SIZE_T_BITSIZE - SIZE_T_ONE)) & 1]);
        K <<= 1;
        if (*C != 0) {
          tchunkt = *C;
        } else if (RTCHECK(ok_address(m, C))) {
          *C = tchunkx;
          tchunkx->parent = tchunkt;
          tchunkx->fd = tchunkx->bk = tchunkx;
          break;
        } else {
          CORRUPTION_ERROR_ACTION(m);
          break;
        }
      } else {
        tchunkptr prev = tchunkt->fd;
        if (RTCHECK(ok_address(m, tchunkt) && ok_address(m, prev))) {
          tchunkt->fd = prev->bk = tchunkx;
          tchunkx->fd = prev;
          tchunkx->bk = tchunkt;
          tchunkx->parent = 0;
          break;
        } else {
#if defined(ANDROID) || defined(__ANDROID__)
          __android_log_print(
              ANDROID_LOG_ERROR, "PRIMJS_ALLOCATE",
              "====insert_large_chunk  ok_address(m, tchunkt):%d, "
              "ok_address(m, prev):%d\n",
              ok_address(m, tchunkt), ok_address(m, prev));
#endif
          CORRUPTION_ERROR_ACTION(m);
          break;
        }
      }
    }
  }
}

__attribute__((always_inline)) void local_insert_large_chunk(mstate m,
                                                             tchunkptr tchunkx,
                                                             size_t size,
                                                             int local_idx) {
  tbinptr* tbin;
  bindex_t idx;
  compute_tree_index(size, idx);
  tbin = local_treebin_at(m, idx, local_idx);

  tchunkx->index = idx;
  tchunkx->child[0] = tchunkx->child[1] = 0;
  if (!local_treemap_is_marked(m, idx, local_idx)) {
    local_mark_treemap(m, idx, local_idx);
    *tbin = tchunkx;
    tchunkx->parent = (tchunkptr)tbin;
    tchunkx->fd = tchunkx->bk = tchunkx;
  } else {
    tchunkptr tchunkt = *tbin;
    size_t K = size << leftshift_for_tree_index(idx);
    for (;;) {
      if (chunksize(tchunkt) != size) {
        tchunkptr* C =
            &(tchunkt->child[(K >> (SIZE_T_BITSIZE - SIZE_T_ONE)) & 1]);
        K <<= 1;
        if (*C != 0) {
          tchunkt = *C;
        } else if (RTCHECK(ok_address(m, C))) {
          *C = tchunkx;
          tchunkx->parent = tchunkt;
          tchunkx->fd = tchunkx->bk = tchunkx;
          break;
        } else {
          CORRUPTION_ERROR_ACTION(m);
          break;
        }
      } else {
        tchunkptr prev = tchunkt->fd;
        if (RTCHECK(ok_address(m, tchunkt) && ok_address(m, prev))) {
          tchunkt->fd = prev->bk = tchunkx;
          tchunkx->fd = prev;
          tchunkx->bk = tchunkt;
          tchunkx->parent = 0;
          break;
        } else {
#if defined(ANDROID) || defined(__ANDROID__)
          __android_log_print(
              ANDROID_LOG_ERROR, "PRIMJS_ALLOCATE",
              "====insert_large_chunk  ok_address(m, tchunkt):%d, "
              "ok_address(m, prev):%d\n",
              ok_address(m, tchunkt), ok_address(m, prev));
#endif
          CORRUPTION_ERROR_ACTION(m);
          break;
        }
      }
    }
  }
}

__attribute__((always_inline)) void unlink_large_chunk(mstate m,
                                                       tchunkptr tchunk) {
  tchunkptr XP = tchunk->parent;
  tchunkptr R;
  if (tchunk->bk != tchunk) {
    tchunkptr prev = tchunk->fd;
    R = tchunk->bk;
    if (RTCHECK(ok_address(m, prev) && prev->bk == tchunk && R->fd == tchunk)) {
      prev->bk = R;
      R->fd = prev;
    } else {
#if defined(ANDROID) || defined(__ANDROID__)
      __android_log_print(
          ANDROID_LOG_ERROR, "PRIMJS_ALLOCATE",
          "====unlink_large_chunk  ok_address(m, prev):%d, prev->bk "
          "== tchunk:%d, R->fd == tchunk:%d\n",
          ok_address(m, prev), prev->bk == tchunk, R->fd == tchunk);
#endif
      CORRUPTION_ERROR_ACTION(m);
    }
  } else {
    tchunkptr* RP;
    if (((R = *(RP = &(tchunk->child[1]))) != 0) ||
        ((R = *(RP = &(tchunk->child[0]))) != 0)) {
      tchunkptr* CP;
      while ((*(CP = &(R->child[1])) != 0) || (*(CP = &(R->child[0])) != 0)) {
        R = *(RP = CP);
      }
      if (RTCHECK(ok_address(m, RP))) {
        *RP = 0;
      } else {
        CORRUPTION_ERROR_ACTION(m);
      }
    }
  }
  if (XP != 0) {
    tbinptr* tbin = treebin_at(m, tchunk->index);
    if (tchunk == *tbin) {
      if ((*tbin = R) == 0) clear_treemap(m, tchunk->index);
    } else if (RTCHECK(ok_address(m, XP))) {
      if (XP->child[0] == tchunk)
        XP->child[0] = R;
      else
        XP->child[1] = R;
    } else {
      CORRUPTION_ERROR_ACTION(m);
    }
    if (R != 0) {
      if (RTCHECK(ok_address(m, R))) {
        tchunkptr C0, C1;
        R->parent = XP;
        if ((C0 = tchunk->child[0]) != 0) {
          if (RTCHECK(ok_address(m, C0))) {
            R->child[0] = C0;
            C0->parent = R;
          } else {
            CORRUPTION_ERROR_ACTION(m);
          }
        }
        if ((C1 = tchunk->child[1]) != 0) {
          if (RTCHECK(ok_address(m, C1))) {
            R->child[1] = C1;
            C1->parent = R;
          } else {
            CORRUPTION_ERROR_ACTION(m);
          }
        }
      } else {
        CORRUPTION_ERROR_ACTION(m);
      }
    }
  }
}

__attribute__((always_inline)) void insert_chunk(mstate m, mchunkptr mchunk,
                                                 size_t size) {
  if (is_small(size)) {
    insert_small_chunk(m, mchunk, size);
  } else {
    tchunkptr tchunk = (tchunkptr)(mchunk);
    insert_large_chunk(m, tchunk, size);
  }
}

__attribute__((always_inline)) void local_insert_chunk(mstate m,
                                                       mchunkptr mchunk,
                                                       size_t size,
                                                       int local_idx) {
  if (is_small(size)) {
    local_insert_small_chunk(m, mchunk, size, local_idx);
  } else {
    tchunkptr tchunk = (tchunkptr)(mchunk);
    local_insert_large_chunk(m, tchunk, size, local_idx);
  }
}

__attribute__((always_inline)) void unlink_chunk(mstate m, mchunkptr mchunk,
                                                 size_t size) {
  if (is_small(size)) {
    unlink_small_chunk(m, mchunk, size);
  } else {
    tchunkptr tchunk = (tchunkptr)(mchunk);
    unlink_large_chunk(m, tchunk);
  }
}

#if ONLY_MSPACES
#define internal_malloc(m, b) mspace_malloc(m, b)
#define internal_free(m, mem) mspace_free(m, mem);
#else /* ONLY_MSPACES */
#if MSPACES
#define internal_malloc(m, b) ((m == gm) ? allocate(b) : mspace_malloc(m, b))
#define internal_free(m, mem) \
  if (m == gm)                \
    gcfree(mem);              \
  else                        \
    mspace_free(m, mem);
#else /* MSPACES */
#define internal_malloc(m, b) allocate(m, b)
#define internal_free(m, mem) gcfree(m, mem)
#endif /* MSPACES */
#endif /* ONLY_MSPACES */

static uint32_t mmap_get_free(const void* p) { return (uintptr_t)p >> 1; }

void* mmap_set_free(uint32_t v) {
  return reinterpret_cast<void*>(((uintptr_t)(v) << 1) | 1);
}

static void add_mmap_chunk(mstate m, void* mem) {
  // mmap_array
  if (m->mmap_count == m->mmap_size) {
    uint32_t new_mmap_size = (m->mmap_size == 0) ? 1024 : m->mmap_size * 2;
    void** new_mmap_array =
        reinterpret_cast<void**>(CALL_MMAP(new_mmap_size * sizeof(uintptr_t)));
    if (reinterpret_cast<void*>(new_mmap_array) == MAP_FAILED) abort();
    memcpy(new_mmap_array, m->mmap_array, m->mmap_size * sizeof(uintptr_t));
    uint32_t start = m->mmap_size;
    for (uint32_t i = start; i < new_mmap_size; i++) {
      uint32_t next;
      if (i == (new_mmap_size - 1)) {
        next = 0;
      } else {
        next = i + 1;
      }
      new_mmap_array[i] = mmap_set_free(next);
    }
    if (m->mmap_array &&
        CALL_MUNMAP(m->mmap_array, m->mmap_size * sizeof(uintptr_t)) != 0) {
      abort();
    }
    m->mmap_array = new_mmap_array;
    m->mmap_size = new_mmap_size;
    m->mmap_free_index = start;
  }
  uint32_t index = m->mmap_free_index;
  m->mmap_free_index = mmap_get_free(m->mmap_array[index]);
  m->mmap_array[index] = mem;
  m->mmap_count++;
}

static int chunk_call_munmap(mstate m, mchunkptr p, size_t size) {
  size_t prevsize = p->prev_foot;
  char* base = reinterpret_cast<char*>(p) - prevsize;
  int res = CALL_MUNMAP(base, size);
  uint32_t i = 0;
  uintptr_t mem = (uintptr_t)chunk2mem(p);
  for (i = 0; i < m->mmap_size; i++) {
    if (!mmap_is_free(m->mmap_array[i]) && (uintptr_t)m->mmap_array[i] == mem) {
      break;
    }
  }
  m->mmap_array[i] = mmap_set_free(m->mmap_free_index);
  m->mmap_free_index = i;
  m->mmap_count--;
  return res;
}

#if defined(ANDROID) || defined(__ANDROID__)
pid_t gettid() { return syscall(SYS_gettid); }
#endif

static void* mmap_alloc(mstate m, size_t nb) {
  size_t mmsize = mmap_align(nb + SIX_SIZE_T_SIZES + CHUNK_ALIGN_MASK);
  if (m->footprint_limit != 0) {
    size_t fp = m->footprint + mmsize;
    if (fp <= m->footprint || fp > m->footprint_limit) return 0;
  }
  if (mmsize > nb) { /* Check for wrap around 0 */
    char* mm = reinterpret_cast<char*>(CALL_MMAP(mmsize));
#if defined(ANDROID) || defined(__ANDROID__)
#define PR_SET_VMA 0x53564d41
#define PR_SET_VMA_ANON_NAME 0
    prctl(PR_SET_VMA, PR_SET_VMA_ANON_NAME, mm, mmsize, m->mem_name);
#endif
    if (mm != CMFAIL) {
      size_t offset = align_offset(chunk2mem(mm));
      size_t psize = mmsize - offset - MMAP_FOOT_PAD;
      mchunkptr p = (mchunkptr)(mm + offset);
      p->prev_foot = offset;
      p->head = psize;
      mark_inuse_foot(m, p, psize);
      chunk_plus_offset(p, psize)->head = FENCEPOST_HEAD;
      chunk_plus_offset(p, psize + SIZE_T_SIZE)->head = 0;

      if (m->least_addr == 0 || mm < m->least_addr) m->least_addr = mm;
      if ((m->footprint += mmsize) > m->max_footprint)
        m->max_footprint = m->footprint;
      assert(is_aligned(chunk2mem(p)));
      check_mmapped_chunk(m, p);
      void* mem = chunk2mem(p);
      add_mmap_chunk(m, mem);
      return mem;
    }
  }
  return 0;
}

static mchunkptr mmap_resize(mstate m, mchunkptr oldp, size_t nb, int flags) {
  size_t oldsize = chunksize(oldp);
  (void)flags;
  if (is_small(nb)) return 0;
  if (oldsize >= nb + SIZE_T_SIZE &&
      (oldsize - nb) <= (mparams.granularity << 1))
    return oldp;
  else {
    size_t offset = oldp->prev_foot;
    size_t oldmmsize = oldsize + offset + MMAP_FOOT_PAD;
    size_t newmmsize = mmap_align(nb + SIX_SIZE_T_SIZES + CHUNK_ALIGN_MASK);
    char* cp = reinterpret_cast<char*>(CALL_MREMAP(
        reinterpret_cast<char*>(oldp) - offset, oldmmsize, newmmsize, flags));
    if (cp != CMFAIL) {
      mchunkptr newp = (mchunkptr)(cp + offset);
      size_t psize = newmmsize - offset - MMAP_FOOT_PAD;
      newp->head = psize;
      mark_inuse_foot(m, newp, psize);
      chunk_plus_offset(newp, psize)->head = FENCEPOST_HEAD;
      chunk_plus_offset(newp, psize + SIZE_T_SIZE)->head = 0;

      if (cp < m->least_addr) m->least_addr = cp;
      if ((m->footprint += newmmsize - oldmmsize) > m->max_footprint)
        m->max_footprint = m->footprint;
      check_mmapped_chunk(m, newp);
      return newp;
    }
  }
  return 0;
}

static void init_top(mstate m, mchunkptr p, size_t psize) {
  /* Ensure alignment */
  size_t offset = align_offset(chunk2mem(p));
  p = (mchunkptr)(reinterpret_cast<char*>(p) + offset);
  psize -= offset;

  m->top = p;
  m->topsize = psize;
  p->head = psize | PINUSE_BIT;
  chunk_plus_offset(p, psize)->head = TOP_FOOT_SIZE;
  m->trim_check = mparams.trim_threshold; /* reset on each update */
}

void init_bins(mstate m) {
  bindex_t i;
  for (i = 0; i < NSMALLBINS; ++i) {
    sbinptr bin = smallbin_at(m, i);
    bin->fd = bin->bk = bin;
  }

  for (int local_i = 0; local_i < THREAD_NUM; local_i++) {
    bindex_t i;
    for (i = 0; i < NSMALLBINS; ++i) {
      sbinptr bin = local_smallbin_at(m, i, local_i);
      bin->fd = bin->bk = bin;
    }
  }
}

static void init_mmap_array(mstate m) {
  m->mmap_array = NULL;
  m->mmap_size = 0;
  m->mmap_free_index = 0;
  m->mmap_count = 0;
}

#if PROCEED_ON_ERROR

static void reset_on_error(mstate m) {
  int i;
  ++malloc_corruption_error_count;
  /* Reinitialize fields to forget about all memory */
  m->smallmap = m->treemap = 0;
  m->dvsize = m->topsize = 0;
  m->seg.base = 0;
  m->seg.size = 0;
  m->seg.next = 0;
  m->top = m->dv = 0;
  for (i = 0; i < NTREEBINS; ++i) *treebin_at(m, i) = 0;
  init_bins(m);
}
#endif /* PROCEED_ON_ERROR */

static void add_segment(mstate m, char* tbase, size_t tsize, flag_t mmapped) {
  char* old_top = reinterpret_cast<char*>(m->top);
  msegmentptr oldsp = segment_holding(m, old_top);
  char* old_end = oldsp->base + oldsp->size;
  size_t ssize = pad_request(sizeof(struct malloc_segment));
  char* rawsp = old_end - (ssize + FOUR_SIZE_T_SIZES + CHUNK_ALIGN_MASK);
  size_t offset = align_offset(chunk2mem(rawsp));
  char* asp = rawsp + offset;
  char* csp = (asp < (old_top + MIN_CHUNK_SIZE)) ? old_top : asp;
  mchunkptr sp = (mchunkptr)csp;
  msegmentptr ss = (msegmentptr)(chunk2mem(sp));
  mchunkptr tnext = chunk_plus_offset(sp, ssize);
  mchunkptr p = tnext;
  int nfences = 0;

  init_top(m, (mchunkptr)tbase, tsize - TOP_FOOT_SIZE);

  assert(is_aligned(ss));
  set_size_and_pinuse_of_inuse_chunk(m, sp, ssize);
  *ss = m->seg;
  m->seg.base = tbase;
  m->seg.size = tsize;
  m->seg.sflags = mmapped;
  m->seg.next = ss;
  m->seg_count++;

  for (;;) {
    mchunkptr nextp = chunk_plus_offset(p, SIZE_T_SIZE);
    p->head = FENCEPOST_HEAD;
    ++nfences;
    if (reinterpret_cast<char*>(&(nextp->head)) < old_end)
      p = nextp;
    else
      break;
  }
  assert(nfences >= 2);

  if (csp != old_top) {
    mchunkptr q = (mchunkptr)old_top;
    size_t psize = csp - old_top;
    mchunkptr tn = chunk_plus_offset(q, psize);
    set_free_with_pinuse(q, psize, tn);
    insert_chunk(m, q, psize);
  }

  check_top_chunk(m, m->top);
}
/* -------------------------- System allocation -------------------------- */
static inline void set_prctlinfo(mstate m, int granularity, char* ret) {
#if defined(ANDROID) || defined(__ANDROID__)
#define PR_SET_VMA 0x53564d41
#define PR_SET_VMA_ANON_NAME 0
  prctl(PR_SET_VMA, PR_SET_VMA_ANON_NAME, ret, granularity, m->mem_name);
#endif
}

static void js_munmap_failed(int err_num, void* base, size_t size) {
#if defined(ANDROID) || defined(__ANDROID__)
  __android_log_print(ANDROID_LOG_FATAL, "PRIMJS_ALLOCATE",
                      "munmap failed! errno: %d, base: %p, size: %zu\n",
                      err_num, base, size);
#endif
}

static inline char* alloc_from_mmap_cache(mstate m, size_t req_size) {
#if defined(__x86_64__) || defined(__aarch64__)
#define MMAP_GRANULARITY 1024 * 1024
  if (req_size >= 256 * 1024) {
    char* ret = reinterpret_cast<char*>(CALL_MMAP(req_size));
    if (ret == MAP_FAILED) return CMFAIL;
    int granulirity = req_size;
    set_prctlinfo(m, granulirity, ret);
    return ret;
  }
  size_t cur_size = m->mmap_cache_size;
  if (cur_size == 0 || cur_size < req_size) {
    if (m->mmap_cache != NULL) {
      if (cur_size != 0 && CALL_MUNMAP(m->mmap_cache, cur_size) != 0) {
        *reinterpret_cast<int*>(0xdead) = 0;
      }
      m->mmap_cache = NULL;
      m->mmap_cache_size = 0;
    }
    char* ret = reinterpret_cast<char*>(CALL_MMAP(MMAP_GRANULARITY));
    int granulirity = MMAP_GRANULARITY;
    if (ret == MAP_FAILED) {
      release_unused_segments(m);
      ret = reinterpret_cast<char*>(CALL_MMAP(MMAP_GRANULARITY));
      if (ret == MAP_FAILED) return CMFAIL;
    }
    set_prctlinfo(m, granulirity, ret);
    m->mmap_cache = ret + req_size;
    m->mmap_cache_size = granulirity - req_size;
    return ret;
  } else {
    char* ret = m->mmap_cache;
    m->mmap_cache = ret + req_size;
    m->mmap_cache_size = cur_size - req_size;
    return ret;
  }
#else
  char* ret = reinterpret_cast<char*>(CALL_MMAP(req_size));
  if (ret == MAP_FAILED) return CMFAIL;
  set_prctlinfo(m, req_size, ret);
  return ret;
#endif
}
static void* sys_alloc(mstate m, size_t nb) {
  char* tbase = CMFAIL;
  size_t tsize = 0;
  flag_t mmap_flag = 0;
  size_t asize;

  ensure_initialization(m);

  if (nb >= 256 * 1024 && m->topsize != 0) {
    void* mem = mmap_alloc(m, nb);
    if (mem != 0) {
      PRINT("allocate mmap size:%zu \n", nb);
      return mem;
    } else {
      PRINT("allocate mmap failed \n");
    }
  }

  asize = granularity_align(nb + SYS_ALLOC_PADDING);
  if (asize <= nb) return 0; /* wraparound */
  if (m->footprint_limit != 0) {
    size_t fp = m->footprint + asize;
    if (fp <= m->footprint || fp > m->footprint_limit) return 0;
  }

  char* mp = alloc_from_mmap_cache(m, asize);
  if (mp != CMFAIL) {
    tbase = mp;
    tsize = asize;
    mmap_flag = USE_MMAP_BIT;
  } else {
    return 0;
  }

  if ((m->footprint += tsize) > m->max_footprint)
    m->max_footprint = m->footprint;

  if (!is_initialized(m)) {
    if (m->least_addr == 0 || tbase < m->least_addr) m->least_addr = tbase;
    m->seg.base = tbase;
    m->seg.size = tsize;
    m->seg.sflags = mmap_flag;
    m->magic = mparams.magic;
    m->release_checks = MAX_RELEASE_CHECK_RATE;
    m->seg_count = 0;
    m->open_madvise = false;
    init_bins(m);
    init_top(m, (mchunkptr)tbase, tsize - TOP_FOOT_SIZE);
    init_mmap_array(m);
    m->seg_count++;
#if defined(ANDROID) || defined(__ANDROID__)
    char id[10];
    sprintf(id, "%d", getpid());
    strcat(m->mem_name, id);
    strcat(m->mem_name, "_");
    sprintf(id, "%d", gettid());
    strcat(m->mem_name, id);
#endif
  } else {
    msegmentptr sp = &m->seg;
    while (sp != 0 && tbase != sp->base + sp->size) {
      sp = (NO_SEGMENT_TRAVERSAL) ? 0 : sp->next;
    }
    if (sp != 0 && segment_holds(sp, m->top)) {
      if (sp->size > 512 * 1024) {
        add_segment(m, tbase, tsize, mmap_flag);
      } else {
        sp->size += tsize;
        init_top(m, m->top, m->topsize + tsize);
      }
    } else {
      if (tbase < m->least_addr) m->least_addr = tbase;
      add_segment(m, tbase, tsize, mmap_flag);
    }
  }

  if (nb < m->topsize) {
    size_t rsize = m->topsize -= nb;
    mchunkptr p = m->top;
    mchunkptr r = m->top = chunk_plus_offset(p, nb);
    r->head = rsize | PINUSE_BIT;
    set_size_and_pinuse_of_inuse_chunk(m, p, nb);
    check_top_chunk(m, m->top);
    check_malloced_chunk(m, chunk2mem(p), nb);
    return chunk2mem(p);
  }

  MALLOC_FAILURE_ACTION;

  return 0;
}
#ifdef ENABLE_PHYSICAL_MEM_MANAGE
#define TCHUNKSIZE sizeof(tchunk)
#define MAX_TRAVERSE_NUM 48

static int MAX_COLLECT_TREECHUNK_IDX = 31;
static int MIN_COLLECT_TREECHUNK_IDX = 20;
static __attribute__((unused)) void release_physical_mem(mstate m) {
  MIN_COLLECT_TREECHUNK_IDX--;
  MAX_COLLECT_TREECHUNK_IDX--;
  if (MIN_COLLECT_TREECHUNK_IDX == 14) {
    MAX_COLLECT_TREECHUNK_IDX = 31;
    MIN_COLLECT_TREECHUNK_IDX = 20;
  }
  tchunkptr queue[MAX_TRAVERSE_NUM];
  size_t front_idx = 0, back_idx = 0;
  for (bindex_t idx = MAX_COLLECT_TREECHUNK_IDX;
       idx >= MIN_COLLECT_TREECHUNK_IDX; idx--) {
    tchunkptr t;
    if ((t = *treebin_at(m, idx)) != 0) {
      queue[back_idx++] = t;

      while (front_idx < back_idx) {
        tchunkptr tmp = queue[front_idx++];
        if (back_idx < MAX_TRAVERSE_NUM && tmp->child[0] != 0) {
          queue[back_idx++] = tmp->child[0];
        }
        if (back_idx < MAX_TRAVERSE_NUM && tmp->child[1] != 0) {
          queue[back_idx++] = tmp->child[1];
        }
      }
      if (back_idx == MAX_TRAVERSE_NUM) break;
    }
  }
  for (size_t i = 0; i < back_idx; i++) {
    tchunkptr ck = queue[i];
    void* release_start =
        reinterpret_cast<uint8_t*>(page_align((uintptr_t)ck)) +
        malloc_getpagesize;
    size_t release_size =
        chunksize(ck) - SIZE_T_SIZE - TCHUNKSIZE - malloc_getpagesize * 3;

    PRINT(
        "qjs4347 release_start:%p,rel_end:%p release_size:%d, chunksize:%d, "
        "chunkaddr:%p, chk_end:%p, back_idx:%d",
        release_start, release_start + release_size, release_size,
        chunksize(ck), ck, (char*)ck + chunksize(ck), back_idx);

    int ret = madvise(release_start, release_size, MADV_DONTNEED);  // linux
    if (ret != 0) {
      PRINT("qjs4043 errno:%d", errno);
    }
  }
}
#endif
void destroy_allocate_instance(mstate m) {
#ifdef USE_ALLOCATE_DEBUG
  malloc_debug_finalize(m);
#endif
  // mmap chunks
  if (m->mmap_count != 0) {
    void** mmap_array = m->mmap_array;
    uint32_t len = m->mmap_size;
    void* mem = NULL;
    for (uint32_t i = 0; i < len; i++) {
      mem = mmap_array[i];
      if (!mmap_is_free(mem)) {
        gcfree(m, mem);
      }
    }
  }
  // segments
  msegmentptr sp = &m->seg;
  msegmentptr next = NULL;
  while (sp != NULL) {
    next = sp->next;
    if (sp->size && sp->base && CALL_MUNMAP(sp->base, sp->size) != 0) {
      js_munmap_failed(errno, sp->base, sp->size);
    }
    sp = next;
  }
  if (m->mmap_cache_size && m->mmap_cache &&
      CALL_MUNMAP(m->mmap_cache, m->mmap_cache_size) != 0) {
    js_munmap_failed(errno, m->mmap_cache, m->mmap_cache_size);
  }
  if (m->mmap_size && m->mmap_array &&
      CALL_MUNMAP(m->mmap_array, m->mmap_size * sizeof(uintptr_t)) != 0) {
    js_munmap_failed(errno, m->mmap_array, m->mmap_size * sizeof(uintptr_t));
  }
  free(m->smallbins);
  free(m->treebins);
  for (int i = 0; i < THREAD_NUM; i++) {
    free(m->local_smallbins[i]);
    free(m->local_treebins[i]);
  }
}

size_t release_unused_segments(mstate m) {
#ifdef ENABLE_TRACING_GC_LOG
  m->release_seg_num = 0;
#endif
  size_t released = 0;
  int nsegs = 0;
  msegmentptr pred = &m->seg;
  msegmentptr sp = pred->next;

  while (sp != 0) {
    char* base = sp->base;
    size_t size = sp->size;
    msegmentptr next = sp->next;
    ++nsegs;

    PRINT("4390 freesize:%zu, fullsize:%zu, TOP_FOOT_SIZE:%zu \n", psize, size,
          TOP_FOOT_SIZE);

    if (is_unused(sp)) {
      assert(segment_holds(sp, reinterpret_cast<char*>(sp)));
      if (CALL_MUNMAP(base, size) == 0) {
#ifdef ENABLE_TRACING_GC_LOG
        m->release_seg_num++;
#endif
        released += size;
        m->footprint -= size;
        m->seg_count--;
        /* unlink obsoleted record */
        sp = pred;
        sp->next = next;
      } else { /* back out if cannot unmap */
        abort();
      }
    }

    if (NO_SEGMENT_TRAVERSAL) /* scan only first segment */
      break;
    pred = sp;
    sp = next;
  }

#ifdef ENABLE_PHYSICAL_MEM_MANAGE
#ifdef linux
  if (m->footprint != m->max_footprint) {
    release_physical_mem(m);
   PRINT("release_unused_segments, footprint:%zu,
   max_footprint:%zu\n",m->footprint, m->max_footprint);
  }
#endif
#endif
  return released;
}

static int sys_trim(mstate m, size_t pad) {
  size_t released = 0;
  ensure_initialization(m);
  if (pad < MAX_REQUEST && is_initialized(m)) {
    pad += TOP_FOOT_SIZE; /* ensure enough room for segment overhead */

    if (m->topsize > pad) {
      size_t unit = mparams.granularity;
      size_t extra =
          ((m->topsize - pad + (unit - SIZE_T_ONE)) / unit - SIZE_T_ONE) * unit;
      msegmentptr sp = segment_holding(m, reinterpret_cast<char*>(m->top));

      if (extra != 0 && sp->size >= extra && !has_segment_link(m, sp)) {
        size_t newsize = sp->size - extra;
        (void)newsize;

        if (CALL_MUNMAP(sp->base + newsize, extra) == 0) {
          released = extra;
        } else {
          *reinterpret_cast<int*>(0xdead) = 0;
        }
      }

      if (released != 0) {
        sp->size -= released;
        m->footprint -= released;
        init_top(m, m->top, m->topsize - released);
        check_top_chunk(m, m->top);
      }
    }

    if (released == 0 && m->topsize > m->trim_check) {
      m->trim_check = MAX_SIZE_T;
    }
  }
  return (released != 0) ? 1 : 0;
}

static void* tmalloc_large(mstate m, size_t nb) {
  tchunkptr v = 0;
  size_t rsize = -nb;
  tchunkptr t;
  bindex_t idx;
  compute_tree_index(nb, idx);
  if ((t = *treebin_at(m, idx)) != 0) {
    size_t sizebits = nb << leftshift_for_tree_index(idx);
    tchunkptr rst = 0;
    for (;;) {
      tchunkptr rt;
      size_t trem = chunksize(t) - nb;
      if (trem < rsize) {
        v = t;
        if ((rsize = trem) == 0) break;
      }
      rt = t->child[1];
      t = t->child[(sizebits >> (SIZE_T_BITSIZE - SIZE_T_ONE)) & 1];
      if (rt != 0 && rt != t) rst = rt;
      if (t == 0) {
        t = rst;
        break;
      }
      sizebits <<= 1;
    }
  }
  if (t == 0 && v == 0) {
    binmap_t leftbits = left_bits(idx2bit(idx)) & m->treemap;
    if (leftbits != 0) {
      bindex_t i;
      binmap_t leastbit = least_bit(leftbits);
      compute_bit2idx(leastbit, i);
      t = *treebin_at(m, i);
    }
  }

  while (t != 0) {
    size_t trem = chunksize(t) - nb;
    if (trem < rsize) {
      rsize = trem;
      v = t;
    }
    t = leftmost_child(t);
  }

  if (v != 0 && rsize < (size_t)(m->dvsize - nb)) {
    if (RTCHECK(ok_address(m, v))) {
      mchunkptr r = chunk_plus_offset(v, nb);
      assert(chunksize(v) == rsize + nb);
      if (RTCHECK(ok_next(v, r))) {
        unlink_large_chunk(m, v);
        if (rsize < MIN_CHUNK_SIZE) {
          set_inuse_and_pinuse(m, v, (rsize + nb));
        } else {
          set_size_and_pinuse_of_inuse_chunk(m, v, nb);
          set_size_and_pinuse_of_free_chunk(r, rsize);
          insert_chunk(m, r, rsize);
        }
        return chunk2mem(v);
      }
    }
    CORRUPTION_ERROR_ACTION(m);
  }
  return 0;
}

static void* tmalloc_small(mstate m, size_t nb) {
  tchunkptr t, v;
  size_t rsize;
  bindex_t i;
  binmap_t leastbit = least_bit(m->treemap);
  compute_bit2idx(leastbit, i);
  v = t = *treebin_at(m, i);
  rsize = chunksize(t) - nb;

  while ((t = leftmost_child(t)) != 0) {
    size_t trem = chunksize(t) - nb;
    if (trem < rsize) {
      rsize = trem;
      v = t;
    }
  }

  if (RTCHECK(ok_address(m, v))) {
    mchunkptr r = chunk_plus_offset(v, nb);
    assert(chunksize(v) == rsize + nb);
    if (RTCHECK(ok_next(v, r))) {
      unlink_large_chunk(m, v);
      if (rsize < MIN_CHUNK_SIZE) {
        set_inuse_and_pinuse(m, v, (rsize + nb));
      } else {
        set_size_and_pinuse_of_inuse_chunk(m, v, nb);
        set_size_and_pinuse_of_free_chunk(r, rsize);
        replace_dv(m, r, rsize);
      }
      return chunk2mem(v);
    }
  }
  CORRUPTION_ERROR_ACTION(m);
  return 0;
}
#if !ONLY_MSPACES

void* allocate(mstate gm, size_t bytes) {
#if USE_LOCKS
  ensure_initialization();
#endif
  void* mem;
  size_t nb;
  if (bytes <= MAX_SMALL_REQUEST) {
    bindex_t idx;
    binmap_t smallbits;
    nb = (bytes < MIN_REQUEST) ? MIN_CHUNK_SIZE : pad_request(bytes);
    idx = small_index(nb);
    smallbits = gm->smallmap >> idx;

    if ((smallbits & 0x3U) != 0) {
      mchunkptr b, p;
      idx += ~smallbits & 1;
      b = smallbin_at(gm, idx);
      p = b->fd;
      assert(chunksize(p) == small_index2size(idx));
      unlink_first_small_chunk(gm, b, p, idx);
      set_inuse_and_pinuse(gm, p, small_index2size(idx));
      mem = chunk2mem(p);
      check_malloced_chunk(gm, mem, nb);
      goto postaction;
    } else if (nb > gm->dvsize) {
      if (smallbits != 0) {
        mchunkptr b, p, r;
        size_t rsize;
        bindex_t i;
        binmap_t leftbits = (smallbits << idx) & left_bits(idx2bit(idx));
        binmap_t leastbit = least_bit(leftbits);
        compute_bit2idx(leastbit, i);
        b = smallbin_at(gm, i);
        p = b->fd;
        assert(chunksize(p) == small_index2size(i));
        unlink_first_small_chunk(gm, b, p, i);
        rsize = small_index2size(i) - nb;
        if (SIZE_T_SIZE != 4 && rsize < MIN_CHUNK_SIZE) {
          set_inuse_and_pinuse(gm, p, small_index2size(i));
        } else {
          set_size_and_pinuse_of_inuse_chunk(gm, p, nb);
          r = chunk_plus_offset(p, nb);
          set_size_and_pinuse_of_free_chunk(r, rsize);
          replace_dv(gm, r, rsize);
        }
        mem = chunk2mem(p);
        check_malloced_chunk(gm, mem, nb);
        goto postaction;
      } else if (gm->treemap != 0 && (mem = tmalloc_small(gm, nb)) != 0) {
        check_malloced_chunk(gm, mem, nb);
        goto postaction;
      }
    }
  } else if (bytes >= MAX_REQUEST) {
    nb = MAX_SIZE_T;
  } else {
    nb = pad_request(bytes);
    if (gm->treemap != 0 && (mem = tmalloc_large(gm, nb)) != 0) {
      check_malloced_chunk(gm, mem, nb);
      goto postaction;
    }
  }

  if (nb <= gm->dvsize) {
    size_t rsize = gm->dvsize - nb;
    mchunkptr p = gm->dv;
    if (rsize >= MIN_CHUNK_SIZE) {
      mchunkptr r = gm->dv = chunk_plus_offset(p, nb);
      gm->dvsize = rsize;
      set_size_and_pinuse_of_free_chunk(r, rsize);
      set_size_and_pinuse_of_inuse_chunk(gm, p, nb);
    } else {
      size_t dvs = gm->dvsize;
      gm->dvsize = 0;
      gm->dv = 0;
      set_inuse_and_pinuse(gm, p, dvs);
    }
    mem = chunk2mem(p);
    check_malloced_chunk(gm, mem, nb);
    goto postaction;
  } else if (nb < gm->topsize) {
    size_t rsize = gm->topsize -= nb;
    mchunkptr p = gm->top;
    mchunkptr r = gm->top = chunk_plus_offset(p, nb);
    r->head = rsize | PINUSE_BIT;
    set_size_and_pinuse_of_inuse_chunk(gm, p, nb);
    mem = chunk2mem(p);
    check_top_chunk(gm, gm->top);
    check_malloced_chunk(gm, mem, nb);
    goto postaction;
  }

  mem = sys_alloc(gm, nb);

postaction:
  POSTACTION(gm);
#ifdef ENABLE_GC_DEBUG_TOOLS
  add_cur_mems(gm->runtime, mem);
#endif
  if (mem) {
    clear_mark(mem);
    return mem;
  }
  return 0;
}

void gcfree(mstate fm, void* mem) {
  PRINT("gcfree, addr:%p, mstate:%p, tid:%d\n", mem, fm, gettid());
#ifdef ENABLE_GC_DEBUG_TOOLS
  delete_cur_mems(fm->runtime, mem);
#endif

  mchunkptr p = mem2chunk(mem);
  check_inuse_chunk(fm, p);
  if (RTCHECK(ok_address(fm, p) && ok_inuse(p))) {
    size_t psize = chunksize(p);
    mchunkptr next = chunk_plus_offset(p, psize);
    if (!pinuse(p)) {
      size_t prevsize = p->prev_foot;
      if (is_mmapped(p)) {
        psize += prevsize + MMAP_FOOT_PAD;
        if (chunk_call_munmap(fm, p, psize) == 0) fm->footprint -= psize;
        goto postaction;
      } else {
        mchunkptr prev = chunk_minus_offset(p, prevsize);
        psize += prevsize;
        p = prev;
        if (RTCHECK(ok_address(fm, prev))) { /* consolidate backward */
          if (p != fm->dv) {
            unlink_chunk(fm, p, prevsize);
          } else if ((next->head & INUSE_BITS) == INUSE_BITS) {
            fm->dvsize = psize;
            set_free_with_pinuse(p, psize, next);
            goto postaction;
          }
        } else
#if defined(ANDROID) || defined(__ANDROID__)
          __android_log_print(ANDROID_LOG_FATAL, "PRIMJS_ALLOCATE",
                              "bottom of the MORECORE!");
#else
          abort();
#endif
      }
    }

    if (RTCHECK(ok_next(p, next) && ok_pinuse(next))) {
      if (!cinuse(next)) { /* consolidate forward */
        if (next == fm->top) {
          size_t tsize = fm->topsize += psize;
          fm->top = p;
          p->head = tsize | PINUSE_BIT;
          if (p == fm->dv) {
            fm->dv = 0;
            fm->dvsize = 0;
          }
          if (should_trim(fm, tsize)) {
            sys_trim(fm, 0);
          } else {
          }
          goto postaction;
        } else if (next == fm->dv) {
          size_t dsize = fm->dvsize += psize;
          fm->dv = p;
          set_size_and_pinuse_of_free_chunk(p, dsize);
          goto postaction;
        } else {
          size_t nsize = chunksize(next);
          psize += nsize;
          unlink_chunk(fm, next, nsize);
          set_size_and_pinuse_of_free_chunk(p, psize);
          if (p == fm->dv) {
            fm->dvsize = psize;
            goto postaction;
          }
        }
      } else {
        set_free_with_pinuse(p, psize, next);
      }

      if (is_small(psize)) {
        insert_small_chunk(fm, p, psize);
        check_free_chunk(fm, p);
      } else {
        tchunkptr tp = (tchunkptr)p;
        insert_large_chunk(fm, tp, psize);
        check_free_chunk(fm, p);
      }
      goto postaction;
    }
  } else {
    USAGE_ERROR_ACTION(fm, p);
  }
postaction:
  POSTACTION(fm);
}

int atomic_acqurie_local_idx(mstate m) {
  pthread_mutex_lock(&m->mtx);
  for (int i = 0; i < THREAD_NUM; i++) {
    if (m->local_idx_flag[i] == 0) {
      m->local_idx_flag[i] = -1;
      pthread_mutex_unlock(&m->mtx);
      return i;
    }
  }
  pthread_mutex_unlock(&m->mtx);
  return -1;
}

void atomic_release_local_idx(mstate m, int local_idx) {
  pthread_mutex_lock(&m->mtx);
  m->local_idx_flag[local_idx] = 0;
  pthread_mutex_unlock(&m->mtx);
}

void local_gcfree(mstate fm, void* mem, int local_idx) {
#ifdef ENABLE_GC_DEBUG_TOOLS
  if (local_idx != -1) multi_delete_cur_mems(fm->runtime, mem, local_idx);
#endif

  mchunkptr p = mem2chunk(mem);
  check_inuse_chunk(fm, p);
  size_t psize = chunksize(p);
  mchunkptr next = chunk_plus_offset(p, psize);

  ((next)->head &= ~PINUSE_BIT);
  (p)->head = (psize | pinuse(p));
  set_foot(p, psize);

  goto postaction;
postaction:
  POSTACTION(fm);
}
#endif /* !ONLY_MSPACES */

static mchunkptr
#ifdef USE_ALLOCATE_DEBUG
    __attribute__((unused))
#endif
    try_realloc_chunk(mstate m, mchunkptr p, size_t nb, int can_move) {
  mchunkptr newp = 0;
  size_t oldsize = chunksize(p);
  mchunkptr next = chunk_plus_offset(p, oldsize);
  if (RTCHECK(ok_address(m, p) && ok_inuse(p) && ok_next(p, next) &&
              ok_pinuse(next))) {
    if (is_mmapped(p)) {
      newp = mmap_resize(m, p, nb, can_move);
    } else if (oldsize >= nb) {
      size_t rsize = oldsize - nb;
      if (rsize >= MIN_CHUNK_SIZE) {
        mchunkptr r = chunk_plus_offset(p, nb);
        set_inuse(m, p, nb);
        set_free_with_pinuse(r, rsize, next);
        insert_chunk(m, r, rsize);
      }
      newp = p;
    } else if (next == m->top) {
      if (oldsize + m->topsize > nb) {
        size_t newsize = oldsize + m->topsize;
        size_t newtopsize = newsize - nb;
        mchunkptr newtop = chunk_plus_offset(p, nb);
        set_inuse(m, p, nb);
        newtop->head = newtopsize | PINUSE_BIT;
        m->top = newtop;
        m->topsize = newtopsize;
        newp = p;
      }
    } else if (next == m->dv) {
      size_t dvs = m->dvsize;
      if (oldsize + dvs >= nb) {
        size_t dsize = oldsize + dvs - nb;
        if (dsize >= MIN_CHUNK_SIZE) {
          mchunkptr r = chunk_plus_offset(p, nb);
          mchunkptr n = chunk_plus_offset(r, dsize);
          set_inuse(m, p, nb);
          set_size_and_pinuse_of_free_chunk(r, dsize);
          clear_pinuse(n);
          m->dvsize = dsize;
          m->dv = r;
        } else {
          size_t newsize = oldsize + dvs;
          set_inuse(m, p, newsize);
          m->dvsize = 0;
          m->dv = 0;
        }
        newp = p;
      }
    }
  } else {
    USAGE_ERROR_ACTION(m, p);
  }
  return newp;
}

#if !ONLY_MSPACES
void* reallocate(mstate gm, void* oldmem, size_t bytes) {
  void* mem = 0;
  if (oldmem == 0) {
    mem = allocate(gm, bytes);
  } else if (bytes >= MAX_REQUEST) {
    MALLOC_FAILURE_ACTION;
  }
#ifdef REALLOC_ZERO_BYTES_FREES
  else if (bytes == 0) {
    return NULL;
  }
#endif /* REALLOC_ZERO_BYTES_FREES */
  else {
    size_t nb = request2size(bytes);
    mchunkptr oldp = mem2chunk(oldmem);

    mchunkptr newp = try_realloc_chunk(gm, oldp, nb, 1);
    POSTACTION(gm);
    if (newp != 0) {
      check_inuse_chunk(gm, newp);
      mem = chunk2mem(newp);
    } else {
      mem = internal_malloc(gm, bytes);
      if (mem != 0) {
        size_t oc = chunksize(oldp) - overhead_for(oldp);
        memcpy(mem, oldmem, (oc < bytes) ? oc : bytes);
      }
    }
  }
  return mem;
}

#if !NO_MALLINFO
struct mallinfo allocinfo(mstate m) { return internal_mallinfo(m); }
#endif /* NO_MALLINFO */

#if !NO_MALLOC_STATS
void allocate_stats(mstate m) { internal_malloc_stats(m); }
#endif /* NO_MALLOC_STATS */

size_t allocate_usable_size(void* mem) {
  mchunkptr p = mem2chunk(mem);
  return chunksize(p) - overhead_for(p);
}

int64_t get_daytime() {
  int64_t d;
  struct timeval tv;
  gettimeofday(&tv, NULL);
  d = (int64_t)tv.tv_sec * 1000000 + tv.tv_usec;
  return d;
}
#ifdef ENABLE_TRACING_GC_LOG
size_t get_malloc_size(mstate m) {
  size_t malloc_size = 0;
  // segment
  msegmentptr sp = &(m->seg);
  mchunkptr p;
  size_t psize;
  uintptr_t end;
  while (sp != NULL) {
    p = align_as_chunk(sp->base);
    if (!p) {
      sp = sp->next;
      continue;
    }
    end = segment_holds(sp, m->top)
              ? (uintptr_t)(m->top)
              : (uintptr_t)(sp) - (uintptr_t)(chunk2mem(0));
    while ((uintptr_t)p < end) {
      psize = chunksize(p);
      if (psize == 0) {
        printf("get_malloc_size, psize is 0, p: %p, sp: %p\n", p, sp);
        abort();
      }
      if (cinuse(p)) {
        malloc_size += psize;
      }
      p = chunk_plus_offset(p, psize);
    }
    sp = sp->next;
  }
  // mmap_chunk
  void** mmap_array = m->mmap_array;
  uint32_t len = m->mmap_size;
  void* mem;
  for (uint32_t i = 0; i < len; i++) {
    mem = mmap_array[i];
    if (!mmap_is_free(mem)) {
      p = mem2chunk(mem);
      psize = chunksize(p);
      malloc_size += psize;
    }
  }

  return malloc_size;
}
#endif

bool mmap_is_free(const void* p) { return (uintptr_t)p & 1; }

bool is_marked(void* ptr) { return *(reinterpret_cast<int*>(ptr) - 1); }
void clear_mark(void* ptr) { *(reinterpret_cast<int*>(ptr) - 1) = 0; }
int get_tag(void* ptr) { return *(reinterpret_cast<int*>(ptr) - 2) & 0x3F; }

#endif /* !ONLY_MSPACES */

// mark
#include <atomic>
void set_mark_multi(void* ptr) {
  (reinterpret_cast<std::atomic<int>*>(ptr) - 1)
      ->store(1, std::memory_order_relaxed);
}
bool is_marked_multi(void* ptr) {
  return (reinterpret_cast<std::atomic<int>*>(ptr) - 1)
      ->load(std::memory_order_relaxed);
}
// alloc tag
void set_alloc_tag(void* ptr, int alloc_tag) {
  int size = *(reinterpret_cast<int*>(ptr) - 2) & ~(0x3F);
  *(reinterpret_cast<int*>(ptr) - 2) = size | alloc_tag;
}
int get_alloc_tag(void* ptr) {
  return *(reinterpret_cast<int*>(ptr) - 2) & 0x3F;
}

#pragma clang diagnostic pop
#endif

// hash size
void set_hash_size(void* ptr, int hash_size) {  // with tag
  if (hash_size > (1 << 25) - 1) {
    *reinterpret_cast<int*>(0xdead) = 0;
  }
  int tag = *(reinterpret_cast<int*>(ptr) - 2) & 0x3F;
  *(reinterpret_cast<int*>(ptr) - 2) = hash_size << 6 | tag;
}
int get_hash_size(void* ptr) { return *(reinterpret_cast<int*>(ptr) - 2) >> 6; }

// heap obj length
void set_heap_obj_len(void* ptr, int len) {
  if (len > (1 << 25) - 1) {
    *reinterpret_cast<int*>(0xdead) = 0;
  }
  int tag = *(reinterpret_cast<int*>(ptr) - 2) & 0x3F;
  *(reinterpret_cast<int*>(ptr) - 2) = (len << 6) | tag;
}

int get_heap_obj_len(void* ptr) {
  return *(reinterpret_cast<int*>(ptr) - 2) >> 6;
}
