# 快速跑通 Demo

## 环境准备

- 仅支持 Flutter 3.16.9 及以下版本。

- Android 端开发：

  - Android Studio 2.0 或以上版本。

  - Android SDK API Level 19 及以上。

  - Android 4.4 及以上，支持 armeabi-v7a、arm-v8a 架构的移动设备。

- iOS 端开发：

  - Xcode 11.0及以上版本。

  - OSX 系统版本要求 10.11 及以上版本。

  - 请确保您的项目已设置有效的开发者签名。

## 快速集成

### 导入项目

把 EffectPlayer_Flutter 项目导入到 Android Studio 后拉取依赖。

### 申请 License

中国站客户 [点击这里](https://cloud.tencent.com/document/product/616/116465) 申请 礼物动画特效测试 License。

成功申请到 LicenseUrl 和 LicenseKey 后，把它们赋值给 example/lib/main.dart 里面的 LICENSE_URL 和 LICENSE_KEY 字段。

### 运行项目

Android 端：把  example/android/app/build.gradle.kts 文件里 applicationId = "com.tencent.tcmediax.demo" 替换为申请 License 是填写的Package Name。

iOS 端： 把 example 运行的 Bundle Identifer 替换为 申请 License 时填写的 Bundle ID。
