import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

const _kNativeResDicName = "my_resources";
const _kNormalAnimNames = [
  "anim/anim.mp4",
  "anim/anim_mix.mp4",
];

const _kTCMP4AnimNames = [
  "anim/avatar1.tcmp4",
  "anim/avatar2.tcmp4",
];

class DemoAssetHelper {
  static DemoAssetHelper? _instance;

  static DemoAssetHelper get instance => _getInstance();

  /// FTCMediaXBase instance
  static DemoAssetHelper _getInstance() {
    _instance ??= DemoAssetHelper._internal();
    return _instance!;
  }

  late String appDir;
  Completer<bool> dicCompleter = Completer();

  DemoAssetHelper._internal() {
    _initAndroidResDic();
  }

  _initAndroidResDic() async {
      final Directory appDir = await getApplicationDocumentsDirectory();
      this.appDir = '${appDir.path}/$_kNativeResDicName';
    dicCompleter.complete(true);
  }

  Future<String> copyAsset() async {
    await dicCompleter.future;
    final String targetPath = appDir;
    final Directory targetDir = Directory(targetPath);

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }
    // copy file
    for (final assetPath in _kNormalAnimNames) {
      final data = await rootBundle.load("asset/$assetPath");
      final file = File('$targetPath/${assetPath.split('/').last}');
      await file.writeAsBytes(data.buffer.asUint8List());
    }

    for (final assetPath in _kTCMP4AnimNames) {
      final data = await rootBundle.load("asset/$assetPath");
      final file = File('$targetPath/${assetPath.split('/').last}');
      await file.writeAsBytes(data.buffer.asUint8List());
    }
    return targetPath;
  }

  List<String> getAnimPathList() {
    List<String> resulList = [];
    if (Platform.isAndroid || Platform.isIOS) {
      for (String item in _kNormalAnimNames) {
        resulList.add("$appDir/${item.split('/').last}");
      }
    }
    return resulList;
  }

  List<String> getTCMP4AnimPathList() {
    List<String> resulList = [];
    if (Platform.isAndroid || Platform.isIOS) {
      for (String item in _kTCMP4AnimNames) {
        resulList.add("$appDir/${item.split('/').last}");
      }
    }
    return resulList;
  }
}
