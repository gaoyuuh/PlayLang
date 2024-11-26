//
//  GParser.m
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import "GParser.h"
#import "GMacroDefines.h"
#import "GUnaryExpr.h"
#import "GLiteral.h"

@interface GParser ()

@property (nonatomic, strong) NSDictionary * opPrec;

@end

@implementation GParser

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (GProgram *)parseProgram:(GTokenizer *)tokenizer {
    if (!tokenizer) {
        return nil;
    }
    self.tokenizer = tokenizer;
    GProgram *program = [[GProgram alloc] init];
    program.beginPos = [tokenizer peek].position;
    program.endPos = [tokenizer getLastPos];
    program.stmts = [self parseStatementList];
    return program;
}

- (NSArray<GStatement *> *)parseStatementList {
    NSMutableArray<GStatement *> *stmts = [NSMutableArray array];
    GToken *token = [self.tokenizer peek];
    while (token.kind != GTokenKindEOF &&
           token.kind != GTokenKindRBrace) {
        GStatement *stmt = [self parseStatement];
        if (!stmt) {
            break;
        }
        [stmts addObject:stmt];
        token = [self.tokenizer peek];
    }
    return stmts;
}

/// 解析语句
- (GStatement *)parseStatement {
    GToken *token = [self.tokenizer peek];
    switch (token.kind) {
        case GTokenKindFunc: {
            return [self parseFunctionDecl];
        } break;
        case GTokenKindVar:
        case GTokenKindLet: {
            return [self parseVariableStmt];
        } break;
        case GTokenKindReturn: {
            return [self parseReturnStmt];
        } break;
        case GTokenKindIf: {
            
        } break;
        case GTokenKindFor: {
            
        } break;
        case GTokenKindLBrace: {
            return [self parseBlock];
        } break;
        case GTokenKindIdentifier:
        case GTokenKindFloatLiteral:
        case GTokenKindIntegerLiteral:
        case GTokenKindStringLiteral:
        case GTokenKindLParen: {
            return [self parseExpStatement];
        } break;
            
        default:
            break;
    }
    NSLog(@"parseStatement error: %@ %@", [self.tokenizer peek].value, [self.tokenizer getLastPos]);
    return nil;
}

/// 解析表达式语句
- (GExprStatement *)parseExpStatement {
    GExpr *expr = [self parseExpression];
    GExprStatement *stmt = [[GExprStatement alloc] init];
    stmt.beginPos = expr.beginPos;
    stmt.endPos = [self.tokenizer getLastPos];
    stmt.expr = expr;
    GToken *token = [self.tokenizer peek];
    if (token.kind == GTokenKindSemiColon) {
        [self.tokenizer next];
        return stmt;
    } else {
        [self addError:_S(@"Expecting a semicolon at the end of an expresson statement, while we got a %@", token.value) pos:[self.tokenizer getLastPos]];
    }
    return nil;
}

/// 解析函数声明
/// funcDecl:       "func" IDENTIFIER callSignature block ;
/// callSignature:  "(" parameterList? ")" typeAnnotation? ;
/// parameterList:  parameter ("," parameter)* ;
/// parameter:      IDENTIFIER typeAnnotation? ;
/// block:          "{" statementList? "}" ;
- (GFuncDecl *)parseFunctionDecl {
    GPosition *beginPos = [self.tokenizer getNextPos];
    // 跳过 func
    [self.tokenizer next];
    GToken *token = [self.tokenizer next];
    if (token.kind != GTokenKindIdentifier) {
        [self addError:_S(@"Expecting a function name, while we got a %@", token.value) pos:self.tokenizer.getLastPos];
        return nil;
    }
    NSString *funcName = token.value;
    
    // 解析函数签名
    token = [self.tokenizer peek];
    GFuncSignature *callSign = nil;
    if (token.kind == GTokenKindLParen) {
        callSign = [self parseCallSignature];
    } else {
        [self addError:_S(@"Expecting '(' in FunctionDecl, while we got a %@", token.value) pos:self.tokenizer.getLastPos];
        return nil;
    }
    
    // 解析函数体
    token = [self.tokenizer peek];
    GBlock *funcBlock = nil;
    if (token.kind == GTokenKindLBrace) { // {
        funcBlock = [self parseBlock];
    } else {
        [self addError:_S(@"Expecting '{' in FunctionDecl, while we got a %@", token.value) pos:self.tokenizer.getLastPos];
        return nil;
    }
    
    GFuncDecl *funcDecl = [[GFuncDecl alloc] init];
    funcDecl.beginPos = beginPos;
    funcDecl.endPos = [self.tokenizer getLastPos];
    funcDecl.declName = funcName;
    funcDecl.signature = callSign;
    funcDecl.body = funcBlock;
    return funcDecl;
}

