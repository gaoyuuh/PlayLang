//
//  GCallExpr.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GExpr.h"

NS_ASSUME_NONNULL_BEGIN

@interface GFuncCallExpr : GExpr

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray<GExpr *> * arguments;

@end

NS_ASSUME_NONNULL_END
