//
//  WXMakePhoneCall.h
//  WX
//
//  Created by zuowu on 2018/11/22.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <WX/WX.h>

#pragma mark -- call --

@protocol WXMakePhoneCallRes <NSObject>

@property (nonatomic, copy) NSString * errMsg;

@end

typedef void (^WXMakePhoneCallObjectSuccess) (id<WXMakePhoneCallRes> res) ;
typedef void (^WXMakePhoneCallObjectFail) (id<WXMakePhoneCallRes> res) ;
typedef void (^WXMakePhoneCallObjectComplete) (id<WXMakePhoneCallRes> res) ;

@protocol WXMakePhoneCallObject <NSObject>

@property (nonatomic, assign) NSString * phoneNumber;
@property (nonatomic, strong) WXMakePhoneCallObjectSuccess success;
@property (nonatomic, strong) WXMakePhoneCallObjectFail fail;
@property (nonatomic, strong) WXMakePhoneCallObjectComplete complete;

@end

@interface WXMakePhoneCallRes : NSObject <WXMakePhoneCallRes>

-(instancetype) initWithErrMsg:(NSString *) msg;

@end

@interface WXMakePhoneCallObject : NSObject <WXMakePhoneCallObject>

@end

#pragma mark -- wx --

@interface WX (WXMakePhoneCall)

@property (nonatomic, strong) UIViewController * phoneCallViewController;

-(void)makePhoneCall:(id<WXMakePhoneCallObject>) object;

@end


