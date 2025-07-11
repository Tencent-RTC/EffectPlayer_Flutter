// Copyright (c) 2025 Tencent. All rights reserved.
part of '../ftceffect_player.dart';

class FTCEffectConfig {

  FCodecType? codecType;

  FFreezeFrame? freezeFrame;

  FAnimType? animType;

  Map<String, Object> extendMapParams = {};

  FTCEffectConfigMsg toMsg() {
    return FTCEffectConfigMsg()
      ..codecTypeValue = codecType?.index
      ..animTypeValue = animType?.index
      ..freezeFrame = freezeFrame?.index
      ..extendMapParams = extendMapParams;
  }

}