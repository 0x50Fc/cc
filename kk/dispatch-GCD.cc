//
//  dispatch.cc
//  kk
//
//  Created by zhanghailong on 2018/10/26.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <kk/dispatch.h>
#include <future>
#include <dispatch/dispatch.h>

namespace kk {
    
    
    class GCDDispatchQueue : public DispatchQueue {
    public:
        
        GCDDispatchQueue(kk::CString name,DispatchQueueType type) {
            _queue = ::dispatch_queue_create(name, type == DispatchQueueTypeSerial ? DISPATCH_QUEUE_SERIAL : DISPATCH_QUEUE_CONCURRENT);
        }
        
        GCDDispatchQueue(::dispatch_queue_t queue) {
            _queue = queue;
        }
        
        virtual ~GCDDispatchQueue(){
            dispatch_release(_queue);
            kk::Log("[GCDDispatchQueue] [dealloc]");
        }
        
        virtual void async(std::function<void()> && func) {
            
            std::function<void()> * f = new std::function<void()>(func);
            
            ::dispatch_async(_queue, ^{
                (*f)();
                delete f;
            });
            
        }
        virtual void sync(std::function<void()> && func) {
            ::dispatch_sync(_queue, ^{
                func();
            });
        }
        virtual ::dispatch_queue_t queue() {
            return _queue;
        }
    protected:
        ::dispatch_queue_t _queue;
    };

    
    kk::Strong<DispatchQueue> DispatchQueueCreate(kk::CString name,DispatchQueueType type) {
        return new GCDDispatchQueue(name,type);
    }
    
    DispatchQueue * GetMainDispatchQueue() {
        static DispatchQueue * v = nullptr;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            v = new kk::GCDDispatchQueue(dispatch_get_main_queue());
        });
        return v;
    }
    
    class GCDDispatchSource : public DispatchSource {
    public:
        
        GCDDispatchSource(kk::Uint64 fd,DispatchSourceType type,GCDDispatchQueue * queue) {
            
            dispatch_source_type_t t;
            
            switch (type) {
                case DispatchSourceTypeRead:
                    t = DISPATCH_SOURCE_TYPE_READ;
                    break;
                case DispatchSourceTypeWrite:
                    t = DISPATCH_SOURCE_TYPE_WRITE;
                    break;
                case DispatchSourceTypeTimer:
                    t = DISPATCH_SOURCE_TYPE_TIMER;
                    break;
                case DispatchSourceTypeSignal:
                    t = DISPATCH_SOURCE_TYPE_SIGNAL;
                    break;
            }
            
            _source = ::dispatch_source_create(t, fd, 0, queue->queue());
            
            dispatch_source_set_event_handler(_source, ^{
                this->onEvent();
            });
            
            dispatch_source_set_cancel_handler(_source, ^{
                this->onCancel();
            });
            
        }
        
        virtual ~GCDDispatchSource() {
            dispatch_release(_source);
        }
        
        virtual void suspend() {
            dispatch_suspend(_source);
        }
        
        virtual void resume() {
            dispatch_resume(_source);
        }
        
        virtual void cancel() {
            dispatch_cancel(_source);
        }
        
        virtual void setTimer(kk::Uint64 start,kk::Uint64 interval) {
            dispatch_source_set_timer(_source, start, interval, 0);
        }
        
        virtual void setEvent(std::function<void()> && func) {
            _event = func;
        }
        
        virtual void setCancel(std::function<void()> && func) {
            _cancel = func;
        }
    protected:
        
        virtual void onEvent() {
            if(_event != nullptr) {
                std::function<void()> fn = _event;
                fn();
            }
        }
        
        virtual void onCancel() {
            if(_cancel != nullptr) {
                std::function<void()> fn = _cancel;
                fn();
            }
        }
        
        ::dispatch_source_t _source;
        std::function<void()> _event;
        std::function<void()> _cancel;
    };
    
    kk::Strong<DispatchSource> DispatchSourceCreate(kk::Uint64 fd,DispatchSourceType type,DispatchQueue * queue) {
        return new GCDDispatchSource(fd, type, (GCDDispatchQueue *) queue);
    }
    
}

