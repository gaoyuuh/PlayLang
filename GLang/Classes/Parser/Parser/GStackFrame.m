//
//  GStackFrame.m
//  GLang
//
//  Created by gaoyu on 2024/11/25.
//

#import "GStackFrame.h"

@implementation GReturnValue

+ (BOOL)isReturnValue:(id)v {
    return [v isKindOfClass:[GReturnValue class]];
}

@end

@implementation GStackFrame

- (NSMapTable<GSymbol *,id> *)values {
    if (!_values) {
        _values = [[NSMapTable alloc] init];
    }
    return _values;
}

@end
