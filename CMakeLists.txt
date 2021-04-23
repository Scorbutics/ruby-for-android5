cmake_minimum_required(VERSION 3.9)
project(cruby-android)

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/arm64-v8a-android-toolchain.cmake)

message("Using compiler toolchain ${CMAKE_CXX_ANDROID_TOOLCHAIN_PREFIX}...${CMAKE_CXX_ANDROID_TOOLCHAIN_SUFFIX}")

set(OPENSSL_VERSION "1.1.1k")
set(ZLIB_VERSION "1.2.11")
set(RUBY_RELEASE "3.0")
set(RUBY_SRC_VERSION "${RUBY_RELEASE}.0")
set(RUBY_SRC_DIR "ruby-${RUBY_SRC_VERSION}")

set(INCLUDE_DIR_USR "${CMAKE_SOURCE_DIR}/target/usr/include")
set(INCLUDE_DIR_USR_LOCAL "${CMAKE_SOURCE_DIR}/target/usr/local/include")
set(LINK_DIR_USR "${CMAKE_SOURCE_DIR}/target/usr/lib")
set(LINK_DIR_USR_LOCAL "${CMAKE_SOURCE_DIR}/target/usr/local/lib")

include_directories(${INCLUDE_DIR_USR} ${INCLUDE_DIR_USR_LOCAL})
link_directories(${LINK_DIR_USR} ${LINK_DIR_USR_LOCAL} ${CMAKE_SOURCE_DIR}/${RUBY_SRC_DIR})

file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/download)
file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/target)

set(SETUP_COMMAND CMAKE_CXX_ANDROID_TOOLCHAIN_PREFIX=${CMAKE_CXX_ANDROID_TOOLCHAIN_PREFIX} CMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION} source ${CMAKE_SOURCE_DIR}/tools/env.src)

add_subdirectory(${CMAKE_SOURCE_DIR}/ruby-build)
