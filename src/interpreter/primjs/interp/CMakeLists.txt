include_directories(${VM_ROOT_DIR}/src ${VM_ROOT_DIR}/src/interpreter
                    ${VM_ROOT_DIR}/ ${VM_ROOT_DIR}/../)

file(GLOB SRC "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")

add_library(primjs_static STATIC ${SRC})

if(${ENABLE_QUICKJS_DEBUGGER})
  target_sources(primjs_static
                 PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/mac/embedded-inspector.S")
else()
  target_sources(primjs_static
                 PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/mac/embedded.S")
endif()

target_link_libraries(primjs_static quick_static)
