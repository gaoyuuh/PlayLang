//
//  GType.h
//  GLang
//
//  Created by gaoyu on 2024/11/4.
//

#import <Foundation/Foundation.h>

@interface GType : NSObject

@property (nonatomic, strong) NSString * name;

/// 当前类型是否小于等于type2
- (BOOL)LE:(GType *)type2;

/// type1和type2的上界
+ (GType *)getUpperBound:(GType *)type1 type2:(GType *)type2;

+ (BOOL)isSimpleType:(GType *)t;
+ (BOOL)isUnionType:(GType *)t;
+ (BOOL)isFunctionType:(GType *)t;

@end


@interface GSimpleType : GType
@property (nonatomic, strong) NSArray<GType *> * upperTypes;
@end


@interface GFunctionType : GType
@property (nonatomic, strong) GType * returnType;
@property (nonatomic, strong) NSArray<GType *> * paramTypes;
@end


@interface GUnionType : GType
@property (nonatomic, strong) NSArray<GType *> * types;
@end


@interface GSysTypes : NSObject

// 所有类型的父类型
+ (GSimpleType *)Any;

// 基础类型
+ (GSimpleType *)Int;
+ (GSimpleType *)Int64;
+ (GSimpleType *)Float;
+ (GSimpleType *)Boolean;
+ (GSimpleType *)String;

+ (BOOL)isSysType:(GType *)t;

@end
