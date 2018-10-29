//
//  main.cpp
//  kk
//
//  Created by zhanghailong on 2018/10/24.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <iostream>
#include <thread>
#include <kk/kk.h>
#include <kk/jit.h>
#include <kk/dispatch.h>

class T : public kk::Object {
public:
    T(const char * name,int version) {
        kk::Log("[T] (%s,%d)",name,version);
    }
    virtual ~T() {
        kk::Log("[T] [dealloc]");
    }
};

void th_cb(kk::Any& v) {
    kk::JITContext::current();
    v.call<void,kk::Int>(1);
}

void js_print(const char * string,int v) {
    kk::Log("%s %d",string,v);
}

int js_get(int v) {
    return v + 1;
}

int main(int argc, const char * argv[]) {
    
    {
        T * v = new T("B",2);
        std::shared_ptr<T> a(v);
        std::shared_ptr<T> b(a);
    }
    
    duk_context * ctx = duk_create_heap_default();
    
    kk::PushFunction<void,const char *,int>(ctx, js_print);
    
    duk_put_global_string(ctx, "print");
    
    kk::PushFunction<int, int>(ctx, js_get);
    
    duk_put_global_string(ctx, "get");
    
    kk::PushConstructor<T,const char *,int>(ctx);
    
    duk_put_global_string(ctx, "T");
    
    duk_eval_string_noresult(ctx, "print(123,get(456)); new T('A',1);");
    
    {
        duk_eval_string(ctx, "(function(a,b){ return a + b; })");
        kk::Strong<kk::JSObject> fn = kk::Get<kk::JSObject>(ctx,-1);
        duk_pop(ctx);
        int vv = fn->invoke<int,int,int>(nullptr, 123,456);
        kk::Log("R: %d",vv);
    }
    
    duk_destroy_heap(ctx);
    
    int i = 0;
    
    kk::Any v(new kk::TFunction<void,kk::Int>([=](kk::Int v){
        kk::Log("%d",i + v);
    }));
    
    v.call<void,kk::Int>(1);
    
    std::thread th(th_cb,std::ref(v));
    
    th.join();
    
    std::thread th2(th_cb,std::ref(v));
    
    th2.join();
    
    std::cout << i << std::endl;

    {
        kk::Strong<kk::DispatchQueue> queue = kk::DispatchQueueCreate("Queue",kk::DispatchQueueTypeConcurrent);
        
        for(int i=0;i<20;i++) {
            queue->async([i]()->void{
                kk::Log("[DispatchQueue] [async] [OK] %d %d",i,std::this_thread::get_id());
            });
        }
        
        queue->sync([]()->void{
            kk::Log("[DispatchQueue] [sync] [OK]");
        });
        
        std::this_thread::sleep_for(std::chrono::seconds(6));
        
        kk::Log("[DispatchQueue] [DONE]");
    }
    return 0;
}
