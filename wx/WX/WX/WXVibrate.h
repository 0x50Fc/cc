//
//  WXVibrate.h
//  WX
//
//  Created by zuowu on 2018/11/26.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <WX/WX.h>

@protocol WXVibrateLongRes <NSObject>
@property (nonatomic, copy) NSString * errMsg;
@end

@protocol WXVibrateShortRes <NSObject>
@property (nonatomic, copy) NSString * errMsg;
@end

@interface WXVibrateLongRes : NSObject <WXVibrateLongRes>
-(instancetype)initWithErrMsg:(NSString *)msg;
@end

@interface WXVibrateShortRes : NSObject <WXVibrateShortRes>
-(instancetype)initWithErrMsg:(NSString *)msg;
@end


typedef void (^WXVibrateLongObjectSuccess)(id<WXVibrateLongRes> res);
typedef void (^WXVibrateLongObjectFail)(id<WXVibrateLongRes> res);
typedef void (^WXVibrateLongObjectComplete)(id<WXVibrateLongRes> res);

@protocol WXVibrateLongObject <NSObject>
@property (nonatomic, strong) WXVibrateLongObjectSuccess success;
@property (nonatomic, strong) WXVibrateLongObjectFail fail;
@property (nonatomic, strong) WXVibrateLongObjectComplete complete;
@end

@interface WXVibrateLongObject : NSObject <WXVibrateLongObject>

@end

typedef void (^WXVibrateShortObjectSuccess)(id<WXVibrateShortRes> res);
typedef void (^WXVibrateShortObjectFail)(id<WXVibrateShortRes> res);
typedef void (^WXVibrateShortObjectSuccess)(id<WXVibrateShortRes> res);

@protocol WXVibrateShortObject <NSObject>
@property (nonatomic, strong) WXVibrateShortObjectSuccess success;
@property (nonatomic, strong) WXVibrateShortObjectFail fail;
@property (nonatomic, strong) WXVibrateShortObjectSuccess complete;
@end

@interface WXVibrateShortObject : NSObject <WXVibrateShortObject>

@end

@interface WX (WXVibrate)

-(void)virateLong:(id<WXVibrateLongObject>) object;

@end


