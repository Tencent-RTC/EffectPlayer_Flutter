//
//  FTCEffectViewFactory.h
//  flutter_effect_player
//
//  Created by kakaayang on 2025/7/3.
//

#ifndef FTCEffectViewFactory_h
#define FTCEffectViewFactory_h

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "FTCEffectAnimView.h"


@interface FTCEffectViewFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>) binaryMessenger;

- (FTCEffectAnimView*)findViewById:(NSUInteger)viewId;

@end

#endif /* FTCEffectViewFactory_h */
