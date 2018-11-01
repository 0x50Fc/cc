//
//  view.cpp
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <ui/view.h>

namespace kk {
    
    namespace ui {
    
        void View::addSubview(View * view,SubviewPosition position) {
            view->View::removeView();
            view->_parent = this;
            _subviews[view] = view;
        }
        
        void View::removeView() {
            if(_parent != nullptr) {
                auto i = _parent->_subviews.find(this);
                if(i != _parent->_subviews.end()) {
                    _parent->_subviews.erase(i);
                }
                _parent = nullptr;
            }
        }
        
        void View::setFrame(Float x,Float y,Float width,Float height) {
            Rect r = {{x,y},{width,height}};
            setFrame(r);
        }
        
        void View::setContentSize(Float width,Float height) {
            Size s = {width,height};
            setContentSize(s);
        }
        
        kk::Strong<View> View::obtainView(kk::CString reuse) {
            
            auto i = _obtainViews.find(reuse);
            
            if(i != _obtainViews.end()) {
                auto q = i->second;
                auto n = q.begin();
                if(n != q.end()) {
                    kk::Strong<View> v = * n;
                    q.erase(n);
                    return v;
                }
            }
            
            return nullptr;
        }
        
        void View::recycleView(View * view,kk::CString reuse) {
            
            auto i = _obtainViews.find(reuse);
            
            if(i != _obtainViews.end()) {
                i->second.push_back(view);
            } else {
                _obtainViews[reuse] = {view};
            }
            
        }
        
        void View::removeRecycleViews() {
            
            auto i = _obtainViews.begin();
            
            while(i != _obtainViews.end()) {
                
                auto q = i->second;
                auto n = q.begin();
                
                while(n != q.end()) {
                    View * view = *n;
                    view->removeView();
                    n ++;
                }
                
                i ++;
            }
            
        }
        
        void View::Openlib() {
            
            kk::Openlib<>::add([](duk_context * ctx)->void{
                
                kk::PushInterface<View>(ctx, [](duk_context * ctx)->void{
                    
                    kk::PutMethod<View,void,kk::CString,kk::CString>(ctx, -1, "set", &View::set);
                    kk::PutMethod<View,void,kk::ui::Float,kk::ui::Float,kk::ui::Float,kk::ui::Float>(ctx, -1, "setFrame", &View::setFrame);
                    kk::PutMethod<View,void,kk::ui::Float,kk::ui::Float>(ctx, -1, "setContentSize", &View::setContentSize);
                    kk::PutMethod<View,void,View *,SubviewPosition>(ctx, -1, "addSubview", &View::addSubview);
                    kk::PutMethod<View,void>(ctx, -1, "removeView", &View::removeView);
                    kk::PutMethod<View,void,CString>(ctx, -1, "evaluateJavaScript", &View::evaluateJavaScript);
                    kk::PutProperty<View,Point>(ctx, -1, "contentOffset", &View::contentOffset);
                    
                    duk_push_string(ctx, "create");
                    kk::PushFunction(ctx, (Any (*)(CString))([](CString name)->Any{
                        Strong<View> v = createView(name);
                        return Any(v.get());
                    }));
                    
                    duk_def_prop(ctx, -4, DUK_DEFPROP_HAVE_VALUE | DUK_DEFPROP_CLEAR_WRITABLE | DUK_DEFPROP_SET_ENUMERABLE | DUK_DEFPROP_SET_CONFIGURABLE);
                    
                });
                
            });
            
        }
        
    }
    
}