//
//  GExpr.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GNode.h"
@class GType;

@interface GExpr : GNode

@property (nonatomic, strong) GType * theType;
/// 是否是一个左值
@property (nonatomic, assign) BOOL isLeftValue;

@end
