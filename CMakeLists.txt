cmake_minimum_required(VERSION 3.25)
project(social_network_microservices)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_FLAGS "-O3")
set(CMAKE_INSTALL_PREFIX /usr/local/bin)

add_subdirectory(src)
#add_subdirectory(test)
#enable_testing()


