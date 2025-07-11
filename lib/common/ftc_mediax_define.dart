// Copyright (c) 2025 Tencent. All rights reserved.
part of '../ftceffect_player.dart';

typedef FTCMediaLicenseListener = void Function(int errCode, String msg);

typedef FResImgResultFetcher = Uint8List Function(FEffectResource res);
typedef FResTextResultFetcher = FTCEffectText Function(FEffectResource res);
typedef FResReleaseListener = void Function(List<FEffectResource> resList);
typedef FResClickListener = void Function(FEffectResource res);
typedef FEmptyFunction = void Function();
typedef FIntParamsFunction = void Function(int code);
typedef FOnPlayEventFunction = void Function(int event, Map params);
typedef FEffectViewControllerCallback = void Function(FTCEffectViewController controller);

const _kFTCEffectAnimViewType = "FlutterEffectAnimView";

enum FVideoMode {
  VIDEO_MODE_NONE,
  VIDEO_MODE_SPLIT_HORIZONTAL,
  VIDEO_MODE_SPLIT_VERTICAL,
  VIDEO_MODE_SPLIT_HORIZONTAL_REVERSE,
  VIDEO_MODE_SPLIT_VERTICAL_REVERSE,
}

enum FScaleType {
  FIT_XY,
  FIT_CENTER,
  CENTER_CROP,
}

enum FCodecType {
  TC_MPLAYER,
  TC_MCODEC,
  TX_LITEAV_SDK,
}

enum FFreezeFrame {
  FREEZE_FRAME_NONE,
  FREEZE_FRAME_LAST,
}

enum FAnimType { AUTO, MP4, TCMP4 }

class FEffectResource {
  String? id;
  String? srcType;
  String? loadType;
  String? tag;
  Uint8List? bitmapByte;
  String? text;

  static FEffectResource copyFromMsg(FResourceMsg msg) {
    return FEffectResource()
      ..id = msg.id
      ..srcType = msg.srcType
      ..loadType = msg.loadType
      ..tag = msg.tag
      ..bitmapByte = msg.bitmapByte
      ..text = msg.text;
  }
}

class FTCEffectText {
  static const TEXT_ALIGNMENT_NONE = -1;
  static const TEXT_ALIGNMENT_LEFT = 0;
  static const TEXT_ALIGNMENT_CENTER = 1;
  static const TEXT_ALIGNMENT_RIGHT = 2;

  String? text;
  String? fontStyle;
  int? color;
  int? alignment;
  double? fontSize;

  static FTCEffectText copyFromMsg(FTCEffectTextMsg msg) {
    return FTCEffectText()
      ..text = msg.text
      ..fontStyle = msg.fontStyle
      ..color = msg.color
      ..alignment = msg.alignment
      ..fontSize = msg.fontSize;
  }

  FTCEffectTextMsg toMsg() {
    return FTCEffectTextMsg()
      ..text = text
      ..fontStyle = fontStyle
      ..color = color
      ..alignment = alignment
      ..fontSize = fontSize;
  }
}

class FTCEffectAnimInfo {
  int? type;

  int? duration;

  int? width;

  int? height;

  int? encryptLevel;

  FMixInfo? mixInfo;

  static FTCEffectAnimInfo copyFromMsg(FTCEffectAnimInfoMsg msg) {
    // msg.mixInfo?.
    return FTCEffectAnimInfo()
      ..type = msg.type
      ..duration = msg.duration
      ..width = msg.width
      ..height = msg.height
      ..encryptLevel = msg.encryptLevel
      ..mixInfo = msg.mixInfo != null ? FMixInfo.copyFromMsg(msg.mixInfo!) : null;
  }
}

class FMixInfo {
  List<FMixItem> textMixItemList = [];

  List<FMixItem> imageMixItemList = [];

  static FMixInfo copyFromMsg(FMixInfoMsg msg) {
    return FMixInfo()
      ..imageMixItemList =
          UnmodifiableListView(msg.imageMixItemList?.map((item) => FMixItem.copyFromMsg(item)).toList() ?? [])
      ..textMixItemList =
          UnmodifiableListView(msg.textMixItemList?.map((item) => FMixItem.copyFromMsg(item)).toList() ?? []);
  }
}

class FMixItem {
  String? id;

  String? tag;

  String? text;

  static FMixItem copyFromMsg(FMixItemMsg msg) {
    return FMixItem()
      ..id = msg.id
      ..tag = msg.tag
      ..text = msg.text;
  }
}

class FResourceFetcher {
  FResImgResultFetcher? imgFetcher;

  FResTextResultFetcher? textFetcher;

  FResReleaseListener? releaseListener;

  FResourceFetcher({this.imgFetcher, this.textFetcher, this.releaseListener});
}

class FAnimPlayListener {
  FEmptyFunction? onPlayStart;

  FEmptyFunction? onPlayEnd;

  FIntParamsFunction? onPlayError;

  FOnPlayEventFunction? onPlayEvent;

  FAnimPlayListener({this.onPlayStart, this.onPlayEnd, this.onPlayError, this.onPlayEvent});
}

class FTCEffectPlayerConstant {
  static const  REPORT_INFO_ON_PLAY_EVT_PLAY_END = 2006;
  static const  REPORT_INFO_ON_PLAY_EVT_RCV_FIRST_I_FRAME = 2003;
  static const  REPORT_INFO_ON_PLAY_EVT_CHANGE_RESOLUTION = 2009;
  static const  REPORT_INFO_ON_PLAY_EVT_LOOP_ONCE_COMPLETE = 6001;
  static const  REPORT_INFO_ON_VIDEO_CONFIG_READY = 200001;
  static const  REPORT_INFO_ON_NEED_SURFACE = 200002;
  static const  REPORT_INFO_ON_VIDEO_SIZE_CHANGE = 200003;
  static const  REPORT_ANIM_INFO = 200004;

  static const  REPORT_ERROR_TYPE_HEVC_NOT_SUPPORT = -10007;
  static const  REPORT_ERROR_TYPE_INVALID_PARAM = -10008;
  static const  REPORT_ERROR_TYPE_INVALID_LICENSE = -10009;
  static const  REPORT_ERROR_TYPE_ADVANCE_MEDIA_PLAYER = -10010;
  static const  REPORT_ERROR_TYPE_MC_DECODER = -10011;
  static const  REPORT_ERROR_TYPE_UNKNOWN_ERROR = -20000;
}