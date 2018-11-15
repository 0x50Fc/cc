//
//  WXAccelerometer.h
//  WX
//
//  Created by zuowu on 2018/11/15.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <WX/WXObject.h>
#import <objc/runtime.h>
#import <CoreMotion/CoreMotion.h>



@protocol WXStartAccelerometerRes <NSObject>

@property(nonatomic,copy) NSString * errMsg;

@end


typedef void (^WXStartAccelerometerObjectSuccess)(id<WXStartAccelerometerRes> res);
typedef void (^WXStartAccelerometerObjectFail)(NSError * error);
typedef void (^WXStartAccelerometerObjectComplete)(id<WXStartAccelerometerRes> res);

@protocol WXStartAccelerometerObject <NSObject>

/*
 * game    20ms/次
 * ui      60ms/次
 * noraml 200ms/次
 */
@property(nonatomic, copy) NSString * interval;
@property(nonatomic, strong) WXStartAccelerometerObjectSuccess success;
@property(nonatomic, strong) WXStartAccelerometerObjectFail fail;
@property(nonatomic, strong) WXStartAccelerometerObjectComplete complete;

@end


@protocol WXOnAccelerometerChangeRes <NSObject>

@property(nonatomic,assign) double x;
@property(nonatomic,assign) double y;
@property(nonatomic,assign) double z;

-(instancetype)initWithX:(double)dx Y:(double)dy Z:(double)dz;

@end


@interface WXStartAccelerometerRes : NSObject <WXStartAccelerometerRes>

-(instancetype)initWithErrMsg:(NSString *)msg;

@end


@interface WXOnAccelerometerChangeRes : NSObject <WXOnAccelerometerChangeRes>

@end


@interface WXStartAccelerometerObject : NSObject <WXStartAccelerometerObject>

@end


typedef void (^WXOnAccelerometerChange)(id<WXOnAccelerometerChangeRes> res);

@interface WX (WXAccelerometer)

@property (nonatomic, strong, readonly) CMMotionManager * motionManager;
@property(nonatomic, strong) WXOnAccelerometerChange onAccelerometerChange;

-(void)startAccelerometer:(id<WXStartAccelerometerObject>) object;
-(void)stopAccelerometer:(id<WXStartAccelerometerObject>) object;

@end


