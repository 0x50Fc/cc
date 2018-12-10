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
@property (nonatomic, strong) WXRecorderManager * recorderManager;
@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WX * wx = [ViewController shareWX];
    self.recorderManager = [wx getRecoderManager];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnStartRecoder:(id)sender {
    
    
    WXRecorderManagerStarObject * object = [[WXRecorderManagerStarObject alloc] init];
    object.duration = 20 * 1000;
    
    [self.recorderManager star:object];
    
}
- (IBAction)btnStopRecoder:(id)sender {
    
    [self.recorderManager stop];
    
}
- (IBAction)btnPlayRecorder:(id)sender {
    
    [self.recorderManager play];
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
