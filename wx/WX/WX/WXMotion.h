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



#pragma mark -- accelerometer --

@protocol WXStartAccelerometerRes <NSObject>

@property(nonatomic,copy) NSString * errMsg;

@end


typedef void (^WXStartAccelerometerObjectSuccess)(id<WXStartAccelerometerRes> res);
typedef void (^WXStartAccelerometerObjectFail)(NSError * error);
typedef void (^WXStartAccelerometerObjectComplete)(id<WXStartAccelerometerRes> res);

@protocol WXStartAccelerometerObject <NSObject>

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

#pragma mark -- gyrosco --

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


#pragma mark -- device motion --

@protocol WXOnDeviceMotionChangeRes <NSObject>

@property (nonatomic, assign) double alpha;
@property (nonatomic, assign) double beta;
@property (nonatomic, assign) double gamma;

@property (nonatomic, copy) NSString * testStr;

@end

@protocol WXDeviceMotionRes <NSObject>

@property (nonatomic, copy) NSString * errMsg;

@end

typedef void (^WXStartDeviceMotionListeningObjectSuccess)(id<WXDeviceMotionRes> res);
typedef void (^WXStartDeviceMotionListeningObjectFail)(id<WXDeviceMotionRes> res);
typedef void (^WXStartDeviceMotionListeningObjectComplete)(id<WXDeviceMotionRes> res);

@protocol WXStartDeviceMotionListeningObject <NSObject>

@property (nonatomic, copy) NSString * interval;
@property (nonatomic, strong) WXStartDeviceMotionListeningObjectSuccess success;
@property (nonatomic, strong) WXStartDeviceMotionListeningObjectFail fail;
@property (nonatomic, strong) WXStartDeviceMotionListeningObjectComplete complete;

@end

typedef void (^WXStopDeviceMotionListeningObjectSuccess)(id<WXDeviceMotionRes> res);
typedef void (^WXStopDeviceMotionListeningObjectFail)(id<WXDeviceMotionRes> res);
typedef void (^WXStopDeviceMotionListeningObjectComplete)(id<WXDeviceMotionRes> res);

@protocol WXStopDeviceMotionListeningObject <NSObject>

@property (strong, nonatomic) WXStopDeviceMotionListeningObjectSuccess success;
@property (strong, nonatomic) WXStopDeviceMotionListeningObjectFail fail;
@property (strong, nonatomic) WXStopDeviceMotionListeningObjectComplete complete;

@end

@interface WXOnDeviceMotionChangeRes : NSObject <WXOnDeviceMotionChangeRes>
-(instancetype)initWithCMDeviceMotion:(CMDeviceMotion *) motion;
@end

@interface WXDeviceMotionRes : NSObject <WXDeviceMotionRes>
-(instancetype) initWithErrMsg:(NSString *) msg;
@end

@interface WXStartDeviceMotionListeningObject : NSObject <WXStartDeviceMotionListeningObject>
@end

@interface WXStopDeviceMotionListeningObject : NSObject <WXStopDeviceMotionListeningObject>
@end

#pragma mark -- wx --

typedef void (^WXOnAccelerometerChange)(id<WXOnAccelerometerChangeRes> res);
typedef void (^WXOnGyroscopeChange)(id<WXOnGyroscopeChangeRes> res);
typedef void (^WXOnDeviceMotionChange)(id<WXOnDeviceMotionChangeRes> res);

@interface WX (Motion)

@property (nonatomic, strong, readonly) CMMotionManager * motionManager;
@property (nonatomic, strong) WXOnAccelerometerChange onAccelerometerChange;
@property (nonatomic, strong) WXOnGyroscopeChange onGyrscopeChage;
@property (nonatomic, strong) WXOnDeviceMotionChange onDeviceMotionChange;

-(void)startAccelerometer:(id<WXStartAccelerometerObject>) object;
-(void)stopAccelerometer:(id<WXStartAccelerometerObject>) object;

-(void)startGyroscope:(id<WXStartGyroscopeObject>) object;
-(void)stopGyroscope:(id<WXStopGyroscopeObject>) object;

-(void)startDeviceMotionListening:(id<WXStartDeviceMotionListeningObject>) object;
-(void)stopDeviceMotionListening:(id<WXStopDeviceMotionListeningObject>) object;

@end


@interface NSString (Motion)
-(NSTimeInterval) toInterval;
@end


