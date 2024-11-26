//
//  GSemanticAnalyer.h
//  GLang
//
//  Created by gaoyu on 2024/11/22.
//

#import <Foundation/Foundation.h>
#import "GProgram.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSemanticAnalyer : NSObject

- (void)analyse:(GProgram *)program;

@end

NS_ASSUME_NONNULL_END
