//
//  GIntepretor.m
//  GLang
//
//  Created by gaoyu on 2024/11/25.
//

#import "GIntepretor.h"
#import "GStackFrame.h"
#import "GFunctionSymbol.h"

@interface GIntepretor ()

@property (nonatomic, strong) NSMutableArray<GStackFrame *> * stacks;
@property (nonatomic, strong) GStackFrame * currentFrame;

@end

@implementation GIntepretor

- (instancetype)init {
    if (self = [super init]) {
        self.currentFrame = [[GStackFrame alloc] init];
        self.stacks = [NSMutableArray array];
        [self.stacks addObject:self.currentFrame];
    }
    return self;
}

/// 变量声明
/// 如果存在变量初始化部分，要存下变量值
- (id)visitVarDecl:(GVarDecl *)varDecl {
    if (varDecl.expr) {
        id v = [self visit:varDecl.expr];
        [self setVariableValue:varDecl.symbol value:v];
        return v;
    }
    return nil;
}

- (id)visitVarExpr:(GVarExpr *)varExpr {
    if (varExpr.isLeftValue) {
        return varExpr.sym;
    }
    return [self getVariableValue:varExpr.sym];
}

- (id)visitBinaryExpr:(GBinaryExpr *)binaryExpr {
    id ret = nil;
    id v1 = [self visit:binaryExpr.exp1];
    id v2 = [self visit:binaryExpr.exp2];
    switch (binaryExpr.op) {
        case GTokenKindAdd: // '+'
            ret = @( [v1 doubleValue] + [v2 doubleValue] );
            break;
        case GTokenKindSub: // '-'
            ret = @( [v1 doubleValue] - [v2 doubleValue] );
            break;
        case GTokenKindMultiply: // '*'
            ret = @( [v1 doubleValue] * [v2 doubleValue] );
            break;
        case GTokenKindDivide: // '/'
            ret = @( [v1 doubleValue] / [v2 doubleValue] );
            break;
        case GTokenKindModulus: // '%'
            ret = @( [v1 intValue] % [v2 intValue] );
            break;
        case GTokenKindGT: // '>'
            ret = @( [v1 doubleValue] > [v2 doubleValue] );
            break;
        case GTokenKindGE: // '>='
            ret = @( [v1 doubleValue] >= [v2 doubleValue] );
            break;
        case GTokenKindLT: // '<'
            ret = @( [v1 doubleValue] < [v2 doubleValue] );
            break;
        case GTokenKindLE: // '<='
            ret = @( [v1 doubleValue] <= [v2 doubleValue] );
            break;
        case GTokenKindEQ: // '=='
            ret = @( [v1 doubleValue] == [v2 doubleValue] );
            break;
        case GTokenKindNotEQ: // '!='
            ret = @( [v1 doubleValue] != [v2 doubleValue] );
            break;
        case GTokenKindAND: // '&&'
            ret = @( [v1 boolValue] && [v2 boolValue] );
            break;
        case GTokenKindOR: // '||'
            ret = @( [v1 boolValue] || [v2 boolValue] );
            break;
        case GTokenKindAssign: // '='
        {
            GVarSymbol *varSymbol = (GVarSymbol *)v1;
            [self setVariableValue:varSymbol value:v2];
        }
        break;
        default:
            NSLog(@"Unsupported binary operation: %d", binaryExpr.op);
    }
    return ret;
}

- (id)visitUnaryExpr:(GUnaryExpr *)unaryExpr {
    id v = [self visit:unaryExpr.expr];
    GVarSymbol *varSymbol = nil;
    id value = nil;
    switch (unaryExpr.op) {
        case GTokenKindIncrement:
            varSymbol = (GVarSymbol *)v;
            value = [self getVariableValue:varSymbol];
            [self setVariableValue:varSymbol value:@([value intValue] + 1)];
            if (unaryExpr.isPrefix) {
                return @([value intValue] + 1);
            } else {
                return value;
            }
            break;
        case GTokenKindDecrement:
            varSymbol = (GVarSymbol *)v;
            value = [self getVariableValue:varSymbol];
            [self setVariableValue:varSymbol value:@([value intValue] - 1)];
            if (unaryExpr.isPrefix) {
                return @([value intValue] - 1);
            } else {
                return value;
            }
            break;
        case GTokenKindAdd:
            return v;
            break;
        case GTokenKindSub:
            return @(-[v intValue]);
            break;
        default:
            NSLog(@"Unsupported unary op: %d", unaryExpr.op);
    }
    return nil;
}

