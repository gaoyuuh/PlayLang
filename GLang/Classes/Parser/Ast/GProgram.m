//
//  GProgram.m
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GProgram.h"
#import "GAstVisitor.h"

@implementation GProgram

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitProg:self];
}

@end
