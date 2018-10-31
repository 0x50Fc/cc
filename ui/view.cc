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
                    
                });
                
            });
            
        }
        
    }
    
}
