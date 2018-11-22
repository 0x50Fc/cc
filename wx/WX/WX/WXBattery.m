//
//  WXBattery.m
//  WX
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXBattery.h"

#pragma mark -- battery --

@implementation WXGetBatteryInfoRes

@synthesize level = _level;
@synthesize isCharging = _isCharging;
@synthesize errMsg = _errMsg;

-(instancetype)initWithLevel:(float) level BatteryState:(UIDeviceBatteryState) state errMsg:(NSString *) msg {
    if (self = [super init]) {
        if (level >= 0.0f && level <= 1.0f) {
            int Il = level * 100;
            self.level = [NSString stringWithFormat:@"%d", Il];
        }else {
            self.level = @"100";
        }
        self.isCharging = state == UIDeviceBatteryStateCharging ? YES: NO;
        self.errMsg = msg;
    }
    return self;
}

-(NSString *)description{
    NSDictionary * dic = @{
                           @"level": _level,
                           @"isCharing": [NSNumber numberWithBool:_isCharging],
                           @"errMsg": _errMsg
                           };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end


@implementation WXGetBatteryInfoObject

@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;

@end


#pragma mark -- wx --

@implementation WX (WXBattery)

-(void)getBatteryInfo:(id<WXGetBatteryInfoObject>) object{
    UIDevice * device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    WXGetBatteryInfoRes * res = [[WXGetBatteryInfoRes alloc] initWithLevel:device.batteryLevel BatteryState:device.batteryState errMsg:@"getBatteryInfo:ok"];
    object.complete(res);
    object.success(res);
}




@end

