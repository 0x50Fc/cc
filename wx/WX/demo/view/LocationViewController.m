//
//  LocationViewController.m
//  demo
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "LocationViewController.h"
#import "ViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnGetLocation:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    WXGetLocationObject * ob = [[WXGetLocationObject alloc]init];
    ob.success = ^(id<WXGetLocationRes> res) {
        NSLog(@"success");
        NSLog(@"%@",res);
    };
    ob.fail = ^(NSError *error) {

    };
    ob.complete = ^(id<WXGetLocationRes> res) {
        if ([res.errMsg isEqualToString:@"getLocation:ok"]) {
            NSLog(@"complete");
            NSLog(@"%@",res);
        }
    };
    ob.type = @"gcj02";
    ob.altitude = YES;

    [wx getLocation:ob];
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
