//
//  WXPhoneContact.m
//  WX
//
//  Created by zuowu on 2018/11/19.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXPhoneContact.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>


#define WXPhoneContactViewControllerKey "WXPhoneContactViewControllerKey"
#define WXAddPhoneContactObjectKey "WXAddPhoneContactObjectKey"


@implementation WXAddPhoneContactRes

@synthesize errMsg = _errMsg;

-(instancetype)initWithErrMsg:(NSString *)msg{
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"{errMsg:%@}",self.errMsg];
}
@end


@implementation WXAddPhoneContactObject

@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;

//基本信息
@synthesize firstName = _firstName;
@synthesize nickName = _nickName;
@synthesize lastName = _lastName;
@synthesize middleName = _middleName;
@synthesize title = _title;
@synthesize remark = _remark;
@synthesize organization = _organization;
@synthesize url = _url;

//邮箱
@synthesize email = _email;

//头像
@synthesize photoFilePath = _photoFilePath;

//电话
@synthesize mobilePhoneNumber = _mobilePhoneNumber;
@synthesize workFaxNumber = _workFaxNumber;
@synthesize workPhoneNumber = _workPhoneNumber;
@synthesize hostNumber = _hostNumber;
@synthesize homeFaxNumber = _homeFaxNumber;
@synthesize homePhoneNumber = _homePhoneNumber;

//邮政地址
@synthesize addressState = _addressState;
@synthesize addressCity = _addressCity;
@synthesize addressStreet = _addressStreet;
@synthesize addressPostalCode = _addressPostalCode;

//工作地址
@synthesize workAddressCountry = _workAddressCountry;
@synthesize workAddressState = _workAddressState;
@synthesize workAddressCity = _workAddressCity;
@synthesize workAddressStreet = _workAddressStreet;
@synthesize workAddressPostalCode = _workAddressPostalCode;

//住宅地址
@synthesize homeAddressCountry = _homeAddressCountry;
@synthesize homeAddressState = _homeAddressState;
@synthesize homeAddressCity = _homeAddressCity;
@synthesize homeAddressStreet = _homeAddressStreet;
@synthesize homeAddressPostalCode = _homeAddressPostalCode;


//社交账号
@synthesize weChatNumber = _weChatNumber;
@synthesize sinaWeiboNumber = _sinaWeiboNumber;
@synthesize sinaWeiboName = _sinaWeiboName;

@end


@implementation WX (WXPhoneContact)

-(WXAddPhoneContactObject *)addPhoneContactObject{
    return objc_getAssociatedObject(self, WXAddPhoneContactObjectKey);
}

-(void)setAddPhoneContactObject:(WXAddPhoneContactObject *)addPhoneContactObject{
    objc_setAssociatedObject(self, WXAddPhoneContactObjectKey, addPhoneContactObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIViewController *)phoneContactViewController{
    return objc_getAssociatedObject(self, WXPhoneContactViewControllerKey);
}

-(void)setPhoneContactViewController:(UIViewController *)phoneContactViewController{
    objc_setAssociatedObject(self, WXPhoneContactViewControllerKey, phoneContactViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) addPhoneContact:(id<WXAddPhoneContactObject>) object {
    
    self.addPhoneContactObject = object;
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {

        if (granted) {
            [self createContact];
        } else {
            WXAddPhoneContactRes * res = [[WXAddPhoneContactRes alloc] initWithErrMsg:@"addPhoneContact: request contact access fail cancel"];
            object.fail(res);
            object.complete(res);
        }
    }];

}

-(void)createContact{
    
    if (self.phoneContactViewController != nil) {
        
        UIAlertController * actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"创建新联系人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.phoneContactViewController != nil) {
                CNMutableContact * contact = [[CNMutableContact alloc] initWithWXAddPhoneContactObject:self.addPhoneContactObject];
                CNContactViewController * vc = [CNContactViewController  viewControllerForNewContact:contact];
                vc.delegate = self;
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self.phoneContactViewController presentViewController:nav animated:YES completion:nil];
            }
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"添加到现有联系人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            CNContactPickerViewController * pickerVC = [[CNContactPickerViewController alloc] init];
            pickerVC.delegate = self;
            [self.phoneContactViewController presentViewController:pickerVC animated:YES completion:nil];
            
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            WXAddPhoneContactRes * res = [[WXAddPhoneContactRes alloc] initWithErrMsg:@"addPhoneContact:fail cancel"];
            self.addPhoneContactObject.fail(res);
            self.addPhoneContactObject.complete(res);
        }];
        
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [actionSheet addAction:action3];
        [self.phoneContactViewController presentViewController:actionSheet animated:YES completion:nil];
            
    }
}

