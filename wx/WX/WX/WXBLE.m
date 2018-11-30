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


@interface WX()

@property (nonatomic, strong, readonly) NSMutableArray<CBPeripheral *> * connectedPeripherals;

@property (nonatomic, strong) WXCreateBLEConnectionObject * createBLEConnectionObject;
@property (nonatomic, strong) WXCloseBLEConnectionObject * closeBLEConnectionObject;
@property (nonatomic, strong) WXGetBLEDeviceServicesObject * getBLEDeviceServicesObject;

@end

@implementation WX (WXBLE)

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
            [self.centralManager connectPeripheral:peripheral options:nil];
            NSLog(@"id = %@",peripheral.identifier);
            
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
    }
}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接失败 %@", peripheral);
    if (self.createBLEConnectionObject) {
        WXCreateBLEConnectionRes * res = [[WXCreateBLEConnectionRes alloc] initWithErrMsg:@"createBLEConnection:fail errCode 10003 连接失败" ErrCode:10003];
        self.createBLEConnectionObject.fail(res);
        self.createBLEConnectionObject.complete(res);
        self.createBLEConnectionObject = nil;
    }
}

#pragma mark -- CBPeripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"peripheral:didDiscoverServices %@", peripheral.services);
    if (self.getBLEDeviceServicesObject) {
        WXGetBLEDeviceServicesRes * res = [[WXGetBLEDeviceServicesRes alloc] initWithErrMsg:@"getBLEDeviceServices:ok" errCode:0 peripheral:peripheral];
        self.getBLEDeviceServicesObject.success(res);
        self.getBLEDeviceServicesObject.complete(res);
        self.getBLEDeviceServicesObject = nil;
    }
}


@end
