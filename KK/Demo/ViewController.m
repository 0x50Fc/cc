//
//  ViewController.m
//  Demo
//
//  Created by zhanghailong on 2018/11/6.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "ViewController.h"
#import <KK/KK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doTapAction:(id)sender {
    
    KKApp * app = [[KKApp alloc] initWithBasePath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"main"]];
    
    [app run:@{}];
    
}
@end
