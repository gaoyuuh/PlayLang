//
//  GFuncDecl.m
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GFuncDecl.h"
#import "GAstVisitor.h"

@implementation GFuncDecl

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitFuncDecl:self];
}

@end
