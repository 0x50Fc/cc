//
//  timer.cc
//  KK
//
//  Created by hailong11 on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <core/timer.h>

namespace kk {
    
    
    Timer::Timer(DispatchQueue * queue, kk::Uint64 start,kk::Uint64 interval, std::function<void()> && func):_func(func) {
        _source = createDispatchSource(0, DispatchSourceTypeTimer, queue);
        _source->resume();
    }
    
    Timer::~Timer() {
        if(_source) {
            _source->cancel();
        }
    }
    
    void Timer::cancel() {
        _func = nullptr;
        if(_source) {
            _source->cancel();
            _source = nullptr;
        }
    }
    
    void Timer::Openlib() {
        
        kk::Openlib<TimerSource *>::add([](duk_context * ctx, TimerSource * source)->void {
            Weak<TimerSource> s = source;
            
            PushFunction(ctx, new TFunction<kk::Uint64, JSObject *,kk::Int>([s](JSObject * func,kk::Int tv)->kk::Uint64{
                
                kk::Strong<TimerSource> source = s.operator->();
                
                if(source != nullptr) {
                    kk::Strong<JSObject> fn = func;
                    Timer * v = new Timer(s->queue(),tv,0,[fn]()->void{
                        kk::Strong<JSObject> & func = (kk::Strong<JSObject> &) fn;
                        func->invoke<void>(nullptr);
                        func = nullptr;
                    });
                    source->set(v);
                    return (kk::Uint64) v;
                }
                
                return 0;
            }));
            
            duk_put_global_string(ctx, "setTimeout");
            
            PushFunction(ctx, new TFunction<void, kk::Uint64>([s](kk::Uint64 id )->void{
                
                kk::Strong<TimerSource> source = s.operator->();
                
                if(source != nullptr && id != 0) {
                    
                    Timer * v = dynamic_cast<Timer *>(s->get((kk::Object *) id));
                    
                    if(v != nullptr) {
                        v->cancel();
                        source->remove(v);
                    }
                    
                }
                
            }));
        
            duk_put_global_string(ctx, "clearTimeout");
            
            PushFunction(ctx, new TFunction<kk::Uint64, JSObject *,kk::Int>([s](JSObject * func,kk::Int tv)->kk::Uint64{
                
                kk::Strong<TimerSource> source = s.operator->();
                
                if(source != nullptr) {
                    kk::Strong<JSObject> fn = func;
                    Timer * v = new Timer(s->queue(),tv,tv,[fn]()->void{
                        kk::Strong<JSObject> & func = (kk::Strong<JSObject> &) fn;
                        func->invoke<void>(nullptr);
                    });
                    source->set(v);
                    return (kk::Uint64) v;
                }
                
                return 0;
            }));
            
            duk_put_global_string(ctx, "setInterval");
            
            PushFunction(ctx, new TFunction<void, kk::Uint64>([s](kk::Uint64 id )->void{
                
                kk::Strong<TimerSource> source = s.operator->();
                
                if(source != nullptr && id != 0) {
                    
                    Timer * v = dynamic_cast<Timer *>(s->get((kk::Object *) id));
                    
                    if(v != nullptr) {
                        v->cancel();
                        source->remove(v);
                    }
                    
                }
                
            }));
            
            duk_put_global_string(ctx, "clearInterval");
            
            
        });
        
    }
    
}
