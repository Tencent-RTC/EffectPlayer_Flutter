// Copyright (c) 2025 Tencent. All rights reserved.
part of '../ftceffect_player.dart';

class FTCMediaXBase extends FTCMediaXBaseFlutterEvent{

  static FTCMediaXBase? _instance;

  static FTCMediaXBase get instance => _getInstance();

  /// FTCMediaXBase instance
  static FTCMediaXBase _getInstance() {
    _instance ??= FTCMediaXBase._internal();
    return _instance!;
  }

  FTCMediaLicenseListener? curLicenseListener;
  FTCMediaXBaseApi mediaXBaseApi = FTCMediaXBaseApi();

  FTCMediaXBase._internal() {
    FTCMediaXBaseFlutterEvent.setUp(this);
  }

  ///  mediaXBase api start ///

  Future<void> setLicense(String url, String key, FTCMediaLicenseListener listener) async {
    curLicenseListener = listener;
    return await mediaXBaseApi.setLicense(url, key);
  }

  Future<void> setLogEnable(bool enable) async {
    return await mediaXBaseApi.setLogEnable(enable);
  }

  /// 设置是否启用兼容模式
  /// 当启用时，在特定设备（如 Pixel）上动画 PlatformView 会使用更稳定的渲染方式，
  /// 可以避免出现的 fd 泄漏和 GPU crash 问题。
  /// @param enable true 启用兼容模式（默认），false 禁用
  Future<void> enableCompatMode(bool enable) async {
    return await mediaXBaseApi.enableCompatMode(enable);
  }

  ///  mediaXBase api end ///


  ///  mediaXBase event start ///

  @override
  void onLicenseResult(int errCode, String msg) {
    curLicenseListener?.call(errCode, msg);
  }

  ///  mediaXBase event end ///
}