//
//  GParseError.h
//  Pods
//
//  Created by gaoyu on 2024/9/19.
//

#import <Foundation/Foundation.h>
#import "GPosition.h"
#import "GNode.h"

@interface GParseError : NSObject

/// 错误信息
@property (nonatomic, strong) NSString * msg;
/// 是否是警告级别
@property (nonatomic, assign) BOOL isWarning;
/// 错误开始位置
@property (nonatomic, strong) GPosition * beginPos;
/// 关联node
@property (nonatomic, strong) GNode * node;

@end
