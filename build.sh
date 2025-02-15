#!/bin/sh

# stop on error and display each command as it gets executed. Optional step but helpful in catching where errors happen if they do.
set -xe

BUILD_TOOLS=android/sdk/build-tools/29.0.3

$BUILD_TOOLS/aapt package -f -m \
	-S android/build/res -J android/build/src -M android/build/AndroidManifest.xml \
	-I android/sdk/platforms/android-29/android.jar

# Compile MainActivity.java
javac -verbose -source 1.8 -target 1.8 -d android/build/obj \
	-bootclasspath jre/lib/rt.jar \
	-classpath android/sdk/platforms/android-29/android.jar:android/build/obj \
	-sourcepath src android/build/src/com/template/project/R.java \
	android/build/src/com/template/project/MainActivity.java

$BUILD_TOOLS/dx --verbose --dex --output=android/build/dex/classes.dex android/build/obj

# Add resources and assets to APK
$BUILD_TOOLS/aapt package -f \
	-M android/build/AndroidManifest.xml -S android/build/res -A android/build/assets \
	-I android/sdk/platforms/android-29/android.jar -F app.apk android/build/dex

# Zipalign APK and sign
# NOTE: If you changed the storepass and keypass in the setup process, change them here too
$BUILD_TOOLS/zipalign -f 4 app.apk game.final.apk
mv -f game.final.apk app.apk

# Install apksigner with `sudo apt install apksigner`
apksigner sign  --ks android/project.keystore --out my-app-release.apk --ks-pass pass:project app.apk
mv my-app-release.apk app.apk

# Install to device or emulator
android/sdk/platform-tools/adb install -r app.apk
