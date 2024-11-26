//
//  GFunctionSymbol.h
//  Pods
//
//  Created by gaoyu on 2024/9/9.
//

#import "GSymbol.h"
#import "GVarSymbol.h"
#import "GFuncDecl.h"

@interface GFunctionSymbol : GSymbol

/// 本地变量的列表，参数也算本地变量
@property (nonatomic, strong) NSArray<GVarSymbol *> * vars;
/// 操作数栈的大小
@property (nonatomic, assign) int opStackSize;
/// 存放生成的字节码
@property (nonatomic, strong) NSArray<NSNumber *> * byteCode;
/// 存放ast，作为代码来运行
@property (nonatomic, strong) GFuncDecl * decl;

- (NSUInteger)getNumParams;

@end
