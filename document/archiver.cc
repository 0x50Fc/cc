//
//  archiver.cpp
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <document/archiver.h>
#include <core/bio.h>

#define BUF_EX_SIZE 40960

//#define KK_DEBUG_SYNC(...) kk::Log(__VA_ARGS__)

#define KK_DEBUG_SYNC(...)

namespace kk {
    
    static char TAG[] = {'K','K',0x00,0x00};
    
    DocumentArchiver::DocumentArchiver(Byte * data,size_t size):DocumentArchiver() {
        presize(size);
        _length = size;
        memcpy(_data, data, size);
    }

    DocumentArchiver::DocumentArchiver():_data(nullptr),_size(0),_length(0) {
        
    }
    
    DocumentArchiver::~DocumentArchiver() {
        if(_data) {
            free(_data);
        }
    }
    
    void DocumentArchiver::alloc(Document * document,Element * element) {
        append((Byte)DocumentObserverTypeAlloc);
        append((Int64)element->elementId());
        append((CString)element->name());
    }
    
    void DocumentArchiver::root(Document * document,Element * element) {
        append((Byte)DocumentObserverTypeRoot);
        if(element == nullptr ){
            append((Int64) 0);
        } else {
            append((Int64) element->elementId());
        }
    }
    
    void DocumentArchiver::set(Document * document,Element * element,ElementKey key,CString value) {
        append((Byte)DocumentObserverTypeSet);
        append((Int64)element->elementId());
        append((Int64)key);
        append((CString)value);
    }
    
    void DocumentArchiver::append(Document * document, Element * element,Element * e) {
        append((Byte)DocumentObserverTypeAppend);
        append((Int64)element->elementId());
        append((Int64)e->elementId());
    }
    
    void DocumentArchiver::before(Document * document, Element * element,Element * e) {
        append((Byte)DocumentObserverTypeBefore);
        append((Int64)element->elementId());
        append((Int64)e->elementId());
    }
    
    void DocumentArchiver::after(Document * document, Element * element,Element * e) {
        append((Byte)DocumentObserverTypeAfter);
        append((Int64)element->elementId());
        append((Int64)e->elementId());
    }
    
    void DocumentArchiver::remove(Document * document, ElementKey elementId) {
        append((Byte)DocumentObserverTypeRemove);
        append((Int64)elementId);
    }
    
    void DocumentArchiver::key(Document * document, ElementKey key, CString name) {
        append((Byte)DocumentObserverTypeKey);
        append((Int64)key);
        append((CString)name);
    }
    
    static void encodeAttributes(DocumentArchiver * observer,Document * document, Element * element) {
        
        TObject<String,String> * attrs = element->attributes();
        
        if(attrs == nullptr) {
            return;
        }
        
        std::map<String,String>::iterator i = attrs->begin();
        
        while(i != attrs->end()) {
            observer->set(document, element, document->elementKey(i->first.c_str()), i->second.c_str());
            i ++;
        }
        
    }
    
    static void encodeElement(DocumentArchiver * observer,Document * document, Element * element) {
        
        encodeAttributes(observer,document,element);
        
        Element * p = element->firstChild();
        
        while(p) {
            observer->alloc(document, p);
            observer->append(document, element, p);
            encodeElement(observer, document, p);
            p = p->nextSibling();
        }
        
    }
    
    void DocumentArchiver::encode(Document * document) {
        
        {
            std::map<ElementKey,String> & keys = document->elementKeys();
            std::map<ElementKey,String>::iterator i = keys.begin();
            while(i != keys.end()) {
                this->key(document, i->first, i->second.c_str());
                i ++;
            }
        }
        
        {
            Element * p = document->rootElement();
            
            if(p != nullptr) {
                this->alloc(document, p);
                encodeElement(this,document,p);
            }
            
            this->root(document, p);
            
        }
        
    }
    
    Byte * DocumentArchiver::data() {
        return _data;
    }
    
    size_t DocumentArchiver::length() {
        return _length;
    }
    
    
    void DocumentArchiver::append(Byte * data, size_t n) {
        
        presize(n);
        
        memcpy(_data + _length, data, n);
        
        _length += n;
        
    }
    
    void DocumentArchiver::append(Byte byte) {
        append(&byte, 1);
    }
    
    void DocumentArchiver::append(Int32 v) {
        presize(Bio::Int32_Size);
        _length += Bio::encode(v, _data + _length, _size - _length);
    }
    
    void DocumentArchiver::append(Int64 v) {
        presize(Bio::Int64_Size);
        _length += Bio::encode(v, _data + _length, _size - _length);
    }
    
