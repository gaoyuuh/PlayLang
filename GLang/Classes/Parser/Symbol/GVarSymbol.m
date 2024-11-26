//
//  GVarSymbol.m
//  Pods
//
//  Created by gaoyu on 2024/9/9.
//

#import "GVarSymbol.h"

@implementation GVarSymbol

+ (instancetype)symbolWithName:(NSString *)name 
                       theType:(GType *)theType {
    GVarSymbol *symbol = [[GVarSymbol alloc] init];
    symbol.name = name;
    symbol.kind = GSymbolKindVariable;
    symbol.theType = theType;
    return symbol;
}

@end
