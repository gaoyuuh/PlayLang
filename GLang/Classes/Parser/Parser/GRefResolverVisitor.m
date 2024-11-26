//
//  GRefResolverVisitor.m
//  GLang
//
//  Created by gaoyu on 2024/11/22.
//

#import "GRefResolverVisitor.h"
#import "GFunctionSymbol.h"

@interface GRefResolverVisitor ()

@property (nonatomic, strong) GScope * scope;
// 每个Scope已经声明了的变量的列表
@property (nonatomic, strong) NSMapTable<GScope *, NSMutableDictionary<NSString *, GVarSymbol *> *> * declaredVarsMap;

@end

@implementation GRefResolverVisitor

- (instancetype)init {
    if (self = [super init]) {
        self.declaredVarsMap = [[NSMapTable alloc] init];
    }
    return self;
}

- (id)visitFuncDecl:(GFuncDecl *)funcDecl {
    // 1.修改scope
    GScope *oldScope = self.scope;
    self.scope = funcDecl.scope;
    NSAssert(self.scope, @"Scope不可为null");
    
    // 为已声明的变量设置一个存储区域
    [self.declaredVarsMap setObject:[NSMutableDictionary dictionary] forKey:self.scope];
    
    // 2.遍历下级节点
    [super visitFuncDecl:funcDecl];
    
    // 3.重新设置scope
    self.scope = oldScope;
    return nil;
}

- (id)visitBlock:(GBlock *)block {
    // 1.修改scope
    GScope *oldScope = self.scope;
    self.scope = block.scope;
    NSAssert(self.scope, @"Scope不可为null");
    
    // 为已声明的变量设置一个存储区域
    [self.declaredVarsMap setObject:[NSMutableDictionary dictionary] forKey:self.scope];
    
    // 2.遍历下级节点
    [super visitBlock:block];
    
    // 3.重新设置scope
    self.scope = oldScope;
    return nil;
}

/// 做函数的消解。
/// 函数不需要声明在前，使用在后。
- (id)visitFuncCall:(GFuncCallExpr *)funcCall {
    GScope *currentScope = self.scope;
    if ([@[@"println"] containsObject:funcCall.name]) {
        GFunctionType *type = [[GFunctionType alloc] init];
        type.returnType = GSysTypes.Void;
        type.paramTypes = @[GSysTypes.String];
        
        GFunctionSymbol *symbol = [[GFunctionSymbol alloc] init];
        symbol.name = funcCall.name;
        symbol.theType = type;
        funcCall.sym = symbol;
    } else {
        funcCall.sym = (GFunctionSymbol *)[currentScope getSymbolCascade:funcCall.name];
    }
    
    //调用下级，主要是参数。
    return [super visitFuncCall:funcCall];;
}

/// 标记变量是否已被声明
- (id)visitVarDecl:(GVarDecl *)varDecl {
    GScope *currentScope = self.scope;
    NSMutableDictionary *declaredSyms = [self.declaredVarsMap objectForKey:currentScope];
    GSymbol *sym = [currentScope getSymbol:varDecl.declName];
    if (sym) { // TODO 需要检查sym是否是变量
        declaredSyms[varDecl.declName] = sym;
    }
    
    //处理初始化的部分
    [super visitVarDecl:varDecl];
    return nil;
}

/// 变量引用消解
/// 变量必须声明在前，使用在后。
- (id)visitVarExpr:(GVarExpr *)varExpr {
    GScope *currentScope = self.scope;
    varExpr.sym = [self findVariableCascade:currentScope variable:varExpr];
    return nil;
}

/// 逐级查找某个符号是不是在声明前就使用了
- (GVarSymbol *)findVariableCascade:(GScope *)scope variable:(GVarExpr *)variable {
    NSMutableDictionary<NSString *, GVarSymbol *> *declaredSyms = [[self.declaredVarsMap objectForKey:scope] mutableCopy];
    GVarSymbol *symInScope = (GVarSymbol *)[scope getSymbol:variable.name];
    if (symInScope != nil) {
        if ([declaredSyms objectForKey:variable.name] != nil) {
            return [declaredSyms objectForKey:variable.name]; // 找到了，成功返回。
        } else {
            if (symInScope.kind == GSymbolKindVariable) {
                [self addError:[NSString stringWithFormat:@"Variable: '%@' is used before declaration.", variable.name] node:variable];
            } else {
                [self addError:[NSString stringWithFormat:@"We expect a variable of name: '%@', but find a %d.", variable.name, symInScope.kind] node:variable];
            }
        }
    } else {
        if (scope.enclosingScope != nil) {
            return [self findVariableCascade:scope.enclosingScope variable:variable];
        } else {
            [self addError:[NSString stringWithFormat:@"Cannot find a variable of name: '%@'", variable.name] node:variable];
        }
    }
    return nil;
}

@end