/// 解析函数签名
/// callSignature: '(' parameterList? ')' typeAnnotation? ;
- (GFuncSignature *)parseCallSignature {
    GPosition *beginPos = [self.tokenizer getNextPos];
    // 跳过 (
    [self.tokenizer next];
    
    GFuncParamsList *paramList = nil;
    GToken *token = [self.tokenizer peek];
    if (token.kind != GTokenKindRParen) { // )
        paramList = [self parseParameterList];
    }
    
    token = [self.tokenizer peek];
    if (token.kind != GTokenKindRParen) {
        [self addError:_S(@"Expecting a ')' after for a call signature") pos:[self.tokenizer getLastPos]];
        return nil;
    }
    
    // 跳过 ）
    [self.tokenizer next];
    // 解析返回值
    token = [self.tokenizer peek];
    GType *returnType = GSysTypes.Any;
    if (token.kind == GTokenKindColon) { // :
        returnType = [self parseTypeAnnotation];
    }
    GFuncSignature *funcSign = [[GFuncSignature alloc] init];
    funcSign.beginPos = beginPos;
    funcSign.endPos = [self.tokenizer getLastPos];
    funcSign.paramList = paramList;
    funcSign.returnType = returnType;
    return funcSign;
}

/// 解析参数列表
/// parameterList: parameter ("," parameter)* ;
- (GFuncParamsList *)parseParameterList {
    GPosition *beginPos = [self.tokenizer getNextPos];
    NSMutableArray<GVarDecl *> *params = [NSMutableArray array];
    GToken *token = [self.tokenizer peek];
    while (token.kind != GTokenKindRParen && token.kind != GTokenKindEOF) {
        if (token.kind != GTokenKindIdentifier) {
            [self addError:@"Expecting an identifier as name of a Parameter" pos:[self.tokenizer getLastPos]];
            break;
        }
        [self.tokenizer next];
        GToken *token1 = [self.tokenizer peek];
        GType *type = GSysTypes.Any;
        if (token1.kind == GTokenKindColon) { // :
            type = [self parseTypeAnnotation];
        }
        GVarDecl *varDecl = [[GVarDecl alloc] init];
        varDecl.beginPos = beginPos;
        varDecl.endPos = [self.tokenizer getLastPos];
        varDecl.declName = token.value;
        varDecl.declType = type;
        [params addObject:varDecl];
        
        // 处理 ","
        token = [self.tokenizer peek];
        if (token.kind != GTokenKindRParen) { // )
            if (token.kind == GTokenKindComma) { // ,
                // 跳过 ,
                [self.tokenizer next];
                token = [self.tokenizer peek];
            } else {
                [self addError:@"Expecting a ',' or '）' after a parameter" pos:[self.tokenizer getLastPos]];
                break;
            }
        }
    }
    
    GFuncParamsList *list = [[GFuncParamsList alloc] init];
    list.beginPos = beginPos;
    list.endPos = [self.tokenizer getLastPos];
    list.params = params;
    return list;
}

