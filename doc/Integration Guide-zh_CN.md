# 集成指引

## 环境准备

- 仅支持 Flutter 3.16.9 及以下版本。

- Android 端开发：

  - Android Studio 3.5及以上版本。

  - App 要求 Android 4.1及以上版本设备。

- iOS 端开发：

  - Xcode 11.0及以上版本。

  - OSX 系统版本要求 10.11 及以上版本。

  - 请确保您的项目已设置有效的开发者签名。

## 快速集成

### 在项目的 pubspec.yaml 中添加依赖

目前仅支持通过 github 集成，暂不支持通过 pub 集成，在`pubspec.yaml`中增加配置：

```
flutter_effect_player:
  git:
    url: https://github.com/Tencent-RTC/EffectPlayer_Flutter
```

如果需要特定版本，可以指定通过 ref 依赖的 tag 来指定到对应版本，如下所示：

```
flutter_effect_player:
  git:
    url: https://github.com/Tencent-RTC/EffectPlayer_Flutter
    ref: release_example_tag
```

