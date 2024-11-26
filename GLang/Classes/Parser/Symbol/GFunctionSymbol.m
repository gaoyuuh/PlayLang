//
//  GFunctionSymbol.m
//  Pods
//
//  Created by gaoyu on 2024/9/9.
//

#import "GFunctionSymbol.h"

@implementation GFunctionSymbol

- (instancetype)init {
    self = [super init];
    if (self) {
        self.opStackSize = 10;
    }
    return self;
}

- (NSUInteger)getNumParams {
    if ([self.theType isKindOfClass:GFunctionType.class]) {
        return ((GFunctionType *)self.theType).paramTypes.count;
    }
    return 0;
}

@end
