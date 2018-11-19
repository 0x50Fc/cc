//
//  ClipboardViewController.m
//  demo
//
//  Created by zuowu on 2018/11/19.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "ClipboardViewController.h"
#import "ViewController.h"

@interface ClipboardViewController ()

@end

@implementation ClipboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnSetClipboard:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    WXSetClipboardObject * object = [[WXSetClipboardObject alloc] init];
    object.data = self.setField.text;
    object.success = ^(id<WXClipboardRes> res) {
        NSLog(@"WX set clipboard success res = %@", res);
    };
    object.complete = ^(id<WXClipboardRes> res) {
        NSLog(@"WX set clipboard complete res = %@", res);
    };
    object.fali = ^(NSError *error) {
        NSLog(@"WX set clipboard error res = %@", error);
    };
    [wx setClipboardData:object];
    
    wx.onCompassChange = ^(id<WXOnCompassChageRes> res) {
        NSLog(@"on compass change res = %@",res);
    };
}
- (IBAction)btnGetClipboard:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    WXGetClipboardObject * object = [[WXGetClipboardObject alloc] init];
    object.success = ^(id<WXClipboardRes> res) {
        NSLog(@"WX get clipboard success res = %@", res);
        self.getField.text = res.data;
    };
    object.fail = ^(NSError *error) {
        NSLog(@"WX get clipboard fail res = %@", error);
    };
    object.complete = ^(id<WXClipboardRes> res) {
        NSLog(@"WX get clipboard complete res = %@", res);
    };
    [wx getClipboardData:object];
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
