//
//  GExprStatement.m
//  Pods
//
//  Created by gaoyu on 2024/9/9.
//

#import "GExprStatement.h"
#import "GAstVisitor.h"

@implementation GExprStatement

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitExprStmt:self];
}

@end
