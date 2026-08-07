#import "RCTLiftosaurShare.h"
#import <React/RCTBridgeModule.h>
#import <React_RCTAppDelegate/RCTDefaultReactNativeFactoryDelegate.h>
#import "Liftosaur-Swift.h"

@implementation RCTLiftosaurShare

RCT_EXPORT_MODULE(LiftosaurShare)

+ (BOOL)requiresMainQueueSetup {
  return NO;
}

- (void)shareLog:(RCTPromiseResolveBlock)resolve
           reject:(RCTPromiseRejectBlock)reject {
  [[LiftosaurShareImpl shared] shareLogWithCompletion:^(NSString * _Nullable error) {
    if (error) {
      reject(@"share_log_failed", error, nil);
    } else {
      resolve(nil);
    }
  }];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeLiftosaurShareSpecJSI>(params);
}

@end
