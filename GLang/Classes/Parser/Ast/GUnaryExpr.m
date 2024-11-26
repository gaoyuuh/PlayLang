//
//  GUnaryExpr.m
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GUnaryExpr.h"
#import "GAstVisitor.h"

@implementation GUnaryExpr

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitUnaryExpr:self];
}

@end
