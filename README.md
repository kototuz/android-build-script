# Android Project Template

> [!WARNING]
> It is created only for Linux

This project was inspired by [guide to build raylib project for Android](https://github.com/raysan5/raylib/wiki/Working-for-Android-(on-Linux))
but the project doesn't use NDK.

## Why?

1. Simple to use
2. No Gradle. No Android Studio

## Requirements

- **Kotlin**. If you are using `Kotlin.mk`
- **OpenJDK**. You can install it [here](https://openjdk.org)
- **Android SDK**
    Install [Android command line toools](https://developer.android.com/studio/#command-tools). Unzip it, go to the `bin` folder and run this:
    ``` console
    ./sdkmanager --update --sdk_root=<path_to_sdk>
    ./sdkmanager --install "build-tools;34.0.0" --sdk_root=<path_to_sdk>
    ./sdkmanager --install "platform-tools" --sdk_root=<path_to_sdk>
    ./sdkmanager --install "platforms;android-29" --sdk_root=<path_to_sdk>
    ```

## Setup

There are `Java.mk` and `Kotlin.mk`. They don't depend on each other.
If you want to write in java pick `Java.mk`, in kotlin - `Kotlin.mk`.
Then change settings in your makefile.

Init the project. It will generate basic android project:
``` console
make init
```

## Usage

To build the app (it means generate an apk file) just run this:

> [!TIP]
> If you connect your device to your computer and enable on the device **debug mode** you can install an apk there.

``` console
make
```
