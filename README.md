# Android Project Template

> [!WARNING]
> It is created only for Linux

This project based on [guide to build raylib project for Android](https://github.com/raysan5/raylib/wiki/Working-for-Android-(on-Linux))
but the project doesn't use NDK. The project is a template for creating java android projects using just shell script.

## Why?

1. Simple to use
2. No Gradle

## Requirements

- You need to have OpenJDK to create android apps. You can install it [here](https://openjdk.org)
- `apksigner`. You can install it with `sudo apt install apksigner` (or something like that)

## Setup

### Step 1

Install [command line tools](https://developer.android.com/studio/#command-tools) (At the page bottom).
After installing decompress the file into `android/sdk`. Make sure there is a `cmdline-tools` folder. 

### Step 2

Just run this script it will install SDK and generate **keystore**:

``` shell
cd android/sdk/cmdline-tools/bin
./sdkmanager --update --sdk_root=../..
./sdkmanager --install "build-tools;29.0.3" --sdk_root=../..
./sdkmanager --install "platform-tools" --sdk_root=../..
./sdkmanager --install "platforms;android-29" --sdk_root=../..
cd ../../../..

cd android
keytool -genkeypair -validity 1000 -dname "CN=project,O=Android,C=ES" -keystore project.keystore -storepass 'project' -keypass 'project' -alias projectKey -keyalg RSA
cd ..

mkdir -p android/build/assets
mkdir -p android/build/dex
```

## Usage

To build the app (it means generate an apk file) just run this:

> [!TIP]
> If you connect your device to your computer and enable on the device **debug mode** you can install an apk there.

``` console
./build.sh
```

The main file is `android/build/src/com/template/project/MainActivity.java` (why is it so long?).
You can start write your app there.
