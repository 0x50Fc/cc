//
//  WXAccelerometer.m
//  WX
//
//  Created by zuowu on 2018/11/15.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXAccelerometer.h"

#define MotionManagerKey "MotionManagerKey"
#define OnAccelerometerChangeKey "OnAccelerometerChange"

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

-(instancetype)initWithX:(double)dx Y:(double)dy Z:(double)dz {
    if (self = [super init]) {
        self.x = dx;
        self.y = dy;
        self.z = dz;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"{x : %lf, y : %lf, z : %lf}", _x,_y,_z];
}

@end

@implementation WXStartAccelerometerObject

@synthesize interval = _interval;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;

@end

@implementation WX (WXAccelerometer)

-(WXOnAccelerometerChange)onAccelerometerChange {
    return  objc_getAssociatedObject(self, OnAccelerometerChangeKey);
}

-(void)setOnAccelerometerChange:(WXOnAccelerometerChange)onAccelerometerChange{
    objc_setAssociatedObject(self, OnAccelerometerChangeKey, onAccelerometerChange, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
        
        self.motionManager.magnetometerUpdateInterval = 0.2;
        if ([object.interval isEqualToString:@"game"]) {
            self.motionManager.magnetometerUpdateInterval = 0.02;
        }else if ([object.interval isEqualToString:@"ui"]){
            self.motionManager.magnetometerUpdateInterval = 0.06;
        }else if ([object.interval isEqualToString:@"normal"]) {
            self.motionManager.magnetometerUpdateInterval = 0.2;
        }
        
        //成功回调
        object.success([[WXStartAccelerometerRes alloc] initWithErrMsg:@"startAccelerometer:ok"]);
        object.complete([[WXStartAccelerometerRes alloc] initWithErrMsg:@"startAccelerometer:ok"]);
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            self.onAccelerometerChange([[WXOnAccelerometerChangeRes alloc] initWithX:accelerometerData.acceleration.x
                                                                                         Y:accelerometerData.acceleration.y
                                                                                         Z:accelerometerData.acceleration.z]);
        }];
        
    }
}

-(void)stopAccelerometer:(id<WXStartAccelerometerObject>) object{
    [self.motionManager stopAccelerometerUpdates];
    object.success([[WXStartAccelerometerRes alloc] initWithErrMsg:@"stopAccelerometer:ok"]);
    object.complete([[WXStartAccelerometerRes alloc] initWithErrMsg:@"stopAccelerometer:ok"]);
}

@end
