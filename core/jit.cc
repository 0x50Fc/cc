//
//  jit.cpp
//  kk
//
//  Created by zhanghailong on 2018/10/24.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <kk/jit.h>
#include <thread>

namespace kk {
    
    JITContext::JITContext() {
        
    }
    
    JITContext::~JITContext() {
        Log("[JITContext] [dealloc]");
    }
    
    void JITContext::strong(duk_context * ctx, void * heapptr, Object * object) {
        
        auto i = _objectsWithHeapptr.find(heapptr);
        
        if(i == _objectsWithHeapptr.end()) {
            
            _objectsWithHeapptr[heapptr] = object;
            
            auto n = _objectsWithObject.find(object);
            
            if(n == _objectsWithObject.end()) {
                _objectsWithObject[object] = {};
                n = _objectsWithObject.find(object);
            }
            
            n->second[ctx] = heapptr;
            
        }
        
        auto n = _strongObjects.find(object);
        
        if(n == _strongObjects.end()) {
            _strongObjects[object] = object;
        }
        
    }
    
    void JITContext::weak(duk_context * ctx, void * heapptr, Object * object) {
        
        auto i = _objectsWithHeapptr.find(heapptr);
        
        if(i == _objectsWithHeapptr.end()) {
            
            _objectsWithHeapptr[heapptr] = object;
            
            auto n = _objectsWithObject.find(object);
            
            if(n == _objectsWithObject.end()) {
                _objectsWithObject[object] = {};
                n = _objectsWithObject.find(object);
            }
            
            n->second[ctx] = heapptr;
            
        }
        
        auto n = _weakObjects.find(object);
        
        if(n == _weakObjects.end()) {
            _weakObjects[object] = object;
        }
        
    }
    
    void JITContext::remove(duk_context * ctx,void * heapptr) {
        
        auto i = _objectsWithHeapptr.find(heapptr);
        
        if(i != _objectsWithHeapptr.end()) {
            Object * v = i->second;
            auto n = _objectsWithObject.find(v);
            if(n != _objectsWithObject.end()) {
                auto m = n->second;
                auto j = m.find(ctx);
                if(j != m.end()) {
                    m.erase(j);
                    if(m.empty()) {
                        _objectsWithObject.erase(n);
                    }
                }
            }
            _objectsWithHeapptr.erase(i);
            _weakObjects.erase(v);
            _strongObjects.erase(v);
        }
        
    }
    
    void JITContext::remove(Object * object) {
        
        auto i = _objectsWithObject.find(object);
        
        if(i != _objectsWithObject.end()) {
            
            auto m = i->second;
            auto n = m.begin();
            while (n != m.end()) {
                void * v = n->second;
                auto j = _objectsWithHeapptr.find(v);
                if(j != _objectsWithHeapptr.end()) {
                    _objectsWithHeapptr.erase(j);
                }
                n ++;
            }
            
            _objectsWithObject.erase(i);
            _weakObjects.erase(object);
            _strongObjects.erase(object);
        }
        
    }
    
    Object * JITContext::get(void * heapptr) {
        auto i = _objectsWithHeapptr.find(heapptr);
        if(i != _objectsWithHeapptr.end()) {
            Object * v = i->second;
            if(_strongObjects.find(v) != _strongObjects.end()) {
                return v;
            }
            std::map<Object *,Weak<Object>>::iterator i = _weakObjects.find(v);
            if(i != _weakObjects.end()) {
                v = i->second;
                if(v == nullptr) {
                    remove(v);
                } else {
                    return v;
                }
            }
        }
        return nullptr;
    }
    
    void * JITContext::get(Object * object,duk_context * ctx) {
        
        auto i = _objectsWithObject.find(object);
        
        if(i != _objectsWithObject.end()) {
            auto m = i->second;
            auto n = m.find(ctx);
            if(n != m.end()) {
                return n->second;
            }
        }
        
        return nullptr;
    }
    
    std::map<Object *, std::map<duk_context *,void *>>::iterator JITContext::find(Object * object) {
        return _objectsWithObject.find(object);
    }
    
    JITContext * JITContext::current(){
        thread_local std::shared_ptr<JITContext> v;
        if(v.get() == nullptr) {
            v = std::shared_ptr<JITContext>(new JITContext());
        }
        return v.get();
    }
    
    static std::list<std::function<void(duk_context *)>> _Openlibs;
    
    void addOpenlib(std::function<void(duk_context *)> && openlib) {
        _Openlibs.push_back(openlib);
    }
    
    void openlib(duk_context * ctx) {
        auto i = _Openlibs.begin();
        while(i != _Openlibs.end()) {
            (*i)(ctx);
            i ++;
        }
    }
    
