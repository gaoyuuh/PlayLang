//
//  GAstDumpVisitor.m
//  GLang
//
//  Created by gaoyu on 2024/11/21.
//

#import "GAstDumpVisitor.h"

@implementation GAstDumpVisitor

- (id)visitProg:(GProgram *)prog {
    NSLog(@"GProgram");
    for (GStatement *stmt in prog.stmts) {
        [self visit:stmt];
    }
    return nil;
}

- (id)visitFuncDecl:(GFuncDecl *)funcDecl {
    NSLog(@"GFuncDecl - %@", funcDecl.declName);
    [self visit:funcDecl.signature];
    [self visit:funcDecl.body];
    return nil;
}

- (id)visitFuncSignature:(GFuncSignature *)funcSignature {
    NSLog(@"    Return Type: %@", funcSignature.returnType.name);
    [self visit:funcSignature.paramList];
    return nil;
}

- (id)visitFuncParamList:(GFuncParamsList *)paramList {
    NSLog(@"    ParamList: %d", (int)paramList.params.count);
    for (GVarDecl *decl in paramList.params) {
        [self visit:decl];
    }
    return nil;
}

- (id)visitVarDecl:(GVarDecl *)varDecl {
    NSLog(@"    GVarDecl");
    NSLog(@"        name: %@", varDecl.declName);
    NSLog(@"        type: %@", varDecl.declType.name);
    if (varDecl.expr) {
        [self visit:varDecl.expr];
    } else {
        NSLog(@"no initialization.");
    }
    return nil;
}

- (id)visitBlock:(GBlock *)block {
    for (GStatement *stmt in block.stmts) {
        [self visit:stmt];
    }
    return nil;
}

- (id)visitIntegerLiteral:(GIntegerLiteral *)integerLiteral {
    return integerLiteral.value;
}

- (id)visitDecimalLiteral:(GDecimalLiteral *)decimalLiteral {
    return decimalLiteral.value;
}

@end
