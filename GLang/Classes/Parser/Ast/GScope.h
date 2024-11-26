//
//  GScope.h
//  Pods
//
//  Created by gaoyu on 2024/9/9.
//

#import <Foundation/Foundation.h>
#import "GSymbol.h"

@interface GScope : NSObject

/// 上级作用域
@property (nonatomic, strong) GScope * enclosingScope;

/// 把符号记入符号表（作用域）
- (void)enter:(NSString *)name sym:(GSymbol *)sym;

/// 查询是否有某名称的符号
- (BOOL)hasSymbol:(NSString *)name;

/// 根据名称查找符号
- (GSymbol *)getSymbol:(NSString *)name;

/// 级联查找某个符号
/// 先从本作用域查找，查不到就去上一级作用域，依此类推
- (GSymbol *)getSymbolCascade:(NSString *)name;

@end
