//
//  WXBLE.m
//  WX
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXBLE.h"

#define ConnectedPeripheralsKey "ConnectedPeripheralsKey"
#define CreateBLEConnectionObjectKey "CreateBLEConnectionObjectKey"
#define CloseBLEConnectionObjectKey "CreateBLEConnectionObjectKey"
#define GetBLEDeviceServicesKey "GetBLEDeviceServicesKey"
#define GetBLEDeviceCharacteristicsKey "GetBLEDeviceCharacteristicsKey"
#define NotifyBLECharacteristicValueChangeObjectKey "NotifyBLECharacteristicValueChangeObjectKey"
#define OnBLECharacteristicValueChangeKey "OnBLECharacteristicValueChangeKey"
#define OnBLEConnectionStateChangeKey "OnBLEConnectionStateChangeKey"
#define ReadBLECharacteristicValueObjectKey "ReadBLECharacteristicValueObjectKey"
#define WriteBLECharacteristicValueObjectKey "WriteBLECharacteristicValueObjectKey"

@implementation WXCreateBLEConnectionRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode {
    if (self = [super init]) {
        self.errMsg = errMsg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d}", self.errMsg, self.errCode];
}
@end

@implementation WXCreateBLEConnectionObject
@synthesize deviceId = _deviceId;
@synthesize timeout = _timeout;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end


@implementation WXCloseBLEConnectionRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode {
    if (self = [super init]) {
        self.errMsg = errMsg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d}", self.errMsg, self.errCode];
}
@end

@implementation WXCloseBLEConnectionObject
@synthesize deviceId = _deviceId;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end


@implementation WXBLEDeviceService
@synthesize uuid = _uuid;
@synthesize isPrimary = _isPrimary;
-(instancetype)initWithCBService:(CBService *)service{
    if (self = [super init]) {
        self.uuid = service.UUID.UUIDString;
        self.isPrimary = service.isPrimary;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{uuid:%@, isPeimary:%@}",self.uuid,[NSNumber numberWithBool:self.isPrimary]];
}
@end

@implementation WXGetBLEDeviceServicesRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
@synthesize deviceId = _deviceId;
@synthesize services = _services;
-(instancetype)initWithErrMsg:(NSString *)errMsg errCode:(int)errCode peripheral:(CBPeripheral *)peripheral{
    if (self = [super init]) {
        self.errMsg = errMsg;
        self.errCode = errCode;
        NSMutableArray * array = [[NSMutableArray alloc] init];
        if (peripheral) {
            
            self.deviceId = peripheral.identifier.UUIDString;
            for (CBService * service in peripheral.services) {
                [array addObject:[[WXBLEDeviceService alloc] initWithCBService:service]];
                self.services = array;
            }
        }
    }
    return self;
}
-(NSString *)description{
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendString:@"(\n"];
    for (int i = 0 ; i < self.services.count; i++) {
        [str appendString:[NSString stringWithFormat:@"%@ ,\n", [self.services objectAtIndex:i]]];
    }
    [str appendString:@")"];
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d, deviceId:%@, services:%@}", self.errMsg, self.errCode, self.deviceId, str];
}
@end

@implementation WXGetBLEDeviceServicesObject
@synthesize deviceId = _deviceId;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end


