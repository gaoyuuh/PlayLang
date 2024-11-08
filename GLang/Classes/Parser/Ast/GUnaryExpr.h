//
//  GUnaryExpr.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GExpr.h"
#import "GToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface GUnaryExpr : GExpr

/// 运算符
@property (nonatomic, assign) GTokenKind op;
/// 表达式
@property (nonatomic, strong) GExpr * expr;
/// 前缀还是后缀
@property (nonatomic, assign) BOOL isPrefix;

@end

NS_ASSUME_NONNULL_END
