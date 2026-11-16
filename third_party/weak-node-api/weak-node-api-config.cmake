# Get the current file directory
get_filename_component(WEAK_NODE_API_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)

if(NOT DEFINED WEAK_NODE_API_LIB)
    # Auto-detect library path for Android NDK builds
    if(ANDROID)
        # Define the library path pattern for Android
        set(WEAK_NODE_API_LIB_PATH "weak-node-api.android.node/${ANDROID_ABI}/libweak-node-api.so")
        
        # Try Debug first, then Release using the packaged Android node structure
        set(WEAK_NODE_API_LIB_DEBUG "${WEAK_NODE_API_CMAKE_DIR}/build/Debug/${WEAK_NODE_API_LIB_PATH}")
        set(WEAK_NODE_API_LIB_RELEASE "${WEAK_NODE_API_CMAKE_DIR}/build/Release/${WEAK_NODE_API_LIB_PATH}")
        
        if(EXISTS "${WEAK_NODE_API_LIB_DEBUG}")
            set(WEAK_NODE_API_LIB "${WEAK_NODE_API_LIB_DEBUG}")
            message(STATUS "Using Debug weak-node-api library: ${WEAK_NODE_API_LIB}")
        elseif(EXISTS "${WEAK_NODE_API_LIB_RELEASE}")
            set(WEAK_NODE_API_LIB "${WEAK_NODE_API_LIB_RELEASE}")
            message(STATUS "Using Release weak-node-api library: ${WEAK_NODE_API_LIB}")
        else()
            message(FATAL_ERROR "Could not find weak-node-api library for Android ABI ${ANDROID_ABI}. Expected at:\n  ${WEAK_NODE_API_LIB_DEBUG}\n  ${WEAK_NODE_API_LIB_RELEASE}")
        endif()
    else()
        message(FATAL_ERROR "WEAK_NODE_API_LIB is not set")
    endif()
endif()

if(NOT DEFINED WEAK_NODE_API_INC)
    set(WEAK_NODE_API_INC "${WEAK_NODE_API_CMAKE_DIR}/include;${WEAK_NODE_API_CMAKE_DIR}/generated")
    message(STATUS "Using weak-node-api include directories: ${WEAK_NODE_API_INC}")
endif()

add_library(weak-node-api SHARED IMPORTED)

set_target_properties(weak-node-api PROPERTIES
    IMPORTED_LOCATION "${WEAK_NODE_API_LIB}"
    INTERFACE_INCLUDE_DIRECTORIES "${WEAK_NODE_API_INC}"
)
