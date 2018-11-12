//
//  WXLocation.h
//  WX
//
//  Created by hailong11 on 2018/11/12.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WX/WXObject.h>

@protocol WXShooseLocationRes <NSObject>

@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * address;
@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;

@end

typedef void (^WXShooseLocationObjectSuccess)(id<WXShooseLocationRes> res);
typedef void (^WXShooseLocationObjectFail)(NSError * error);
typedef void (^WXShooseLocationObjectComplete)(void);

@protocol WXShooseLocationObject <NSObject>

@property(nonatomic,strong) WXShooseLocationObjectSuccess success;
@property(nonatomic,strong) WXShooseLocationObjectFail fail;
@property(nonatomic,strong) WXShooseLocationObjectComplete complete;

@end


@protocol WXGetLocationRes <NSObject>

@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;
@property(nonatomic,assign) double speed;
@property(nonatomic,assign) double accuracy;
@property(nonatomic,assign) double altitude;
@property(nonatomic,assign) double verticalAccuracy;
@property(nonatomic,assign) double horizontalAccuracy;

@end

typedef void (^WXGetLocationObjectSuccess)(id<WXGetLocationRes> res);
typedef void (^WXGetLocationObjectFail)(NSError * error);
typedef void (^WXGetLocationObjectComplete)(void);

@protocol WXGetLocationObject <NSObject>

@property(nonatomic,strong) WXGetLocationObjectSuccess success;
@property(nonatomic,strong) WXGetLocationObjectFail fail;
@property(nonatomic,strong) WXGetLocationObjectComplete complete;

@property(nonatomic,strong) NSString * type;
@property(nonatomic,assign) BOOL altitude;


@end


@interface WXShooseLocationRes : NSObject<WXShooseLocationRes>

@end

@interface WXShooseLocationObject  : NSObject<WXShooseLocationObject>

@end

@interface WXGetLocationRes : NSObject<WXGetLocationRes>

@end

@interface WXGetLocationObject : NSObject<WXGetLocationObject>

@end

@interface WX (WXLocation)

-(void) chooseLocation:(id<WXShooseLocationObject>) object;

-(void) getLocation:(id<WXShooseLocationObject>) object;

@end


