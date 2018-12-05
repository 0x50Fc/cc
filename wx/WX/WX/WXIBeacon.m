//
//  WXIBeacon.m
//  WX
//
//  Created by zuowu on 2018/12/4.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXIBeacon.h"

#define BeaconRegionKey "BeaconRegionKey"
#define OnBeaconServiceChangKey "OnBeaconServiceChangKey"
#define OnBeaconUpdateKey "OnBeaconUpdateKey"



@implementation IBeaconInfo
@synthesize uuid = _uuid;
@synthesize major = _major;
@synthesize minor = _minor;
@synthesize proximity = _proximity;
@synthesize accuracy = _accuracy;
@synthesize rssi = _rssi;
@end

@implementation WXStartBeaconDiscoveryRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
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
@end

@implementation WXGetBeaconsObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end



@implementation WXOnBeaconServiceChangeRes
@synthesize available = _available;
@synthesize discovering = _discovering;
@end




@implementation WXOnBeaconUpdateRes
@synthesize beacons = _beacons;
@end




@interface WX ()
@property (nonatomic, strong, readonly) CLBeaconRegion * beaconRegion;
@end

@implementation WX (WXIBeacon)

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

-(CLBeaconRegion *)beaconRegion{
    CLBeaconRegion * _beaconRegion = objc_getAssociatedObject(self, BeaconRegionKey);
    if (!_beaconRegion) {
        
        NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:@"5D7B50B0-CFBA-4BF8-999B-93F6DA0F4356"];
        _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"WX"];
        objc_setAssociatedObject(self, BeaconRegionKey, _beaconRegion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _beaconRegion;
}

-(void)startBeaconDiscovery:(id<WXIBeaconObject, WXStartBeaconDiscoveryInfo>) object{
    
}

-(void)stopBeaconDiscovery:(id<WXIBeaconObject>) object{
    
}

-(void)getBeacons:(id<WXIBeaconObject>) object{
    
}

@end
