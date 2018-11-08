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

void duk_push_NSObject(duk_context * ctx, id object);
id duk_to_NSObject(duk_context * ctx,duk_idx_t idx);

kk::Any KKObjectToAny(id object);
id KKObjectFromAny(kk::Any & v);

#endif


@interface NSObject(KKObject)

-(id) kk_getValue:(NSString *) key;

-(NSString *) kk_getString:(NSString *) key;

-(NSString *) kk_stringValue;

@end
