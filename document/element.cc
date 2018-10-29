//
//  element.cc
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <document/document.h>
#include <typeinfo>

namespace kk {
    
    ElementEvent::ElementEvent(Element * element):Event(),_cancelBubble(false) {
        
    }
    
    Element * ElementEvent::element() {
        return _element;
    }
    
    Boolean ElementEvent::isCancelBubble() {
        return _cancelBubble;
    }
    
    void ElementEvent::cancelBubble() {
        _cancelBubble =true;
    }
    
    Object * ElementEvent::data() {
        return _data;
    }
    
    void ElementEvent::setData(Object * data) {
        _data = data;
    }
    
    Element::Element(Document * document,CString name, ElementKey elementId)
        :_document(document),_name(name),_elementId(elementId),_depth(0) {
        
    }
    
    Element::~Element() {
        
    }
    
    ElementKey Element::elementId() {
        return _elementId;
    }
    
    CString Element::name() {
        return _name.c_str();
    }
    
    Document * Element::document() {
        return (Document *) _document.get();
    }
    
    Int Element::depth() {
        return _depth;
    }
    
    Element * Element::firstChild() {
        return (Element *) _firstChild.get();
    }
    
    Element * Element::lastChild() {
        return (Element *) _lastChild.get();
    }
    
    Element * Element::nextSibling() {
        return (Element *) _nextSibling.get();
    }
    
    Element * Element::prevSibling() {
        return (Element *) _prevSibling.get();
    }
    
    Element * Element::parent() {
        return (Element *) _parent.get();
    }
    
    void Element::append(Element * element) {
        
        if(element == nullptr) {
            return;
        }
        
        Strong<Element> e(element);
        
        element->remove();
        
        Element * lastChild = this->lastChild();
        
        if(lastChild) {
            lastChild->_nextSibling = element;
            element->_prevSibling = lastChild;
            _lastChild = element;
            element->_parent = this;
        } else {
            _firstChild = _lastChild = element;
            element->_parent = this;
        }
        
        {
            Document * v = document();
            
            if(v != nullptr) {
                
                DocumentObserver * observer = v->getObserver();
                
                if(observer) {
                    observer->append(v, this, element);
                }
                
            }
            
        }
        
        onDidAddChildren(element);
        
    }
    
    void Element::before(Element * element) {
        
        if(element == nullptr) {
            return;
        }
        
        Strong<Element> e(element);
        
        element->remove();
        
        Element * prevSibling = this->prevSibling();
        Element * parent = this->parent();
        
        if(prevSibling) {
            prevSibling->_nextSibling = element;
            element->_prevSibling = prevSibling;
            element->_nextSibling = this;
            element->_parent = parent;
            _prevSibling = element;
        } else if(parent) {
            element->_nextSibling = this;
            element->_parent = parent;
            _prevSibling = element;
            parent->_firstChild = element;
        }
        
        if(parent) {
            
            {
                Document * v = document();
                
                if(v != nullptr) {
                    
                    DocumentObserver * observer = v->getObserver();
                    
                    if(observer) {
                        observer->before(v, this, element);
                    }
                    
                }
                
            }
            
            parent->onDidAddChildren(element);
        }
    }
    
    void Element::after(Element * element) {
        
        if(element == nullptr){
            return;
        }
        
        Strong<Element> e(element);
        
        element->remove();
        
        Element * nextSibling = this->nextSibling();
        Element * parent = this->parent();
        
        if(nextSibling) {
            nextSibling->_prevSibling = element;
            element->_nextSibling = nextSibling;
            element->_prevSibling = this;
            element->_parent = parent;
            _nextSibling = element;
        } else if(parent) {
            element->_prevSibling = this;
            element->_parent = parent;
            _nextSibling = element;
            parent->_lastChild = element;
        }
        
        if(parent) {
            
            {
                Document * v = document();
                
                if(v != nullptr) {
                    
                    DocumentObserver * observer = v->getObserver();
                    
                    if(observer) {
                        observer->after(v, this, element);
                    }
                    
                }
                
            }
            
            parent->onDidAddChildren(element);
        }
    }
    
    void Element::remove() {
        
        Strong<Element> e(this);
        
        Element * prevSibling = this->prevSibling();
        Element * nextSibling = this->nextSibling();
        Element * parent = this->parent();
        
        if(prevSibling) {
            parent->onWillRemoveChildren(this);
            prevSibling->_nextSibling = nextSibling;
            if(nextSibling) {
                nextSibling->_prevSibling = prevSibling;
            } else {
                parent->_lastChild = prevSibling;
            }
        } else if(parent) {
            parent->onWillRemoveChildren(this);
            parent->_firstChild = nextSibling;
            if(nextSibling) {
                nextSibling->_prevSibling = (Element *) nullptr;
            } else {
                parent->_lastChild = (Element *) nullptr;
            }
        }
        
        _parent = nullptr;
        _prevSibling = nullptr;
        _nextSibling = nullptr;
        
        if(parent) {
            {
                Document * v = document();
                
                if(v != nullptr) {
                    
                    DocumentObserver * observer = v->getObserver();
                    
                    if(observer) {
                        observer->remove(v, _elementId);
                    }
                    
                }
                
            }
        }
    }
    
