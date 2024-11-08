//
//  GVarDecl.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GDecl.h"
#import "GType.h"
#import "GExpr.h"
#import "GVarSymbol.h"

@interface GVarDecl : GDecl

/// 变量类型
@property (nonatomic, strong) GType * declType;
/// 推测类型
@property (nonatomic, strong) GType * inferredType;
/// 变量初始化的表达式
@property (nonatomic, strong) GExpr * expr;
/// 符号表
@property (nonatomic, strong) GVarSymbol * symbol;

@end
