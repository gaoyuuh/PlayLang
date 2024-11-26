//
//  GSemanticVisitor.m
//  GLang
//
//  Created by gaoyu on 2024/11/22.
//

#import "GSemanticVisitor.h"

@implementation GSemanticVisitor

- (void)addError:(NSString *)msg node:(GNode *)node {
    GParseError *error = [[GParseError alloc] init];
    error.msg = msg;
    error.node = node;
    error.beginPos = node.beginPos;
    error.isWarning = NO;
    [self.errors addObject:error];
    NSLog(@"@%@ : %@", node.beginPos, msg);
}

- (void)addWarning:(NSString *)msg node:(GNode *)node {
    GParseError *error = [[GParseError alloc] init];
    error.msg = msg;
    error.node = node;
    error.beginPos = node.beginPos;
    error.isWarning = YES;
    [self.warnings addObject:error];
    NSLog(@"@%@ : %@", node.beginPos, msg);
}

@end
