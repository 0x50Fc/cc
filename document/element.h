//
//  element.h
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef element_h
#define element_h

#include <core/event.h>

namespace kk {
    
    typedef Uint64 ElementKey;
    
    class Element;
    class Document;
    
    class ElementEvent : public Event {
    public:
        ElementEvent(Element * element);
        virtual Element * element();
        virtual Boolean isCancelBubble();
        virtual void cancelBubble();
    protected:
        Boolean _cancelBubble;
        Strong<Element> _element;
    };
    
    class Element : public EventEmitter {
        
    public:
        Element(Document * document,CString name, ElementKey elementId);
        virtual ~Element();
        virtual ElementKey elementId();
        virtual CString name();
        virtual Document * document();
        virtual Int depth();
        
        virtual Element * firstChild();
        virtual Element * lastChild();
        virtual Element * nextSibling();
        virtual Element * prevSibling();
        virtual Element * parent();
        virtual void append(Element * element);
        virtual void before(Element * element);
        virtual void after(Element * element);
        virtual void remove();
        virtual void appendTo(Element * element);
        virtual void beforeTo(Element * element);
        virtual void afterTo(Element * element);
        
        virtual CString get(ElementKey key);
        virtual CString get(CString key);
        virtual void set(ElementKey key,CString value);
        virtual void set(CString key,CString value);
        
        virtual TObject<String,String> * attributes();
        
        
        virtual void emit(CString name,Event * event);
        virtual kk::Boolean hasBubble(CString name);
        
        virtual kk::Object * object(CString key);
        virtual void setObject(CString key,kk::Object * object);
        
        virtual String toString();
        
    protected:
        virtual void onDidAddChildren(Element * element);
        virtual void onDidAddToParent(Element * element);
        virtual void onWillRemoveChildren(Element * element);
        virtual void onWillRemoveFromParent(Element * element);
        
    protected:
        Weak<Document> _document;
        ElementKey _elementId;
        String _name;
        Strong<Element> _firstChild;
        Strong<Element> _lastChild;
        Strong<Element> _nextSibling;
        Weak<Element> _prevSibling;
        Weak<Element> _parent;
        Strong<TObject<String,String>> _attributes;
        std::map<String,Strong<Object>> _objects;
        Int _depth;
    };
    
    
}


#endif /* element_h */
