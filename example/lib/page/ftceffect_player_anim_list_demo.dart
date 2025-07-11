import 'package:flutter/material.dart';
import 'package:flutter_effect_player/ftceffect_player.dart';
import 'package:tceffectplayer_flutter_example/tools/demo_asset_helper.dart';

class FTCEffectPlayerAnimListDemo extends StatefulWidget {

  const FTCEffectPlayerAnimListDemo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FTCEffectPlayerAnimListDemoState();
  }
}

class _FTCEffectPlayerAnimListDemoState
    extends State<FTCEffectPlayerAnimListDemo> {

  final List<String> _animFileList = DemoAssetHelper.instance.getTCMP4AnimPathList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TCMP4 List Demo"),),
      body: GridView.builder(
          itemCount: _animFileList.length * 2,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,),
          itemBuilder: (context,index) {
           return FTCEffectAnimView(
                controllerCallback: (controller){
                  controller.setLoop(true);
                  controller.startPlay(_animFileList[index%_animFileList.length]);
                },
            );
          }
      ),
    );
  }

}