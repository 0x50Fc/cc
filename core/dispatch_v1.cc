//
//  dispatch.cc
//  kk
//
//  Created by zhanghailong on 2018/10/26.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <kk/dispatch.h>
#include <future>

namespace kk {
    
    
    DispatchQueue::DispatchQueue():DispatchQueue(1) {
        
    }
    
    DispatchQueue::DispatchQueue(kk::Uint maxConcurrent):_maxConcurrent(maxConcurrent),_loopbreak(false) {
        
    }
    
    DispatchQueue::~DispatchQueue() {
        
        _lock.lock();
        _loopbreak = true;
        _wait.notify_all();
        _lock.unlock();
        
        std::list<std::shared_ptr<std::thread>>::iterator i = _threads.begin();
        
        while(i != _threads.end()) {
            (*i)->join();
            i ++;
        }
        
        kk::Log("[DispatchQueue] [dealloc]");
        
    }
    
    void DispatchQueue::async(std::function<void()> && func) {
        
        std::unique_lock<std::mutex> uv(_lock);
        
        _queue.push(func);
        
        if(_threads.size() < _maxConcurrent) {
            
            std::shared_ptr<std::thread> th(new std::thread([this]()->void{
                
                do {
                    
                    std::function<void()> fn;
                    
                    {
                        std::unique_lock<std::mutex> uv(_lock);
                        
//                        while(_queue.empty()) {
//                            _wait.wait(uv);
//                            if(_loopbreak) {
//                                return;
//                            }
//                        }
                        
                        if(!_queue.empty()) {
                            fn = _queue.front();
                            _queue.pop();
                        }
                    }
                    
                    if(fn == nullptr) {
                        std::this_thread::yield();
                    } else {
                        fn();
                    }

                } while(!_loopbreak);
                
            }));
            
            _threads.push_back(th);
        }
        
        _wait.notify_one();
        
    }
    
    void DispatchQueue::sync(std::function<void()> && func) {
    
        std::promise<int> p;
        std::future<int> r = p.get_future();
        
        async([&p,func]()->void{
            func();
            p.set_value(0);
        });
        
        r.get();
        
    }
    
}

