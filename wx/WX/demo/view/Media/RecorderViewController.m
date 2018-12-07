//
//  RecorderViewController.m
//  demo
//
//  Created by zuowu on 2018/12/6.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "RecorderViewController.h"
#import "ViewController.h"

@interface RecorderViewController ()

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnStartRecoder:(id)sender {
//    WX * wx = [ViewController shareWX];
//    WXRecoderManager * recocerManager = [wx getRecoderManager];
    WXRecoderManagerStarObject * object = [[WXRecoderManagerStarObject alloc] init];
    
//    recocerManager star:<#(id<WXRecoderManagerStarObject>)#>
    
}
- (IBAction)btnStopRecoder:(id)sender {
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
