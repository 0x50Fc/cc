//
//  timer.h
//  KK
//
//  Created by hailong11 on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef ui_timer_h
#define ui_timer_h

#include <kk/kk.h>
#include <kk/jit.h>
#include <kk/dispatch.h>

namespace kk {
    
    class TimerSource {
    public:
        virtual kk::DispatchQueue * queue() = 0;
        virtual void set(kk::Object * object) = 0;
        virtual kk::Object * get(kk::Object * object) = 0;
        virtual void remove(kk::Object * object) = 0;
    };
    
    class Timer : public Object {
    public:
        Timer(DispatchQueue * queue, kk::Uint64 start,kk::Uint64 interval, std::function<void()> && func);
        virtual ~Timer();
        virtual void cancel();
        static void Openlib();
    protected:
        Strong<DispatchSource> _source;
        std::function<void()> _func;
    };
    
}

#endif /* timer_h */
