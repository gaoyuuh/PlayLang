//
//  GType.m
//  GLang
//
//  Created by gaoyu on 2024/11/4.
//

#import "GType.h"

@implementation GType

- (BOOL)LE:(GType *)type2 {
    return NO;
}

- (BOOL)hasVoid {
    return NO;
}

+ (GType *)getUpperBound:(GType *)type1 type2:(GType *)type2 {
    if ([type1.name isEqualToString:GSysTypes.Any.name] ||
        [type2.name isEqualToString:GSysTypes.Any.name]) {
        return GSysTypes.Any;
    }
    if ([type1 LE:type2]) {
        return type2;
    }
    if ([type2 LE:type1]) {
        return type1;
    }
    GUnionType *type = [[GUnionType alloc] init];
    type.types = @[type1, type2];
    return type;
}

+ (BOOL)isSimpleType:(GType *)t {
    return [t isKindOfClass:GSimpleType.class];
}

+ (BOOL)isUnionType:(GType *)t {
    return [t isKindOfClass:GUnionType.class];
}

+ (BOOL)isFunctionType:(GType *)t {
    return [t isKindOfClass:GFunctionType.class];
}

@end


@implementation GSimpleType

- (BOOL)hasVoid {
    if ([self.name isEqualToString:GSysTypes.Void.name]) {
        return YES;
    }
    for (GType *type in self.upperTypes) {
        if ([type hasVoid]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)LE:(GType *)type2 {
    if ([type2.name isEqualToString:GSysTypes.Any.name]) {
        return YES;
    }
    if ([self.name isEqualToString:GSysTypes.Any.name]) {
        return NO;
    }
    if ([self.name isEqualToString:type2.name]) {
        return YES;
    }
    if ([GType isSimpleType:type2]) {
        if ([self.upperTypes indexOfObject:type2]) {
            return YES;
        } else {
            // 看看所有的父类型中，有没有一个是type2的子类型
            for (GType *type in self.upperTypes) {
                if ([type LE:type2]) {
                    return YES;
                }
            }
            return NO;
        }
    }
    if ([GType isUnionType:type2]) {
        if ([((GUnionType *)type2).types indexOfObject:self]) {
            return YES;
        } else { // 是联合类型中其中一个类型的子类型就行
            for (GType *type in ((GUnionType *)type2).types) {
                if ([self LE:type]) {
                    return YES;
                }
            }
            return NO;
        }
    }
    return NO;
}

@end


@implementation GFunctionType

- (BOOL)hasVoid {
    return [self.returnType hasVoid];
}

- (BOOL)LE:(GType *)type2 {
    if ([type2.name isEqualToString:GSysTypes.Any.name]) {
        return YES;
    }
    if ([self.name isEqualToString:type2.name]) {
        return YES;
    }
    if ([GType isUnionType:type2]) {
        if ([((GUnionType *)type2).types indexOfObject:self]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

@end


@implementation GUnionType

- (BOOL)hasVoid {
    for (GType *t in self.types) {
        if ([t hasVoid]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)LE:(GType *)type2 {
    if ([type2.name isEqualToString:GSysTypes.Any.name]) {
        return YES;
    }
    if ([GType isUnionType:type2]) {
        for (GType *t in self.types) {
            BOOL found = false;
            for (GType *t2 in ((GUnionType *)type2).types) {
                if ([t LE:t2]) {
                    found = YES;
                    break;
                }
            }
            if (!found) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end


@implementation GSysTypes

+ (GSimpleType *)Any {
    GSimpleType *type = [[GSimpleType alloc] init];
    type.name = @"Any";
    return type;
}

+ (GSimpleType *)Int {
    GSimpleType *type = [[GSimpleType alloc] init];
    type.name = @"Int";
    type.upperTypes = @[GSysTypes.Any];
    return type;
}

+ (GSimpleType *)Int64 {
    GSimpleType *type = [[GSimpleType alloc] init];
    type.name = @"Int64";
    type.upperTypes = @[GSysTypes.Any];
    return type;
}

+ (GSimpleType *)Float {
    GSimpleType *type = [[GSimpleType alloc] init];
    type.name = @"Float";
    type.upperTypes = @[GSysTypes.Any];
    return type;
}

+ (GSimpleType *)Boolean {
    GSimpleType *type = [[GSimpleType alloc] init];
    type.name = @"Bool";
    type.upperTypes = @[GSysTypes.Any];
    return type;
}

+ (GSimpleType *)String {
    GSimpleType *type = [[GSimpleType alloc] init];
    type.name = @"String";
    type.upperTypes = @[GSysTypes.Any];
    return type;
}

+ (GSimpleType *)Void {
    GSimpleType *type = [[GSimpleType alloc] init];
    type.name = @"Void";
    type.upperTypes = @[GSysTypes.Any];
    return type;
}

+ (BOOL)isSysType:(GType *)t {
    return ([t.name isEqualToString:GSysTypes.Any.name] ||
            [t.name isEqualToString:GSysTypes.Int.name] ||
            [t.name isEqualToString:GSysTypes.Int64.name] ||
            [t.name isEqualToString:GSysTypes.Float.name] ||
            [t.name isEqualToString:GSysTypes.Boolean.name] ||
            [t.name isEqualToString:GSysTypes.String.name] ||
            [t.name isEqualToString:GSysTypes.Void.name]);
}

@end
