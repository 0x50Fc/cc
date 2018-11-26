//
//  WXVibrate.m
//  WX
//
//  Created by zuowu on 2018/11/26.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXVibrate.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation WXVibrateLongRes
@synthesize errMsg = _errMsg;
-(instancetype)initWithErrMsg:(NSString *)msg{
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}
@end

@implementation WXVibrateShortRes
@synthesize errMsg = _errMsg;
-(instancetype)initWithErrMsg:(NSString *)msg{
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}
@end

@implementation WXVibrateLongObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

@implementation WXVibrateShortObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

@implementation WX (WXVibrate)

-(void)virateLong:(id<WXVibrateLongObject>) object {
    WXVibrateLongRes * res = [[WXVibrateLongRes alloc] initWithErrMsg:@"vibrateLong:ok"];
    object.success(res);
    object.complete(res);
    AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
        
    });
}

@end
