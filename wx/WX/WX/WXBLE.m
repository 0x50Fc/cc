//
//  WXBLE.m
//  WX
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXBLE.h"

#define CBCenterManagerKey ""

@implementation WX (WXBLE)

- (CBCentralManager *)cbCentralManager{

//    CBCentralManager * _manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];

    return nil;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}

@end
