//
//  kk.cc
//  kk
//
//  Created by zhanghailong on 2018/10/24.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <kk/kk.h>
#include <typeinfo>

namespace kk {
    
    Object::Object(): _retainCount(0) {
    }
    
    Object::~Object(){
        
        Atomic * a = Atomic::current();
        
        if(a != nullptr) {
            a->lock();
        }
        
        std::set<Object **>::iterator i =_weakObjects.begin();
        
        while(i != _weakObjects.end()) {
            Object ** v = * i;
            if(v) {
                *v = NULL;
            }
            i ++;
        }
        
        if(a != nullptr) {
            a->unlock();
        }
        
    }
    
    String Object::toString() {
        return String(typeid(this).name());
    }
    
    void Object::release() {
        Atomic * a = Atomic::current();
        if(a != nullptr) {
            a->lock();
        }
        _retainCount --;
        if(_retainCount == 0) {
            if(a != nullptr) {
                a->addObject(this);
            } else {
                delete this;
            }
        }
        if(a != nullptr) {
            a->unlock();
        }
    }
    
    void Object::retain() {
        Atomic * a = Atomic::current();
        if(a != nullptr) {
            a->lock();
        }
        _retainCount ++;
        if(a != nullptr) {
            a->unlock();
        }
    }
    
    int Object::retainCount() {
        return _retainCount;
    }
    
    void Object::weak(Object ** ptr) {
        Atomic * a = Atomic::current();
        if(a != nullptr) {
            a->lock();
        }
        _weakObjects.insert(ptr);
        if(a != nullptr) {
            a->unlock();
        }
    }
    
    void Object::unWeak(Object ** ptr) {
        Atomic * a = Atomic::current();
        if(a != nullptr) {
            a->lock();
        }
        std::set<Object **>::iterator i = _weakObjects.find(ptr);
        if(i != _weakObjects.end()) {
            _weakObjects.erase(i);
        }
        if(a != nullptr) {
            a->unlock();
        }
    }
    
    Atomic::Atomic(){
        
    }
    
    
    Atomic::~Atomic() {
        
    }
    
    void Atomic::lock() {
        _lock.lock();
    }
    
    void Atomic::unlock() {
        
        _lock.unlock();
        
        Object * v = nullptr;
        
        do {
            
            _objectLock.lock();
            
            if(_objects.empty()) {
                v = nullptr;
            } else {
                v = _objects.front();
                _objects.pop();
            }
            
            _objectLock.unlock();
            
            if(v != nullptr && v->retainCount() == 0) {
                delete v;
            }
            
        } while (v);
    }
    
    void Atomic::addObject(Object * object) {
        _objectLock.lock();
        _objects.push(object);
        _objectLock.unlock();
    }
   
    
    Atomic * Atomic::current() {
        static Atomic * a = nullptr;
        if(a == nullptr) {
            a = new Atomic();
        }
        return a;
    }
    
    Ref::Ref():_object(nullptr) {
        
    }
    
    Object * Ref::get() {
        return _object;
    }
    

    Function::~Function() {
        Log("[Function] [dealloc]");
    }
    
    Any::~Any() {
        if(_data) {
            free(_data);
        }
        Log("[Any] [dealloc]");
    }
    
    Any::Any(const Any & v):Any() {
        if(v.type < TypeObject) {
            stringValue = v.stringValue;
            length = v.length;
        }
        type = v.type;
        objectValue = v.objectValue;
        if(v.type == TypeString) {
            setLString(v.stringValue, v.length);
        }
    }
    
    Any::Any():type(TypeNil),objectValue(nullptr),stringValue(nullptr),length(0),_size(0),_data(nullptr) {
        
    }
    
    Any::Any(Function * v):type(TypeFunction),objectValue(v),stringValue(nullptr),length(0),_size(0),_data(nullptr) {
        
    }
    
    Any::Any(Object * v):type(TypeObject),objectValue(v),stringValue(nullptr),length(0),_size(0),_data(nullptr){
        
    }
    
    Any::Any(Int8 v):Any() {
        type = TypeInt8;
        int8Value = v;
    }
    
    Any::Any(Uint8 v):Any() {
        type = TypeUint8;
        uint8Value = v;
    }
    
    Any::Any(Int16 v):Any()  {
        type = TypeInt16;
        int16Value = v;
    }
    
    Any::Any(Uint16 v):Any() {
        type = TypeUint16;
        uint16Value = v;
    }
    
    Any::Any(Int32 v):Any()  {
        type = TypeInt32;
        int32Value = v;
    }
    
    Any::Any(Uint32 v):Any() {
        type = TypeUint32;
        uint32Value = v;
    }
    
    Any::Any(Int64 v):Any()  {
        type = TypeInt64;
        int64Value = v;
    }
    
    Any::Any(Uint64 v):Any() {
        type = TypeUint64;
        uint64Value = v;
    }
    
