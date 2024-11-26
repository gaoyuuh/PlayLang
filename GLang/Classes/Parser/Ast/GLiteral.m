//
//  GLiteral.m
//  GLang
//
//  Created by gaoyu on 2024/11/5.
//

#import "GLiteral.h"
#import "GAstVisitor.h"

@implementation GLiteral

@end

@implementation GIntegerLiteral

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitIntegerLiteral:self];
}

@end

@implementation GDecimalLiteral

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitDecimalLiteral:self];
}

@end

@implementation GStringLiteral

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitStringLiteral:self];
}

@end

@implementation GBoolLiteral

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitBoolLiteral:self];
}

@end
