//
//  KKObject.m
//  KK
//
//  Created by hailong11 on 2018/11/2.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "KKObject.h"

void duk_push_NSObject(duk_context * ctx, id object) {
    
    if(object == nil) {
        duk_push_undefined(ctx);
        return;
    }
    
    if([object isKindOfClass:[NSString class]]) {
        duk_push_string(ctx, [object UTF8String]);
        return;
    }
    
    if([object isKindOfClass:[NSNumber class]]) {
        if(strcmp( [object objCType],@encode(BOOL)) == 0) {
            duk_push_boolean(ctx, [object boolValue]);
        } else {
            duk_push_number(ctx, [object doubleValue]);
        }
        return ;
    }
    
    if([object isKindOfClass:[NSValue class]]) {
        duk_push_string(ctx, [[object description] UTF8String]);
        return;
    }
    
    if([object isKindOfClass:[NSArray class]]) {
        duk_push_array(ctx);
        duk_uarridx_t i = 0;
        for(id v in object) {
            duk_push_NSObject(ctx, v);
            duk_put_prop_index(ctx, -2, i);
            i++;
        }
        return;
    }
    
    if([object isKindOfClass:[NSDictionary class]]) {
        duk_push_object(ctx);
        NSEnumerator * keyEnum = [object keyEnumerator];
        id key;
        while((key = [keyEnum nextObject])) {
            id v = [object objectForKey:key];
            duk_push_string(ctx, [key UTF8String]);
            duk_push_NSObject(ctx, v);
            duk_put_prop(ctx, -3);
        }
        return;
    }
    
    duk_push_undefined(ctx);
    return;
    
}

id duk_to_NSObject(duk_context * ctx,duk_idx_t idx) {
    
    duk_int_t type = duk_get_type(ctx, idx);
    
    switch (type) {
        case DUK_TYPE_STRING:
        return [NSString stringWithCString:duk_to_string(ctx, idx) encoding:NSUTF8StringEncoding];
        case DUK_TYPE_NUMBER:
        return [NSNumber numberWithDouble:duk_to_number(ctx, idx)];
        case DUK_TYPE_BOOLEAN:
        return [NSNumber numberWithBool:duk_to_boolean(ctx, idx)];
        case DUK_TYPE_OBJECT:
        if(duk_is_array(ctx, idx)) {
            NSMutableArray * vs = [NSMutableArray arrayWithCapacity:4];
            duk_enum(ctx, idx, DUK_ENUM_ARRAY_INDICES_ONLY);
            while(duk_next(ctx, -1, 1)) {
                id v = duk_to_NSObject(ctx, -1);
                if(v) {
                    [vs addObject:v];
                }
                duk_pop_2(ctx);
            }
            duk_pop(ctx);
            return vs;
        } else {
            NSMutableDictionary * data = [NSMutableDictionary dictionaryWithCapacity:4];
            duk_enum(ctx, idx, DUK_ENUM_INCLUDE_SYMBOLS);
            while(duk_next(ctx, -1, 1)) {
                id key = duk_to_NSObject(ctx, -2);
                id v = duk_to_NSObject(ctx, -1);
                if(key && v) {
                    [data setObject:v forKey:key];
                }
                duk_pop_2(ctx);
            }
            duk_pop(ctx);
            return data;
        }
        case DUK_TYPE_BUFFER:
        if(duk_is_buffer_data(ctx, idx)) {
            duk_size_t size = 0;
            void * bytes = duk_get_buffer_data(ctx, idx, &size);
            return [NSData dataWithBytes:bytes length:size];
        } else {
            duk_size_t size = 0;
            void * bytes = duk_get_buffer(ctx, idx, &size);
            return [NSData dataWithBytes:bytes length:size];
        }
        default:
        return nil;
    }
    
}


