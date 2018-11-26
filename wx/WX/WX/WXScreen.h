//
//  WXScreen.h
//  WX
//
//  Created by zuowu on 2018/11/26.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <WX/WX.h>


@protocol WXGetScreenBrightnessRes <NSObject>
@property (nonatomic, assign) float value;
@property (nonatomic, copy) NSString * errMsg;
@end

@protocol WXSetScreenBrightnessRes <NSObject>
@property (nonatomic, copy) NSString * errMsg;
@end

@protocol WXSetKeepScreenOnRes <NSObject>
@property (nonatomic, copy) NSString * errMsg;
@end

@interface WXGetScreenBrightnessRes : NSObject <WXGetScreenBrightnessRes>
-(instancetype)initWithValue:(double) value errMsg:(NSString *) msg;
@end

@interface WXSetScreenBrightnessRes : NSObject <WXSetScreenBrightnessRes>
-(instancetype)initWithErrMsg: (NSString *) msg;
@end

@interface WXSetKeepScreenOnRes : NSObject <WXSetKeepScreenOnRes>
-(instancetype)initWithErrMsg: (NSString *) msg;
@end



typedef void (^WXGetScreenBrightnessObjectSuccess) (id<WXGetScreenBrightnessRes> res);
typedef void (^WXGetScreenBrightnessObjectFail) (id<WXGetScreenBrightnessRes> res);
typedef void (^WXGetScreenBrightnessObjectComplete) (id<WXGetScreenBrightnessRes> res);

@protocol WXGetScreenBrightnessObject <NSObject>

@property (nonatomic, strong) WXGetScreenBrightnessObjectSuccess success;
@property (nonatomic, strong) WXGetScreenBrightnessObjectFail fail;
@property (nonatomic, strong) WXGetScreenBrightnessObjectComplete complete;

@end

@interface WXGetScreenBrightnessObject : NSObject <WXGetScreenBrightnessObject>

@end



typedef void (^WXSetScreenBrightnessObjectSuccess) (id<WXSetScreenBrightnessRes> res);
typedef void (^WXSetScreenBrightnessObjectFail) (id<WXSetScreenBrightnessRes> res);
typedef void (^WXSetScreenBrightnessObjectComplete) (id<WXSetScreenBrightnessRes> res);

@protocol WXSetScreenBrightnessObject <NSObject>

@property (nonatomic, assign) double value;
@property (nonatomic, strong) WXSetScreenBrightnessObjectSuccess success;
@property (nonatomic, strong) WXSetScreenBrightnessObjectFail fail;
@property (nonatomic, strong) WXSetScreenBrightnessObjectComplete complete;

@end

@interface WXSetScreenBrightnessObject : NSObject <WXSetScreenBrightnessObject>

@end



typedef void (^WXSetKeepScreenOnObjectSuccess) (id<WXSetKeepScreenOnRes> res);
typedef void (^WXSetKeepScreenOnObjectFali) (id<WXSetKeepScreenOnRes> res);
typedef void (^WXSetKeepScreenOnObjectComplete) (id<WXSetKeepScreenOnRes> res);

@protocol WXSetKeepScreenOnObject <NSObject>

@property (nonatomic, assign) BOOL keepScreenOn;
@property (nonatomic, strong) WXSetKeepScreenOnObjectSuccess success;
@property (nonatomic, strong) WXSetKeepScreenOnObjectFali fail;
@property (nonatomic, strong) WXSetKeepScreenOnObjectComplete complete;

@end

@interface WXSetKeepScreenOnObject : NSObject <WXSetKeepScreenOnObject>

@end


typedef void (^WXOnUserCaptureScreen) (void);

@interface WX (WXScreen)
@property (nonatomic, strong) WXOnUserCaptureScreen onUserCaptureScreen;
-(void)getScreenBrightness:(id<WXGetScreenBrightnessObject>) object;
-(void)setScreenBrightness:(id<WXSetScreenBrightnessObject>) object;
-(void)setKeepScreenOn:(id<WXSetKeepScreenOnObject>) object;
@end


