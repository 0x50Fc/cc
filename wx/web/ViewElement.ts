import { Element as KKElement } from './Element';

export class ViewElement extends KKElement {

    protected _view: Element;

    public get view(): Element {
        return this._view;
    }

    protected createView(): Element {
        return document.createElement("div");
    }

    constructor() {
        super();
        this._view = this.createView();
    }

    public set(key: string, value: string | undefined) {
        super.set(key, value);

        if(key == 'class'){ 
            this._view.className = value === undefined ? ''  : value as string;
        } else if(key == 'style') {
            if(value === undefined) {
                this._view.removeAttribute(key);
            } else {
                this._view.setAttribute('style',value as string);
            }
        } else if(key == '#text') {
            this._view.textContent = value === undefined ? ''  : value as string;
        }
    }

    protected onDidAddToParent(element: KKElement): void {
        super.onDidAddToParent(element);
        if(element instanceof ViewElement) {
            element.view.appendChild(this._view);
        } else {
            document.body.appendChild(this._view);
        }
    }

    protected onWillRemoveFromParent(element: KKElement): void {
        super.onWillRemoveFromParent(element);
        let p = this._view.parentElement;
        if(p) {
            p.removeChild(this._view);
        }
    }

}
