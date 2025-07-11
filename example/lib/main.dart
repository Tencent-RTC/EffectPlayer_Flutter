import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_effect_player/ftceffect_player.dart';
import 'package:tceffectplayer_flutter_example/common/demo_config.dart';
import 'package:tceffectplayer_flutter_example/page/ftceffect_player_anim_demo.dart';
import 'package:tceffectplayer_flutter_example/page/ftceffect_player_anim_list_demo.dart';
import 'package:tceffectplayer_flutter_example/tools/asset_image_cache.dart';
import 'package:tceffectplayer_flutter_example/tools/demo_asset_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
    copyResIfAndroid();
    preloadImageAssets();
  }

  Future<void> copyResIfAndroid() async {
    DemoAssetHelper.instance.copyAsset();
  }

  Future<void> preloadImageAssets() async {
    AssetImageCache.preload();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    FTCMediaXBase.instance.setLicense(LICENSE_URL, LICENSE_KEY, (code, msg) {
      print("TCMediax setLicense code:$code | msg:$msg");
    });
    FTCMediaXBase.instance.setLogEnable(true);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("TCEffectPlayerDemo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          ),
          body: Center(
            child: Builder(builder: (ctx) {
              return Center(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(ctx, MaterialPageRoute(
                          builder: (ctx) => FTCEffectPlayerAnimDemo(),
                        ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Text("EffectAnim Demo",
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue),),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(ctx, MaterialPageRoute(
                          builder: (ctx) => FTCEffectPlayerAnimListDemo(),
                        ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Text("EffectAnim List",
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue),),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ));
  }
}
