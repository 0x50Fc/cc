//
//  WXBLE.h
//  WX
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//
/*
 * https://www.jianshu.com/p/1f479b6ab6df
 */

#import <WX/WX.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface WX (WXBLE) <CBCentralManagerDelegate>
@property (nonatomic, strong, readonly) CBCentralManager * cbCentralManager;
@end


