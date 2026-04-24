#ifndef SRC_NAPI_ADAPTER_PRIMJS_WEAK_NODE_API_PROVIDER_H_
#define SRC_NAPI_ADAPTER_PRIMJS_WEAK_NODE_API_PROVIDER_H_

#ifdef __cplusplus
extern "C" {
#endif

// Returns an opaque pointer to PrimJS' weak Node-API raw host table.
const void* PrimJSGetWeakNodeApiRawPtrHost(void);

#ifdef __cplusplus
}
#endif

#endif  // SRC_NAPI_ADAPTER_PRIMJS_WEAK_NODE_API_PROVIDER_H_
