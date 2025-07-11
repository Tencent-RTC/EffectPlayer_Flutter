package com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.ui.view;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.lang.ref.WeakReference;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class FTCEffectViewFactory extends PlatformViewFactory {

    private final Map<Integer, WeakReference<FTCEffectAnimView>> mRenderViewCache = new HashMap<>();
    private final BinaryMessenger mBinaryMessenger;

    public FTCEffectViewFactory(BinaryMessenger binaryMessenger) {
        super(StandardMessageCodec.INSTANCE);
        mBinaryMessenger = binaryMessenger;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        FTCEffectAnimView effectAnimView = new FTCEffectAnimView(context, viewId, creationParams, mBinaryMessenger);
        mRenderViewCache.put(viewId, new WeakReference<>(effectAnimView));
        return effectAnimView;
    }

    public void removeByViewId(int viewId) {
        mRenderViewCache.remove(viewId);
    }

    public FTCEffectAnimView findViewById(int viewId) {
        WeakReference<FTCEffectAnimView> renderViewWeakReference = mRenderViewCache.get(viewId);
        if (null == renderViewWeakReference) {
            return null;
        }
        return renderViewWeakReference.get();
    }
}
