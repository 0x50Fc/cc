//
//  KKPage.m
//  KK
//
//  Created by zhanghailong on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import "KKPage.h"
#import "KKObject.h"
#include <ui/ui.h>
#include <ui/page.h>

namespace kk {
    namespace ui {
        extern kk::Strong<View> createView(CFTypeRef view,kk::ui::ViewConfiguration * config,kk::ui::Context * context);
    }
}

@interface KKPage() {
    kk::ui::Page * _page;
}

-(void) setOptions:(id) options;

@end

@implementation KKPage

-(instancetype) initWithView:(UIView *) view app:(KKApp *) app {
    if((self = [super init])) {
        _app = app;
        _view = view;
        kk::Strong<kk::ui::View> v = kk::ui::createView((__bridge CFTypeRef) view,nullptr,(kk::ui::Context *) [app CPointer]);
        _page = new kk::ui::Page((kk::ui::App *)[_app CPointer],v);
        {
            kk::ui::Size s = {(kk::ui::Float)view.bounds.size.width,(kk::ui::Float)view.bounds.size.height};
            _page->setSize(s);
        }
        _page->retain();
        
        CFTypeRef page = (__bridge CFTypeRef) self;
        
        _page->on("options", new kk::TFunction<void,kk::Event *>([page](kk::Event * event)->void{
            
            @autoreleasepool {
                KKPage * p = (__bridge KKPage *) page;
                kk::Any v = event->data();
                id object = KKObjectFromAny(v);
                [p setOptions:object];
            }
            
        }));
        
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

-(void) setSize:(CGSize) size {
    kk::ui::Size s = {(kk::ui::Float)size.width,(kk::ui::Float)size.height};
    _page->setSize(s);
}

-(void) setOptions:(id) options {
    if([(id)_delegate respondsToSelector:@selector(KKPage:setOptions:)]) {
        [_delegate KKPage:self setOptions:options];
    }
}

@end
