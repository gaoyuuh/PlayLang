//
//  GReturnExpr.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GStatement.h"
@class GExpr;

NS_ASSUME_NONNULL_BEGIN

@interface GReturnStmt : GStatement

@property (nonatomic, strong) GExpr * expr;

@end

NS_ASSUME_NONNULL_END
