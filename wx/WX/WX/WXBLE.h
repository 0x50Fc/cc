//
//  WXBLE.h
//  WX
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <WX/WX.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol WXBluetoothRes;
@protocol WXBluetoothObject;

@protocol WXBluetoothRes <NSObject>
@property (nonatomic, copy) NSString * errMsg;
@property (nonatomic, assign) int errCode;
@end

typedef void (^WXBluetoothObjectSuccess) (id<WXBluetoothRes> res);
typedef void (^WXBluetoothObjectFail) (id<WXBluetoothRes> res);
typedef void (^WXBluetoothObjectComplete) (id<WXBluetoothRes> res);

@protocol WXBluetoothObject <NSObject>
@property (nonatomic, strong) WXBluetoothObjectSuccess success;
@property (nonatomic, strong) WXBluetoothObjectFail fail;
@property (nonatomic, strong) WXBluetoothObjectComplete complete;
@end

@protocol WXCreateBLEConnectionInfo <NSObject>
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, assign) double timeout;
@end

@protocol WXGetBLEConnectionInfo <NSObject>
@property (nonatomic, strong) NSString * deviceId;
@end


@interface WXCreateBLEConnectionRes : NSObject <WXBluetoothRes>
@end

@interface WXCreateBLEConnectionObject : NSObject <WXBluetoothObject, WXCreateBLEConnectionInfo>
@end


@interface WXCloseBLEConnectionRes : NSObject <WXBluetoothRes>
@end

@interface WXCloseBLEConnectionObject : NSObject <WXBluetoothObject, WXGetBLEConnectionInfo>
@end


@protocol WXBLEDeviceService <NSObject>
@property (nonatomic, copy) NSString * uuid;
@property (nonatomic, assign) BOOL isPrimary;
@end

@interface WXBLEDeviceService : NSObject<WXBLEDeviceService>
@end

@interface WXGetBLEDeviceServicesRes : NSObject <WXBluetoothRes>
@property (nonatomic, copy) NSString * deviceId;
@property (nonatomic, copy) NSMutableArray<WXBLEDeviceService *> * services;
@end

@interface WXGetBLEDeviceServicesObject : NSObject<WXBluetoothObject, WXGetBLEConnectionInfo>
@end


@interface WX (WXBLE) <CBPeripheralDelegate>

-(void)createBLEConnection:(id<WXBluetoothObject, WXCreateBLEConnectionInfo>) object;
-(void)closeBLEConnection:(id<WXBluetoothObject, WXGetBLEConnectionInfo>) object;

-(void)getBLEDeviceServices:(id<WXBluetoothObject, WXGetBLEConnectionInfo>) object;

@end


