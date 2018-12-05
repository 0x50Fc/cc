//
//  WXIBeacon.h
//  WX
//
//  Created by zuowu on 2018/12/4.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <WX/WX.h>
#import <CoreLocation/CoreLocation.h>

@protocol WXIBeaconRes <NSObject>
@property (nonatomic, strong) NSString * errMsg;
@property (nonatomic, assign) int errCode;
@end

typedef void (^WXIBeaconObjectSuccess) (id<WXBluetoothRes> res);
typedef void (^WXIBeaconObjectFail) (id<WXBluetoothRes> res);
typedef void (^WXIBeaconObjectComplete) (id<WXBluetoothRes> res);

@protocol WXIBeaconObject <NSObject>
@property (nonatomic, strong) WXIBeaconObjectSuccess success;
@property (nonatomic, strong) WXIBeaconObjectFail fail;
@property (nonatomic, strong) WXIBeaconObjectComplete complete;
@end

@protocol IBeaconInfo <NSObject>
@property (nonatomic, copy) NSString * uuid;          //设备广播的 uuid
@property (nonatomic, copy) NSString * major;         //设备的主 id
@property (nonatomic, copy) NSString * minor;         //设备的次 id
@property (nonatomic, assign) NSInteger proximity;    //表示设备距离的枚举值
@property (nonatomic, assign) double accuracy;        //设备的距离
@property (nonatomic, assign) double rssi;            //信号强度
@end

@interface IBeaconInfo : NSObject <IBeaconInfo>
@end




@protocol WXStartBeaconDiscoveryInfo <NSObject>
@property (nonatomic, copy) NSArray * uuids;
@property (nonatomic, assign) BOOL ignoreBluetoothAvailable;
@end

@interface WXStartBeaconDiscoveryRes : NSObject <WXIBeaconRes>
@end

@interface WXStartBeaconDiscoveryObject : NSObject <WXIBeaconObject, WXStartBeaconDiscoveryInfo>
@end




@interface WXStopBeaconDiscoveryRes : NSObject <WXIBeaconRes>
@end

@interface WXStopBeaconDiscoveryObject : NSOrderedSet <WXIBeaconObject>
@end




@interface WXGetBeaconsRes : NSObject <WXIBeaconRes>
@property (nonatomic, copy) NSArray<IBeaconInfo *> * beacons;
@end

@interface WXGetBeaconsObject : NSObject <WXIBeaconObject>
@end




@protocol WXOnBeaconServiceChangeRes <NSObject>
@property (nonatomic, assign) BOOL available;
@property (nonatomic, assign) BOOL discovering;
@end

@interface WXOnBeaconServiceChangeRes : NSObject <WXOnBeaconServiceChangeRes>
@end



@protocol WXOnBeaconUpdateRes <NSObject>
@property (nonatomic, copy) NSArray<IBeaconInfo *> * beacons;
@end

@interface WXOnBeaconUpdateRes : NSObject <WXOnBeaconUpdateRes>
@end




typedef void (^WXOnBeaconServiceChang)(id<WXOnBeaconServiceChangeRes> res);
typedef void (^WXOnBeaconUpdate)(id<WXOnBeaconUpdateRes> res);

@interface WX (WXIBeacon)

@property (nonatomic, strong) WXOnBeaconServiceChang onBeaconServiceChang;
@property (nonatomic, strong) WXOnBeaconUpdate onBeaconUpdate;

-(void)startBeaconDiscovery:(id<WXIBeaconObject, WXStartBeaconDiscoveryInfo>) object;
-(void)stopBeaconDiscovery:(id<WXIBeaconObject>) object;

-(void)getBeacons:(id<WXIBeaconObject>) object;

@end


