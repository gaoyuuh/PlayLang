//
//  GVarStmt.m
//  Pods
//
//  Created by gaoyu on 2024/9/19.
//

#import "GVarExpr.h"
#import "GAstVisitor.h"

@implementation GVarExpr

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitVarExpr:self];
}

@end
