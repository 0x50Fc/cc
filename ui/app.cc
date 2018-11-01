//
//  app.cc
//  KK
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <ui/app.h>

namespace kk {
    
    namespace ui {
    
        App::App(kk::CString basePath):Context(basePath,kk::mainDispatchQueue()) {

            duk_context * ctx = jsContext();
            
            PushWeakObject(ctx, this);
            duk_put_global_string(ctx, "app");
            
        }
        
        App::~App() {
            
            kk::Log("[App] [dealloc]");
        }
        
        Context * App::getContext(kk::CString path,kk::CString queue) {
            auto i = _contexts.find(path);
            if(i != _contexts.end()) {
                return i->second;
            }
            kk::String basePath = this->basePath();
            if(!basePath.endsWith("/")) {
                basePath.append("/");
            }
            basePath.append(path);
            Context * v = new Context(basePath.c_str(),this->queue(queue));
            _contexts[path] = v;
            return v;
        }
        
        DispatchQueue * App::queue(kk::CString name) {
            auto i = _queues.find(name);
            if(i != _queues.end()) {
                return i->second;
            }
            DispatchQueue * v = createDispatchQueue(name, DispatchQueueTypeSerial);
            _queues[name] = v;
            return v;
        }

        void App::open(kk::CString uri,kk::Boolean animated) {
            if(uri == nullptr) {
                return;
            }
            kk::Strong<Event> e = new Event();
            kk::Strong<kk::TObject<kk::String, kk::Any>> data = new kk::TObject<kk::String, kk::Any>({{"uri", kk::Any(uri)},{"animated",kk::Any(animated)}});
            e->setData((kk::TObject<kk::String, kk::Any> *) data);
            emit("open", e);
        }
        
        void App::Openlib() {
            
            kk::Openlib<>::add([](duk_context * ctx)->void{
                
                kk::PushInterface<App, kk::CString>(ctx, [](duk_context * ctx)->void{
                    
                    kk::PutMethod<App,Context *,kk::CString,kk::CString>(ctx, -1, "getContext", &App::getContext);
                    
                    kk::PutMethod<App,DispatchQueue *,kk::CString>(ctx, -1, "queue", &App::queue);
                    
                    kk::PutMethod<App,void,kk::CString,kk::Boolean>(ctx, -1, "open", &App::open);
                    
                });
                
            });
            
        }
        
    }
    
}
