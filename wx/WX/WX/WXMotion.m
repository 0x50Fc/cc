//
//  WXAccelerometer.m
//  WX
//
//  Created by zuowu on 2018/11/15.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXMotion.h"

#define MotionManagerKey "MotionManagerKey"
#define OnAccelerometerChangeKey "OnAccelerometerChange"
#define OnGyroscopeChangeKey "OnGyroscopeChangeKey"


@implementation WXStartAccelerometerRes

@synthesize errMsg = _errMsg;

-(instancetype)initWithErrMsg:(NSString *)msg{
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}

-(NSString *)description{
    return self.errMsg;
}

@end


@implementation WXOnAccelerometerChangeRes

@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;

-(instancetype)initWithCMAccelerometerData:(CMAccelerometerData *) data{
    if (self = [super init]) {
        self.x = data.acceleration.x;
        self.y = data.acceleration.y;
        self.z = data.acceleration.z;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"{x: %lf, y : %lf, z : %lf}", _x,_y,_z];
}

@end


@implementation WXStartAccelerometerObject

@synthesize interval = _interval;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;

@end


@implementation WXGyroscopeRes

@synthesize errMsg = _errMsg;

-(instancetype)initWithErrMsg:(NSString*) msg {
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@}", self.errMsg];
}

@end


@implementation WXStartGyroscopeObject

@synthesize interval = _interval;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;

@end


@implementation WXStopGyroscopeObject

@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;

@end


@implementation WXOnGyroscopeChangeRes

@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;

-(instancetype)initWithCMGyroData:(CMGyroData *) data {
    if (self = [super init]) {
        self.x = data.rotationRate.x;
        self.y = data.rotationRate.y;
        self.z = data.rotationRate.z;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"{x:%lf, y:%lf, z:%lf}",_x,_y,_z];
}
@end


@implementation WX (Motion)

-(WXOnAccelerometerChange)onAccelerometerChange {
    return  objc_getAssociatedObject(self, OnAccelerometerChangeKey);
}

-(void)setOnAccelerometerChange:(WXOnAccelerometerChange)onAccelerometerChange{
    objc_setAssociatedObject(self, OnAccelerometerChangeKey, onAccelerometerChange, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WXOnGyroscopeChange)onGyrscopeChage{
    return  objc_getAssociatedObject(self, OnGyroscopeChangeKey);
}

-(void)setOnGyrscopeChage:(WXOnGyroscopeChange)onGyrscopeChage{
    objc_setAssociatedObject(self, OnGyroscopeChangeKey, onGyrscopeChage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(CMMotionManager *)motionManager {
    CMMotionManager * _motionManager = objc_getAssociatedObject(self, MotionManagerKey);
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
        objc_setAssociatedObject(self, MotionManagerKey, _motionManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _motionManager;
}

-(void)startAccelerometer:(id<WXStartAccelerometerObject>) object{
    
    
    if (!self.motionManager.isAccelerometerAvailable) {
        
        NSLog(@"Accelerometer 不可用");
        object.fail(nil);
        object.complete([[WXStartAccelerometerRes alloc] initWithErrMsg:@"startAccelerometer:err - magnetometer is not active"]);

    } else {
        
        //成功回调
        self.motionManager.magnetometerUpdateInterval = [object.interval toInterval];
        object.success([[WXStartAccelerometerRes alloc] initWithErrMsg:@"startAccelerometer:ok"]);
        object.complete([[WXStartAccelerometerRes alloc] initWithErrMsg:@"startAccelerometer:ok"]);
        
        [self.motionManager startAccelerometerUpdatesToQueue: [NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            self.onAccelerometerChange([[WXOnAccelerometerChangeRes alloc] initWithCMAccelerometerData:accelerometerData]);
        }];
        
    }
}

-(void)stopAccelerometer:(id<WXStartAccelerometerObject>) object{
    [self.motionManager stopAccelerometerUpdates];
    object.success([[WXStartAccelerometerRes alloc] initWithErrMsg:@"stopAccelerometer:ok"]);
    object.complete([[WXStartAccelerometerRes alloc] initWithErrMsg:@"stopAccelerometer:ok"]);
}


-(void)startGyroscope:(id<WXStartGyroscopeObject>) object{
    
    if (!self.motionManager.isGyroAvailable) {
        
        NSLog(@"gyroscope 不可用");
        WXGyroscopeRes * res = [[WXGyroscopeRes alloc] initWithErrMsg:@"startGyroscope:err - gyroscope is not active"];
        object.fail(res);
        object.complete(res);
        
    }else{
        
        self.motionManager.gyroUpdateInterval = [object.interval toInterval];
        WXGyroscopeRes * res = [[WXGyroscopeRes alloc] initWithErrMsg:@"startGyroscope:ok"];
        object.success(res);
        object.complete(res);
        
        [self.motionManager startGyroUpdatesToQueue: [NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            self.onGyrscopeChage([[WXOnGyroscopeChangeRes alloc] initWithCMGyroData:gyroData]);
        }];
    }
    
}

-(void)stopGyroscope:(id<WXStopGyroscopeObject>) object{
    [self.motionManager stopGyroUpdates];
    WXGyroscopeRes * res = [[WXGyroscopeRes alloc] initWithErrMsg:@"stopGyroscope:ok"];
    object.success(res);
    object.complete(res);
}

@end


@implementation NSString (Motion)

-(NSTimeInterval) toInterval{
    NSTimeInterval result = 0.2;
    if ([self isEqualToString:@"game"]) {
        result = 0.02;
    }else if ([self isEqualToString:@"ui"]){
        result = 0.06;
    }else if ([self isEqualToString:@"normal"]){
        result = 0.6;
    }
    return result;
}

@end
