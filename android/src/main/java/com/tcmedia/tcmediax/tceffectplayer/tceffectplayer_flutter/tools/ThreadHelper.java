package com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.tools;

import android.os.Handler;
import android.os.Looper;

public class ThreadHelper {

    private static final Handler MAIN_HANDLER = new Handler(Looper.getMainLooper());

    public static void runMain(Runnable runnable) {
        if (runnable == null) {
            return;
        }
        if (Looper.myLooper() == Looper.getMainLooper()) {
            runnable.run();
        } else {
            MAIN_HANDLER.post(runnable);
        }
    }
}
