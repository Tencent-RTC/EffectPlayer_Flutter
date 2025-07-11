package com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.tools;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.text.TextUtils;

import com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.common.FEffectConstants;
import com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.messages.TCEffectMessages;
import com.tencent.tcmediax.tceffectplayer.api.TCEffectConfig;
import com.tencent.tcmediax.tceffectplayer.api.TCEffectPlayerConstant;
import com.tencent.tcmediax.tceffectplayer.api.data.TCEffectAnimInfo;
import com.tencent.tcmediax.tceffectplayer.api.mix.Resource;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class FEffectViewHelper {

    public static TCEffectPlayerConstant.ScaleType findScaleTypeByValue(Long value) {
        return FEffectConstants.SCALE_TYPE_VALUE.get(value);
    }

    public static TCEffectPlayerConstant.VideoMode findVideoModeByValue(Long value) {
        return FEffectConstants.VIDEO_MODE_VALUE.get(value);
    }

    private static TCEffectConfig.CodecType findCodecTypeByValue(Long value) {
        return FEffectConstants.CODEC_TYPE_VALUE.get(value);
    }

    private static TCEffectConfig.AnimType findAnimTypeByValue(Long value) {
        return FEffectConstants.ANIM_TYPE_VALUE.get(value);
    }

    private static int findFreezeFrameByValue(Long value) {
        Integer result = FEffectConstants.FREEZE_FRAME_VALUE.get(value);
        return result == null ? TCEffectConfig.FREEZE_FRAME_NONE : result;
    }

    public static TCEffectConfig transConfigFromMsg(TCEffectMessages.FTCEffectConfigMsg msg) {
        TCEffectConfig.Builder configBuilder = new TCEffectConfig.Builder();

        if (msg.getCodecTypeValue() != null) {
            configBuilder.setCodecType(findCodecTypeByValue(msg.getCodecTypeValue()));
        }
        if (msg.getAnimTypeValue() != null) {
            configBuilder.setAnimType(findAnimTypeByValue(msg.getAnimTypeValue()));
        }
        if (msg.getFreezeFrame() != null) {
            configBuilder.setFreezeFrame(findFreezeFrameByValue(msg.getFreezeFrame()));
        }
        if (msg.getExtendMapParams() != null) {
            Map<String ,Object> extParams = new HashMap<>();
            Map<Object, Object> extObjMap = msg.getExtendMapParams();
            for (Object key : extObjMap.keySet()) {
                extParams.put(key.toString(), extObjMap.get(key));
            }
            configBuilder.setExtendMapParams(extParams);
        }

        return configBuilder.build();
    }

    public static TCEffectMessages.FTCEffectAnimInfoMsg transAnimInfoToMsg(TCEffectAnimInfo animInfo) {
        if (animInfo == null) {
            return null;
        }
        TCEffectMessages.FTCEffectAnimInfoMsg msg = new TCEffectMessages.FTCEffectAnimInfoMsg();
        msg.setType((long) animInfo.type);
        msg.setDuration(animInfo.duration);
        msg.setWidth((long) animInfo.width);
        msg.setHeight((long) animInfo.height);
        msg.setEncryptLevel((long) animInfo.encryptLevel);
        msg.setMixInfo(transMixInfoToMsg(animInfo.mixInfo));
        return msg;
    }

    private static TCEffectMessages.FMixInfoMsg transMixInfoToMsg(TCEffectAnimInfo.MixInfo mixInfo) {
        if (mixInfo == null) {
            return null;
        }
        TCEffectMessages.FMixInfoMsg mixInfoMsg = new TCEffectMessages.FMixInfoMsg();

        List<TCEffectMessages.FMixItemMsg> textMixItemMsgList = null;
        if (mixInfo.textMixItemList != null) {
            textMixItemMsgList = new ArrayList<>();
            for (TCEffectAnimInfo.MixInfo.MixItem mixItem : mixInfo.textMixItemList) {
                textMixItemMsgList.add(transMixItemToMsg(mixItem));
            }
        }

        List<TCEffectMessages.FMixItemMsg> imageMixItemMsgList = null;
        if (mixInfo.imageMixItemList != null) {
            imageMixItemMsgList = new ArrayList<>();
            for (TCEffectAnimInfo.MixInfo.MixItem mixItem : mixInfo.imageMixItemList) {
                imageMixItemMsgList.add(transMixItemToMsg(mixItem));
            }
        }
        mixInfoMsg.setTextMixItemList(textMixItemMsgList);
        mixInfoMsg.setImageMixItemList(imageMixItemMsgList);
        return mixInfoMsg;
    }

     private static TCEffectMessages.FMixItemMsg transMixItemToMsg(TCEffectAnimInfo.MixInfo.MixItem mixItem){
         TCEffectMessages.FMixItemMsg mixItemMsg = new TCEffectMessages.FMixItemMsg();
         mixItemMsg.setId(mixItem.id);
         mixItemMsg.setTag(mixItem.tag);
         mixItemMsg.setText(mixItem.text);
         return mixItemMsg;
    }

    public static TCEffectMessages.FResourceMsg transResourceToMsg(Resource resource){
        TCEffectMessages.FResourceMsg resourceMsg = new TCEffectMessages.FResourceMsg();
        resourceMsg.setId(resource.id);
        resourceMsg.setSrcType(resource.srcType);
        resourceMsg.setLoadType(resource.loadType);
        resourceMsg.setLoadType(resource.loadType);
        resourceMsg.setTag(resource.tag);
        // 其他的暂时不传
        return resourceMsg;
    }

    public static Bitmap transByteArrToBitmap(byte[] bytes) {
        if (bytes == null || bytes.length == 0) {
            return null;
        }
        try {
            return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
        } catch (Throwable throwable) {
            throwable.printStackTrace();
        }
        return null;
    }

    public static String checkIfFlutterPath(String mayFlutterAssetPath, FlutterPlugin.FlutterAssets flutterAssets) {
        if (TextUtils.isEmpty(mayFlutterAssetPath)) {
            return mayFlutterAssetPath;
        }

        String result = mayFlutterAssetPath;
        if (result.startsWith(FEffectConstants.FLUTTER_ASSET_PROTOCOL_PREFIX)) {
            result = normalizeAssetUri(mayFlutterAssetPath, flutterAssets);
        }
        return result;
    }

    private static String normalizeAssetUri(String uri, FlutterPlugin.FlutterAssets flutterAssets) {
        String orgPath = uri.replaceFirst("^"+FEffectConstants.FLUTTER_ASSET_PROTOCOL_PREFIX+":/*", "");
        return "file://" + flutterAssets.getAssetFilePathByName(orgPath);
    }

    public static Map<Object, Object> getParams(Bundle bundle) {
        Map<Object, Object> param = new HashMap<>();
        if (bundle != null && !bundle.isEmpty()) {
            Set<String> keySet = bundle.keySet();
            for (String key : keySet) {
                Object val = bundle.get(key);
                if (val instanceof TCEffectAnimInfo) {
                    continue;
                }
                if (null != val) {
                    param.put(key, val);
                }
            }
        }
        return param;
    }
}
