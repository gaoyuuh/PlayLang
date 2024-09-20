//
//  GVarStmt.h
//  Pods
//
//  Created by gaoyu on 2024/9/19.
//

#import "GStatement.h"
#import "GVarDecl.h"

@interface GVarStmt : GStatement

@property (nonatomic, strong) GVarDecl * varDecl;

@end
