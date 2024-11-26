//
//  GAstVisitor.h
//  GLang
//
//  Created by gaoyu on 2024/11/8.
//

#import <Foundation/Foundation.h>
#import "GAstHeader.h"

@interface GAstVisitor : NSObject

- (id)visit:(GNode *)node;

- (id)visitProg:(GProgram *)prog;

- (id)visitExprStmt:(GExprStatement *)exprStmt;

- (id)visitVarDecl:(GVarDecl *)varDecl;

- (id)visitVarExpr:(GVarExpr *)varExpr;

- (id)visitFuncDecl:(GFuncDecl *)funcDecl;

- (id)visitFuncCall:(GFuncCallExpr *)funcCall;

- (id)visitFuncSignature:(GFuncSignature *)funcSignature;

- (id)visitFuncParamList:(GFuncParamsList *)paramList;

- (id)visitIfStmt:(GIfStatement *)ifStmt;

- (id)visitBlock:(GBlock *)block;

- (id)visitBinaryExpr:(GBinaryExpr *)binaryExpr;

- (id)visitUnaryExpr:(GUnaryExpr *)unaryExpr;

- (id)visitIntegerLiteral:(GIntegerLiteral *)integerLiteral;

- (id)visitDecimalLiteral:(GDecimalLiteral *)decimalLiteral;

- (id)visitStringLiteral:(GStringLiteral *)stringLiteral;

- (id)visitBoolLiteral:(GBoolLiteral *)boolLiteral;

- (id)visitReturnStmt:(GReturnStmt *)returnStmt;

@end
