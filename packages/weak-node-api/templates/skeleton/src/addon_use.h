#pragma once

#ifndef EXTERN_C_START
#ifdef __cplusplus
#define EXTERN_C_START extern "C" {
#define EXTERN_C_END }
#else
#define EXTERN_C_START
#define EXTERN_C_END
#endif
#endif

#if defined(_MSC_VER)
#define NAPI_USED __declspec(selectany)
#elif defined(__GNUC__)
#define NAPI_USED __attribute__((used))
#else
#define NAPI_USED
#endif

#ifndef NAPI_USE
#define NAPI_USE(modname)                        \
  EXTERN_C_START                                 \
  extern void _napi_register_xx_##modname(void); \
  NAPI_USED void* _napi_module_##modname##_p =   \
      (void*)&_napi_register_xx_##modname;       \
  EXTERN_C_END
#endif

NAPI_USE(__PROJECT_SYMBOL__)
