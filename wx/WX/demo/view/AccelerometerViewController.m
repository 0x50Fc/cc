//
//  AccelerometerViewController.m
//  demo
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "AccelerometerViewController.h"
#import "ViewController.h"

@interface AccelerometerViewController ()

@end

@implementation AccelerometerViewController
- (IBAction)btnStartAccelerometer:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    WXStartAccelerometerObject * ob = [[WXStartAccelerometerObject alloc] init];
    ob.interval = @"game";
    ob.success = ^(id<WXStartAccelerometerRes> res) {
        NSLog(@"star accelerometer success %@", res);
    };
    ob.complete = ^(id<WXStartAccelerometerRes> res) {
        NSLog(@"star accelerometer complete %@", res);
    };
    ob.fail = ^(NSError *error) {
        NSLog(@"star accelerometer fail %@", error);
    };
    
    [wx startAccelerometer:ob];
    wx.onAccelerometerChange = ^(id<WXOnAccelerometerChangeRes> res) {
        NSLog(@"on accelerometer change = %@",res);
    };
}
- (IBAction)btnStopAccelerometer:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    WXStartAccelerometerObject * ob = [[WXStartAccelerometerObject alloc] init];
    
    ob.success = ^(id<WXStartAccelerometerRes> res) {
        NSLog(@"stop accelerometer success %@", res);
    };
    ob.complete = ^(id<WXStartAccelerometerRes> res) {
        NSLog(@"stop accelerometer complete %@", res);
    };
    ob.fail = ^(NSError *error) {
        NSLog(@"stop accelerometer fail %@", error);
    };
    
    [wx stopAccelerometer:ob];
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