@implementation WXBLEDeviceCharacteristicPropertie
@synthesize read = _read;
@synthesize write = _write;
@synthesize notify = _notify;
@synthesize indicate = _indicate;
-(instancetype)initWithProperties:(CBCharacteristicProperties)properties{
    if (self = [super init]) {
        self.read = properties & CBCharacteristicPropertyRead ? YES : NO;
        self.write = properties & CBCharacteristicPropertyWrite ? YES : NO;
        self.notify = properties & CBCharacteristicPropertyNotify ? YES : NO;
        self.indicate = properties & CBCharacteristicPropertyIndicate ? YES : NO;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{read:%d, write:%d, notify:%d, indicate:%d}",self.read, self.write, self.notify, self.indicate];
}
@end

@implementation WXBLEDeviceCharacteristic
@synthesize properties = _properties;
@synthesize uuid = _uuid;
-(instancetype)initWithCharacteristic:(CBCharacteristic *)characteristic{
    if (self = [super init]) {
        self.uuid = characteristic.UUID.UUIDString;
        self.properties = [[WXBLEDeviceCharacteristicPropertie alloc] initWithProperties:characteristic.properties];
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{uuid:%@, properties:%@}", self.uuid, self.properties.description];
}
@end

@implementation WXGetBLEDeviceCharacteristicsRes
@synthesize errCode = _errCode;
@synthesize errMsg = _errMsg;
@synthesize characteristics = _characteristics;
-(instancetype)initWithService:(CBService *)service ErrMsg:(NSString *)errMsg ErrCode:(int) errCode{
    if (self = [super init]) {
        if (service == nil) {
            self.characteristics = @[];
        }else {
            NSMutableArray * arr = [[NSMutableArray alloc] init];
            for (CBCharacteristic * characteristic in service.characteristics) {
                [arr addObject:[[WXBLEDeviceCharacteristic alloc] initWithCharacteristic:characteristic]];
            }
            self.characteristics = [arr copy];
        }
    }
    return self;
}
-(NSString *)description{
    NSMutableString * str = [@"(" mutableCopy];
    for (WXBLEDeviceCharacteristic * characteristics in self.characteristics) {
        [str appendString:characteristics.description];
        [str appendString:@","];
    }
    [str appendString:@")"];
    return str;
}
@end

@implementation WXBGetLEDeviceCharacteristicsObject
@synthesize deviceId = _deviceId;;
@synthesize serviceId = _serviceId;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end



@implementation WXNotifyBLECharacteristicValueChangeRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode {
    if (self = [super init]) {
        self.errMsg = errMsg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d}", self.errMsg, self.errCode];
}
@end

@implementation WXNotifyBLECharacteristicValueChangeObject
@synthesize deviceId = _deviceId;;
@synthesize serviceId = _serviceId;;
@synthesize characteristicId = _characteristicId;
@synthesize state = _state;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end



@implementation WXOnBLECharacteristicValueChangeRes
@synthesize deviceId = _deviceId;
@synthesize serviceId = _serviceId;
@synthesize characteristicId = _characteristicId;
@synthesize value = _value;
-(instancetype)initWithPeripheral:(CBPeripheral *)peripheral Characteristic:(CBCharacteristic *)characteristic{
    if (self = [super init]) {
        self.deviceId = peripheral.identifier.UUIDString;
        self.serviceId = characteristic.service.UUID.UUIDString;
        self.characteristicId = characteristic.UUID.UUIDString;
        self.value = characteristic.value;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"deviceId:%@, serviceId:%@, characteristicId:%@, value:%@",self.deviceId,self.serviceId,self.characteristicId,self.value];
}
@end



@implementation WXOnBLEConnectionStateChangeRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
@synthesize deviceId = _deviceId;
@synthesize connected = _connected;
-(instancetype)initWithPeripheral:(CBPeripheral *)peripheral Connected:(BOOL)connected ErrMsg:(NSString *)errMsg ErrCode:(int)errCode{
    if (self = [super init]) {
        self.deviceId = peripheral.identifier.UUIDString;
        self.connected = connected;
        self.errMsg = errMsg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{deviceId:%@, connected:%d, errMsg:%@, errCode:%d}",self.deviceId, self.connected, self.errMsg, self.errCode];
}
@end



@implementation WXReadBLECharacteristicValueRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode {
    if (self = [super init]) {
        self.errMsg = errMsg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d}", self.errMsg, self.errCode];
}
@end

@implementation WXReadBLECharacteristicValueObject
@synthesize deviceId = _deviceId;
@synthesize serviceId = _serviceId;
@synthesize characteristicId = _characteristicId;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end



@implementation WXWriteBLECharacteristicValueRes
@synthesize errMsg = _errMsg;
@synthesize errCode = _errCode;
-(instancetype)initWithErrMsg:(NSString *)errMsg ErrCode:(int)errCode {
    if (self = [super init]) {
        self.errMsg = errMsg;
        self.errCode = errCode;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@, errCode:%d}", self.errMsg, self.errCode];
}
@end

@implementation WXWriteBLECharacteristicValueObject
@synthesize deviceId = _deviceId;
@synthesize serviceId = _serviceId;
@synthesize characteristicId = _characteristicId;
@synthesize value = _value;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@end




@interface WX()

@property (nonatomic, strong, readonly) NSMutableArray<CBPeripheral *> * connectedPeripherals;

@property (nonatomic, strong) WXCreateBLEConnectionObject * createBLEConnectionObject;
@property (nonatomic, strong) WXCloseBLEConnectionObject * closeBLEConnectionObject;
@property (nonatomic, strong) WXGetBLEDeviceServicesObject * getBLEDeviceServicesObject;
@property (nonatomic, strong) WXBGetLEDeviceCharacteristicsObject * getBLEDeviceCharacteristicsObject;
@property (nonatomic, strong) WXNotifyBLECharacteristicValueChangeObject * notifyBLECharacteristicValueChangeObject;
@property (nonatomic, strong) WXReadBLECharacteristicValueObject * readBLECharacteristicValueObject;
@property (nonatomic, strong) WXWriteBLECharacteristicValueObject * writeBLECharacteristicValueObject;

@end

@implementation WX (WXBLE)

-(WXOnBLECharacteristicValueChang)onBLECharacteristicValueChange{
    return objc_getAssociatedObject(self, OnBLECharacteristicValueChangeKey);
}
-(void)setOnBLECharacteristicValueChange:(WXOnBLECharacteristicValueChang)onBLECharacteristicValueChange{
    objc_setAssociatedObject(self, OnBLECharacteristicValueChangeKey, onBLECharacteristicValueChange, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WXOnBLEConnectionStateChange)onBLEConnectionStateChange{
    return objc_getAssociatedObject(self, OnBLEConnectionStateChangeKey);
}
-(void)setOnBLEConnectionStateChange:(WXOnBLEConnectionStateChange)onBLEConnectionStateChange{
    objc_setAssociatedObject(self, OnBLEConnectionStateChangeKey, onBLEConnectionStateChange, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(NSMutableArray<CBPeripheral *> *)connectedPeripherals{
    NSMutableArray<CBPeripheral *> * _connectedPeripherals = objc_getAssociatedObject(self, ConnectedPeripheralsKey);
    if (_connectedPeripherals == nil) {
        _connectedPeripherals = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, ConnectedPeripheralsKey, _connectedPeripherals, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _connectedPeripherals;
}

-(WXCreateBLEConnectionObject *)createBLEConnectionObject{
    return objc_getAssociatedObject(self, CreateBLEConnectionObjectKey);
}
-(void)setCreateBLEConnectionObject:(WXCreateBLEConnectionObject *)createBLEConnectionObject{
    objc_setAssociatedObject(self, CreateBLEConnectionObjectKey, createBLEConnectionObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(WXCloseBLEConnectionObject *)closeBLEConnectionObject{
    return objc_getAssociatedObject(self, CloseBLEConnectionObjectKey);
}
-(void)setCloseBLEConnectionObject:(WXCloseBLEConnectionObject *)closeBLEConnectionObject{
    objc_setAssociatedObject(self, CloseBLEConnectionObjectKey, closeBLEConnectionObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(WXGetBLEDeviceServicesObject *)getBLEDeviceServicesObject{
    return objc_getAssociatedObject(self, GetBLEDeviceServicesKey);
}
-(void)setGetBLEDeviceServicesObject:(WXGetBLEDeviceServicesObject *)getBLEDeviceServicesObject{
    objc_setAssociatedObject(self, GetBLEDeviceServicesKey, getBLEDeviceServicesObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(WXBGetLEDeviceCharacteristicsObject *)getBLEDeviceCharacteristicsObject{
    return objc_getAssociatedObject(self, GetBLEDeviceCharacteristicsKey);
}
-(void)setGetBLEDeviceCharacteristicsObject:(WXBGetLEDeviceCharacteristicsObject *)getBLEDeviceCharacteristicsObject{
    objc_setAssociatedObject(self, GetBLEDeviceCharacteristicsKey, getBLEDeviceCharacteristicsObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(WXNotifyBLECharacteristicValueChangeObject *)notifyBLECharacteristicValueChangeObject{
    return objc_getAssociatedObject(self, NotifyBLECharacteristicValueChangeObjectKey);
}
-(void)setNotifyBLECharacteristicValueChangeObject:(WXNotifyBLECharacteristicValueChangeObject *)notifyBLECharacteristicValueChangeObject{
    objc_setAssociatedObject(self, NotifyBLECharacteristicValueChangeObjectKey, notifyBLECharacteristicValueChangeObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WXReadBLECharacteristicValueObject *)readBLECharacteristicValueObject{
    return objc_getAssociatedObject(self, ReadBLECharacteristicValueObjectKey);
}
-(void)setReadBLECharacteristicValueObject:(WXReadBLECharacteristicValueObject *)readBLECharacteristicValueObject{
    objc_setAssociatedObject(self, ReadBLECharacteristicValueObjectKey, readBLECharacteristicValueObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WXWriteBLECharacteristicValueObject *)writeBLECharacteristicValueObject{
    return objc_getAssociatedObject(self, WriteBLECharacteristicValueObjectKey);
}
-(void)setWriteBLECharacteristicValueObject:(WXWriteBLECharacteristicValueObject *)writeBLECharacteristicValueObject{
    objc_setAssociatedObject(self, WriteBLECharacteristicValueObjectKey, writeBLECharacteristicValueObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CBPeripheral *) findPeripheral:(NSString *)uuid{

    NSArray * arr = [self.centralManager retrievePeripheralsWithIdentifiers:@[[[NSUUID alloc]initWithUUIDString:uuid]]];
    if (arr && arr.count > 0) {
        return arr[0];
    }else{
        return nil;
    }
    
}

-(CBPeripheral *)findConnectedPeripheral:(NSString *)uuid{
    
    CBPeripheral * peripheral = [self  findPeripheral:uuid];
    if (peripheral) {
        BOOL saved = [self.connectedPeripherals alreadySaveObject:peripheral method:^BOOL(id objA, id objB) { return objA == objB ? YES : NO; }];
        if (saved) {
            return peripheral;
        }else {
            return nil;
        }
    }else{
        return nil;
    }
}

-(void)createBLEConnection:(id<WXBluetoothObject, WXCreateBLEConnectionInfo>) object {
    
    if (self.centralManager == nil) {
        
        WXCreateBLEConnectionRes * res = [[WXCreateBLEConnectionRes alloc] initWithErrMsg:@"createBLEConnection:fail createBLEConnection error 10000." ErrCode:1000];
        object.fail(res);
        object.complete(res);
        
    }else{
        
        CBPeripheral * peripheral = [self  findPeripheral:object.deviceId];
        
        if (peripheral) {
            
            BOOL saved = [self.connectedPeripherals alreadySaveObject:peripheral method:^BOOL(id objA, id objB) {return objA == objB ? YES : NO;}];
            
            if (!saved) {
                [self.connectedPeripherals addObject:peripheral];
            }
            
            self.createBLEConnectionObject = object;
            NSLog(@"connect peripheral id = %@",peripheral.identifier);
            [self.centralManager connectPeripheral:peripheral options:nil];
            
            if (object.timeout && object.timeout > 0) {
                //设定超时
                [NSTimer scheduledTimerWithTimeInterval:object.timeout/1000 target:self selector:@selector(onConnectTimeOutTimer:) userInfo:peripheral repeats:NO];
            }
            
        }else {
            
            WXCreateBLEConnectionRes * res = [[WXCreateBLEConnectionRes alloc] initWithErrMsg:@"createBLEConnection:fail createBLEConnection error 10002 device not found" ErrCode:10002];
            object.fail(res);
            object.complete(res);
            
        }
    }
}

-(void)onConnectTimeOutTimer:(NSTimer *)timer{
    
    CBPeripheral * peripheral = timer.userInfo;
    if (peripheral.state != CBPeripheralStateConnected && self.createBLEConnectionObject) {
        WXCreateBLEConnectionRes * res = [[WXCreateBLEConnectionRes alloc] initWithErrMsg:@"createBLEConnection:fail connect time out." ErrCode:10003];
        self.createBLEConnectionObject.fail(res);
        self.createBLEConnectionObject.complete(res);
        self.createBLEConnectionObject = nil;
    }
}

-(void)closeBLEConnection:(id<WXBluetoothObject, WXGetBLEConnectionInfo>) object{
    
    if (self.centralManager == nil) {
        
        WXCloseBLEConnectionRes * res = [[WXCloseBLEConnectionRes alloc] initWithErrMsg:@"closeBLEConnection:fail closeBLEConnection error 10000" ErrCode:10000];
        object.fail(res);
        object.complete(res);
        
    }else{
        
        CBPeripheral * peripheral = [self findConnectedPeripheral:object.deviceId];
        if (peripheral) {
            self.closeBLEConnectionObject = object;
            [self.centralManager cancelPeripheralConnection:peripheral];
        }else{
            WXCloseBLEConnectionRes * res = [[WXCloseBLEConnectionRes alloc] initWithErrMsg:@"closeBLEConnection:fail closeBLEConnection error 10002 device not find" ErrCode:10002];
            object.fail(res);
            object.complete(res);
        }

    }
}

-(void)getBLEDeviceServices:(id<WXBluetoothObject, WXGetBLEConnectionInfo>) object{
    
    if (self.centralManager == nil) {
        
        WXGetBLEDeviceServicesRes * res = [[WXGetBLEDeviceServicesRes alloc] initWithErrMsg:@"getBLEDeviceServices:fail closeBLEConnection error 10000" errCode:10000 peripheral:nil];
        object.fail(res);
        object.complete(res);
        
    }else {
        
        CBPeripheral * peripheral = [self findConnectedPeripheral:object.deviceId];
        if (peripheral) {
            self.getBLEDeviceServicesObject = object;
            //扫描服务
            [peripheral discoverServices:nil];
        }else{
            //没找到设备
            WXGetBLEDeviceServicesRes * res = [[WXGetBLEDeviceServicesRes alloc] initWithErrMsg:@"getBLEDeviceServices:fail getBLEDeviceServices error 10002" errCode:10002 peripheral:nil];
            object.fail(res);
            object.complete(res);
        }
    }
}

-(void)getBLEDeviceCharacteristics:(id<WXBluetoothObject, WXBGetLEDeviceCharacteristicsInfo>)object {
    
    if (self.centralManager == nil) {
        //未初始化
        WXGetBLEDeviceCharacteristicsRes * res = [[WXGetBLEDeviceCharacteristicsRes alloc] initWithService:nil ErrMsg:@"getBLEDeviceCharacteristics:fail getBLEDeviceCharacteristics error 10000" ErrCode:10000];
        object.fail(res);
        object.complete(res);
        
    }else{
        CBPeripheral * peripheral = [self findConnectedPeripheral:object.deviceId];
        if (peripheral) {
            CBService * service = [peripheral findServiceByID:object.serviceId];
            if (service) {
                //获取特征值
                self.getBLEDeviceCharacteristicsObject = object;
                [peripheral discoverCharacteristics:nil forService:service];
            }else{
                //服务未找到
                WXGetBLEDeviceCharacteristicsRes * res = [[WXGetBLEDeviceCharacteristicsRes alloc] initWithService:nil ErrMsg:@"getBLEDeviceCharacteristics:fail getBLEDeviceCharacteristics error 10004 need find services" ErrCode:10004];
                object.fail(res);
                object.complete(res);
            }
        }else{
            //设备未找到
            WXGetBLEDeviceCharacteristicsRes * res = [[WXGetBLEDeviceCharacteristicsRes alloc] initWithService:nil ErrMsg:@"getBLEDeviceCharacteristics:fail getBLEDeviceCharacteristics error 10002 need connect device" ErrCode:10002];
            object.fail(res);
            object.complete(res);
        }
    }
}

-(void)notifyBLECharacteristicValueChange:(id<WXBluetoothObject, WXNotifyBLECharacteristicValueChangeInfo>) object{
    
    if (self.centralManager == nil) {
        //未初始化
        WXNotifyBLECharacteristicValueChangeRes * res = [[WXNotifyBLECharacteristicValueChangeRes alloc] initWithErrMsg:@"notifyBLECharacteristicValueChange:fail setNotifyOnCharacteristics error 10000" ErrCode:10000];
        object.fail(res);
        object.complete(res);
        
    }else {
        
        CBPeripheral * peripheral = [self findConnectedPeripheral:object.deviceId];
        if (peripheral) {
            CBService * service = [peripheral findServiceByID:object.serviceId];
            if (service) {
                CBCharacteristic * characteristic = [service findCharacteristicByID:object.characteristicId];
                if (characteristic) {
                    //开始设定特征值notify
                    self.notifyBLECharacteristicValueChangeObject = object;
                    [peripheral setNotifyValue:object.state forCharacteristic:characteristic];
                }else{
                    //特征值未找到
                    WXNotifyBLECharacteristicValueChangeRes * res = [[WXNotifyBLECharacteristicValueChangeRes alloc] initWithErrMsg:@"notifyBLECharacteristicValueChange:fail setNotifyOnCharacteristics error 10005 charcteristics not found" ErrCode:10005];
                    object.fail(res);
                    object.complete(res);
                }
            }else {
                //服务未找到
                WXNotifyBLECharacteristicValueChangeRes * res = [[WXNotifyBLECharacteristicValueChangeRes alloc] initWithErrMsg:@"notifyBLECharacteristicValueChange:fail setNotifyOnCharacteristics error 10004 service not found" ErrCode:10004];
                object.fail(res);
                object.complete(res);
            }
        }else{
            //设备未找到
            WXNotifyBLECharacteristicValueChangeRes * res = [[WXNotifyBLECharacteristicValueChangeRes alloc] initWithErrMsg:@"notifyBLECharacteristicValueChange:fail setNotifyOnCharacteristics error 10002 device not found" ErrCode:10002];
            object.fail(res);
            object.complete(res);
        }
    }
}

-(void)readBLECharacteristicValue:(id<WXBluetoothObject, WXReadBLECharacteristicValueInfo>) object{
    
    if (self.centralManager == nil) {
        //未初始化
        WXReadBLECharacteristicValueRes * res = [[WXReadBLECharacteristicValueRes alloc] initWithErrMsg:@"readBLECharacteristicValue:fail errCode 10000" ErrCode:10000];
        object.fail(res);
        object.complete(res);
    }else {
        CBPeripheral * peripheral = [self findConnectedPeripheral:object.deviceId];
        if (peripheral) {
            CBService * service = [peripheral findServiceByID:object.serviceId];
            if (service) {
                CBCharacteristic * characteristic = [service findCharacteristicByID:object.characteristicId];
                if (characteristic) {
                    //开始读
                    self.readBLECharacteristicValueObject = object;
                    [peripheral readValueForCharacteristic:characteristic];
                }else {
                    //特征值未找到
                    WXReadBLECharacteristicValueRes * res = [[WXReadBLECharacteristicValueRes alloc] initWithErrMsg:@"readBLECharacteristicValue:fail errCode 10005" ErrCode:10005];
                    object.fail(res);
                    object.complete(res);
                }
            }else {
                //服务未找到
                WXReadBLECharacteristicValueRes * res = [[WXReadBLECharacteristicValueRes alloc] initWithErrMsg:@"readBLECharacteristicValue:fail errCode 10004" ErrCode:10004];
                object.fail(res);
                object.complete(res);
            }
        }else {
            //设备未找到
            WXReadBLECharacteristicValueRes * res = [[WXReadBLECharacteristicValueRes alloc] initWithErrMsg:@"readBLECharacteristicValue:fail errCode 10002" ErrCode:10002];
            object.fail(res);
            object.complete(res);
        }

    }
    
}

-(void)writeBLECharacteristicValue:(id<WXBluetoothObject, WXWriteBLECharacteristicValueInfo>) object{
    
    if (self.centralManager == nil) {
        //未初始化
        WXWriteBLECharacteristicValueRes * res = [[WXWriteBLECharacteristicValueRes alloc] initWithErrMsg:@"writeBLECharacteristicValue:fail errCode 10000" ErrCode:10000];
        object.fail(res);
        object.complete(res);
    }else {
        CBPeripheral * peripheral = [self findConnectedPeripheral:object.deviceId];
        if (peripheral) {
            CBService * service = [peripheral findServiceByID:object.serviceId];
            if (service) {
                CBCharacteristic * characteristic = [service findCharacteristicByID:object.characteristicId];
                if (characteristic) {
                    //开始写
                    self.writeBLECharacteristicValueObject = object;
                    [peripheral writeValue:object.value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                }else {
                    //特征值未找到
                    WXWriteBLECharacteristicValueRes * res = [[WXWriteBLECharacteristicValueRes alloc] initWithErrMsg:@"writeBLECharacteristicValue:fail errCode 10005" ErrCode:10005];
                    object.fail(res);
                    object.complete(res);
                }
            }else {
                //服务未找到
                WXWriteBLECharacteristicValueRes * res = [[WXWriteBLECharacteristicValueRes alloc] initWithErrMsg:@"writeBLECharacteristicValue:fail errCode 10004" ErrCode:10004];
                object.fail(res);
                object.complete(res);
            }
        }else {
            //设备未找到
            WXWriteBLECharacteristicValueRes * res = [[WXWriteBLECharacteristicValueRes alloc] initWithErrMsg:@"writeBLECharacteristicValue:fail errCode 10002" ErrCode:10002];
            object.fail(res);
            object.complete(res);
        }

    }
}




#pragma mark -- CBCentralManagerDelegate

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    NSLog(@"连接成功 %@", peripheral);
    peripheral.delegate = self;
    if (self.createBLEConnectionObject) {
        WXCreateBLEConnectionRes * res = [[WXCreateBLEConnectionRes alloc] initWithErrMsg:@"createBLEConnection:ok" ErrCode:0];
        self.createBLEConnectionObject.success(res);
        self.createBLEConnectionObject.complete(res);
        self.createBLEConnectionObject = nil;
    }
    
    if (self.onBLEConnectionStateChange) {
        self.onBLEConnectionStateChange([[WXOnBLEConnectionStateChangeRes alloc]initWithPeripheral:peripheral Connected:YES ErrMsg:@"connect success" ErrCode:0]);
    }
    
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"断开连接 %@", peripheral);
    if (self.closeBLEConnectionObject) {
        //主动断开连接
        WXCloseBLEConnectionRes * res = [[WXCloseBLEConnectionRes alloc] initWithErrMsg:@"closeBLEConnectionObject:ok" ErrCode:0];
        self.closeBLEConnectionObject.success(res);
        self.closeBLEConnectionObject.complete(res);
        [self.connectedPeripherals removeObject:peripheral];
        self.closeBLEConnectionObject = nil;
        
        //主动断开
        if (self.onBLEConnectionStateChange) {
            self.onBLEConnectionStateChange([[WXOnBLEConnectionStateChangeRes alloc]initWithPeripheral:peripheral Connected:NO ErrMsg:@"disconnect success" ErrCode:0]);
            
        }
    }else {
        //被动断开
        if (self.onBLEConnectionStateChange) {
            self.onBLEConnectionStateChange([[WXOnBLEConnectionStateChangeRes alloc]initWithPeripheral:peripheral Connected:NO ErrMsg:@"disconnect 10006" ErrCode:10006]);
        }
    }
}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    //NSLog(@"连接失败 %@", peripheral);
    if (self.createBLEConnectionObject) {
        WXCreateBLEConnectionRes * res = [[WXCreateBLEConnectionRes alloc] initWithErrMsg:@"createBLEConnection:fail errCode 10003 连接失败" ErrCode:10003];
        self.createBLEConnectionObject.fail(res);
        self.createBLEConnectionObject.complete(res);
        self.createBLEConnectionObject = nil;
    }
    
    if (self.onBLEConnectionStateChange) {
        self.onBLEConnectionStateChange([[WXOnBLEConnectionStateChangeRes alloc]initWithPeripheral:peripheral Connected:NO ErrMsg:@"connect fail 10003" ErrCode:10003]);
    }
}

#pragma mark -- CBPeripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    //NSLog(@"peripheral:didDiscoverServices %@", peripheral.services);
    if (self.getBLEDeviceServicesObject) {
        WXGetBLEDeviceServicesRes * res = [[WXGetBLEDeviceServicesRes alloc] initWithErrMsg:@"getBLEDeviceServices:ok" errCode:0 peripheral:peripheral];
        self.getBLEDeviceServicesObject.success(res);
        self.getBLEDeviceServicesObject.complete(res);
        self.getBLEDeviceServicesObject = nil;
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    //NSLog(@"peripheral = %@", peripheral);
    //NSLog(@"characteristics = %@",service.characteristics);
    if (self.getBLEDeviceCharacteristicsObject) {
        if (error) {
            WXGetBLEDeviceCharacteristicsRes * res = [[WXGetBLEDeviceCharacteristicsRes alloc] initWithService:service ErrMsg:@"getBLEDeviceCharacteristics:fail getBLEDeviceCharacteristics error 10008" ErrCode:10008];
            self.getBLEDeviceCharacteristicsObject.fail(res);
            self.getBLEDeviceCharacteristicsObject.complete(res);
            self.getBLEDeviceCharacteristicsObject = nil;
        }else{
            WXGetBLEDeviceCharacteristicsRes * res = [[WXGetBLEDeviceCharacteristicsRes alloc] initWithService:service ErrMsg:@"getBLEDeviceCharacteristics:ok" ErrCode:0];
            self.getBLEDeviceCharacteristicsObject.success(res);
            self.getBLEDeviceCharacteristicsObject.complete(res);
            self.getBLEDeviceCharacteristicsObject = nil;
        }
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
    //NSLog(@"error = %@", error);
    if (self.notifyBLECharacteristicValueChangeObject) {
        if (error) {
            if (error.code == 6) {
                //特征不支持 notify
                WXNotifyBLECharacteristicValueChangeRes * res = [[WXNotifyBLECharacteristicValueChangeRes alloc] initWithErrMsg:@"notifyBLECharacteristicValueChange:fail setNotifyOnCharacteristics error 10007" ErrCode:10007];
                self.notifyBLECharacteristicValueChangeObject.fail(res);
                self.notifyBLECharacteristicValueChangeObject.complete(res);
            }else {
                //其他错误
                WXNotifyBLECharacteristicValueChangeRes * res = [[WXNotifyBLECharacteristicValueChangeRes alloc] initWithErrMsg:@"notifyBLECharacteristicValueChange:fail setNotifyOnCharacteristics error 10008" ErrCode:10008];
                self.notifyBLECharacteristicValueChangeObject.fail(res);
                self.notifyBLECharacteristicValueChangeObject.complete(res);
            }
        }else {
            //成功
            WXNotifyBLECharacteristicValueChangeRes * res = [[WXNotifyBLECharacteristicValueChangeRes alloc] initWithErrMsg:@"notifyBLECharacteristicValueChange:ok" ErrCode:0];
            self.notifyBLECharacteristicValueChangeObject.success(res);
            self.notifyBLECharacteristicValueChangeObject.complete(res);
        }
        self.notifyBLECharacteristicValueChangeObject = nil;
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
    //读反馈
    if (self.readBLECharacteristicValueObject) {
        if (error == nil) {
            //成功
            WXReadBLECharacteristicValueRes * res = [[WXReadBLECharacteristicValueRes alloc] initWithErrMsg:@"readBLECharacteristicValue:ok" ErrCode:0];
            self.readBLECharacteristicValueObject.success(res);
            self.readBLECharacteristicValueObject.complete(res);
            self.readBLECharacteristicValueObject = nil;
        }else {
            if (error.code == 2) {
                //特征不支持读取操作
                WXReadBLECharacteristicValueRes * res = [[WXReadBLECharacteristicValueRes alloc] initWithErrMsg:@"readBLECharacteristicValue:fail characteristic not support read errCode 10007" ErrCode:10007];
                self.readBLECharacteristicValueObject.fail(res);
                self.readBLECharacteristicValueObject.complete(res);
                self.readBLECharacteristicValueObject = nil;
            }else {
                //其他错误
                WXReadBLECharacteristicValueRes * res = [[WXReadBLECharacteristicValueRes alloc] initWithErrMsg:@"readBLECharacteristicValue:fail errCode 10008" ErrCode:10008];
                self.readBLECharacteristicValueObject.fail(res);
                self.readBLECharacteristicValueObject.complete(res);
                self.readBLECharacteristicValueObject = nil;
            }
        }
        
    }
    
    if (self.onBLECharacteristicValueChange) {
        WXOnBLECharacteristicValueChangeRes * res = [[WXOnBLECharacteristicValueChangeRes alloc] initWithPeripheral:peripheral Characteristic:characteristic];
        self.onBLECharacteristicValueChange(res);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    //写反馈
    if (self.writeBLECharacteristicValueObject) {
        if (error == nil) {
            //写成功
            WXWriteBLECharacteristicValueRes * res = [[WXWriteBLECharacteristicValueRes alloc] initWithErrMsg:@"writeBLECharacteristicValue:ok" ErrCode:0];
            self.writeBLECharacteristicValueObject.success(res);
            self.writeBLECharacteristicValueObject.complete(res);
            self.writeBLECharacteristicValueObject = nil;
        }else {
            if (error.code == 3) {
                WXWriteBLECharacteristicValueRes * res = [[WXWriteBLECharacteristicValueRes alloc] initWithErrMsg:@"writeBLECharacteristicValue:fail not support write errCode 10007" ErrCode:10007];
                self.writeBLECharacteristicValueObject.fail(res);
                self.writeBLECharacteristicValueObject.complete(res);
                self.writeBLECharacteristicValueObject = nil;
            }else {
                WXWriteBLECharacteristicValueRes * res = [[WXWriteBLECharacteristicValueRes alloc] initWithErrMsg:@"writeBLECharacteristicValue:fail errCode 10008" ErrCode:10008];
                self.writeBLECharacteristicValueObject.fail(res);
                self.writeBLECharacteristicValueObject.complete(res);
                self.writeBLECharacteristicValueObject = nil;
            }
        }
    }
}

@end

@implementation CBPeripheral(WXBLE)
-(CBService *)findServiceByID:(NSString *)ID{
    for (CBService * service in self.services) {
        if ([service.UUID.UUIDString isEqualToString:ID]) {
            return service;
        }
    }
    return nil;
}
@end


@implementation CBService(WXBLE)
-(CBCharacteristic *)findCharacteristicByID:(NSString *)ID{
    for (CBCharacteristic * characteristic in self.characteristics) {
        if ([characteristic.UUID.UUIDString isEqualToString:ID]) {
            return characteristic;
        }
    }
    return nil;
}
@end

