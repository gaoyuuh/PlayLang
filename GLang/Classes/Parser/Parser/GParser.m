//
//  GParser.m
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import "GParser.h"
#import "GMacroDefines.h"

@interface GParser ()

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
            
        } break;
        case GTokenKindVar:
        case GTokenKindLet: {
            GVarDecl *decl = [self parseVariableStmt];
            if (decl) {
                return decl;
            }
        } break;
        case GTokenKindReturn: {
            
        } break;
        case GTokenKindIf: {
            
        } break;
        case GTokenKindFor: {
            
        } break;
        case GTokenKindLBrace: {
            
        } break;
            
        default:
            break;
    }
    NSLog(@"parseStatement error: %@ %@", [self.tokenizer peek].value, [self.tokenizer getLastPos]);
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
    [self.tokenizer next];
    GToken *token = [self.tokenizer next];
    if (token.kind != GTokenKindIdentifier) {
        [self addError:_S(@"Expecting a function name, while we got a %@", token.value) pos:self.tokenizer.getLastPos];
        return nil;
    }
    
    // 解析函数签名
    token = [self.tokenizer peek];
    if (token.kind != GTokenKindLParen) {
        [self addError:_S(@"Expecting '(' in FunctionDecl, while we got a %@", token.value) pos:self.tokenizer.getLastPos];
        return nil;
    }
    
    return nil;
}

/// 解析变量声明
/// varDecl:             ("var" | "let") IDENTIFIER typeAnnotation? ("=" expression)? ";" ;
/// typeAnnotation:      ":" ("Int" | "Int64" | "Float" | "Bool" | "String" | "Array" | "Dict" | "Id")
- (GVarDecl *)parseVariableStmt {
    GPosition *beginPos = [self.tokenizer getNextPos];
    [self.tokenizer next];
    GToken *token = [self.tokenizer next];
    if (token.kind != GTokenKindIdentifier) {
        [self addError:_S(@"Expecting variable name in GVarDecl, while we meet %@", token.value) pos:self.tokenizer.getLastPos];
        return nil;
    }
    NSString *varName = token.value;
    token = [self.tokenizer next];
    if (token.kind != GTokenKindColon &&
        token.kind != GTokenKindAssign &&
        token.kind != GTokenKindSemiColon) {
        [self addError:_S(@"GVarDecl error, value: %@", token.value) pos:self.tokenizer.getLastPos];
        return nil;
    }
    // 匹配冒号，说明有类型说明，解析typeAnnotation
    NSString *varType = @"Id";
    if (token.kind == GTokenKindColon) {
        token = [self.tokenizer peek];
        if (![token isTypeAnnotation]) {
            [self addError:_S(@"Error parsing type annotation in GVarDecl") pos:self.tokenizer.getLastPos];
            return nil;
        }
        varType = token.value;
        [self.tokenizer next];
    }
    
    // 匹配下一个token是否符合预期
    token = [self.tokenizer peek];
    if (token.kind != GTokenKindAssign &&
        token.kind != GTokenKindSemiColon) {
        [self addError:_S(@"Error parsing type assign in GVarDecl") pos:self.tokenizer.getLastPos];
        return nil;
    }
    
    // 匹配等号，解析初始化部分
    GExpr *expr = nil;
    token = [self.tokenizer peek];
    if (token.kind == GTokenKindAssign) {
        [self.tokenizer next];
        expr = [self parseExpression];
        [self.tokenizer next];
    }
    
    // 匹配下一个token是否符合预期
    token = [self.tokenizer peek];
    if (token.kind != GTokenKindSemiColon) {
        [self addError:_S(@"Error parsing type GTokenKindSemiColon in GVarDecl") pos:self.tokenizer.getLastPos];
        return nil;
    }
    
    // 匹配分号，结束
    if (token.kind == GTokenKindSemiColon) {
        [self.tokenizer next];
    }
    
    GVarDecl *decl = [[GVarDecl alloc] init];
    decl.beginPos = beginPos;
    decl.endPos = [self.tokenizer getLastPos];
    decl.declName = varName;
    decl.declType = nil;
    decl.inferredType = nil;
    decl.expr = expr;
    decl.symbol = nil;
    return decl;
}

- (GExpr *)parseExpression {
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
