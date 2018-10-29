//
//  kk.h
//  kk
//
//  Created by zhanghailong on 2018/10/24.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef kk_kk_h
#define kk_kk_h

#include <string>
#include <functional>
#include <vector>
#include <map>
#include <set>
#include <thread>
#include <queue>

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
        virtual kk::Boolean startsWith(kk::CString v);
        virtual kk::Boolean startsWith(kk::String &v);
        virtual kk::Boolean endsWith(kk::CString v);
        virtual kk::Boolean endsWith(kk::String &v);
        virtual String substr(kk::Int i,size_t length);
        virtual String substr(kk::Int i);
    };
    
    struct Class {
        const Class * isa;
        CString name;
    };
    
    
#define KK_CLASS(T,S) \
public: \
virtual const kk::Class * isa() { return T::Class(); } \
static const kk::Class * Class() { \
    static kk::Class isa = { S::Class() , #T }; \
    return & isa; \
};

    class Object {
        
    private:
        int _retainCount;
        std::set<Object **> _weakObjects;
    public:
        
        Object();
        
        virtual ~Object();
        
        virtual String toString();
        
        virtual void release();
        
        virtual void retain();
        
        virtual int retainCount();
        
        virtual void weak(Object ** ptr);
        
        virtual void unWeak(Object ** ptr);
        
        virtual const Class * isa() { return Object::Class(); }
        
        static const Class * Class() {
            static kk::Class isa = { nullptr, "Object" };
            return & isa;
        };
    };
    
    class Atomic {
    public:
        Atomic();
        virtual ~Atomic();
        virtual void lock();
        virtual void unlock();
        virtual void addObject(Object * object);
        static Atomic * current();
    protected:
        std::mutex _lock;
        std::mutex _objectLock;
        std::queue<Object *> _objects;
    };
    
    class Ref {
    public:
        Ref();
        virtual Object * get();
        virtual void set(Object * object) = 0;
    protected:
        Object * _object;
    };
    
    template<class T = Object>
    class Strong : public Ref {
    public:
        Strong():Ref(){}
        Strong(T * object):Ref(){
            set((Object *)object);
        }
        Strong(const Strong &ref):Ref(){
            set(ref._object);
        }
        virtual ~Strong() {
            if(_object) {
                _object->release();
            }
        }
        virtual void set(Object * object) {
            if(object) {
                object->retain();
            }
            if(_object) {
                _object->release();
            }
            _object = object;
        }
        Strong& operator=(T * object) {
            set(object);
            return *this;
        }
        Strong& operator=(const Strong& ref) {
            set(ref._object);
            return *this;
        }
        operator T*() {
            return (T *) _object;
        }
        T * operator->() const {
            return (T *) _object;
        }
        T * operator * () const {
            return (T *) _object;
        }
    };
    
    template<class T = Object>
    class Weak : public Ref {
    public:
        Weak():Ref(){}
        Weak(T * object):Ref(){
            set((Object *)object);
        }
        Weak(const Weak & ref):Ref() {
            set(ref.get());
        }
        virtual ~Weak() {
            if(_object != nullptr) {
                _object->unWeak(&_object);
            }
        }
        virtual void set(Object * object) {
            if(object != nullptr) {
                object->unWeak(&_object);
            }
            if(_object != nullptr) {
                _object->weak(&_object);
            }
            _object = object;
        }
        Weak& operator=(T * object) {
            set(object);
            return *this;
        }
        Weak& operator=(const Weak& ref) {
            set(ref._object);
            return *this;
        }
        operator T*() {
            return (T *) _object;
        }
        T * operator->() const {
            return _object;
        }
        T * operator * () const {
            return _object;
        }
    };
    
    class Function : public Object {
    public:
        virtual ~Function();
    };
    
    template<typename T,typename ... TArgs>
    class TFunction : public Function {
    public:
        TFunction(std::function<T(TArgs ...)> && func):_func(func){}
        T operator()(TArgs ... args) {
            return _func(args...);
        }
        operator std::function<T(TArgs ...)>&() {
            return _func;
        }
    private:
        std::function<T(TArgs ...)> _func;
    };
    
    class Any {
    public:
        Any(void);
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
        Any(const Any & v);
        virtual ~Any();
        Type type;
        Strong<Object> objectValue;
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
            struct {
                CString stringValue;
                size_t length;
            };
        };
        template<typename T,typename ... TArgs>
        T call(TArgs && ... args) {
            TFunction<T,TArgs...> * fn = (TFunction<T,TArgs...> *) objectValue.get();
            return (*fn)(args...);
        }
        
        template<typename T,typename ... TArgs>
        operator std::function<T(TArgs...)> &() {
            TFunction<T,TArgs...> * fn = (TFunction<T,TArgs...> *) objectValue.get();
            return * fn;
        }
        template<class T>
        operator Strong<T>() {
            return dynamic_cast<T*>(objectValue.get());
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
        
        operator CString();
        operator Int8();
        operator Uint8();
        operator Int16();
        operator Uint16();
        operator Int32();
        operator Uint32();
        operator Int64();
        operator Uint64();
        operator Float32();
        operator Float64();
        operator Boolean();
        operator String();
        operator Object*();
        operator Function*();
        
    protected:
        virtual void reset();
        virtual CString sprintf(CString format,...);
        virtual void setCString(CString string);
        virtual void setLString(CString string,size_t length);
        void * _data;
        size_t _size;
    };
    
    class _Array : public Object {
    public:
        virtual void forEach(std::function<void(Any&)> && func) = 0;
    };
    
    template<typename T>
    class Array : public _Array {
    public:
        Array(){}
        Array(std::initializer_list<T> v):_items(v){}
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
        virtual void forEach(std::function<void(Any&)> && func) {
            Any item;
            typename std::vector<T>::iterator i = _items.begin();
            while(i != _items.end()) {
                item = * i;
                func(item);
                i ++;
            }
        }
    private:
        std::vector<T> _items;
    };
    
    class _TObject : public Object {
    public:
        virtual void forEach(std::function<void(Any&,Any&)> && func) = 0;
    };
    
    template<typename TKey,typename TValue>
    class TObject : public _TObject {
    public:
        TObject(){}
        TObject(std::initializer_list<std::pair<TKey,TValue>> v):_items(v){}
        
        TValue & operator[](TKey key) {
            return _items[key];
        }
        typename std::map<TKey,TValue>::iterator begin() {
            return _items.begin();
        }
        typename std::map<TKey,TValue>::iterator end() {
            return _items.end();
        }
        virtual void forEach(std::function<void(Any&,Any&)> && func) {
            Any key,value;
            typename std::map<TKey,TValue>::iterator i = _items.begin();
            while(i != _items.end()) {
                key = i->first;
                value = i->second;
                func(value,key);
                i ++;
            }
        }
    private:
        std::map<TKey,TValue> _items;
    };
    
    
    void LogV(const char * format, va_list va);
    
    void Log(const char * format, ...);
    
}

#endif /* kk_h */
