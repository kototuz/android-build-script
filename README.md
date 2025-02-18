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
After installing decompress the file into `sdk` folder. Make sure there is a `cmdline-tools` folder in the `sdk` folder. 

### Step 2

Just run this script it will install SDK and generate **keystore**:

``` shell
cd sdk/cmdline-tools/bin
./sdkmanager --update --sdk_root=../..
./sdkmanager --install "build-tools;29.0.3" --sdk_root=../..
./sdkmanager --install "platform-tools" --sdk_root=../..
./sdkmanager --install "platforms;android-29" --sdk_root=../..
cd ../../..

mkdir -p build
keytool -genkeypair -validity 1000 -dname "CN=project,O=Android,C=ES" -keystore ./build/project.keystore -storepass 'project' -keypass 'project' -alias projectKey -keyalg RSA
```

## Usage

To build the app (it means generate an apk file) just run this:

> [!TIP]
> If you connect your device to your computer and enable on the device **debug mode** you can install an apk there.

``` console
./build.sh
```

The main file is `src/com/template/project/MainActivity.java` (why is it so long?).
You can start write your app there.

> [!WARNING]
> Your apps may conflict if they have the same package name.
> So you should change the default package name `com.template.project` (don't forget change it in `AndroidManifest.xml`)