kk::Any KKObjectToAny(id object) {
    kk::Any v;
    
    if([object isKindOfClass:[NSNumber class]]) {
        if(strcmp([object objCType], @encode(BOOL)) == 0) {
            v = (kk::Boolean) [object boolValue];
        } else if(strcmp([object objCType], @encode(double)) == 0) {
            v = (kk::Double) [object doubleValue];
        } else if(strcmp([object objCType], @encode(float)) == 0) {
            v = (kk::Float) [object floatValue];
        } else if(strcmp([object objCType], @encode(int)) == 0) {
            v = (kk::Int) [object intValue];
        } else if(strcmp([object objCType], @encode(unsigned int)) == 0) {
            v = (kk::Uint) [object unsignedIntValue];
        } else if(strcmp([object objCType], @encode(long long)) == 0) {
            v = (kk::Int64) [object longLongValue];
        } else if(strcmp([object objCType], @encode(unsigned long long)) == 0) {
            v = (kk::Uint64) [object unsignedLongLongValue];
        } else {
            v = (kk::Double) [object doubleValue];
        }
    } else if([object isKindOfClass:[NSString class]]) {
        v = (kk::CString) [object UTF8String];
    } else if([object isKindOfClass:[NSArray class]]) {
        
        kk::Array<kk::Any> * items = new kk::Array<kk::Any>();
        
        for(id item in object) {
            kk::Any i = KKObjectToAny(item);
            items->push(i);
        }
        
        v = (kk::Object *) items;
        
    } else if([object isKindOfClass:[NSDictionary class]]) {
        kk::TObject<kk::String, kk::Any> * m = new kk::TObject<kk::String, kk::Any>();
        
        NSEnumerator * keyEnum = [object keyEnumerator];
        NSString * key ;
        while((key = [keyEnum nextObject])) {
            id v = [object objectForKey:key];
            kk::CString skey = [key UTF8String];
            (*m)[skey] = KKObjectToAny(v);
        }
        
        v = (kk::Object *) m;
    }
    
    return v;
}

id KKObjectFromAny(kk::Any & v) {
    switch (v.type) {
        case kk::TypeInt8:
        return [NSNumber numberWithInt:v.int8Value];
        case kk::TypeInt16:
        return [NSNumber numberWithInt:v.int16Value];
        case kk::TypeInt32:
        return [NSNumber numberWithInt:v.int32Value];
        case kk::TypeInt64:
        return [NSNumber numberWithLongLong:v.int64Value];
        case kk::TypeUint8:
        return [NSNumber numberWithUnsignedInt:v.uint8Value];
        case kk::TypeUint16:
        return [NSNumber numberWithUnsignedInt:v.uint16Value];
        case kk::TypeUint32:
        return [NSNumber numberWithUnsignedInt:v.uint32Value];
        case kk::TypeUint64:
        return [NSNumber numberWithUnsignedLongLong:v.uint64Value];
        case kk::TypeBoolean:
        return [NSNumber numberWithBool:v.booleanValue];
        case kk::TypeString:
        return [NSString stringWithCString:v.stringValue encoding:NSUTF8StringEncoding];
        case kk::TypeObject:
        {
            kk::_TObject * object = dynamic_cast<kk::_TObject *>(v.objectValue.get());
            if(object) {
                NSMutableDictionary * m = [NSMutableDictionary dictionaryWithCapacity:4];
                object->forEach([m](kk::Any & key,kk::Any & value)->void{
                    kk::CString skey = key;
                    id vv = KKObjectFromAny(value);
                    if(skey) {
                        [m setObject:vv forKey:[NSString stringWithCString:skey encoding:NSUTF8StringEncoding]];
                    }
                });
                return m;
            }
        }
        {
            kk::_Array * object = dynamic_cast<kk::_Array *>(v.objectValue.get());
            if(object) {
                NSMutableArray * m = [NSMutableArray arrayWithCapacity:4];
                object->forEach([m](kk::Any & value)->void{
                    id vv = KKObjectFromAny(value);
                    if(vv) {
                        [m addObject:vv];
                    }
                });
                return m;
            }
        }
        {
            kk::JSObject * object = dynamic_cast<kk::JSObject *>(v.objectValue.get());
            if(object) {
                duk_context * ctx = object->jsContext();
                void * heapptr = object->heapptr();
                if(ctx && heapptr) {
                    duk_push_heapptr(ctx, heapptr);
                    id vv = duk_to_NSObject(ctx,-1);
                    duk_pop(ctx);
                    return vv;
                }
            }
        }

        default:
        break;
    }
    return nil;
}


@implementation NSObject(KKObject)

-(id) kk_getValue:(NSString *) key {
    @try {
        return [self valueForKey:key];
    }
    @catch(NSException *ex) {
        
    }
    return nil;
}

-(NSString *) kk_getString:(NSString *) key {
    return [[self kk_getValue:key] kk_stringValue];
}

-(NSString *) kk_stringValue {
    if([self isKindOfClass:[NSString class]]) {
        return (NSString *) self;
    }
    return [self description];
}

@end
