package com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.ui.view;

import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.tools.PlatformViewRenderTarget;
import com.tencent.tcmediax.utils.Log;

import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class FTCEffectViewFactory extends PlatformViewFactory {
    private static final String TAG = "FTCEffectViewFactory";

    private final BinaryMessenger mBinaryMessenger;
    private final Handler mMainHandler = new Handler(Looper.getMainLooper());

    /**
     * 是否启用兼容模式开关
     * 开启后，只会在 Pixel 设备上动画 View 会使用 SurfaceTexture RenderTarget，避免 fd 泄漏
     */
    private boolean mCompatModeEnabled = true;
    
    /**
     * 缓存是否为 Pixel 设备的判断结果
     */
    private static final boolean IS_PIXEL_DEVICE = isPixelDevice();

    /**
     * 当前正在创建的 View 计数
     */
    private final AtomicInteger mCreatingCount = new AtomicInteger(0);

    public FTCEffectViewFactory(BinaryMessenger binaryMessenger) {
        super(StandardMessageCodec.INSTANCE);
        mBinaryMessenger = binaryMessenger;
        Log.d(TAG, "FTCEffectViewFactory init, isPixelDevice: " + IS_PIXEL_DEVICE + ", manufacturer: " + Build.MANUFACTURER + ", brand: " + Build.BRAND);
    }

    /**
     * 设置是否启用兼容模式
     * 注意：兼容模式仅在 Pixel 设备上生效
     * @param enable true 启用（Pixel 设备上动画 View 使用 SurfaceTexture），false 禁用
     */
    public void enableCompatMode(boolean enable) {
        mCompatModeEnabled = enable;
        Log.d(TAG, "enableCompatMode: " + enable + ", isPixelDevice: " + IS_PIXEL_DEVICE + ", actualEnabled: " + shouldUseCompatMode());
    }

    /**
     * 判断是否应该使用兼容模式
     * 条件：开关打开 且 是 Pixel 设备
     */
    private boolean shouldUseCompatMode() {
        return mCompatModeEnabled && IS_PIXEL_DEVICE;
    }

    /**
     * 判断当前设备是否为 Google Pixel 设备
     */
    private static boolean isPixelDevice() {
        String manufacturer = Build.MANUFACTURER;
        String brand = Build.BRAND;
        // Google Pixel 设备的 manufacturer 和 brand 都是 "Google"
        return "Google".equalsIgnoreCase(manufacturer) || "Google".equalsIgnoreCase(brand);
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        // 判断是否需要使用兼容模式
        boolean useCompatMode = shouldUseCompatMode();
        Log.d(TAG, "create: " + mCompatModeEnabled + ", isPixelDevice: " + IS_PIXEL_DEVICE + ", actualEnabled: " + useCompatMode);

        // ============== 兼容模式开始 ==============
        // 在 create() 开始时切换为 SurfaceTexture 模式
        if (useCompatMode && mCreatingCount.getAndIncrement() == 0) {
            PlatformViewRenderTarget.EnableResult result = PlatformViewRenderTarget.enableSurfaceTexturePlatformViewRenderTarget();
            Log.d(TAG, "create[viewId=" + viewId + "] >>> Switch to SurfaceTexture RenderTarget: " + result);
        }

        // 创建 PlatformView
        FTCEffectAnimView animView = new FTCEffectAnimView(context, viewId, creationParams, mBinaryMessenger, null);

        // 在 create() 返回后恢复原设置
        // 1. PlatformViewsController.createForTextureLayer() 被调用
        // 2. -> createPlatformView() -> Factory.create() 被调用（我们在这里）
        // 3. -> create() 返回后
        // 4. -> configureForTextureLayerComposition() 被调用
        // 5. -> makePlatformViewRenderTarget() 被调用（RenderTarget 在这里创建）
        //
        // 由于 configureForTextureLayerComposition 和 makePlatformViewRenderTarget
        // 都在同一个调用栈中同步执行，我们使用 Handler.post() 将恢复操作
        // 推迟到当前 Message 处理完毕后执行，此时 RenderTarget 已经创建完成
        if (useCompatMode) {
            mMainHandler.post(() -> {
                if (mCreatingCount.decrementAndGet() == 0) {
                    PlatformViewRenderTarget.EnableResult result = PlatformViewRenderTarget.restorePlatformViewRenderTarget();
                    Log.d(TAG, "create[viewId=" + viewId + "] <<< Restore RenderTarget: " + result);
                }
            });
        }
        return animView;
    }
}
