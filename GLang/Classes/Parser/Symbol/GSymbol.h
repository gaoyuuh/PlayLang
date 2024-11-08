//
//  GSymbol.h
//  Pods
//
//  Created by gaoyu on 2024/9/9.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, GSymbolKind) {
    GSymbolKindVariable = 1,
    GSymbolKindFunction,
    GSymbolKindClass,
};

@interface GSymbol : NSObject

@property (nonatomic, strong) NSString * name;

@end
