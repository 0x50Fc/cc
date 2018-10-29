//
//  jit.h
//  kk
//
//  Created by zhanghailong on 2018/10/24.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef kk_jit_h
#define kk_jit_h

#include <kk/kk.h>
#include <duktape.h>
#include <tuple>
#include <list>
#include <set>

namespace kk {
    
    
    class JITContext : public Object {
    public:
        JITContext();
        virtual ~JITContext();
        virtual void strong(duk_context * ctx, void * heapptr, Object * object);
        virtual void weak(duk_context * ctx, void * heapptr, Object * object);
        virtual void remove(duk_context * ctx,void * heapptr);
        virtual void remove(Object * object);
        virtual Object * get(void * heapptr);
        virtual void * get(Object * object,duk_context * ctx);
        virtual std::map<Object *, std::map<duk_context *,void *>>::iterator find(Object * object);
        static JITContext * current();

        KK_CLASS(JITContext,Object)
        
    protected:
        std::map<Object *,Weak<Object>> _weakObjects;
        std::map<Object *,Strong<Object>> _strongObjects;
        std::map<void *,Object *> _objectsWithHeapptr;
        std::map<Object *, std::map<duk_context *,void *>> _objectsWithObject;
    };
    
    void addOpenlib(std::function<void(duk_context *)> && openlib);
    
    void openlib(duk_context * ctx);
    
    
    void SetPrototype(duk_context * ctx, duk_idx_t idx, const Class * isa);
    
    void SetObject(duk_context * ctx, duk_idx_t idx, Object * object);
    
    void PushObject(duk_context * ctx, Object * object);
    
    Object * GetObject(duk_context * ctx, duk_idx_t idx);
    
    void PushAny(duk_context * ctx, Any & any);
    
    void GetAny(duk_context * ctx, duk_idx_t idx,Any & v);
    
    template<class T>
    Strong<T> Get(duk_context * ctx, duk_idx_t idx) {
        Any v;
        GetAny(ctx, idx, v);
        return (Strong<T>) v;
    }
    
    std::shared_ptr<Any> GetAnyPtr(duk_context * ctx, duk_idx_t idx);
    
    void Error(duk_context * ctx, duk_idx_t idx, kk::CString prefix);
    
    namespace details {
        
        
        template<size_t N>
        struct Arguments {
            
            template<typename P, typename ... TArgs>
            static std::tuple<P,TArgs...> Get(duk_context * ctx,std::vector<std::shared_ptr<Any>> &&vs) {
                std::shared_ptr<Any> v = GetAnyPtr(ctx, - (duk_idx_t) N );
                vs.push_back(v);
                return std::tuple_cat(std::make_tuple((P) *v), Arguments<N-1>::template Get<TArgs...>(ctx,std::move(vs)));
            }
            
            template<typename P, typename ... TArgs>
            static void Set(duk_context * ctx, P v, TArgs ... args) {
                Any a(v);
                PushAny(ctx, a);
                Arguments<N-1>::Set(ctx,args...);
            }
            
        };
        
        template<>
        struct Arguments<1> {
            
            template<typename P>
            static std::tuple<P> Get(duk_context * ctx,std::vector<std::shared_ptr<Any>> &&vs) {
                std::shared_ptr<Any> v = GetAnyPtr(ctx, - 1);
                vs.push_back(v);
                return std::make_tuple((P) *v);
            }
            
            template<typename P>
            static void Set(duk_context * ctx, P v) {
                Any a(v);
                PushAny(ctx, a);
            }
            
        };
        
        template<>
        struct Arguments<0> {
            
            template<typename ... TArgs>
            static std::tuple<> Get(duk_context * ctx,std::vector<std::shared_ptr<Any>> &&vs) {
                return std::tuple<>();
            }
            
            template<typename ... TArgs>
            static void Set(duk_context * ctx) {
            }
            
        };
        
        
        
        template<size_t N>
        struct Call {
            
