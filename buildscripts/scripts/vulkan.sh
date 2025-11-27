#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

build=_build$ndk_suffix

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf $build
	exit 0
else
	exit 255
fi

cmake -S . -B build \
  -D CMAKE_TOOLCHAIN_FILE=../../sdk/android-sdk-linux/ndk/$v_ndk/build/cmake/android.toolchain.cmake \
  -D ANDROID_PLATFORM=26 \
  -D CMAKE_ANDROID_ARCH_ABI=$prefix_name \
  -D CMAKE_ANDROID_STL_TYPE=c++_static \
  -D ANDROID_USE_LEGACY_TOOLCHAIN_FILE=NO \
  -D CMAKE_BUILD_TYPE=Release \
  -D UPDATE_DEPS=ON \
  -G Ninja

cmake --build build

cmake --install build --prefix "$prefix_dir"

mkdir -p "$prefix_dir"/lib/pkgconfig
cat >"$prefix_dir"/lib/pkgconfig/vulkan.pc <<END
Name: Vulkan
Description:
Version: $v_vulkan
Libs: -lvulkan
Cflags:
END