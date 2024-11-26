//
//  GSemanticAnalyer.m
//  GLang
//
//  Created by gaoyu on 2024/11/22.
//

#import "GSemanticAnalyer.h"
#import "GSemanticVisitor.h"
#import "GEnterVisitor.h"
#import "GRefResolverVisitor.h"
#import "GLeftValueAttrVisitor.h"

@interface GSemanticAnalyer ()

@property (nonatomic, strong) NSArray<GSemanticVisitor *> * passes;

@end

@implementation GSemanticAnalyer

- (void)analyse:(GProgram *)program {
    for (GSemanticVisitor *pass in self.passes) {
        [pass visit:program];
    }
}

- (NSArray<GSemanticVisitor *> *)passes {
    if (!_passes) {
        _passes = @[
            [[GEnterVisitor alloc] init],
            [[GRefResolverVisitor alloc] init],
            [[GLeftValueAttrVisitor alloc] init],
        ];
    }
    return _passes;
}

@end
