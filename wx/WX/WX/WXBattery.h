//
//  WXBattery.h
//  WX
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <WX/WX.h>


@protocol WXGetBatteryInfoRes <NSObject>

@property (nonatomic, copy) NSString * level;
@property (nonatomic, assign) BOOL isCharging;
@property (nonatomic, copy) NSString * errMsg;

@end


typedef void (^WXGetBatteryInfoObjectSuccess)(id<WXGetBatteryInfoRes> res);
typedef void (^WXGetBatteryInfoObjectFail)(NSError * error);
typedef void (^WXGetBatteryInfoObjectFailComplete)(id<WXGetBatteryInfoRes> res);

@protocol WXGetBatteryInfoObject <NSObject>

@property (nonatomic, strong) WXGetBatteryInfoObjectSuccess success;
@property (nonatomic, strong) WXGetBatteryInfoObjectFail fail;
@property (nonatomic, strong) WXGetBatteryInfoObjectFailComplete complete;

@end


@interface WXGetBatteryInfoRes : NSObject <WXGetBatteryInfoRes>

-(instancetype)initWithLevel:(float) level BatteryState:(UIDeviceBatteryState) state errMsg:(NSString *) msg;

@end


@interface WXGetBatteryInfoObject : NSObject <WXGetBatteryInfoObject>

@end


@interface WX (WXBattery)

-(void)getBatteryInfo:(id<WXGetBatteryInfoObject>) object;

@end
