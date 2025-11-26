#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$ndk_suffix
	exit 0
else
	exit 255
fi

mkdir -p _build$ndk_suffix
cd _build$ndk_suffix

cpu=armv7-a
[[ "$ndk_triple" == "aarch64"* ]] && cpu=armv8-a
[[ "$ndk_triple" == "x86_64"* ]] && cpu=generic
[[ "$ndk_triple" == "i686"* ]] && cpu="i686 --disable-asm"

cpuflags=
[[ "$ndk_triple" == "arm"* ]] && cpuflags="$cpuflags -mfpu=neon -mcpu=cortex-a8"

../configure \
	--target-os=android --enable-cross-compile --cross-prefix=$ndk_triple- --ar=$AR --cc=$CC --ranlib=$RANLIB \
	--arch=${ndk_triple%%-*} --cpu=$cpu --pkg-config=pkg-config --nm=llvm-nm \
	--extra-cflags="-Wno-incompatible-function-pointer-types -I$prefix_dir/include $cpuflags" --extra-ldflags="-L$prefix_dir/lib" \
	\
	--enable-gpl \
	--enable-nonfree \
	--enable-version3 \
	--enable-static \
	--disable-shared \
	--disable-iconv \
	--pkg-config-flags=--static \
	\
	--enable-decoders \
	--enable-demuxers \
	--enable-parsers \
	--enable-filters \
	\
	--disable-muxers \
	--disable-encoders \
	--disable-parsers \
	--disable-protocols \
	--disable-devices \
	--disable-doc \
	--disable-avdevice \
	--disable-programs \
	--disable-gray \
	--disable-swscale-alpha \
	\
	--enable-jni \
	--enable-bsfs \
	--enable-mediacodec \
	--enable-vulkan \
	\
	--disable-dxva2 \
	--disable-vaapi \
	--disable-vdpau \
	--disable-bzlib \
	--disable-linux-perf \
	--disable-videotoolbox \
	--disable-audiotoolbox \
	\
	--enable-small \
	--enable-hwaccels \
	--enable-optimizations \
	--enable-runtime-cpudetect \
	\
	--enable-mbedtls \
	\
	--enable-libdav1d \
	\
	--enable-libxml2 \
	\
	--enable-avutil \
	--enable-avcodec \
	--enable-avfilter \
	--enable-avformat \
	--enable-swscale \
	--enable-swresample \
	\
	--enable-libwebp \
	--enable-libplacebo \
	\
	--enable-encoder=png \
	--enable-encoder=libwebp \
	--enable-encoder=libwebp_anim \
	\
	--enable-network \

make -j$cores
make DESTDIR="$prefix_dir" install

ln -sf "$prefix_dir"/lib/libswresample.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavutil.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavcodec.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavformat.so "$native_dir"
ln -sf "$prefix_dir"/lib/libswscale.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavfilter.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavdevice.so "$native_dir"
