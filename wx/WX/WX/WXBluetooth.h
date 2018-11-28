//
//  WXBluetooth.h
//  WX
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//  传统蓝牙 bluetooth 2.0


#import <WX/WX.h>
#import <CoreBluetooth/CoreBluetooth.h>

/*
 err type
 0    ok    正常
 10000    not init              未初始化蓝牙适配器
 10001    not available         当前蓝牙适配器不可用
 10002    no device             没有找到指定设备
 10003    connection fail       连接失败
 10004    no service            没有找到指定服务
 10005    no characteristic     没有找到指定特征值
 10006    no connection         当前连接已断开
 10007    property not support  当前特征值不支持此操作
 10008    system error          其余所有系统上报的异常
 10009    system not support    Android 系统特有，系统版本低于 4.3 不支持 BLE
 */

@protocol WXBluetoothRes <NSObject>
@property(nonatomic, copy) NSString * errMsg;
@end

@interface WXBOpenBluetoothAdapterRes : NSObject <WXBluetoothRes>
@property (nonatomic, assign) int state;
@property (nonatomic, assign) int errCode;
-(instancetype)initWithErrMsg:(NSString *)msg state:(int) s errCode:(int) ecode;
@end

@interface WXCloseBluetoothAdapterRes : NSObject <WXBluetoothRes>
-(instancetype)initWithErrMsg:(NSString *)msg;
@end

@interface WXStartBluetoothDevicesDiscoveryRes : NSObject <WXBluetoothRes>
@property (nonatomic, assign) int errCode;
@property (nonatomic, assign) BOOL isDiscovering;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode isDiscovering:(BOOL) isDiscovering;
@end

@interface WXStopBluetoothDevicesDiscoveryRes : NSObject <WXBluetoothRes>
@property (nonatomic, assign) int errCode;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode;
@end


@protocol WXOnBluetoothDeviceFoundPeripheral <NSObject>

@property (nonatomic, copy) NSString * name;                              //蓝牙设备名称，某些设备可能没有
@property (nonatomic, copy) NSString * deviceId;                          //用于区分设备的 id
@property (nonatomic, copy) NSNumber * RSSI;                              //当前蓝牙设备的信号强度
@property (nonatomic, copy) NSData * advertisData;                        //当前蓝牙设备的广播数据段中的 ManufacturerData 数据段
@property (nonatomic, copy) NSArray<NSString *> * advertisServiceUUIDs;   //当前蓝牙设备的广播数据段中的 ServiceUUIDs 数据段
@property (nonatomic, copy) NSString * localName;                         //当前蓝牙设备的广播数据段中的 LocalName 数据段
@property (nonatomic, copy) NSDictionary * serviceData;                   //当前蓝牙设备的广播数据段中的 ServiceData 数据段

-(instancetype) initWithDiscoverPeripheral:(CBPeripheral *) peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
@end

@protocol WXOnBluetoothDeviceFoundRes <NSObject>

@property (nonatomic, copy) NSArray<id<WXOnBluetoothDeviceFoundPeripheral>> * devices;

@end

@interface WXOnBluetoothDeviceFoundPeripheral : NSObject <WXOnBluetoothDeviceFoundPeripheral>

@end

@interface WXOnBluetoothDeviceFoundRes : NSObject <WXOnBluetoothDeviceFoundRes>
-(instancetype)initWithDevices:(NSArray<id<WXOnBluetoothDeviceFoundPeripheral>> *)devices;
@end

typedef void (^WXBluetoothObjectSuccess) (id<WXBluetoothRes> res);
typedef void (^WXBluetoothObjectFail) (id<WXBluetoothRes> res);
typedef void (^WXBluetoothObjectComplete) (id<WXBluetoothRes> res);

@protocol WXBluetoothObject <NSObject>
@property (nonatomic, strong) WXBluetoothObjectSuccess success;
@property (nonatomic, strong) WXBluetoothObjectFail fail;
@property (nonatomic, strong) WXBluetoothObjectComplete complete;
@end

@protocol WXBluetoothDiscoverObject <NSObject>
@property (nonatomic, copy) NSArray<NSString*> * services;
@property (nonatomic, assign) BOOL allowDuplicatesKey;
@property (nonatomic, assign) long interval;
@end

@interface WXBOpenBluetoothAdapterObject : NSObject <WXBluetoothObject>

@end

@interface WXCloseBluetoothAdapterObject : NSObject <WXBluetoothObject>

@end

@interface WXStartBluetoothDevicesDiscoveryObject : NSObject <WXBluetoothObject, WXBluetoothDiscoverObject>

@end

@interface WXStopBluetoothDevicesDiscoveryObject : NSObject <WXBluetoothObject>

@end


typedef void (^WXOnBluetoothDeviceFound)(id<WXOnBluetoothDeviceFoundRes> res);

@interface WX (WXBluetooth) <CBCentralManagerDelegate>

@property (nonatomic, strong) WXBOpenBluetoothAdapterObject * openBluetoothAdapterObject;
@property (nonatomic, strong) WXStartBluetoothDevicesDiscoveryObject * sartBluetoothDevicesDiscoveryObject;
@property (nonatomic, strong) NSNumber * starScanTime;
@property (nonatomic, strong, readonly) NSMutableArray<WXOnBluetoothDeviceFoundPeripheral *> * peripherAarray;
@property (nonatomic, strong) WXOnBluetoothDeviceFound onBluetoothDeviceFound;


-(void)openBluetoothAdapter:(id<WXBluetoothObject>) object;
-(void)closeBluetoothAdapter:(id<WXBluetoothObject>) object;

-(void)startBluetoothDevicesDiscovery:(id<WXBluetoothObject, WXBluetoothDiscoverObject>) object;
-(void)stopBluetoothDevicesDiscovery:(id<WXBluetoothObject>) object;

@end


