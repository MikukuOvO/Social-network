add_executable(
    UniqueIdService
    UniqueIdService.cpp
    ${THRIFT_GEN_CPP_DIR}/UniqueIdService.cpp
    ${THRIFT_GEN_CPP_DIR}/ComposePostService.cpp
    ${THRIFT_GEN_CPP_DIR}/social_network_types.cpp
)

# target_include_directories(
#     UniqueIdService PRIVATE
#     # /usr/local/include/jaegertracing
# )

target_link_libraries(
    UniqueIdService
    nlohmann_json::nlohmann_json
    ${THRIFT_LIB}
    ${CMAKE_THREAD_LIBS_INIT}
    ${Boost_LIBRARIES}
    Boost::log
    Boost::log_setup
    # jaegertracing
    opentracing
    yaml-cpp
    ${OPENTELEMETRY_CPP_LIBRARIES}
)

install(TARGETS UniqueIdService DESTINATION ./)