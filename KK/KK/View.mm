//
//  Canvas.m
//  KK
//
//  Created by hailong11 on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "KKViewProtocol.h"

#include <ui/ui.h>
#include <ui/view.h>
#include <ui/CGContext.h>
#include <kk/dispatch.h>

namespace kk {
    
    namespace ui {
        
        extern kk::Strong<kk::ui::CG::Context> createCGContext(kk::Uint width,kk::Uint height);
        extern void displayCGContext(kk::ui::CG::Context * context,CFTypeRef view);
        extern kk::Strong<Image> createImageWithCGContext(kk::ui::CG::Context * context);
        
        class OSCanvas : public Canvas {
        public:
            
            OSCanvas():OSCanvas(nullptr) {
                
            }
            
            OSCanvas(CFTypeRef view):_width(0),_height(0),_resize(false) {
                @autoreleasepool {
                    _view = view;
                    CFRetain(view);
                    if(_view != nil) {
                        UIView * v = (__bridge UIView *) _view;
                        setWidth((kk::Uint) ceil( v.frame.size.width * v.layer.contentsScale));
                        setHeight((kk::Uint) ceil( v.frame.size.height * v.layer.contentsScale));
                    }
                }
            }
            
            virtual ~OSCanvas() {
                @autoreleasepool {
                    CFRelease(_view);
                }
            }
            
            virtual Strong<Object> getContext(kk::CString name) {
                
                if(name == nullptr ){
                    return nullptr;
                }
                
                if(_width == 0 || _height == 0) {
                    return nullptr;
                }
                
                if(strcmp(name, "2d") == 0) {
                    kk::Weak<OSCanvas> canvas = this;
                    kk::Strong<kk::ui::CG::Context> v = createCGContext(_width,_height);
                    _context = v;
                    if(_view != nil) {
                        DispatchQueue * queue = nullptr; //;
                        queue->async([v,canvas]()->void{
                            kk::Strong<OSCanvas> c = canvas.operator->();
                            if(c != nullptr) {
                                displayCGContext(v.operator->(),c->_view);
                            }
                        });
                    }
                }
                
                _resize = false;
                
                return nullptr;
            }
            
            virtual Uint width() {
                return _width;
            }
            
            virtual void setWidth(Uint v) {
                if(_width != v) {
                    _width = v;
                    _resize = true;
                }
            }
            
            virtual Uint height() {
                return _height;
            }
            
            virtual void setHeight(Uint v) {
                if(_height != v) {
                    _height = v;
                    _resize = true;
                }
            }
            
            virtual Strong<Image> toImage() {
                {
                    kk::ui::CG::Context * v =dynamic_cast<kk::ui::CG::Context *>(_context.get());
                    if(v) {
                        return createImageWithCGContext(v);
                    }
                }
                return nullptr;
            }
            
        protected:
            CFTypeRef _view;
            kk::Uint _width;
            kk::Uint _height;
            kk::Boolean _resize;
            kk::Strong<Object> _context;
        };
        
        class OSView : public View {
        public:
            
            OSView(CFTypeRef view) {
                @autoreleasepool {
                    _view = view;
                    CFRetain(view);
                    UIView * v = (__bridge UIView *) _view;
                    if([v respondsToSelector:@selector(KKViewObtain:)]) {
                        [(id<KKViewProtocol>) v KKViewObtain:(void *) _view];
                    }
                }
            }
            
            virtual ~OSView() {
                @autoreleasepool {
                    UIView * v = (__bridge UIView *) _view;
                    if([v respondsToSelector:@selector(KKViewRecycle:)]) {
                        [(id<KKViewProtocol>) v KKViewRecycle:(void *) _view];
                    }
                    CFRelease(_view);
                }
            }
            
            virtual void set(kk::CString name,kk::CString value) {
                @autoreleasepool {
                    UIView * v = (__bridge UIView *) _view;
                    if([v respondsToSelector:@selector(KKViewSetAttribute:value:)]) {
                        [(id<KKViewProtocol>) v KKViewSetAttribute:name value:value];
                    }
                }
            }
            
            virtual void setFrame(Rect & frame) {
                @autoreleasepool {
                    UIView * v = (__bridge UIView *) _view;
                    [v setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
                }
            }
            
            virtual void setContentSize(Size & size) {
                @autoreleasepool {
                    UIView * v = (__bridge UIView *) _view;
                    if([v isKindOfClass:[UIScrollView class]]) {
                        [(UIScrollView *) v setContentSize:CGSizeMake(size.width, size.height)];
                    }
                }
            }
            
            virtual void setContentOffset(Point & offset) {
                @autoreleasepool {
                    UIView * v = (__bridge UIView *) _view;
                    if([v isKindOfClass:[UIScrollView class]]) {
                        [(UIScrollView *) v setContentOffset:CGPointMake(offset.x, offset.y)];
                    }
                }
            }
            
            virtual Point contentOffset() {
                @autoreleasepool {
                    
                    UIView * v = (__bridge UIView *) _view;
                    
                    if([v isKindOfClass:[UIScrollView class]]) {
                        CGPoint p = [(UIScrollView *) v contentOffset];
                        return { (Float) p.x, (Float)  p.y};
                    }
                    
                    return {0,0};
                }
            }
            
            virtual void createCanvas(std::function<void(Canvas *)> && func,DispatchQueue * queue) {
                
                kk::Weak<OSView> v = this;
                
                queue->async([func,v]()->void{
                    
                    kk::Strong<OSView> view = v.operator->();
                    
                    if(view != nullptr) {
                        kk::Strong<Canvas> c = new OSCanvas(view->_view);
                        func(c);
                    }
                    
                });
                
            }
            
            virtual void addSubview(View * view,SubviewPosition position) {
                OSView * ov = dynamic_cast<OSView *>(view);
                if(ov == nullptr) {
                    return ;
                }
                @autoreleasepool {
                    UIView * v = (__bridge UIView *) _view;
                    UIView * b = (__bridge UIView *) ov->_view;
                    if(position == SubviewPositionFront) {
                        [v addSubview:b];
                    } else {
                        [v insertSubview:b atIndex:0];
                    }
                }
            }
            
            virtual void removeView() {
                @autoreleasepool {
                    UIView * v = (__bridge UIView *) _view;
                    [v removeFromSuperview];
                }
            }
            
        protected:
            CFTypeRef _view;
        };
        
        kk::Strong<View> createView(kk::CString name) {
            
            if(name == nullptr) {
                return nullptr;
            }
            
            @autoreleasepool {
                
                ::Class isa = NSClassFromString([NSString stringWithCString:name encoding:NSUTF8StringEncoding]);
                
                if(isa == nullptr) {
                    return nullptr;
                }
                
                UIView * view = [[isa alloc] initWithFrame:CGRectZero];
                
                return new OSView((__bridge CFTypeRef) view);
                
            }
            
        }
        
        kk::Strong<Canvas> createCanvas() {
            return new OSCanvas();
        }
        
    }
    
}
