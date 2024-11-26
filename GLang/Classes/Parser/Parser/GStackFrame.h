//
//  GStackFrame.h
//  GLang
//
//  Created by gaoyu on 2024/11/25.
//

#import <Foundation/Foundation.h>
@class GSymbol;

@interface GReturnValue : NSObject

@property (nonatomic, assign) int tag_ReturnValue;
@property (nonatomic, strong) id value;

+ (BOOL)isReturnValue:(id)v;

@end

@interface GStackFrame : NSObject

/// 存储变量的值
@property (nonatomic, strong) NSMapTable<GSymbol *, id> *values;
/// 返回值，当调用函数的时候，返回值放在这里
@property (nonatomic, strong) id retVal;

@end
