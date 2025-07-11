#import "TceffectplayerFlutterPlugin.h"
#import "TCEffectMessages.h"
#import "FTCEffectViewFactory.h"
#import "FEffectConstants.h"
#import "FEffectViewHelper.h"
#import "TCMediaX/TCMediaXBase.h"
#import "TCMediaX/TCMediaXBaseDelegate.h"

@interface TceffectplayerFlutterPlugin () <FTCMediaXBaseApi, TCMediaXBaseDelegate>

@property (nonatomic, strong) FTCMediaXBaseFlutterEvent* mediaxBaseFlutterEvent;
@property (nonatomic, strong) FTCEffectViewFactory* tceffectViewFactory;

@end

TceffectplayerFlutterPlugin* instance;

@implementation TceffectplayerFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    instance = [[TceffectplayerFlutterPlugin alloc] initWithRegistrar:registrar];
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    if(instance) {
        [instance destory];
    }
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        SetUpFTCMediaXBaseApi([registrar messenger],self);
        self.mediaxBaseFlutterEvent  = [[FTCMediaXBaseFlutterEvent alloc] initWithBinaryMessenger:[registrar messenger]];
        
        self.tceffectViewFactory = [[FTCEffectViewFactory alloc]initWithBinaryMessenger:[registrar messenger]];
        [registrar registerViewFactory:self.tceffectViewFactory withId:VIEW_TYPE_EFFECT_VIEW];
    }
    return self;
}

-(void) destory
{
    
}

#pragma mark - FTCMediaXBaseApi

- (void)setLicenseUrl:(NSString *)url key:(NSString *)key error:(FlutterError *_Nullable *_Nonnull)error {
    [[TCMediaXBase getInstance] setDelegate:self];
    [[TCMediaXBase getInstance] setLicenceURL:url key:key];
}

- (void)setLogEnableEnable:(BOOL)enable error:(FlutterError *_Nullable *_Nonnull)error {
    [[TCMediaXBase getInstance] setLogEnable:enable];
}

#pragma mark - TCMediaXBaseDelegate

- (void)onLicenseCheckCallback:(int)errcode withParam:(NSDictionary *)param{
    [FEffectViewHelper runOnMainThread:^{
        [self.mediaxBaseFlutterEvent onLicenseResultErrCode:errcode msg:param[@"ErrorMessage"] completion:^(FlutterError * _Nullable err) {
        }];
    }];
}

@end
