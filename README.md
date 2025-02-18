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
- Android SDK
    Install [Android command line toools](https://developer.android.com/studio/#command-tools). Unzip it, go to the `bin` folder and run this:
    ``` console
    ./sdkmanager --update --sdk_root=<path_to_sdk>
    ./sdkmanager --install "build-tools;29.0.3" --sdk_root=<path_to_sdk>
    ./sdkmanager --install "platform-tools" --sdk_root=<path_to_sdk>
    ./sdkmanager --install "platforms;android-29" --sdk_root=<path_to_sdk>
    ```

## Setup

There are `build_java.sh` and `build_kotlin.sh`. They don't depend on each other.
If you want to write in java pick `build_java.sh`, in kotlin - `build_kotlin.sh`.
The picked one you can rename to `build.sh` and another remove.
Then configure your `build.sh` by changing this variables:

> [!NOTE]
> You must replace `ANDROID_HOME` with your path to sdk

``` console
# Configuration
ANDROID_HOME="sdk"
APP_LABEL_NAME=Application
APP_COMPANY_NAME=example
APP_PRODUCT_NAME=project
APP_KEYSTORE_PASS=$APP_PRODUCT_NAME
```

Setup the project:
``` console
./build.sh setup
```

## Usage

To build the app (it means generate an apk file) just run this:

> [!TIP]
> If you connect your device to your computer and enable on the device **debug mode** you can install an apk there.

``` console
./build.sh
```

> [!NOTE]
> If `./build.sh` fails with error `Failure [INSTALL_FAILED_UPDATE_INCOMPATIBLE: Existing package com.example.project signatures do not match newer version; ignoring!]`.
> You may fix it by `$ANDROID_HOME/platform-tools/adb uninstall <package_specified_in_the_error>`

The main file in `src/<your_package>/`. You can start write your app there.
