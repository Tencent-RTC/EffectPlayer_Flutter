//
//  FTCEffectAnimController.m
//  flutter_effect_player
//
//  Created by kakaayang on 2025/7/3.
//

#import "FTCEffectAnimController.h"

@interface FTCEffectAnimController() <TCEPAnimViewDelegate>
@property(nonatomic, strong) TCEffectAnimView* tceAnimView;
@property(nonatomic, strong) FTCEffectAnimViewFlutterEvent* tceAnimViewFlutterEvent;
@property (nonatomic, assign) int64_t viewId;
@end

@implementation FTCEffectAnimController

- (nonnull instancetype)initWithViewId:(int64_t)viewId binaryMessenger:(nonnull id<FlutterBinaryMessenger>)messenger effectView:(nonnull TCEffectAnimView *)effectView {
    self = [super init];
    if(self){
        self.viewId = viewId;
        self.tceAnimViewFlutterEvent = [[FTCEffectAnimViewFlutterEvent alloc] initWithBinaryMessenger:messenger messageChannelSuffix:[@(viewId)stringValue]];
        self.tceAnimView = effectView;
        self.tceAnimView.effectPlayerDelegate = self;
        SetUpFTCEffectAnimViewApiWithSuffix(messenger, self, [@(viewId)stringValue]);
    }
    return self;
}

- (nonnull TCEffectAnimView*) getAnimView{
    return self.tceAnimView;
}

#pragma mark - FTCEffectAnimViewApi

- (nullable FTCEffectAnimInfoMsg *)getTCAnimInfoWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    return [FEffectViewHelper transAnimInfoToMsg:[self.tceAnimView getAnimInfo]];
}

- (nullable NSNumber *)isPlayingWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    return @([self.tceAnimView isPlaying]);
}

- (void)onDestroyWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    
}

- (void)pauseWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView pause];
}

- (void)requestUpdateResourceWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView requestUpdateResource];
}

- (void)resumeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView resume];
}

- (void)seekProgressProgress:(double)progress error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView seekProgress:progress];
}

- (void)seekToMilliSec:(NSInteger)milliSec error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView seek:milliSec/1000.0f];
}

- (void)setConfigConfig:(nonnull FTCEffectConfigMsg *)config error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView setEffectPlayerConfig: [FEffectViewHelper transConfigFromMsg:config]];
}

- (void)setDurationDurationInMilliSec:(NSInteger)durationInMilliSec error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView setDuration:durationInMilliSec];
}

- (void)setLoopCountLoopCount:(NSInteger)loopCount error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView setLoopCount:(int)loopCount];
}

- (void)setLoopIsLoop:(BOOL)isLoop error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView setLoop:isLoop];
}

- (void)setMuteMute:(BOOL)mute error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView setMute:mute];
}

- (void)setRenderRotationRotation:(NSInteger)rotation error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView setRenderRotation:[FEffectViewHelper findHomeOrientationByValue:[NSNumber numberWithInteger:rotation]]];
}

- (void)setScaleTypeScaleTypeValue:(NSInteger)scaleTypeValue error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView setRenderMode:[FEffectViewHelper findContentModeByValue:[NSNumber numberWithInteger:scaleTypeValue]]];
}

- (void)setVideoModeVideoModeValue:(NSInteger)videoModeValue error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView setVideoMode:[FEffectViewHelper findVideoBlendModeByValue:[NSNumber numberWithInteger:videoModeValue]]];
}

- (nullable NSNumber *)startPlayPlayUrl:(nonnull NSString *)playUrl error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView startPlay:playUrl];
    return @0;
}

- (void)stopPlayClearLastFrame:(BOOL)clearLastFrame error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self.tceAnimView stopPlay];
}

- (void)setRateRate:(double)rate error:(FlutterError * _Nullable __autoreleasing *)error {
    [self.tceAnimView setRate:rate];
}

- (nullable NSString *)getSdkVersionWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error { 
    return [TCEffectAnimView getSdkVersion];
}

- (FTCEffectAnimInfoMsg *)preloadTCAnimInfoPlayUrl:(NSString *)playUrl config:(FTCEffectConfigMsg *)config error:(FlutterError * _Nullable __autoreleasing *)error{
    return [FEffectViewHelper transAnimInfoToMsg:[TCEffectAnimView preloadTCAnimInfo:playUrl config:[FEffectViewHelper transConfigFromMsg:config]]];;
}

#pragma mark - TCEPAnimViewDelegate