#pragma mark -- CNContactViewControllerDelegate
- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property{
    return NO;
}

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    
    if (contact == nil) {
        WXAddPhoneContactRes * res = [[WXAddPhoneContactRes alloc] initWithErrMsg:@"addPhoneContact:fail cancel"];
        self.addPhoneContactObject.fail(res);
        self.addPhoneContactObject.complete(res);
    }else{
        WXAddPhoneContactRes * res = [[WXAddPhoneContactRes alloc] initWithErrMsg:@"addPhoneContact:ok"];
        self.addPhoneContactObject.fail(res);
        self.addPhoneContactObject.complete(res);
    }
    [self.phoneContactViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --  CNContactPickerDelegate

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    [self.phoneContactViewController dismissViewControllerAnimated:YES completion:^{
        WXAddPhoneContactRes * res = [[WXAddPhoneContactRes alloc] initWithErrMsg:@"addPhoneContact:fail cancel"];
        self.addPhoneContactObject.fail(res);
        self.addPhoneContactObject.complete(res);
    }];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{

    [self.phoneContactViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismiss");
        CNMutableContact * aa = [contact mutableCopy];
        CNMutableContact * bb= [[CNMutableContact alloc] initWithWXAddPhoneContactObject:self.addPhoneContactObject];
        [aa updateWithMutableContact:bb];
        CNContactViewController * vc = [CNContactViewController  viewControllerForNewContact:aa];
        vc.delegate = self;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.phoneContactViewController presentViewController:nav animated:YES completion:nil];
    }];

}

@end


@implementation CNMutableContact (WXPhoneContact)

