//
//  archiver.h
//  kk
//
//  Created by hailong11 on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef archiver_h
#define archiver_h

#include <document/document.h>

namespace kk {

    class DocumentArchiver : public Object, public DocumentObserver {
    public:
        DocumentArchiver();
        DocumentArchiver(Byte * data,size_t size);
        virtual ~DocumentArchiver();
        virtual void alloc(Document * document,Element * element);
        virtual void root(Document * document,Element * element);
        virtual void set(Document * document,Element * element,ElementKey key,CString value);
        virtual void append(Document * document, Element * element,Element * e);
        virtual void before(Document * document, Element * element,Element * e);
        virtual void after(Document * document, Element * element,Element * e);
        virtual void remove(Document * document, ElementKey elementId);
        virtual void key(Document * document, ElementKey key, CString name);
        
        virtual void encode(Document * document);
        virtual void decode(Document * document);
        virtual Byte * data();
        virtual size_t length();
        
    protected:
        
        virtual void append(Byte * data, size_t n);
        virtual void append(Byte byte);
        virtual void append(Int32 v);
        virtual void append(Int64 v);
        virtual void append(Boolean v);
        virtual void append(Float v);
        virtual void append(Double v);
        virtual void append(CString v);
        virtual void presize(size_t length);
        
        Byte * _data;
        size_t _length;
        size_t _size;
    };
    
}

#endif /* archiver_h */