/// 解析类型注解
- (GType *)parseTypeAnnotation {
    // 跳过 :
    [self.tokenizer next];
    GToken *token = [self.tokenizer peek];
    if (![token isTypeAnnotation]) {
        [self addError:@"Expecting a type name in type annotation" pos:[self.tokenizer getLastPos]];
        return nil;
    }
    [self.tokenizer next];
    GType *type = [self parseTypeWithTypeName:token.value];
    return type;
}

/// 解析函数体
/// block: "{" statementList? "}" ;
- (GBlock *)parseBlock {
    GPosition *beginPos = [self.tokenizer getNextPos];
    [self.tokenizer next];
    NSArray<GStatement *> *stmts = [self parseStatementList];
    GToken *token = [self.tokenizer peek];
    if (token.kind != GTokenKindRBrace) { // }
        [self addError:_S(@"Expecting '}' while parsing a block, but we got a %@", token.value) pos:[self.tokenizer getLastPos]];
        return nil;
    }
    [self.tokenizer next];
    GBlock *block = [[GBlock alloc] init];
    block.beginPos = beginPos;
    block.endPos = [self.tokenizer getLastPos];
    block.stmts = stmts;
    return block;
}

/// 解析变量声明
/// varDecl:             ("var" | "let") IDENTIFIER typeAnnotation? ("=" expression)? ";" ;
/// typeAnnotation:      ":" ("Int" | "Int64" | "Float" | "Bool" | "String" | "Array" | "Dict" | "Any")
- (GVarDecl *)parseVariableStmt {
    GPosition *beginPos = [self.tokenizer getNextPos];
    [self.tokenizer next];
    GToken *token = [self.tokenizer next];
    if (token.kind != GTokenKindIdentifier) {
        [self addError:_S(@"Expecting variable name in GVarDecl, while we meet %@", token.value) pos:self.tokenizer.getLastPos];
        return nil;
    }
    
    NSString *varName = token.value;
    GType *varType = GSysTypes.Any;
    GExpr *expr = nil;
    
    token = [self.tokenizer peek];
    // 类型注解部分
    if (token.kind == GTokenKindColon) { // :
        [self.tokenizer next];
        token = [self.tokenizer peek];
        if ([token isTypeAnnotation]) {
            [self.tokenizer next];
            varType = [self parseTypeWithTypeName:token.value];
        } else {
            [self addError:_S(@"Error parsing type annotation in GVarDecl") pos:self.tokenizer.getLastPos];
            return nil;
        }
    }
    
    // 初始化部分
    token = [self.tokenizer peek];
    if (token.kind == GTokenKindAssign) {
        [self.tokenizer next];
        expr = [self parseExpression];
    }
    
    token = [self.tokenizer peek];
    if (token.kind == GTokenKindSemiColon) {
        [self.tokenizer next];
    }
    
    GVarDecl *varDecl = [[GVarDecl alloc] init];
    varDecl.beginPos = beginPos;
    varDecl.endPos = [self.tokenizer getLastPos];
    varDecl.declName = varName;
    varDecl.declType = varType;
    varDecl.expr = expr;
    return varDecl;
}

/// 解析表达式
- (GExpr *)parseExpression {
    return [self parseAssignment];
}

/// 解析赋值表达式
/// 赋值表达式是右结合
- (GExpr *)parseAssignment {
    int assignPrec = [self getPrec:GTokenKindAssign];
    // 先解析一个优先级更高的表达式
    GExpr *exp1 = [self parseBinary:assignPrec];
    GToken *token = [self.tokenizer peek];
    int nextPrec = [self getPrec:token.kind];
    
    // 存放赋值运算符两边的表达式
    NSMutableArray<GExpr *> *exprStack = [NSMutableArray array];
    if (exp1) {
        [exprStack addObject:exp1];
    }
    // 存放赋值运算符
    NSMutableArray<NSNumber *> *opStack = [NSMutableArray array];
    
    // 解析赋值表达式
    while ([token isOperation] && nextPrec == assignPrec) {
        [opStack addObject:@(token.kind)];
        [self.tokenizer next];
        exp1 = [self parseBinary:assignPrec];
        if (exp1) {
            [exprStack addObject:exp1];
        }
        token = [self.tokenizer peek];
        nextPrec = [self getPrec:token.kind];
    }
    
    // 组装成右结合的AST
    exp1 = exprStack[exprStack.count - 1];
    if (opStack.count) {
        for (int i = (int)exprStack.count - 2; i >= 0; i--) {
            GBinaryExpr *binary = [[GBinaryExpr alloc] init];
            binary.op = [opStack[i] intValue];
            binary.exp1 = exprStack[i];
            binary.exp2 = exp1;
            exp1 = binary;
        }
    }
    
    return exp1;
}

