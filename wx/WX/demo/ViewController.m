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

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _arrVC = @[
               @{ @"text":@"定位 - Location", @"class":@"LocationViewController" },
               @{ @"text":@"加速器 - Accelerometer", @"class":@"AccelerometerViewController" }
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
    id vc = [[NSClassFromString([dic valueForKey:@"class"]) alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    
}
    
-(IBAction)starButton:(id)sender{
//    [self testGetLocation];
    [self testStartAccelerometer];
}
- (IBAction)stopButton:(id)sender {
    WXStartAccelerometerObject * ob = [[WXStartAccelerometerObject alloc] init];

    ob.success = ^(id<WXStartAccelerometerRes> res) {
        NSLog(@"stop accelerometer success %@", res);
    };
    ob.complete = ^(id<WXStartAccelerometerRes> res) {
        NSLog(@"stop accelerometer complete %@", res);
    };
    ob.fail = ^(NSError *error) {
        NSLog(@"stop accelerometer fail %@", error);
    };
    
    [_wx stopAccelerometer:ob];
}

-(void)testGetLocation{
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
    
    [_wx getLocation:ob];
}

-(void)testStartAccelerometer{
    WXStartAccelerometerObject * ob = [[WXStartAccelerometerObject alloc] init];
    ob.interval = @"game";
    ob.success = ^(id<WXStartAccelerometerRes> res) {
        NSLog(@"star accelerometer success %@", res);
    };
    ob.complete = ^(id<WXStartAccelerometerRes> res) {
        NSLog(@"star accelerometer complete %@", res);
    };
    ob.fail = ^(NSError *error) {
        NSLog(@"star accelerometer fail %@", error);
    };
    
    [_wx startAccelerometer:ob];
    _wx.onAccelerometerChange = ^(id<WXOnAccelerometerChangeRes> res) {
        NSLog(@"on accelerometer change = %@",res);
    };

}


@end
