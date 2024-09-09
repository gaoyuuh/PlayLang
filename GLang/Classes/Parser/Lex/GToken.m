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
        case GTokenKindId:
            typeAnnotation = YES;
            break;
        default:
            break;
    }
    return typeAnnotation;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GToken @%@\t%d\t'%@'", self.position, self.kind, self.value];
}

@end
