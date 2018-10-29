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
    
    enum DispatchQueueType {
        DispatchQueueTypeSerial,
        DispatchQueueTypeConcurrent
    };
    
    class DispatchQueue : public Object {
    public:
        virtual void async(std::function<void()> && func) = 0;
        virtual void sync(std::function<void()> && func) = 0;
    };
    
    enum DispatchSourceType {
        DispatchSourceTypeRead,
        DispatchSourceTypeWrite,
        DispatchSourceTypeTimer,
        DispatchSourceTypeSignal
    };
    
    class DispatchSource : public Object {
    public:
        virtual void suspend() = 0;
        virtual void resume() = 0;
        virtual void cancel() = 0;
        virtual void setTimer(kk::Uint64 start,kk::Uint64 interval) = 0;
        virtual void setEvent(std::function<void()> && func) = 0;
        virtual void setCancel(std::function<void()> && func) = 0;
    };
    
    kk::Strong<DispatchQueue> DispatchQueueCreate(kk::CString name,DispatchQueueType type);
    
    kk::Strong<DispatchSource> DispatchSourceCreate(kk::Uint64 fd,DispatchSourceType type,DispatchQueue * queue);
    
    DispatchQueue * GetMainDispatchQueue();
    
}

#endif /* dispatch_h */
