//
//  KKPageViewController.m
//  KK
//
//  Created by hailong11 on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import "KKPageViewController.h"
#import "KKObject.h"

@interface KKPageViewController () {
    CGSize _layoutSize;
}

@end

@implementation KKPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if(_app != nil && _path != nil) {
        _page = [[KKPage alloc] initWithView:self.view app:_app];
        _page.delegate = self;
        [_page run:_path query:_query];
    }
    
}


-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if(CGSizeEqualToSize(_layoutSize, self.view.bounds.size)) {
        _layoutSize = self.view.bounds.size;
        [_page setSize:_layoutSize];
    }
}

-(void) KKPage:(KKPage *) page setOptions:(id) options {
    self.title = [options kk_getString:@"title"];
}
    

@end
