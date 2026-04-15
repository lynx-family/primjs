get_filename_component(WEAK_NODE_API_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)

if(NOT DEFINED WEAK_NODE_API_INC)
    set(WEAK_NODE_API_INC "${WEAK_NODE_API_CMAKE_DIR}/headers;${WEAK_NODE_API_CMAKE_DIR}/generated")
endif()

if(NOT TARGET weak-node-api-headers)
    add_library(weak-node-api-headers INTERFACE)
    set_target_properties(weak-node-api-headers PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${WEAK_NODE_API_INC}"
    )
endif()