            template<typename ... TArgs>
            struct T {
                template<typename TReturn,typename ... P>
                static TReturn Apply(std::function<TReturn(P...)> && func,std::tuple<P...>& a,TArgs ... args,typename std::enable_if<std::is_void<TReturn>::value>::type* = 0) {
                    Call<N-1>::template T<typename std::tuple_element<N -1, std::tuple<P...>>::type,TArgs...>::template Apply<TReturn,P ...>(std::move(func),a,std::get<N -1>(a),args...);
                }
                template<typename TReturn,typename ... P>
                static TReturn Apply(std::function<TReturn(P...)> && func,std::tuple<P...>& a,TArgs ... args,typename std::enable_if<!std::is_void<TReturn>::value>::type* = 0) {
                    return Call<N-1>::template T<typename std::tuple_element<N -1, std::tuple<P...>>::type,TArgs...>::template Apply<TReturn,P ...>(std::move(func),a,std::get<N -1>(a),args...);
                }
                
                template<class TClass,typename ... P>
                static TClass * New(std::tuple<P...>& a,TArgs ... args) {
                    return Call<N-1>::template T<typename std::tuple_element<N -1, std::tuple<P...>>::type,TArgs...>::template New<TClass,P ...>(a,std::get<N -1>(a),args...);
                }
            };
        };
        
        template<>
        struct Call<0> {
            
            template<typename ... TArgs>
            struct T {
                template<typename TReturn,typename ... P>
                static TReturn Apply(std::function<TReturn(P...)> && func,std::tuple<P...>& a, P ... args,typename std::enable_if<std::is_void<TReturn>::value>::type* = 0) {
                    func(args...);
                }
                template<typename TReturn,typename ... P>
                static TReturn Apply(std::function<TReturn(P...)> && func,std::tuple<P...>& a, P ... args,typename std::enable_if<!std::is_void<TReturn>::value>::type* = 0) {
                    return func(args...);
                }
                
                template<class TClass,typename ... P>
                static TClass * New(std::tuple<P...>& a, P ... args) {
                    return new TClass(args...);
                }
            };
            
        };
        
    }
    
    template <typename TReturn,typename ... TArgs>
    duk_ret_t Call(std::function<TReturn(TArgs...)> && func,duk_context * ctx,typename std::enable_if<std::is_void<TReturn>::value>::type* = 0) {
        std::vector<std::shared_ptr<Any>> vs;
        std::tuple<TArgs...> args = details::Arguments<sizeof...(TArgs)>::template Get<TArgs...>(ctx, std::move(vs));
        details::Call<sizeof...(TArgs)>::template T<>::template Apply<TReturn,TArgs...>(std::move(func),args);
        return 0;
    }
    
    template <typename TReturn,typename ... TArgs>
    duk_ret_t Call(std::function<TReturn(TArgs...)> && func,duk_context * ctx,typename std::enable_if<!std::is_void<TReturn>::value>::type* = 0) {
        std::vector<std::shared_ptr<Any>> vs;
        std::tuple<TArgs...> args = details::Arguments<sizeof...(TArgs)>::template Get<TArgs...>(ctx, std::move(vs));
        Any v = details::Call<sizeof...(TArgs)>::template T<>::template Apply<TReturn,TArgs...>(std::move(func),args);
        PushAny(ctx, v);
        return 1;
    }
    
    template <class T,typename ... TArgs>
    T * New(duk_context * ctx) {
        std::vector<std::shared_ptr<Any>> vs;
        std::tuple<TArgs...> args = details::Arguments<sizeof...(TArgs)>::template Get<TArgs...>(ctx, std::move(vs));
        return details::Call<sizeof...(TArgs)>::template T<>::template New<T,TArgs...>(args);
    }

