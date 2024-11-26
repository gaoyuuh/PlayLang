//
//  GCallExpr.m
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GFuncCallExpr.h"
#import "GAstVisitor.h"

@implementation GFuncCallExpr

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitFuncCall:self];
}

@end
