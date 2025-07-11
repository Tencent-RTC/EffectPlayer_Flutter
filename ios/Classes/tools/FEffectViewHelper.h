//
//  FEffectViewHelper.h
//  flutter_effect_player
//
//  Created by kakaayang on 2025/7/3.
//

#ifndef FEffectViewHelper_h
#define FEffectViewHelper_h

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "TCEffectMessages.h"
#import "TCEffectPlayer/TCEffectAnimInfo.h"
#import "TCEffectPlayer/TCEffectConfig.h"
#import "TCEffectPlayer/TCEffectText.h"

@interface FEffectViewHelper : NSObject

+ (TCEPCodecType)findCodecTypeByValue:(NSNumber *)value;

+ (NSInteger)findFreezeFrameByValue:(NSNumber *)value;

+ (TCEP_Enum_Type_HomeOrientation)findHomeOrientationByValue:(NSNumber *)value;

+ (TCEPVPViewContentMode)findContentModeByValue:(NSNumber *)value;

+ (TCEPVAPVideoFrameTextureBlendMode)findVideoBlendModeByValue:(NSNumber *)value;

+ (TCEffectConfig *)transConfigFromMsg:(FTCEffectConfigMsg *)msg;

+ (TCEffectText *)transEffectTextFromMsg:(FTCEffectTextMsg *)msg;

+ (nullable FTCEffectAnimInfoMsg*)transAnimInfoToMsg:(nullable TCEffectAnimInfo *)animInfo;

+ (nullable FResourceMsg*)transResourceTagToMsg:(nullable NSString *)tag;

+ (void)runOnMainThread:(dispatch_block_t _Nullable )block;

+ (NSDictionary *_Nonnull)getParams:(nullable NSDictionary *)source;

@end

#endif /* FEffectViewHelper_h */
