# Integration Guide

## Environment Preparation

- Only supports Flutter 3.16.9 and below.

- Android development:
  - Android Studio 3.5 and above.

  - App requires Android 4.1 and above devices.

- iOS development:
  - Xcode 11.0 and above.

  - OSX system version requires 10.11 and above.

  - Please make sure your project has set a valid developer signature.


## Quick integration

### Add dependencies in the project's pubspec.yaml

Currently, only integration through github is supported, and integration through pub is not supported yet. Add configuration in `pubspec.yaml`:

```
flutter_effect_player:
  git:
    url: https://github.com/Tencent-RTC/EffectPlayer_Flutter
```

If a specific version is required, you can specify the corresponding version through the tag of the ref dependency, as shown below:

```
flutter_effect_player:
  git:
    url: https://github.com/Tencent-RTC/EffectPlayer_Flutter
    ref: release_example_tag
```
