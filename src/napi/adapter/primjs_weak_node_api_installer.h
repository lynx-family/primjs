#ifndef SRC_NAPI_ADAPTER_PRIMJS_WEAK_NODE_API_INSTALLER_H_
#define SRC_NAPI_ADAPTER_PRIMJS_WEAK_NODE_API_INSTALLER_H_

#ifdef __cplusplus
extern "C" {
#endif

typedef const void* (*PrimJSWeakNodeApiRawPtrHostProvider)(void);

// Installs a provider that returns PrimJS' weak Node-API raw host table on
// Apple platforms, where LynxWeakNodeAPI does not link PrimJS directly.
void PrimJSInstallWeakNodeApiRawPtrHostProvider(
    PrimJSWeakNodeApiRawPtrHostProvider provider);

// Initializes the weak Node-API bridge. On Apple platforms this must be called
// after PrimJSInstallWeakNodeApiRawPtrHostProvider(); on non-Apple platforms it
// is also registered as a static constructor by the bridge implementation.
void SetupWeakNodeApiEnv(void);

#ifdef __cplusplus
}
#endif

#endif  // SRC_NAPI_ADAPTER_PRIMJS_WEAK_NODE_API_INSTALLER_H_
