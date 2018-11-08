import { ViewElement  } from './ViewElement';
import { resolveURI } from './URI';

export class ImageElement extends ViewElement {

    public get imageView():Element {
        return this._view.firstElementChild!;
    }

    protected createView(): Element {
        var v = document.createElement("wx-" + this._name);
        var img = document.createElement("img");
        img.style.width = "100%";
        v.appendChild(img);
        v.style.overflow = 'hidden';
        return v;
    }

    public set(key: string, value: string | undefined) {
        super.set(key, value);

        if (key == 'src') {
            if(value === undefined) {
                this.imageView.removeAttribute("src");
            } else {
                this.imageView.setAttribute("src",resolveURI(value));
            }
        } 
    }

}
