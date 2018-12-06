//
//  WXIBeacon.m
//  WX
//
//  Created by zuowu on 2018/12/4.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXIBeacon.h"


#define PeripheralManagerKey "PeripheralManagerKey"
#define StartBeaconDiscoveryObjectKey "StartBeaconDiscoveryObjectKey"
#define BeaconRegionArrayKey "BeaconRegionArrayKey"
#define BeaconArrayDicKey "BeaconArrayDicKey"
#define OnBeaconServiceChangKey "OnBeaconServiceChangKey"
#define OnBeaconUpdateKey "OnBeaconUpdateKey"

#define BeaconAvaliabeKey "BeaconAvaliabeKey"
#define BeaconDiscoveringKey "BeaconDiscoveringKey"



@implementation WXIBeaconInfo
@synthesize uuid = _uuid;
@synthesize major = _major;
@synthesize minor = _minor;
@synthesize proximity = _proximity;
@synthesize accuracy = _accuracy;
@synthesize rssi = _rssi;
-(instancetype)initWithBeacon:(CLBeacon *)beacon{
    if (self = [super init]) {
        self.uuid = beacon.proximityUUID.UUIDString;
        self.major = beacon.major;
        self.minor = beacon.minor;
        self.proximity = beacon.proximity;
        self.accuracy = beacon.accuracy;
        self.rssi = beacon.rssi;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{uuid:%@, major:%@, minor:%@, proximity:%ld, accuracy:%lf, rssi:%ld}",self.uuid,self.major,self.minor,(long)self.proximity,self.accuracy,(long)self.rssi];
}
@end

@implementation WXStartBeaconDiscoveryRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode{
    if (self = [super init]) {
        self.errMsg = errMsg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d}",self.errMsg, self.errCode];
}
@end

@implementation WXStartBeaconDiscoveryObject
@synthesize uuids = _uuids;
@synthesize ignoreBluetoothAvailable = _ignoreBluetoothAvailable;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end




@implementation WXStopBeaconDiscoveryRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode{
    if (self = [super init]) {
        self.errMsg = errMsg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d}",self.errMsg, self.errCode];
}
@end

@implementation WXStopBeaconDiscoveryObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end



@implementation WXGetBeaconsRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
@synthesize beacons = _beacons;
-(instancetype)initWithBeacons:(NSArray *)beacons ErrMsg:(NSString *)errMsg ErrCode:(int)errCode{
    if (self = [super init]) {
        self.beacons = beacons;
        self.errMsg = errMsg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendString:@"(\n"];
    for (int i = 0 ; i < self.beacons.count; i++) {
        [str appendString:[NSString stringWithFormat:@"%@,\n", [self.beacons objectAtIndex:i]]];
    }
    [str appendString:@")"];
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d, beacons:%@}",self.errMsg,self.errCode,self.beacons];
}
@end

@implementation WXGetBeaconsObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end



@implementation WXOnBeaconServiceChangeRes
@synthesize available = _available;
@synthesize discovering = _discovering;
-(instancetype)initWithAvailable:(NSNumber *)available Discovering:(NSNumber *)discovering{
    if (self = [super init]) {
        self.available = [available boolValue];
        self.discovering = [discovering boolValue];
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"available:%d, discovering%d", self.available, self.discovering];
}
@end




@implementation WXOnBeaconUpdateRes
@synthesize beacons = _beacons;
-(instancetype)initWithBeacons:(NSArray *)beacons{
    if (self == [super init]) {
        self.beacons = beacons;
    }
    return self;
}
-(NSString *)description{
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendString:@"(\n"];
    for (int i = 0 ; i < self.beacons.count; i++) {
        [str appendString:[NSString stringWithFormat:@"%@,\n", [self.beacons objectAtIndex:i]]];
    }
    [str appendString:@")"];
    return str;
}
@end




@interface WX ()

