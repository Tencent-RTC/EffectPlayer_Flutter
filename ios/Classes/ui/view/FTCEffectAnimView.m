//
//  FTCEffectAnimView.m
//  flutter_effect_player
//
//  Created by kakaayang on 2025/7/3.
//

#import "FTCEffectAnimView.h"
#import "FTCEffectAnimController.h"

@interface FTCEffectAnimView()

@property (nonatomic, assign) int64_t mViewId;
@property (nonatomic, strong) FTCEffectAnimController* controller;

@end

@implementation FTCEffectAnimView

- (nonnull instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args messenger:(nonnull id<FlutterBinaryMessenger>)binaryMessenger {
    self = [super init];
    if (self) {
        self.mViewId = viewId;
        TCEffectAnimView* animView = [[TCEffectAnimView alloc] initWithFrame:frame];
        self.controller = [[FTCEffectAnimController alloc] initWithViewId:viewId binaryMessenger:binaryMessenger effectView:animView];
    }
    return self;
}

- (void)dealloc
{
    [self.controller releaseRefObject];
    self.controller = nil;
}

- (nonnull UIView *)view { 
    return  [self.controller getAnimView];
}

@end
