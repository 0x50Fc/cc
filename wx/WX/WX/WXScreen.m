//
//  WXScreen.m
//  WX
//
//  Created by zuowu on 2018/11/26.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXScreen.h"

#define WXOnUserCaptureScreenKey "WXOnUserCaptureScreenKey"

@implementation WXGetScreenBrightnessRes
@synthesize value = _value;
@synthesize errMsg = _errMsg;
-(instancetype)initWithValue:(double) value errMsg:(NSString *) msg{
    if (self = [super init]) {
        self.value = value;
        self.errMsg = msg;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{value:%lf, errMsg:%@}",self.value,self.errMsg];
}
@end

@implementation WXSetScreenBrightnessRes
@synthesize errMsg = _errMsg;
-(instancetype)initWithErrMsg: (NSString *) msg {
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@}",self.errMsg];
}
@end

@implementation WXSetKeepScreenOnRes
@synthesize errMsg = _errMsg;
-(instancetype)initWithErrMsg: (NSString *) msg {
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@}",self.errMsg];
}
@end

@implementation WXGetScreenBrightnessObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

@implementation WXSetScreenBrightnessObject
@synthesize value = _value;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

@implementation WXSetKeepScreenOnObject
@synthesize keepScreenOn = _keepScreenOn;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

@implementation WX (WXScreen)

-(WXOnUserCaptureScreen)onUserCaptureScreen{
    return objc_getAssociatedObject(self, WXOnUserCaptureScreenKey);
}

-(void)setOnUserCaptureScreen:(WXOnUserCaptureScreen)onUserCaptureScreen{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    });
    objc_setAssociatedObject(self, WXOnUserCaptureScreenKey, onUserCaptureScreen, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)userDidTakeScreenshot{
    self.onUserCaptureScreen();
}

-(void)getScreenBrightness:(id<WXGetScreenBrightnessObject>) object{
    WXGetScreenBrightnessRes * res = [[WXGetScreenBrightnessRes alloc] initWithValue:[UIScreen mainScreen].brightness errMsg:@"getScreenBrightness:ok"];
    object.success(res);
    object.complete(res);
    
}
-(void)setScreenBrightness:(id<WXSetScreenBrightnessObject>) object{
    [[UIScreen mainScreen] setBrightness:object.value];
    WXSetScreenBrightnessRes * res = [[WXSetScreenBrightnessRes alloc] initWithErrMsg:@"setScreenBrightness:ok"];
    object.success(res);
    object.complete(res);
}
-(void)setKeepScreenOn:(id<WXSetKeepScreenOnObject>) object{
    [[UIApplication sharedApplication] setIdleTimerDisabled:object.keepScreenOn];
    WXSetKeepScreenOnRes * res = [[WXSetKeepScreenOnRes alloc] initWithErrMsg:@"setKeepScreenOn:ok"];
    object.success(res);
    object.complete(res);
}

@end
