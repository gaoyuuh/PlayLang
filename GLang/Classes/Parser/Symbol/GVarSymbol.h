//
//  GVarSymbol.h
//  Pods
//
//  Created by gaoyu on 2024/9/9.
//

#import "GSymbol.h"

@interface GVarSymbol : GSymbol

+ (instancetype)symbolWithName:(NSString *)name 
                       theType:(GType *)theType;

@end
