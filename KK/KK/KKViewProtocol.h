//
//  KKViewProtocol.h
//  KK
//
//  Created by hailong11 on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKViewProtocol <NSObject>

-(void) KKViewObtain:(void *) view;

-(void) KKViewSetAttribute:(const char *) key value:(const char *) value;

-(void) KKViewRecycle:(void *) view;

@end

@protocol KKImageViewProtocol <KKViewProtocol>

-(void) KKViewDisplayImage:(UIImage *) image;

@end

