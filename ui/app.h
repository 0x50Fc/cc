//
//  app.h
//  KK
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef ui_app_h
#define ui_app_h

#include <ui/ui.h>
#include <ui/view.h>

namespace kk {
    
    namespace ui {
        
        class App : public Context {
        public:
            App(kk::CString basePath);
            virtual ~App();
            virtual DispatchQueue * queue(kk::CString name);
            virtual Context * getContext(kk::CString path,kk::CString queue);
            virtual void open(kk::CString uri,kk::Boolean animated);
            virtual kk::Strong<View> createView(kk::CString name,ViewConfiguration * configuration);
            
            static void Openlib();
            
            KK_CLASS(App,Context,"UIApp")
    
        protected:
            std::map<kk::String,kk::Strong<DispatchQueue>> _queues;
            std::map<kk::String,kk::Strong<Context>> _contexts;
        };
        
    }
}


#endif /* app_h */
