//
//  WXClipboard.h
//  WX
//
//  Created by zuowu on 2018/11/19.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <WX/WX.h>


@protocol WXClipboardRes <NSObject>

@optional
@property (nonatomic, copy) NSString * errMsg; /*all*/
@property (nonatomic, copy) NSString * data;   /*getClipboardRes*/

@end


typedef void (^WXSetClipboardObjectSuccess) (id<WXClipboardRes> res);
typedef void (^WXSetClipboardObjectFail) (NSError * error);
typedef void (^WXSetClipboardObjectComplete) (id<WXClipboardRes> res);

@protocol WXSetClipboardObject <NSObject>

@property (nonatomic, copy) NSString * data;
@property (nonatomic, strong) WXSetClipboardObjectSuccess success;
@property (nonatomic, strong) WXSetClipboardObjectFail fali;
@property (nonatomic, strong) WXSetClipboardObjectComplete complete;

@end


typedef void (^WXGetClipboardObjectSuccess) (id<WXClipboardRes> res);
typedef void (^WXGetClipboardObjectFail) (NSError * error);
typedef void (^WXGetClipboardObjectComplete) (id<WXClipboardRes> res);

@protocol WXGetClipboardObject <NSObject>

@property (nonatomic, strong) WXGetClipboardObjectSuccess success;
@property (nonatomic, strong) WXGetClipboardObjectFail fail;
@property (nonatomic, strong) WXGetClipboardObjectComplete complete;

@end


@interface WXSetClipboardRes : NSObject <WXClipboardRes>

-(instancetype) initWithErrMsg:(NSString *) msg;

@end


@interface WXGetClipboardRes : NSObject <WXClipboardRes>

-(instancetype) initWithData:(NSString *) data errMsg:(NSString *) msg;

@end


@interface WXSetClipboardObject : NSObject <WXSetClipboardObject>

@end


@interface WXGetClipboardObject : NSObject <WXGetClipboardObject>


@end


@interface WX (WXClipboard)

-(void)getClipboardData:(id<WXGetClipboardObject>) object;
-(void)setClipboardData:(id<WXSetClipboardObject>) object;

@end


