//
//  dispatch.h
//  kk
//
//  Created by zhanghailong on 2018/10/26.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef kk_dispatch_h
#define kk_dispatch_h

#include <kk/kk.h>
#include <list>

namespace kk {
    
    class DispatchQueue : public Object {
    public:
        DispatchQueue();
        DispatchQueue(kk::Uint maxConcurrent);
        virtual ~DispatchQueue();
        virtual void async(std::function<void()> && func);
        virtual void sync(std::function<void()> && func);
    protected:
        kk::Uint _maxConcurrent;
        std::queue<std::function<void()>> _queue;
        std::mutex _lock;
        std::condition_variable _wait;
        std::list<std::shared_ptr<std::thread>> _threads;
        kk::Boolean _loopbreak;
    };
    
}

#endif /* dispatch_h */
