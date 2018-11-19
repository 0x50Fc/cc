//
//  WXClipboard.m
//  WX
//
//  Created by zuowu on 2018/11/19.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXClipboard.h"


@implementation WXSetClipboardRes

@synthesize errMsg = _errMsg;

-(instancetype) initWithErrMsg:(NSString *) msg{
    if (self = [super init]) {
        self.errMsg = msg;
    }
    return self;
}

-(NSString * )description{
    NSDictionary * dic = @{
                           @"errMsg": _errMsg,
                           };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end


@implementation WXGetClipboardRes

@synthesize errMsg = _errMsg;
@synthesize data = _data;

-(instancetype) initWithData:(NSString *)data errMsg:(NSString *)msg{
    if (self = [super init]) {
        self.data = data;
        self.errMsg = msg;
    }
    return self;
}

-(NSString * )description{
    NSDictionary * dic = @{
                           @"data": _data,
                           @"errMsg": _errMsg,
                           };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end


@implementation WXSetClipboardObject

@synthesize data = _data;
@synthesize success = _success;
@synthesize fali = _fali;
@synthesize complete = _complete;

@end


@implementation WXGetClipboardObject

@synthesize success = _success;
@synthesize fail = _fail;
@synthesize complete = _complete;

@end


@implementation WX(WXClipboard)

-(void)getClipboardData:(id<WXGetClipboardObject>) object{
    NSString * data = [UIPasteboard generalPasteboard].string;
    WXGetClipboardRes * res = [[WXGetClipboardRes alloc] initWithData:data errMsg:@"getClipboardData:ok"];
    object.success(res);
    object.complete(res);
}
-(void)setClipboardData:(id<WXSetClipboardObject>) object{
    [UIPasteboard generalPasteboard].string = object.data;
    WXSetClipboardRes * res = [[WXSetClipboardRes alloc] initWithErrMsg:@"setClipboardData:ok"];
    object.success(res);
    object.complete(res);
}

@end
