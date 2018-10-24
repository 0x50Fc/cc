//
//  jit.cpp
//  kk
//
//  Created by zhanghailong on 2018/10/24.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include "jit.h"
#include <thread>

namespace kk {
    
    JITObject::JITObject(duk_context * ctx, void * heapptr, Object * object):_ctx(ctx),_heapptr(heapptr),_object(object) {
    }
    
    JITObject::~JITObject() {
        
    }
    
    duk_context * JITObject::jsContext() {
        return _ctx;
    }
    
    void * JITObject::heapptr() {
        return _heapptr;
    }
    
    Object * JITObject::object() {
        return _object.get();
    }
    
    JITContext::JITContext() {
        
    }
    
    JITContext::~JITContext() {
        Log("[JITContext] [dealloc]");
    }
    
    void JITContext::add(duk_context * ctx, void * heapptr, Object * object) {
        
        auto i = _objectsWithHeapptr.find(heapptr);
        
        if(i == _objectsWithHeapptr.end()) {
            
            std::shared_ptr<JITObject> v(new JITObject(ctx,heapptr,object));
            
            _objectsWithHeapptr[heapptr] = v;
            
            auto n = _objectsWithObject.find(object);
            
            if(n == _objectsWithObject.end()) {
                _objectsWithObject[object] = {};
                n = _objectsWithObject.find(object);
            }
            
            n->second[ctx] = v;
            
        }
        
    }
    
    void JITContext::remove(void * heapptr) {
        
        auto i = _objectsWithHeapptr.find(heapptr);
        
        if(i != _objectsWithHeapptr.end()) {
            JITObject * v = i->second.get();
            auto n = _objectsWithObject.find(v->object());
            if(n != _objectsWithObject.end()) {
                auto m = n->second;
                auto j = m.find(v->jsContext());
                if(j != m.end()) {
                    m.erase(j);
                    if(m.empty()) {
                        _objectsWithObject.erase(n);
                    }
                }
            }
            _objectsWithHeapptr.erase(i);
        }
        
    }
    
    void JITContext::remove(Object * object) {
        
        auto i = _objectsWithObject.find(object);
        
        if(i != _objectsWithObject.end()) {
            
            auto m = i->second;
            auto n = m.begin();
            while (n != m.end()) {
                JITObject * v = n->second.get();
                auto j = _objectsWithHeapptr.find(v->heapptr());
                if(j != _objectsWithHeapptr.end()) {
                    _objectsWithHeapptr.erase(j);
                }
                n ++;
            }
            
            _objectsWithObject.erase(i);
        }
        
    }
    
    Object * JITContext::get(void * heapptr) {
        auto i = _objectsWithHeapptr.find(heapptr);
        if(i != _objectsWithHeapptr.end()) {
            JITObject * v = i->second.get();
            return v->object();
        }
        return nullptr;
    }
    
    void * JITContext::get(Object * object,duk_context * ctx) {
        
        auto i = _objectsWithObject.find(object);
        
        if(i != _objectsWithObject.end()) {
            auto m = i->second;
            auto n = m.find(ctx);
            if(n != m.end()) {
                auto v = n->second.get();
                return v->heapptr();
            }
        }
        
        return nullptr;
    }
    
    std::map<Object *, std::map<duk_context *,std::shared_ptr<JITObject>>>::iterator JITContext::find(Object * object) {
        return _objectsWithObject.find(object);
    }
    
    JITContext * JITContext::current(){
        thread_local std::shared_ptr<JITContext> v;
        if(v.get() == nullptr) {
            v = std::shared_ptr<JITContext>(new JITContext());
        }
        return v.get();
    }
    
    static duk_ret_t Object_dealloc(duk_context * ctx) {
        
        void * heapptr = duk_get_heapptr(ctx, -1);
        
        JITContext::current()->remove(heapptr);
        
        return 0;
    }
    
    void SetObject(duk_context * ctx, duk_idx_t idx, Object * object) {
        
        if(duk_is_object(ctx, idx) || duk_is_function(ctx, idx)) {
            
            duk_get_finalizer(ctx, idx);
            
            if(duk_is_function(ctx, -1)) {
                duk_pop(ctx);
                return;
            }
            
            duk_push_c_function(ctx, Object_dealloc, 1);
            duk_set_finalizer(ctx, idx - 1);
            
            JITContext::current()->add(ctx, duk_get_heapptr(ctx, idx), object);
            
        }
        
    }
    
    void PushObject(duk_context * ctx, Object * object) {
        
        void * heapptr = JITContext::current()->get(object, ctx);
        
        if(heapptr != nullptr) {
            duk_push_heapptr(ctx, heapptr);
            return;
        }
        
        duk_push_object(ctx);
        
        SetObject(ctx, -1, object);
    }
    
    Object * GetObject(duk_context * ctx, duk_idx_t idx) {
        
        if(duk_is_object(ctx, idx) || duk_is_function(ctx, idx)) {
            void * heapptr = duk_get_heapptr(ctx, idx);
            return JITContext::current()->get(heapptr);
        }
        
        return nullptr;
    }
    
    void PushAny(duk_context * ctx, Any & any) {
        
    }
    
    Any GetAny(duk_context * ctx, duk_idx_t idx) {
        
        Any v;
        
        switch (duk_get_type(ctx, idx)) {
            case DUK_TYPE_NUMBER:
                v = (Double) duk_to_number(ctx, idx);
                break;
            case DUK_TYPE_BOOLEAN:
                v = (Boolean) duk_to_boolean(ctx, idx);
                break;
            case DUK_TYPE_STRING:
                v = (CString) duk_to_string(ctx, idx);
                break;
            case DUK_TYPE_OBJECT:
            case DUK_TYPE_LIGHTFUNC:
            {
                Object * a =  GetObject(ctx, idx);
                if(a == nullptr) {
                    a = new JSObject();
                    SetObject(ctx, idx, a);
                }
                v = a;
            }
                break;
            default:
                break;
        }
        
        return v;
    }
    
}
