// Copyright (c) 2025 Tencent. All rights reserved.
import 'package:pigeon/pigeon.dart';

/// Pigeon original component, used to generate native communication code for `messages`.
/// The generation command is as follows. When using the generation command,
/// the two import statements above need to be implemented or commented out.
///
/*
    dart run pigeon \
    --input pigeons/tceffect_messages.dart \
    --dart_out lib/message/tceffect_messages.dart \
    --objc_header_out ios/Classes/messages/TCEffectMessages.h \
    --objc_source_out ios/Classes/messages/TCEffectMessages.m \
    --java_out ./android/src/main/java/com/tcmedia/tcmediax/tceffectplayer/tceffectplayer_flutter/messages/TCEffectMessages.java \
    --java_package "com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.messages" \
    --copyright_header pigeons/tceffect_copy_right.txt
 */

class FTCEffectConfigMsg {

  int? codecTypeValue;

  int? freezeFrame;

  int? animTypeValue;

  Map? extendMapParams;
}

class FTCEffectAnimInfoMsg {

  int? type;

  int? duration;

  int? width;

  int? height;

  int? encryptLevel;

  FMixInfoMsg? mixInfo;
}

class FMixInfoMsg {

  List<FMixItemMsg>? textMixItemList;

  List<FMixItemMsg>? imageMixItemList;

}

class FMixItemMsg {

  String? id;

  String? tag;

  String? text;

}

class FResourceMsg {
  String? id;
  String? srcType;
  String? loadType;
  String? tag;
  Uint8List? bitmapByte;
  String? text;
}

class FTCEffectTextMsg {
  String? text;
  String? fontStyle;
  int? color;
  int? alignment;
  double? fontSize;
}

@HostApi()
abstract class FTCMediaXBaseApi {

  void setLicense(String url, String key);

  void setLogEnable(bool enable);

}

@HostApi()
abstract class FTCEffectAnimViewApi {

  int startPlay(String playUrl);

  void setVideoMode(int videoModeValue);

  void setConfig(FTCEffectConfigMsg config);

  void setScaleType(int scaleTypeValue);

  void requestUpdateResource();

  void setRenderRotation(int rotation);

  bool isPlaying();

  void resume();

  void pause();

  void seekTo(int milliSec);

  void seekProgress(double progress);

  void setLoop(bool isLoop);

  void setLoopCount(int loopCount);

  void setDuration(int durationInMilliSec);

  void stopPlay(bool clearLastFrame);

  void setMute(bool mute);

  FTCEffectAnimInfoMsg getTCAnimInfo();

  void onDestroy();

  void setRate(double rate);

  String getSdkVersion();

  FTCEffectAnimInfoMsg preloadTCAnimInfo(String playUrl, FTCEffectConfigMsg config);
}

@FlutterApi()
abstract class FTCMediaXBaseFlutterEvent {

  void onLicenseResult(int errCode, String msg);

}

@FlutterApi()
abstract class FTCEffectAnimViewFlutterEvent {

  Uint8List? fetchImage(FResourceMsg res);

  FTCEffectTextMsg? fetchText(FResourceMsg res);

  void releaseResource(List<FResourceMsg> resourceList);

  void onResClick(FResourceMsg res);

  void onPlayStart();

  void onPlayEnd();

  void onPlayError(int errCode);

  void onPlayEvent(int event, Map param);
}

