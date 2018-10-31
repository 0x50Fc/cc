//
//  KKPage.m
//  KK
//
//  Created by hailong11 on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import "KKPage.h"
#include <ui/ui.h>
#include <ui/page.h>

namespace kk {
    namespace ui {
        extern kk::Strong<View> createView(CFTypeRef view);
    }
}

@interface KKPage() {
    kk::ui::Page * _page;
}

@end

@implementation KKPage

-(instancetype) initWithView:(UIView *) view app:(KKApp *) app {
    if((self = [super init])) {
        _app = app;
        _view = view;
        kk::Strong<kk::ui::View> v = kk::ui::createView((__bridge CFTypeRef) view);
        _page = new kk::ui::Page((kk::ui::App *)[_app CPointer],v);
        _page->retain();
    }
    return self;
}

-(void) dealloc{
    _page->off();
    _page->release();
}

-(KKPageCPointer) CPointer {
    return _page;
}

-(void) run:(NSString *) path query:(NSDictionary<NSString *,NSString *> *) query {
    kk::Strong<kk::TObject<kk::String, kk::String>> q = new kk::TObject<kk::String, kk::String>();
    NSEnumerator * keyEnum = [query keyEnumerator];
    NSString * key;
    while((key = [keyEnum nextObject])) {
        NSString * value = [query valueForKey:key];
        (*q)[[key UTF8String]] = [value UTF8String];
    }
    _page->run([path UTF8String], q);
}

@end
