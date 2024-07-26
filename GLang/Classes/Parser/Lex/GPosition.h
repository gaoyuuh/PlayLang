//
//  GPosition.h
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import <Foundation/Foundation.h>

@interface GPosition : NSObject

/// 行号
@property (nonatomic, assign) long line;
/// 列号
@property (nonatomic, assign) long column;
/// 开始字符
@property (nonatomic, assign) long begin;
/// 结束字符
@property (nonatomic, assign) long end;

@end
