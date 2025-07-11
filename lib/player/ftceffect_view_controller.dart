// Copyright (c) 2025 Tencent. All rights reserved.
part of '../ftceffect_player.dart';

class FTCEffectViewController implements FTCEffectAnimViewFlutterEvent {

  final int viewId;
  final FTCEffectAnimViewApi _effectViewApi;
  FResourceFetcher? _resFetcher;
  FResClickListener? _resClickListener;
  FAnimPlayListener? _animPlayListener;

  FTCEffectViewController(this.viewId)
      : _effectViewApi = FTCEffectAnimViewApi(messageChannelSuffix: viewId.toString()) {
    FTCEffectAnimViewFlutterEvent.setUp(this, messageChannelSuffix: viewId.toString());
  }

  /// api start ///

  Future<int> startPlay(String playUrl) async {
    return await _effectViewApi.startPlay(playUrl);
  }

  Future<void> setVideoMode(FVideoMode videoMode) async {
    await _effectViewApi.setVideoMode(videoMode.index);
  }

  Future<void> setConfig(FTCEffectConfig config) async {
    await _effectViewApi.setConfig(config.toMsg());
  }

  Future<void> setScaleType(FScaleType type) async {
    await _effectViewApi.setScaleType(type.index);
  }

  void setFetchResource(FResourceFetcher resFetcher) {
    _resFetcher = resFetcher;
  }

  void setOnResourceClickListener(FResClickListener resClickListener) {
    _resClickListener = resClickListener;
  }

  Future<void> requestUpdateResource() async {
    await _effectViewApi.requestUpdateResource();
  }

  Future<void> setRenderRotation(int rotation) async {
    await _effectViewApi.setRenderRotation(rotation);
  }

  Future<bool> isPlaying() async {
    return await _effectViewApi.isPlaying();
  }

  Future<void> resume() async {
    await _effectViewApi.resume();
  }

  Future<void> pause() async {
    await _effectViewApi.pause();
  }

  Future<void> seekTo(int millSec) async {
    await _effectViewApi.seekTo(millSec);
  }

  Future<void> seekProgress(double progress) async {
    await _effectViewApi.seekProgress(progress);
  }

  Future<void> setLoop(bool isLoop) async {
    await _effectViewApi.setLoop(isLoop);
  }

  Future<void> setLoopCount(int loopCount) async {
    await _effectViewApi.setLoopCount(loopCount);
  }

  Future<void> setRate(double rate) async {
    await _effectViewApi.setRate(rate);
  }

  Future<void> setDuration(int durationInMilliSec) async {
    await _effectViewApi.setDuration(durationInMilliSec);
  }

  Future<void> stopPlay({bool? clearLastFrame}) async {
    await _effectViewApi.stopPlay(clearLastFrame ?? false);
  }

  Future<void> setMute(bool mute) async {
    await _effectViewApi.setMute(mute);
  }

  void setPlayListener(FAnimPlayListener? listener) {
    _animPlayListener = listener;
  }

  Future<FTCEffectAnimInfo> getTCAnimInfo() async {
    FTCEffectAnimInfoMsg msg = await _effectViewApi.getTCAnimInfo();
    return FTCEffectAnimInfo.copyFromMsg(msg);
  }

  // Future<void> onDestroy() async {
  //   await _effectViewApi.onDestroy();
  // }

  /// api end ///

  /// event start ///
  @override
  Uint8List? fetchImage(FResourceMsg res) {
    return _resFetcher?.imgFetcher?.call(
        FEffectResource.copyFromMsg(res)
    );
  }

  @override
  FTCEffectTextMsg? fetchText(FResourceMsg res) {
    return _resFetcher?.textFetcher
        ?.call(FEffectResource.copyFromMsg(res))
        .toMsg();
  }

  @override
  void releaseResource(List<FResourceMsg> resourceList) {
    _resFetcher?.releaseListener?.call(
        resourceList.map((msg) => FEffectResource.copyFromMsg(msg)).toList()
    );
  }

  @override
  void onResClick(FResourceMsg res) {
    _resClickListener?.call(FEffectResource.copyFromMsg(res));
  }

  @override
  void onPlayEnd() {
    _animPlayListener?.onPlayEnd?.call();
  }

  @override
  void onPlayError(int errCode) {
    _animPlayListener?.onPlayError?.call(errCode);
  }

  @override
  void onPlayEvent(int event, Map<Object?, Object?> param) {
    _animPlayListener?.onPlayEvent?.call(event, param);
  }

  @override
  void onPlayStart() {
    _animPlayListener?.onPlayStart?.call();
  }
  /// event end ///
}
