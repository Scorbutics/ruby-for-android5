#!/bin/sh

ABI_VERSION=4.9
NDK_VERSION=r21e

# Set this to your minSdkVersion.
PLATFORM_VERSION=26

ARCH="aarch64"
ARCH2="arm64"
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
GCC_TOOLCHAIN="$ANDROID_NDK/toolchains/$TARGET-$ABI_VERSION/prebuilt/$HOST_TAG/$TARGET"

SYSROOT="$ANDROID_NDK/sysroot"
CLANG_TARGET="-target $TARGET$PLATFORM_VERSION"
export CFLAGS="-MMD -MP -D__android__ -DANDROID -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -Wno-invalid-command-line-argument -Wno-unused-command-line-argument"
export CPPFLAGS="$CFLAGS"

export CC="$TOOLCHAIN_BIN/clang $CLANG_TARGET"
export CXX="$TOOLCHAIN_BIN/clang++ $CLANG_TARGET"

#export AR="$TARGET-ar"
#export RANLIB="$TARGET-ranlib"
#export STRIP="$TARGET-strip"
export AR="$TOOLCHAIN_BIN/llvm-ar"
export STRIP="$TOOLCHAIN_BIN/llvm-strip"
export RANLIB="$TOOLCHAIN_BIN/llvm-ranlib"

export LD="$TOOLCHAIN_BIN/clang $CLANG_TARGET"
export AS="$CC"

PATH="$TOOLCHAIN_BIN:$PATH"

#export LD="$TARGET-ld"

#export LD="$TOOLCHAIN_BIN/ld.lld"
#export LDFLAGS="-L$TOOLCHAIN/lib"
#export LDFLAGS="-L$TOOLCHAIN/lib/gcc/$TARGET/$ABI_VERSION.x/"

export LDFLAGS="-lm"

cd ruby-build/
make
