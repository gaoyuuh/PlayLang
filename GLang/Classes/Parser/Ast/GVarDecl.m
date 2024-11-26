//
//  GVarDecl.m
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GVarDecl.h"
#import "GAstVisitor.h"

@implementation GVarDecl

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitVarDecl:self];
}

@end
