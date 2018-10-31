//
//  UIView+KKViewProtocol.m
//  KK
//
//  Created by hailong11 on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import "UIView+KKViewProtocol.h"
#include <ui/ui.h>

@implementation UIView (KKViewProtocol)

-(void) KKViewObtain:(void *) view {
    
}

-(void) KKViewSetAttribute:(const char *) key value:(const char *) value {
    
    if(key == nullptr) {
        return ;
    }
    
    if(strcmp(key, "background-color") == 0) {
        kk::ui::Color v(value);
        self.backgroundColor = [UIColor colorWithRed:v.r green:v.g blue:v.b alpha:v.a];
    }
    
}

-(void) KKViewRecycle:(void *) view {
    
}

@end
