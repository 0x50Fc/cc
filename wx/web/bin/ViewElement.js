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
//# sourceMappingURL=ViewElement.js.map