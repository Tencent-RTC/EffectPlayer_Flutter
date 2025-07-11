//
//  FEffectViewHelper.m
//  flutter_effect_player
//
//  Created by kakaayang on 2025/7/3.
//

#import "FEffectViewHelper.h"
#import "FEffectConstants.h"
#import "TCEffectPlayer/TCEPAnimConfig.h"

@interface FEffectViewHelper()

@end

@implementation FEffectViewHelper

+ (TCEP_Enum_Type_HomeOrientation)findHomeOrientationByValue:(NSNumber *)value {
    switch (value.integerValue) {
        case 90:
            return TCEP_HOME_ORIENTATION_RIGHT;
        case 180:
            return TCEP_HOME_ORIENTATION_UP;
        case 270:
            return TCEP_HOME_ORIENTATION_LEFT;
        default:
            return TCEP_HOME_ORIENTATION_DOWN;
    }
}

+ (TCEPCodecType)findCodecTypeByValue:(NSNumber *)value {
    switch (value.integerValue) {
        case 2:
            return TCEPCodecTypeVODPlayer;
        default:
            return TCEPCodecTypeAVPlayer;
    }
}

+ (NSInteger)findFreezeFrameByValue:(NSNumber *)value {
    switch (value.integerValue) {
        case 1:
            return FRAME_LAST;
        default:
            return FRAME_NONE;
    }
}

+ (TCEPVPViewContentMode)findContentModeByValue:(NSNumber *)value {
    switch (value.integerValue) {
        case 0:
            return TCEPVPViewContentModeScaleToFill;
        case 2:
            return TCEPVPViewContentModeAspectFill;
        default:
            return TCEPVPViewContentModeAspectFit;
    }
}

+ (TCEPVAPVideoFrameTextureBlendMode)findVideoBlendModeByValue:(NSNumber *)value {
    switch (value.integerValue) {
        case 0:
            return TCEPVAPVFTextureBlendMode_None;
        case 2:
            return TCEPVAPVFTextureBlendMode_AlphaTop;
        case 3:
            return TCEPVAPVFTextureBlendMode_AlphaRight;
        case 4:
            return TCEPVAPVFTextureBlendMode_AlphaBottom;
        default:
            return TCEPVAPVFTextureBlendMode_AlphaLeft;;
    }
}

+ (TCEffectConfig *)transConfigFromMsg:(FTCEffectConfigMsg *)msg {
    TCEffectConfig *config = [[TCEffectConfig alloc] init];
    if(msg.codecTypeValue){
        config.vapEngineType = [FEffectViewHelper findCodecTypeByValue:msg.codecTypeValue];
    }
    if(msg.freezeFrame){
        config.freezeFrame = [FEffectViewHelper findFreezeFrameByValue:msg.freezeFrame];
    }
    if(msg.extendMapParams){
        config.extendMapParams = msg.extendMapParams;
    }
    return config;
}

+ (TCEffectText *)transEffectTextFromMsg:(FTCEffectTextMsg *)msg {
    TCEffectText* tceText = [[TCEffectText alloc] init];
    if(msg.text){
       tceText.text = msg.text;
    }
    if(msg.fontStyle){
       tceText.fontStyle = msg.fontStyle;
    }
    if(msg.color){
        uint32_t argb = msg.color.unsignedIntValue;
        CGFloat alpha = ((argb >> 24) & 0xFF) / 255.0;
        CGFloat red   = ((argb >> 16) & 0xFF) / 255.0;
        CGFloat green = ((argb >>  8) & 0xFF) / 255.0;
        CGFloat blue  =  (argb        & 0xFF) / 255.0;
        tceText.color = [UIColor colorWithRed:red
                                        green:green
                                         blue:blue
                                        alpha:alpha];
    }
    if(msg.fontSize){
       tceText.fontSize = msg.fontSize.floatValue;
    }
    if(msg.alignment){
       tceText.alignment = msg.alignment.intValue;
    }
    return tceText;
}

+ (nullable FTCEffectAnimInfoMsg *)transAnimInfoToMsg:(TCEffectAnimInfo *)animInfo {
    if (!animInfo){
        return nil;
    }
    FTCEffectAnimInfoMsg *msg = [[FTCEffectAnimInfoMsg alloc] init];
    msg.type         = @(animInfo.resType);
    msg.duration     = [NSNumber numberWithLong:animInfo.duration];
    msg.width        = @(animInfo.width);
    msg.height       = @(animInfo.height);
    msg.encryptLevel = @(animInfo.encryptLevel);
    msg.mixInfo      = [self transMixInfoToMsg:animInfo.mixInfo];
    return msg;
}

+ (nullable FMixInfoMsg *)transMixInfoToMsg:(TCEffectMixInfo *)mixInfo {
    if (!mixInfo){
        return nil;
    }
    FMixInfoMsg *mixMsg = [[FMixInfoMsg alloc] init];
    
    if (mixInfo.textMixItemList) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:mixInfo.textMixItemList.count];
        for (TCEffectMixItem *item in mixInfo.textMixItemList) {
            [arr addObject:[self transMixItemToMsg:item]];
        }
        mixMsg.textMixItemList = arr;
    }
    
    if (mixInfo.imageMixItemList) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:mixInfo.imageMixItemList.count];
        for (TCEffectMixItem *item in mixInfo.imageMixItemList) {
            [arr addObject:[self transMixItemToMsg:item]];
        }
        mixMsg.imageMixItemList = arr;
    }
    return mixMsg;
}


+ (nullable FMixItemMsg *)transMixItemToMsg:(TCEffectMixItem *)item {
    if (!item){
        return nil;
    }
    FMixItemMsg *msg = [[FMixItemMsg alloc] init];
    msg.id = item.itemId;
    msg.tag = item.tag;
    msg.text = item.text;
    return msg;
}

+ (nullable FResourceMsg *)transResourceTagToMsg:(nullable NSString *)tag {
    if(!tag){
        return nil;
    }
    FResourceMsg* msg = [[FResourceMsg alloc] init];
    msg.tag = tag;

    return msg;
}

+ (void)runOnMainThread:(dispatch_block_t  _Nullable __strong)block {
    if (!block) {
        return;
    }
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

+ (NSDictionary *_Nonnull)getParams:(nullable NSDictionary *)source {
    if (source == nil || source.count == 0) {
        return @{};
    }
    NSMutableDictionary *dest = [NSMutableDictionary dictionaryWithCapacity:source.count];
    [source enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TCEPAnimConfig class]]) {
            return;
        }
        id valueCopy = ([obj respondsToSelector:@selector(copyWithZone:)]) ? [obj copy] : obj;
        dest[key] = valueCopy;
    }];
    
    return [dest copy];
}


@end
