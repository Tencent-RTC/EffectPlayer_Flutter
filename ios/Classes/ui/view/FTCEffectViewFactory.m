//
//  FTCEffectViewFactory.m
//  flutter_effect_player
//
//  Created by kakaayang on 2025/7/3.
//

#import "FTCEffectViewFactory.h"

@interface FTCEffectViewFactory()

@property(nonatomic, strong) id<FlutterBinaryMessenger> binaryMessenger;
@property(nonatomic, strong) NSMapTable<NSNumber*, FTCEffectAnimView*>* viewToPlatformViewMap;

@end

@implementation FTCEffectViewFactory

- (nonnull instancetype)initWithBinaryMessenger:(nonnull id<FlutterBinaryMessenger>)binaryMessenger {
    self = [super init];
    if (self) {
        self.viewToPlatformViewMap = [NSMapTable weakToWeakObjectsMapTable];
        self.binaryMessenger = binaryMessenger;
    }
    return self;
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    FTCEffectAnimView *renderView = [[FTCEffectAnimView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args messenger:self.binaryMessenger];
    [self.viewToPlatformViewMap setObject:renderView forKey:@(viewId)];
    return renderView;
}

- (nonnull FTCEffectAnimView *)findViewById:(NSUInteger)viewId {
    return [self.viewToPlatformViewMap objectForKey:@(viewId)];
}

@end

