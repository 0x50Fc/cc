
import * as ts from "typescript";

export class iOSCompiler {

    private _dir:string;
    private _prefix:string;

    constructor(dir:string,prefix:string="WX"){
        this._dir = dir;
        this._prefix = prefix;
    }

    compile(file:ts.SourceFile):void {

    }
}