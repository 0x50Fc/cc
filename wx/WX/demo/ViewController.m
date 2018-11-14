//
//  ViewController.m
//  demo
//
//  Created by hailong11 on 2018/11/12.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    WX * wx = [[WX alloc] init];

//    WXChooseLocationRes * res = [[WXChooseLocationRes alloc] init];
//    res.name = @"a";
//    res.address = @"d";
    


}
    
    
-(IBAction)button:(id)sender{
    _wx = [[WX alloc] init];
    WXGetLocationObject * ob = [[WXGetLocationObject alloc]init];
    ob.success = ^(id<WXGetLocationRes> res) {
        NSLog(@"success");
        NSLog(@"%@",res);
    };
    ob.fail = ^(NSError *error) {
        
    };
    ob.complete = ^(id<WXGetLocationRes> res) {
        NSLog(@"complete");
        NSLog(@"%@",res);
    };
//    ob.type = @"gcj02";
    ob.altitude = YES;
    
    [_wx getLocation:ob];
}
    



@end
