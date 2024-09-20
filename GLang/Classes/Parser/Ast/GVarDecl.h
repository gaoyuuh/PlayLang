//
//  GVarDecl.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GDecl.h"
#import "GTypeNode.h"
#import "GExpr.h"
#import "GVarSymbol.h"

@interface GVarDecl : GDecl

/// 变量类型
@property (nonatomic, strong) GTypeNode * declType;
/// 推测类型
@property (nonatomic, strong) GTypeNode * inferredType;
/// 变量初始化的表达式
@property (nonatomic, strong) GExpr * expr;
/// 符号表
@property (nonatomic, strong) GVarSymbol * symbol;

@end
