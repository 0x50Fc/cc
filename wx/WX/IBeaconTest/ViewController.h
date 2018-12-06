//
//  ViewController.h
//  IBeaconTest
//
//  Created by zuowu on 2018/12/5.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController <CBPeripheralManagerDelegate, CBCentralManagerDelegate>


@end

