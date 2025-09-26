import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_effect_player/ftceffect_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tceffectplayer_flutter_example/tools/asset_image_cache.dart';
import 'package:tceffectplayer_flutter_example/tools/demo_asset_helper.dart';

import '../common/demo_config.dart';

class FTCEffectPlayerAnimDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FTCEffectPlayerAnimDemoState();
}

class FTCEffectPlayerAnimDemoState extends State<FTCEffectPlayerAnimDemo> {
  FTCEffectViewController? _effectViewController;
  int _curAnimIndex = 0;
  List<String> animList = DemoAssetHelper.instance.getAnimPathList();
  // use extendMapParams to set licenseKey info
  final FTCEffectConfig _curConfig = FTCEffectConfig()..extendMapParams = {"PARAM_OPTIONAL_STRING_EXTRA_LICENSE_KEY":"{your license key}"};

  ///
  /// hard code
  ///
  ///
  final Map<String, FCodecType> _codecHardCode = {
    "MP": FCodecType.TC_MPLAYER,
    "MC": FCodecType.TC_MCODEC,
    "TX": FCodecType.TX_LITEAV_SDK,
  };
  final Map<String, FAnimType> _animTypeHardCode = {
    "AUTO": FAnimType.AUTO,
    "MP4": FAnimType.MP4,
    "TCMP4": FAnimType.TCMP4,
  };
  final Map<String, FScaleType> _scaleTypeHardCode = {
    "FIT_CENTER": FScaleType.FIT_CENTER,
    "FIT_XY": FScaleType.FIT_XY,
    "CENTER_CROP": FScaleType.CENTER_CROP,
  };
  final List<double> _rateValues = [0.5, 1.0, 1.5, 2.0];
  final List<int> _rotationValue = [0, 90, 180, 270];

  ///
  /// current value
  ///
  final ValueNotifier<String?> _codecNotifier = ValueNotifier(null);
  final ValueNotifier<double?> _rateNotifier = ValueNotifier(1.0);
  final ValueNotifier<String?> _animTypeNotifier = ValueNotifier("null");
  final ValueNotifier<int?> _rotationNotifier = ValueNotifier(0);
  final ValueNotifier<bool> _muteNotifier = ValueNotifier(false);
  final ValueNotifier<String?> _scaleTypeNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _loopNotifier = ValueNotifier(false);

