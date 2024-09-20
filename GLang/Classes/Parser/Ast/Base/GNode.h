//
//  GNode.h
//  GLang
//
//  Created by gaoyu on 2024/7/31.
//

#import <Foundation/Foundation.h>
#import "GPosition.h"

@interface GNode : NSObject

@property (nonatomic, strong) GPosition * beginPos;
@property (nonatomic, strong) GPosition * endPos;
@property (nonatomic, assign) BOOL isErrorNode;

@end