/// 采用运算符优先级算法，解析二元表达式
/// 递归算法，一开始，提供的参数是最低优先级
- (GExpr *)parseBinary:(int)prec {
    GExpr *exp1 = [self parseUnary];
    GToken *token = [self.tokenizer peek];
    int nextPrec = [self getPrec:token.kind];
    // 下面这个循环的意思是：只要右边出现的新运算符的优先级更高，
    // 那么就把右边出现的作为右子节点。
    /**
     * 对于2+3*5
     * 第一次循环，遇到+号，优先级大于零，所以做一次递归的parseBinary
     * 在递归的binary中，遇到乘号，优先级大于+号，所以形成3*5返回，又变成上一级的右子节点。
     *
     * 反过来，如果是3*5+2
     * 第一次循环还是一样，遇到*号，做一次递归的parseBinary
     * 在递归中，新的运算符的优先级要小，所以只返回一个5，跟前一个节点形成3*5,成为新的左子节点。
     * 接着做第二次循环，遇到+号，返回5，并作为右子节点，跟3*5一起组成一个新的binary返回。
     */
    while ([token isOperation] && nextPrec > prec) {
        [self.tokenizer next];
        GExpr *exp2 = [self parseBinary:nextPrec];
        GBinaryExpr *binaryExpr = [[GBinaryExpr alloc] init];
        binaryExpr.op = token.kind;
        binaryExpr.exp1 = exp1;
        binaryExpr.exp2 = exp2;
        
        exp1 = binaryExpr;
        token = [self.tokenizer peek];
        nextPrec = [self getPrec:token.kind];
    }
    return exp1;
}

/// 解析一元运算
/// unary: primary | prefixOp unary | primary postfixOp ;
- (GExpr *)parseUnary {
    GPosition *beginPos = [self.tokenizer getNextPos];
    GToken *token = [self.tokenizer peek];
    // 前缀表达式
    if ([token isOperation]) {
        [self.tokenizer next];
        GExpr *exp = [self parseUnary];
        GUnaryExpr *unaryExp = [[GUnaryExpr alloc] init];
        unaryExp.beginPos = beginPos;
        unaryExp.endPos = [self.tokenizer getLastPos];
        unaryExp.op = token.kind;
        unaryExp.expr = exp;
        unaryExp.isPrefix = YES;
        return unaryExp;
    } else {
        GExpr *primary = [self parsePrimary];
        GToken *token1 = [self.tokenizer peek];
        // 后缀表达式只能是 ++ 或 --
        if (token1.kind == GTokenKindIncrement || token1.kind == GTokenKindDecrement) {
            [self.tokenizer next];
            GUnaryExpr *unaryExp = [[GUnaryExpr alloc] init];
            unaryExp.beginPos = beginPos;
            unaryExp.endPos = [self.tokenizer getLastPos];
            unaryExp.op = token1.kind;
            unaryExp.expr = primary;
            unaryExp.isPrefix = NO;
            return unaryExp;
        } else {
            return primary;
        }
    }
    return nil;
}

