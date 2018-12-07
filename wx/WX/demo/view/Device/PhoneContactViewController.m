//
//  PhoneContactViewController.m
//  demo
//
//  Created by zuowu on 2018/11/20.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "PhoneContactViewController.h"
#import "ViewController.h"

@interface PhoneContactViewController ()

@end

@implementation PhoneContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnAddPhoneContact:(id)sender {
    WX * wx = [ViewController shareWX];;
    wx.phoneContactViewController = self;
    WXAddPhoneContactObject * object = [[WXAddPhoneContactObject alloc] init];
    
    object.title = @"caption american";
    object.firstName = @"zuowu";
    object.middleName = @"";
    object.lastName = @"cao";
    object.nickName = @"zowoo";
    
    object.remark = @"remark";
    object.organization = @"sina";
    object.url = @"www.baidu.com";
    
    object.email = @"zuowu@staff.weibo.com";
    object.photoFilePath = @"";
    
    object.mobilePhoneNumber = @"1234abcd";
    object.workFaxNumber = @"1234abcd";
    object.workPhoneNumber = @"1234abcd";
    object.hostNumber = @"1234abcd";
    object.homeFaxNumber = @"1234abcd";
    object.homePhoneNumber = @"1234abcd";
    
    object.addressState = @"_addressState";
    object.addressCity = @"_addressCity";
    object.addressStreet = @"_addressStreet";
    object.addressPostalCode = @"_addressPostalCode";
    
    object.workAddressCountry = @"_workAddressCountry";
    object.workAddressState = @"_workAddressState";
    object.workAddressCity = @"_workAddressCity";
    object.workAddressStreet = @"_workAddressStreet";
    object.workAddressPostalCode = @"_workAddressPostalCode";
    
    object.homeAddressCountry = @"_homeAddressCountry";
    object.homeAddressState = @"_homeAddressState";
    object.homeAddressCity = @"_homeAddressCity";
    object.homeAddressStreet = @"_homeAddressStreet";
    object.homeAddressPostalCode = @"_homeAddressPostalCode";
    
    object.weChatNumber = @"caozuowuofwechat";
    object.sinaWeiboNumber = @"2636528421";
    object.sinaWeiboName = @"吧嘶光年";
    
    object.success = ^(id<WXAddPhoneContactRes> res) {
        NSLog(@"add contect success res = %@", res);
    };
    object.fail = ^(id<WXAddPhoneContactRes> res) {
        NSLog(@"add contect fail res = %@", res);
    };
    object.complete = ^(id<WXAddPhoneContactRes> res) {
        NSLog(@"add contect complete res = %@", res);
    };
    
    [wx addPhoneContact:object];

}



@end
