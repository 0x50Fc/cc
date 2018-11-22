//
//  WXLocation.m
//  WX
//
//  Created by hailong11 on 2018/11/12.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXLocation.h"

#define LocationManagerKey "LocationManagerKey"
#define GetLocationObjectKey "GetLocationObjectKey"
#define OnCompassChangeKey "OnCompassChangeKey"

#pragma mark -- location --

@implementation WXChooseLocationRes

@synthesize address = _address;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize name = _name;

@end

@implementation WXChooseLocationObject

@synthesize fail = _fail;
@synthesize success = _success;
@synthesize complete = _complete;

@end

@implementation WXGetLocationRes

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize speed = _speed;
@synthesize accuracy = _accuracy;
@synthesize altitude = _altitude;
@synthesize verticalAccuracy = _verticalAccuracy;
@synthesize horizontalAccuracy = _horizontalAccuracy;
@synthesize errMsg = _errMsg;

-(instancetype)initWithCLLocation:(CLLocation *)location errMsg:(NSString *)msg type:(NSString *)type{
    if (self = [super init]) {
        CLLocationCoordinate2D coordinate = location.coordinate;
        //默认为wgs84 如果设置gcj02 则计算相应系统坐标
        if ([type isEqualToString:@"gcj02"]) {
            coordinate = [location generateGCJ02Coordinate];
        }
        self.latitude = coordinate.latitude;
        self.longitude = coordinate.longitude;
        self.speed = location.speed;
        self.accuracy = kCLLocationAccuracyBest;
        self.altitude = location.altitude;
        self.verticalAccuracy = location.verticalAccuracy;
        self.horizontalAccuracy = location.horizontalAccuracy;
        self.errMsg = msg;
    }
    return self;
}

-(NSString *)description{
    NSString * log = @"{     \n\
    latitude:%lf,           \n\
    longitude:%lf,          \n\
    speed:%lf,              \n\
    accuracy:%lf            \n\
    altitude:%lf            \n\
    verticalAccuracy:%lf    \n\
    horizontalAccuracy:%lf  \n\
    errMsg:\"%@\"           \n\
}";
    return [NSString stringWithFormat:log,_latitude,_longitude,_speed,_accuracy,_altitude,_verticalAccuracy,_horizontalAccuracy,_errMsg];
}

@end

@implementation WXGetLocationObject

@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@synthesize type = _type;
@synthesize altitude = _altitude;

@end

#pragma mark -- compass --

@implementation WXCompassRes

@synthesize errMsg = _errMsg;

-(instancetype)initWithErrMsg:(NSString *) msg{
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}

