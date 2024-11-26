//
//  GFuncParamDecl.m
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GFuncSignature.h"
#import "GAstVisitor.h"

@implementation GFuncParamsList

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitFuncParamList:self];
}

@end

@implementation GFuncSignature

- (id)accept:(GAstVisitor *)visitor {
    return [visitor visitFuncSignature:self];
}

@end