    void Element::appendTo(Element * element) {
        if(element != nullptr) {
            element->append(this);
        }
    }
    
    void Element::beforeTo(Element * element) {
        if(element != nullptr) {
            element->before(this);
        }
    }
    
    void Element::afterTo(Element * element) {
        if(element != nullptr) {
            element->after(this);
        }
    }
    
    void Element::onDidAddChildren(Element * element) {
        element->onDidAddToParent(this);
        element->_depth = _depth + 1;
    }
    
    void Element::onWillRemoveChildren(Element * element) {
        element->onWillRemoveFromParent(this);
        element->_depth = 0;
    }
    
    void Element::onDidAddToParent(Element * element) {
        
    }
    
    void Element::onWillRemoveFromParent(Element * element) {
        
    }
    
    void Element::set(ElementKey key,CString value) {
        Document * v = document();
        if(v == nullptr) {
            return;
        }
        set(v->key(key),value);
    }
    
    CString Element::get(CString key) {
        
        if(_attributes == nullptr) {
            return nullptr;
        }
        auto m = *_attributes;
        auto i = m.find(key);
        if(i != m.end()) {
            String &v = i->second;
            return v.c_str();
        }
        return nullptr;
    }
    
    CString Element::get(ElementKey key) {
        Document * v = document();
        if(v == nullptr) {
            return nullptr;
        }
        return get(v->key(key));
    }
    
    void Element::set(CString key,CString value) {
        
        if(value == nullptr) {
            
            if(_attributes == nullptr) {
                return;
            }
            
            auto m = *_attributes;
            std::map<String,String>::iterator i = m.find(key);
            
            if(i != m.end()) {
                m.erase(i);
            }
            
        } else {
            if(_attributes == nullptr) {
                _attributes = new TObject<String, String>({{key,value}});
            } else {
                auto m = *_attributes;
                m[key] = value;
            }
            
        }
        
        {
            Document * v = document();
            
            if(v != nullptr) {
                
                DocumentObserver * observer = v->getObserver();
                
                if(observer) {
                    observer->set(v, this,v->elementKey(key),value);
                }
                
            }
            
        }
    }
    
    TObject<String, String> * Element::attributes() {
        return _attributes;
    }
    
    void Element::emit(CString name,Event * event) {
        
        ElementEvent * e = dynamic_cast<ElementEvent *>(event);
        
        EventEmitter::emit(name, event);
        
        if(e && !e->isCancelBubble()) {
            Element * p = parent();
            if(p) {
                p->emit(name, event);
            } else  {
                Document * doc = document();
                if(doc) {
                    doc->emit(name,event);
                }
            }
        }
        
    }
    
    kk::Boolean Element::hasBubble(CString name) {
        
        if(EventEmitter::has(name)) {
            return true;
        }
        
        Element * p = parent();
        
        if(p != nullptr) {
            return p->hasBubble(name);
        }
        
        Document * doc = document();
        
        if(doc != nullptr) {
            return doc->has(name);
        }
        
        return false;
    }

    kk::Object * Element::object(CString key) {
        auto i = _objects.find(key);
        if(i != _objects.end()) {
            return i->second;
        }
        return nullptr;
    }
    
    void Element::setObject(CString key,kk::Object * object) {
        if(object == nullptr) {
            auto i = _objects.find(key);
            if(i != _objects.end()) {
                _objects.erase(i);
            }
        } else {
            _objects[key] = object;
        }
    }
    
    String Element::toString() {
        String v;
        
        for(int i=0;i<_depth;i++) {
            v.append("\t");
        }
        
        v.append("<").append(_name);
        
        if(_attributes != nullptr) {
            auto m = * _attributes;
            std::map<String,String>::iterator i = m.begin();
            
            while(i != m.end()) {
                String key = i->first;
                if(!key.startsWith("#")) {
                    v.append(" ").append(i->first).append("=\"").append(i->second).append("\"");
                }
                
                i ++;
            }
        }
        
        v.append(">");
        
        Element * e = firstChild();
        
        if(e) {
            
            while(e) {
                
                v.append("\n");
                
                v.append(e->toString());
                
                e = e->nextSibling();
                
            }
            
            v.append("\n");
            
            for(int i=0;i<_depth;i++) {
                v.append("\t");
            }
            
        } else {
            CString vv = get("#text");
            if(vv) {
                v.append(vv);
            }
        }
        
        v.append("</").append(_name).append(">");
        
        return v;
    }
    
    
}