    static duk_ret_t Object_dealloc(duk_context * ctx) {
        
        void * heapptr = duk_get_heapptr(ctx, -1);
        
        JITContext::current()->remove(ctx,heapptr);
        
        return 0;
    }
    
    void SetObject(duk_context * ctx, duk_idx_t idx, Object * object) {
        
        if(duk_is_object(ctx, idx) || duk_is_function(ctx, idx)) {
            
            duk_get_finalizer(ctx, idx);
            
            if(duk_is_function(ctx, -1)) {
                duk_pop(ctx);
                return;
            } else {
                duk_pop(ctx);
            }
            
            duk_push_c_function(ctx, Object_dealloc, 1);
            duk_set_finalizer(ctx, idx - 1);
            
            JITContext::current()->strong(ctx, duk_get_heapptr(ctx, idx), object);
            
        }
        
    }
    
    void SetWeakObject(duk_context * ctx, duk_idx_t idx, Object * object) {
        
        if(duk_is_object(ctx, idx) || duk_is_function(ctx, idx)) {
            
            duk_get_finalizer(ctx, idx);
            
            if(duk_is_function(ctx, -1)) {
                duk_pop(ctx);
                return;
            } else {
                duk_pop(ctx);
            }
            
            duk_push_c_function(ctx, Object_dealloc, 1);
            duk_set_finalizer(ctx, idx - 1);
            
            JITContext::current()->weak(ctx, duk_get_heapptr(ctx, idx), object);
            
        }
        
    }
    
    void SetPrototype(duk_context * ctx, duk_idx_t idx, const Class * isa) {
        
        duk_get_global_string(ctx, isa->name);
        
        if(duk_is_function(ctx, -1)) {
            duk_get_prototype(ctx, -1);
            duk_set_prototype(ctx, idx - 2);
        }
        
        duk_pop(ctx);
        
    }
    
    void PushObject(duk_context * ctx, Object * object) {
        
        void * heapptr = JITContext::current()->get(object, ctx);
        
        if(heapptr != nullptr) {
            duk_push_heapptr(ctx, heapptr);
            return;
        }
        
        {
            _Array * v = dynamic_cast<_Array *>(object);
            if(v != nullptr) {
                duk_push_array(ctx);
                duk_uarridx_t i = 0;
                v->forEach([&i,ctx](Any & item) -> void {
                    PushAny(ctx, item);
                    duk_put_prop_index(ctx, -2, i);
                    i ++;
                });
                return;
            }
        }
        
        {
            _TObject * v = dynamic_cast<_TObject *>(object);
            if(v != nullptr) {
                duk_push_object(ctx);
                v->forEach([ctx](Any & value,Any & key) -> void {
                    CString sKey = key;
                    if(sKey) {
                        PushAny(ctx, value);
                        duk_put_prop_string(ctx, -2, sKey);
                    }
                });
                return;
            }
        }
        
        duk_push_object(ctx);
        SetObject(ctx, -1, object);
        
        {
            const Class * isa = object->isa();
            if(isa != nullptr) {
                SetPrototype(ctx, -1, isa);
            }
        }
        
    }
    
    void PushWeakObject(duk_context * ctx, Object * object) {
        
        void * heapptr = JITContext::current()->get(object, ctx);
        
        if(heapptr != nullptr) {
            duk_push_heapptr(ctx, heapptr);
            return;
        }
        
        duk_push_object(ctx);
        SetWeakObject(ctx, -1, object);
        
        {
            const Class * isa = object->isa();
            if(isa != nullptr) {
                SetPrototype(ctx, -1, isa);
            }
        }
        
    }
    
    
    Object * GetObject(duk_context * ctx, duk_idx_t idx) {
        
        if(duk_is_object(ctx, idx) || duk_is_function(ctx, idx)) {
            void * heapptr = duk_get_heapptr(ctx, idx);
            return JITContext::current()->get(heapptr);
        }
        
        return nullptr;
    }
    
    static duk_ret_t JSObject_dealloc(duk_context * ctx) {
        
        duk_push_current_function(ctx);
        
        duk_get_prop_string(ctx, -1, "__object");
        
        if(duk_is_pointer(ctx, -1)) {
            JSObject * v = (JSObject *) duk_to_pointer(ctx, -1);
            if(v) {
                v->recycle();
            }
        }
        
        duk_pop_2(ctx);
        
        return 0;
    }
    
