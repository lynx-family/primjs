/*
Derived from weak-node-api@0.1.1 (npm package maintained in
callstackincubator/react-native-node-api). Local modifications include symbol
renaming via weak_napi_defines.h/weak_napi_undefs.h and include/path
adjustments. See NOTICE.md for upstream attribution and licensing details.
*/

/**
 * @file weak_node_api.hpp
 * @brief Weak Node-API host injection interface.
 *
 * This header provides the struct and injection function for deferring Node-API
 * function calls from addons into a Node-API host.
 *
 * @note This file is generated - don't edit it directly
 */

#pragma once

#include <stdio.h>   // fprintf()
#include <stdlib.h>  // abort()

#include "../headers/node_api.h"
#include "NodeApiHost.hpp"
#if defined(USE_WEAK_SUFFIX_NAPI)
#include "../headers/weak_napi_defines.h"
#endif

typedef void (*InjectHostFunction)(const NodeApiHost &);
extern "C" void inject_weak_node_api_host(const NodeApiHost &host);

#if defined(USE_WEAK_SUFFIX_NAPI)
#include "../headers/weak_napi_undefs.h"
#endif
