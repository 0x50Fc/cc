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
#define DiscoveredPeripherArrayKey "DiscoveredPeripherArrayKey"
#define OnBluetoothDeviceFoundKey "OnBluetoothDeviceFoundKey"
#define OnBluetoothAdapterStateChangeKey "OnBluetoothAdapterStateChangeKey"
#define PeripherArrayKey "PeripherArrayKey"

@implementation WXGetBluetoothAdapterStateRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
@synthesize discovering = _discovering;
@synthesize available = _available;
-(instancetype)initWithErrMsg:(NSString *)msg errCode:(int)code discovering:(BOOL) discovering available:(BOOL) available{
    if (self = [super init]) {
        self.errMsg = msg;
        self.errCode = code;
        self.discovering = discovering;
        self.available = available;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errCode:%d, errMsg:%@, available:%d, discovering:%d}",self.errCode, self.errMsg, self.available, self.discovering];
}
@end

@implementation WXOnBluetoothAdapterStateChangeRes
@synthesize available = _available;
@synthesize discovering = _discovering;
-(instancetype)initWithAvailable:(BOOL)available discovering:(BOOL)discovering{
    if (self = [super init]) {
        self.available = available;
        self.discovering = discovering;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{available:%d, discovering:%d}", self.available, self.discovering];
}
@end

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
@synthesize errCode;
@synthesize errMsg = _errMsg;
-(instancetype)initWithErrMsg:(NSString *)msg errCode:(int)errCode{
    if (self = [super init]) {
        self.errMsg = msg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d}",self.errMsg,self.errCode];
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

@implementation WXGetBluetoothDevicesRes
@synthesize devices = _devices;
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode devices:(NSArray<id<WXOnBluetoothDeviceFoundPeripheral>> *) devices{
    if (self = [super init]) {
        self.errMsg = errMsg;
        self.errCode = errCode;
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
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d, devices:%@}", self.errMsg, self.errCode, str];
}
@end

@implementation WXConnectedBluetoothDevices
@synthesize name = _name;
@synthesize deviceId = _deviceId;
-(instancetype)initWithCBPeripheral:(CBPeripheral *)peripheral {
    if (self = [super init]) {
        self.name = peripheral.name;
        self.deviceId = peripheral.identifier.UUIDString;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{name:%@, deviceId:%@}", self.name, self.deviceId];
}
@end

@implementation WXGetConnectedBluetoothDevicesRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
@synthesize devices = _devices;
-(instancetype)initWithDevices:(NSArray *)devices errMsg:(NSString *)errMsg errCode:(int)errCode{
    if (self = [super init]) {
        self.devices = devices;
        self.errMsg = errMsg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendString:@"(\n"];
    for (WXConnectedBluetoothDevices * device in self.devices) {
        [str appendString:[NSString stringWithFormat:@"%@ ,\n,", device]];
    }
    [str appendString:@")"];
    return str;
}
@end



@implementation WXGetBluetoothAdapterStateObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
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

@implementation WXGetBluetoothDevicesObject
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

@implementation WXGetConnectedBluetoothDevices
@synthesize services = _services;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end

@interface WX()
@property (nonatomic, strong) WXBOpenBluetoothAdapterObject * openBluetoothAdapterObject;
@property (nonatomic, strong) WXStartBluetoothDevicesDiscoveryObject * sartBluetoothDevicesDiscoveryObject;
@property (nonatomic, strong) NSNumber * starScanTime;
@property (nonatomic, strong, readonly) NSMutableArray<WXOnBluetoothDeviceFoundPeripheral *> * discoveredPeripherArray;
@property (nonatomic, strong, readonly) NSMutableArray<WXOnBluetoothDeviceFoundPeripheral *> * peripherArray;
@end

@implementation WX (WXBluetooth)

#pragma mark --  property

-(CBCentralManager*)centralManager{
    return objc_getAssociatedObject(self,  CentralManagerKey);
}
-(void)setCentralManager:(CBCentralManager *)centralManager{
    objc_setAssociatedObject(self, CentralManagerKey, centralManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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

-(NSMutableArray<WXOnBluetoothDeviceFoundPeripheral *> *)discoveredPeripherArray{
    NSMutableArray * _discoveredPeripherArray = objc_getAssociatedObject(self, DiscoveredPeripherArrayKey);
    if (_discoveredPeripherArray == nil) {
        _discoveredPeripherArray = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, DiscoveredPeripherArrayKey, _discoveredPeripherArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _discoveredPeripherArray;
}

-(NSMutableArray<WXOnBluetoothDeviceFoundPeripheral *> *)peripherArray{
    NSMutableArray * _peripherArray = objc_getAssociatedObject(self, PeripherArrayKey);
    if (_peripherArray == nil) {
        _peripherArray = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, PeripherArrayKey, _peripherArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _peripherArray;
}

-(WXOnBluetoothDeviceFound)onBluetoothDeviceFound{
    return objc_getAssociatedObject(self,  OnBluetoothDeviceFoundKey);
}
-(void)setOnBluetoothDeviceFound:(WXOnBluetoothDeviceFound)onBluetoothDeviceFound{
    objc_setAssociatedObject(self, OnBluetoothDeviceFoundKey, onBluetoothDeviceFound, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WXOnBluetoothAdapterStateChange)onBluetoothAdapterStateChange{
    return objc_getAssociatedObject(self,  OnBluetoothAdapterStateChangeKey);
}
-(void)setOnBluetoothAdapterStateChange:(WXOnBluetoothAdapterStateChange)onBluetoothAdapterStateChange{
    objc_setAssociatedObject(self, OnBluetoothAdapterStateChangeKey, onBluetoothAdapterStateChange, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark --  property end

-(void)getBluetoothAdapterState:(id<WXBluetoothObject>) object{
    
    if (self.centralManager == nil) {
        
        WXGetBluetoothAdapterStateRes * res = [[WXGetBluetoothAdapterStateRes alloc] initWithErrMsg: @"getBluetoothAdapterState:fail ble adapter need open first. need open bluetooth adapter" errCode:10000 discovering:NO available:NO];
        object.fail(res);
        object.complete(res);
        
    }else {
        
        if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
            
            WXGetBluetoothAdapterStateRes * res = [[WXGetBluetoothAdapterStateRes alloc] initWithErrMsg: @"getBluetoothAdapterState:ok" errCode:0 discovering:self.centralManager.isScanning available:YES];
            object.success(res);
            object.complete(res);
            
        }else {
            
            WXGetBluetoothAdapterStateRes * res = [[WXGetBluetoothAdapterStateRes alloc] initWithErrMsg: @"getBluetoothAdapterState:fail ble adapter need open first. bluetooth state err" errCode:10008 discovering:NO available:NO];
            object.fail(res);
            object.complete(res);
            
        }
    }
}

-(void)openBluetoothAdapter:(id<WXBluetoothObject>) object {
    self.openBluetoothAdapterObject = object;
    if (self.centralManager == nil) {
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
}

-(void)closeBluetoothAdapter:(id<WXBluetoothObject>) object{
    self.centralManager = nil;
    self.openBluetoothAdapterObject = nil;
    [self.peripherArray removeAllObjects];
    WXCloseBluetoothAdapterRes * res = [[WXCloseBluetoothAdapterRes alloc] initWithErrMsg:@"closeBluetoothAdapter:fail" errCode:0];
    if (object != nil) {
        object.success(res);
        object.complete(res);
    }
}

-(void)startBluetoothDevicesDiscovery:(id<WXBluetoothObject, WXBluetoothDiscoverObject>) object{
    
    if (self.centralManager == nil) {
        
        WXStartBluetoothDevicesDiscoveryRes * res = [[WXStartBluetoothDevicesDiscoveryRes alloc] initWithErrMsg:@"startBluetoothDevicesDiscovery:fail need openBluetoothAdapter" ErrCode:10000 isDiscovering:NO];
        object.fail(res);
        object.complete(res);
        
    }else {
        
        if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
            
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
            [self.centralManager scanForPeripheralsWithServices:services options:options];

            WXStartBluetoothDevicesDiscoveryRes * res = [[WXStartBluetoothDevicesDiscoveryRes alloc] initWithErrMsg:@"startBluetoothDevicesDiscovery:ok" ErrCode:0 isDiscovering:YES];
            object.success(res);
            object.complete(res);
            
        }else {
            
            WXStartBluetoothDevicesDiscoveryRes * res = [[WXStartBluetoothDevicesDiscoveryRes alloc] initWithErrMsg:[NSString stringWithFormat:@"startBluetoothDevicesDiscovery:fail openBluetoothAdapter state = %ld", (long)self.centralManager.state] ErrCode:10000 isDiscovering:NO];
            object.fail(res);
            object.complete(res);
            
        }
    }
    
}

-(void)stopBluetoothDevicesDiscovery:(id<WXBluetoothObject>) object {
    
    if (self.centralManager == nil || self.centralManager.state != CBCentralManagerStatePoweredOn) {

        WXStopBluetoothDevicesDiscoveryRes * res = [[WXStopBluetoothDevicesDiscoveryRes alloc] initWithErrMsg:@"stopBluetoothDevicesDiscovery:fail ble adapter hans't been opened or ble is unavailable." ErrCode:10000];
        object.fail(res);
        object.complete(res);
        
    }else {
        
        [self.centralManager stopScan];
        self.sartBluetoothDevicesDiscoveryObject = nil;
        WXStopBluetoothDevicesDiscoveryRes * res = [[WXStopBluetoothDevicesDiscoveryRes alloc] initWithErrMsg:@"stopBluetoothDevicesDiscovery:ok" ErrCode:0];
        object.success(res);
        object.complete(res);
        
    }
    
}

-(void)getBluetoothDevices:(id<WXBluetoothObject>) object{
    
    if (self.centralManager == nil) {
        
        WXGetBluetoothDevicesRes * res = [[WXGetBluetoothDevicesRes alloc] initWithErrMsg:@"getBluetoothDevices:fail ble adapter hans't been opened or ble is unavailable." ErrCode:10000 devices:self.peripherArray];
        object.success(res);
        object.complete(res);
        
    }else {
        
        WXGetBluetoothDevicesRes * res = [[WXGetBluetoothDevicesRes alloc] initWithErrMsg:@"getBluetoothDevices:ok" ErrCode:0 devices:self.peripherArray];
        object.fail(res);
        object.complete(res);
    }
    
}

-(void)getConnectedBluetoothDevices:(id<WXBluetoothObject, WXGetConnectedBluetoothDevicesIdentifiers>) object{
    
    if (self.centralManager == nil) {
        
        WXGetConnectedBluetoothDevicesRes * res = [[WXGetConnectedBluetoothDevicesRes alloc] initWithDevices:@[] errMsg:@"getConnectedBluetoothDevices:fail ble adapter hans't been opened or ble is unavailable." errCode:10000];
        object.fail(res);
        object.complete(res);
        
    }else {

        NSMutableArray<CBUUID *> * arr = [[NSMutableArray alloc]init];
        for (NSString * identifier in object.services) {
            [arr addObject:[CBUUID UUIDWithString:identifier]];
        }
        NSArray<CBPeripheral *> * peripherals = [self.centralManager retrieveConnectedPeripheralsWithServices:arr];
        NSMutableArray<WXConnectedBluetoothDevices *> * devices = [[NSMutableArray alloc]init];
        for (CBPeripheral * peripheral in peripherals) {
            [devices addObject:[[WXConnectedBluetoothDevices alloc] initWithCBPeripheral:peripheral]];
        }
        WXGetConnectedBluetoothDevicesRes * res = [[WXGetConnectedBluetoothDevicesRes alloc] initWithDevices:devices errMsg:@"getConnectedBluetoothDevices:ok" errCode:0];
        object.success(res);
        object.complete(res);
        
    }
}

#pragma mark -- CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    BOOL available = NO;
    BOOL discovering = NO;
    if (central) {
        BOOL available = NO;
        discovering = central.isScanning;
        if (central.state == CBCentralManagerStatePoweredOn) {
            available = YES;
        }
    }
    if (self.onBluetoothAdapterStateChange) {
        self.onBluetoothAdapterStateChange([[WXOnBluetoothAdapterStateChangeRes alloc] initWithAvailable:available discovering:discovering]);
    }
    
    
    NSLog(@"centralManagerDidUpdateState");
    WXBOpenBluetoothAdapterRes * res = [[WXBOpenBluetoothAdapterRes alloc] init];
    res.state = central.state;

    switch (central.state) {
        case CBCentralManagerStateUnknown:
            res.errCode = 10008;
            res.errMsg = @"openBluetoothAdapter:fail open CBManagerStateUnknown 设备类型未知";
            break;
        case CBCentralManagerStateResetting:
            res.errCode = 10008;
            res.errMsg = @"openBluetoothAdapter:fail open CBManagerStateResetting 设备初始化中";
            break;
        case CBCentralManagerStateUnsupported:
            res.errCode = 10008;
            res.errMsg = @"openBluetoothAdapter:fail open CBManagerStateUnsupported 不支持蓝牙";
            break;
        case CBCentralManagerStateUnauthorized:
            res.errCode = 10008;
            res.errMsg = @"openBluetoothAdapter:fail open CBManagerStateUnauthorized 设备未授权";
            break;
        case CBCentralManagerStatePoweredOff:
            res.errCode = 10001;
            res.errMsg = @"openBluetoothAdapter:fail open CBManagerStatePoweredOff 蓝牙未开启";
            break;
        case CBCentralManagerStatePoweredOn:
            res.errCode = 0;
            res.errMsg = @"openBluetoothAdapter: ok CBCentralManagerStatePoweredOn 蓝牙已经开始";
            break;
        default:
            break;
    }

    if (self.openBluetoothAdapterObject) {
//        self.openBluetoothAdapterObject = nil;
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

    BOOL saved = [self.peripherArray alreadySaveObject:p method:^BOOL(id objA, id objB) {
        WXOnBluetoothDeviceFoundPeripheral * pa = (WXOnBluetoothDeviceFoundPeripheral *)objA;
        WXOnBluetoothDeviceFoundPeripheral * pb = (WXOnBluetoothDeviceFoundPeripheral *)objB;
        if ([pa.deviceId isEqualToString:pb.deviceId]) {
            return YES;
        }
        return NO;
    }];
    if (!saved) {
        [self.peripherArray addObject:p];
    }

    if (self.sartBluetoothDevicesDiscoveryObject) {
        
        if (self.sartBluetoothDevicesDiscoveryObject.interval == 0) {
            
            [self.discoveredPeripherArray addObject:p];
            self.onBluetoothDeviceFound([[WXOnBluetoothDeviceFoundRes alloc] initWithDevices:self.discoveredPeripherArray]);
            [self.discoveredPeripherArray removeAllObjects];
            
        }else {
            
            [self.discoveredPeripherArray addObject:p];
            long nowTime = [[NSDate date] timeIntervalSince1970] * 1000;
            if (nowTime - [self.starScanTime longLongValue] > self.sartBluetoothDevicesDiscoveryObject.interval) {
                self.onBluetoothDeviceFound([[WXOnBluetoothDeviceFoundRes alloc] initWithDevices:self.discoveredPeripherArray]);
                [self.discoveredPeripherArray removeAllObjects];
                self.starScanTime = [NSNumber numberWithLong:nowTime];
            }
        }
    }
}


@end


@implementation NSMutableArray (WXBOpenBluetooth)
-(BOOL)alreadySaveObject:(id)object method:(ArrayCompareFunc)func{
    for (id a in self) {
        if (func(object, a)) {
            return YES;
        }
    }
    return NO;
}
@end
