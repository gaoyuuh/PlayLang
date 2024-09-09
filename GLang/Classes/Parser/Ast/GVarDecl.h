//
//  GVarDecl.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GDecl.h"
#import "GTypeNode.h"
#import "GExpr.h"

@interface GVarDecl : GDecl

@property (nonatomic, strong) GTypeNode * declType;
@property (nonatomic, strong) GExpr * expr;

@end
