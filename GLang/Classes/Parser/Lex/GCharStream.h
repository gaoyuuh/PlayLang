//
//  GCharStream.h
//  GLang
//
//  Created by gaoyu on 2024/7/23.
//

#import <Foundation/Foundation.h>
@class GPosition;

@interface GCharStream : NSObject
/// 行号
@property (nonatomic, assign, readonly) long line;
/// 列号
@property (nonatomic, assign, readonly) long column;
/// 位置
@property (nonatomic, assign, readonly) long pos;

+ (instancetype)streamWithCode:(NSString *)code;

/// 预读下一个字符，但不移动指针
- (unichar)peek;
- (unichar)peek2;

/// 预读出对应count的字符串
- (NSString *)peekToCount:(int)count;
- (NSString *)subStringWithRange:(NSRange)range;

/// 读取下一个字符，并且移动指针
- (unichar)next;

/// 判断是否已经到了结尾
- (BOOL)eof;

/// position对象
- (GPosition *)position;

@end
