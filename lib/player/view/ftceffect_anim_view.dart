// Copyright (c) 2025 Tencent. All rights reserved.
part of '../../ftceffect_player.dart';

class FTCEffectAnimView extends StatefulWidget {

  FEffectViewControllerCallback? controllerCallback;

  FTCEffectAnimView({this.controllerCallback, Key? viewKey}):super(key: viewKey);

  @override
  State<StatefulWidget> createState() => FTCEffectAnimViewState();

}

class FTCEffectAnimViewState extends State<FTCEffectAnimView> {

  int _viewId = -1;
  Completer<int> _viewIdCompleter = Completer();
  // for force rebuild
  Key _platformViewKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return IgnorePointer(
          ignoring: true,
          child: AndroidView(
            key: _platformViewKey,
            onPlatformViewCreated: _onCreateAndroidView,
            viewType: _kFTCEffectAnimViewType,
            layoutDirection: TextDirection.ltr,
            creationParams: {},
            creationParamsCodec: const StandardMessageCodec(),

          )
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return IgnorePointer(
        ignoring: true,
        child: UiKitView(
            key: _platformViewKey,
            viewType: _kFTCEffectAnimViewType,
            layoutDirection: TextDirection.ltr,
            creationParams: const {},
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onCreateIOSView
        ),
      );
    } else {
      throw ArgumentError("platform not support: $defaultTargetPlatform");
    }
  }

  void _onCreateAndroidView(int id) {
    if (_viewIdCompleter.isCompleted) {
      _viewIdCompleter = Completer();
    }
    _viewId = id;
    _viewIdCompleter.complete(id);
    widget.controllerCallback?.call(FTCEffectViewController(id));
  }

  void _onCreateIOSView(int id) {
    if (_viewIdCompleter.isCompleted) {
      _viewIdCompleter = Completer();
    }
    _viewId = id;
    _viewIdCompleter.complete(id);
    widget.controllerCallback?.call(FTCEffectViewController(id));
  }

  Future<int> getViewId() async {
    await _viewIdCompleter.future;
    return _viewId;
  }

}