//
//  GScope.m
//  Pods
//
//  Created by gaoyu on 2024/9/9.
//

#import "GScope.h"

@interface GScope ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, GSymbol *> * name2sym;

@end

@implementation GScope

- (void)enter:(NSString *)name sym:(GSymbol *)sym {
    if (!sym || name.length == 0) return;
    self.name2sym[name] = sym;
}

- (BOOL)hasSymbol:(NSString *)name {
    return self.name2sym[name];
}

- (GSymbol *)getSymbol:(NSString *)name {
    return self.name2sym[name];
}

- (GSymbol *)getSymbolCascade:(NSString *)name {
    GSymbol *symbol = [self getSymbol:name];
    if (symbol) {
        return symbol;
    }
    return [self.enclosingScope getSymbolCascade:name];
}

- (NSMutableDictionary<NSString *, GSymbol *> *)name2sym {
    if (!_name2sym) {
        _name2sym = [NSMutableDictionary dictionary];
    }
    return _name2sym;
}

@end
