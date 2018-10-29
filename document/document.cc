//
//  document.cc
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <document/document.h>
#include <typeinfo>

namespace kk {
 
    Library::Library() {
        
    }
    
    void Library::add(CString name,TFunction<Element *, Document *,CString,ElementKey>  * func) {
        _funcs[name] = func;
    }
    
    void Library::def(TFunction<Element *, Document *,CString,ElementKey>  * func) {
        add("", func);
    }
    
    Strong<Element> Library::createElement(Document * document,CString name,ElementKey elementId) {
        auto i = _funcs.find(name);
        if(i == _funcs.end()) {
            i = _funcs.find("");
        }
        if(i != _funcs.end()) {
            TFunction<Element *, Document *,CString,ElementKey> * func = i->second;
            return (*func)(document,name,elementId);
        }
        return nullptr;
    }
    
    Library * Library::defaultLibrary() {
        static Library * v = nullptr;
        if(v != nullptr) {
            v = new Library();
            v->retain();
        }
        return v;
    }
    
    Document::Document(Library * library):_library(library),_autoKey(0) {
        
    }
    
    Document::Document():Document(Library::defaultLibrary()) {
        
    }
    
    Document::~Document() {
        
    }
    
    Element * Document::rootElement() {
        return (Element *) _rootElement.get();
    }
    
    void Document::setRootElement(Element * element) {
        
        _rootElement = element;
        
        {
            DocumentObserver * observer = getObserver();
            
            if(observer) {
                observer->root(this, element);
            }
        }
        
    }
    
    Strong<Element> Document::element(ElementKey elementId) {
        Strong<Element> v;
        std::map<ElementKey,Weak<Element>>::iterator i = _elements.find(elementId);
        if(i != _elements.end()) {
            Weak<Element> & vv = i->second;
            Element * e = (Element *) vv.get();
            if(e == nullptr) {
                _elements.erase(i);
            } else {
                v = e;
            }
        }
        return v;
    }
    
    Strong<Element> Document::createElement(CString name,ElementKey elementId) {
        
        if(elementId == 0) {
            elementId = ++ _autoKey;
        } else if(elementId > _autoKey) {
            _autoKey = elementId;
        }
        
        Strong<Element> v = _library->createElement(this, name, elementId);
        
        if(v == nullptr) {
            v = new Element(this,name,elementId);
        }
        
        _elements[elementId] = v;
        
        {
            std::map<String,std::list<Weak<Element>>>::iterator i = _elementsByName.find(name);
            if(i == _elementsByName.end()) {
                _elementsByName[name] = std::list<Weak<Element>>();
                i = _elementsByName.find(name);
            }
            std::list<Weak<Element>> & vs = i->second;
            vs.push_back( (Element *) v);
        }
        
        {
            DocumentObserver * observer = getObserver();
            
            if(observer) {
                observer->alloc(this, (Element *) v.get());
            }
        }
        
        return v;
        
    }
    
    Strong<Element> Document::createElement(CString name) {
        return createElement(name, 0);
    }
    
    
    kk::CString Document::key(ElementKey key) {
        std::map<ElementKey,String>::iterator i = _elementKeys.find(key);
        if(i != _elementKeys.end()) {
            return i->second.c_str();
        }
        return nullptr;
    }
    
    ElementKey Document::elementKey(CString name) {
        
        std::map<String,ElementKey>::iterator i = _keys.find(name);
        
        if(i == _keys.end()) {
            
            ElementKey key = ++ _autoKey;
            
            _keys[name] = key;
            _elementKeys[key] = name;
            
            {
                DocumentObserver * observer = getObserver();
                
                if(observer) {
                    observer->key(this, key,name);
                }
            }
            
            return key;
        }
        
        return i->second;
    }
    
    void Document::beginObserver(DocumentObserver * observer) {
        _observers.push_back(observer);
    }
    
    DocumentObserver * Document::getObserver() {
        if(_observers.empty()) {
            return nullptr;
        }
        return _observers.back();
    }
    
    void Document::endObserver() {
        _observers.pop_back();
    }
    
    
    void Document::set(CString name,ElementKey key) {
        if(key > _autoKey) {
            _autoKey = key;
        }
        _keys[name] = key;
        _elementKeys[key] = name;
    }
    
    std::map<ElementKey,String> & Document::elementKeys() {
        return _elementKeys;
    }
    
    void Document::elementsByName(CString name,std::list<Strong<Element>> & elements) {
        std::map<String,std::list<Weak<Element>>>::iterator i = _elementsByName.find(name);
        if(i != _elementsByName.end()) {
            std::list<Weak<Element>> & vs = i->second;
            std::list<Weak<Element>>::iterator n = vs.begin();
            while(n != vs.end()) {
                Weak<Element> & v = *n;
                Element * e = (Element *) v.get();
                if(e == nullptr) {
                    n = vs.erase(n);
                } else {
                    elements.push_back(e);
                    n ++;
                }
            }
        }
    }
    
    String Document::toString() {
        String v;
        
        Element * e = rootElement();
        
        if(e) {
            return e->toString();
        }
        
        return v;
    }
    
    
}

