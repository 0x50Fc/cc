//
//  KKViewProtocol.h
//  KK
//
//  Created by hailong11 on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKViewProtocol <NSObject>

+(instancetype) KKViewCreate;

-(void) KKViewObtain:(void *) view;

-(void) KKViewSetAttribute:(const char *) key value:(const char *) value;

-(void) KKViewRecycle:(void *) view;

-(UIView *) KKViewContentView;

@end

@protocol KKImageViewProtocol <KKViewProtocol>

-(void) KKViewDisplayImage:(UIImage *) image;

@end

