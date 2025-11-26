# --------------------------------------------------

if [ ! -f "deps" ]; then
  sudo rm -r deps
fi
if [ ! -f "prefix" ]; then
  sudo rm -r prefix
fi

./download.sh
./patch.sh

# --------------------------------------------------

./build.sh || exit 1

# --------------------------------------------------

echo "chdir media-kit-android-helper"
cd deps/media-kit-android-helper || exit 1

sudo chmod +x gradlew
./gradlew assembleRelease

unzip -o app/build/outputs/apk/release/app-release.apk -d app/build/outputs/apk/release

cp ../../prefix/arm64-v8a/usr/local/lib/libmpv.so      app/build/outputs/apk/release/lib/arm64-v8a
cp ../../prefix/armeabi-v7a/usr/local/lib/libmpv.so    app/build/outputs/apk/release/lib/armeabi-v7a
cp ../../prefix/x86/usr/local/lib/libmpv.so            app/build/outputs/apk/release/lib/x86
cp ../../prefix/x86_64/usr/local/lib/libmpv.so         app/build/outputs/apk/release/lib/x86_64

cd app/build/outputs/apk/release

zip -r default-arm64-v8a.jar      lib/arm64-v8a/*.so
zip -r default-armeabi-v7a.jar    lib/armeabi-v7a/*.so
zip -r default-x86.jar            lib/x86/*.so
zip -r default-x86_64.jar         lib/x86_64/*.so

md5sum *.jar

cd ../../../../../../..

mkdir -p artifacts/default
cp deps/media-kit-android-helper/app/build/outputs/apk/release/default-*.jar artifacts/default/