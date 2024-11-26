//
//  GAstVisitor.m
//  GLang
//
//  Created by gaoyu on 2024/11/8.
//

#import "GAstVisitor.h"

@implementation GAstVisitor

- (id)visit:(GNode *)node {
    return [node accept:self];
}

- (id)visitProg:(GProgram *)prog {
    return [self visitBlock:prog];
}

- (id)visitExprStmt:(GExprStatement *)exprStmt {
    return [self visit:exprStmt.expr];
}

- (id)visitVarDecl:(GVarDecl *)varDecl {
    return [self visit:varDecl.expr];
}

- (id)visitVarExpr:(GVarExpr *)varExpr {
    return nil;
}

- (id)visitFuncDecl:(GFuncDecl *)funcDecl {
    [self visit:funcDecl.signature];
    [self visitBlock:funcDecl.body];
    return nil;
}

- (id)visitFuncCall:(GFuncCallExpr *)funcCall {
    for (GExpr *expr in funcCall.arguments) {
        [self visit:expr];
    }
    return nil;
}

- (id)visitFuncParamList:(GFuncParamsList *)paramList {
    for (GVarDecl *varDecl in paramList.params) {
        [self visit:varDecl];
    }
    return nil;
}

- (id)visitFuncSignature:(GFuncSignature *)funcSignature {
    if (funcSignature.paramList) {
        [self visit:funcSignature.paramList];
    }
    return nil;
}

- (id)visitIfStmt:(GIfStatement *)ifStmt {
    return nil;
}

- (id)visitBlock:(GBlock *)block {
    id retValue = nil;
    for (GStatement *stmt in block.stmts) {
        retValue = [self visit:stmt];
    }
    return retValue;
}

- (id)visitBinaryExpr:(GBinaryExpr *)binaryExpr {
    [self visit:binaryExpr.exp1];
    [self visit:binaryExpr.exp2];
    return nil;
}

- (id)visitUnaryExpr:(GUnaryExpr *)unaryExpr {
    [self visit:unaryExpr.expr];
    return nil;
}

- (id)visitIntegerLiteral:(GIntegerLiteral *)integerLiteral {
    return integerLiteral.value;
}

- (id)visitDecimalLiteral:(GDecimalLiteral *)decimalLiteral {
    return decimalLiteral.value;
}

- (id)visitStringLiteral:(GStringLiteral *)stringLiteral {
    return stringLiteral.value;
}

- (id)visitBoolLiteral:(GBoolLiteral *)boolLiteral {
    return @(boolLiteral.value);
}

- (id)visitReturnStmt:(GReturnStmt *)returnStmt {
    if (returnStmt.expr) {
        return [self visit:returnStmt.expr];
    }
    return nil;
}

@end
