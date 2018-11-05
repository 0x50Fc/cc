(function(){function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s}return e})()({1:[function(require,module,exports){
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class IObject {
    get(key) {
        return this[key];
    }
    set(key, value) {
        if (value === undefined) {
            delete this[key];
        }
        else {
            this[key] = value;
        }
    }
}
exports.IObject = IObject;
function get(object, keys, index = 0) {
    if (index < keys.length) {
        var key = keys[index];
        if (typeof object == 'object') {
            if (object instanceof IObject) {
                return get(object.get(key), keys, index + 1);
            }
            return get(object[key], keys, index + 1);
        }
    }
    else {
        return object;
    }
}
exports.get = get;
function set(object, keys, value, index = 0) {
    if (typeof object != 'object') {
        return;
    }
    if (index + 1 < keys.length) {
        var key = keys[index];
        var v;
        if (object instanceof IObject) {
            v = object.get(key);
        }
        else {
            v = object[key];
        }
        if (v === undefined) {
            v = {};
            if (object instanceof IObject) {
                object.set(key, v);
            }
            else {
                object[key] = v;
            }
        }
        set(v, keys, value, index + 1);
    }
    else if (index < keys.length) {
        var key = keys[index];
        if (object instanceof IObject) {
            object.set(key, value);
        }
        else {
            object[key] = value;
        }
    }
}
exports.set = set;
class Evaluate {
    constructor(keys, evaluateScript) {
        this.keys = keys;
        this.evaluateScript = evaluateScript;
    }
}
exports.Evaluate = Evaluate;
class KeyCallback {
    constructor(func) {
        this.hasChildren = false;
        this.priority = 0;
        this.func = func;
    }
    run(object, changedKeys) {
        var v;
        if (this.evaluateScript !== undefined) {
            v = this.evaluateScript(object);
        }
        else if (this.keys !== undefined) {
            v = get(object, this.keys);
        }
        this.func(v, changedKeys);
    }
}
class KeyObserver {
    constructor() {
        this.children = {};
        this.callbacks = [];
    }
    add(keys, callback, index) {
        if (index < keys.length) {
            let key = keys[index];
            var ch = this.children[key];
            if (ch === undefined) {
                ch = new KeyObserver();
                this.children[key] = ch;
            }
            ch.add(keys, callback, index + 1);
        }
        else {
            this.callbacks.push(callback);
        }
    }
    remove(keys, func, index) {
        if (func === undefined) {
            this.children = {};
            this.callbacks = [];
        }
        else if (index < keys.length) {
            let key = keys[index];
            let ch = this.children[key];
            if (ch !== undefined) {
                ch.remove(keys, func, index + 1);
            }
        }
        else {
            let cbs = [];
            for (let cb of this.callbacks) {
                if (cb.func != func) {
                    cbs.push(cb);
                }
            }
            this.callbacks = cbs;
            for (let key in this.children) {
                var ch = this.children[key];
                ch.remove(keys, func, index);
            }
        }
    }
    change(keys, callbacks, index) {
        if (index < keys.length) {
            let key = keys[index];
            let ch = this.children[key];
            if (ch !== undefined) {
                ch.change(keys, callbacks, index + 1);
            }
            for (let cb of this.callbacks) {
                if (cb.hasChildren) {
                    callbacks.push(cb);
                }
            }
        }
        else {
            for (let cb of this.callbacks) {
                callbacks.push(cb);
            }
            for (let key in this.children) {
                var ch = this.children[key];
                ch.change(keys, callbacks, index);
            }
        }
    }
    changedKeys(object, keys) {
        let callbacks = [];
        this.change(keys, callbacks, 0);
        callbacks.sort((a, b) => {
            return a.priority - b.priority;
        });
        for (let cb of callbacks) {
            cb.run(object, keys);
        }
    }
    on(object, keys, func, hasChildren = false, priority = 0) {
        let onKeys = [];
        let cb = new KeyCallback(func);
        cb.hasChildren = hasChildren;
        cb.priority = priority;
        if (keys instanceof Evaluate) {
            onKeys = keys.keys;
            cb.evaluateScript = keys.evaluateScript;
        }
        else {
            cb.keys = keys;
            onKeys.push(keys);
        }
        if (onKeys.length == 0) {
            var vv;
            if (cb.evaluateScript !== undefined) {
                try {
                    vv = cb.evaluateScript(object);
                }
                catch (e) {
                    console.info("[ERROR] " + e);
                }
            }
            if (vv !== undefined) {
                func(vv, []);
            }
        }
        else {
            for (let ks of onKeys) {
                this.add(ks, cb, 0);
            }
        }
    }
    off(keys, func) {
        this.remove(keys, func, 0);
    }
}
class Data {
    constructor() {
        this._keyObserver = new KeyObserver();
        this.object = {};
    }
    get(keys) {
        return get(this.object, keys);
    }
    set(keys, value, changed = false) {
        set(this.object, keys, value);
        if (changed === true) {
            this.changedKeys(keys);
        }
    }
    changedKeys(keys) {
        this._keyObserver.changedKeys(this.object, keys);
    }
    on(keys, func, hasChildren = false, priority = 0) {
        this._keyObserver.on(this.object, keys, func, hasChildren, priority);
    }
    off(keys, func) {
        this._keyObserver.off(keys, func);
    }
    setParent(parent) {
        this.recycle();
        if (parent !== undefined) {
            this._parent = parent;
            let data = this;
            this._parentFunc = function (value, keys) {
                if (value !== undefined) {
                    data.set(keys, get(value, keys));
                }
            };
            parent.on([], this._parentFunc, true);
            for (var key in parent.object) {
                this.object[key] = parent.object[key];
            }
            this.changedKeys([]);
        }
    }
    recycle() {
        if (this._parent !== undefined) {
            this._parent.off([], this._parentFunc);
            this._parent = undefined;
            this._parentFunc = undefined;
        }
    }
    static evaluateKeys(evaluate, keys) {
        var v = evaluate.replace(/(\\\')|(\\\")/g, '');
        v = v.replace(/(\'.*?\')|(\".*?\")/g, '');
        v = v.replace(/\".*?\"/g, '');
        v.replace(/[a-zA-Z_][0-9a-zA-Z\\._]*/g, (name) => {
            if (name && !name.startsWith("_")) {
                keys.push(name.split("."));
            }
            return '';
        });
    }
    static evaluateScript(evaluateScript) {
        let keys = [];
        let code = ['(function(object){ var _G = {}; try { with(object) { _G.ret = '];
        var idx = 0;
        var count = 0;
        evaluateScript.replace(/\{\{(.*?)\}\}/g, (text, exaluate, index) => {
            if (index > idx) {
                if (count != 0) {
                    code.push("+");
                }
                code.push(JSON.stringify(evaluateScript.substr(idx, index - idx)));
                count++;
            }
            Data.evaluateKeys(exaluate, keys);
            if (count != 0) {
                code.push("+");
            }
            code.push("(");
            code.push(exaluate);
            code.push(")");
            count++;
            idx = index;
            return '';
        });
        if (evaluateScript.length > idx && count != 0) {
            code.push("+");
            code.push(JSON.stringify(evaluateScript.substr(idx)));
        }
        code.push('; } } catch(e) {  } return _G.ret; } )');
        if (count == 0) {
            return undefined;
        }
        return new Evaluate(keys, eval(code.join('')));
    }
}
exports.Data = Data;

},{}],2:[function(require,module,exports){
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Event_1 = require("./Event");
const EventEmitter_1 = require("./EventEmitter");
class ElementEvent extends Event_1.Event {
    constructor(element) {
        super();
        this.cancelBubble = false;
        this.element = element;
    }
}
exports.ElementEvent = ElementEvent;
class Element extends EventEmitter_1.EventEmitter {
    constructor() {
        super(...arguments);
        this._attributes = {};
        this._levelId = 0;
        this._depth = 0;
        this._autoLevelId = 0;
    }
    get levelId() {
        return this._levelId;
    }
    get depth() {
        return this._depth;
    }
    get firstChild() {
        return this._firstChild;
    }
    get lastChild() {
        return this._lastChild;
    }
    get nextSibling() {
        return this._nextSibling;
    }
    get prevSibling() {
        return this._prevSibling;
    }
    get parent() {
        return this._parent;
    }
    onDidAddToParent(element) {
    }
    onDidAddChildren(element) {
        let e = element;
        e._depth = this._depth + 1;
        e._levelId = this._autoLevelId + 1;
        this._autoLevelId = e._levelId;
        e.onDidAddToParent(this);
    }
    append(element) {
        var e = element;
        e.remove();
        if (this._lastChild !== undefined) {
            this._lastChild._nextSibling = e;
            e._prevSibling = this._lastChild;
            this._lastChild = e;
            e._parent = this;
        }
        else {
            this._firstChild = e;
            this._lastChild = e;
            e._parent = this;
        }
        this.onDidAddChildren(element);
    }
    before(element) {
        var e = element;
        e.remove();
        if (this._prevSibling !== undefined) {
            this._prevSibling._nextSibling = e;
            e._prevSibling = this._prevSibling;
            e._nextSibling = this;
            e._parent = this._parent;
            this._prevSibling = e;
        }
        else if (this._parent) {
            e._nextSibling = this;
            e._parent = this._parent;
            this._prevSibling = e;
            this._parent._firstChild = e;
        }
        if (this._parent !== undefined) {
            this._parent.onDidAddChildren(element);
        }
    }
    after(element) {
        var e = element;
        e.remove();
        if (this._nextSibling !== undefined) {
            this._nextSibling._prevSibling = e;
            e._nextSibling = this._nextSibling;
            e._prevSibling = this;
            e._parent = this._parent;
            this._nextSibling = e;
        }
        else if (this._parent) {
            e._prevSibling = this;
            e._parent = this._parent;
            this._nextSibling = e;
            this._parent._lastChild = e;
        }
        if (this._parent !== undefined) {
            this._parent.onDidAddChildren(element);
        }
    }
    onWillRemoveFromParent(element) {
    }
    onWillRemoveChildren(element) {
        let e = element;
        e._depth = 0;
        e._levelId = 0;
        e.onWillRemoveFromParent(this);
    }
    remove() {
        if (this._prevSibling !== undefined && this._parent !== undefined) {
            this._parent.onWillRemoveChildren(this);
            this._prevSibling._nextSibling = this._nextSibling;
            if (this._nextSibling !== undefined) {
                this._nextSibling._prevSibling = this._prevSibling;
            }
            else {
                this._parent._lastChild = this._prevSibling;
            }
        }
        else if (this._parent !== undefined) {
            this._parent.onWillRemoveChildren(this);
            this._parent._firstChild = this._nextSibling;
            if (this._nextSibling) {
                this._nextSibling._prevSibling = undefined;
            }
            else {
                this._parent._lastChild = undefined;
            }
        }
        if (this._parent) {
            this._parent = undefined;
            this._prevSibling = undefined;
            this._nextSibling = undefined;
        }
    }
    appendTo(element) {
        element.append(this);
    }
    beforeTo(element) {
        element.before(this);
    }
    afterTo(element) {
        element.after(this);
    }
    get(key) {
        return this._attributes[key];
    }
    set(key, value) {
        if (value === undefined) {
            delete this._attributes[key];
        }
        else {
            this._attributes[key] = value;
        }
    }
    get attributes() {
        return this._attributes;
    }
    emit(name, event) {
        if (event instanceof ElementEvent) {
            var e = event;
            if (e.element === undefined) {
                e.element = this;
            }
        }
        super.emit(name, event);
        if (event instanceof ElementEvent) {
            var e = event;
            if (!e.cancelBubble) {
                if (this._parent !== undefined) {
                    this._parent.emit(name, event);
                }
            }
        }
    }
    hasBubble(name) {
        if (super.has(name)) {
            return true;
        }
        if (this._parent !== undefined) {
            return this._parent.hasBubble(name);
        }
        return false;
    }
    recycle() {
        var p = this._firstChild;
        while (p !== undefined) {
            let n = p._nextSibling;
            p.recycle();
            p = n;
        }
        this._parent = undefined;
        this._firstChild = undefined;
        this._lastChild = undefined;
        this._prevSibling = undefined;
        this._nextSibling = undefined;
        this._parent = undefined;
    }
}
exports.Element = Element;

},{"./Event":3,"./EventEmitter":4}],3:[function(require,module,exports){
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class Event {
}
exports.Event = Event;

},{}],4:[function(require,module,exports){
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class EventEmitter {
    constructor() {
        this._events = {};
    }
    on(name, func) {
        var v = this._events[name];
        if (v === undefined) {
            v = [];
            this._events[name] = v;
        }
        v.push(func);
    }
    off(name, func) {
        if (name === undefined && func === undefined) {
            this._events = {};
        }
        else if (func === undefined && name !== undefined) {
            delete this._events[name];
        }
        else if (name !== undefined) {
            var v = this._events[name];
            if (v !== undefined) {
                var vs = [];
                for (let fn of v) {
                    if (fn != func) {
                        vs.push(fn);
                    }
                }
                this._events[name] = vs;
            }
        }
    }
    emit(name, event) {
        var v = this._events[name];
        if (v !== undefined) {
            var vs = v.slice();
            for (let fn of vs) {
                fn(event);
            }
        }
    }
    has(name) {
        return this._events[name] !== undefined;
    }
}
exports.EventEmitter = EventEmitter;

},{}],5:[function(require,module,exports){
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Data_1 = require("./Data");
const Element_1 = require("./Element");
const Page_1 = require("./Page");
const ViewElement_1 = require("./ViewElement");
let elementClass = {
    "view": ViewElement_1.ViewElement
};
function CreateElementWithName(name) {
    let fn = elementClass[name];
    if (fn === undefined) {
        return new Element_1.Element();
    }
    return new fn();
}
function ElementSetAttributes(element, data, attributes) {
    for (let key in attributes) {
        if (key.startsWith("wx:")) {
        }
        else {
            let v = attributes[key];
            let evaluate = Data_1.Data.evaluateScript(v);
            if (evaluate === undefined) {
                element.set(key, v);
            }
            else {
                let fn = (key, element, evaluate) => {
                    data.on(evaluate, (value, changdKeys) => {
                        element.set(key, value + '');
                    });
                };
                fn(key, element, evaluate);
            }
        }
    }
}
function CreateForElement(element, data, name, attributes, context, children) {
    let evaluate = Data_1.Data.evaluateScript(attributes["wx:for"]);
    if (evaluate === undefined) {
        return;
    }
    delete attributes["wx:for"];
    let before = new Element_1.Element();
    before.appendTo(element);
    let index = attributes["wx:for-index"] || "index";
    let item = attributes["wx:for-item"] || "item";
    let items = [];
    data.on(evaluate, (object, changedKeys) => {
        var i = 0;
        context.begin();
        if (object instanceof Array) {
            for (let d of object) {
                let v;
                if (i < items.length) {
                    v = items[i];
                }
                else {
                    v = {
                        data: new Data_1.Data(),
                        element: CreateElementWithName(name)
                    };
                    v.data.setParent(data);
                    ElementSetAttributes(element, v.data, attributes);
                    before.before(v.element);
                }
                v.data.set([index], i);
                v.data.set([item], d);
                i++;
            }
        }
        while (i < items.length) {
            let v = items.pop();
            v.element.remove();
            v.element.recycle();
            v.data.recycle();
        }
        context.end();
    });
}
function CreateIfElement(element, data, name, attributes, context, children) {
    let evaluate = Data_1.Data.evaluateScript(attributes["wx:if"]);
    if (evaluate === undefined) {
        return;
    }
    let before = new Element_1.Element();
    before.appendTo(element);
    let scope = context.scope();
    let block;
    block = new Page_1.IfBlock({
        element: undefined,
        name: name,
        attributes: attributes,
        children: children,
        evaluate: evaluate,
        data: data,
        elementData: undefined
    }, (value, changedKeys) => {
        let e;
        for (let item of block.elements) {
            if (e === undefined) {
                if (item.evaluate !== undefined) {
                    let v = item.evaluate.evaluateScript(item.data.object);
                    if (v) {
                        e = item;
                    }
                }
                else {
                    e = item;
                }
            }
            if (e == item) {
                if (item.element === undefined) {
                    item.element = CreateElementWithName(item.name);
                    item.elementData = new Data_1.Data();
                    ElementSetAttributes(item.element, item.data, item.attributes);
                    context.begin();
                    item.children(item.element, item.elementData, context);
                    context.end();
                    item.elementData.setParent(item.data);
                }
                else {
                    before.before(item.element);
                    item.elementData.changedKeys([]);
                }
            }
            else if (item.element !== undefined) {
                item.element.remove();
                item.element.recycle();
                item.elementData.recycle();
                item.element = undefined;
                item.elementData = undefined;
            }
        }
    });
    scope.ifblock = block;
    data.on(evaluate, block.func);
}
function CreateElifElement(element, data, name, attributes, context, children) {
    let scope = context.scope();
    if (scope.ifblock !== undefined) {
        let evaluate = Data_1.Data.evaluateScript(attributes["wx:elif"]);
        if (evaluate === undefined) {
            return;
        }
        scope.ifblock.elements.push({
            element: undefined,
            name: name,
            attributes: attributes,
            children: children,
            evaluate: evaluate,
            data: data,
            elementData: undefined
        });
        data.on(evaluate, scope.ifblock.func);
    }
}
function CreateElseElement(element, data, name, attributes, context, children) {
    let scope = context.scope();
    if (scope.ifblock !== undefined) {
        scope.ifblock.elements.push({
            element: undefined,
            name: name,
            attributes: attributes,
            children: children,
            evaluate: undefined,
            data: data,
            elementData: undefined
        });
        scope.ifblock = undefined;
    }
}
function CreateElement(element, data, name, attributes, context, children) {
    if (attributes["wx:for"] !== undefined) {
        CreateForElement(element, data, name, attributes, context, children);
    }
    else if (attributes["wx:if"] !== undefined) {
        CreateIfElement(element, data, name, attributes, context, children);
    }
    else if (attributes["wx:elif"] !== undefined) {
        CreateElifElement(element, data, name, attributes, context, children);
    }
    else if (attributes["wx:else"] !== undefined) {
        CreateElseElement(element, data, name, attributes, context, children);
    }
    else {
        let e = CreateElementWithName(name);
        ElementSetAttributes(e, data, attributes);
        element.append(e);
        context.begin();
        children(e, data, context);
        context.end();
    }
}
exports.CreateElement = CreateElement;
var page = new Page_1.Page();
function Page(view, styleSheet, options) {
    view(page.element, page.data, new Page_1.PageViewContext());
}
exports.Page = Page;
function setData(data) {
    for (var key in data) {
        page.data.set([key], data[key]);
    }
}
exports.setData = setData;
function setContentOffset(x, y) {
}
exports.setContentOffset = setContentOffset;

},{"./Data":1,"./Element":2,"./Page":6,"./ViewElement":8}],6:[function(require,module,exports){
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Data_1 = require("./Data");
const Element_1 = require("./Element");
class IfBlock {
    constructor(element, func) {
        this.elements = [element];
        this.func = func;
    }
}
exports.IfBlock = IfBlock;
class PageViewScope {
}
exports.PageViewScope = PageViewScope;
class PageViewContext {
    constructor() {
        this._scopes = [new PageViewScope()];
    }
    begin() {
        this._scopes.push(new PageViewScope());
    }
    end() {
        this._scopes.pop();
    }
    scope() {
        return this._scopes[this._scopes.length - 1];
    }
}
exports.PageViewContext = PageViewContext;
class Page {
    constructor() {
        this._element = new Element_1.Element();
        this._data = new Data_1.Data();
    }
    get element() {
        return this._element;
    }
    get data() {
        return this._data;
    }
}
exports.Page = Page;

},{"./Data":1,"./Element":2}],7:[function(require,module,exports){
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });

},{}],8:[function(require,module,exports){
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Element_1 = require("./Element");
class ViewElement extends Element_1.Element {
    get view() {
        return this._view;
    }
    createView() {
        return document.createElement("div");
    }
    constructor() {
        super();
        this._view = this.createView();
    }
    set(key, value) {
        super.set(key, value);
        if (key == 'class') {
            this._view.className = value === undefined ? '' : value;
        }
        else if (key == 'style') {
            if (value === undefined) {
                this._view.removeAttribute(key);
            }
            else {
                this._view.setAttribute('style', value);
            }
        }
        else if (key == '#text') {
            this._view.textContent = value === undefined ? '' : value;
        }
    }
    onDidAddToParent(element) {
        super.onDidAddToParent(element);
        if (element instanceof ViewElement) {
            element.view.appendChild(this._view);
        }
        else {
            document.body.appendChild(this._view);
        }
    }
    onWillRemoveFromParent(element) {
        super.onWillRemoveFromParent(element);
        let p = this._view.parentElement;
        if (p) {
            p.removeChild(this._view);
        }
    }
}
exports.ViewElement = ViewElement;

},{"./Element":2}],9:[function(require,module,exports){

require('./bin/Data.js');
require('./bin/Event.js');
require('./bin/EventEmitter.js');
require('./bin/Style.js');
require('./bin/Element.js');
require('./bin/ViewElement.js');
require('./bin/Page.js');

kk = require('./bin/Main.js');


},{"./bin/Data.js":1,"./bin/Element.js":2,"./bin/Event.js":3,"./bin/EventEmitter.js":4,"./bin/Main.js":5,"./bin/Page.js":6,"./bin/Style.js":7,"./bin/ViewElement.js":8}]},{},[9]);
