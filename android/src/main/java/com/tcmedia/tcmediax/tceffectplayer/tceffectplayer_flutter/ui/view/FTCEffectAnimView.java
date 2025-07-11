package com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.ui.view;

import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.tencent.tcmediax.tceffectplayer.api.TCEffectAnimView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class FTCEffectAnimView implements PlatformView {

    private final FTCEffectAnimController mController;

    public FTCEffectAnimView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams,
                             BinaryMessenger messenger) {
        TCEffectAnimView effectView = new TCEffectAnimView(context);
        mController = new FTCEffectAnimController(id, messenger, effectView);
    }

    @Nullable
    @Override
    public View getView() {
        return mController.getEffectView();
    }

    @Override
    public void dispose() {
        mController.onDestroy();
    }

    @Override
    public void onFlutterViewAttached(@NonNull View flutterView) {
    }

    @Override
    public void onFlutterViewDetached() {
    }


    @Override
    public void onInputConnectionLocked() {
    }

    @Override
    public void onInputConnectionUnlocked() {
    }
}
