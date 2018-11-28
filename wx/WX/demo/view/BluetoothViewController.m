//
//  BluetoothViewController.m
//  demo
//
//  Created by zuowu on 2018/11/27.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "BluetoothViewController.h"
#import "ViewController.h"

@interface BluetoothViewController ()

@end

@implementation BluetoothViewController
- (IBAction)btnOpenBluetooth:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    WXBOpenBluetoothAdapterObject * object = [[WXBOpenBluetoothAdapterObject alloc] init];
    object.success = ^(id<WXBluetoothRes> res) {
        NSLog(@"OpenBluetoothAdapter success res = %@", res);
    };
    object.fail = ^(id<WXBluetoothRes> res) {
        NSLog(@"OpenBluetoothAdapter fail res = %@", res);
    };
    object.complete = ^(id<WXBluetoothRes> res) {
        NSLog(@"OpenBluetoothAdapter complete res = %@", res);
    };
    [wx openBluetoothAdapter:object];
}
- (IBAction)btnCloseBluetooth:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    WXCloseBluetoothAdapterObject * object = [[WXCloseBluetoothAdapterObject alloc] init];
    object.success = ^(id<WXBluetoothRes> res) {
        NSLog(@"CloseBluetoothAdapter success res = %@", res);
    };
    object.fail = ^(id<WXBluetoothRes> res) {
        NSLog(@"CloseBluetoothAdapter fail res = %@", res);
    };
    object.complete = ^(id<WXBluetoothRes> res) {
        NSLog(@"CloseBluetoothAdapter complete res = %@",res);
    };
    [wx closeBluetoothAdapter:object];
}
- (IBAction)btnStartBluetoothDevicesDiscovery:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    WXStartBluetoothDevicesDiscoveryObject * object = [[WXStartBluetoothDevicesDiscoveryObject alloc] init];
//    object.interval = 5000;
//    object.services = @[@"181D"];
//    object.allowDuplicatesKey = NO;
    object.success = ^(id<WXBluetoothRes> res) {
        NSLog(@"StartBluetoothDevicesDiscovery success res = %@", res);
    };
    object.fail = ^(id<WXBluetoothRes> res) {
        NSLog(@"StartBluetoothDevicesDiscovery fail res = %@", res);
    };
    object.complete = ^(id<WXBluetoothRes> res) {
        NSLog(@"StartBluetoothDevicesDiscovery complete res = %@", res);
    };
    
    wx.onBluetoothDeviceFound = ^(id<WXOnBluetoothDeviceFoundRes> res) {
        NSLog(@"found devices\n");
        NSLog(@"%@",res);
    };
    
    [wx startBluetoothDevicesDiscovery:object];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
