//
//  WXLocation.h
//  WX
//
//  Created by hailong11 on 2018/11/12.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WX/WXObject.h>

@protocol WXChooseLocationRes <NSObject>

@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * address;
@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;

@end

@protocol WXChooseLocationObject <NSObject>

-(void) success:(id<WXChooseLocationRes>) res;
-(void) fail:(NSString *) errmsg;
-(void) complete;

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

@protocol WXGetLocationObject <NSObject>

@property(nonatomic,strong) NSString * type;
@property(nonatomic,assign) BOOL altitude;

-(void) success:(id<WXGetLocationRes>) res;
-(void) fail:(NSString *) errmsg;
-(void) complete;

@end


@interface WXChooseLocationRes : NSObject<WXChooseLocationRes>

@end


@interface WXGetLocationRes : NSObject<WXGetLocationRes>

@end

@interface WX (WXLocation)

-(void) chooseLocation:(id<WXChooseLocationObject>) object;

-(void) getLocation:(id<WXGetLocationObject>) object;

@end


