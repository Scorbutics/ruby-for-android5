cmake_minimum_required(VERSION 3.9)
project(cruby-android)

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/arm64-v8a-android-toolchain.cmake)

message("Using compiler toolchain ${CMAKE_CXX_ANDROID_TOOLCHAIN_PREFIX}...${CMAKE_CXX_ANDROID_TOOLCHAIN_SUFFIX}")

set(RUBY_RELEASE "3.0")
set(RUBY_SRC_VERSION "${RUBY_RELEASE}.0")
set(RUBY_SRC_DIR "ruby-${RUBY_SRC_VERSION}")

file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/download)
file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/target)

set(SETUP_COMMAND export ROOT_DIR=${CMAKE_SOURCE_DIR}\\\; export CMAKE_CXX_ANDROID_TOOLCHAIN_PREFIX=${CMAKE_CXX_ANDROID_TOOLCHAIN_PREFIX}\\\; export CMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION}\\\; source ${CMAKE_SOURCE_DIR}/tools/env.src )

add_subdirectory(${CMAKE_SOURCE_DIR}/ruby-build)
