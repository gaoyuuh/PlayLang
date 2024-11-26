//
//  GNode.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import <Foundation/Foundation.h>
#import "GPosition.h"
@class GAstVisitor;

@interface GNode : NSObject

@property (nonatomic, strong) GPosition * beginPos;
@property (nonatomic, strong) GPosition * endPos;
@property (nonatomic, assign) BOOL isErrorNode;

- (id)accept:(GAstVisitor *)visitor;

@end
