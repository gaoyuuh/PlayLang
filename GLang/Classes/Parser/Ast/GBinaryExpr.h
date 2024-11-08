//
//  GBinaryExpr.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GExpr.h"
#import "GToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface GBinaryExpr : GExpr

/// 运算符
@property (nonatomic, assign) GTokenKind op;
/// 左边表达式
@property (nonatomic, strong) GExpr * exp1;
/// 右边表达式
@property (nonatomic, strong) GExpr * exp2;

@end

NS_ASSUME_NONNULL_END
