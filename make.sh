#!/bin/sh

ABI_VERSION=4.9
NDK_VERSION=r21e

# Set this to your minSdkVersion.
PLATFORM_VERSION=26

export ARCH="aarch64"
HOST_TAG="linux-x86_64"

# Used for --host & --build
TARGET=$ARCH-linux-android
export HOST="$TARGET"
export HOST_SHORT="android-arm64"

export ANDROID_API=$PLATFORM_VERSION

export ANDROID_NDK="/usr/local/android/android-ndk-$NDK_VERSION"
export ANDROID_NDK_HOME="$ANDROID_NDK"
export TOOLCHAIN="$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST_TAG/"
TOOLCHAIN_BIN="$TOOLCHAIN/bin"

CLANG_TARGET="-target $TARGET$PLATFORM_VERSION"
export CFLAGS="-MMD -MP -D__android__ -DANDROID -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -Wno-invalid-command-line-argument -Wno-unused-command-line-argument"
export CPPFLAGS="$CFLAGS"

export CC="$TOOLCHAIN_BIN/clang $CLANG_TARGET"
export CXX="$TOOLCHAIN_BIN/clang++ $CLANG_TARGET"
export AR="$TOOLCHAIN_BIN/llvm-ar"
export STRIP="$TOOLCHAIN_BIN/llvm-strip"
export RANLIB="$TOOLCHAIN_BIN/llvm-ranlib"
export LD="$TOOLCHAIN_BIN/clang $CLANG_TARGET"
export AS="$CC"

PATH="$TOOLCHAIN_BIN:$PATH"

export LDFLAGS="-lm"

cd ruby-build/
make "$@"
