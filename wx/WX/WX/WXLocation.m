//
//  WXLocation.m
//  WX
//
//  Created by hailong11 on 2018/11/12.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXLocation.h"


@implementation WXShooseLocationRes

@synthesize address = _address;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize name = _name;

@end

@implementation WXShooseLocationObject

@synthesize fail = _fail;
@synthesize success = _success;
@synthesize complete = _complete;

@end

@implementation WXGetLocationRes

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize speed = _speed;
@synthesize accuracy = _accuracy;
@synthesize altitude = _altitude;
@synthesize verticalAccuracy = _verticalAccuracy;
@synthesize horizontalAccuracy = _horizontalAccuracy;

@end

@implementation WXGetLocationObject

@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;
@synthesize type = _type;
@synthesize altitude = _altitude;

@end

@implementation WX (WXLocation)

-(void) chooseLocation:(id<WXShooseLocationObject>) object {
    
}

-(void) getLocation:(id<WXShooseLocationObject>) object {
    
}

@end


