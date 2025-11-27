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

cmake -S . -B build

cmake --install build --prefix "$prefix_dir"

mkdir -p "$prefix_dir"/lib/pkgconfig
cat >"$prefix_dir"/lib/pkgconfig/vulkan.pc <<END
Name: Vulkan
Description:
Version: $v_vulkan
Libs: -lvulkan
Cflags:
END