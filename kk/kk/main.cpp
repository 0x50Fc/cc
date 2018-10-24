//
//  main.cpp
//  kk
//
//  Created by zhanghailong on 2018/10/24.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <iostream>
#include <thread>
#include "kk.h"
#include "jit.h"

void th_cb(kk::Any& v) {
    kk::JITContext::current();
    v.call<void,kk::Int>(1);
}

int main(int argc, const char * argv[]) {
    
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
    
    return 0;
}
