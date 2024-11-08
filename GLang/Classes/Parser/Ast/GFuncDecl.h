//
//  GFuncDecl.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GDecl.h"
#import "GScope.h"
#import "GBlock.h"
#import "GFuncSignature.h"

NS_ASSUME_NONNULL_BEGIN

@interface GFuncDecl : GDecl

@property (nonatomic, strong) GFuncSignature * signature;
@property (nonatomic, strong) GBlock * body;
@property (nonatomic, strong) GScope * scope;

@end

NS_ASSUME_NONNULL_END
