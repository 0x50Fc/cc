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
@property (nonatomic, copy) NSArray<WXBLEDeviceService *> * services;
@end

@interface WXGetBLEDeviceServicesObject : NSObject<WXBluetoothObject, WXGetBLEConnectionInfo>
@end




@protocol WXBLEDeviceCharacteristicPropertie <NSObject>
@property (nonatomic, assign) BOOL read;                 //1<<1 CBCharacteristicPropertyRead
@property (nonatomic, assign) BOOL write;                //1<<3 CBCharacteristicPropertyWrite
@property (nonatomic, assign) BOOL notify;               //1<<4 CBCharacteristicPropertyNotify
@property (nonatomic, assign) BOOL indicate;             //1<<5 CBCharacteristicPropertyIndicate
@end

@interface WXBLEDeviceCharacteristicPropertie : NSObject <WXBLEDeviceCharacteristicPropertie>
@end

@protocol WXBLEDeviceCharacteristic <NSObject>
@property (nonatomic, strong) WXBLEDeviceCharacteristicPropertie * properties;
@property (nonatomic, copy) NSString * uuid;
@end

@interface WXBLEDeviceCharacteristic : NSObject <WXBLEDeviceCharacteristic>
@end

@interface WXGetBLEDeviceCharacteristicsRes : NSObject <WXBluetoothRes>
@property (nonatomic, copy) NSArray<WXBLEDeviceCharacteristic *> * characteristics;
@end

@protocol WXBGetLEDeviceCharacteristicsInfo <NSObject>
@property (nonatomic, copy) NSString * deviceId;
@property (nonatomic, copy) NSString * serviceId;
@end

@interface WXBGetLEDeviceCharacteristicsObject : NSObject <WXBluetoothObject, WXBGetLEDeviceCharacteristicsInfo>
@end



@interface WXNotifyBLECharacteristicValueChangeRes : NSObject <WXBluetoothRes>
@end

@protocol WXNotifyBLECharacteristicValueChangeInfo <NSObject>
@property (nonatomic, copy) NSString * deviceId;
@property (nonatomic, copy) NSString * serviceId;
@property (nonatomic, copy) NSString * characteristicId;
@property (nonatomic, assign) BOOL state;
@end

@interface WXNotifyBLECharacteristicValueChangeObject : NSObject <WXBluetoothObject, WXNotifyBLECharacteristicValueChangeInfo>
@end


@protocol WXOnBLECharacteristicValueChangeRes <NSObject>
@property (nonatomic, copy) NSString * deviceId;
@property (nonatomic, copy) NSString * serviceId;
@property (nonatomic, copy) NSString * characteristicId;
@property (nonatomic, copy) NSData * value;
@end

@interface WXOnBLECharacteristicValueChangeRes : NSObject <WXOnBLECharacteristicValueChangeRes>
@end



@protocol WXOnBLEConnectionStateChangeInfo <NSObject>
@property (nonatomic, copy) NSString * deviceId;
@property (nonatomic, assign) BOOL connected;
@end

@interface WXOnBLEConnectionStateChangeRes : NSObject <WXBluetoothRes,WXOnBLEConnectionStateChangeInfo>
@end


typedef void (^WXOnBLECharacteristicValueChang)(id<WXOnBLECharacteristicValueChangeRes>);
typedef void (^WXOnBLEConnectionStateChange)(id<WXBluetoothRes,WXOnBLEConnectionStateChangeInfo>);

@interface WX (WXBLE) <CBPeripheralDelegate>

@property (nonatomic, strong) WXOnBLECharacteristicValueChang onBLECharacteristicValueChange;
@property (nonatomic, strong) WXOnBLEConnectionStateChange onBLEConnectionStateChange;

-(void)createBLEConnection:(id<WXBluetoothObject, WXCreateBLEConnectionInfo>) object;
-(void)closeBLEConnection:(id<WXBluetoothObject, WXGetBLEConnectionInfo>) object;

-(void)getBLEDeviceServices:(id<WXBluetoothObject, WXGetBLEConnectionInfo>) object;
-(void)getBLEDeviceCharacteristics:(id<WXBluetoothObject, WXBGetLEDeviceCharacteristicsInfo>) object;

-(void)notifyBLECharacteristicValueChange:(id<WXBluetoothObject, WXNotifyBLECharacteristicValueChangeInfo>) object;
@end


typedef BOOL(^FatureFunc) (id objectA, id objectB);
@interface NSArray (WXBLE)
-(id)objectByFeature:(id)objectA func:(FatureFunc)func;
@end


