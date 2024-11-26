//
//  GBlock.m
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GBlock.h"
#import "GAstVisitor.h"

@implementation GBlock

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitBlock:self];
}

@end