@property (nonatomic, strong, readonly) CBPeripheralManager * peripheralManager;
@property (nonatomic, strong) WXStartBeaconDiscoveryObject * startBeaconDiscoveryObject;
@property (nonatomic, strong) NSMutableArray<CLBeaconRegion *> * beaconRegionArray;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<CLBeacon *> *> * beaconArrayDic;

@property (nonatomic, copy) NSNumber * beaconAvailable;
@property (nonatomic, copy) NSNumber * beaconDiscovering;

@end

@implementation WX (WXIBeacon)

-(CBPeripheralManager *) peripheralManager{
    CBPeripheralManager * _peripheralManager = objc_getAssociatedObject(self, PeripheralManagerKey);
    if (!_peripheralManager) {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        objc_setAssociatedObject(self, PeripheralManagerKey, _peripheralManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _peripheralManager;
}

-(WXStartBeaconDiscoveryObject *)startBeaconDiscoveryObject{
    return objc_getAssociatedObject(self, StartBeaconDiscoveryObjectKey);
}
-(void)setStartBeaconDiscoveryObject:(WXStartBeaconDiscoveryObject *)startBeaconDiscoveryObject{
    objc_setAssociatedObject(self, StartBeaconDiscoveryObjectKey, startBeaconDiscoveryObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)beaconRegionArray{
    NSMutableArray * _beaconRegionArray = objc_getAssociatedObject(self, BeaconRegionArrayKey);
    if (!_beaconRegionArray) {
        _beaconRegionArray = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, BeaconRegionArrayKey, _beaconRegionArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _beaconRegionArray;
}

-(NSMutableDictionary *)beaconArrayDic{
    NSMutableDictionary * _beaconArrayDic = objc_getAssociatedObject(self, BeaconArrayDicKey);
    if (!_beaconArrayDic) {
        _beaconArrayDic = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, BeaconArrayDicKey, _beaconArrayDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _beaconArrayDic;
}

-(WXOnBeaconServiceChang)onBeaconServiceChang{
    return objc_getAssociatedObject(self, OnBeaconServiceChangKey);
}
-(void)setOnBeaconServiceChang:(WXOnBeaconServiceChang)onBeaconServiceChang{
    objc_setAssociatedObject(self, OnBeaconServiceChangKey, onBeaconServiceChang, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WXOnBeaconUpdate)onBeaconUpdate{
    return objc_getAssociatedObject(self, OnBeaconUpdateKey);
}
-(void)setOnBeaconUpdate:(WXOnBeaconUpdate)onBeaconUpdate{
    objc_setAssociatedObject(self, OnBeaconUpdateKey, onBeaconUpdate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)beaconAvailable{
    return objc_getAssociatedObject(self, BeaconAvaliabeKey);
}
-(void)setBeaconAvailable:(NSNumber *)beaconAvailable{
    objc_setAssociatedObject(self, BeaconAvaliabeKey, beaconAvailable, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSNumber *)beaconDiscovering{
    return objc_getAssociatedObject(self, BeaconDiscoveringKey);
}
-(void)setBeaconDiscovering:(NSNumber *)beaconDiscovering{
    objc_setAssociatedObject(self, BeaconDiscoveringKey, beaconDiscovering, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSArray<WXIBeaconInfo *> *)collectBeacons{
    NSMutableArray<WXIBeaconInfo *> * arr = [[NSMutableArray alloc]init];
    if (self.beaconArrayDic) {
        for (NSString * key in self.beaconArrayDic.allKeys) {
            NSArray * beacons = [self.beaconArrayDic objectForKey:key];
            for (CLBeacon * beacon in beacons) {
                WXIBeaconInfo * info = [[WXIBeaconInfo alloc]initWithBeacon:beacon];
                [arr addObject:info];
            }
        }
    }
    return arr;
}


-(void)startRangingBeacons:(WXStartBeaconDiscoveryObject *)object{
    
    
    BOOL location = [CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);
    
    if (location) {
        
        for (int i = 0 ; i < object.uuids.count; i++) {
            NSString * strID = [object.uuids objectAtIndex:i];
            NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:strID];
            NSString * identifier = [NSString stringWithFormat:@"WX_%d",i];
            CLBeaconRegion * region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:identifier];
            [self.beaconRegionArray addObject:region];
            [self.locationManager startRangingBeaconsInRegion:region];
        }
        WXStartBeaconDiscoveryRes * res = [[WXStartBeaconDiscoveryRes alloc] initWithErrMsg:@"startBeaconDiscovery:ok" ErrCode:0];
        object.success(res);
        object.complete(res);
        
        self.beaconDiscovering = @YES;
        
        self.onBeaconServiceChang([[WXOnBeaconServiceChangeRes alloc] initWithAvailable:self.beaconAvailable Discovering:self.beaconDiscovering]);
        
    }else {
        
        WXStartBeaconDiscoveryRes * res = [[WXStartBeaconDiscoveryRes alloc] initWithErrMsg:@"startBeaconDiscovery:fail fail: location service unavailable" ErrCode:11002];
        object.fail(res);
        object.complete(res);
        
        self.onBeaconServiceChang([[WXOnBeaconServiceChangeRes alloc] initWithAvailable:self.beaconAvailable Discovering:self.beaconDiscovering]);
        
    }
    
}

-(void)startBeaconDiscovery:(id<WXIBeaconObject, WXStartBeaconDiscoveryInfo>) object{
    
    [self peripheralManager];
    
    if (object.ignoreBluetoothAvailable) {
        
        self.startBeaconDiscoveryObject = object;
        
    }else {
        
        [self startRangingBeacons:object];

    }
    
}

-(void)stopBeaconDiscovery:(id<WXIBeaconObject>) object{
    
    for (CLBeaconRegion * region in self.beaconRegionArray) {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    [self.beaconRegionArray removeAllObjects];
    [self.beaconArrayDic removeAllObjects];
    
    WXStopBeaconDiscoveryRes * res = [[WXStopBeaconDiscoveryRes alloc] initWithErrMsg:@"stopBeaconDiscovery:ok" ErrCode:0];
    object.success(res);
    object.complete(res);
    
    self.beaconDiscovering =  @NO;
    self.onBeaconServiceChang([[WXOnBeaconServiceChangeRes alloc] initWithAvailable:self.beaconAvailable Discovering:self.beaconDiscovering]);
}

-(void)getBeacons:(id<WXIBeaconObject>) object{
    
    WXGetBeaconsRes * res = [[WXGetBeaconsRes alloc] initWithBeacons:[self collectBeacons] ErrMsg:@"getBeacons:ok" ErrCode:0];
    object.success(res);
    object.complete(res);
}


#pragma mark -- CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    
    NSLog(@"didRangeBeacons");
    [self.beaconArrayDic setObject:beacons forKey:region.proximityUUID.UUIDString];
    //NSLog(@"dic = %@", self.beaconArrayDic);
    self.onBeaconUpdate([[WXOnBeaconUpdateRes alloc] initWithBeacons:[self collectBeacons]]);

}

- (void)peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *)peripheral {
    
    if (self.startBeaconDiscoveryObject) {
        if (peripheral.state == CBCentralManagerStatePoweredOn) {
            
            [self startRangingBeacons:self.startBeaconDiscoveryObject];
            
        }else{
            WXStartBeaconDiscoveryRes * res = [[WXStartBeaconDiscoveryRes alloc] initWithErrMsg:@"startBeaconDiscovery:fail fail:bluetooth power off" ErrCode:11000];
            self.startBeaconDiscoveryObject.fail(res);
            self.startBeaconDiscoveryObject.complete(res);
        }
        
        self.startBeaconDiscoveryObject = nil;
    }
    
    self.beaconAvailable = peripheral.state == CBCentralManagerStatePoweredOn ? @YES : @NO;
    self.onBeaconServiceChang([[WXOnBeaconServiceChangeRes alloc] initWithAvailable:self.beaconAvailable Discovering:self.beaconDiscovering]);
}

@end
