//
//  UIView+KKViewProtocol.m
//  KK
//
//  Created by zhanghailong on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import "UIView+KKViewProtocol.h"
#import "KKObject.h"
#include <ui/ui.h>
#include <ui/view.h>
#include <objc/runtime.h>


@implementation UIView (KKViewProtocol)

+(instancetype) KKViewCreateWithConfiguration:(void *)configuration {
    return [[self alloc] initWithFrame:CGRectZero];
}

-(UIView *) KKViewContentView {
    return self;
}

-(void) KKViewObtain:(void *) view {
    
}

-(void) KKViewSetAttribute:(const char *) key value:(const char *) value {
    
    if(key == nullptr) {
        return ;
    }
    
    if(strcmp(key, "background-color") == 0) {
        kk::ui::Color v(value);
        self.backgroundColor = [UIColor colorWithRed:v.r green:v.g blue:v.b alpha:v.a];
    } else if(strcmp(key, "transform") == 0) {
        kk::ui::Transform v = kk::ui::TransformFromString(value);
        self.transform = CGAffineTransformIdentity;
        self.transform = CGAffineTransformMake(v.a, v.b, v.c, v.d, v.tx, v.ty);
    }
    
}

-(void) KKViewRecycle:(void *) view {
    
}

@end