/// 解析基础表达式
- (GExpr *)parsePrimary {
    GPosition *beginPos = [self.tokenizer getNextPos];
    GToken *token = [self.tokenizer peek];
    switch (token.kind) {
        case GTokenKindIdentifier: {
            // 以以Identifier开头，可能是函数调用，也可能是一个变量，所以要再多向后看一个Token，相当于在局部使用了LL（2）算法
            if ([self.tokenizer peek2].kind == GTokenKindLParen) {
                return [self parseFuncCall];
            } else {
                [self.tokenizer next];
                GVarExpr *expr = [[GVarExpr alloc] init];
                expr.beginPos = beginPos;
                expr.endPos = [self.tokenizer getLastPos];
                expr.name = token.value;
                return expr;
            }
        } break;
        case GTokenKindIntegerLiteral: {
            [self.tokenizer next];
            GIntegerLiteral *literal = [[GIntegerLiteral alloc] init];
            literal.beginPos = beginPos;
            literal.value = @([token.value integerValue]);
            return literal;
        } break;
        case GTokenKindFloatLiteral: {
            [self.tokenizer next];
            GDecimalLiteral *literal = [[GDecimalLiteral alloc] init];
            literal.beginPos = beginPos;
            literal.value = @([token.value doubleValue]);
            return literal;
        } break;
        case GTokenKindStringLiteral: {
            [self.tokenizer next];
            GStringLiteral *literal = [[GStringLiteral alloc] init];
            literal.beginPos = beginPos;
            literal.value = token.value;
            return literal;
        } break;
        case GTokenKindLParen: { // (
            [self.tokenizer next];
            GExpr *expr = [self parseExpression];
            GToken *token1 = [self.tokenizer peek];
            if (token1.kind == GTokenKindRParen) { // )
                [self.tokenizer next];
                return expr;
            } else {
                [self addError:_S(@"Expecting a ')' at the end of a primary expresson, while we got a %@", token1.value) pos:self.tokenizer.getLastPos];
            }
        } break;
        
        default:
            [self addError:_S(@"Can not recognize a primary expression starting with:  %@", token.value) pos:self.tokenizer.getLastPos];
            break;
    }
    return nil;
}

/// 解析函数调用
/// functionCall: Identifier "(" parameterList? ")" ;
/// parameterList: StringLiteral ("," StringLiteral)* ;
- (GFuncCallExpr *)parseFuncCall {
    GPosition *beginPos = [self.tokenizer getNextPos];
    NSMutableArray<GExpr *> *params = [NSMutableArray array];
    // 跳过函数名
    NSString *name = [self.tokenizer next].value;
    // 跳过"("
    [self.tokenizer next];
    // 获取参数列表
    GToken *token = [self.tokenizer peek];
    while (token.kind != GTokenKindRParen && token.kind != GTokenKindEOF) {
        GExpr *expr = [self parseExpression];
        if (expr) {
            [params addObject:expr];
        }
        token = [self.tokenizer peek];
        if (token.kind != GTokenKindRParen) { // ")"
            if (token.kind == GTokenKindComma) { // ","
                token = [self.tokenizer next];
            } else {
                [self addError:_S(@"Expecting a comma at the end of a parameter, while we got a %@", token.value) pos:[self.tokenizer getLastPos]];
                return nil;
            }
        }
    }
    
    if (token.kind == GTokenKindRParen) {
        // 消化掉 ")"
        [self.tokenizer next];
    }
    
    GFuncCallExpr *callExpr = [[GFuncCallExpr alloc] init];
    callExpr.beginPos = beginPos;
    callExpr.endPos = [self.tokenizer getLastPos];
    callExpr.name = name;
    callExpr.arguments = params;
    return callExpr;
}

