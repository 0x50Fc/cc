//
//  ScreenViewController.m
//  demo
//
//  Created by zuowu on 2018/11/26.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "ScreenViewController.h"
#import "ViewController.h"

@interface ScreenViewController ()

@end

@implementation ScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WX * wx = [ViewController shareWX];;
    wx.onUserCaptureScreen = ^{
        NSLog(@"on user capture");
        NSString * str = [NSString stringWithFormat:@"%d", arc4random()];
        self.labelOnUserCaptureScreen.text = str;
    };
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnGetScreenBrightness:(id)sender {
    WX * wx = [ViewController shareWX];;
    WXGetScreenBrightnessObject * object = [[WXGetScreenBrightnessObject alloc] init];
    object.success = ^(id<WXGetScreenBrightnessRes> res) {
        self.labelGetScreenBrightness.text = [NSString stringWithFormat:@"%lf", res.value];
        NSLog(@"get screen brightness success res = %@", res);
    };
    object.fail = ^(id<WXGetScreenBrightnessRes> res) {
        NSLog(@"get screen brightness fail res = %@", res);
    };
    object.complete = ^(id<WXGetScreenBrightnessRes> res) {
        NSLog(@"get screen brightness complete res = %@", res);
    };
    [wx getScreenBrightness:object];
}
- (IBAction)btnSetScreenBrightness:(id)sender {
    WX * wx = [ViewController shareWX];;
    WXSetScreenBrightnessObject * object = [[WXSetScreenBrightnessObject alloc] init];
    object.value = [self.labelSetScreenBrightness.text doubleValue];
    object.success = ^(id<WXSetScreenBrightnessRes> res) {
        NSLog(@"set screen brightness success res = %@", res);
    };
    object.fail = ^(id<WXSetScreenBrightnessRes> res) {
        NSLog(@"set screen brightness success res = %@", res);
    };
    object.complete = ^(id<WXSetScreenBrightnessRes> res) {
        NSLog(@"set screen brightness success res = %@", res);
    };
    [wx setScreenBrightness:object];
}
- (IBAction)btnKeepScreenOn:(id)sender {
    WX * wx = [ViewController shareWX];;
    WXSetKeepScreenOnObject * object = [[WXSetKeepScreenOnObject alloc] init];
    object.keepScreenOn = YES;
    object.success = ^(id<WXSetKeepScreenOnRes> res) {
        NSLog(@"set keep screen on success res = %@", res);
    };
    object.fail = ^(id<WXSetKeepScreenOnRes> res) {
        NSLog(@"set keep screen on success res = %@", res);
    };
    object.complete = ^(id<WXSetKeepScreenOnRes> res) {
        NSLog(@"set keep screen on success res = %@", res);
    };
    [wx setKeepScreenOn:object];
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