  FTCEffectPlayerAnimDemoState() {
    _codecNotifier.value = _codecHardCode.keys.first;
    _animTypeNotifier.value = _animTypeHardCode.keys.first;
    _scaleTypeNotifier.value = _scaleTypeHardCode.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AnimPlayerDemo"),
        actions: [_buildOptItem("playNext", _playNextAnim)],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FTCEffectAnimView(
              controllerCallback: (controller) async {
                await _setUpController(controller);
                await _handlePlayAnim(_curAnimIndex);
              },
            ),
            Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 40),
                  decoration: BoxDecoration(color: Color.fromARGB(150, 128, 128, 128)),
                  child: Column(
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 5,
                        childAspectRatio: 5,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: _buildConfigItemList(),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: _buildOptItemList(),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConfigItemList() {
    List<Widget> items = [
      // codec
      _buildTextSpinnerLabel<String>("Codec:", _codecNotifier, _codecHardCode.keys.toList(), (value) {
        _codecNotifier.value = value;
        if (null != value) {
          _curConfig.codecType = _codecHardCode[value]!;
        }
      }),
      // is Playing
      _buildOptItem("isPlaying", () async {
        bool isPlaying = await _effectViewController?.isPlaying() ?? false;
        Fluttertoast.showToast(msg: "isPlaying:$isPlaying");
      }),
      // rate
      _buildTextSpinnerLabel<double>("Rate:", _rateNotifier, _rateValues, (value) {
        _rateNotifier.value = value;
        if (null != value) {
          _effectViewController?.setRate(value);
        }
      }),
      // animType
      _buildTextSpinnerLabel<String>("AnimType:", _animTypeNotifier, _animTypeHardCode.keys.toList(), (value) {
        _animTypeNotifier.value = value;
        if (value != null) {
          _curConfig.animType = _animTypeHardCode[value];
          _effectViewController?.setConfig(_curConfig);
        }
      }),
      // rotation
      _buildTextSpinnerLabel<int>("Rotation:", _rotationNotifier, _rotationValue, (value) {
        _rotationNotifier.value = value;
        if (value != null) {
          _effectViewController?.setRenderRotation(value.toInt());
        }
      }),
      // mute
      Row(
        children: [
          _buildCfgLabel("isMute"),
          ValueListenableBuilder(
              valueListenable: _muteNotifier,
              builder: (ctx, value, child) {
                return Switch(
                    value: value,
                    onChanged: (tValue) {
                      _muteNotifier.value = tValue;
                      _effectViewController?.setMute(tValue);
                    });
              })
        ],
      ),
      // scaleType
      _buildTextSpinnerLabel("ScaleType:", _scaleTypeNotifier, _scaleTypeHardCode.keys.toList(), (value) {
        _scaleTypeNotifier.value = value;
        if (value != null) {
          _effectViewController?.setScaleType(_scaleTypeHardCode[value]!);
        }
      }),
      // loop
      Row(
        children: [
          _buildCfgLabel("isLoop"),
          ValueListenableBuilder(
              valueListenable: _loopNotifier,
              builder: (ctx, value, child) {
                return Switch(
                    value: value,
                    onChanged: (tValue) {
                      _loopNotifier.value = tValue;
                      _effectViewController?.setLoop(tValue);
                    });
              })
        ],
      ),
    ];
    return items;
  }

  Widget _buildTextSpinnerLabel<T>(
      String labelStr, ValueNotifier<T?> notifier, List<T> valueArray, ValueChanged<T?>? onChanged) {
    return Row(
      children: [
        _buildCfgLabel(labelStr),
        Flexible(
            child: ValueListenableBuilder<T?>(
                valueListenable: notifier,
                builder: (ctx, value, child) {
                  return DropdownButton<T>(
                      isExpanded: true,
                      value: value,
                      alignment: AlignmentDirectional.center,
                      style: TextStyle(color: Colors.white),
                      dropdownColor: Colors.black,
                      items: valueArray.map<DropdownMenuItem<T>>((T value) {
                        return DropdownMenuItem<T>(
                          value: value,
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            value.toString(),
                            softWrap: true,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: onChanged);
                })),
      ],
    );
  }

  Text _buildCfgLabel(String txt) {
    return Text(
      txt,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 13),
    );
  }

  List<Widget> _buildOptItemList() {
    List<Widget> items = [
      _buildOptItem("startPlay", _clickStart),
      _buildOptItem("pause", _clickPause),
      _buildOptItem("resume", _clickResume),
      _buildOptItem("stopPlay", _clickStop),
    ];
    return items;
  }

  Widget _buildOptItem(String text, VoidCallback clickFunction) {
    return GestureDetector(
      onTap: clickFunction,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(color: Color.fromARGB(150, 128, 128, 128)),
        margin: EdgeInsets.only(right: 2),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _clickStart() {
    _handlePlayAnim(_curAnimIndex);
  }

  void _clickPause() {
    _effectViewController?.pause();
  }

  void _clickResume() {
    _effectViewController?.resume();
  }

  void _clickStop() {
    _effectViewController?.stopPlay();
  }

  Future<void> _setUpController(FTCEffectViewController controller) async {
    _effectViewController = controller;
    _effectViewController?.setFetchResource(FResourceFetcher(textFetcher: (res) {
      if (res.tag == "01") {
        return FTCEffectText()
          ..text="FTCEffect${res.tag}"
          ..alignment = FTCEffectText.TEXT_ALIGNMENT_LEFT
          ..color = 0xFF0000FF;
      } else {
        return FTCEffectText()..text = "FTCEffect${res.tag}";
      }
    }, imgFetcher: (res) {
      if (res.tag == "03") {
        return AssetImageCache.samplePng;
      } else {
        return AssetImageCache.samplePng;
      }
    }));
    _effectViewController?.setPlayListener(FAnimPlayListener(onPlayStart: () async {
      FTCEffectAnimInfo? animInfo = await _effectViewController?.getTCAnimInfo();
      print("onPlayStart ${animInfo?.type} | ${animInfo?.duration} | ${animInfo?.width} | ${animInfo?.height} | ${animInfo?.encryptLevel}");
      // List<FMixItem>? imageMixItemList =  animInfo?.mixInfo?.imageMixItemList;
      // if (imageMixItemList != null) {
      //   for (FMixItem mixItem in imageMixItemList) {
      //     print("onPlayStart mixInfo Image :${mixItem.id} - ${mixItem.tag}  - ${mixItem.text}");
      //   }
      // }
      // List<FMixItem>? textMixItemList = animInfo?.mixInfo?.textMixItemList;
      // if (textMixItemList != null) {
      //   for (FMixItem mixItem in textMixItemList) {
      //     print("onPlayStart mixInfo Text  :${mixItem.id} - ${mixItem.tag}  - ${mixItem.text}");
      //   }
      // }
    }, onPlayEnd: () {
      print("onPlayEnd");
    }, onPlayEvent: (int event, Map params) {
      print("onPlayEvent ${event} -- ${params}");
    }, onPlayError: (code) {
      print("onPlayError $code");
    }));
  }

  Future<void> _playNextAnim() async {
    _curAnimIndex = _curAnimIndex + 1;
    _handlePlayAnim(_curAnimIndex);
  }

  Future<void> _handlePlayAnim(int animIndex) async {
    _effectViewController?.setConfig(_curConfig);
    String animPath = animList[animIndex % animList.length];
    FTCEffectViewController controller = _effectViewController!;
    controller.setVideoMode(FVideoMode.VIDEO_MODE_SPLIT_HORIZONTAL);
    controller.setScaleType(FScaleType.FIT_CENTER);
    await controller.startPlay(animPath);
  }
}
