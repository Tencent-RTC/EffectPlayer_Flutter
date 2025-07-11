import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class AssetImageCache {
  static Uint8List? _samplePng;

  static Future<void> preload() async {
    final data = await rootBundle.load('asset/image/head.png');
    _samplePng = data.buffer.asUint8List();
  }

  static Uint8List get samplePng {
    if (_samplePng == null) {
      throw StateError('Asset not preloaded. Call AssetCache.preload() first.');
    }
    return _samplePng!;
  }
}
