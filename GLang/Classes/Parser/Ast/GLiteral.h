//
//  GLiteral.h
//  GLang
//
//  Created by gaoyu on 2024/11/5.
//

#import "GExpr.h"

@interface GLiteral : GExpr

@end

@interface GIntegerLiteral : GLiteral

@property (nonatomic, strong) NSNumber * value;

@end

@interface GDecimalLiteral : GLiteral

@property (nonatomic, strong) NSNumber * value;

@end

@interface GStringLiteral : GLiteral

@property (nonatomic, strong) NSString * value;

@end

@interface GBoolLiteral : GLiteral

@property (nonatomic, assign) BOOL value;

@end