- (void)onPlayEvent:(ITCEffectPlayer *)player
              event:(int)EvtID
          withParam:(NSDictionary *)param{
    [FEffectViewHelper runOnMainThread:^{
        [self.tceAnimViewFlutterEvent onPlayEventEvent:EvtID param:[FEffectViewHelper getParams:param] completion:^(FlutterError * _Nullable flutterErr) {

        }];
    }];
}

- (TCEffectText *)loadTextForPlayer:(ITCEffectPlayer *)player
                            withTag:(NSString *)tag {
    FResourceMsg* resouceMsg = [FEffectViewHelper transResourceTagToMsg:tag];
    __block TCEffectText *tceffectText = nil;
    float defaultTimeOutInSec = 5;
    if([NSThread isMainThread]){
        __block BOOL isFetchCompleted = NO;
        [self.tceAnimViewFlutterEvent fetchTextRes:resouceMsg completion:^(FTCEffectTextMsg * _Nullable ftceffectTextMsg, FlutterError * _Nullable error) {
            if(!error && ftceffectTextMsg){
                tceffectText = [FEffectViewHelper transEffectTextFromMsg:ftceffectTextMsg];
            }
            isFetchCompleted = YES;
        }];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:defaultTimeOutInSec];
        while (!isFetchCompleted && [runLoop runMode:NSDefaultRunLoopMode beforeDate:timeoutDate]) {
            if ([timeoutDate timeIntervalSinceNow] < 0) {
                NSLog(@"loadTextForPlayer waiting for flutter time out in mainThread!");
                break;
            }
        }
    } else {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [FEffectViewHelper runOnMainThread:^{
            [self.tceAnimViewFlutterEvent fetchTextRes:resouceMsg completion:^(FTCEffectTextMsg * _Nullable ftceffectTextMsg, FlutterError * _Nullable error) {
                if(!error && ftceffectTextMsg){
                    tceffectText = [FEffectViewHelper transEffectTextFromMsg:ftceffectTextMsg];
                }
                dispatch_semaphore_signal(sema);
            }];
        }];
        long res = dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, defaultTimeOutInSec * NSEC_PER_SEC));
        if (res != 0) {
            NSLog(@"loadTextForPlayer waiting for flutter time out in childThread!");
        }
    }
    return tceffectText;
}

- (void)loadImageForPlayer:(ITCEffectPlayer *)player
                   context:(NSDictionary *)context
                completion:(void(^)(UIImage *image,
                                    NSError *error))completionBlock{
    NSString *tag = context[TCEPContextSourceTypeImageIndex];
    FResourceMsg* resouceMsg = [FEffectViewHelper transResourceTagToMsg:tag];
    [FEffectViewHelper runOnMainThread:^{
        [self.tceAnimViewFlutterEvent fetchImageRes:resouceMsg completion:^(FlutterStandardTypedData * _Nullable data, FlutterError * _Nullable error) {
            if(error){
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                if (error.code){
                    userInfo[@"flutterErrorCode"] = error.code;
                }
                if (error.message) {
                    userInfo[@"flutterErrorMsg"] = error.message;
                }
                if (error.details) {
                    userInfo[@"flutterErrorDetail"] = error.details;
                }
                NSError* nsError= [[NSError alloc]initWithDomain:@"FlutterErrorDomain" code:-1 userInfo:userInfo];
                completionBlock(nil, nsError);
            }else{
                NSData* imageData = [data data];
                UIImage* uiImage = [UIImage imageWithData:imageData];
                completionBlock(uiImage,nil);
            }
        }];
    }];
}

- (void)tcePlayerTagTouchBegan:(ITCEffectPlayer *)player tag:(NSString *)tag{

}


- (void)tcePlayerStart:(ITCEffectPlayer *)player{
    [FEffectViewHelper runOnMainThread:^{
        [self.tceAnimViewFlutterEvent onPlayStartWithCompletion:^(FlutterError * _Nullable flutterErr) {

        }];
    }];
}

- (void)tcePlayerEnd:(ITCEffectPlayer *)player{
    [FEffectViewHelper runOnMainThread:^{
        [self.tceAnimViewFlutterEvent onPlayEndWithCompletion:^(FlutterError * _Nullable flutterErr) {
        }];
    }];
}

- (void)tcePlayerError:(ITCEffectPlayer *)player error:(NSError *)error{
    [FEffectViewHelper runOnMainThread:^{
        [self.tceAnimViewFlutterEvent onPlayErrorErrCode:error.code completion:^(FlutterError * _Nullable flutterErr) {

        }];
    }];
}

@end

