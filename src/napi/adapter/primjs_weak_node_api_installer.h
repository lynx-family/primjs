#ifndef SRC_NAPI_ADAPTER_PRIMJS_WEAK_NODE_API_INSTALLER_H_
#define SRC_NAPI_ADAPTER_PRIMJS_WEAK_NODE_API_INSTALLER_H_

#ifdef __cplusplus
extern "C" {
#endif

typedef const void* (*PrimJSWeakNodeApiRawPtrHostProvider)(void);

// Installs a provider that returns PrimJS' weak Node-API raw host table.
void PrimJSInstallWeakNodeApiRawPtrHostProvider(
    PrimJSWeakNodeApiRawPtrHostProvider provider);

// Initializes the weak Node-API bridge after the provider is installed on iOS.
// On non-Apple platforms the bridge still initializes automatically.
void SetupWeakNodeApiEnv(void);

#ifdef __cplusplus
}
#endif

#endif  // SRC_NAPI_ADAPTER_PRIMJS_WEAK_NODE_API_INSTALLER_H_
