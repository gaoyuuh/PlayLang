//
//  GBlock.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GStatement.h"

NS_ASSUME_NONNULL_BEGIN

@interface GBlock : GStatement

@property (nonatomic, strong) NSArray<GStatement *> * stmts;

@end

NS_ASSUME_NONNULL_END
