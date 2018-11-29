//
//  WXBLE.m
//  WX
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXBLE.h"

#define ConnectedPeripheralsKey "ConnectedPeripheralsKey"

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

@interface WX()
@property (nonatomic, strong, readonly) NSMutableArray<CBPeripheral *> * connectedPeripherals;
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

-(void)createBLEConnection:(id<WXBluetoothObject, WXCreateBLEConnectionInfo>) object {
    
    if (self.centralManager == nil) {
        
        WXCreateBLEConnectionRes * res = [[WXCreateBLEConnectionRes alloc] initWithErrMsg:@"createBLEConnection:fail createBLEConnection error 10000." ErrCode:1000];
        object.fail(res);
        object.complete(res);
        
    }else{
        
        NSArray * arr = [self.centralManager retrievePeripheralsWithIdentifiers:@[[[NSUUID alloc] initWithUUIDString:object.deviceId]]];
        if (arr.count > 0) {
            
            CBPeripheral * peripheral = arr[0];
            
            BOOL saved = [self.connectedPeripherals alreadySaveObject:peripheral method:^BOOL(id objA, id objB) {
                if (objA == objB) {
                    return YES;
                }
                return NO;
            }];
            
            if (!saved) {
                [self.connectedPeripherals addObject:peripheral];
            }

            [self.centralManager connectPeripheral:peripheral options:nil];
            
            if (object.timeout && object.timeout > 0) {
                //设定超时
                [NSTimer scheduledTimerWithTimeInterval:object.timeout/1000 target:self selector:@selector(onConnectTimeOutTimer:) userInfo:@[peripheral,object] repeats:NO];
            }
            
        }else{
            
            WXCreateBLEConnectionRes * res = [[WXCreateBLEConnectionRes alloc] initWithErrMsg:@"createBLEConnection:fail createBLEConnection error 10002 device not found" ErrCode:10002];
            object.fail(res);
            object.complete(res);
            
        }
    }
}

-(void)onConnectTimeOutTimer:(NSTimer *)timer{
    NSArray * data = timer.userInfo;
    CBPeripheral * peripheral = data[0];
    WXCreateBLEConnectionObject * object = data[1];
    if (peripheral.state != CBPeripheralStateConnected) {
        WXCreateBLEConnectionRes * res = [[WXCreateBLEConnectionRes alloc] initWithErrMsg:@"createBLEConnection:fail connect time out." ErrCode:10003];
        object.fail(res);
        object.complete(res);
        //[self.centralManager cancelPeripheralConnection:peripheral];
    }
}

-(void)closeBLEConnection:(id<WXBluetoothObject, WXCloseBLEConnectionInfo>) object{
    if (self.centralManager == nil) {
        
    }else{
//        self.centralManager cancelPeripheralConnection:<#(nonnull CBPeripheral *)#>
    }
}


#pragma mark -- CBCentralManagerDelegate

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接成功 %@", peripheral);
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接断开连接 %@", peripheral);
}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接失败 %@", peripheral);
}


@end
