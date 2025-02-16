add_executable(
    UserTimelineService
    UserTimelineService.cpp
    ${THRIFT_GEN_CPP_DIR}/UserTimelineService.cpp
    ${THRIFT_GEN_CPP_DIR}/social_network_types.cpp
    ${THRIFT_GEN_CPP_DIR}/PostStorageService.cpp
)

target_include_directories(
    UserTimelineService PRIVATE
    ${MONGOC_INCLUDE_DIRS}
    # /usr/local/include/jaegertracing
    /usr/local/include/hiredis
    /usr/local/include/sw
)

target_link_libraries(
    UserTimelineService
    ${MONGOC_LIBRARIES}
    nlohmann_json::nlohmann_json
    ${THRIFT_LIB}
    ${CMAKE_THREAD_LIBS_INIT}
    ${Boost_LIBRARIES}
    Boost::log
    Boost::log_setup
    Boost::program_options
    # jaegertracing
    /usr/local/lib/libhiredis.so
    /usr/local/lib/libhiredis_ssl.so
    /usr/local/lib/libredis++.a
    OpenSSL::SSL
    opentracing
    yaml-cpp
    ${OPENTELEMETRY_CPP_LIBRARIES}
)

install(TARGETS UserTimelineService DESTINATION ./)