"use strict";
exports.__esModule = true;
var ts = require("typescript");
var iOSCompiler_1 = require("./iOSCompiler");
function compile() {
    var program = ts.createProgram(['../location.ts'], {});
    var ios = new iOSCompiler_1.iOSCompiler();
    for (var _i = 0, _a = program.getSourceFiles(); _i < _a.length; _i++) {
        var file = _a[_i];
        if (file.isDeclarationFile) {
            continue;
        }
        console.info(file.fileName);
    }
    process.exit();
}
compile();
