//
//  IBeaconViewController.m
//  demo
//
//  Created by zuowu on 2018/12/5.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "IBeaconViewController.h"
#import "ViewController.h"

@interface IBeaconViewController ()

@end

@implementation IBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnStartBeaconDiscovery:(id)sender {
    WX * wx = [ViewController shareWX];;
    WXStartBeaconDiscoveryObject * object = [[WXStartBeaconDiscoveryObject alloc] init];
    object.uuids = @[@"5D7B50B0-CFBA-4BF8-999B-93F6DA0F4356",@"CF5FE804-E59A-41C3-8669-59B2982EB566"];
    object.success = ^(id<WXIBeaconRes> res) {
        
    };
    object.fail = ^(id<WXIBeaconRes> res) {
        
    };
    object.complete = ^(id<WXIBeaconRes> res) {
        
    };
    [wx startBeaconDiscovery:object];
    
}
- (IBAction)btnStopBeaconDiscovery:(id)sender {
}
- (IBAction)btnGetBeacons:(id)sender {
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
