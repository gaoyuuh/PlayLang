//
//  GToken.m
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import "GToken.h"

@implementation GToken

+ (instancetype)tokenKind:(GTokenKind)kind value:(NSString *)value {
    return [self tokenKind:kind value:value pos:nil];
}

+ (instancetype)tokenKind:(GTokenKind)kind value:(NSString *)value pos:(GPosition *)pos {
    GToken *token = [[GToken alloc] init];
    token.kind = kind;
    token.value = value;
    token.position = pos;
    return token;
}

- (BOOL)isTypeAnnotation {
    BOOL typeAnnotation = NO;
    switch (self.kind) {
        case GTokenKindInt:
        case GTokenKindInt64:
        case GTokenKindFloat:
        case GTokenKindBool:
        case GTokenKindString:
        case GTokenKindArray:
        case GTokenKindDict:
        case GTokenKindAny:
            typeAnnotation = YES;
            break;
        default:
            break;
    }
    return typeAnnotation;
}

- (BOOL)isOperation {
    BOOL operation = NO;
    switch (self.kind) {
        case GTokenKindNot:
        case GTokenKindSub:
        case GTokenKindMultiply:
        case GTokenKindDivide:
        case GTokenKindModulus:
        case GTokenKindAdd:
        case GTokenKindLShift:
        case GTokenKindRShift:
        case GTokenKindLT:
        case GTokenKindLE:
        case GTokenKindGT:
        case GTokenKindGE:
        case GTokenKindEQ:
        case GTokenKindNotEQ:
        case GTokenKindBitAnd:
        case GTokenKindBitXor:
        case GTokenKindBitOr:
        case GTokenKindAND:
        case GTokenKindOR:
        case GTokenKindAssign:
        case GTokenKindMultiplyAssign:
        case GTokenKindDivideAssign:
        case GTokenKindModulusAssign:
        case GTokenKindAddAssign:
        case GTokenKindSubAssign:
        case GTokenKindLShiftAssign:
        case GTokenKindRShiftAssign:
        case GTokenKindBitAndAssign:
        case GTokenKindBitXorAssign:
        case GTokenKindBitOrAssign:
            operation = YES;
        default:
            break;
    }
    return operation;
}

+ (BOOL)isAssignOp:(GTokenKind)op {
    return op == GTokenKindAssign;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GToken @%@\t%d\t'%@'", self.position, self.kind, self.value];
}

@end
