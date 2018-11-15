//
//  ViewController.h
//  demo
//
//  Created by hailong11 on 2018/11/12.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <WX/WX.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray * _arrVC;
    WX * _wx;
    UITableView * _tableView;
}

@end

