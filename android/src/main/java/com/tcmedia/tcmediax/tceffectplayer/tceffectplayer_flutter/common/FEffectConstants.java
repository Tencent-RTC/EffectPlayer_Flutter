package com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.common;

import com.tencent.tcmediax.tceffectplayer.api.TCEffectConfig;
import com.tencent.tcmediax.tceffectplayer.api.TCEffectPlayerConstant;

import java.util.HashMap;
import java.util.Map;

public class FEffectConstants {

    public static final String VIEW_TYPE_EFFECT_VIEW = "FlutterEffectAnimView";

    public static final String FLUTTER_ASSET_PROTOCOL_PREFIX = "flutterAsset";


    /**
     * hard code value map
     */

    /*
    video mode
     */
    public static final Map<Long, TCEffectPlayerConstant.VideoMode> VIDEO_MODE_VALUE = new HashMap<>(){{
        put(0L, TCEffectPlayerConstant.VideoMode.VIDEO_MODE_NONE);
        put(1L, TCEffectPlayerConstant.VideoMode.VIDEO_MODE_SPLIT_HORIZONTAL); // alpha left
        put(2L, TCEffectPlayerConstant.VideoMode.VIDEO_MODE_SPLIT_VERTICAL);  //alpha top
        put(3L, TCEffectPlayerConstant.VideoMode.VIDEO_MODE_SPLIT_HORIZONTAL_REVERSE); // alpha right
        put(4L, TCEffectPlayerConstant.VideoMode.VIDEO_MODE_SPLIT_VERTICAL_REVERSE);  // alpha bottom
    }};

    /*
    scale type
     */
    public static final Map<Long, TCEffectPlayerConstant.ScaleType> SCALE_TYPE_VALUE = new HashMap<>(){{
        put(0L, TCEffectPlayerConstant.ScaleType.FIT_XY);
        put(1L, TCEffectPlayerConstant.ScaleType.FIT_CENTER);
        put(2L, TCEffectPlayerConstant.ScaleType.CENTER_CROP);
    }};

    /*
    codec type
     */
    public static final Map<Long, TCEffectConfig.CodecType> CODEC_TYPE_VALUE = new HashMap<>(){{
        put(0L, TCEffectConfig.CodecType.TC_MPLAYER);
        put(1L, TCEffectConfig.CodecType.TC_MCODEC);
        put(2L, TCEffectConfig.CodecType.TX_LITEAV_SDK);
    }};

    /*
    anim type
     */
    public static final Map<Long, TCEffectConfig.AnimType> ANIM_TYPE_VALUE = new HashMap<>(){{
        put(0L, TCEffectConfig.AnimType.AUTO);
        put(1L, TCEffectConfig.AnimType.MP4);
        put(2L, TCEffectConfig.AnimType.TCMP4);
    }};

 public static final Map<Long, Integer> FREEZE_FRAME_VALUE = new HashMap<>(){{
        put(0L, TCEffectConfig.FREEZE_FRAME_NONE);
        put(1L, TCEffectConfig.FREEZE_FRAME_LAST);
    }};

}
