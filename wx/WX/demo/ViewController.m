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

@end

@implementation ViewController

@synthesize wx = _wx;

static ViewController * __instance;
+(ViewController *)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[ViewController alloc] init];
    });
    return __instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _arrVC = @[
               @{ @"text":@"定位 - Location", @"class":@"LocationViewController" },
               @{ @"text":@"加速器 - Accelerometer", @"class":@"AccelerometerViewController" },
               @{ @"text":@"电量 - Battery", @"class":@"BatteryViewController" },
               @{ @"text":@"蓝牙4.0(低功耗蓝牙) - BLE", @"class":@"BLEViewController" },
               @{ @"text":@"剪切板 - Clipboard", @"class":@"ClipboardViewController" },
               @{ @"text":@"联系人 - PhoneContact", @"class":@"PhoneContactViewController" }
               ];
     _wx = [[WX alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
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
    id vc =  [[NSClassFromString(name) alloc]initWithNibName:name bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
