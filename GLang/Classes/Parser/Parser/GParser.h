//
//  GParser.h
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import <Foundation/Foundation.h>
@class GTokenizer;
@class GProgram;

@interface GParser : NSObject

@property (nonatomic, strong) GTokenizer * tokenizer;

- (GProgram *)parseProgram:(GTokenizer *)tokenizer;

@end
