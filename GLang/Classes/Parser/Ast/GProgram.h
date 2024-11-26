//
//  GProgram.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GBlock.h"
@class GFunctionSymbol;
@class GScope;

@interface GProgram : GBlock

@property (nonatomic, strong) NSArray<GStatement *> * stmts;

@property (nonatomic, strong) GFunctionSymbol * sym;

@end