    void DocumentArchiver::append(Boolean v) {
        presize(Bio::Boolean_Size);
        _length += Bio::encode(v, _data + _length, _size - _length);
    }
    
    void DocumentArchiver::append(Float v) {
        presize(Bio::Float_Size);
        _length += Bio::encode(v, _data + _length, _size - _length);
    }
    
    void DocumentArchiver::append(Double v) {
        presize(Bio::Double_Size);
        _length += Bio::encode(v, _data + _length, _size - _length);
    }
    
    void DocumentArchiver::append(CString v) {
        
        size_t n = v == nullptr ? 0 : strlen(v) + 1;
        
        presize(Bio::Int32_Size + n);
        
        _length += Bio::encode((Int32) n, _data + _length, _size - _length);
        
        if(v != nullptr) {
            append((Byte *) v, n);
        }
        
    }
    
    void DocumentArchiver::presize(size_t length) {
        if(_length + length > _size) {
            _size = MAX(sizeof(TAG) + _length + length,_size +BUF_EX_SIZE);
            if(_data == nullptr) {
                _data = (Byte *) malloc(_size);
                memcpy(_data, TAG, sizeof(TAG));
                _length = sizeof(TAG);
            } else {
                _data = (Byte *) realloc(_data, _size);
            }
        }
    }
    
