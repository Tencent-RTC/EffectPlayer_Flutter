//
//  FTCEffectAnimController.h
//  flutter_effect_player
//
//  Created by kakaayang on 2025/7/3.
//

#ifndef FTCEffectAnimController_h
#define FTCEffectAnimController_h


#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "TCEffectMessages.h"
#import "TCEffectPlayer/TCEffectAnimView.h"
#import "TCEffectPlayer/TCEffectAnimInfo.h"
#import "TCEffectPlayer/TCEffectText.h"
#import "FEffectViewHelper.h"

@interface FTCEffectAnimController : NSObject<FTCEffectAnimViewApi>

- (instancetype)initWithViewId:(int64_t)viewId
               binaryMessenger:(id<FlutterBinaryMessenger>) messenger
                    effectView:(TCEffectAnimView *)effectView;


- (nonnull TCEffectAnimView*) getAnimView;

@end


#endif /* FTCEffectAnimController_h */
