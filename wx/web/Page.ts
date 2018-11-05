import { Data, DataFunction, Evaluate } from './Data';
import { Element, AttributeMap } from './Element';

export interface PageElement {
    element?:Element;
    name:string;
    attributes:AttributeMap;
    children:PageView;
    evaluate?:Evaluate;
    data:Data;
    elementData?:Data;
}

export class IfBlock {
    elements:PageElement[];
    func:DataFunction;
    constructor(element:PageElement,func:DataFunction) {
        this.elements = [element];
        this.func = func;
    }
}

export class PageViewScope {
    ifblock?:IfBlock
}

export class PageViewContext {
    private _scopes:PageViewScope[];
    constructor() {
        this._scopes = [new PageViewScope()];
    }
    begin():void {
        this._scopes.push(new PageViewScope());
    }
    end():void {
        this._scopes.pop();
    }
    scope():PageViewScope{
        return this._scopes[this._scopes.length -1];
    }
}

export type PageView = (element:Element,data:Data,context:PageViewContext)=>void;

export interface PageOptions {
    navigationBarBackgroundColor:string;
    navigationBarTextStyle:string;
    navigationBarTitleText:string;
    backgroundColor:string;
    backgroundTextStyle:string;
    enablePullDownRefresh:boolean;
    onReachBottomDistance:number;
    disableScroll:boolean;
}

export interface PageData {
    [key:string]:any
}

export class Page {

    private _element:Element;
    private _data:Data;

    constructor() {
        this._element = new Element();
        this._data = new Data();
    }

    public get element():Element {
        return this._element;
    }

    public get data():Data {
        return this._data;
    }
    
}