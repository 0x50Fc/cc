//
//  KKPageViewController.m
//  KK
//
//  Created by hailong11 on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import "KKPageViewController.h"

@interface KKPageViewController ()

@end

@implementation KKPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if(_app != nil && _path != nil) {
        _page = [[KKPage alloc] initWithView:self.view app:_app];
        [_page run:_path query:_query];
    }
    
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
