//
//  kk.h
//  kk
//
//  Created by zhanghailong on 2018/10/24.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef kk_h
#define kk_h

#include <string>
#include <functional>
#include <vector>
#include <map>

namespace kk {
    
    typedef int Int;
    typedef unsigned int Uint;
    typedef char Int8;
    typedef unsigned char Uint8;
    typedef short Int16;
    typedef unsigned short Uint16;
    typedef int Int32;
    typedef unsigned int Uint32;
    typedef long long Int64;
    typedef unsigned long long Uint64;
    typedef double Double;
    typedef float Float;
    typedef float Float32;
    typedef double Float64;
    typedef bool Boolean;
    typedef const char * CString;
    
    enum Type {
        TypeNil,
        TypeInt8,
        TypeUint8,
        TypeInt16,
        TypeUint16,
        TypeInt32,
        TypeUint32,
        TypeInt64,
        TypeUint64,
        TypeFloat32,
        TypeFloat64,
        TypeBoolean,
        TypeObject,
        TypeFunction,
        TypeString,
    };
    
    class String : public std::string {
    public:
        using std::string::string;
        virtual ~String();
    };
    
    class Object {
    public:
        virtual ~Object();
    };
    
    class Function : public Object {
    public:
        virtual ~Function();
    };
    
    template<typename T,typename ... TArgs>
    class TFunction : public Function {
    public:
        TFunction(std::function<T(TArgs ...)> func):_func(func){}
        T operator()(TArgs ... args) {
            return _func(args...);
        }
    private:
        std::function<T(TArgs ...)> _func;
    };
    
    template<typename T>
    class Array : public Object {
    public:
        T & operator[](kk::Int i) {
            return _items[i];
        }
        kk::Int length() {
            return _items.size();
        }
        typename std::vector<T>::iterator begin() {
            return _items.begin();
        }
        typename std::vector<T>::iterator end() {
            return _items.end();
        }
    private:
        std::vector<T> _items;
    };
    
    template<typename TKey,typename TValue>
    class TObject : public Object {
    public:
        TValue & operator[](TKey key) {
            return _items[key];
        }
        typename std::map<TKey,TValue>::iterator begin() {
            return _items.begin();
        }
        typename std::map<TKey,TValue>::iterator end() {
            return _items.end();
        }
    private:
        std::map<TKey,TValue> _items;
    };
    
    class Any {
    public:
        Any();
        Any(Function * v);
        Any(Object * v);
        Any(Int8 v);
        Any(Uint8 v);
        Any(Int16 v);
        Any(Uint16 v);
        Any(Int32 v);
        Any(Uint32 v);
        Any(Int64 v);
        Any(Uint64 v);
        Any(Boolean v);
        Any(Float32 v);
        Any(Float64 v);
        Any(String & v);
        Any(CString v);
        Any(const Any * v);
        Type type;
        String stringValue;
        std::shared_ptr<Object> objectValue;
        union {
            Int8 int8Value;
            Uint8 uint8Value;
            Int16 int16Value;
            Uint16 uint16Value;
            Int32 int32Value;
            Uint32 uint32Value;
            Int64 int64Value;
            Uint64 uint64Value;
            Boolean booleanValue;
            Float32 float32Value;
            Float64 float64Value;
        };
        template<typename T,typename ... TArgs>
        T call(TArgs && ... args) {
            TFunction<T,TArgs...> * fn = (TFunction<T,TArgs...> *) objectValue.get();
            return (*fn)(args...);
        }
        Any & operator=(std::nullptr_t v);
        Any & operator=(Object *v);
        Any & operator=(Function *v);
        Any & operator=(Int8 v);
        Any & operator=(Uint8 v);
        Any & operator=(Int16 v);
        Any & operator=(Uint16 v);
        Any & operator=(Int32 v);
        Any & operator=(Uint32 v);
        Any & operator=(Int64 v);
        Any & operator=(Uint64 v);
        Any & operator=(Boolean v);
        Any & operator=(Float32 v);
        Any & operator=(Float64 v);
        Any & operator=(String & v);
        Any & operator=(CString v);
        Any & operator=(const Any & v);
    };
    
    void LogV(const char * format, va_list va);
    
    void Log(const char * format, ...);
    
}

#endif /* kk_h */