- (id)visitFuncDecl:(GFuncDecl *)funcDecl {
    return nil;
}

/// 函数调用
- (id)visitFuncCall:(GFuncCallExpr *)funcCall {
    if ([funcCall.name isEqualToString:@"println"]) { // 内置函数
        return [self println:funcCall.arguments];
    }
    if (funcCall.sym) {
        self.currentFrame.retVal = nil;
        // 1. 创建新栈桢
        GStackFrame *frame = [[GStackFrame alloc] init];
        // 2. 计算参数值，并保存到新创建的栈桢
        GFuncDecl *funcDecl = funcCall.sym.decl;
        if (funcDecl.signature.paramList) {
            NSArray<GVarDecl *> *params = funcDecl.signature.paramList.params;
            for (int i = 0; i < params.count; i++) {
                GVarDecl *variableDecl = params[i];
                id val = [self visit:funcCall.arguments[i]];
                [frame.values setObject:val forKey:variableDecl.symbol];
            }
        }
        // 3. 把新栈桢入栈
        [self pushFrame:frame];
        // 4. 执行函数
        [self visit:funcDecl.body];
        // 5. 弹出当前的栈桢
        [self popFrame];
        // 6. 函数的返回值
        return self.currentFrame.retVal;
    } else {
        NSLog(@"Runtime error, cannot find declaration of `%@`", funcCall.name);
    }
    return nil;
}

- (id)visitBlock:(GBlock *)block {
    id retVal = nil;
    for (GStatement *stmt in block.stmts) {
        retVal = [self visit:stmt];
        //如果当前执行了一个返回语句，那么就直接返回，不再执行后面的语句。
        //如果存在上一级Block，也是中断执行，直接返回。
        if (retVal && [GReturnValue isReturnValue:retVal]) {
            return retVal;
        }
    }
    return retVal;
}

- (id)visitReturnStmt:(GReturnStmt *)returnStmt {
    id retVal = nil;
    if (returnStmt.expr) {
        retVal = [self visit:returnStmt.expr];
        [self setReturnValue:retVal];
    }
    // 这里是传递一个信号，让Block和for循环等停止执行。
    GReturnValue *ret = [[GReturnValue alloc] init];
    ret.value = retVal;
    return ret;
}

// 把返回值设置到上一级栈桢中（也就是调用者的栈桢）
- (void)setReturnValue:(id)retVal {
    GStackFrame *frame = self.stacks[self.stacks.count - 2];
    frame.retVal = retVal;
}

/// 内置函数 println
- (id)println:(NSArray<GExpr *> *)args {
    if (args.count > 0) {
        id retVal = [self visit:args[0]];
        NSLog(@"%@", retVal);
    } else {
        NSLog(@"");
    }
    return @(0);
}

- (id)getVariableValue:(GVarSymbol *)sym {
    return [self.currentFrame.values objectForKey:sym];
}

- (void)setVariableValue:(GVarSymbol *)sym value:(id)value {
    [self.currentFrame.values setObject:value forKey:sym];
}

- (void)pushFrame:(GStackFrame *)frame {
    [self.stacks addObject:frame];
    self.currentFrame = frame;
}

- (void)popFrame {
    if (self.stacks.count > 1) {
        GStackFrame *frame = self.stacks[self.stacks.count - 2];
        [self.stacks removeLastObject];
        self.currentFrame = frame;
    }
}

@end
