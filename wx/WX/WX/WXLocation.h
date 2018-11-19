//
//  WXLocation.h
//  WX
//
//  Created by hailong11 on 2018/11/12.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <WX/WXObject.h>
#import <objc/runtime.h>
#import <CoreLocation/CoreLocation.h>

@protocol WXChooseLocationRes <NSObject>

@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * address;
@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;

@end

typedef void (^WXChooseLocationObjectSuccess)(id<WXChooseLocationRes> res);
typedef void (^WXChooseLocationObjectFail)(NSError * error);
typedef void (^WXChooseLocationObjectComplete)(void);

@protocol WXChooseLocationObject <NSObject>

@property(nonatomic,strong) WXChooseLocationObjectSuccess success;
@property(nonatomic,strong) WXChooseLocationObjectFail fail;
@property(nonatomic,strong) WXChooseLocationObjectComplete complete;

@end


@protocol WXGetLocationRes <NSObject>

@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;
@property(nonatomic,assign) double speed;
@property(nonatomic,assign) double accuracy;
@property(nonatomic,assign) double altitude;
@property(nonatomic,assign) double verticalAccuracy;
@property(nonatomic,assign) double horizontalAccuracy;
@property(nonatomic,copy) NSString * errMsg;

-(instancetype)initWithCLLocation:(CLLocation *)location errMsg:(NSString *)msg type:(NSString *)type;

@end

typedef void (^WXGetLocationObjectSuccess)(id<WXGetLocationRes> res);
typedef void (^WXGetLocationObjectFail)(NSError * error);
typedef void (^WXGetLocationObjectComplete)(id<WXGetLocationRes> res);

@protocol WXGetLocationObject <NSObject>

@property(nonatomic,strong) WXGetLocationObjectSuccess success;
@property(nonatomic,strong) WXGetLocationObjectFail fail;
@property(nonatomic,strong) WXGetLocationObjectComplete complete;

@property(nonatomic,strong) NSString * type;
@property(nonatomic,assign) BOOL altitude;

@end


@protocol WXOnCompassChageRes <NSObject>

@property (nonatomic, assign) double direction;
@property (nonatomic, assign) double accuracy;

@end

@protocol WXComparesRes <NSObject>

@property (nonatomic, copy) NSString * errMsg;

@end


typedef void (^WXStartCompassObjectSuccess)(id<WXComparesRes> res);
typedef void (^WXStartCompassObjectFail)(NSError * error);
typedef void (^WXStartCompassObjectComplete)(id<WXComparesRes> res);

@protocol WXStartCompassObject <NSObject>

@property (nonatomic, strong) WXStartCompassObjectSuccess success;
@property (nonatomic, strong) WXStartCompassObjectFail fail;
@property (nonatomic, strong) WXStartCompassObjectComplete complete;

@end


typedef void (^WXStopCompassObjectSuccess)(id<WXComparesRes> res);
typedef void (^WXStopCompassObjectFail)(NSError * error);
typedef void (^WXStopCompassObjectComplete)(id<WXComparesRes> res);

@protocol WXStopCompassObject <NSObject>

@property (nonatomic, strong) WXStopCompassObjectSuccess success;
@property (nonatomic, strong) WXStopCompassObjectFail fail;
@property (nonatomic, strong) WXStopCompassObjectComplete complete;

@end


@interface WXComparesRes : NSObject<WXComparesRes>

-(instancetype)initWithErrMsg:(NSString *) msg;

@end

@interface WXChooseLocationRes : NSObject<WXChooseLocationRes>

@end

@interface WXChooseLocationObject  : NSObject<WXChooseLocationObject>

@end

@interface WXGetLocationRes : NSObject<WXGetLocationRes>

@end

@interface WXGetLocationObject : NSObject<WXGetLocationObject>

@end

@interface WXStartCompassObject : NSObject<WXStartCompassObject>

@end

@interface WXStopCompassObject : NSObject<WXStopCompassObject>

@end

@interface WXOnCompassChageRes : NSObject<WXOnCompassChageRes>

-(instancetype)initWithHeading:(CLHeading *)heading;

@end

typedef void(^WXOnCompassChange) (id<WXOnCompassChageRes> res);

@interface WX (WXLocation) <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CLLocationManager * locationManager;
@property (nonatomic, strong) WXGetLocationObject * getLocationObject;

-(void) chooseLocation:(id<WXChooseLocationObject>) object;
-(void) getLocation:(id<WXGetLocationObject>) object;

@property (nonatomic, strong) WXOnCompassChange onCompassChange;

-(void) startCompass:(id<WXStartCompassObject>) object;
-(void) stopCompass:(id<WXStopCompassObject>) object;

@end

@interface CLLocation (WXLocation)
/*CoreLocation 获取的地址为wgs84 这个方法可以生成一个转换成 gcj02 标准的坐标*/
-(CLLocationCoordinate2D)generateGCJ02Coordinate;

@end


