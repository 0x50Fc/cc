import { Data, Evaluate } from './Data';
import { Element, AttributeMap } from './Element';
import { StyleSheet } from "./Style";
import { PageOptions, PageData, PageView, PageViewContext, IfBlock, PageElement, Page as PageObject } from "./Page";
import { ViewElement } from './ViewElement';

interface ElemnetClassMap {
    [keys: string]: any
}

let elementClass: ElemnetClassMap = {
    "view":ViewElement
};

function CreateElementWithName(name: string): Element {
    let fn = elementClass[name];
    if (fn === undefined) {
        return new Element();
    }
    return new fn();
}

function ElementSetAttributes(element: Element, data: Data, attributes: AttributeMap): void {

    for (let key in attributes) {
        if (key.startsWith("wx:")) {

        } else {
            let v = attributes[key];
            let evaluate = Data.evaluateScript(v);
            if (evaluate === undefined) {
                element.set(key, v);
            } else {
                let fn = (key: string, element: Element, evaluate: Evaluate): void => {
                    data.on(evaluate, (value: any, changdKeys: string[]): void => {
                        element.set(key, value + '');
                    });
                };
                fn(key, element, evaluate);
            }
        }
    }
}

interface ForItem {
    element: Element
    data: Data
}

function CreateForElement(element: Element, data: Data, name: string, attributes: AttributeMap, context: PageViewContext, children: PageView): void {

    let evaluate = Data.evaluateScript(attributes["wx:for"]);

    if (evaluate === undefined) {
        return;
    }

    delete attributes["wx:for"];

    let before = new Element();
    before.appendTo(element);

    let index = attributes["wx:for-index"] || "index";
    let item = attributes["wx:for-item"] || "item";
    let items: ForItem[] = [];

    data.on(evaluate, (object: any, changedKeys: string[]): void => {

        var i = 0;

        context.begin();

        if (object instanceof Array) {
            for (let d of object) {
                let v: ForItem;
                if (i < items.length) {
                    v = items[i];
                } else {
                    v = {
                        data: new Data(),
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
            let v = items.pop()!;
            v.element.remove();
            v.element.recycle();
            v.data.recycle();
        }

        context.end();

    });

}

function CreateIfElement(element: Element, data: Data, name: string, attributes: AttributeMap, context: PageViewContext, children: PageView): void {

    let evaluate = Data.evaluateScript(attributes["wx:if"]);

    if (evaluate === undefined) {
        return;
    }

    let before = new Element();
    before.appendTo(element);

    let scope = context.scope();

    let block: IfBlock;

    block = new IfBlock({
        element: undefined,
        name: name,
        attributes: attributes,
        children: children,
        evaluate: evaluate,
        data: data,
        elementData: undefined
    }, (value: any, changedKeys: string[]): void => {

        let e: PageElement | undefined;

        for (let item of block.elements) {

            if (e === undefined) {
                if (item.evaluate !== undefined) {
                    let v = item.evaluate.evaluateScript(item.data.object);
                    if (v) {
                        e = item;
                    }
                } else {
                    e = item;
                }
            }

            if (e == item) {

                if (item.element === undefined) {
                    item.element = CreateElementWithName(item.name);
                    item.elementData = new Data();
                    ElementSetAttributes(item.element, item.data, item.attributes);
                    context.begin();
                    item.children(item.element, item.elementData, context);
                    context.end();
                    item.elementData.setParent(item.data);
                } else {
                    before.before(item.element);
                    item.elementData!.changedKeys([]);
                }

            } else if (item.element !== undefined) {
                item.element.remove();
                item.element.recycle();
                item.elementData!.recycle();
                item.element = undefined;
                item.elementData = undefined;
            }

        }

    });

    scope.ifblock = block;

    data.on(evaluate, block.func);

}

function CreateElifElement(element: Element, data: Data, name: string, attributes: AttributeMap, context: PageViewContext, children: PageView): void {

    let scope = context.scope();

    if (scope.ifblock !== undefined) {

        let evaluate = Data.evaluateScript(attributes["wx:elif"]);

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

function CreateElseElement(element: Element, data: Data, name: string, attributes: AttributeMap, context: PageViewContext, children: PageView): void {

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

export function CreateElement(element: Element, data: Data, name: string, attributes: AttributeMap, context: PageViewContext, children: PageView): void {

    if (attributes["wx:for"] !== undefined) {
        CreateForElement(element, data, name, attributes, context, children);
    } else if (attributes["wx:if"] !== undefined) {
        CreateIfElement(element, data, name, attributes, context, children);
    } else if (attributes["wx:elif"] !== undefined) {
        CreateElifElement(element, data, name, attributes, context, children);
    } else if (attributes["wx:else"] !== undefined) {
        CreateElseElement(element, data, name, attributes, context, children);
    } else {
        let e = CreateElementWithName(name);
        ElementSetAttributes(e, data, attributes);
        element.append(e);
        context.begin();
        children(e, data, context);
        context.end();
    }

}

var page = new PageObject();

export function Page(view: PageView, styleSheet: StyleSheet, options: PageOptions): void {
    view(page.element,page.data,new PageViewContext());
}

export function setData(data: PageData): void {

    for(var key in data) {
        page.data.set([key],data[key]);
    }

}

export function setContentOffset(x: number, y: number): void {

}