    Any::Any(Boolean v):Any() {
        type = TypeBoolean;
        booleanValue = v;
    }
    
    Any::Any(Float32 v):Any()  {
        type = TypeFloat32;
        float32Value = v;
    }
    
    Any::Any(Float64 v):Any()  {
        type = TypeFloat64;
        float64Value = v;
    }
    
    Any::Any(String & v):Any() {
        type = TypeString;
        setLString(v.c_str(), v.size());
    }
    
    Any::Any(CString v):Any() {
        if(v != nullptr) {
            type = TypeString;
            setCString(v);
        }
    }
    
    void Any::reset() {
        stringValue = nullptr;
        length = 0;
        objectValue = nullptr;
        type = TypeNil;
    }
    
    Any & Any::operator=(std::nullptr_t v) {
        reset();
        return * this;
    }
    
    Any & Any::operator=(Object *v) {
        reset();
        type = TypeObject;
        objectValue = v;
        return * this;
    }
    
    Any & Any::operator=(Function *v) {
        reset();
        type = TypeFunction;
        objectValue = v;
        return * this;
    }
    
    Any & Any::operator=(Int8 v) {
        reset();
        type = TypeInt8;
        int8Value = v;
        return * this;
    }
    
    Any & Any::operator=(Uint8 v) {
        reset();
        type = TypeUint8;
        uint8Value = v;
        return * this;
    }
    
    Any & Any::operator=(Int16 v) {
        reset();
        type = TypeInt16;
        int16Value = v;
        return * this;
    }
    
    Any & Any::operator=(Uint16 v){
        reset();
        type = TypeUint16;
        uint16Value = v;
        return * this;
    }
    
    Any & Any::operator=(Int32 v) {
        reset();
        type = TypeInt32;
        int32Value = v;
        return * this;
    }
    Any & Any::operator=(Uint32 v) {
        reset();
        type = TypeUint32;
        uint32Value = v;
        return * this;
    }
    
    Any & Any::operator=(Int64 v) {
        reset();
        type = TypeInt64;
        int64Value = v;
        return * this;
    }
    
    Any & Any::operator=(Uint64 v) {
        reset();
        type = TypeUint64;
        uint64Value = v;
        return * this;
    }
    
    Any & Any::operator=(Boolean v) {
        reset();
        type = TypeBoolean;
        booleanValue = v;
        return * this;
    }
    
    Any & Any::operator=(Float32 v) {
        reset();
        type = TypeFloat32;
        float32Value = v;
        return * this;
    }
    
    Any & Any::operator=(Float64 v) {
        reset();
        type = TypeFloat64;
        float64Value = v;
        return * this;
    }
    
    Any & Any::operator=(String & v) {
        reset();
        setLString(v.c_str(), v.length());
        return * this;
    }
    Any & Any::operator=(const String & v) {
        reset();
        setLString(v.c_str(), v.length());
        return * this;
    }
    Any & Any::operator=(CString v) {
        reset();
        if(v != nullptr) {
            type = TypeString;
            setCString(v);
        }
        return * this;
    }
    
    Any::operator CString () {
        switch(type) {
            case TypeInt8:
            {
                return this->sprintf("%d",int8Value);
            }
                break;
            case TypeUint8:
            {
                return this->sprintf( "%u",uint8Value);
            }
                break;
            case TypeInt16:
            {
                return this->sprintf("%d",int16Value);
            }
                break;
            case TypeUint16:
            {
                return this->sprintf("%u",uint16Value);
            }
                break;
            case TypeInt32:
            {
                return this->sprintf("%d",int32Value);
            }
                break;
            case TypeUint32:
            {
                return this->sprintf("%u",uint32Value);
            }
                break;
            case TypeInt64:
            {
                return this->sprintf("%lld",int64Value);
            }
                break;
            case TypeUint64:
            {
                return this->sprintf("%llu",uint64Value);
            }
                break;
            case TypeFloat32:
            {
                return this->sprintf("%g",float32Value);
            }
                break;
            case TypeFloat64:
            {
                return this->sprintf("%g",float64Value);
            }
                break;
            case TypeBoolean:
            {
                return this->sprintf("%s",booleanValue ? "true":"false");
            }
                break;
            default:
                break;
        }
        return stringValue;
    }
    
