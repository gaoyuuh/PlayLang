//
//  GBinaryExpr.m
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GBinaryExpr.h"
#import "GAstVisitor.h"

@implementation GBinaryExpr

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitBinaryExpr:self];
}

@end
