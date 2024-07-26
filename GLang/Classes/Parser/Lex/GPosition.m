//
//  GPosition.m
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import "GPosition.h"

@implementation GPosition

- (NSString *)description {
    return [NSString stringWithFormat:@"(ln: %ld, col: %ld, pos: %ld)", self.line, self.column, self.begin];
}

@end
