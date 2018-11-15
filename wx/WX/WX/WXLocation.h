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


@interface WXChooseLocationRes : NSObject<WXChooseLocationRes>

@end

@interface WXChooseLocationObject  : NSObject<WXChooseLocationObject>

@end

@interface WXGetLocationRes : NSObject<WXGetLocationRes>

@end

@interface WXGetLocationObject : NSObject<WXGetLocationObject>

@end

@interface WX (WXLocation) <CLLocationManagerDelegate>
@property (nonatomic, strong, readonly) CLLocationManager * locationManager;
@property (nonatomic, strong) WXGetLocationObject * getLocationObject;

-(void) chooseLocation:(id<WXChooseLocationObject>) object;
-(void) getLocation:(id<WXGetLocationObject>) object;
@end

@interface CLLocation (WXLocation)
/*CoreLocation 获取的地址为wgs84 这个方法可以生成一个转换成 gcj02 标准的坐标*/
-(CLLocationCoordinate2D)generateGCJ02Coordinate;

@end


