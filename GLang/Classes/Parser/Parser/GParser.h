//
//  GParser.h
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import <Foundation/Foundation.h>
#import "GLexHeader.h"
#import "GAstHeader.h"
#import "GParseError.h"

@interface GParser : NSObject

@property (nonatomic, strong) GTokenizer * tokenizer;

- (GProgram *)parseProgram:(GTokenizer *)tokenizer;

/// 语法错误
@property (nonatomic, strong) NSMutableArray<GParseError *> * errors;
/// 语法警告
@property (nonatomic, strong) NSMutableArray<GParseError *> * warnings;

@end
