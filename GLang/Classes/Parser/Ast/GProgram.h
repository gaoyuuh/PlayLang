//
//  GProgram.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GNode.h"
#import "GDecl.h"

@interface GProgram : GNode

@property (nonatomic, strong) NSArray<GDecl *> * decls;

@end