    Any::operator Int8() {
        switch(type) {
            case TypeInt8:
                return int8Value;
            case TypeUint8:
                return uint8Value;
            case TypeInt16:
                return int16Value;
            case TypeUint16:
                return uint16Value;
            case TypeInt32:
                return int32Value;
            case TypeUint32:
                return uint32Value;
            case TypeInt64:
                return int64Value;
            case TypeUint64:
                return uint64Value;
            case TypeFloat32:
                return float32Value;
            case TypeFloat64:
                return float64Value;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return atoi(stringValue);
            default:
                break;
        }
        return 0;
    }
    Any::operator Uint8() {
        switch(type) {
            case TypeInt8:
                return int8Value;
            case TypeUint8:
                return uint8Value;
            case TypeInt16:
                return int16Value;
            case TypeUint16:
                return uint16Value;
            case TypeInt32:
                return int32Value;
            case TypeUint32:
                return uint32Value;
            case TypeInt64:
                return int64Value;
            case TypeUint64:
                return uint64Value;
            case TypeFloat32:
                return float32Value;
            case TypeFloat64:
                return float64Value;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return atoi(stringValue);
            default:
                break;
        }
        return 0;
    }
    Any::operator Int16() {
        switch(type) {
            case TypeInt8:
                return int8Value;
            case TypeUint8:
                return uint8Value;
            case TypeInt16:
                return int16Value;
            case TypeUint16:
                return uint16Value;
            case TypeInt32:
                return int32Value;
            case TypeUint32:
                return uint32Value;
            case TypeInt64:
                return int64Value;
            case TypeUint64:
                return uint64Value;
            case TypeFloat32:
                return float32Value;
            case TypeFloat64:
                return float64Value;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return atoi(stringValue);
            default:
                break;
        }
        return 0;
    }
    Any::operator Uint16() {
        switch(type) {
            case TypeInt8:
                return int8Value;
            case TypeUint8:
                return uint8Value;
            case TypeInt16:
                return int16Value;
            case TypeUint16:
                return uint16Value;
            case TypeInt32:
                return int32Value;
            case TypeUint32:
                return uint32Value;
            case TypeInt64:
                return int64Value;
            case TypeUint64:
                return uint64Value;
            case TypeFloat32:
                return float32Value;
            case TypeFloat64:
                return float64Value;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return atoi(stringValue);
            default:
                break;
        }
        return 0;
    }
    Any::operator Int32() {
        switch(type) {
            case TypeInt8:
                return int8Value;
            case TypeUint8:
                return uint8Value;
            case TypeInt16:
                return int16Value;
            case TypeUint16:
                return uint16Value;
            case TypeInt32:
                return int32Value;
            case TypeUint32:
                return uint32Value;
            case TypeInt64:
                return (Int32)int64Value;
            case TypeUint64:
                return (Int32)uint64Value;
            case TypeFloat32:
                return float32Value;
            case TypeFloat64:
                return float64Value;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return atoi(stringValue);
            default:
                break;
        }
        return 0;
    }
    Any::operator Uint32() {
        switch(type) {
            case TypeInt8:
                return int8Value;
            case TypeUint8:
                return uint8Value;
            case TypeInt16:
                return int16Value;
            case TypeUint16:
                return uint16Value;
            case TypeInt32:
                return int32Value;
            case TypeUint32:
                return uint32Value;
            case TypeInt64:
                return (Uint32) int64Value;
            case TypeUint64:
                return (Uint32) uint64Value;
            case TypeFloat32:
                return float32Value;
            case TypeFloat64:
                return float64Value;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return atoi(stringValue);
            default:
                break;
        }
        return 0;
    }
    Any::operator Int64() {
        switch(type) {
            case TypeInt8:
                return int8Value;
            case TypeUint8:
                return uint8Value;
            case TypeInt16:
                return int16Value;
            case TypeUint16:
                return uint16Value;
            case TypeInt32:
                return int32Value;
            case TypeUint32:
                return uint32Value;
            case TypeInt64:
                return int64Value;
            case TypeUint64:
                return uint64Value;
            case TypeFloat32:
                return float32Value;
            case TypeFloat64:
                return float64Value;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return atoll(stringValue);
            default:
                break;
        }
        return 0;
    }
    Any::operator Uint64() {
        switch(type) {
            case TypeInt8:
                return int8Value;
            case TypeUint8:
                return uint8Value;
            case TypeInt16:
                return int16Value;
            case TypeUint16:
                return uint16Value;
            case TypeInt32:
                return int32Value;
            case TypeUint32:
                return uint32Value;
            case TypeInt64:
                return int64Value;
            case TypeUint64:
                return uint64Value;
            case TypeFloat32:
                return float32Value;
            case TypeFloat64:
                return float64Value;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return atoll(stringValue);
            default:
                break;
        }
        return 0;
    }
    Any::operator Float32() {
        switch(type) {
            case TypeInt8:
                return int8Value;
            case TypeUint8:
                return uint8Value;
            case TypeInt16:
                return int16Value;
            case TypeUint16:
                return uint16Value;
            case TypeInt32:
                return int32Value;
            case TypeUint32:
                return uint32Value;
            case TypeInt64:
                return int64Value;
            case TypeUint64:
                return uint64Value;
            case TypeFloat32:
                return float32Value;
            case TypeFloat64:
                return float64Value;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return atof(stringValue);
            default:
                break;
        }
        return 0;
    }
    Any::operator Float64() {
        switch(type) {
            case TypeInt8:
                return int8Value;
            case TypeUint8:
                return uint8Value;
            case TypeInt16:
                return int16Value;
            case TypeUint16:
                return uint16Value;
            case TypeInt32:
                return int32Value;
            case TypeUint32:
                return uint32Value;
            case TypeInt64:
                return int64Value;
            case TypeUint64:
                return uint64Value;
            case TypeFloat32:
                return float32Value;
            case TypeFloat64:
                return float64Value;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return atof(stringValue);
            default:
                break;
        }
        return 0;
    }
    Any::operator Boolean() {
        switch(type) {
            case TypeInt8:
                return int8Value != 0;
            case TypeUint8:
                return uint8Value !=0 ;
            case TypeInt16:
                return int16Value != 0;
            case TypeUint16:
                return uint16Value != 0;
            case TypeInt32:
                return int32Value != 0;
            case TypeUint32:
                return uint32Value != 0;
            case TypeInt64:
                return int64Value != 0;
            case TypeUint64:
                return uint64Value != 0;
            case TypeFloat32:
                return float32Value != 0;
            case TypeFloat64:
                return float64Value != 0;
            case TypeBoolean:
                return booleanValue;
            case TypeString:
                return length > 0;
            default:
                return objectValue.get() != nullptr;
        }
    }
    
