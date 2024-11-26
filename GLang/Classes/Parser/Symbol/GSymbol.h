//
//  GSymbol.h
//  Pods
//
//  Created by gaoyu on 2024/9/9.
//

#import <Foundation/Foundation.h>
#import "GType.h"

typedef NS_ENUM(int, GSymbolKind) {
    GSymbolKindVariable = 1,
    GSymbolKindFunction,
    GSymbolKindClass,
};

@interface GSymbol : NSObject

/// 符号名称
@property (nonatomic, strong) NSString * name;
/// 符号类型
@property (nonatomic, assign) GSymbolKind kind;
/// 值类型
@property (nonatomic, strong) GType * theType;

@end
