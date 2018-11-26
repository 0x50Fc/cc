//
//  ScreenViewController.h
//  demo
//
//  Created by zuowu on 2018/11/26.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScreenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *labelGetScreenBrightness;
@property (weak, nonatomic) IBOutlet UITextField *labelSetScreenBrightness;
@property (weak, nonatomic) IBOutlet UILabel *labelOnUserCaptureScreen;

@end

NS_ASSUME_NONNULL_END
