//
//  KKViewProtocol.h
//  KK
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol KKViewProtocol <NSObject>

+(instancetype) KKViewCreateWithConfiguration:(void *) configuration;

-(void) KKViewObtain:(void *) view;

-(void) KKViewSetAttribute:(const char *) key value:(const char *) value;

-(void) KKViewRecycle:(void *) view;

-(UIView *) KKViewContentView;

@end




