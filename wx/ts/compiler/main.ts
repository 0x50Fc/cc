
import * as ts from "typescript";
import { iOSCompiler } from './iOSCompiler';

function compile(): void {

    let program = ts.createProgram(['../location.ts'], {});

    let ios = new iOSCompiler();

    for (let file of program.getSourceFiles()) {

        if (file.isDeclarationFile) {
            continue;
        }

        ios.compile(file);
    }

    process.exit();
}

compile();
