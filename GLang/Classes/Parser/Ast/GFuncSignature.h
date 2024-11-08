//
//  GFuncParamDecl.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import "GNode.h"
#import "GVarDecl.h"

@interface GFuncParamsList : GNode

@property (nonatomic, strong) NSArray<GVarDecl *> * params;

@end

@interface GFuncSignature : GNode

/// 参数列表
@property (nonatomic, strong) GFuncParamsList * paramList;
/// 返回值类型
@property (nonatomic, strong) GType * returnType;

@end
