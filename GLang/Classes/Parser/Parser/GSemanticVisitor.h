//
//  GSemanticVisitor.h
//  GLang
//
//  Created by gaoyu on 2024/11/22.
//

#import "GAstVisitor.h"
#import "GParseError.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSemanticVisitor : GAstVisitor

@property (nonatomic, strong) NSMutableArray<GParseError *> *errors;   // 语义错误
@property (nonatomic, strong) NSMutableArray<GParseError *> *warnings; // 语义报警信息

- (void)addError:(NSString *)msg node:(GNode *)node;
- (void)addWarning:(NSString *)msg node:(GNode *)node;

@end

NS_ASSUME_NONNULL_END