-(NSString *)description{
    NSDictionary * dic = @{
                           @"errMsg": _errMsg,
                           };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end

@implementation WXStartCompassObject

@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;

@end

@implementation WXStopCompassObject

@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;

@end

@implementation WXOnCompassChageRes

@synthesize direction = _direction;
@synthesize accuracy = _accuracy;

-(instancetype)initWithHeading:(CLHeading *)heading{
    if (self = [super init]) {
        self.accuracy = heading.headingAccuracy;
        self.direction = heading.trueHeading;
    }
    return self;
}

-(NSString*) description{
    return [NSString stringWithFormat:@"{direction:%f, accuracy:%f}", self.direction, self.accuracy];
}
@end

#pragma mark -- wx --

@implementation WX (WXLocation)

-(CLLocationManager *)locationManager{
    CLLocationManager * _locationManager = objc_getAssociatedObject(self, LocationManagerKey);
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestAlwaysAuthorization];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
         objc_setAssociatedObject(self, LocationManagerKey, _locationManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _locationManager;
}
    
-(WXGetLocationObject *)getLocationObject{
    return objc_getAssociatedObject(self, GetLocationObjectKey);
}
    
-(void)setGetLocationObject:(WXGetLocationObject *)object{
    objc_setAssociatedObject(self, GetLocationObjectKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(WXOnCompassChange)onCompassChange{
    return objc_getAssociatedObject(self, OnCompassChangeKey);
}
-(void)setOnCompassChange:(WXOnCompassChange)onCompassChange{
    objc_setAssociatedObject(self, OnCompassChangeKey, onCompassChange, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) chooseLocation:(id<WXChooseLocationObject>) object {
    
}

-(void) getLocation:(id<WXGetLocationObject>) object {
    self.getLocationObject = object;
    [self.locationManager startUpdatingLocation];
}

-(void) startCompass:(id<WXStartCompassObject>) object{
    [self.locationManager startUpdatingHeading];
    WXCompassRes * res = [[WXCompassRes alloc] initWithErrMsg:@"startCompass:ok"];
    object.success(res);
    object.complete(res);
}

-(void) stopCompass:(id<WXStopCompassObject>) object{
    [self.locationManager stopUpdatingHeading];
    WXCompassRes * res = [[WXCompassRes alloc] initWithErrMsg:@"stopCompass:ok"];
    object.success(res);
    object.complete(res);
}

#pragma mark -- CLLocationManager Protocol

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    CMDeviceMotion a;
    //NSLog(@"%@", locations);
    if (self.getLocationObject) {
        WXGetLocationRes * res = [[WXGetLocationRes alloc] initWithCLLocation:locations.lastObject errMsg:@"getLocation:ok" type:self.getLocationObject.type];
        self.getLocationObject.success(res);
        self.getLocationObject.complete(res);
    }
    
    [self.locationManager stopUpdatingLocation];
}
    
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //NSLog(@"%@",error);
    if (self.getLocationObject) {
        WXGetLocationRes * res = [[WXGetLocationRes alloc] initWithCLLocation:nil errMsg:@"getLocation:error" type:self.getLocationObject.type];
        self.getLocationObject.fail(error);
        self.getLocationObject.complete(res);
    }
    [self.locationManager stopUpdatingLocation];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
//    NSLog(@"new heading magneticHeading = %lf, trueHeading = %lf, headingAccuracy = %lf", newHeading.magneticHeading, newHeading.trueHeading, newHeading.headingAccuracy);
    self.onCompassChange([[WXOnCompassChageRes alloc] initWithHeading:newHeading]);
}
    
@end

@implementation CLLocation (WXLocation)

#define LAT_OFFSET_0(x,y) -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
#define LAT_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_2 (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_3 (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0

#define LON_OFFSET_0(x,y) 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
#define LON_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_2 (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_3 (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0

#define RANGE_LON_MAX 137.8347
#define RANGE_LON_MIN 72.004
#define RANGE_LAT_MAX 55.8271
#define RANGE_LAT_MIN 0.8293

#define jzA 6378245.0
#define jzEE 0.00669342162296594323

- (BOOL)outOfChina:(double)lat bdLon:(double)lon{
    if (lon < RANGE_LON_MIN || lon > RANGE_LON_MAX)
        return true;
    if (lat < RANGE_LAT_MIN || lat > RANGE_LAT_MAX)
        return true;
    return false;
}
- (double)transformLat:(double)x bdLon:(double)y{
    double ret = LAT_OFFSET_0(x, y);
    ret += LAT_OFFSET_1;
    ret += LAT_OFFSET_2;
    ret += LAT_OFFSET_3;
    return ret;
}

- (double)transformLon:(double)x bdLon:(double)y{
    double ret = LON_OFFSET_0(x, y);
    ret += LON_OFFSET_1;
    ret += LON_OFFSET_2;
    ret += LON_OFFSET_3;
    return ret;
}

- (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon{
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self outOfChina:ggLat bdLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0)bdLon:(ggLat - 35.0)];
    double dLon = [self transformLon:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - jzEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((jzA * (1 - jzEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (jzA / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}

-(CLLocationCoordinate2D)generateGCJ02Coordinate{
    return [self gcj02Encrypt:self.coordinate.latitude bdLon:self.coordinate.longitude];
}
@end