    template<typename TReturn,typename ... TArgs>
    void PushFunction(duk_context * ctx, TFunction<TReturn,TArgs...> * func) {
        auto fn = [](duk_context * ctx) -> duk_ret_t {
            
            duk_push_current_function(ctx);
            TFunction<TReturn,TArgs...> * func = (TFunction<TReturn,TArgs...> *) GetObject(ctx,  -1);
            duk_pop(ctx);
            
            if(func) {
                std::function<TReturn(TArgs...)> & fn = func->func();
                return Call(std::move(fn),ctx);
            }
           
            return 0;
        };
        duk_push_c_function(ctx, fn, sizeof...(TArgs));
        SetObject(ctx, -1, func);
    }
    
    template<typename TReturn,typename ... TArgs>
    void PushFunction(duk_context * ctx, TReturn (*func) (TArgs ...)) {
        auto fn = [](duk_context * ctx) -> duk_ret_t {
            duk_push_current_function(ctx);
            duk_get_prop_string(ctx, -1, "__func");
            TReturn(*func)(TArgs ...) = (TReturn(*)(TArgs ...)) duk_to_pointer(ctx, -1);
            duk_pop_2(ctx);
            
            if(func) {
                std::function<TReturn(TArgs...)> v(func);
                return Call(std::move(v),ctx);
            }
            return 0;
        };
        duk_push_c_function(ctx, fn, sizeof...(TArgs));
        {
            duk_push_pointer(ctx, (void *) func);
            duk_put_prop_string(ctx, -2, "__func");
        }
    }
    
    template<typename T>
    void PutProperty(duk_context * ctx, duk_idx_t idx, CString name, T (Object::*getter)(), void (Object::*setter)(T value)) {
        
        auto getter_fn = [](duk_context * ctx) -> duk_ret_t {
            duk_push_this(ctx);
            Object * object = GetObject(ctx, -1);
            duk_pop(ctx);
            
            duk_push_current_function(ctx);
            duk_get_prop_string(ctx, -1, "__func");
            T(Object::*func)() = (T(Object::*)()) duk_to_pointer(ctx, -1);
            duk_pop_2(ctx);
            if(object && func) {
                Any v = (object->*func)();
                PushAny(ctx, v);
                return 1;
            }
            return 0;
        };
        
        auto setter_fn = [](duk_context * ctx) -> duk_ret_t {
            duk_push_this(ctx);
            Object * object = GetObject(ctx, -1);
            duk_pop(ctx);
            
            duk_push_current_function(ctx);
            duk_get_prop_string(ctx, -1, "__func");
            void (Object::*func)(T v) = (void (Object::*)(T v)) duk_to_pointer(ctx, -1);
            duk_pop_2(ctx);
            
            if(object && func) {
                Any v ;
                GetAny(ctx,-1,v);
                (object->*func)((T) v);
            }
            return 0;
        };
        
        duk_push_string(ctx, name);
        duk_push_c_function(ctx, getter_fn, 0);
        {
            duk_push_pointer(ctx, (void *) getter);
            duk_put_prop_string(ctx, -2, "__func");
        }
        duk_push_c_function(ctx, setter_fn, 1);
        {
            duk_push_pointer(ctx, (void *) setter);
            duk_put_prop_string(ctx, -2, "__func");
        }
        duk_def_prop(ctx, idx - 3, DUK_DEFPROP_HAVE_GETTER | DUK_DEFPROP_HAVE_SETTER);
        
    }
    
    template<typename TReturn,typename ... TArgs>
    void PutMethod(duk_context * ctx, duk_idx_t idx, CString name, TReturn (Object::*method)(TArgs ...),typename std::enable_if<std::is_void<TReturn>::value>::type* = 0) {
    
        auto fn = [](duk_context * ctx) -> duk_ret_t {
            duk_push_this(ctx);
            Object * object = GetObject(ctx, -1);
            duk_pop(ctx);
            
            duk_push_current_function(ctx);
            duk_get_prop_string(ctx, -1, "__func");
            TReturn (Object::*func)(TArgs ...) = (TReturn (Object::*)(TArgs ...)) duk_to_pointer(ctx, -1);
            duk_pop_2(ctx);
            
            if(object && func) {
                auto fn = [object,func](TArgs ... args) -> TReturn {
                    (object->*func)(args...);
                };
                return Call(std::move(fn), ctx);
            }
            return 0;
        };
        
        duk_push_string(ctx, name);
        duk_push_c_function(ctx, fn, sizeof...(TArgs));
        {
            duk_push_pointer(ctx, (void *) method);
            duk_put_prop_string(ctx, -2, "__func");
        }
        duk_def_prop(ctx, idx - 2, DUK_DEFPROP_HAVE_VALUE | DUK_DEFPROP_SET_ENUMERABLE | DUK_DEFPROP_SET_CONFIGURABLE | DUK_DEFPROP_CLEAR_WRITABLE);
        
    }
    
