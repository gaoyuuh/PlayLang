//
//  GProgram.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GStatement.h"

@interface GProgram : GNode

@property (nonatomic, strong) NSArray<GStatement *> * stmts;

@end
