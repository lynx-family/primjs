# Get the current file directory
get_filename_component(WEAK_NODE_API_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)

if(NOT DEFINED WEAK_NODE_API_LIB)
    if(ANDROID)
        message(WARNING "Platform detected: Android. Prebuilt binaries for Android are not currently supported.")
    elseif(CMAKE_SYSTEM_NAME STREQUAL "OHOS")
        message(WARNING "Platform detected: HarmonyOS. Prebuilt binaries for HarmonyOS are not currently supported.")
    elseif(APPLE)
        if(IOS OR CMAKE_SYSTEM_NAME STREQUAL "iOS")
            message(WARNING "Platform detected: iOS. Prebuilt binaries for iOS are not currently supported.")
        else()
            message(STATUS "Platform detected: macOS.")
            # macOS: Look for dylib in prebuilt/macos/{Release,Debug}
            set(WEAK_NODE_API_LIB_RELEASE "${WEAK_NODE_API_CMAKE_DIR}/prebuilt/macos/weak_suffix/release/libweak-node-api.dylib")
            set(WEAK_NODE_API_LIB_DEBUG "${WEAK_NODE_API_CMAKE_DIR}/prebuilt/macos/weak_suffix/debug/libweak-node-api.dylib")
        endif()

    elseif(WIN32)
        message(STATUS "Platform detected: Windows.")
        # Windows: Look for .lib (Import Library) in prebuilt/win/x64/{Release,Debug}
        set(WEAK_NODE_API_IMPLIB_RELEASE "${WEAK_NODE_API_CMAKE_DIR}/prebuilt/win/weak_suffix/x64/Release/WeakNodeAPI.lib")
        set(WEAK_NODE_API_DLL_RELEASE "${WEAK_NODE_API_CMAKE_DIR}/prebuilt/win/weak_suffix/x64/Release/WeakNodeAPI.dll")
        
        set(WEAK_NODE_API_IMPLIB_DEBUG "${WEAK_NODE_API_CMAKE_DIR}/prebuilt/win/weak_suffix/x64/Debug/WeakNodeAPI.lib")
        set(WEAK_NODE_API_DLL_DEBUG "${WEAK_NODE_API_CMAKE_DIR}/prebuilt/win/weak_suffix/x64/Debug/WeakNodeAPI.dll")
    else()
        message(WARNING "Platform detected: Unknown (${CMAKE_SYSTEM_NAME}). Prebuilt binaries are not currently supported.")
    endif()
endif()

if(NOT DEFINED WEAK_NODE_API_INC)
    set(WEAK_NODE_API_INC "${WEAK_NODE_API_CMAKE_DIR}/headers;${WEAK_NODE_API_CMAKE_DIR}/generated")
    message(STATUS "Using weak-node-api include directories: ${WEAK_NODE_API_INC}")
endif()

add_library(weak-node-api SHARED IMPORTED)

set_target_properties(weak-node-api PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${WEAK_NODE_API_INC}"
    INTERFACE_COMPILE_DEFINITIONS "USE_WEAK_SUFFIX_NAPI"
    IMPORTED_CONFIGURATIONS "RELEASE;DEBUG"
)

if(WIN32)
    # Windows Configuration
    if(EXISTS "${WEAK_NODE_API_IMPLIB_RELEASE}")
        set_target_properties(weak-node-api PROPERTIES
            IMPORTED_IMPLIB_RELEASE "${WEAK_NODE_API_IMPLIB_RELEASE}"
            IMPORTED_LOCATION_RELEASE "${WEAK_NODE_API_DLL_RELEASE}"
        )
    endif()
    
    if(EXISTS "${WEAK_NODE_API_IMPLIB_DEBUG}")
        set_target_properties(weak-node-api PROPERTIES
            IMPORTED_IMPLIB_DEBUG "${WEAK_NODE_API_IMPLIB_DEBUG}"
            IMPORTED_LOCATION_DEBUG "${WEAK_NODE_API_DLL_DEBUG}"
        )
    endif()

    # Fallback: If only one exists, map it to the other config to avoid build errors
    if(NOT EXISTS "${WEAK_NODE_API_IMPLIB_DEBUG}" AND EXISTS "${WEAK_NODE_API_IMPLIB_RELEASE}")
        set_target_properties(weak-node-api PROPERTIES
            IMPORTED_IMPLIB_DEBUG "${WEAK_NODE_API_IMPLIB_RELEASE}"
            IMPORTED_LOCATION_DEBUG "${WEAK_NODE_API_DLL_RELEASE}"
        )
    endif()
else()
    # macOS/Unix Configuration
    if(EXISTS "${WEAK_NODE_API_LIB_RELEASE}")
        set_target_properties(weak-node-api PROPERTIES
            IMPORTED_LOCATION_RELEASE "${WEAK_NODE_API_LIB_RELEASE}"
        )
    endif()

    if(EXISTS "${WEAK_NODE_API_LIB_DEBUG}")
        set_target_properties(weak-node-api PROPERTIES
            IMPORTED_LOCATION_DEBUG "${WEAK_NODE_API_LIB_DEBUG}"
        )
    endif()

    # Fallback
    if(NOT EXISTS "${WEAK_NODE_API_LIB_DEBUG}" AND EXISTS "${WEAK_NODE_API_LIB_RELEASE}")
        set_target_properties(weak-node-api PROPERTIES
            IMPORTED_LOCATION_DEBUG "${WEAK_NODE_API_LIB_RELEASE}"
        )
    endif()
endif()
