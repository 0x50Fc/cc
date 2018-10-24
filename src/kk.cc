//
//  kk.cc
//  kk
//
//  Created by zhanghailong on 2018/10/24.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include "kk.h"

namespace kk {
    
    
    String::~String() {
        Log("[String] [dealloc]");
    }
    
    Object::~Object() {
        Log("[Object] [dealloc]");
    }
    
    Function::~Function() {
        Log("[Function] [dealloc]");
    }
    
    Any::Any(const Any * v):Any() {
        
    }
    
    Any::Any():type(TypeNil),objectValue(nullptr) {
        
    }
    
    Any::Any(Function * v):type(TypeFunction),objectValue(v) {
        
    }
    
    Any::Any(Object * v):type(TypeObject),objectValue(v){
        
    }
    
    Any::Any(Int8 v):type(TypeInt8),int8Value(v) {
        
    }
    
    Any::Any(Uint8 v):type(TypeUint8),uint8Value(v) {
        
    }
    
    Any::Any(Int16 v):type(TypeInt16),int16Value(v) {
        
    }
    
    Any::Any(Uint16 v):type(TypeUint16),uint16Value(v) {
        
    }
    
    Any::Any(Int32 v):type(TypeInt32),int32Value(v) {
        
    }
    
    Any::Any(Uint32 v):type(TypeUint32),uint32Value(v) {
        
    }
    
    Any::Any(Int64 v):type(TypeInt64),int64Value(v) {
        
    }
    
    Any::Any(Uint64 v):type(TypeUint64),uint64Value(v) {
        
    }
    
    Any::Any(Boolean v):type(TypeBoolean),booleanValue(v) {
        
    }
    
    Any::Any(Float32 v):type(TypeFloat32),float32Value(v) {
        
    }
    
    Any::Any(Float64 v):type(TypeFloat64),float64Value(v) {
        
    }
    
    Any::Any(String & v):type(TypeString),stringValue(v) {
        
    }
    
    Any::Any(CString v):type(TypeString),stringValue(v) {
        
    }
    
    Any & Any::operator=(std::nullptr_t v) {
        type = TypeNil;
        objectValue = nullptr;
        stringValue.clear();
        return * this;
    }
    
    Any & Any::operator=(Object *v) {
        type = TypeObject;
        objectValue = std::shared_ptr<Object>(v);
        stringValue.clear();
        return * this;
    }
    
    Any & Any::operator=(Function *v) {
        type = TypeFunction;
        objectValue = std::shared_ptr<Object>(v);
        stringValue.clear();
        return * this;
    }
    
    Any & Any::operator=(Int8 v) {
        type = TypeInt8;
        objectValue = nullptr;
        stringValue.clear();
        int8Value = v;
        return * this;
    }
    
    Any & Any::operator=(Uint8 v) {
        type = TypeUint8;
        objectValue = nullptr;
        stringValue.clear();
        uint8Value = v;
        return * this;
    }
    
    Any & Any::operator=(Int16 v) {
        type = TypeInt16;
        objectValue = nullptr;
        stringValue.clear();
        int16Value = v;
        return * this;
    }
    
    Any & Any::operator=(Uint16 v){
        type = TypeUint16;
        objectValue = nullptr;
        stringValue.clear();
        uint16Value = v;
        return * this;
    }
    
    Any & Any::operator=(Int32 v) {
        type = TypeInt32;
        objectValue = nullptr;
        stringValue.clear();
        int32Value = v;
        return * this;
    }
    Any & Any::operator=(Uint32 v) {
        type = TypeUint32;
        objectValue = nullptr;
        stringValue.clear();
        uint32Value = v;
        return * this;
    }
    
    Any & Any::operator=(Int64 v) {
        type = TypeInt64;
        objectValue = nullptr;
        stringValue.clear();
        int64Value = v;
        return * this;
    }
    
    Any & Any::operator=(Uint64 v) {
        type = TypeUint64;
        objectValue = nullptr;
        stringValue.clear();
        uint64Value = v;
        return * this;
    }
    
    Any & Any::operator=(Boolean v) {
        type = TypeBoolean;
        objectValue = nullptr;
        stringValue.clear();
        booleanValue = v;
        return * this;
    }
    
    Any & Any::operator=(Float32 v) {
        type = TypeFloat32;
        objectValue = nullptr;
        stringValue.clear();
        float32Value = v;
        return * this;
    }
    
    Any & Any::operator=(Float64 v) {
        type = TypeFloat64;
        objectValue = nullptr;
        stringValue.clear();
        float64Value = v;
        return * this;
    }
    
    Any & Any::operator=(String & v) {
        type = TypeFloat64;
        objectValue = nullptr;
        stringValue = v;
        return * this;
    }
    Any & Any::operator=(CString v) {
        type = TypeFloat64;
        objectValue = nullptr;
        stringValue = v;
        return * this;
    }
    
    Any & Any::operator=(const Any & v) {
        type = v.type;
        objectValue = v.objectValue;
        stringValue = v.stringValue;
        uint64Value = v.uint64Value;
        return * this;
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

