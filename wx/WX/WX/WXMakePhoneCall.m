//
//  WXMakePhoneCall.m
//  WX
//
//  Created by zuowu on 2018/11/22.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXMakePhoneCall.h"

#define PhoneCallViewControllerKey "PhoneCallViewControllerKey"

#pragma mark -- call --

@implementation WXMakePhoneCallRes

@synthesize errMsg = _errMsg;

-(instancetype) initWithErrMsg:(NSString *) msg{
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@}", self.errMsg];
}

@end

@implementation WXMakePhoneCallObject

@synthesize phoneNumber = _phoneNumber;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;

@end

#pragma mark -- wx --

@implementation WX (WXMakePhoneCall)

-(UIViewController *)phoneCallViewController{
    return objc_getAssociatedObject(self, PhoneCallViewControllerKey);
}
-(void)setPhoneCallViewController:(UIViewController *)phoneCallViewController{
    objc_setAssociatedObject(self, PhoneCallViewControllerKey, phoneCallViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)makePhoneCall:(id<WXMakePhoneCallObject>) object {
    
    if (self.phoneCallViewController != nil) {
        
        UIAlertController * actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString * str = [NSString stringWithFormat:@"呼叫 %@", object.phoneNumber];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableString * callPhone = [NSMutableString stringWithFormat:@"tel:%@",object.phoneNumber];

            if (@available(iOS 10.0, *)) {

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        WXMakePhoneCallRes * res = [[WXMakePhoneCallRes alloc] initWithErrMsg:@"makePhoneCall:ok"];
                        object.success(res);
                        object.complete(res);
                    }else{
                        WXMakePhoneCallRes * res = [[WXMakePhoneCallRes alloc] initWithErrMsg:@"makePhoneCall:fail unknow"];
                        object.fail(res);
                        object.complete(res);
                    }
                }];
                
            } else {
                    // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                WXMakePhoneCallRes * res = [[WXMakePhoneCallRes alloc] initWithErrMsg:@"makePhoneCall:ok"];
                object.success(res);
                object.complete(res);
            }
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            WXMakePhoneCallRes * res = [[WXMakePhoneCallRes alloc] initWithErrMsg:@"makePhoneCall:fail cancel"];
            object.fail(res);
            object.complete(res);
        }];
        
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        
        [self.phoneCallViewController presentViewController:actionSheet animated:YES completion:nil];
    }
}

@end
