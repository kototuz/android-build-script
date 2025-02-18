#!/bin/sh

# stop on error and display each command as it gets executed. Optional step but helpful in catching where errors happen if they do.
set -xe

BUILD_TOOLS=sdk/build-tools/29.0.3

mkdir -p build build/dex

$BUILD_TOOLS/aapt package -f -m \
	-S ./res -J ./src -M ./AndroidManifest.xml \
	-I sdk/platforms/android-29/android.jar

# Compile MainActivity.java
javac -verbose -source 1.8 -target 1.8 -d ./build/obj \
	-bootclasspath jre/lib/rt.jar \
	-classpath sdk/platforms/android-29/android.jar:./build/obj \
	-sourcepath src ./src/com/template/project/R.java \
	./src/com/template/project/MainActivity.java

$BUILD_TOOLS/dx --verbose --dex --output=./build/dex/classes.dex ./build/obj

# Add resources and assets to APK
$BUILD_TOOLS/aapt package -f \
	-M ./AndroidManifest.xml -S ./res -A ./assets \
	-I sdk/platforms/android-29/android.jar -F ./build/app.apk ./build/dex

# Zipalign APK and sign
# NOTE: If you changed the storepass and keypass in the setup process, change them here too
$BUILD_TOOLS/zipalign -f 4 ./build/app.apk game.final.apk
mv -f game.final.apk ./build/app.apk

# Install apksigner with `sudo apt install apksigner`
apksigner sign  --ks ./build/project.keystore --out ./build/my-app-release.apk --ks-pass pass:project ./build/app.apk
mv ./build/my-app-release.apk ./build/app.apk

# Install to device or emulator
sdk/platform-tools/adb install -r ./build/app.apk
