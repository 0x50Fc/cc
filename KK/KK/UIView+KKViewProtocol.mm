//
//  UIView+KKViewProtocol.m
//  KK
//
//  Created by hailong11 on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import "UIView+KKViewProtocol.h"
#include <ui/ui.h>
#include <ui/view.h>
#include <objc/runtime.h>

@implementation UIView (KKViewProtocol)

+(instancetype) KKViewCreate {
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
    }
    
}

-(void) KKViewRecycle:(void *) view {
    
}

@end

@interface UIScrollViewKKViewProtocol : NSObject

@end

@implementation UIScrollViewKKViewProtocol

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint v = [(UIScrollView *) object contentOffset];
        if(context != nullptr){
            kk::ui::View * view = (kk::ui::View *) context;
            kk::ui::Point p = { (kk::ui::Float) v.x, (kk::ui::Float) v.y};
            view->setContentOffset(p);
        }
    }
}

@end

@implementation UIScrollView (KKViewProtocol)

-(void) KKViewObtain:(void *) view {
    [super KKViewObtain:view];
    UIScrollViewKKViewProtocol * object = [[UIScrollViewKKViewProtocol alloc] init];
    objc_setAssociatedObject(self, "__UIScrollViewKKViewProtocol", object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addObserver:object forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:view];
}

-(void) KKViewRecycle:(void *) view {
    [super KKViewRecycle:view];
    UIScrollViewKKViewProtocol * object = objc_getAssociatedObject(self, "__UIScrollViewKKViewProtocol");
    if(object != nil) {
        [self removeObserver:object forKeyPath:@"contentOffset" context:view];
        objc_setAssociatedObject(self, "__UIScrollViewKKViewProtocol", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end

@implementation WKWebView (KKViewProtocol)

+(instancetype) KKViewCreate {
    WKWebView * view = [[self alloc] initWithFrame:CGRectZero configuration:[[WKWebViewConfiguration alloc] init]];
    [view setOpaque:NO];
    return view;
}

-(void) KKViewObtain:(void *) view {
    [super KKViewObtain:view];
    [self.scrollView KKViewObtain:view];
}

-(void) KKViewRecycle:(void *) view {
    [super KKViewRecycle:view];
    [self.scrollView KKViewRecycle:view];
}

-(UIView *) KKViewContentView {
    return self.scrollView;
}

-(void) KKViewSetAttribute:(const char *) key value:(const char *) value {
    
    [super KKViewSetAttribute:key value:value];
    
    if(key == nullptr) {
        return ;
    }
    
    if(strcmp(key, "src") == 0) {
        if(value != nullptr) {
            @try {
                NSURL * u = [NSURL URLWithString:[NSString stringWithCString:value encoding:NSUTF8StringEncoding]];
                [self loadRequest:[NSURLRequest requestWithURL:u]];
            }
            @catch(NSException * ex) {
                NSLog(@"[KK] %@",ex);
            }
        }
    } else if(strcmp(key, "#text") == 0) {
        if(value != nullptr) {
            [self loadHTMLString:[NSString stringWithCString:value encoding:NSUTF8StringEncoding] baseURL:nil];
        }
    }
    
}

@end