    JSObject::JSObject(duk_context * ctx, void * heapptr):_ctx(ctx),_heapptr(heapptr) {
        
        duk_push_heap_stash(ctx);
        
        duk_push_sprintf(ctx, "0x%x",(long) heapptr);
        duk_push_heapptr(ctx, _heapptr);
        {
            duk_push_c_function(ctx, JSObject_dealloc, 1);
            {
                duk_push_pointer(ctx, this);
                duk_put_prop_string(ctx, -2, "__object");
            }
            duk_set_finalizer(ctx, -2);
        }
        
        duk_put_prop(ctx, -3);
        
        duk_pop(ctx);
        
        JITContext::current()->weak(ctx, heapptr, this);
        
    }
    
    void Error(duk_context * ctx, duk_idx_t idx, kk::CString prefix) {
        if(duk_is_error(ctx, idx)) {
            duk_get_prop_string(ctx, idx, "lineNumber");
            int lineNumber = duk_to_int(ctx, -1);
            duk_pop(ctx);
            duk_get_prop_string(ctx, idx, "stack");
            const char * error = duk_to_string(ctx, -1);
            duk_pop(ctx);
            duk_get_prop_string(ctx, idx, "fileName");
            const char * fileName = duk_to_string(ctx, -1);
            duk_pop(ctx);
            kk::Log("%s%s(%d): %s",prefix,fileName,lineNumber,error);
        } else {
            kk::Log("%s%s",prefix,duk_to_string(ctx, idx));
        }
    }
    
    JSObject::~JSObject() {
        
        if(_ctx && _heapptr) {
            JITContext::current()->remove(this);
            duk_context * ctx = _ctx;
            void * heapptr = _heapptr;
            duk_push_heapptr(ctx, heapptr);
            duk_push_undefined(ctx);
            duk_set_finalizer(ctx, -2);
            duk_pop(ctx);
            duk_push_global_stash(ctx);
            duk_push_sprintf(ctx, "0x%x",(long) heapptr);
            duk_del_prop(ctx, -2);
            duk_pop(ctx);
        }
        
    }
    
    duk_context * JSObject::jsContext() {
        return _ctx;
    }
    
    void * JSObject::heapptr() {
        return _heapptr;
    }
    
    void JSObject::recycle() {
        if(_ctx && _heapptr) {
            JITContext::current()->remove(this);
            _ctx = nullptr;
            _heapptr = nullptr;
        }
    }
    
    void PushAny(duk_context * ctx, Any & any) {
        switch (any.type) {
            case TypeInt8:
                duk_push_int(ctx, any.int8Value);
                break;
            case TypeUint8:
                duk_push_uint(ctx, any.uint8Value);
                break;
            case TypeInt16:
                duk_push_int(ctx, any.int16Value);
                break;
            case TypeUint16:
                duk_push_uint(ctx, any.uint16Value);
                break;
            case TypeInt32:
                duk_push_int(ctx, any.int32Value);
                break;
            case TypeUint32:
                duk_push_uint(ctx, any.uint32Value);
                break;
            case TypeInt64:
                duk_push_sprintf(ctx, "%lld",any.int64Value);
                break;
            case TypeUint64:
                duk_push_sprintf(ctx, "%llu",any.uint64Value);
                break;
            case TypeBoolean:
                duk_push_boolean(ctx, any.booleanValue);
                break;
            case TypeFloat32:
                duk_push_number(ctx, any.float32Value);
                break;
            case TypeFloat64:
                duk_push_number(ctx, any.float64Value);
                break;
            case TypeObject:
            case TypeFunction:
                if(any.objectValue.get() == nullptr) {
                    duk_push_undefined(ctx);
                } else {
                    PushObject(ctx, any.objectValue.get());
                }
                break;
            case TypeString:
                duk_push_lstring(ctx, any.stringValue,any.length);
                break;
            default:
                duk_push_undefined(ctx);
                break;
        }
    }
    
    std::shared_ptr<Any> GetAnyPtr(duk_context * ctx, duk_idx_t idx) {
        Any * vv = new Any();
        GetAny(ctx,idx,* vv);
        return std::shared_ptr<Any>(vv);
    }
    
    void GetAny(duk_context * ctx, duk_idx_t idx,Any & v) {
    
        switch (duk_get_type(ctx, idx)) {
            case DUK_TYPE_NUMBER:
            {
                Double dv = duk_to_number(ctx, idx);
                Int64 iv = (Int64) dv;
                Int32 iiv = (Int32) dv;
                if((Double) iv == dv) {
                    if(iv == (Int64) iiv) {
                        v = iiv;
                    } else {
                        v = iv;
                    }
                } else {
                    v = dv;
                }
            }
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
                    a = new JSObject(ctx,duk_get_heapptr(ctx, idx));
                }
                v = a;
            }
                break;
            default:
                break;
        }
        
    }
    
    
}
