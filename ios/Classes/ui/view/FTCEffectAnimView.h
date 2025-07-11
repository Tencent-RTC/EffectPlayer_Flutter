//
//  FTCEffectAnimView.h
//  flutter_effect_player
//
//  Created by kakaayang on 2025/7/3.
//

#ifndef FTCEffectAnimView_h
#define FTCEffectAnimView_h

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface FTCEffectAnimView : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    messenger:(nonnull id<FlutterBinaryMessenger>)binaryMessenger;

@end

#endif /* FTCEffectAnimView_h */
