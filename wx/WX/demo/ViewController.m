//
//  ViewController.m
//  demo
//
//  Created by hailong11 on 2018/11/12.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "ViewController.h"
#import "LocationViewController.h"

@interface ViewController ()
@property (nonatomic, strong, readonly) WX * wx;
@end

@implementation ViewController

@synthesize wx = _wx;

static ViewController * __instance;

+(WX *)shareWX{
    return [ViewController getInstance].wx;
}

+(ViewController *)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[ViewController alloc] init];
    });
    return __instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//   VibrateViewController
    _arrVC = @[
               @{ @"text":@"录音 - Recorder", @"class":@"RecorderViewController" },
               @{ @"text":@"定位 - Location", @"class":@"LocationViewController" },
               @{ @"text":@"加速器 - Accelerometer", @"class":@"AccelerometerViewController" },
               @{ @"text":@"电量 - Battery", @"class":@"BatteryViewController" },
               @{ @"text":@"蓝牙 - Bluetooth", @"class":@"BluetoothViewController" },
               @{ @"text":@"剪切板 - Clipboard", @"class":@"ClipboardViewController" },
               @{ @"text":@"联系人 - PhoneContact", @"class":@"PhoneContactViewController" },
               @{ @"text":@"打电话 - MakePhoneCall", @"class":@"MakePhoneCallViewController" },
               @{ @"text":@"屏幕 - Screen", @"class":@"ScreenViewController" },
               @{ @"text":@"震动 - Vibrate", @"class":@"VibrateViewController" },
               @{ @"text":@"iBeacon - iBeacon", @"class":@"IBeaconViewController" }
               ];
     _wx = [[WX alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}
- (IBAction)bkk:(id)sender {
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrVC.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic = [_arrVC objectAtIndex:[indexPath row]];
    CGRect sceneRect = [UIScreen mainScreen].bounds;
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,sceneRect.size.width, 40)];
    label.highlightedTextColor = [UIColor whiteColor];
    label.text = [dic valueForKey:@"text"];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary * dic = [_arrVC objectAtIndex:[indexPath row]];
    NSString * name = [dic valueForKey:@"class"];
    NSBundle * budnle = [NSBundle bundleForClass:NSClassFromString(name)];
    NSLog(@"budnle==%@",budnle);
    id vc =  [[NSClassFromString(name) alloc]initWithNibName:name bundle:budnle];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
