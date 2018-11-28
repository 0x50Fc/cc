//
//  WXBluetooth.m
//  WX
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXBluetooth.h"

#define CentralManagerKey "CentralManagerKey"
#define OpenBluetoothAdapterObjectKey "OpenBluetoothAdapterObjectKey"
#define StartBluetoothDevicesDiscoveryObjectKey "StartBluetoothDevicesDiscoveryObjectKey"
#define StarScanTimeKey "StarScanTimeKey"
#define PeripherAarrayKey "PeripherAarrayKey"
#define OnBluetoothDeviceFoundKey "OnBluetoothDeviceFoundKey"

@implementation WXBOpenBluetoothAdapterRes
@synthesize state = _state;
@synthesize errCode = _errCode;
@synthesize errMsg = _errMsg;
-(instancetype)initWithErrMsg:(NSString *)msg state:(int) s errCode:(int) ecode{
    if (self = [super init]) {
        self.errMsg = msg;
        self.state = s;
        self.errCode = ecode;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errCode:%d, errMsg:%@, state: %d}",self.errCode,self.errMsg, self.state];
}
@end

@implementation WXCloseBluetoothAdapterRes
@synthesize errMsg = _errMsg;
-(instancetype)initWithErrMsg:(NSString *)msg{
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@}",self.errMsg];
}
@end

@implementation WXStartBluetoothDevicesDiscoveryRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
@synthesize isDiscovering = _isDiscovering;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode isDiscovering:(BOOL) isDiscovering{
    if (self = [super init]) {
        self.errCode = errCode;
        self.errMsg = errMsg;
        self.isDiscovering = isDiscovering;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errCode:%d, errMsg:%@, isDiscovering:%d}",self.errCode,self.errMsg,self.isDiscovering];
}
@end

@implementation WXStopBluetoothDevicesDiscoveryRes
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
    return [NSString stringWithFormat:@"{errCode:%d, errMsg:%@}", self.errCode,self.errMsg];
}

@end


@implementation WXOnBluetoothDeviceFoundPeripheral
@synthesize name = _name;
@synthesize deviceId = _deviceId;
@synthesize RSSI = _RSSI;
@synthesize advertisData = _advertisData;
@synthesize advertisServiceUUIDs = _advertisServiceUUIDs;
@synthesize localName = _localName;
@synthesize serviceData = _serviceData;

-(instancetype) initWithDiscoverPeripheral:(CBPeripheral *) peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if (self = [super init]) {
        self.name = peripheral.name;
        self.deviceId = peripheral.identifier.UUIDString;
        self.RSSI = RSSI;
        self.advertisData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        self.advertisServiceUUIDs = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
        self.localName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
        self.serviceData = [advertisementData objectForKey:@"kCBAdvDataServiceData"];
    }
    return self;
}
-(NSString *)description{
    NSString * str = @"{\
    name:%@,                   \n\
    deviceId:%@                \n\
    RSSI:%@                    \n\
    advertisData:%@            \n\
    advertisServiceUUIDs:%@    \n\
    localName:%@               \n\
    serviceData:%@             \n\
}";
    return [NSString stringWithFormat:str,self.name,self.deviceId,self.RSSI,self.advertisData,self.advertisServiceUUIDs,self.localName,self.serviceData];
}
@end

@implementation WXOnBluetoothDeviceFoundRes
@synthesize devices = _devices;
-(instancetype)initWithDevices:(NSArray<id<WXOnBluetoothDeviceFoundPeripheral>> *)devices{
    if (self = [super init]) {
        self.devices = devices;
    }
    return self;
}
-(NSString *)description{
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendString:@"(\n"];
    for (int i = 0 ; i < self.devices.count; i++) {
        WXOnBluetoothDeviceFoundPeripheral * device = [self.devices objectAtIndex:i];
        [str appendString: [NSString stringWithFormat:@"%@ ,\n", device]];
    }
    [str appendString:@")"];
    return str;
}
@end


@implementation WXBOpenBluetoothAdapterObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

@implementation WXCloseBluetoothAdapterObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

@implementation WXStartBluetoothDevicesDiscoveryObject
@synthesize services = _services;
@synthesize allowDuplicatesKey = _allowDuplicatesKey;
@synthesize interval = _interval;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

