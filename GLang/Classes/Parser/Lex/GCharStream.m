//
//  GCharStream.m
//  GLang
//
//  Created by gaoyu on 2024/7/23.
//

#import "GCharStream.h"
#import "GPosition.h"

@interface GCharStream ()

@property (nonatomic, strong) NSString * code;
/// 行号
@property (nonatomic, assign) long line;
/// 列号
@property (nonatomic, assign) long column;
/// 位置
@property (nonatomic, assign) long pos;

@end

@implementation GCharStream

+ (instancetype)streamWithCode:(NSString *)code {
    GCharStream *stream = [[GCharStream alloc] init];
    stream.code = [code stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    stream.line = 1;
    stream.column = 0;
    stream.pos = 0;
    return stream;
}

/// 预读下一个字符，但不移动指针
- (unichar)peek {
    return [self.code characterAtIndex:self.pos];
}

/// 预读2个字符，但不移动指针
- (unichar)peek2 {
    return [self.code characterAtIndex:self.pos + 1];
}

- (NSString *)peekToCount:(int)count {
    if (self.pos + count >= self.code.length) {
        return nil;
    }
    NSString *str = [self.code substringWithRange:NSMakeRange(self.pos, count)];
    return str;
}

- (NSString *)subStringWithRange:(NSRange)range {
    if (range.location == NSNotFound || NSMaxRange(range) >= self.code.length) {
        return nil;
    }
    NSString *str = [self.code substringWithRange:range];
    return str;
}

/// 读取下一个字符，并且移动指针
- (unichar)next {
    unichar ch = [self.code characterAtIndex:self.pos++];
    if (ch == '\n') {
        self.line++;
        self.column = 0;
    } else {
        self.column++;
    }
    return ch;
}

/// 判断是否已经到了结尾
- (BOOL)eof {
    return self.pos > self.code.length - 1;
}

- (GPosition *)position {
    GPosition *pos = [[GPosition alloc] init];
    pos.begin = self.pos + 1;
    pos.end = self.pos + 1;
    pos.line = self.line;
    pos.column = self.column;
    return pos;
}

@end
