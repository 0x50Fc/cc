//
//  document.h
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef document_h
#define document_h

#include <document/element.h>

namespace kk {


    class Document;
    
    enum DocumentObserverType {
        DocumentObserverTypeAlloc,
        DocumentObserverTypeRoot,
        DocumentObserverTypeSet,
        DocumentObserverTypeAppend,
        DocumentObserverTypeBefore,
        DocumentObserverTypeAfter,
        DocumentObserverTypeRemove,
        DocumentObserverTypeKey
    };
    
    class DocumentObserver {
    public:
        virtual void alloc(Document * document,Element * element) = 0;
        virtual void root(Document * document,Element * element) = 0;
        virtual void set(Document * document,Element * element,ElementKey key,CString value) = 0;
        virtual void append(Document * document, Element * element,Element * e) = 0;
        virtual void before(Document * document, Element * element,Element * e) = 0;
        virtual void after(Document * document, Element * element,Element * e) = 0;
        virtual void remove(Document * document, ElementKey elementId) = 0;
        virtual void key(Document * document, ElementKey key, CString name) = 0;
    };
    
    typedef TFunction<Element *, Document *,CString,ElementKey> LibraryCreateElementFunction;
    
    class Library : public Object {
    public:
        Library();
        virtual void add(CString name,TFunction<Element *, Document *,CString,ElementKey>  * func);
        virtual void def(TFunction<Element *, Document *,CString,ElementKey>  * func);
        virtual Strong<Element> createElement(Document * document,CString name,ElementKey elementId);
        static Library * defaultLibrary();
    protected:
        std::map<String,Strong<TFunction<Element *, Document *,CString,ElementKey>>> _funcs;
    };
    
    class Document : public EventEmitter {
    public:
        Document();
        Document(Library * library);
        virtual ~Document();
        virtual Element * rootElement();
        virtual void setRootElement(Element * element);
        virtual Strong<Element> createElement(CString name);
        virtual Strong<Element> createElement(CString name,ElementKey elementId);
        virtual Strong<Element> element(ElementKey elementId);
        virtual void elementsByName(CString name,std::list<Strong<Element>> & elements);
        virtual void set(CString name,ElementKey key);
        virtual ElementKey elementKey(CString name);
        virtual kk::CString key(ElementKey key);
        virtual void beginObserver(DocumentObserver * observer);
        virtual DocumentObserver * getObserver();
        virtual void endObserver();
        
        virtual std::map<ElementKey,String> & elementKeys();
        
        virtual String toString();
        
    protected:
        Strong<Library> _library;
        ElementKey _autoKey;
        Strong<Element> _rootElement;
        std::map<ElementKey,String> _elementKeys;
        std::map<String,ElementKey> _keys;
        std::list<DocumentObserver *> _observers;
        std::map<ElementKey,Weak<Element>> _elements;
        std::map<String,std::list<Weak<Element>>> _elementsByName;
    };
    
    
}

#endif /* document_h */