/// Return语句
- (GReturnStmt *)parseReturnStmt {
    GPosition *beginPos = [self.tokenizer getNextPos];
    GExpr *expr = nil;
    // 跳过return
    [self.tokenizer next];
    
    // 解析后面的表达式
    GToken *token = [self.tokenizer peek];
    if (token.kind != GTokenKindSemiColon) { // ;
        expr = [self parseExpression];
    }
    
    // 跳过;
    token = [self.tokenizer peek];
    if (token.kind == GTokenKindSemiColon) { // ;
        [self.tokenizer next];
    } else {
        [self addError:@"Expecting ';' after return statement." pos:[self.tokenizer getLastPos]];
    }
    
    GReturnStmt *stmt = [[GReturnStmt alloc] init];
    stmt.beginPos = beginPos;
    stmt.endPos = [self.tokenizer getLastPos];
    stmt.expr = expr;
    return stmt;
}

/// 获取运算符优先级
- (int)getPrec:(GTokenKind)op {
    NSString *value = self.opPrec[@(op)];
    if (!value) {
        return -1;
    } else {
        return [value intValue];
    }
}

/// 二元运算符的优先级
- (NSDictionary *)opPrec {
    return @{
        @(GTokenKindAssign):            @"2",
        @(GTokenKindAddAssign):         @"2",
        @(GTokenKindSubAssign):         @"2",
        @(GTokenKindMultiplyAssign):    @"2",
        @(GTokenKindDivideAssign):      @"2",
        @(GTokenKindModulusAssign):     @"2",
        @(GTokenKindBitAndAssign):      @"2",
        @(GTokenKindBitOrAssign):       @"2",
        @(GTokenKindBitXorAssign):      @"2",
        @(GTokenKindLShiftAssign):      @"2",
        @(GTokenKindRShiftAssign):      @"2",
        @(GTokenKindOR):                @"4",
        @(GTokenKindAND):               @"5",
        @(GTokenKindBitOr):             @"6",
        @(GTokenKindBitXor):            @"7",
        @(GTokenKindBitAnd):            @"8",
        @(GTokenKindEQ):                @"9",
        @(GTokenKindNotEQ):             @"9",
        @(GTokenKindGT):                @"10",
        @(GTokenKindGE):                @"10",
        @(GTokenKindLT):                @"10",
        @(GTokenKindLE):                @"10",
        @(GTokenKindLShift):            @"11",
        @(GTokenKindRShift):            @"11",
        @(GTokenKindAdd):               @"12",
        @(GTokenKindSub):               @"12",
        @(GTokenKindMultiply):          @"13",
        @(GTokenKindDivide):            @"13",
        @(GTokenKindModulus):           @"13",
    };
}

/// 类型
- (GType *)parseTypeWithTypeName:(NSString *)typeName {
    if ([typeName isEqualToString:@"Int"]) {
        return GSysTypes.Int;
    }
    if ([typeName isEqualToString:@"Int64"]) {
        return GSysTypes.Int64;
    }
    if ([typeName isEqualToString:@"Float"]) {
        return GSysTypes.Float;
    }
    if ([typeName isEqualToString:@"Bool"]) {
        return GSysTypes.Boolean;
    }
    if ([typeName isEqualToString:@"String"]) {
        return GSysTypes.String;
    }
    if ([typeName isEqualToString:@"Any"]) {
        return GSysTypes.Any;
    }
    return nil;
}

- (void)addError:(NSString *)msg pos:(GPosition *)pos {
    GParseError *err = [[GParseError alloc] init];
    err.msg = msg;
    err.beginPos = pos;
    [self.errors addObject:err];
    NSLog(@"Error @ %@ : %@", pos, msg);
}

- (void)addWarning:(NSString *)msg pos:(GPosition *)pos {
    GParseError *err = [[GParseError alloc] init];
    err.msg = msg;
    err.beginPos = pos;
    err.isWarning = YES;
    [self.warnings addObject:err];
    NSLog(@"Warning @ %@ : %@", pos, msg);
}


#pragma mark - Lazy

- (NSMutableArray<GParseError *> *)errors {
    if (!_errors) {
        _errors = [NSMutableArray array];
    }
    return _errors;
}

- (NSMutableArray<GParseError *> *)warnings {
    if (!_warnings) {
        _warnings = [NSMutableArray array];
    }
    return _warnings;
}

@end
