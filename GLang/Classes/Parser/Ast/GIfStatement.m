//
//  GIfExpr.m
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GIfStatement.h"
#import "GAstVisitor.h"

@implementation GIfStatement

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitIfStmt:self];
}

@end
