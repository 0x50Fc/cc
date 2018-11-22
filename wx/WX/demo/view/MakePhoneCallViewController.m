//
//  MakePhoneCallViewController.m
//  demo
//
//  Created by zuowu on 2018/11/22.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "MakePhoneCallViewController.h"
#import "ViewController.h"

@interface MakePhoneCallViewController ()

@end

@implementation MakePhoneCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnCall:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    wx.phoneCallViewController = self;
    WXMakePhoneCallObject * object = [[WXMakePhoneCallObject alloc] init];
    object.phoneNumber = self.numberField.text;
    object.success = ^(id<WXMakePhoneCallRes> res) {
        NSLog(@"call success res = %@", res);
    };
    object.fail = ^(id<WXMakePhoneCallRes> res) {
        NSLog(@"call fail res = %@", res);
    };
    object.complete = ^(id<WXMakePhoneCallRes> res) {
        NSLog(@"call complete res = %@", res);
    };
    [wx makePhoneCall:object];
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
