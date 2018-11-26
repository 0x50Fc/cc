//
//  VibrateViewController.m
//  demo
//
//  Created by zuowu on 2018/11/26.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "VibrateViewController.h"
#import "ViewController.h"

@interface VibrateViewController ()

@end

@implementation VibrateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnVirbateLong:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    WXVibrateLongObject * object = [[WXVibrateLongObject alloc] init];
    object.success = ^(id<WXVibrateLongRes> res) {
        
    };
    object.fail = ^(id<WXVibrateLongRes> res) {
        
    };
    object.complete = ^(id<WXVibrateLongRes> res) {
        
    };
    [wx virateLong:object];
}
- (IBAction)btnVirbateShort:(id)sender {
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
