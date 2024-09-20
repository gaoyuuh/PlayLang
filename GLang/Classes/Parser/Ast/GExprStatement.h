//
//  GExprStatement.h
//  Pods
//
//  Created by gaoyu on 2024/9/9.
//

#import "GStatement.h"
#import "GExpr.h"

NS_ASSUME_NONNULL_BEGIN

@interface GExprStatement : GStatement

@property (nonatomic, strong) GExpr * expr;

@end

NS_ASSUME_NONNULL_END