    void DocumentArchiver::decode(Document * document) {
        
        KK_DEBUG_SYNC("[SYNC] >>>>>>>>>>");
        
        Byte * data = _data;
        size_t size = _length;
        
        std::map<ElementKey,Strong<Element>> elements;
        
        size_t n = 0;
        
        if(size >= sizeof(TAG)) {
            
            if(memcmp(data, TAG, sizeof(TAG)) != 0) {
                KK_DEBUG_SYNC("[DOCUMENT] [BINARY] [DECODE] [ERROR] TAG");
                return;
            }
            
            n += sizeof(TAG);
        }
        
        while(n < size) {
            
            Byte v = 0;
            
            n += Bio::decode(&v, data + n, size - n);
            
            if(v == DocumentObserverTypeAlloc ) {
                
                if(size - n >= Bio::Int64_Size + Bio::Int32_Size) {
                    
                    Int64 elementId = 0;
                    Int32 length = 0;
                    n += Bio::decode(& elementId, data + n, size - n);
                    n += Bio::decode(& length, data + n, size - n);
                    
                    if(elementId && length > 0) {
                        Strong<Element> v = document->element(elementId);
                        if(v == nullptr) {
                            Strong<Element> vv = document->createElement(data + n, elementId);
                            elements[elementId] = vv;
                            KK_DEBUG_SYNC("[SYNC] [ALLOC] %lld %s",elementId,data + n);
                        }
                    } else {
                        KK_DEBUG_SYNC("[DOCUMENT] [BINARY] [DECODE] [ERROR] [ALLOC]");
                    }
                    
                    n += length;
                    
                } else {
                    break;
                }
            } else if(v == DocumentObserverTypeRoot) {
                
                if(size - n >= Bio::Int64_Size) {
                    
                    Int64 elementId = 0;
                    
                    n += Bio::decode(& elementId, data + n, size - n);
                    
                    Strong<Element> e = document->element(elementId);
                    
                    document->setRootElement((Element *) e.get());
                    
                    KK_DEBUG_SYNC("[SYNC] [ROOT] %lld",elementId);
                    
                } else {
                    break;
                }
                
            } else if(v == DocumentObserverTypeSet) {
                
                if(size - n >= Bio::Int64_Size + Bio::Int64_Size + Bio::Int32_Size) {
                    
                    Int64 elementId = 0;
                    Int64 key = 0;
                    Int32 length = 0;
                    
                    n += Bio::decode(& elementId, data + n, size - n);
                    n += Bio::decode(& key, data + n, size - n);
                    n += Bio::decode(& length, data + n, size - n);
                    
                    Strong<Element> e = document->element(elementId);
                    Element * element = (Element *) e.get();
                    
                    if(element != nullptr) {
                        
                        CString skey = document->key(key);
                        
                        if(skey != nullptr) {
                            element->set(skey, length == 0 ? nullptr : data + n);
                            KK_DEBUG_SYNC("[SYNC] [SET] %lld %s=%s",elementId,skey, length == 0 ? "" : data + n);
                        }
                        
                    } else {
                        KK_DEBUG_SYNC("[DOCUMENT] [BINARY] [DECODE] [ERROR] [SET]");
                    }
                    
                    n += length;
                    
                } else {
                    break;
                }
            } else if(v == DocumentObserverTypeAppend) {
                
                if(size - n >= Bio::Int64_Size + Bio::Int64_Size ) {
                    
                    Int64 elementId = 0;
                    Int64 eid = 0;
                    
                    n += Bio::decode(& elementId, data + n, size - n);
                    n += Bio::decode(& eid, data + n, size - n);
                    
                    Strong<Element> e = document->element(elementId);
                    Element * element = (Element *) e.get();
                    
                    if(element != nullptr) {
                        
                        Strong<Element> ee = document->element(eid);
                        Element * el = (Element *) ee.get();
                        
                        if(el != nullptr && el->parent() != element) {
                            element->append(el);
                            KK_DEBUG_SYNC("[SYNC] [APPEND] %lld %lld",elementId,eid);
                        }
                        
                    } else {
                        KK_DEBUG_SYNC("[DOCUMENT] [BINARY] [DECODE] [ERROR] [APPEND] %lld %lld",elementId,eid);
                    }
                    
                } else {
                    break;
                }
            } else if(v == DocumentObserverTypeBefore) {
                
                if(size - n >= Bio::Int64_Size + Bio::Int64_Size ) {
                    
                    Int64 elementId = 0;
                    Int64 eid = 0;
                    
                    n += Bio::decode(& elementId, data + n, size - n);
                    n += Bio::decode(& eid, data + n, size - n);
                    
                    Strong<Element> e = document->element(elementId);
                    Element * element = (Element *) e.get();
                    
                    if(element != nullptr) {
                        
                        Strong<Element> ee = document->element(eid);
                        Element * el = (Element *) ee.get();
                        
                        if(el != nullptr && el->nextSibling() != element) {
                            element->before(el);
                        }
                        
                    } else {
                        KK_DEBUG_SYNC("[DOCUMENT] [BINARY] [DECODE] [ERROR] [BEFORE]");
                    }
                    
                } else {
                    break;
                }
            } else if(v == DocumentObserverTypeAfter) {
                
                if(size - n >= Bio::Int64_Size + Bio::Int64_Size ) {
                    
                    Int64 elementId = 0;
                    Int64 eid = 0;
                    
                    n += Bio::decode(& elementId, data + n, size - n);
                    n += Bio::decode(& eid, data + n, size - n);
                    
                    Strong<Element> e = document->element(elementId);
                    Element * element = (Element *) e.get();
                    
                    if(element != nullptr) {
                        
                        Strong<Element> ee = document->element(eid);
                        Element * el = (Element *) ee.get();
                        
                        if(el != nullptr && el->prevSibling() != element) {
                            element->after(el);
                        }
                        
                    } else {
                        KK_DEBUG_SYNC("[DOCUMENT] [BINARY] [DECODE] [ERROR] [AFTER]");
                    }
                    
                } else {
                    break;
                }
            } else if(v == DocumentObserverTypeRemove) {
                
                if(size - n >= Bio::Int64_Size) {
                    
                    Int64 elementId = 0;
                    
                    n += Bio::decode(& elementId, data + n, size - n);
                    
                    Strong<Element> e = document->element(elementId);
                    Element * element = (Element *) e.get();
                    
                    if(element != nullptr) {
                        
                        elements[elementId] = element;
                        
                        element->remove();
                        
                    } else {
                        KK_DEBUG_SYNC("[DOCUMENT] [BINARY] [DECODE] [ERROR] [REMOVE]");
                    }
                    
                } else {
                    break;
                }
            } else if(v == DocumentObserverTypeKey) {
                
                if(size - n >= Bio::Int64_Size + Bio::Int32_Size) {
                    
                    Int64 key = 0;
                    Int32 length = 0;
                    n += Bio::decode(& key, data + n, size - n);
                    n += Bio::decode(& length, data + n, size - n);
                    
                    if(key && length > 0) {
                        document->set((CString) (data + n), key);
                    } else {
                        KK_DEBUG_SYNC("[DOCUMENT] [BINARY] [DECODE] [ERROR] [KEY]");
                    }
                    
                    n += length;
                    
                } else {
                    break;
                }
                
            } else {
                
                KK_DEBUG_SYNC("[DOCUMENT] [BINARY] [DECODE] [ERROR] [TYPE]");
                
            }
            
            
        }
        
        KK_DEBUG_SYNC("[SYNC] <<<<<<<<");
        
        _length = _length - n;
        
    }
    
    
}