@implementation WXStopBluetoothDevicesDiscoveryObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

static CBCentralManager * _centralManager = nil;

@implementation WX (WXBluetooth)

-(WXBOpenBluetoothAdapterObject *)openBluetoothAdapterObject{
    return objc_getAssociatedObject(self,  OpenBluetoothAdapterObjectKey);
}
-(void)setOpenBluetoothAdapterObject:(WXBOpenBluetoothAdapterObject *)openBluetoothAdapterObject{
    objc_setAssociatedObject(self, OpenBluetoothAdapterObjectKey, openBluetoothAdapterObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSNumber *)starScanTime{
    return objc_getAssociatedObject(self, StarScanTimeKey);
}
-(void)setStarScanTime:(NSNumber *)starScanTime{
    objc_setAssociatedObject(self, StarScanTimeKey, starScanTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WXStartBluetoothDevicesDiscoveryObject *)sartBluetoothDevicesDiscoveryObject{
    return objc_getAssociatedObject(self,  StartBluetoothDevicesDiscoveryObjectKey);
}
-(void)setSartBluetoothDevicesDiscoveryObject:(WXStartBluetoothDevicesDiscoveryObject *)sartBluetoothDevicesDiscoveryObject{
    objc_setAssociatedObject(self, StartBluetoothDevicesDiscoveryObjectKey, sartBluetoothDevicesDiscoveryObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableArray<WXOnBluetoothDeviceFoundPeripheral *> *)peripherAarray{
    NSMutableArray * _peripherAarray = objc_getAssociatedObject(self, PeripherAarrayKey);
    if (_peripherAarray == nil) {
        _peripherAarray = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, PeripherAarrayKey, _peripherAarray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _peripherAarray;
}

-(WXOnBluetoothDeviceFound)onBluetoothDeviceFound{
    return objc_getAssociatedObject(self,  OnBluetoothDeviceFoundKey);
}
-(void)setOnBluetoothDeviceFound:(WXOnBluetoothDeviceFound)onBluetoothDeviceFound{
    objc_setAssociatedObject(self, OnBluetoothDeviceFoundKey, onBluetoothDeviceFound, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)openBluetoothAdapter:(id<WXBluetoothObject>) object {
    self.openBluetoothAdapterObject = object;
    if (_centralManager == nil) {
        _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
}

-(void)closeBluetoothAdapter:(id<WXBluetoothObject>) object{
    _centralManager = nil;
    self.openBluetoothAdapterObject = nil;
    WXCloseBluetoothAdapterRes * res = [[WXCloseBluetoothAdapterRes alloc] initWithErrMsg:@"closeBluetoothAdapter:fail"];
    if (object != nil) {
        object.success(res);
        object.complete(res);
    }
}

-(void)startBluetoothDevicesDiscovery:(id<WXBluetoothObject, WXBluetoothDiscoverObject>) object{
    
    if (_centralManager == nil) {
        
        WXStartBluetoothDevicesDiscoveryRes * res = [[WXStartBluetoothDevicesDiscoveryRes alloc] initWithErrMsg:@"startBluetoothDevicesDiscovery:fail need openBluetoothAdapter" ErrCode:10000 isDiscovering:NO];
        object.fail(res);
        object.complete(res);
        
    }else {
        
        if (_centralManager.state == CBCentralManagerStatePoweredOn) {
            
            self.sartBluetoothDevicesDiscoveryObject = object;
            self.starScanTime = [NSNumber numberWithInteger:([[NSDate date] timeIntervalSince1970] * 1000)];
            NSMutableArray * services = nil;
            if (object.services != nil) {
                services = [[NSMutableArray alloc] init];
                for (int i = 0 ; i < object.services.count; i++) {
                    [services addObject:[CBUUID UUIDWithString:[object.services objectAtIndex:i]]];
                }
            }
            NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
            [options setObject:[NSNumber numberWithBool:object.allowDuplicatesKey] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
            [_centralManager scanForPeripheralsWithServices:services options:options];

            WXStartBluetoothDevicesDiscoveryRes * res = [[WXStartBluetoothDevicesDiscoveryRes alloc] initWithErrMsg:@"startBluetoothDevicesDiscovery:ok" ErrCode:0 isDiscovering:YES];
            object.success(res);
            object.complete(res);
            
        }else {
            
            WXStartBluetoothDevicesDiscoveryRes * res = [[WXStartBluetoothDevicesDiscoveryRes alloc] initWithErrMsg:[NSString stringWithFormat:@"startBluetoothDevicesDiscovery:fail openBluetoothAdapter state = %ld", _centralManager.state] ErrCode:10000 isDiscovering:NO];
            object.fail(res);
            object.complete(res);
            
        }
    }
    
}

-(void)stopBluetoothDevicesDiscovery:(id<WXBluetoothObject>) object {
    
    if (_centralManager == nil || _centralManager.state != CBCentralManagerStatePoweredOn) {

        WXStopBluetoothDevicesDiscoveryRes * res = [[WXStopBluetoothDevicesDiscoveryRes alloc] initWithErrMsg:@"stopBluetoothDevicesDiscovery:fail ble adapter hans't been opened or ble is unavailable." ErrCode:10000];
        object.fail(res);
        object.complete(res);
        
    }else {
        
        [_centralManager stopScan];
        self.sartBluetoothDevicesDiscoveryObject = nil;
        WXStopBluetoothDevicesDiscoveryRes * res = [[WXStopBluetoothDevicesDiscoveryRes alloc] initWithErrMsg:@"stopBluetoothDevicesDiscovery:ok" ErrCode:0];
        object.success(res);
        object.complete(res);
        
    }
    
}

#pragma mark -- CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState");
    WXBOpenBluetoothAdapterRes * res = [[WXBOpenBluetoothAdapterRes alloc] init];
    res.state = central.state;

    switch (central.state) {
        case 0:
            res.errCode = 10008;
            res.errMsg = @"openBluetoothAdapter:fail open CBManagerStateUnknown 设备类型未知";
            break;
        case 1:
            res.errCode = 10008;
            res.errMsg = @"openBluetoothAdapter:fail open CBManagerStateResetting 设备初始化中";
            break;
        case 2:
            res.errCode = 10008;
            res.errMsg = @"openBluetoothAdapter:fail open CBManagerStateUnsupported 不支持蓝牙";
            break;
        case 3:
            res.errCode = 10008;
            res.errMsg = @"openBluetoothAdapter:fail open CBManagerStateUnauthorized 设备未授权";
            break;
        case 4:
            res.errCode = 10001;
            res.errMsg = @"openBluetoothAdapter:fail open CBManagerStatePoweredOff 蓝牙未开启";
            break;
        case 5:
            res.errCode = 0;
            res.errMsg = @"openBluetoothAdapter: ok CBCentralManagerStatePoweredOn 蓝牙已经开始";
            break;
        default:
            break;
    }

    if (self.openBluetoothAdapterObject) {
        if (res.errCode == 0) {
            self.openBluetoothAdapterObject.success(res);
        }else {
            self.openBluetoothAdapterObject.fail(res);
        }
        self.openBluetoothAdapterObject.complete(res);
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    WXOnBluetoothDeviceFoundPeripheral * p = [[WXOnBluetoothDeviceFoundPeripheral alloc] initWithDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    
    if (self.sartBluetoothDevicesDiscoveryObject) {
        
        if (self.sartBluetoothDevicesDiscoveryObject.interval == 0) {
            
            [self.peripherAarray addObject:p];
            self.onBluetoothDeviceFound([[WXOnBluetoothDeviceFoundRes alloc] initWithDevices:self.peripherAarray]);
            [self.peripherAarray removeAllObjects];
            
        }else {
            
            [self.peripherAarray addObject:p];
            long nowTime = [[NSDate date] timeIntervalSince1970] * 1000;
            if (nowTime - [self.starScanTime longLongValue] > self.sartBluetoothDevicesDiscoveryObject.interval) {
                self.onBluetoothDeviceFound([[WXOnBluetoothDeviceFoundRes alloc] initWithDevices:self.peripherAarray]);
                [self.peripherAarray removeAllObjects];
                self.starScanTime = [NSNumber numberWithLong:nowTime];
            }
        }
    }
}

@end
