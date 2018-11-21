//
//  WXPhoneContact.h
//  WX
//
//  Created by zuowu on 2018/11/19.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <WX/WX.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>


@protocol WXAddPhoneContactRes <NSObject>

@property (nonatomic, copy) NSString * errMsg;

@end

typedef void (^WXAddPhoneContactObjectSuccess) (id<WXAddPhoneContactRes> res);
typedef void (^WXAddPhoneContactObjectFail) (id<WXAddPhoneContactRes> res);
typedef void (^WXAddPhoneContactObjectComplete) (id<WXAddPhoneContactRes> res);

@protocol WXAddPhoneContactObject <NSObject>

@property (nonatomic, strong) WXAddPhoneContactObjectSuccess success;
@property (nonatomic, strong) WXAddPhoneContactObjectFail fail;
@property (nonatomic, strong) WXAddPhoneContactObjectComplete complete;

//基本信息
@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * lastName;
@property (nonatomic, copy) NSString * middleName;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * photoFilePath;
@property (nonatomic, copy) NSString * organization;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * url;

//电话
@property (nonatomic, copy) NSString * mobilePhoneNumber;
@property (nonatomic, copy) NSString * workFaxNumber;
@property (nonatomic, copy) NSString * workPhoneNumber;
@property (nonatomic, copy) NSString * hostNumber;
@property (nonatomic, copy) NSString * homeFaxNumber;
@property (nonatomic, copy) NSString * homePhoneNumber;

//社交媒体
@property (nonatomic, copy) NSString * weChatNumber;
@property (nonatomic, copy) NSString * sinaWeiboNumber;
@property (nonatomic, copy) NSString * sinaWeiboName;

//地址 联系 工作 住宅
@property (nonatomic, copy) NSString * addressState;
@property (nonatomic, copy) NSString * addressCity;
@property (nonatomic, copy) NSString * addressStreet;
@property (nonatomic, copy) NSString * addressPostalCode;

@property (nonatomic, copy) NSString * workAddressCountry;
@property (nonatomic, copy) NSString * workAddressState;
@property (nonatomic, copy) NSString * workAddressCity;
@property (nonatomic, copy) NSString * workAddressStreet;
@property (nonatomic, copy) NSString * workAddressPostalCode;

@property (nonatomic, copy) NSString * homeAddressCountry;
@property (nonatomic, copy) NSString * homeAddressState;
@property (nonatomic, copy) NSString * homeAddressCity;
@property (nonatomic, copy) NSString * homeAddressStreet;
@property (nonatomic, copy) NSString * homeAddressPostalCode;

@end


@interface  WXAddPhoneContactRes : NSObject <WXAddPhoneContactRes>

-(instancetype)initWithErrMsg:(NSString *) msg;

@end


@interface WXAddPhoneContactObject : NSObject <WXAddPhoneContactObject>

@end


@interface WX (WXPhoneContact) <CNContactPickerDelegate, CNContactViewControllerDelegate>

@property (nonatomic, strong) WXAddPhoneContactObject * addPhoneContactObject;
@property (nonatomic, strong) UIViewController * phoneContactViewController;
-(void) addPhoneContact:(id<WXAddPhoneContactObject>) object;

@end


@interface CNMutableContact (WXPhoneContact)

-(instancetype)initWithWXAddPhoneContactObject:(WXAddPhoneContactObject *) object;
-(instancetype)updateWithMutableContact:(CNMutableContact *)contact;

@end




