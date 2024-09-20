//
//  GTokenizer.h
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import <Foundation/Foundation.h>
@class GToken;
@class GPosition;

@interface GTokenizer : NSObject

+ (NSArray<GToken *> *)lexWithCode:(NSString *)code;

+ (instancetype)tokenizerWithCode:(NSString *)code;

/// 预读当前的Token，但不移动当前位置
- (GToken *)peek;

/// 预读第二个Token
- (GToken *)peek2;

/// 返回当前的Token，并移向下一个Token
- (GToken *)next;

/// 获取接下来的Token的位置
- (GPosition *)getNextPos;

/// 获取前一个Token的position
- (GPosition *)getLastPos;

@end
