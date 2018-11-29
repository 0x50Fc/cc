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

@protocol WXCreateBLEConnectionInfo <NSObject>
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, assign) double timeout;
@end

@protocol WXCloseBLEConnectionInfo <NSObject>
@property (nonatomic, strong) NSString * deviceId;
@end

@interface WXCreateBLEConnectionRes : NSObject <WXBluetoothRes>
@end

@interface WXCreateBLEConnectionObject : NSObject <WXBluetoothObject, WXCreateBLEConnectionInfo>
@end

@interface WXCloseBLEConnectionRes : NSObject <WXBluetoothRes>
@end

@interface WXCloseBLEConnectionObject : NSObject <WXBluetoothObject, WXCloseBLEConnectionInfo>
@end



@interface WX (WXBLE)
-(void)createBLEConnection:(id<WXBluetoothObject, WXCreateBLEConnectionInfo>) object;
-(void)closeBLEConnection:(id<WXBluetoothObject, WXCloseBLEConnectionInfo>) object;
@end


