//
//  jit.h
//  kk
//
//  Created by zhanghailong on 2018/10/24.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef jit_h
#define jit_h

#include "kk.h"
#include "duktape.h"

namespace kk {
    
    class JITObject {
    public:
        JITObject(duk_context * ctx, void * heapptr, Object * object);
        virtual ~JITObject();
        virtual duk_context * jsContext();
        virtual void * heapptr();
        virtual Object * object();
    protected:
        duk_context * _ctx;
        void * _heapptr;
        std::shared_ptr<Object> _object;
    };
    
    class JITContext : public Object {
    public:
        JITContext();
        virtual ~JITContext();
        virtual void add(duk_context * ctx, void * heapptr, Object * object);
        virtual void remove(void * heapptr);
        virtual void remove(Object * object);
        virtual Object * get(void * heapptr);
        virtual void * get(Object * object,duk_context * ctx);
        virtual std::map<Object *, std::map<duk_context *,std::shared_ptr<JITObject>>>::iterator find(Object * object);
        
        static JITContext * current();
        
    protected:
        std::map<void *,std::shared_ptr<JITObject>> _objectsWithHeapptr;
        std::map<Object *, std::map<duk_context *,std::shared_ptr<JITObject>>> _objectsWithObject;
    };
    
    class JSObject : public Object {
    };
    
    void SetObject(duk_context * ctx, duk_idx_t idx, Object * object);
    
    void PushObject(duk_context * ctx, Object * object);
    
    Object * GetObject(duk_context * ctx, duk_idx_t idx);
    
    void PushAny(duk_context * ctx, Any & any);
    
    Any GetAny(duk_context * ctx, duk_idx_t idx);
    
    template<typename T>
    T Get(duk_context * ctx, duk_idx_t idx) {
        return (T) GetAny(ctx, idx);
    }
    
    template<typename TReturn>
    void PushFunction(duk_context * ctx, TFunction<TReturn> * func) {
        auto fn = [](duk_context * ctx) -> duk_ret_t {
            duk_push_current_function(ctx);
            TFunction<TReturn> * func = (TFunction<TReturn> *) GetObject(ctx,  -1);
            duk_pop(ctx);
            Any v = (*func)();
            PushAny(ctx, v);
            return 1;
        };
        duk_push_c_function(ctx, fn, 0);
        SetObject(ctx, -1, func);
    }
    
    template<typename TReturn,typename TArg>
    void PushFunction(duk_context * ctx, TFunction<TReturn,TArg> * func) {
        auto fn = [](duk_context * ctx) -> duk_ret_t {
            duk_push_current_function(ctx);
            TFunction<TReturn,TArg> * func = (TFunction<TReturn,TArg> *) GetObject(ctx,  -1);
            duk_pop(ctx);
            Any a0 = GetAny(ctx, -1);
            Any v = (*func)((TArg)a0);
            PushAny(ctx, v);
            return 1;
        };
        duk_push_c_function(ctx, fn, 1);
        SetObject(ctx, -1, func);
    }
    
    template<typename TReturn,typename TArg1,typename TArg2>
    void PushFunction(duk_context * ctx, TFunction<TReturn,TArg1,TArg2> * func) {
        auto fn = [](duk_context * ctx) -> duk_ret_t {
            duk_push_current_function(ctx);
            TFunction<TReturn,TArg1,TArg2> * func = (TFunction<TReturn,TArg1,TArg2> *) GetObject(ctx,  -1);
            duk_pop(ctx);
            Any a1 = GetAny(ctx, -2);
            Any a2 = GetAny(ctx, -1);
            Any v = (*func)((TArg1)a1,(TArg2)a2);
            PushAny(ctx, v);
            return 1;
        };
        duk_push_c_function(ctx, fn, 2);
        SetObject(ctx, -1, func);
    }
    
    template<typename TReturn,typename TArg1,typename TArg2,typename TArg3>
    void PushFunction(duk_context * ctx, TFunction<TReturn,TArg1,TArg2,TArg3> * func) {
        auto fn = [](duk_context * ctx) -> duk_ret_t {
            duk_push_current_function(ctx);
            TFunction<TReturn,TArg1,TArg2,TArg3> * func = (TFunction<TReturn,TArg1,TArg2,TArg3> *) GetObject(ctx,  -1);
            duk_pop(ctx);
            Any a1 = GetAny(ctx, -3);
            Any a2 = GetAny(ctx, -2);
            Any a3 = GetAny(ctx, -1);
            Any v = (*func)((TArg1)a1,(TArg2)a2,(TArg3)a3);
            PushAny(ctx, v);
            return 1;
        };
        duk_push_c_function(ctx, fn, 3);
        SetObject(ctx, -1, func);
    }
    
    template<typename TReturn,typename TArg1,typename TArg2,typename TArg3,typename TArg4>
    void PushFunction(duk_context * ctx, TFunction<TReturn,TArg1,TArg2,TArg3,TArg4> * func) {
        auto fn = [](duk_context * ctx) -> duk_ret_t {
            duk_push_current_function(ctx);
            TFunction<TReturn,TArg1,TArg2,TArg3,TArg4> * func = (TFunction<TReturn,TArg1,TArg2,TArg3,TArg4> *) GetObject(ctx,  -1);
            duk_pop(ctx);
            Any a1 = GetAny(ctx, -4);
            Any a2 = GetAny(ctx, -3);
            Any a3 = GetAny(ctx, -2);
            Any a4 = GetAny(ctx, -1);
            Any v = (*func)((TArg1)a1,(TArg2)a2,(TArg3)a3,(TArg4)a4);
            PushAny(ctx, v);
            return 1;
        };
        duk_push_c_function(ctx, fn, 4);
        SetObject(ctx, -1, func);
    }
    
    template<typename T>
    void PushProperty(duk_context * ctx, duk_idx_t idx, CString name, T (Object::*getter)(), void (Object::*setter)(T value)) {
        
        auto getter_fn = [getter](duk_context * ctx) -> duk_ret_t {
            duk_push_this(ctx);
            Object * object = GetObject(ctx, -1);
            duk_pop(ctx);
            if(object && getter) {
                Any v = (object->*getter)();
                PushAny(ctx, v);
                return 1;
            }
            return 0;
        };
        
        auto setter_fn = [setter](duk_context * ctx) -> duk_ret_t {
            duk_push_this(ctx);
            Object * object = GetObject(ctx, -1);
            duk_pop(ctx);
            if(object && setter) {
                Any v = GetAny(ctx,-1);
                (object->*setter)((T) v);
            }
            return 0;
        };
        
        duk_push_string(ctx, name);
        duk_push_c_function(ctx, getter_fn, 0);
        duk_push_c_function(ctx, setter_fn, 1);
        duk_def_prop(ctx, idx - 3, DUK_DEFPROP_HAVE_GETTER | DUK_DEFPROP_HAVE_SETTER);
        
    }
    
}

#endif /* jit_h */