    Any::operator String() {
        return (CString) (* this);
    }
    
    Any::operator Object*() {
        return objectValue.get();
    }
    
    Any::operator Function*() {
        return dynamic_cast<Function *>(objectValue.get());
    }
    
    CString Any::sprintf(CString format,...) {
        va_list va;
        size_t n = 255;
        
        do {
            
            va_start(va,format);
            
            if(_size == 0) {
                _size = n;
                _data = malloc(_size);
            } else if(_size < n) {
                _size = n;
                _data = realloc(_data, _size);
            }
            
            n = vsnprintf((char *)_data, _size, format, va);
            
            va_end(va);
            
        } while(n > _size);
        
        return (CString) _data;
    }
    
    void Any::setCString(CString string) {
        setLString(string, string ?  strlen(string) : 0);
    }
    
    void Any::setLString(CString string,size_t length) {
        
        if(string) {
            
            if(_size == 0) {
                _size = length + 1;
                _data = malloc(_size);
            } else if(_size < length + 1) {
                _size = length + 1;
                _data = realloc(_data, _size);
            }
            
            memcpy(_data, string, length + 1);
            
            stringValue = (CString) _data;
            length = length;
            
        } else if(_size > 0){
            * (char *) _data = 0;
        }
    }
    
    kk::Boolean String::startsWith(kk::CString s,kk::CString v) {
        if(s == nullptr) {
            return false;
        }
        if(v == nullptr) {
            return true;
        }
        char * p = (char *) s;
        char * a = (char *) v;
        for(;;) {
            if(*a == 0) {
                return true;
            }
            if(*p == 0) {
                return false;
            }
            if(*p != *a) {
                return false;
            }
            a ++;
            p ++;
        }
        return false;
    }

    
    kk::Boolean String::endsWith(kk::CString s,kk::CString v) {
        if(s == nullptr) {
            return false;
        }
        if(v == nullptr) {
            return true;
        }
        size_t n = strlen(s);
        size_t l = strlen(v);
        
        if(l == 0) {
            return true;
        }
        
        if(n < l) {
            return false;
        }
        
        char * p = (char *) s + n -1;
        char * a = (char *) v + l - 1;
        
        for(;;) {
            n --;
            l --;
            a --;
            p --;
            if(l == 0) {
                return true;
            }
            if(n == 0) {
                return false;
            }
            if(*p != *a) {
                return false;
            }
        }
        return false;
    }
    
    kk::Boolean String::startsWith(kk::CString v) {
        return String::startsWith(c_str(), v);
    }
    
    kk::Boolean String::endsWith(kk::CString v){
        return String::endsWith(c_str(),v);
    }
    
    String String::substr(kk::Int i,size_t length) {
        return String(data(),i,length);
    }
    
    String String::substr(kk::Int i) {
        return String(data(),i);
    }

    void LogV(const char * format, va_list va) {
        
        time_t now = time(NULL);
        
        struct tm * p = localtime(&now);
        
        printf("[KK] [%04d-%02d-%02d %02d:%02d:%02d] ",1900 + p->tm_year,p->tm_mon + 1,p->tm_mday,p->tm_hour,p->tm_min,p->tm_sec);
        vprintf(format, va);
        printf("\n");
        
    }
    
    void Log(const char * format, ...) {
        va_list va;
        va_start(va, format);
        LogV(format, va);
        va_end(va);
    }
}

