//
//  GLeftValueAttrVisitor.m
//  GLang
//
//  Created by gaoyu on 2024/11/25.
//

#import "GLeftValueAttrVisitor.h"
#import "GAstHeader.h"

@interface GLeftValueAttrVisitor ()

@property (nonatomic, assign) GTokenKind parentOperator;

@end

@implementation GLeftValueAttrVisitor

- (instancetype)init {
    if (self = [super init]) {
        self.parentOperator = -1;
    }
    return self;
}

/// 变量都可以作为左值，除非其类型是void
- (id)visitVarExpr:(GVarExpr *)varExpr {
    if (self.parentOperator) {
        GType *type = varExpr.theType;
        if (![type hasVoid]) {
            varExpr.isLeftValue = YES;
        }
    }
    return nil;
}

/// 检查赋值符号和.符号左边是否是左值
- (id)visitBinaryExpr:(GBinaryExpr *)binaryExpr {
    if ([GToken isAssignOp:binaryExpr.op]) {
        GTokenKind lastParentOperator = self.parentOperator;
        self.parentOperator = binaryExpr.op;
        
        // 检查左子节点
        [self visit:binaryExpr.exp1];
        if (!binaryExpr.exp1.isLeftValue) {
            [self addError:[NSString stringWithFormat:@"Left child of operator `%d` need a left value `%@`", binaryExpr.op, binaryExpr.exp1] node:binaryExpr.exp1];
        }
        
        // 恢复原来的状态信息
        self.parentOperator = lastParentOperator;
        
        // 继续遍历右子节点
        [self visit:binaryExpr.exp2];
    } else {
        return [super visitBinaryExpr:binaryExpr];
    }
    return nil;
}

- (id)visitUnaryExpr:(GUnaryExpr *)unaryExpr {
    //要求必须是个左值
    if (unaryExpr.op == GTokenKindIncrement || unaryExpr.op == GTokenKindDecrement) {
        GTokenKind lastParentOperator = self.parentOperator;
        self.parentOperator = unaryExpr.op;
        
        [self visit:unaryExpr.expr];
        if (!unaryExpr.expr.isLeftValue) {
            [self addError:[NSString stringWithFormat:@"Unary operator `%d` can only be applied to a left value `%@`", unaryExpr.op, unaryExpr] node:unaryExpr];
        }
        
        // 恢复原来的状态信息
        self.parentOperator = lastParentOperator;
    } else {
        return [super visitUnaryExpr:unaryExpr];
    }
    return nil;
}

/// 但函数调用是在.符号左边，并且返回值不为void的时候，可以作为左值
- (id)visitFuncCall:(GFuncCallExpr *)funcCall {
    if (self.parentOperator == GTokenKindDot) {
        GFunctionType *functionType = (GFunctionType *)funcCall.theType;
        if (![functionType.returnType hasVoid]) {
            funcCall.isLeftValue = YES;
        }
    }
    return nil;
}

@end
