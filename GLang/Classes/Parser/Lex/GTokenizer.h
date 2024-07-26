//
//  GTokenizer.h
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import <Foundation/Foundation.h>
@class GToken;

@interface GTokenizer : NSObject

+ (NSArray<GToken *> *)lexWithCode:(NSString *)code;

@end
