cmake_minimum_required(VERSION 3.10)
project(cruby-android)

message("Using compiler toolchain ${CMAKE_CXX_ANDROID_TOOLCHAIN_PREFIX}...${CMAKE_CXX_ANDROID_TOOLCHAIN_SUFFIX}")

file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/download)
file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/target)

configure_file(${CMAKE_SOURCE_DIR}/tools/env.src.template ${CMAKE_SOURCE_DIR}/target/env.src @ONLY)
set(SETUP_COMMAND . ${CMAKE_SOURCE_DIR}/target/env.src )

add_subdirectory(${CMAKE_SOURCE_DIR}/ruby-build)