    template<typename TReturn,typename ... TArgs>
    void PutMethod(duk_context * ctx, duk_idx_t idx, CString name, TReturn (Object::*method)(TArgs ...),typename std::enable_if<!std::is_void<TReturn>::value>::type* = 0) {
        
        auto fn = [](duk_context * ctx) -> duk_ret_t {
            duk_push_this(ctx);
            Object * object = GetObject(ctx, -1);
            duk_pop(ctx);
            
            duk_push_current_function(ctx);
            duk_get_prop_string(ctx, -1, "__func");
            TReturn (Object::*func)(TArgs ...) = (TReturn (Object::*)(TArgs ...)) duk_to_pointer(ctx, -1);
            duk_pop_2(ctx);
            
            if(object && func) {
                auto fn = [object,func](TArgs ... args) -> TReturn {
                    return (object->*func)(args...);
                };
                return Call(std::move(fn), ctx);
            }
            return 0;
        };
        
        duk_push_string(ctx, name);
        duk_push_c_function(ctx, fn, sizeof...(TArgs));
        {
            duk_push_pointer(ctx, (void *) method);
            duk_put_prop_string(ctx, -2, "__func");
        }
        duk_def_prop(ctx, idx - 2, DUK_DEFPROP_HAVE_VALUE | DUK_DEFPROP_SET_ENUMERABLE | DUK_DEFPROP_SET_CONFIGURABLE | DUK_DEFPROP_CLEAR_WRITABLE);
        
    }
    
    template<class T,typename ... TArgs>
    void PushConstructor(duk_context * ctx) {
        
        auto fn =  [](duk_context * ctx) -> duk_ret_t {
            
            kk::Strong<T> v(New<T,TArgs...>(ctx));
            
            duk_push_this(ctx);
            
            SetObject(ctx, -1, v.get());
            
            duk_push_current_function(ctx);
            duk_get_prototype(ctx, -1);
            
            duk_remove(ctx, -2);
            duk_set_prototype(ctx, -2);
            
            duk_pop(ctx);
            
            return 0;
        };
        
        duk_push_c_function(ctx, fn, sizeof...(TArgs));
        
    }
    
    template<class T,typename ... TArgs>
    void PushClass(duk_context * ctx, std::function<void(duk_context *)> && func) {
        
        const Class * isa = & T::Class;
        
        PushConstructor<T,TArgs...>(ctx);
        
        duk_push_object(ctx);
        
        if(isa->isa) {
            SetPrototype(ctx, -1, isa->isa);
        }
        
        if(func != nullptr) {
            func(ctx);
        }
        
        duk_set_prototype(ctx, -2);
        
        duk_put_global_string(ctx, isa->name);
    }
    
