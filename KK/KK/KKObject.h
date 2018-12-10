//
//  KKObject.h
//  KK
//
//  Created by zhanghailong on 2018/11/2.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(__cplusplus)

#include <core/kk.h>
#include <core/jit.h>

#include <objc/runtime.h>

void duk_push_NSObject(duk_context * ctx, id object);
id duk_to_NSObject(duk_context * ctx,duk_idx_t idx);

kk::Any KKObjectToAny(id object);
id KKObjectFromAny(kk::Any & v);

namespace kk {
    
    class OBJCObject : public Object {
    public:
        OBJCObject(::CFTypeRef object);
        virtual ~OBJCObject();
        virtual EXObject EXObject();
    protected:
        ::CFTypeRef _object;
    };
    
    template<void * ISA>
    class TOBJCObject : public OBJCObject {
    public:
        TOBJCObject(::CFTypeRef object):OBJCObject(object){}
        template<SEL NAME,typename TReturn,typename ... TArgs>
        TReturn call(TArgs ... args,typename std::enable_if<std::is_void<TReturn>::value>::type* = 0) {
            @autoreleasepool {
                ::Class isa = (__bridge ::Class) ISA;
                TReturn (*func)(id object,SEL name,TArgs ... args) = (TReturn (*)(id object,SEL name,TArgs ... args)) class_getMethodImplementation(isa, NAME);
                return (func)((__bridge id) _object, NAME , args...);
            }
        }
        
        template<SEL NAME,typename TReturn,typename ... TArgs>
        TReturn call(TArgs ... args,typename std::enable_if<!std::is_void<TReturn>::value>::type* = 0) {
            @autoreleasepool {
                ::Class isa = (__bridge ::Class) ISA;
                TReturn (*func)(id object,SEL name,TArgs ... args) = (TReturn (*)(id object,SEL name,TArgs ... args)) class_getMethodImplementation(isa, NAME);
                (func)((__bridge id) _object, NAME , args...);
            }
        }
    };
    
    
}

typedef kk::JSObject * KKJSObjectRef;

#else

typedef void * KKJSObjectRef;

#endif

@interface KKJSObject : NSObject

@property(nonatomic,readonly,assign) KKJSObjectRef JSObject;

@end

@interface NSObject(KKObject)

-(id) kk_getValue:(NSString *) key;

-(NSString *) kk_getString:(NSString *) key;

-(NSString *) kk_stringValue;

@end
