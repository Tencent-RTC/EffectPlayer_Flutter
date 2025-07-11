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

  ///  mediaXBase api end ///


  ///  mediaXBase event start ///

  @override
  void onLicenseResult(int errCode, String msg) {
    curLicenseListener?.call(errCode, msg);
  }

  ///  mediaXBase event end ///
}