    class JSObject : public Object {
    public:
        JSObject(duk_context * ctx, void * heapptr);
        virtual ~JSObject();
        virtual void recycle();
        virtual duk_context * jsContext();
        virtual void * heapptr();
        template<typename T,typename ... TArgs>
        T invoke(JSObject * object,TArgs ... args,typename std::enable_if<std::is_void<T>::value>::type* = 0) {
            
            if(_ctx && _heapptr) {
                
                duk_push_heapptr(_ctx, _heapptr);
                
                if(duk_is_function(_ctx, -1)) {
                    
                    if(object != nullptr && object->jsContext() == _ctx) {
                        duk_push_heapptr(_ctx, object->heapptr());
                    }
                    
                    details::Arguments<sizeof...(TArgs)>::template Set(_ctx,args...);
                    
                    if(object != nullptr && object->jsContext() == _ctx) {
                        if(duk_pcall_method(_ctx, sizeof...(TArgs)) == DUK_EXEC_SUCCESS) {
                            
                        } else {
                            Error(_ctx, -1, "[JSObject]");
                        }
                    } else {
                        if(duk_pcall(_ctx, sizeof...(TArgs)) == DUK_EXEC_SUCCESS) {
                            
                        } else {
                            Error(_ctx, -1, "[JSObject]");
                        }
                    }
                }
                
                duk_pop(_ctx);
                
            }
        }
        
        template<typename T,typename ... TArgs>
        T invoke(JSObject * object,TArgs ... args,typename std::enable_if<!std::is_void<T>::value>::type* = 0) {
            
            Any r;
            
            if(_ctx && _heapptr) {
                
                duk_push_heapptr(_ctx, _heapptr);
                
                if(duk_is_function(_ctx, -1)) {
                    
                    if(object != nullptr && object->jsContext() == _ctx) {
                        duk_push_heapptr(_ctx, object->heapptr());
                    }
                    
                    details::Arguments<sizeof...(TArgs)>::template Set(_ctx,args...);
                    
                    if(object != nullptr && object->jsContext() == _ctx) {
                        if(duk_pcall_method(_ctx, sizeof...(TArgs)) == DUK_EXEC_SUCCESS) {
                            GetAny(_ctx, -1, r);
                        } else {
                            Error(_ctx, -1, "[JSObject]");
                        }
                    } else {
                        if(duk_pcall(_ctx, sizeof...(TArgs)) == DUK_EXEC_SUCCESS) {
                            GetAny(_ctx, -1, r);
                        } else {
                            Error(_ctx, -1, "[JSObject]");
                        }
                    }
                }
                
                duk_pop(_ctx);
                
            }
            
            return (T) r;
        }
        
        template<typename T,typename ... TArgs,typename std::enable_if<std::is_void<T>::value>::type = 0>
        operator std::function<T(TArgs...)>() {
            Strong<JSObject> object = this;
            return [object](TArgs ... args) -> T {
                duk_context * ctx = object->jsContext();
                void * heapptr = object->heapptr();
                if(ctx && heapptr) {
                    
                    duk_push_heapptr(ctx, heapptr);
                    
                    if(duk_is_function(ctx, -1)) {
                        
                        details::Arguments<sizeof...(TArgs)>::template Set(ctx,args...);
                        
                        if(duk_pcall(ctx, sizeof...(TArgs)) == DUK_EXEC_SUCCESS) {
                            
                        } else {
                            Error(ctx, -1, "[JSObject]");
                        }
                        
                    }
                    
                    duk_pop(ctx);
                }
            };
        }
        template<typename T,typename ... TArgs,typename std::enable_if<!std::is_void<T>::value>::type = 0>
        operator std::function<T(TArgs...)>() {
            Strong<JSObject> object = this;
            return [object](TArgs ... args) -> T {
                Any r;
                duk_context * ctx = object->jsContext();
                void * heapptr = object->heapptr();
                if(ctx && heapptr) {
                    
                    duk_push_heapptr(ctx, heapptr);
                    
                    if(duk_is_function(ctx, -1)) {
                        
                        details::Arguments<sizeof...(TArgs)>::template Set(ctx,args...);
                        
                        if(duk_pcall(ctx, sizeof...(TArgs)) == DUK_EXEC_SUCCESS) {
                            GetAny(ctx, -1, r);
                        } else {
                            Error(ctx, -1, "[JSObject]");
                        }
                        
                    }
                    
                    duk_pop(ctx);
                }
                return (T) r;
            };
        }
    protected:
        duk_context * _ctx;
        void * _heapptr;
    };
    
}

#endif /* jit_h */
