package com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter;

import static com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.common.FEffectConstants.VIEW_TYPE_EFFECT_VIEW;

import androidx.annotation.NonNull;

import com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.messages.TCEffectMessages;
import com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.tools.ThreadHelper;
import com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.ui.view.FTCEffectViewFactory;
import com.tencent.tcmediax.api.ILicenseCallback;
import com.tencent.tcmediax.api.TCMediaXBase;
import com.tencent.tcmediax.utils.Log;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class TceffectplayerFlutterPlugin implements FlutterPlugin, TCEffectMessages.FTCMediaXBaseApi,
        TCEffectMessages.VoidResult {

  private static final String TAG = "TceffectplayerFlutterPlugin";

  FlutterPluginBinding mFlutterPlugin;
  TCEffectMessages.FTCMediaXBaseFlutterEvent mMediaXBaseFlutterEvent;
  private FTCEffectViewFactory mEffectViewFactory;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    mFlutterPlugin = flutterPluginBinding;
    initMediaXBaseFlutterMsg(flutterPluginBinding);
    initEffectViewFactory(flutterPluginBinding);
  }

  private void initMediaXBaseFlutterMsg(FlutterPluginBinding flutterPluginBinding) {
    TCEffectMessages.FTCMediaXBaseApi.setUp(flutterPluginBinding.getBinaryMessenger(), this);
    mMediaXBaseFlutterEvent
            = new TCEffectMessages.FTCMediaXBaseFlutterEvent(flutterPluginBinding.getBinaryMessenger());
  }

  private void initEffectViewFactory(FlutterPluginBinding flutterPluginBinding) {
    mEffectViewFactory = new FTCEffectViewFactory(flutterPluginBinding.getBinaryMessenger());
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(VIEW_TYPE_EFFECT_VIEW, mEffectViewFactory);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  @Override
  public void setLicense(@NonNull String url, @NonNull String key) {
    TCMediaXBase.getInstance().setLicense(mFlutterPlugin.getApplicationContext(), url, key, new ILicenseCallback() {
      @Override
      public void onResult(int i, String s) {
        ThreadHelper.runMain(() -> mMediaXBaseFlutterEvent.onLicenseResult((long)i , s, TceffectplayerFlutterPlugin.this));
      }
    });
  }

  @Override
  public void setLogEnable(@NonNull Boolean enable) {
    TCMediaXBase.getInstance().setLogEnable(mFlutterPlugin.getApplicationContext(), enable);
  }

  /**
   * flutter message callback
   */
  @Override
  public void success() {

  }

  @Override
  public void error(@NonNull Throwable error) {
    Log.e(TAG, "callback msg error:" + error);
  }
}
