//
//  GReturnExpr.m
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GReturnStmt.h"
#import "GAstVisitor.h"

@implementation GReturnStmt

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitReturnStmt:self];
}

@end
