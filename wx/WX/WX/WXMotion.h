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

-(instancetype)initWithCMAccelerometerData:(CMAccelerometerData *) data;

@end


@interface WXStartAccelerometerRes : NSObject <WXStartAccelerometerRes>

-(instancetype)initWithErrMsg:(NSString *)msg;

@end


@interface WXOnAccelerometerChangeRes : NSObject <WXOnAccelerometerChangeRes>

@end


@interface WXStartAccelerometerObject : NSObject <WXStartAccelerometerObject>

@end


@protocol WXGyroscopeRes <NSObject>

@property (nonatomic, strong) NSString * errMsg;

@end


typedef void (^WXStartGyroscopeObjectSuccess)(id<WXGyroscopeRes> res);
typedef void (^WXStartGyroscopeObjectFail)(id<WXGyroscopeRes> res);
typedef void (^WXStartGyroscopeObjectComplete)(id<WXGyroscopeRes> res);

@protocol WXStartGyroscopeObject <NSObject>

@property (nonatomic, copy) NSString * interval;
@property (nonatomic, strong) WXStartGyroscopeObjectSuccess success;
@property (nonatomic, strong) WXStartGyroscopeObjectFail fail;
@property (nonatomic, strong) WXStartGyroscopeObjectComplete complete;

@end


typedef void (^WXStopGyroscopeObjectSuccess)(id<WXGyroscopeRes> res);
typedef void (^WXStopGyroscopeObjectFail)(id<WXGyroscopeRes> res);
typedef void (^WXStopGyroscopeObjectComplete)(id<WXGyroscopeRes> res);

@protocol WXStopGyroscopeObject <NSObject>

@property (nonatomic, strong) WXStopGyroscopeObjectSuccess success;
@property (nonatomic, strong) WXStopGyroscopeObjectFail fail;
@property (nonatomic, strong) WXStopGyroscopeObjectComplete complete;

@end


@protocol WXOnGyroscopeChangeRes <NSObject>

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) double z;

@end


@interface WXGyroscopeRes:NSObject <WXGyroscopeRes>

-(instancetype)initWithErrMsg:(NSString*) msg;

@end

@interface WXStartGyroscopeObject : NSObject <WXStartGyroscopeObject>
@end

@interface WXStopGyroscopeObject : NSObject <WXStopGyroscopeObject>
@end

@interface WXOnGyroscopeChangeRes : NSObject <WXOnGyroscopeChangeRes>

-(instancetype)initWithCMGyroData:(CMGyroData *) data;

@end


typedef void (^WXOnAccelerometerChange)(id<WXOnAccelerometerChangeRes> res);
typedef void (^WXOnGyroscopeChange)(id<WXOnGyroscopeChangeRes> res);

@interface WX (Motion)

@property (nonatomic, strong, readonly) CMMotionManager * motionManager;
@property(nonatomic, strong) WXOnAccelerometerChange onAccelerometerChange;
@property(nonatomic, strong) WXOnGyroscopeChange onGyrscopeChage;

-(void)startAccelerometer:(id<WXStartAccelerometerObject>) object;
-(void)stopAccelerometer:(id<WXStartAccelerometerObject>) object;

-(void)startGyroscope:(id<WXStartGyroscopeObject>) object;
-(void)stopGyroscope:(id<WXStopGyroscopeObject>) object;

@end


@interface NSString (Motion)
-(NSTimeInterval) toInterval;
@end


