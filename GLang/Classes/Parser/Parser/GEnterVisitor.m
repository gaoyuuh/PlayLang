//
//  GEnterVisitor.m
//  GLang
//
//  Created by gaoyu on 2024/11/22.
//

#import "GEnterVisitor.h"
#import "GFunctionSymbol.h"
#import "GMacroDefines.h"

@interface GEnterVisitor ()

@property (nonatomic, strong) GScope * scope;

@property (nonatomic, strong) GFunctionSymbol * funcSym;

@end

@implementation GEnterVisitor

- (id)visitProg:(GProgram *)prog {
    GFunctionType *type = [[GFunctionType alloc] init];
    type.returnType = GSysTypes.Int;
    
    GFunctionSymbol *symbol = [[GFunctionSymbol alloc] init];
    symbol.name = @"main";
    symbol.theType = type;
    
    prog.sym = symbol;
    self.funcSym = symbol;
    return [super visitProg:prog];
}

/// 把函数声明加入符号表
- (id)visitFuncDecl:(GFuncDecl *)funcDecl {
    GScope *curScope = self.scope;
    if ([curScope hasSymbol:funcDecl.declName]) {
        [self addError:_S(@"Dumplicate symbol: %@", funcDecl.declName) node:funcDecl];
    }
    
    NSMutableArray<GType *> *paramTypes = [NSMutableArray array];
    for (GVarDecl *varDecl in funcDecl.signature.paramList.params) {
        [paramTypes addObject:varDecl.declType];
    }
    
    GFunctionType *type = [[GFunctionType alloc] init];
    type.returnType = funcDecl.signature.returnType;
    type.paramTypes = paramTypes;
    
    GFunctionSymbol *symbol = [[GFunctionSymbol alloc] init];
    symbol.kind = GSymbolKindFunction;
    symbol.name = funcDecl.declName;
    symbol.theType = type;
    symbol.decl = funcDecl;
    funcDecl.sym = symbol;
    [curScope enter:funcDecl.declName sym:symbol];
    
    // 修改当前的函数符号
    GFunctionSymbol *lastFunctionSym = self.funcSym;
    self.funcSym = symbol;
    
    // 创建新的Scope，用来存放参数
    GScope *oldScope = curScope;
    GScope *tmp = [[GScope alloc] init];
    tmp.enclosingScope = oldScope;
    self.scope = tmp;
    funcDecl.scope = self.scope;
    
    // 遍历子节点
    [super visitFuncDecl:funcDecl];
    
    // 恢复当前函数
    self.funcSym = lastFunctionSym;

    // 恢复原来的Scope
    self.scope = oldScope;
    
    return nil;
}

/// 遇到block时，建立一级新的作用域
- (id)visitBlock:(GBlock *)block {
    // 创建下一级scope
    GScope *oldScope = self.scope;
    GScope *tmp = [[GScope alloc] init];
    tmp.enclosingScope = self.scope;
    self.scope = tmp;
    block.scope = self.scope;
    
    // 调用父类的方法，遍历所有的语句
    [super visitBlock:block];
    
    // 重新设置当前的Scope
    self.scope = oldScope;
    return nil;
}

/// 把变量声明加入符号表
- (id)visitVarDecl:(GVarDecl *)varDecl {
    GScope *curScope = self.scope;
    if ([curScope hasSymbol:varDecl.declName]) {
        [self addError:_S(@"Dumplicate symbol: %@", varDecl.declName) node:varDecl];
    }
    
    // 把变量加入当前的符号表
    GVarSymbol *symbol = [[GVarSymbol alloc] init];
    symbol.kind = GSymbolKindVariable;
    symbol.name = varDecl.declName;
    symbol.theType = varDecl.declType;
    varDecl.symbol = symbol;
    [curScope enter:varDecl.declName sym:symbol];
    
    // 把本地变量也加入函数符号中，可用于后面生成代码
    NSMutableArray *tmpAry = [NSMutableArray array];
    if (self.funcSym.vars.count) {
        [tmpAry addObject:self.funcSym.vars];
    }
    [tmpAry addObject:symbol];
    self.funcSym.vars = [tmpAry copy];
    
    return nil;
}

@end