-(instancetype)initWithWXAddPhoneContactObject:(WXAddPhoneContactObject *) object {
    
    if (self = [super init]) {
        
        //名称 备注
        self.givenName = object.firstName;
        self.nickname = object.nickName;
        self.familyName = object.lastName;
        self.middleName = object.middleName;
        self.note = object.remark;
        self.jobTitle = object.title;
        self.organizationName = object.organization;
        
        //url
        CNLabeledValue * homeurl = [CNLabeledValue labeledValueWithLabel:CNLabelURLAddressHomePage value:object.url];
        self.urlAddresses = @[homeurl];

        //邮箱
        CNLabeledValue * homeEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:object.email];
        self.emailAddresses = @[homeEmail];
        
        //头像路径
        self.imageData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:object.photoFilePath]);
        
        //社交账号
        CNSocialProfile * wxProfile = [[CNSocialProfile alloc] initWithUrlString:nil username:nil userIdentifier:object.weChatNumber service:@"WeChat"];
        CNLabeledValue * wxProfileLabelValue = [CNLabeledValue labeledValueWithLabel:@"微信" value:wxProfile];
        
        CNSocialProfile * wbProfile = [[CNSocialProfile alloc] initWithUrlString:@"http://www.weibo.com" username:object.sinaWeiboName userIdentifier:object.sinaWeiboNumber service:CNSocialProfileServiceSinaWeibo];
        CNLabeledValue * wbProfileLabelValue = [CNLabeledValue labeledValueWithLabel:@"微博" value:wbProfile];
        self.socialProfiles = @[wxProfileLabelValue, wbProfileLabelValue];
        
        //电话号码
        CNLabeledValue * mobile = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:object.mobilePhoneNumber]];
        CNLabeledValue * workFox = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberWorkFax value:[CNPhoneNumber phoneNumberWithStringValue:object.workFaxNumber]];
        CNLabeledValue * work = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:[CNPhoneNumber phoneNumberWithStringValue:object.workPhoneNumber]];
        CNLabeledValue * host = [CNLabeledValue labeledValueWithLabel:@"公司电话" value:[CNPhoneNumber phoneNumberWithStringValue:object.hostNumber]];
        CNLabeledValue * homeFox = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberHomeFax value:[CNPhoneNumber phoneNumberWithStringValue:object.homeFaxNumber]];
        CNLabeledValue * home = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMain value:[CNPhoneNumber phoneNumberWithStringValue:object.homePhoneNumber]];
        self.phoneNumbers = @[mobile, workFox, work, host, homeFox, home];
        
        //地址
        CNMutablePostalAddress * postalAddress = [[CNMutablePostalAddress alloc] init];
        postalAddress.state = object.addressState;
        postalAddress.city = object.addressCity;
        postalAddress.street = object.addressStreet;
        postalAddress.postalCode = object.addressPostalCode;
        CNLabeledValue * addressLabelValue = [CNLabeledValue labeledValueWithLabel:@"联系地址" value:postalAddress];
        
        //工作地址
        CNMutablePostalAddress * workAddress = [[CNMutablePostalAddress alloc] init];
        workAddress.state = object.workAddressState;
        workAddress.country = object.workAddressCountry;
        workAddress.city = object.workAddressCity;
        workAddress.street = object.workAddressStreet;
        workAddress.postalCode = object.workAddressPostalCode;
        CNLabeledValue * workAddressLabelValue = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:workAddress];
        
        //住宅地址
        CNMutablePostalAddress * homeAddress = [[CNMutablePostalAddress alloc] init];
        homeAddress.state = object.homeAddressState;
        homeAddress.country = object.homeAddressCountry;
        homeAddress.city = object.homeAddressCity;
        homeAddress.street = object.homeAddressStreet;
        homeAddress.postalCode = object.homeAddressPostalCode;
        CNLabeledValue * homeAddressLabelValue = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:homeAddress];
        
        //地址
        self.postalAddresses = @[addressLabelValue, workAddressLabelValue, homeAddressLabelValue];
        
    }
    return self;
}

-(instancetype)updateWithMutableContact:(CNMutableContact *)contact {
    if (contact != nil) {
        //名称 备注
        if (contact.givenName) {
            self.givenName = contact.givenName;
        }
        if (contact.nickname) {
            self.nickname = contact.nickname;
        }
        if (contact.familyName) {
            self.familyName = contact.familyName;
        }
        if (contact.note) {
            self.note = contact.note;
        }
        if (contact.jobTitle) {
            self.jobTitle = contact.jobTitle;
        }
        if (contact.organizationName) {
            self.organizationName = contact.organizationName;
        }
        
        //url
        self.urlAddresses = [self.urlAddresses arrayByAddingObjectsFromArray:contact.urlAddresses];

        //邮箱
        self.emailAddresses = [self.emailAddresses arrayByAddingObjectsFromArray:contact.emailAddresses];

        //头像路径
        if (contact.imageData) { self.imageData = contact.imageData; }

        //社交账号
        self.socialProfiles = [self.socialProfiles arrayByAddingObjectsFromArray:contact.socialProfiles];

        //电话号码
        self.phoneNumbers = [self.phoneNumbers arrayByAddingObjectsFromArray:contact.phoneNumbers];

        //地址
        self.postalAddresses = [self.postalAddresses arrayByAddingObjectsFromArray:contact.postalAddresses];
    }
    return self;
}

@end



