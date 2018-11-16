//
//  BatteryViewController.m
//  demo
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "BatteryViewController.h"
#import "ViewController.h"

@interface BatteryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lableLevel;
@property (weak, nonatomic) IBOutlet UILabel *labelIsCharing;
@property (weak, nonatomic) IBOutlet UILabel *labelErrMsg;

@end

@implementation BatteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnGetBatteryInfo:(id)sender {
    WX * wx = [ViewController getInstance].wx;
    WXGetBatteryInfoObject * ob = [[WXGetBatteryInfoObject alloc] init];
    ob.success = ^(id<WXGetBatteryInfoRes> res) {
        NSLog(@"WXGetBettery info success res = %@", res);
        self.lableLevel.text = res.level;
        self.labelIsCharing.text = [[NSNumber numberWithBool:res.isCharging] stringValue];
        self.labelErrMsg.text = res.errMsg;
    };
    ob.fail = ^(NSError *error) {
        NSLog(@"WXGetBettery info fail = %@", error);
    };
    ob.complete = ^(id<WXGetBatteryInfoRes> res) {
        NSLog(@"WXGetBettery info complete res = %@", res);
    };
    [wx getBatteryInfo:ob];
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
