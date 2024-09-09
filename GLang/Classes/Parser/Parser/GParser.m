//
//  GParser.m
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import "GParser.h"
#import "GTokenizer.h"
#import "GProgram.h"
#import "GToken.h"
#import "GExpr.h"
#import "GVarDecl.h"

@interface GParser ()

@end

@implementation GParser

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (GProgram *)parseProgram:(GTokenizer *)tokenizer {
    GProgram *program = [[GProgram alloc] init];
    program.beginPos = [tokenizer peek].position;
    program.endPos = [tokenizer getLastPos];
    program.decls = @[];
    return program;
}

- (NSArray<GNode *> *)parseExprList {
    NSMutableArray *aryExprs = [NSMutableArray array];
    GToken *token = [self.tokenizer peek];
    while (token.kind != GTokenKindEOF &&
           token.kind != GTokenKindRBrace) {
        GNode *node = [self parseExpr];
        if (!node) break;
        [aryExprs addObject:node];
        token = [self.tokenizer peek];
    }
    return aryExprs;
}

- (GNode *)parseExpr {
    GToken *token = [self.tokenizer peek];
    // 变量声明
    if (token.kind == GTokenKindVar ||
        token.kind == GTokenKindLet) {
        return [self parseVariableDecl];
    }
    return nil;
}

/// 解析变量声明
/// variableDecl: ( "var" | "let") identifier typeAnnotation? ("=" expression)?
/// typeAnnotation: ":" (Int | Int64 | Float | Bool | String | Array | Dict | Id)
- (GVarDecl *)parseVariableDecl {
    GPosition *beginPos = [self.tokenizer getNextPos];
    BOOL isErrorNode = NO;
    [self.tokenizer next];
    GToken *token = [self.tokenizer next];
    NSAssert1(token.kind == GTokenKindIdentifier, @"parseVariableDecl %@", token.position);
    if (token.kind == GTokenKindIdentifier) {
        NSString *varName = token.value;
        NSString *varType = @"Id";
        GExpr *expr = nil;
        BOOL isError = NO;
        
        // 类型
        GToken *t1 = [self.tokenizer peek];
        NSAssert1(t1.kind == GTokenKindColon, @"parseVariableDecl %@", t1.position);
        if (t1.kind == GTokenKindColon) {
            [self.tokenizer next];
            t1 = [self.tokenizer peek];
            NSAssert1([t1 isTypeAnnotation], @"parseVariableDecl %@", t1.position);
            varType = t1.value;
        }
        
        // 初始化
        t1 = [self.tokenizer peek];
        if (t1.kind == GTokenKindAssign) {
            [self.tokenizer next];
            expr = [self parseExpression];
        }
        
        GVarDecl *varDecl = [[GVarDecl alloc] init];
//        varDecl.declType = ;
        varDecl.expr = nil;
    }
    
    return nil;
}

- (GExpr *)parseExpression {
    return nil;
}

@end
